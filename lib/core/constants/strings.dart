// ignore_for_file: constant_identifier_names

//* Cache Keys

const String USER_KEY = "AF4210LIJ2KBN509";

//* Routes
const String BASE_URL_ANDROID = "http://10.0.2.2:8000/api";

//! Auth routes

const String SIGNUP_LINK = "$BASE_URL_ANDROID/register";
const String LOGIN_LINK = "$BASE_URL_ANDROID/login";
const String LOGOUT_LINK = "$BASE_URL_ANDROID/logout";

//! User routes

const String UPDATE_PROFILE_LINK = "$BASE_URL_ANDROID/profile";
const String CHANGE_LANG_LINK = "$BASE_URL_ANDROID/language";

//! Order routes

//* product
const String PRODUCTS_LINK = "$BASE_URL_ANDROID/products";
const String TOP_DEMAND_PRODUCTS_LINK = "$PRODUCTS_LINK/most-ordered";
const String LATEST_PRODUCTS_LINK = "$PRODUCTS_LINK/latest";
const String ORDER_LINK = "$BASE_URL_ANDROID/order";
const String FAV_LINK = "$BASE_URL_ANDROID/favorite";
const String ORDER_FAV_LINK = "$FAV_LINK/order";
const String CANCEL_ORDER_LINK = "$BASE_URL_ANDROID/cancel-order";
const String CART_LINK = "$BASE_URL_ANDROID/cart";
const String ORDER_CART_LINK = "$BASE_URL_ANDROID/add-to-order";

const String DRIVER_ORDERS_LINK = "$BASE_URL_ANDROID/driver-orders";
//* store
const String STORE_LINK = "$BASE_URL_ANDROID/stores";

//! Order Status
const String pending = 'pending';
const String delivering = 'delivering';
const String delivered = 'delivered';
const String canceled = 'canceled';
