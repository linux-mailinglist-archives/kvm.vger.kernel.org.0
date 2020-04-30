Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB401BF47E
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 11:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgD3JuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 05:50:13 -0400
Received: from mx21.baidu.com ([220.181.3.85]:46522 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726378AbgD3JuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 05:50:13 -0400
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id 8351B6C481A756A52BD6;
        Thu, 30 Apr 2020 17:50:08 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 30 Apr 2020 17:50:08 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 30 Apr 2020 17:50:08 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBrdm06IHg4NjogZW11bGF0ZSBBUEVSRi9N?=
 =?utf-8?Q?PERF_registers?=
Thread-Topic: [PATCH][v2] kvm: x86: emulate APERF/MPERF registers
Thread-Index: AQHWHrt7axq7VoyE2kqvmC7wjQtzhaiRZ5mw
Date:   Thu, 30 Apr 2020 09:50:08 +0000
Message-ID: <cc0892c8066e421aba3a603edaf0a39a@baidu.com>
References: <1588139196-23802-1-git-send-email-lirongqing@baidu.com>
 <5aa01c91-b874-fd4f-a1fb-1d008753ca84@intel.com>
In-Reply-To: <5aa01c91-b874-fd4f-a1fb-1d008753ca84@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.11]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2020-04-30 17:50:08:270
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex14_GRAY_Inside_WithoutAtta_2020-04-30
 17:50:08:239
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFhpYW95YW8gTGkgW21h
aWx0bzp4aWFveWFvLmxpQGludGVsLmNvbV0NCj4g5Y+R6YCB5pe26Ze0OiAyMDIw5bm0NOaciDMw
5pelIDE0OjQ5DQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29t
PjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsg
eDg2QGtlcm5lbC5vcmc7IGhwYUB6eXRvci5jb207IGJwQGFsaWVuOC5kZTsNCj4gbWluZ29AcmVk
aGF0LmNvbTsgdGdseEBsaW51dHJvbml4LmRlOyBqb3JvQDhieXRlcy5vcmc7DQo+IGptYXR0c29u
QGdvb2dsZS5jb207IHdhbnBlbmdsaUB0ZW5jZW50LmNvbTsgdmt1em5ldHNAcmVkaGF0LmNvbTsN
Cj4gc2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbTsgcGJvbnppbmlAcmVkaGF0LmNvbQ0K
PiDkuLvpopg6IFJlOiBbUEFUQ0hdW3YyXSBrdm06IHg4NjogZW11bGF0ZSBBUEVSRi9NUEVSRiBy
ZWdpc3RlcnMNCj4gDQo+IE9uIDQvMjkvMjAyMCAxOjQ2IFBNLCBMaSBSb25nUWluZyB3cm90ZToN
Cj4gPiBHdWVzdCBrZXJuZWwgcmVwb3J0cyBhIGZpeGVkIGNwdSBmcmVxdWVuY3kgaW4gL3Byb2Mv
Y3B1aW5mbywgdGhpcyBpcw0KPiA+IGNvbmZ1c2VkIHRvIHVzZXIgd2hlbiB0dXJibyBpcyBlbmFi
bGUsIGFuZCBhcGVyZi9tcGVyZiBjYW4gYmUgdXNlZCB0bw0KPiA+IHNob3cgY3VycmVudCBjcHUg
ZnJlcXVlbmN5IGFmdGVyIDdkNTkwNWRjMTRhDQo+ID4gIih4ODYgLyBDUFU6IEFsd2F5cyBzaG93
IGN1cnJlbnQgQ1BVIGZyZXF1ZW5jeSBpbiAvcHJvYy9jcHVpbmZvKSINCj4gPiBzbyB3ZSBzaG91
bGQgZW11bGF0ZSBhcGVyZiBtcGVyZiB0byBhY2hpZXZlIGl0DQo+ID4NCj4gPiB0aGUgcGVyaW9k
IG9mIGFwZXJmL21wZXJmIGluIGd1ZXN0IG1vZGUgYXJlIGFjY3VtdWxhdGVkIGFzIGVtdWxhdGVk
DQo+ID4gdmFsdWUsIGFuZCBhZGQgcGVyLVZNIGtub2QgdG8gZW5hYmxlIGVtdWxhdGUgbXBlcmZh
cGVyZg0KPiA+DQo+ID4gZGlmZiB2MToNCj4gPiAxLiBzdXBwb3J0IEFNRA0KPiA+IDIuIHN1cHBv
cnQgcGVyLXZtIGNhcGFiaWxpdHkgdG8gZW5hYmxlDQo+ID4NCj4gWy4uLl0NCj4gPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jIGluZGV4DQo+ID4g
ODUxZTljYzc5OTMwLi4xZDE1N2E4ZGJhNDYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3Zt
L3N2bS5jDQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3N2bS5jDQo+ID4gQEAgLTQzMTAsNiArNDMx
MCwxMiBAQCBzdGF0aWMgaW50IHN2bV9nZXRfbXNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4g
c3RydWN0IG1zcl9kYXRhICptc3JfaW5mbykNCj4gPiAgIAljYXNlIE1TUl9GMTBIX0RFQ0ZHOg0K
PiA+ICAgCQltc3JfaW5mby0+ZGF0YSA9IHN2bS0+bXNyX2RlY2ZnOw0KPiA+ICAgCQlicmVhazsN
Cj4gPiArCWNhc2UgTVNSX0lBMzJfTVBFUkY6DQo+ID4gKwkJbXNyX2luZm8tPmRhdGEgPSB2Y3B1
LT5hcmNoLnZfbXBlcmY7DQo+ID4gKwkJYnJlYWs7DQo+ID4gKwljYXNlIE1TUl9JQTMyX0FQRVJG
Og0KPiA+ICsJCW1zcl9pbmZvLT5kYXRhID0gdmNwdS0+YXJjaC52X2FwZXJmOw0KPiA+ICsJCWJy
ZWFrOw0KPiA+ICAgCWRlZmF1bHQ6DQo+ID4gICAJCXJldHVybiBrdm1fZ2V0X21zcl9jb21tb24o
dmNwdSwgbXNyX2luZm8pOw0KPiA+ICAgCX0NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMgaW5kZXgNCj4gPiA5MTc0OWYxMjU0
ZTguLmIwNWUyNzZlMjYyYiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5j
DQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+IEBAIC0xOTE0LDYgKzE5MTQs
MTIgQEAgc3RhdGljIGludCB2bXhfZ2V0X21zcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+IHN0
cnVjdCBtc3JfZGF0YSAqbXNyX2luZm8pDQo+ID4gICAJCSAgICAhZ3Vlc3RfY3B1aWRfaGFzKHZj
cHUsIFg4Nl9GRUFUVVJFX1JEVFNDUCkpDQo+ID4gICAJCQlyZXR1cm4gMTsNCj4gPiAgIAkJZ290
byBmaW5kX3NoYXJlZF9tc3I7DQo+ID4gKwljYXNlIE1TUl9JQTMyX01QRVJGOg0KPiA+ICsJCW1z
cl9pbmZvLT5kYXRhID0gdmNwdS0+YXJjaC52X21wZXJmOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJ
Y2FzZSBNU1JfSUEzMl9BUEVSRjoNCj4gPiArCQltc3JfaW5mby0+ZGF0YSA9IHZjcHUtPmFyY2gu
dl9hcGVyZjsNCj4gPiArCQlicmVhazsNCj4gDQo+IFRoZXkgYXJlIHNhbWUgZm9yIGJvdGggdm14
IGFuZCBzdm0sIHlvdSBjYW4gcHV0IHRoZW0gaW4NCj4ga3ZtX2dldF9tc3JfY29tbW9uKCkNCj4g
DQoNCk9rDQoNCj4gQlRXLCBhcmUgdGhvc2UgdHdvIE1TUiBhbHdheXMgcmVhZGFibGUgcmVnYXJk
bGVzcyBvZiBndWVzdCdzIENQVUlEPw0KDQpJdCBzaG91bGQgYmUsIG5vdCBzdXJlIGlmIHRoZXJl
IGlzIGFibm9ybWFsDQoNCnRoYW5rcw0KLUxpUm9uZ1FpbmcNCg0KPiA+ICAgCWRlZmF1bHQ6DQo+
ID4gICAJZmluZF9zaGFyZWRfbXNyOg0KPiA+ICAgCQltc3IgPSBmaW5kX21zcl9lbnRyeSh2bXgs
IG1zcl9pbmZvLT5pbmRleCk7DQo+IA0KDQo=
