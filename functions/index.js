const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "intrezo.jobs@gmail.com",
    pass: "wulcmgcohlgqcwij", // пароль приложения
  },
});

exports.notifyOnNewApplication = functions.firestore
  .document("applications/{applicationId}")
  .onCreate(async (snap, context) => {
    const application = snap.data();

    const linkToSheets = "https://docs.google.com/spreadsheets/d/1dURY92sRXBGz9nrWeTYliO7p_OCQmf4IauKhGrEKoO4/edit#gid=334295389";

    const mailOptions = {
      from: "intrezo.jobs@gmail.com",
      to: "intrezo.jobs@gmail.com",
      subject: "Новая заявка",

      text: `Пользователь подал заявку на вакансию.\n\nСсылка: ${linkToSheets}`,

      html: `
        <div style="font-family: Roboto, sans-serif; font-size: 16px; color: #001730;">
          <p>Пользователь подал заявку на вакансию.</p>
          <p>
            <a href="${linkToSheets}" target="_blank"
               style="
                 display: inline-block;
                 background-color: #001730;
                 color: #ffffff;
                 padding: 10px 20px;
                 text-decoration: none;
                 border-radius: 6px;
                 font-weight: bold;
               ">
              Открыть таблицу
            </a>
          </p>
        </div>
      `,
    };

    try {
      await transporter.sendMail(mailOptions);
      console.log("✅ Email отправлен успешно!");
    } catch (error) {
      console.error("❌ Ошибка при отправке email:", error);
    }
  });