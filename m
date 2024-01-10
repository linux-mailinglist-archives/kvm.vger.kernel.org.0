Return-Path: <kvm+bounces-5991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC94D8298FD
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 12:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CB521C21FD4
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 11:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9826C47A63;
	Wed, 10 Jan 2024 11:26:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1689B4778E
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 11:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Gao,Shiyuan" <gaoshiyuan@baidu.com>
To: "Gao,Shiyuan" <gaoshiyuan@baidu.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mtosatti@redhat.com"
	<mtosatti@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: limit the maximum CPUID.0xA.edx[0..4] to 3
Thread-Topic: [PATCH] kvm: limit the maximum CPUID.0xA.edx[0..4] to 3
Thread-Index: AQHZlSVPiltb1wEK5Ue4tpzTEkfwMrDTqtuAgACacYA=
Date: Wed, 10 Jan 2024 11:26:03 +0000
Message-ID: <35A93E08-3407-4815-A574-56BC5AFD0805@baidu.com>
References: <20230602073857.96790-1-gaoshiyuan@baidu.com>
 <20240110101317.46344-1-gaoshiyuan@baidu.com>
In-Reply-To: <20240110101317.46344-1-gaoshiyuan@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F0368F29CB0274C8CB81DAB78E803FB@internal.baidu.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.58
X-FE-Last-Public-Client-IP: 100.100.100.60
X-FE-Policy-ID: 15:10:21:SYSTEM

PiBBbnlvbmUgaGFzIHN1Z2dlc3Rpb24/DQo+DQo+IFdoZW4gdGhlIGhvc3Qga2VybmVsIGJlZm9y
ZSB0aGlzIGNvbW1pdCAyZThjZDdhM2I4MjggKCJrdm06IHg4NjogbGltaXQgdGhlIG1heGltdW0g
bnVtYmVyIG9mIHZQTVUNCj4gZml4ZWQgY291bnRlcnMgdG8gMyIpIG9uIGljZWxha2UgbWljcm9h
cmNoaXRlY3R1cmUgYW5kIG5ld2VyLCBleGVjdXRlIGNwdWlkIGluIHRoZSBHdWVzdDoNCj4NCj4g
QXJjaGl0ZWN0dXJlIFBlcmZvcm1hbmNlIE1vbml0b3JpbmcgRmVhdHVyZXMgKDB4YS9lZHgpOg0K
PiAgICAgbnVtYmVyIG9mIGZpeGVkIGNvdW50ZXJzICAgID0gMHg0ICg0KQ0KPg0KPiBUaGlzIGlz
IG5vdCBpbmNvbnNpc3RlbnQgd2l0aCBudW1fYXJjaGl0ZWN0dXJhbF9wbXVfZml4ZWRfY291bnRl
cnMgaW4gUUVNVS4NCg0KVGhpcyBpcyB0aGUgb3JnaW5hbCBwYXRjaC4NCg0Ka3ZtOiBsaW1pdCB0
aGUgbWF4aW11bSBDUFVJRC4weEEuZWR4WzAuLjRdIHRvIDMNCg0KTm93LCB0aGUgQ1BVSUQuMHhB
IGRlcGVuZHMgb24gdGhlIEtWTSByZXBvcnQuIFRoZSB2YWx1ZSBvZiBDUFVJRC4weEEuZWR4WzAu
LjRdDQphbmQgbnVtX2FyY2hpdGVjdHVyYWxfcG11X2ZpeGVkX2NvdW50ZXJzIGFyZSBpbmNvbnNp
c3RlbnQgd2hlbiB0aGUgaG9zdCBrZXJuZWwNCmJlZm9yZSB0aGlzIGNvbW1pdCAyZThjZDdhM2I4
MjggKCJrdm06IHg4NjogbGltaXQgdGhlIG1heGltdW0gbnVtYmVyIG9mIHZQTVUNCmZpeGVkIGNv
dW50ZXJzIHRvIDMiKSBvbiBpY2VsYWtlIG1pY3JvYXJjaGl0ZWN0dXJlLg0KDQpUaGlzIGFsc28g
YnJlYWsgdGhlIGxpdmUtbWlncmF0aW9uIGJldHdlZW4gc291cmNlIGhvc3Qga2VybmVsIGJlZm9y
ZSBjb21taXQNCjJlOGNkN2EzYjgyOCBhbmQgZGVzdCBob3N0IGtlcm5lbCBhZnRlciB0aGUgY29t
bWl0IG9uIGljZWxha2UgbWljcm9hcmNoaXRlY3R1cmUuDQoNClNpZ25lZC1vZmYtYnk6IFNoaXl1
YW4gR2FvIDxnYW9zaGl5dWFuQGJhaWR1LmNvbT4NCi0tLQ0KIHRhcmdldC9pMzg2L2t2bS9rdm0u
YyB8IDEzICsrKysrKysrKysrLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL3RhcmdldC9pMzg2L2t2bS9rdm0uYyBiL3Rh
cmdldC9pMzg2L2t2bS9rdm0uYw0KaW5kZXggZGU1MzE4NDJmNi4uZTc3MTI5YjczNyAxMDA2NDQN
Ci0tLSBhL3RhcmdldC9pMzg2L2t2bS9rdm0uYw0KKysrIGIvdGFyZ2V0L2kzODYva3ZtL2t2bS5j
DQpAQCAtMTc2MSw3ICsxNzYxLDcgQEAgaW50IGt2bV9hcmNoX2luaXRfdmNwdShDUFVTdGF0ZSAq
Y3MpDQoNCiAgICAgWDg2Q1BVICpjcHUgPSBYODZfQ1BVKGNzKTsNCiAgICAgQ1BVWDg2U3RhdGUg
KmVudiA9ICZjcHUtPmVudjsNCi0gICAgdWludDMyX3QgbGltaXQsIGksIGosIGNwdWlkX2k7DQor
ICAgIHVpbnQzMl90IGxpbWl0LCBpLCBqLCBjcHVpZF9pLCBjcHVpZF8weGE7DQogICAgIHVpbnQz
Ml90IHVudXNlZDsNCiAgICAgc3RydWN0IGt2bV9jcHVpZF9lbnRyeTIgKmM7DQogICAgIHVpbnQz
Ml90IHNpZ25hdHVyZVszXTsNCkBAIC0xNzczLDYgKzE3NzMsNyBAQCBpbnQga3ZtX2FyY2hfaW5p
dF92Y3B1KENQVVN0YXRlICpjcykNCiAgICAgbWVtc2V0KCZjcHVpZF9kYXRhLCAwLCBzaXplb2Yo
Y3B1aWRfZGF0YSkpOw0KDQogICAgIGNwdWlkX2kgPSAwOw0KKyAgICBjcHVpZF8weGEgPSAwOw0K
DQogICAgIGhhc194c2F2ZTIgPSBrdm1fY2hlY2tfZXh0ZW5zaW9uKGNzLT5rdm1fc3RhdGUsIEtW
TV9DQVBfWFNBVkUyKTsNCg0KQEAgLTIwNDUsNiArMjA0Niw5IEBAIGludCBrdm1fYXJjaF9pbml0
X3ZjcHUoQ1BVU3RhdGUgKmNzKQ0KICAgICAgICAgICAgIGMtPmZ1bmN0aW9uID0gaTsNCiAgICAg
ICAgICAgICBjLT5mbGFncyA9IDA7DQogICAgICAgICAgICAgY3B1X3g4Nl9jcHVpZChlbnYsIGks
IDAsICZjLT5lYXgsICZjLT5lYngsICZjLT5lY3gsICZjLT5lZHgpOw0KKyAgICAgICAgICAgIGlm
ICgweDBhID09IGkpIHsNCisgICAgICAgICAgICAgICAgY3B1aWRfMHhhID0gY3B1aWRfaSAtIDE7
DQorICAgICAgICAgICAgfQ0KICAgICAgICAgICAgIGlmICghYy0+ZWF4ICYmICFjLT5lYnggJiYg
IWMtPmVjeCAmJiAhYy0+ZWR4KSB7DQogICAgICAgICAgICAgICAgIC8qDQogICAgICAgICAgICAg
ICAgICAqIEtWTSBhbHJlYWR5IHJldHVybnMgYWxsIHplcm9lcyBpZiBhIENQVUlEIGVudHJ5IGlz
IG1pc3NpbmcsDQpAQCAtMjA1OSw3ICsyMDYzLDExIEBAIGludCBrdm1fYXJjaF9pbml0X3ZjcHUo
Q1BVU3RhdGUgKmNzKQ0KICAgICBpZiAobGltaXQgPj0gMHgwYSkgew0KICAgICAgICAgdWludDMy
X3QgZWF4LCBlZHg7DQoNCi0gICAgICAgIGNwdV94ODZfY3B1aWQoZW52LCAweDBhLCAwLCAmZWF4
LCAmdW51c2VkLCAmdW51c2VkLCAmZWR4KTsNCisgICAgICAgIGFzc2VydChjcHVpZF8weGEgPj0g
MHgwYSk7DQorDQorICAgICAgICBjID0gJmNwdWlkX2RhdGEuZW50cmllc1tjcHVpZF8weGFdOw0K
KyAgICAgICAgZWF4ID0gYy0+ZWF4Ow0KKyAgICAgICAgZWR4ID0gYy0+ZWR4Ow0KDQogICAgICAg
ICBoYXNfYXJjaGl0ZWN0dXJhbF9wbXVfdmVyc2lvbiA9IGVheCAmIDB4ZmY7DQogICAgICAgICBp
ZiAoaGFzX2FyY2hpdGVjdHVyYWxfcG11X3ZlcnNpb24gPiAwKSB7DQpAQCAtMjA3OCw2ICsyMDg2
LDcgQEAgaW50IGt2bV9hcmNoX2luaXRfdmNwdShDUFVTdGF0ZSAqY3MpDQoNCiAgICAgICAgICAg
ICAgICAgaWYgKG51bV9hcmNoaXRlY3R1cmFsX3BtdV9maXhlZF9jb3VudGVycyA+IE1BWF9GSVhF
RF9DT1VOVEVSUykgew0KICAgICAgICAgICAgICAgICAgICAgbnVtX2FyY2hpdGVjdHVyYWxfcG11
X2ZpeGVkX2NvdW50ZXJzID0gTUFYX0ZJWEVEX0NPVU5URVJTOw0KKyAgICAgICAgICAgICAgICAg
ICAgYy0+ZWR4ID0gKGVkeCAmIH4weDFmKSB8IG51bV9hcmNoaXRlY3R1cmFsX3BtdV9maXhlZF9j
b3VudGVyczsNCiAgICAgICAgICAgICAgICAgfQ0KICAgICAgICAgICAgIH0NCiAgICAgICAgIH0N
Cg0K

