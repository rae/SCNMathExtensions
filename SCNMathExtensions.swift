// SCNMathExtensions
// @copyright: Slipp Douglas Thompson
// @copyright date: The date(s) of version control check-ins corresponding to this file and this project as a whole; or in lieu of, no earlier than July 2016.

import SceneKit

import simd



// MARK: Type Conversions

extension SCNVector3 {
	public func toSimd() -> float3 {
		return SCNVector3ToFloat3(self)
	}
	public func toGLK() -> GLKVector3 {
		return SCNVector3ToGLKVector3(self)
	}
}
extension float3 {
	public func toSCN() -> SCNVector3 {
		return SCNVector3FromFloat3(self)
	}
}
extension GLKVector3 {
	public func toSCN() -> SCNVector3 {
		return SCNVector3FromGLKVector3(self)
	}
}

extension SCNQuaternion {
	public var q:(Float,Float,Float,Float) {
		return (self.x, self.y, self.z, self.w)
	}
	public init(q:(Float,Float,Float,Float)) {
		self.init(x: q.0, y: q.1, z: q.2, w: q.3)
	}
	
	public func toGLK() -> GLKQuaternion {
		return GLKQuaternion(q: self.q)
	}
}
extension GLKQuaternion {
	public func toSCN() -> SCNQuaternion {
		return SCNQuaternion(q: self.q)
	}
}

extension SCNMatrix4 {
	public func toSimd() -> float4x4 {
		return float4x4(SCNMatrix4ToMat4(self))
	}
	public func toGLK() -> GLKMatrix4 {
		return SCNMatrix4ToGLKMatrix4(self)
	}
}
extension float4x4 {
	public func toSCN() -> SCNMatrix4 {
		return SCNMatrix4FromMat4(self.cmatrix)
	}
}
extension GLKMatrix4 {
	public func toSCN() -> SCNMatrix4 {
		return SCNMatrix4FromGLKMatrix4(self)
	}
}




// MARK: SCNVector3 Extensions

extension SCNVector3
{
	public static let zero = SCNVector3Zero
	
	public static func + (a:SCNVector3, b:SCNVector3) -> SCNVector3 { return a.added(to: b) }
	public func added(to other:SCNVector3) -> SCNVector3 {
		return (self.toSimd() + other.toSimd()).toSCN()
	}
	public static func += (v:inout SCNVector3, o:SCNVector3) { v.add(o) }
	public mutating func add(_ other:SCNVector3) {
		self = self.added(to: other)
	}
	
	public func crossProduct(_ other:SCNVector3) -> SCNVector3 {
		return simd.cross(self.toSimd(), other.toSimd()).toSCN()
	}
	public mutating func formCrossProduct(_ other:SCNVector3) {
		self = self.crossProduct(other)
	}
	
	public static func / (a:SCNVector3, b:SCNVector3) -> SCNVector3 { return a.divided(by: b) }
	public func divided(by other:SCNVector3) -> SCNVector3 {
		return (self.toSimd() / other.toSimd()).toSCN()
	}
	public static func / (a:SCNVector3, b:Float) -> SCNVector3 { return a.divided(by: b) }
	public func divided(by scalar:Float) -> SCNVector3 {
		return (self.toSimd() * recip(scalar)).toSCN()
	}
	public static func /= (v:inout SCNVector3, o:SCNVector3) { v.divide(by: o) }
	public mutating func divide(by other:SCNVector3) {
		self = self.divided(by: other)
	}
	public static func /= (v:inout SCNVector3, o:Float) { v.divide(by: o) }
	public mutating func divide(by scalar:Float) {
		self = self.divided(by: scalar)
	}
	
	public func dotProduct(_ other:SCNVector3) -> Float {
		return simd.dot(self.toSimd(), other.toSimd())
	}
	
	public var isFinite:Bool {
		return self.x.isFinite && self.y.isFinite && self.z.isFinite
	}
	public var isInfinite:Bool {
		return self.x.isInfinite || self.y.isInfinite || self.z.isInfinite
	}
	public var isNaN:Bool {
		return self.x.isNaN || self.y.isNaN || self.z.isNaN
	}
	public var isZero:Bool {
		return self.x.isZero && self.y.isZero && self.z.isZero
	}
	
	public func magnitude() -> Float {
		return simd.length(self.toSimd())
	}
	public func magnitudeSquared() -> Float {
		return simd.length_squared(self.toSimd())
	}
	
	public func mixed(with other:SCNVector3, ratio:Float) -> SCNVector3 {
		return simd.mix(self.toSimd(), other.toSimd(), t: ratio).toSCN()
	}
	public mutating func mix(with other:SCNVector3, ratio:Float) {
		self = self.mixed(with: other, ratio: ratio)
	}
	
	public static func * (a:SCNVector3, b:SCNVector3) -> SCNVector3 { return a.multiplied(by: b) }
	public func multiplied(by other:SCNVector3) -> SCNVector3 {
		return (self.toSimd() * other.toSimd()).toSCN()
	}
	public static func * (a:SCNVector3, b:Float) -> SCNVector3 { return a.multiplied(by: b) }
	public func multiplied(by scalar:Float) -> SCNVector3 {
		return (self.toSimd() * scalar).toSCN()
	}
	public static func *= (v:inout SCNVector3, o:SCNVector3) { v.multiply(by: o) }
	public mutating func multiply(by other:SCNVector3) {
		self = self.multiplied(by: other)
	}
	public static func *= (v:inout SCNVector3, o:Float) { v.multiply(by: o) }
	public mutating func multiply(by scalar:Float) {
		self = self.multiplied(by: scalar)
	}
	
	public static prefix func - (v:SCNVector3) -> SCNVector3 { return v.inverted() }
	public func inverted() -> SCNVector3 {
		return (float3(0) - self.toSimd()).toSCN()
	}
	public mutating func invert() {
		self = self.inverted()
	}
	
	public func normalized() -> SCNVector3 {
		return simd.normalize(self.toSimd()).toSCN()
	}
	public mutating func normalize() {
		self = self.normalized()
	}
	
	public func projected(onto other:SCNVector3) -> SCNVector3 {
		return simd.project(self.toSimd(), other.toSimd()).toSCN()
	}
	public mutating func project(onto other:SCNVector3) {
		self = self.projected(onto: other)
	}
	
	public func reflected(normal:SCNVector3) -> SCNVector3 {
		return simd.reflect(self.toSimd(), n: normal.toSimd()).toSCN()
	}
	public mutating func reflect(normal:SCNVector3) {
		self = self.reflected(normal: normal)
	}
	
	public func refracted(normal:SCNVector3, refractiveIndex:Float) -> SCNVector3 {
		return simd.refract(self.toSimd(), n: normal.toSimd(), eta: refractiveIndex).toSCN()
	}
	public mutating func refract(normal:SCNVector3, refractiveIndex:Float) {
		self = self.refracted(normal: normal, refractiveIndex: refractiveIndex)
	}
	
	public mutating func replace(x:Float?=nil, y:Float?=nil, z:Float?=nil) {
		if let xValue = x { self.x = xValue }
		if let yValue = y { self.y = yValue }
		if let zValue = z { self.z = zValue }
	}
	public func replacing(x:Float?=nil, y:Float?=nil, z:Float?=nil) -> SCNVector3 {
		return SCNVector3(
			x ?? self.x,
			y ?? self.y,
			z ?? self.z
		)
	}
	
	public static func - (a:SCNVector3, b:SCNVector3) -> SCNVector3 { return a.subtracted(by: b) }
	public func subtracted(by other:SCNVector3) -> SCNVector3 {
		return (self.toSimd() - other.toSimd()).toSCN()
	}
	public static func -= (v:inout SCNVector3, o:SCNVector3) { v.subtract(o) }
	public mutating func subtract(_ other:SCNVector3) {
		self = self.subtracted(by: other)
	}
}


extension SCNVector3 : Equatable
{
	public static func == (a:SCNVector3, b:SCNVector3) -> Bool {
		return SCNVector3EqualToVector3(a, b)
	}
}



// MARK: SCNQuaternion Extensions

extension SCNQuaternion
{
	public static let identity:SCNQuaternion = GLKQuaternionIdentity.toSCN()
	public static let identityFacingVector:SCNVector3 = SCNVector3(0, 0, -1)
	public static let identityUpVector:SCNVector3 = SCNVector3(0, 1, 0)
	
	
	public init(from a:SCNVector3, to b:SCNVector3, opposing180Axis:SCNVector3=identityUpVector) {
		let aNormal = a.normalized(), bNormal = b.normalized()
		let dotProduct = aNormal.dotProduct(bNormal)
		if dotProduct >= 1.0 {
			self = GLKQuaternionIdentity.toSCN()
		}
		else if dotProduct < (-1.0 + Float.leastNormalMagnitude) {
			self = GLKQuaternionMakeWithAngleAndVector3Axis(Float.pi, opposing180Axis.toGLK()).toSCN()
		}
		else {
			// from: https://bitbucket.org/sinbad/ogre/src/9db75e3ba05c/OgreMain/include/OgreVector3.h?fileviewer=file-view-default#OgreVector3.h-651
			// looks to be explained at: http://lolengine.net/blog/2013/09/18/beautiful-maths-quaternion-from-vectors
			let s = sqrt((1.0 + dotProduct) * 2.0)
			let xyz = aNormal.crossProduct(bNormal) / s
			(self.x, self.y, self.z, self.w) = (xyz.x, xyz.y, xyz.z, (s * 0.5))
		}
	}
	
	
	public init(angle angle_rad:Float, axis axisVector:SCNVector3) {
		self = GLKQuaternionMakeWithAngleAndVector3Axis(angle_rad, axisVector.toGLK()).toSCN()
	}
	
	
	public func angleAxis() -> (Float, SCNVector3) {
		let self_glk = self.toGLK()
		let angle = GLKQuaternionAngle(self_glk)
		let axis = SCNVector3FromGLKVector3(GLKQuaternionAxis(self_glk))
		return (angle, axis)
	}
	
	public func delta(_ other:SCNQuaternion) -> SCNQuaternion {
		return -self * other
	}
	
	public static prefix func - (q:SCNQuaternion) -> SCNQuaternion { return q.inverted() }
	public func inverted() -> SCNQuaternion {
		return GLKQuaternionInvert(self.toGLK()).toSCN()
	}
	public mutating func invert() {
		self = self.inverted()
	}
	
	public static func * (a:SCNQuaternion, b:SCNQuaternion) -> SCNQuaternion { return a.multiplied(by: b) }
	public func multiplied(by other:SCNQuaternion) -> SCNQuaternion {
		return GLKQuaternionMultiply(self.toGLK(), other.toGLK()).toSCN()
	}
	public static func *= (q:inout SCNQuaternion, o:SCNQuaternion) { q.multiply(by: o) }
	public mutating func multiply(by other:SCNQuaternion) {
		self = self.multiplied(by: other)
	}
	
	public mutating func normalize() {
		self = GLKQuaternionNormalize(self.toGLK()).toSCN()
	}
	
	public static func * (q:SCNQuaternion, v:SCNVector3) -> SCNVector3 { return q.rotate(vector: v) }
	public func rotate(vector:SCNVector3) -> SCNVector3 {
		return GLKQuaternionRotateVector3(self.toGLK(), vector.toGLK()).toSCN()
	}
}



// MARK: SCNMatrix4 Extensions

extension SCNMatrix4
{
	public static let identity:SCNMatrix4 = SCNMatrix4Identity
	
	
	public init(_ m:SCNMatrix4) {
		self = m
	}
	
	public init(translation:SCNVector3) {
		self = SCNMatrix4MakeTranslation(translation.x, translation.y, translation.z)
	}
	
	public init(rotationAngle angle:Float, axis:SCNVector3) {
		self = SCNMatrix4MakeRotation(angle, axis.x, axis.y, axis.z)
	}
	
	public init(scale:SCNVector3) {
		self = SCNMatrix4MakeScale(scale.x, scale.y, scale.z)
	}
	
	
	public static prefix func - (m:SCNMatrix4) -> SCNMatrix4 { return m.inverted() }
	public func inverted() -> SCNMatrix4 {
		return SCNMatrix4Invert(self)
	}
	public mutating func invert() {
		self = self.inverted()
	}
	
	public var isIdentity:Bool {
		return SCNMatrix4IsIdentity(self)
	}
	
	public static func * (a:SCNMatrix4, b:SCNMatrix4) -> SCNMatrix4 { return a.multiplied(by: b) }
	public func multiplied(by other:SCNMatrix4) -> SCNMatrix4 {
		return SCNMatrix4Mult(self, other)
	}
	public static func *= (m:inout SCNMatrix4, o:SCNMatrix4) { m.multiply(by: o) }
	public mutating func multiply(by other:SCNMatrix4) {
		self = self.multiplied(by: other)
	}
	
	public func translated(_ translation:SCNVector3) -> SCNMatrix4 {
		return SCNMatrix4Translate(self, translation.x, translation.y, translation.z)
	}
	public mutating func translate(_ translation:SCNVector3) {
		self = self.translated(translation)
	}
	
	public func scaled(_ scale:SCNVector3) -> SCNMatrix4 {
		return SCNMatrix4Scale(self, scale.x, scale.y, scale.z)
	}
	public mutating func scale(_ scale:SCNVector3) {
		self = self.scaled(scale)
	}
	
	public func rotated(angle:Float, axis:SCNVector3) -> SCNMatrix4 {
		return SCNMatrix4Rotate(self, angle, axis.x, axis.y, axis.z)
	}
	public mutating func rotate(angle:Float, axis:SCNVector3) {
		self = self.rotated(angle: angle, axis: axis)
	}
}


extension SCNMatrix4 : Equatable
{
	public static func == (a:SCNMatrix4, b:SCNMatrix4) -> Bool {
		return SCNMatrix4EqualToMatrix4(a, b)
	}
}
