Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854CD450495
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 13:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhKOMoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 07:44:12 -0500
Received: from smtp4.jd.com ([59.151.64.78]:2050 "EHLO smtp4.jd.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhKOMoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 07:44:06 -0500
Received: from JDCloudMail06.360buyAD.local (172.31.68.39) by
 JDCloudMail07.360buyAD.local (172.31.68.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 15 Nov 2021 20:41:00 +0800
Received: from JDCloudMail06.360buyAD.local ([fe80::643e:3192:cad7:c913]) by
 JDCloudMail06.360buyAD.local ([fe80::643e:3192:cad7:c913%5]) with mapi id
 15.01.2375.007; Mon, 15 Nov 2021 20:41:00 +0800
From:   =?gb2312?B?u8bA1g==?= <huangle1@jd.com>
To:     "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] KVM: x86: Fix uninitialized eoi_exit_bitmap usage in
 vcpu_load_eoi_exitmap()
Thread-Topic: Re: [PATCH] KVM: x86: Fix uninitialized eoi_exit_bitmap usage in
 vcpu_load_eoi_exitmap()
Thread-Index: AQHX2h3F2UztZsEppUOwyzlbNRwZtQ==
Date:   Mon, 15 Nov 2021 12:41:00 +0000
Message-ID: <567b276444f841519e42c91f43f5acd7@jd.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.31.14.18]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiC7xsDWIDxodWFuZ2xlMUBqZC5jb20+IHdyaXRlczoNCj4gDQo+ID4gSW4gdmNwdV9sb2FkX2Vv
aV9leGl0bWFwKCksIGN1cnJlbnRseSB0aGUgZW9pX2V4aXRfYml0bWFwWzRdIGFycmF5IGlzDQo+
ID4gaW5pdGlhbGl6ZWQgb25seSB3aGVuIEh5cGVyLVYgY29udGV4dCBpcyBhdmFpbGFibGUsIGlu
IG90aGVyIHBhdGggaXQgaXMNCj4gPiBqdXN0IHBhc3NlZCB0byBrdm1feDg2X29wcy5sb2FkX2Vv
aV9leGl0bWFwKCkgZGlyZWN0bHkgZnJvbSBvbiB0aGUgc3RhY2ssDQo+ID4gd2hpY2ggd291bGQg
Y2F1c2UgdW5leHBlY3RlZCBpbnRlcnJ1cHQgZGVsaXZlcnkvaGFuZGxpbmcgaXNzdWVzLCBlLmcu
IGFuDQo+ID4gKm9sZCogbGludXgga2VybmVsIHRoYXQgcmVsaWVzIG9uIFBJVCB0byBkbyBjbG9j
ayBjYWxpYnJhdGlvbiBvbiBLVk0gbWlnaHQNCj4gPiByYW5kb21seSBmYWlsIHRvIGJvb3QuDQo+
ID4NCj4gPiBGaXggaXQgYnkgcGFzc2luZyBpb2FwaWNfaGFuZGxlZF92ZWN0b3JzIHRvIGxvYWRf
ZW9pX2V4aXRtYXAoKSB3aGVuIEh5cGVyLVYNCj4gPiBjb250ZXh0IGlzIG5vdCBhdmFpbGFibGUu
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBIdWFuZyBMZSA8aHVhbmdsZTFAamQuY29tPg0KPiAN
Cj4gRml4ZXM6IGYyYmMxNGI2OWMzOCAoIktWTTogeDg2OiBoeXBlci12OiBQcmVwYXJlIHRvIG1l
ZXQgdW5hbGxvY2F0ZWQgSHlwZXItViBjb250ZXh0IikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCg0KQ29tbWl0IGYyYmMxNGI2OWMzOCBpcyBub3QgaW4gc3RhYmxlIHRyZWUgSSBndWVz
cywgaXQgd2FzIG1lcmdlZCBpbiBmcm9tIDUuMTIsDQpkbyB3ZSBzdGlsbCBuZWVkIENjIHRoaXMg
cGF0Y2ggdG8gc3RhYmxlIG1haW50YWluZXJzPw0KDQo+IA0KPiA+IC0tLQ0KPiA+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiBpbmRleCBk
YzdlYjVmZGRmZDMuLjA2OTk4MzI1MDRjOSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0v
eDg2LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiBAQCAtOTU0NywxMSArOTU0
NywxNCBAQCBzdGF0aWMgdm9pZCB2Y3B1X2xvYWRfZW9pX2V4aXRtYXAoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQ0KPiA+ICAgICAgICBpZiAoIWt2bV9hcGljX2h3X2VuYWJsZWQodmNwdS0+YXJjaC5h
cGljKSkNCj4gPiAgICAgICAgICAgICAgICByZXR1cm47DQo+ID4gDQo+ID4gLSAgICAgaWYgKHRv
X2h2X3ZjcHUodmNwdSkpDQo+ID4gLSAgICAgICAgICAgICBiaXRtYXBfb3IoKHVsb25nICopZW9p
X2V4aXRfYml0bWFwLA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIHZjcHUtPmFyY2guaW9h
cGljX2hhbmRsZWRfdmVjdG9ycywNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICB0b19odl9z
eW5pYyh2Y3B1KS0+dmVjX2JpdG1hcCwgMjU2KTsNCj4gPiArICAgICBpZiAoIXRvX2h2X3ZjcHUo
dmNwdSkpIHsNCj4gPiArICAgICAgICAgICAgIHN0YXRpY19jYWxsKGt2bV94ODZfbG9hZF9lb2lf
ZXhpdG1hcCkoDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHZjcHUsICh1NjQgKil2Y3B1LT5h
cmNoLmlvYXBpY19oYW5kbGVkX3ZlY3RvcnMpOw0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuOw0K
PiA+ICsgICAgIH0NCj4gPiANCj4gPiArICAgICBiaXRtYXBfb3IoKHVsb25nICopZW9pX2V4aXRf
Yml0bWFwLCB2Y3B1LT5hcmNoLmlvYXBpY19oYW5kbGVkX3ZlY3RvcnMsDQo+ID4gKyAgICAgICAg
ICAgICAgIHRvX2h2X3N5bmljKHZjcHUpLT52ZWNfYml0bWFwLCAyNTYpOw0KPiA+ICAgICAgICBz
dGF0aWNfY2FsbChrdm1feDg2X2xvYWRfZW9pX2V4aXRtYXApKHZjcHUsIGVvaV9leGl0X2JpdG1h
cCk7DQo+ID4gIH0NCj4gPiANCj4gDQo+IFJldmlld2VkLWJ5OiBWaXRhbHkgS3V6bmV0c292IDx2
a3V6bmV0c0ByZWRoYXQuY29tPg0KPiANCj4gTXkgcGVyc29uYWwgcHJlZmVyZW5jZSwgaG93ZXZl
ciwgd291bGQgYmUgdG8ga2VlcCAnaWYNCj4gKHRvX2h2X3ZjcHUodmNwdSkpJyBjaGVjayBhbmQg
bm90IGludmVydCBpdCwgaS5lLjoNCj4gDQo+ICAgICAgICAgaWYgKHRvX2h2X3ZjcHUodmNwdSkp
IHsNCj4gICAgICAgICAgICAgICAgIGJpdG1hcF9vcigodWxvbmcgKillb2lfZXhpdF9iaXRtYXAs
DQo+ICAgICAgICAgICAgICAgICAgdmNwdS0+YXJjaC5pb2FwaWNfaGFuZGxlZF92ZWN0b3JzLA0K
PiAgICAgICAgICAgICAgICAgIHRvX2h2X3N5bmljKHZjcHUpLT52ZWNfYml0bWFwLCAyNTYpOw0K
PiAgICAgICAgICAgICAgICAgc3RhdGljX2NhbGwoLi4uKSh2Y3B1LCBlb2lfZXhpdF9iaXRtYXAp
DQo+ICAgICAgICAgICAgICAgICByZXR1cm47DQo+ICAgICAgICAgfQ0KPiANCj4gICAgICAgICBz
dGF0aWNfY2FsbCguLi4pKHZjcHUsICh1NjQgKil2Y3B1LT5hcmNoLmlvYXBpY19oYW5kbGVkX3Zl
Y3RvcnMpOw0KPiANCj4gdG8gc2xpZ2h0bHkgcmVkdWNlIHRoZSBjb2RlIGNodXJuIGJ1dCBpdCBk
b2Vzbid0IG1hdHRlciBtdWNoLg0KDQpHb3QgaXQuICBXaWxsIHNlbmQgYW4gdXBkYXRlZCBvbmUg
bGF0ZXIuICBUaGFua3MgZm9yIHN1Z2dlc3Rpb24hDQoNCj4gDQo+IFRoYW5rcyENCj4gDQo+IC0t
DQo+IFZpdGFseQ0K
