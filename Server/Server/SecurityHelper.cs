using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;

namespace Server
{
    class SecurityHelper
    {
        public static string GenerateSaltedHash(string _password, string _salt)
        {
            HashAlgorithm algorithm = SHA512.Create();

            byte[] plainText = System.Text.Encoding.UTF8.GetBytes(_password);
            byte[] salt = System.Text.Encoding.UTF8.GetBytes(_salt);

            byte[] plainTextWithSaltBytes =
              new byte[plainText.Length + salt.Length];

            for (int i = 0; i < plainText.Length; i++)
            {
                plainTextWithSaltBytes[i] = plainText[i];
            }
            for (int i = 0; i < salt.Length; i++)
            {
                plainTextWithSaltBytes[plainText.Length + i] = salt[i];
            }

            byte[] result = algorithm.ComputeHash(plainTextWithSaltBytes);

            string hashed_passwd = Convert.ToBase64String(result);

            return hashed_passwd;
        }

        public static string GenerateSalt(int nSalt = 12)
        {
            var saltBytes = new byte[nSalt];

            var provider = new RNGCryptoServiceProvider();
            
            provider.GetNonZeroBytes(saltBytes);
            

            return Convert.ToBase64String(saltBytes);
        }
    }
}
