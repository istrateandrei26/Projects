using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    
    public class Utility
    {

        public static string _MESSAGE_SEPARATOR = "!@#$%^&*";
        public static string _END_OF_MESSAGE = "&&&&";

        //requests:
        public const string _REGISTER_REQUEST = "0";
        public const string _LOGIN_REQUEST = "1";
        public const string _CHANGE_PASS_REQUEST = "2";
        public const string _VIEW_PROFILE_REQUEST = "3";
        public const string _BOOK_FLIGHT_REQUEST = "4";
        public const string _DESTINATION_REQUEST = "5";
        public const string _DEPARTURE_REQUEST = "6";
        public const string _AVAILABLE_FLIGHT_REQUEST = "7";
        public const string _FUTURE_FLIGHTS_REQUEST = "8";
        public const string _PAST_FLIGHTS_REQUEST = "9";
        public const string _BOOK_2WAY_FLIGHT_REQUEST = "10";

        //return codes success:
        public static string _REGISTER_SUCCES = "100";
        public static string _LOGIN_SUCCES = "101";
        public const string _CHANGE_PASS_SUCCESS = "102";
        public const string _VIEW_PROFILE_SUCCESS = "103";
        public const string _BOOK_FLIGHT_SUCCESS = "104";
        public const string _DESTINATION_SUCCESS = "105";
        public const string _DEPARTURE_SUCCESS = "106";
        public const string _AVAILABLE_FLIGHT_SUCCESS = "107";
        public const string _FUTURE_FLIGHTS_SUCCESS = "108";
        public const string _PAST_FLIGHTS_SUCCESS = "109";
        public const string _BOOK_2WAY_FLIGHT_SUCCESS = "110";

        //return codes failed:
        public static string _REGISTER_FAILED = "1000";
        public static string _LOGIN_FAILED = "1001";
        public const string _CHANGE_PASS_FAILED = "1002";
        public const string _VIEW_PROFILE_FAILED = "1003";
        public const string _BOOK_FLIGHT_FAILED = "1004";
        public const string _DESTINATION_FAILED = "1005";
        public const string _DEPARTURE_FAILED = "1006";
        public const string _AVAILABLE_FLIGHT_FAILED = "1007";
        public const string _FUTURE_FLIGHTS_FAILED = "1008";
        public const string _PAST_FLIGHTS_FAILED = "1009";
        public const string _BOOK_2WAY_FLIGHT_FAILED = "1010";


        //internal error messages:
        public static string _INVALID_CODE = "401";

    }
}
