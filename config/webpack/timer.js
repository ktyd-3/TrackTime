"use strict";

{
  const start = document.getElementById("js-start");
  const stop = document.getElementById("js-stop");
  const reset = document.getElementById("js-reset");
  const comment = document.getElementById("js-comment");
  const countTimer = document.getElementById("js-count-timer");
  const restPopup = document.getElementById("js-rest-popup");
  const rest = document.getElementById("js-rest-btn");
  const finish = document.getElementById("js-finish-btn");
  const restartPopup = document.getElementById("js-restart-popup");
  const restart = document.getElementById("js-restart-btn");
  const audio = document.getElementById("js-audio");

  let startTime;
  // 作業時間を設定する
  let timeLimit = 1;
  let timeoutId;
  let elapsedTime = 0;
  let num = 0;

  // タイマーを画面に書き出す処理
  function updateTimer(t) {
    const d = new Date(t);
    const m = String(d.getMinutes()).padStart(2, "0");
    const s = String(d.getSeconds()).padStart(2, "0");
    countTimer.textContent = `${m}:${s}`;
  }

  // タイマーのカウントダウンの処理
  function countDown() {
    const runningTime =
      timeLimit * 60 * 1000 - elapsedTime - (Date.now() - startTime);

    // 59秒前にアラーム
    const remainingTime = Math.floor(runningTime / 1000);
    if (remainingTime === 59) {
      audio.play();
    }

    if (runningTime < 0) {
      clearTimeout(timeoutId);
      initButtonState();
      elapsedTime = 0;
      audio.play();
      switch (timeLimit) {
        case 5:
          restartPopup.classList.add("show");
          break;
        case 1:
          calcTime();
          restPopup.classList.add("show");
          break;
      }
      return;
    }
    updateTimer(runningTime);

    timeoutId = setTimeout(() => {
      countDown();
    }, 100);
  }

  // ボタンを押したら音を止める処理
  function stoppedSound() {
    audio.pause();
    audio.currentTime = 0;
  }

  // 最初のボタンの状態
  function initButtonState() {
    start.disabled = false;
    stop.disabled = true;
    reset.disabled = true;
    start.style.opacity = 1;
    stop.style.opacity = 0.4;
    reset.style.opacity = 0.4;
  }

  // カウント中のボタンの状態
  function setButtonStateRunning() {
    start.disabled = true;
    stop.disabled = false;
    reset.disabled = true;
    start.style.opacity = 0.4;
    stop.style.opacity = 1;
    reset.style.opacity = 0.4;
  }

  // カウントダウンが止まっている時のボタンの状態
  function setButtonStateStopped() {
    start.disabled = false;
    stop.disabled = true;
    reset.disabled = false;
    start.style.opacity = 1;
    stop.style.opacity = 0.4;
    reset.style.opacity = 1;
  }

  initButtonState();

  // Startボタンを押した時の処理
  start.addEventListener("click", () => {
    setButtonStateRunning();
    startTime = Date.now();
    countDown();
    comment.textContent = "作業中";
  });

  // Stopボタンを押した時の処理
  stop.addEventListener("click", () => {
    clearTimeout(timeoutId);
    setButtonStateStopped();
    elapsedTime += Date.now() - startTime;
    comment.textContent = "Stop";
  });

  // Resetボタンを押した時の処理
  reset.addEventListener("click", () => {
    initButtonState();
    elapsedTime = 0;
    num = 0;
    timeLimit = 1;
    countTimer.textContent = `${timeLimit}:00`;
    comment.textContent = "Click Start";
  });

  // 休憩するボタンを押した時の処理
  rest.addEventListener("click", () => {
    restPopup.classList.remove("show");
    stoppedSound();
    timeLimit = 5;
    countTimer.textContent = `${timeLimit}:00`;
    start.click();
    comment.textContent = "Rest Time";
  });

  // 終了するボタンを押した時の処理
  finish.addEventListener("click", () => {
    restPopup.classList.remove("show");
    stoppedSound();
    num = 0;
    countTimer.textContent = `${timeLimit}:00`;
    comment.textContent = "Click Start";
  });

  // 再開するボタンを押した時の処理
  restart.addEventListener("click", () => {
    restartPopup.classList.remove("show");
    stoppedSound();
    timeLimit = 1;
    countTimer.textContent = `${timeLimit}:00`;
    start.click();
    comment.textContent = "作業中";
  });
}
