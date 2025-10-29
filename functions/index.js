import { https, logger } from "firebase-functions";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";

initializeApp();

const db = getFirestore();
const messaging = getMessaging();

export const notifyFamily = https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new https.HttpsError('unauthenticated', 'Usuário não autenticado');
  }
  const { petId, message } = data;
  if (!petId || !message) {
    throw new https.HttpsError('invalid-argument', 'petId e message são obrigatórios');
  }

  try {
    const petDoc = await db.collection('pets').doc(petId).get();
    if (!petDoc.exists) {
      throw new https.HttpsError('not-found', 'Pet não encontrado');
    }

    const familyCode = petDoc.data()?.familyCode;
    if (!familyCode) {
      throw new https.HttpsError('failed-precondition', 'familyCode do pet não está definido');
    }

    const usersSnap = await db.collection('users')
      .where('familyCode', '==', familyCode)
      .get();

    const tokens = [];
    usersSnap.forEach(userDoc => {
      const fcmTokens = userDoc.data().fcmTokens || [];
      tokens.push(...fcmTokens);
    });

    if (tokens.length === 0) {
      return { success: false, message: "Nenhum token de dispositivo encontrado para notificação." };
    }

    const notificationPayload = {
      notification: {
        title: "PetKeeper Família",
        body: message,
      },
      tokens: tokens,
    };

    const response = await messaging.sendMulticast(notificationPayload);
    logger.info(`Notificação enviada para ${response.successCount} dispositivos.`);
    return { success: true, results: response.successCount };
  } catch (error) {
    logger.error("Erro ao notificar a família:", error);
    throw new https.HttpsError('internal', 'Erro ao enviar notificação');
  }
});
