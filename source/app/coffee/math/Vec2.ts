class Vec2 {
  constructor(private x: number = 0, private y: number = 0) {}

  // TODO: Is this supposed to be used?
  //   private _add(v1, v2) {
  //     return new Vec2(v1.x + v2.x, v1.y + v2.y);
  //   }

  private _subtract(v1, v2) {
    return new Vec2(v1.x - v2.x, v1.y - v2.y);
  }

  clone() {
    return new Vec2(this.x, this.y);
  }

  add(v2) {
    this.x += v2.x;
    this.y += v2.y;
    return this;
  }

  subtract(v2) {
    this.x -= v2.x;
    this.y -= v2.y;
    return this;
  }

  scale(value) {
    this.x *= value;
    this.y *= value;
    return this;
  }

  divide(value) {
    this.x /= value;
    this.y /= value;
    return this;
  }

  copy(v2) {
    this.x = v2.x;
    this.y = v2.y;
    return this;
  }

  set(_at_x, _at_y) {
    this.x = _at_x;
    this.y = _at_y;
    return this;
  }

  invert() {
    this.x = -this.x;
    this.y = -this.y;
    return this;
  }

  dot(v) {
    return this.x * v.x + this.y * v.y;
  }

  rotate(theta) {
    var co, si, xx;
    co = Math.cos(theta);
    si = Math.sin(theta);
    xx = co * this.x - si * this.y;
    this.y = si * this.x + co * this.y;
    this.x = xx;
    return this;
  }

  angle() {
    return Math.atan2(this.y, this.x);
  }

  angleBetween(v) {
    var aa, vv;
    vv = v.clone();
    aa = this.clone();
    vv.normalize();
    aa.normalize();
    return Math.acos(aa.dot(vv));
  }

  length() {
    return Math.sqrt(this.x * this.x + this.y * this.y);
  }

  abs() {
    this.x = Math.abs(this.x);
    this.y = Math.abs(this.y);
    return this;
  }

  clamp(min, max) {
    if (this.x > max) {
      this.x = max;
    } else if (this.x < min) {
      this.x = min;
    }
    if (this.y > max) {
      this.y = max;
    } else if (this.y < min) {
      this.y = min;
    }
    return this;
  }

  normalize() {
    const len = this.length();
    if (len !== 0) {
      this.x = this.x / len;
      this.y = this.y / len;
    }
    return this;
  }

  interpolateTo(v2, easing) {
    const diff = this._subtract(v2, this);
    diff.scale(easing);
    this.add(diff);
    return this;
  }
}

export default Vec2;
