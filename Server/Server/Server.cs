using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Net;
using System.Threading;
using System.Net.Sockets;
using Utilities;

namespace Server
{
    class Server
    { 
        private static Message Return_Code_Register(List<string> Elements)
        {
            // here we have to implement database logic ...
            string FirstName = Elements[1];
            string LastName = Elements[2];
            string email = Elements[3];
            string cnp = Elements[4];
            string age = Elements[5];
            string username = Elements[6];
            string password = Elements[7];

            int response = DatabaseManager.Register(FirstName, LastName, email, cnp, age, username, password);

            return new Message(response);


        }

        private static Message Return_Code_Login(List<string> Elements)
        {
            // here we have to implement database logic ...
            string username = Elements[1];
            string password = Elements[2];
            

            Message response = DatabaseManager.Login(username, password);

            return response;


        }

        private static Message Return_Code_ChangePassword(List<string> Elements)
        {
            // here we have to implement database logic ...
            string clientID = Elements[1];
            string password = Elements[2];
            string oldPassword = Elements[3];


            int response = DatabaseManager.ChangePassword(clientID, password, oldPassword);

            return new Message(response);

        }

        private static Message Return_Code_ViewProfile(List<string> Elements)
        {
            // here we have to implement database logic ...
            string clientID = Elements[1];


            Message response = DatabaseManager.SendPersonalInfo(clientID);

            return response;

        }
        private static Message Return_Code_Destinations(List<string> Elements)
        {
         
            Message response = DatabaseManager.Destinations();

            return response;

        }

        private static Message Return_Code_Departures(List<string> Elements)
        {

            Message response = DatabaseManager.Departures();

            return response;

        }
        private static Message Return_Code_Available(List<string> Elements)
        {

            string destination=Elements[1];
            string departure=Elements[2];
            string data=Elements[3];

            Message response = DatabaseManager.Available_Flights(destination, departure,data);

            return response;

        }
        private static Message Return_Code_BookFlight(List<string> Elements)
        {

            string destination = Elements[1];
            string departure = Elements[2];
            string data = Elements[3];
            string clientID = Elements[4];

            Message response = DatabaseManager.Book_Flight(destination, departure, data,clientID);

            return response;

        }

        private static Message Return_Code_Book2WayTicket(List<string> Elements)
        {
            string destination = Elements[1];
            string departure = Elements[2];
            string data_dus = Elements[3];
            string data_intors = Elements[4];
            string clientID = Elements[5];

            Message response = DatabaseManager.Book_2Way_Flight(destination, departure, data_dus, data_intors, clientID);

            return response;
        }

        private static Message Return_Code_FutureFlights(List<string> Elements)
        {

            string clientID = Elements[1];

            Message response = DatabaseManager.Future_Flights(clientID);

            return response;

        }
        private static Message Return_Code_PastFlights(List<string> Elements)
        {

            string clientID = Elements[1];

            Message response = DatabaseManager.Past_Flights(clientID);

            return response;

        }
        private static void ProcessClientRequest(object argument)
        {
            TcpClient client = (TcpClient)argument;
            
            try
            {
                StreamReader reader = new StreamReader(client.GetStream());
                StreamWriter writer = new StreamWriter(client.GetStream());
                string s = String.Empty;
                s = reader.ReadLine();
                while (s != null)
                {
                    Message received = new Message(s);
                    List<string> elements = received.GetElementsOfMessage();
                    // Console.WriteLine("From client : " + obj.GetTheMessage());
                    // writer.WriteLine("From server : " + obj.GetTheMessage());

                    string request_from_client = received.GetRequest().ToString();

                    Message ret;

                    switch(request_from_client)
                    {
                        case Utility._REGISTER_REQUEST:
                            ret = Return_Code_Register(elements);
                            break;
                        case Utility._LOGIN_REQUEST:
                            ret = Return_Code_Login(elements);
                            break;
                        case Utility._CHANGE_PASS_REQUEST:
                            ret = Return_Code_ChangePassword(elements);
                            break;
                        case Utility._VIEW_PROFILE_REQUEST:
                            ret = Return_Code_ViewProfile(elements);
                            break;
                        case Utility._DESTINATION_REQUEST:
                            ret = Return_Code_Destinations(elements);
                            break;
                        case Utility._DEPARTURE_REQUEST:
                            ret = Return_Code_Departures(elements);
                            break;
                        case Utility._AVAILABLE_FLIGHT_REQUEST:
                            ret = Return_Code_Available(elements);
                            break;
                        case Utility._BOOK_FLIGHT_REQUEST:
                            ret = Return_Code_BookFlight(elements);
                            break;
                        case Utility._FUTURE_FLIGHTS_REQUEST:
                            ret = Return_Code_FutureFlights(elements);
                            break;
                        case Utility._PAST_FLIGHTS_REQUEST:
                            ret = Return_Code_PastFlights(elements);
                            break;
                        case Utility._BOOK_2WAY_FLIGHT_REQUEST:
                            ret = Return_Code_Book2WayTicket(elements);
                            break;
                        default: 
                            ret = new Message(Utility._INVALID_CODE);
                            break;

                    }

                    writer.WriteLine(ret.GetTheMessage());
                    //Console.WriteLine(ret.GetRequest());
                    writer.Flush();

                    s = reader.ReadLine();
                }

                reader.Close();
                writer.Close();
                client.Close();
                Console.WriteLine("[-] Closing client connection...");
            }catch(IOException)
            {
                Console.WriteLine("[-] Client communication failed. Exiting thread...");
            }
        }
        static void Main(string[] args)
        {
             
             TcpListener listener = null;
             
            
             string connection_str = "Server=.;Database=AirlineReservationSystem;Trusted_Connection=true";
             DatabaseConnection.connectDatabase(connection_str);
             
             
             try
             {
                 listener = new TcpListener(IPAddress.Any, 1080);
                 listener.Start();
                 Console.WriteLine("[+] Server started...");
                 while (true)
                 {
                     Console.WriteLine("[+] Waiting for incoming client request...");
                     TcpClient client = listener.AcceptTcpClient();
                     Console.WriteLine("[+] Accepted new client connection...");
                     Thread thread = new Thread(ProcessClientRequest);
                     thread.Start(client);
                 }

             }catch(Exception e)
             {
                 Console.WriteLine(e);
             }

            DatabaseConnection.closeConnection();
            
            
            /*Message obj = new Message(Int32.Parse(Utility._REGISTER_REQUEST));
            string username = "Andrei";
            string password = "Password";
            string email = "andrei@gmail.com";
            obj.Add(username);
            obj.Add(password);
            obj.Add(email);
            obj.Add("Salutare");
            obj.AddEndOfMessage();

            List<string> messageList = new List<string>();
            messageList = obj.GetElementsOfMessage();

            Console.WriteLine(obj.GetTheMessage());

            foreach(string item in messageList)
            {
                Console.WriteLine(item);
            }

            //Console.WriteLine(obj.GetTheMessage());

            Message newMessage = new Message(obj.GetTheMessage());
            Console.WriteLine(newMessage.GetRequest());
            Console.WriteLine(newMessage.isEnded());
            Console.WriteLine(newMessage.GetTheMessage());

            Console.ReadLine();*/
            
        }
    }
}
