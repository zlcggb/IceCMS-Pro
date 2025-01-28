export function formatDate(dateString: string): string {
  if (!dateString) {
    throw new Error("Invalid date string");
  }

  const date = new Date(dateString);

  if (isNaN(date.getTime())) {
    throw new Error("Invalid date format");
  }

  const year = date.getFullYear();
  const month = date.getMonth() + 1; // 月份从 0 开始，需要加 1
  const day = date.getDate();

  return `${year}年${month}月${day}日`;
}

function padLeftZero(str) {
  return ("00" + str).substr(str.length);
}


// Get the day of the week (0–6) from an ISO date string
export function GetWeekdate(isoDateString) {
  const dateObject = new Date(isoDateString);
  if (isNaN(dateObject.getTime())) {
    throw new Error("Invalid date string");
  }
  return dateObject.getDay(); // 0 = Sunday, 6 = Saturday
}
