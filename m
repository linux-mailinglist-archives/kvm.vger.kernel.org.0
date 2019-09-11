Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21539AF760
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 10:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfIKIAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 04:00:16 -0400
Received: from [110.188.70.11] ([110.188.70.11]:39040 "EHLO spam1.hygon.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726696AbfIKIAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 04:00:15 -0400
Received: from MK-FE.hygon.cn ([172.23.18.61])
        by spam1.hygon.cn with ESMTP id x8B7vx8a088544;
        Wed, 11 Sep 2019 15:57:59 +0800 (GMT-8)
        (envelope-from fanjinke@hygon.cn)
Received: from cncheex02.Hygon.cn ([172.23.18.12])
        by MK-FE.hygon.cn with ESMTP id x8B7vkWB014709;
        Wed, 11 Sep 2019 15:57:47 +0800 (GMT-8)
        (envelope-from fanjinke@hygon.cn)
Received: from cncheex01.Hygon.cn (172.23.18.10) by cncheex02.Hygon.cn
 (172.23.18.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Wed, 11 Sep
 2019 15:57:55 +0800
Received: from cncheex01.Hygon.cn ([172.23.18.10]) by cncheex01.Hygon.cn
 ([172.23.18.10]) with mapi id 15.01.1466.003; Wed, 11 Sep 2019 15:57:55 +0800
From:   Jinke Fan <fanjinke@hygon.cn>
CC:     Wen Pu <puwen@hygon.cn>, Borislav Petkov <bp@suse.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 12/16] x86/kvm: Add Hygon Dhyana support to KVM
Thread-Topic: [PATCH 12/16] x86/kvm: Add Hygon Dhyana support to KVM
Thread-Index: AQHVaHVXYNQoj5g29UK0y0FOg4Neo6clljQA
Date:   Wed, 11 Sep 2019 07:57:55 +0000
Message-ID: <4fbc1c0d-4f66-2704-bfdf-7496304e551d@hygon.cn>
References: <20190911074839.69650-1-fanjinke@hygon.cn>
In-Reply-To: <20190911074839.69650-1-fanjinke@hygon.cn>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.44]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E3670A6B28FAB4FBBBA2DEE3C031859@Hygon.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MAIL: spam1.hygon.cn x8B7vx8a088544
X-DNSRBL: 
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGxlYXNlIGlnbm9yZSB0aGlzIGVtYWlsISBJdCdzIGEgbWlzdGFrZS4NCkknbSBzbyBzb3JyeS4N
Cg0KQmVzdCBSZWdhcmRzLg0KSmlua2UgRmFuLg0KDQpPbiAyMDE5LzkvMTEgMTU6NDgsIEppbmtl
IEZhbiB3cm90ZToNCj4gRnJvbTogUHUgV2VuIDxwdXdlbkBoeWdvbi5jbj4NCj4gDQo+IFRoZSBI
eWdvbiBEaHlhbmEgQ1BVIGhhcyB0aGUgU1ZNIGZlYXR1cmUgYXMgQU1EIGZhbWlseSAxN2ggZG9l
cy4NCj4gU28gZW5hYmxlIHRoZSBLVk0gaW5mcmFzdHJ1Y3R1cmUgc3VwcG9ydCB0byBpdC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IFB1IFdlbiA8cHV3ZW5AaHlnb24uY24+DQo+IFNpZ25lZC1vZmYt
Ynk6IEJvcmlzbGF2IFBldGtvdiA8YnBAc3VzZS5kZT4NCj4gUmV2aWV3ZWQtYnk6IEJvcmlzbGF2
IFBldGtvdiA8YnBAc3VzZS5kZT4NCj4gQ2M6IHBib256aW5pQHJlZGhhdC5jb20NCj4gQ2M6IHJr
cmNtYXJAcmVkaGF0LmNvbQ0KPiBDYzogdGdseEBsaW51dHJvbml4LmRlDQo+IENjOiBtaW5nb0By
ZWRoYXQuY29tDQo+IENjOiBocGFAenl0b3IuY29tDQo+IENjOiB4ODZAa2VybmVsLm9yZw0KPiBD
YzogdGhvbWFzLmxlbmRhY2t5QGFtZC5jb20NCj4gQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCj4g
TGluazogaHR0cHM6Ly9sa21sLmtlcm5lbC5vcmcvci82NTRkZDEyODc2MTQ5ZmJhOTU2MTY5OGVh
ZjlmYzE1ZDAzMDMwMWY4LjE1Mzc1MzMzNjkuZ2l0LnB1d2VuQGh5Z29uLmNuDQo+IC0tLQ0KPiAg
IGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9lbXVsYXRlLmggfCAgNCArKysrDQo+ICAgYXJjaC94
ODYvaW5jbHVkZS9hc20vdmlydGV4dC5oICAgICB8ICA1ICsrKy0tDQo+ICAgYXJjaC94ODYva3Zt
L2VtdWxhdGUuYyAgICAgICAgICAgICB8IDExICsrKysrKysrKystDQo+ICAgMyBmaWxlcyBjaGFu
Z2VkLCAxNyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9lbXVsYXRlLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9rdm1fZW11bGF0ZS5oDQo+IGluZGV4IDBmODJjZDkxY2QzYy4uOTNjNGJmNTk4ZmIwIDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1fZW11bGF0ZS5oDQo+ICsrKyBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2t2bV9lbXVsYXRlLmgNCj4gQEAgLTM2NCw2ICszNjQsMTAgQEAg
c3RydWN0IHg4Nl9lbXVsYXRlX2N0eHQgew0KPiAgICNkZWZpbmUgWDg2RU1VTF9DUFVJRF9WRU5E
T1JfQU1EaXNiZXR0ZXJJX2VjeCAweDIxNzI2NTc0DQo+ICAgI2RlZmluZSBYODZFTVVMX0NQVUlE
X1ZFTkRPUl9BTURpc2JldHRlcklfZWR4IDB4NzQ2NTYyNzMNCj4gICANCj4gKyNkZWZpbmUgWDg2
RU1VTF9DUFVJRF9WRU5ET1JfSHlnb25HZW51aW5lX2VieCAweDZmNjc3OTQ4DQo+ICsjZGVmaW5l
IFg4NkVNVUxfQ1BVSURfVkVORE9SX0h5Z29uR2VudWluZV9lY3ggMHg2NTZlNjk3NQ0KPiArI2Rl
ZmluZSBYODZFTVVMX0NQVUlEX1ZFTkRPUl9IeWdvbkdlbnVpbmVfZWR4IDB4NmU2NTQ3NmUNCj4g
Kw0KPiAgICNkZWZpbmUgWDg2RU1VTF9DUFVJRF9WRU5ET1JfR2VudWluZUludGVsX2VieCAweDc1
NmU2NTQ3DQo+ICAgI2RlZmluZSBYODZFTVVMX0NQVUlEX1ZFTkRPUl9HZW51aW5lSW50ZWxfZWN4
IDB4NmM2NTc0NmUNCj4gICAjZGVmaW5lIFg4NkVNVUxfQ1BVSURfVkVORE9SX0dlbnVpbmVJbnRl
bF9lZHggMHg0OTY1NmU2OQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdmly
dGV4dC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdmlydGV4dC5oDQo+IGluZGV4IDAxMTZiMmVl
OWU2NC4uZTA1ZTBkMzA5MjQ0IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92
aXJ0ZXh0LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdmlydGV4dC5oDQo+IEBAIC04
Myw5ICs4MywxMCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgY3B1X2VtZXJnZW5jeV92bXhvZmYodm9p
ZCkNCj4gICAgKi8NCj4gICBzdGF0aWMgaW5saW5lIGludCBjcHVfaGFzX3N2bShjb25zdCBjaGFy
ICoqbXNnKQ0KPiAgIHsNCj4gLQlpZiAoYm9vdF9jcHVfZGF0YS54ODZfdmVuZG9yICE9IFg4Nl9W
RU5ET1JfQU1EKSB7DQo+ICsJaWYgKGJvb3RfY3B1X2RhdGEueDg2X3ZlbmRvciAhPSBYODZfVkVO
RE9SX0FNRCAmJg0KPiArCSAgICBib290X2NwdV9kYXRhLng4Nl92ZW5kb3IgIT0gWDg2X1ZFTkRP
Ul9IWUdPTikgew0KPiAgIAkJaWYgKG1zZykNCj4gLQkJCSptc2cgPSAibm90IGFtZCI7DQo+ICsJ
CQkqbXNnID0gIm5vdCBhbWQgb3IgaHlnb24iOw0KPiAgIAkJcmV0dXJuIDA7DQo+ICAgCX0NCj4g
ICANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9lbXVsYXRlLmMgYi9hcmNoL3g4Ni9rdm0v
ZW11bGF0ZS5jDQo+IGluZGV4IDEwNjQ4MmRhNjM4OC4uMzRlZGYxOTg3MDhmIDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3g4Ni9rdm0vZW11bGF0ZS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9lbXVsYXRl
LmMNCj4gQEAgLTI3MTEsNyArMjcxMSwxNiBAQCBzdGF0aWMgYm9vbCBlbV9zeXNjYWxsX2lzX2Vu
YWJsZWQoc3RydWN0IHg4Nl9lbXVsYXRlX2N0eHQgKmN0eHQpDQo+ICAgCSAgICBlZHggPT0gWDg2
RU1VTF9DUFVJRF9WRU5ET1JfQU1EaXNiZXR0ZXJJX2VkeCkNCj4gICAJCXJldHVybiB0cnVlOw0K
PiAgIA0KPiAtCS8qIGRlZmF1bHQ6IChub3QgSW50ZWwsIG5vdCBBTUQpLCBhcHBseSBJbnRlbCdz
IHN0cmljdGVyIHJ1bGVzLi4uICovDQo+ICsJLyogSHlnb24gKCJIeWdvbkdlbnVpbmUiKSAqLw0K
PiArCWlmIChlYnggPT0gWDg2RU1VTF9DUFVJRF9WRU5ET1JfSHlnb25HZW51aW5lX2VieCAmJg0K
PiArCSAgICBlY3ggPT0gWDg2RU1VTF9DUFVJRF9WRU5ET1JfSHlnb25HZW51aW5lX2VjeCAmJg0K
PiArCSAgICBlZHggPT0gWDg2RU1VTF9DUFVJRF9WRU5ET1JfSHlnb25HZW51aW5lX2VkeCkNCj4g
KwkJcmV0dXJuIHRydWU7DQo+ICsNCj4gKwkvKg0KPiArCSAqIGRlZmF1bHQ6IChub3QgSW50ZWws
IG5vdCBBTUQsIG5vdCBIeWdvbiksIGFwcGx5IEludGVsJ3MNCj4gKwkgKiBzdHJpY3RlciBydWxl
cy4uLg0KPiArCSAqLw0KPiAgIAlyZXR1cm4gZmFsc2U7DQo+ICAgfQ0KPiAgIA0KPiANCg==
