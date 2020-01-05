/* eslint-disable no-console */

export const developerWarn = (message) => {
  if (process.env.NODE_ENV === "development" || process.env.NODE_ENV === "test") {
    console.warn(message);
  }
};