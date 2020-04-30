Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DF01BEE00
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 04:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD3CBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 22:01:30 -0400
Received: from mx22.baidu.com ([220.181.50.185]:38918 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726282AbgD3CBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 22:01:30 -0400
Received: from BC-Mail-Ex16.internal.baidu.com (unknown [172.31.51.56])
        by Forcepoint Email with ESMTPS id 7AD7E984D2F571FACB69;
        Thu, 30 Apr 2020 09:45:30 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex16.internal.baidu.com (172.31.51.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Thu, 30 Apr 2020 09:45:30 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 30 Apr 2020 09:45:30 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBrdm06IHg4NjogZW11bGF0ZSBBUEVSRi9N?=
 =?utf-8?Q?PERF_registers?=
Thread-Topic: [PATCH][v2] kvm: x86: emulate APERF/MPERF registers
Thread-Index: AQHWHgPRaxq7VoyE2kqvmC7wjQtzhaiPXbuAgAGG2mA=
Date:   Thu, 30 Apr 2020 01:45:30 +0000
Message-ID: <bea20279850d48848e0b21f7cbb39bdb@baidu.com>
References: <1588139196-23802-1-git-send-email-lirongqing@baidu.com>
 <20200429085440.GG13592@hirez.programming.kicks-ass.net>
 <201824a4-6b0f-9061-ec21-26d71fa11bc4@redhat.com>
In-Reply-To: <201824a4-6b0f-9061-ec21-26d71fa11bc4@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.11]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex16_2020-04-30 09:45:30:295
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex16_GRAY_Inside_WithoutAtta_2020-04-30
 09:45:30:186
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFBhb2xvIEJvbnppbmkg
W21haWx0bzpwYm9uemluaUByZWRoYXQuY29tXQ0KPiDlj5HpgIHml7bpl7Q6IDIwMjDlubQ05pyI
Mjnml6UgMTg6MjENCj4g5pS25Lu25Lq6OiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVh
ZC5vcmc+OyBMaSxSb25ncWluZw0KPiA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+IOaKhOmAgTog
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgeDg2QGtl
cm5lbC5vcmc7DQo+IGhwYUB6eXRvci5jb207IGJwQGFsaWVuOC5kZTsgbWluZ29AcmVkaGF0LmNv
bTsgdGdseEBsaW51dHJvbml4LmRlOw0KPiBqb3JvQDhieXRlcy5vcmc7IGptYXR0c29uQGdvb2ds
ZS5jb207IHdhbnBlbmdsaUB0ZW5jZW50LmNvbTsNCj4gdmt1em5ldHNAcmVkaGF0LmNvbTsgc2Vh
bi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbQ0KPiDkuLvpopg6IFJlOiBbUEFUQ0hdW3YyXSBr
dm06IHg4NjogZW11bGF0ZSBBUEVSRi9NUEVSRiByZWdpc3RlcnMNCj4gDQo+IE9uIDI5LzA0LzIw
IDEwOjU0LCBQZXRlciBaaWpsc3RyYSB3cm90ZToNCj4gPiBPbiBXZWQsIEFwciAyOSwgMjAyMCBh
dCAwMTo0NjozNlBNICswODAwLCBMaSBSb25nUWluZyB3cm90ZToNCj4gPj4gR3Vlc3Qga2VybmVs
IHJlcG9ydHMgYSBmaXhlZCBjcHUgZnJlcXVlbmN5IGluIC9wcm9jL2NwdWluZm8sIHRoaXMgaXMN
Cj4gPj4gY29uZnVzZWQgdG8gdXNlciB3aGVuIHR1cmJvIGlzIGVuYWJsZSwgYW5kIGFwZXJmL21w
ZXJmIGNhbiBiZSB1c2VkIHRvDQo+ID4+IHNob3cgY3VycmVudCBjcHUgZnJlcXVlbmN5IGFmdGVy
IDdkNTkwNWRjMTRhDQo+ID4+ICIoeDg2IC8gQ1BVOiBBbHdheXMgc2hvdyBjdXJyZW50IENQVSBm
cmVxdWVuY3kgaW4gL3Byb2MvY3B1aW5mbykiDQo+ID4+IHNvIHdlIHNob3VsZCBlbXVsYXRlIGFw
ZXJmIG1wZXJmIHRvIGFjaGlldmUgaXQNCj4gPj4NCj4gPj4gdGhlIHBlcmlvZCBvZiBhcGVyZi9t
cGVyZiBpbiBndWVzdCBtb2RlIGFyZSBhY2N1bXVsYXRlZCBhcyBlbXVsYXRlZA0KPiA+PiB2YWx1
ZSwgYW5kIGFkZCBwZXItVk0ga25vZCB0byBlbmFibGUgZW11bGF0ZSBtcGVyZmFwZXJmDQo+ID4+
DQo+ID4+IGRpZmYgdjE6DQo+ID4+IDEuIHN1cHBvcnQgQU1EDQo+ID4+IDIuIHN1cHBvcnQgcGVy
LXZtIGNhcGFiaWxpdHkgdG8gZW5hYmxlDQo+ID4gV291bGQgaXQgbWFrZSBzZW5zZSB0byBwcm92
aWRlIGEgcGFzcy10aHJvdWdoIEFQRVJGL01QRVJGIGZvcg0KPiA+IEtWTV9ISU5UU19SRUFMVElN
RSA/IEJlY2F1c2UgdGhhdCBoaW50IGd1YXJhbnRlZXMgd2UgaGF2ZSBhIDE6MQ0KPiA+IHZDUFU6
Q1BVIGJpbmRpbmcgYW5kIGd1YXJhbnRlZWQgbm8gb3Zlci1jb21taXQuDQo+ID4NCj4gDQo+IFll
cyBidXQgdGhhdCdzIHVwIHRvIHVzZXJzcGFjZS4NCj4gDQo+IFBhb2xvDQoNClNlZW0ga2VybmVs
IHNob3VsZCBnaXZlIHRoZSBjYXBhYmlsaXR5IHRvIHVzZXJzcGFjZSB0byBkaXNhYmxlIHRoZSBp
bnRlcmNlcHQgbXBlcmYvYXBlcmYgZm9yIEtWTV9ISU5UU19SRUFMVElNRQ0KDQpTbyBJIHdpbGwg
Y2hhbmdlIHRoaXMgcGF0Y2ggdG8gc3VwcG9ydCB0aHJlZSBtb2RlIG1wZXJmYXBlcmY6ICBub25l
LCBzb2Z0d2FyZSBlbXVsYXRlLCBhbmQgcHQNCg0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQppbmRleCAxZDE1N2E4ZGJhNDYuLjZiMDVmNzhi
ZGU3OCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KKysrIGIvYXJjaC94ODYva3Zt
L3N2bS5jDQpAQCAtMTY1Nyw5ICsxNjU3LDExIEBAIHN0YXRpYyB2b2lkIGluaXRfdm1jYihzdHJ1
Y3QgdmNwdV9zdm0gKnN2bSkNCiAgICAgICAgc2V0X2ludGVyY2VwdChzdm0sIElOVEVSQ0VQVF9T
S0lOSVQpOw0KICAgICAgICBzZXRfaW50ZXJjZXB0KHN2bSwgSU5URVJDRVBUX1dCSU5WRCk7DQog
ICAgICAgIHNldF9pbnRlcmNlcHQoc3ZtLCBJTlRFUkNFUFRfWFNFVEJWKTsNCi0gICAgICAgc2V0
X2ludGVyY2VwdChzdm0sIElOVEVSQ0VQVF9SRFBSVSk7DQogICAgICAgIHNldF9pbnRlcmNlcHQo
c3ZtLCBJTlRFUkNFUFRfUlNNKTsNCiANCisgICAgICAgaWYgKCFndWVzdF9tcGVyZmFwZXJmX3B0
KHN2bS0+dmNwdS5rdm0pKQ0KKyAgICAgICAgICAgICAgIHNldF9pbnRlcmNlcHQoc3ZtLCBJTlRF
UkNFUFRfUkRQUlUpOw0KKw0KICAgICAgICBpZiAoIWt2bV9td2FpdF9pbl9ndWVzdChzdm0tPnZj
cHUua3ZtKSkgew0KICAgICAgICAgICAgICAgIHNldF9pbnRlcmNlcHQoc3ZtLCBJTlRFUkNFUFRf
TU9OSVRPUik7DQogICAgICAgICAgICAgICAgc2V0X2ludGVyY2VwdChzdm0sIElOVEVSQ0VQVF9N
V0FJVCk7DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2
bS92bXgvdm14LmMNCmluZGV4IGIwNWUyNzZlMjYyYi4uMjMxNzMyOTI0YzUwIDEwMDY0NA0KLS0t
IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0K
QEAgLTY3NjUsNiArNjc2NSwxMiBAQCBzdGF0aWMgaW50IHZteF9jcmVhdGVfdmNwdShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUpDQogICAgICAgICAgICAgICAgdm14X2Rpc2FibGVfaW50ZXJjZXB0X2Zv
cl9tc3IobXNyX2JpdG1hcCwgTVNSX0NPUkVfQzZfUkVTSURFTkNZLCBNU1JfVFlQRV9SKTsNCiAg
ICAgICAgICAgICAgICB2bXhfZGlzYWJsZV9pbnRlcmNlcHRfZm9yX21zcihtc3JfYml0bWFwLCBN
U1JfQ09SRV9DN19SRVNJREVOQ1ksIE1TUl9UWVBFX1IpOw0KICAgICAgICB9DQorDQorICAgICAg
IGlmIChndWVzdF9tcGVyZmFwZXJmX3B0KHZjcHUtPmt2bSkpIHsNCisgICAgICAgICAgICAgICB2
bXhfZGlzYWJsZV9pbnRlcmNlcHRfZm9yX21zcihtc3JfYml0bWFwLCBNU1JfSUEzMl9NUEVSRiwg
TVNSX1RZUEVfUik7DQorICAgICAgICAgICAgICAgdm14X2Rpc2FibGVfaW50ZXJjZXB0X2Zvcl9t
c3IobXNyX2JpdG1hcCwgTVNSX0lBMzJfQVBFUkYsIE1TUl9UWVBFX1IpOw0KKyAgICAgICB9DQor
DQogICAgICAgIHZteC0+bXNyX2JpdG1hcF9tb2RlID0gMDsNCiANCiAgICAgICAgdm14LT5sb2Fk
ZWRfdm1jcyA9ICZ2bXgtPnZtY3MwMTsNCg0KDQotTGkNCg==
