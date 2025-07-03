let Hooks = {};

let hangmanState = {
  init: 0,
  ctx: null,
  canvas: null,
  steps: [],
};

Hooks.HangmanHook = {
  mounted() {
    hangmanState.ctx = this.el.getContext("2d");
    hangmanState.canvas = this.el;
    hangmanState.init = this.el.dataset.step;

    this.drawInitial();
    // handle event dari server
    this.handleEvent("hang", () => {
      hangmanState.steps = [];
      this.drawInitial();
    });
  },
  updated() {
    this.drawInitial();
    let step = parseInt(this.el.dataset.step);
    let prev = parseInt(hangmanState.init);
    hangmanState.steps.push(prev - step);
    this.drawHangmanPart();
  },
  drawInitial() {
    hangmanState.ctx.clearRect(0, 0, this.el.width, this.el.height);
    hangmanState.ctx.fillStyle = "#FFF9C4";
    hangmanState.ctx.fillRect(0, 0, this.el.width, this.el.height);
    this.drawGallows();
  },

  drawGallows() {
    hangmanState.ctx.strokeStyle = "#000";
    hangmanState.ctx.lineWidth = 4;

    // Base
    hangmanState.ctx.beginPath();
    hangmanState.ctx.moveTo(50, 280);
    hangmanState.ctx.lineTo(200, 280);
    hangmanState.ctx.stroke();

    // Pole
    hangmanState.ctx.beginPath();
    hangmanState.ctx.moveTo(100, 280);
    hangmanState.ctx.lineTo(100, 50);
    hangmanState.ctx.stroke();

    // Top
    hangmanState.ctx.beginPath();
    hangmanState.ctx.moveTo(100, 50);
    hangmanState.ctx.lineTo(180, 50);
    hangmanState.ctx.stroke();

    // Rope
    hangmanState.ctx.beginPath();
    hangmanState.ctx.moveTo(180, 50);
    hangmanState.ctx.lineTo(180, 80);
    hangmanState.ctx.stroke();
  },

  drawHangmanPart() {
    hangmanState.ctx.strokeStyle = "#000";
    hangmanState.ctx.lineWidth = 4;

    for (let v of hangmanState.steps) {
      switch (v) {
        case 1: // Head
          hangmanState.ctx.beginPath();
          hangmanState.ctx.arc(180, 100, 20, 0, Math.PI * 2);
          hangmanState.ctx.stroke();
          break;
        case 2: // Body
          hangmanState.ctx.beginPath();
          hangmanState.ctx.moveTo(180, 120);
          hangmanState.ctx.lineTo(180, 180);
          hangmanState.ctx.stroke();
          break;
        case 3: // Left arm
          hangmanState.ctx.beginPath();
          hangmanState.ctx.moveTo(180, 130);
          hangmanState.ctx.lineTo(150, 150);
          hangmanState.ctx.stroke();
          break;
        case 4: // Right arm
          hangmanState.ctx.beginPath();
          hangmanState.ctx.moveTo(180, 130);
          hangmanState.ctx.lineTo(210, 150);
          hangmanState.ctx.stroke();
          break;
        case 5: // Left leg
          hangmanState.ctx.beginPath();
          hangmanState.ctx.moveTo(180, 180);
          hangmanState.ctx.lineTo(160, 220);
          hangmanState.ctx.stroke();
          break;
        case 6: // Right leg
          hangmanState.ctx.beginPath();
          hangmanState.ctx.moveTo(180, 180);
          hangmanState.ctx.lineTo(200, 220);
          hangmanState.ctx.stroke();
          break;
      }
    }
  },
};

export default Hooks;
