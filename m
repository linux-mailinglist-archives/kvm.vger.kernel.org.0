Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDD51EF4C8
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 11:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgFEJ56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 05:57:58 -0400
Received: from mx20.baidu.com ([111.202.115.85]:41868 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbgFEJ55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 05:57:57 -0400
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2020 05:57:55 EDT
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id 60E49480401D3B0008F9;
        Fri,  5 Jun 2020 17:41:53 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 5 Jun 2020 17:41:52 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Fri, 5 Jun 2020 17:41:52 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Like Xu <like.xu@linux.intel.com>,
        "like.xu@intel.com" <like.xu@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "xiaoyao.li@intel.com" <xiaoyao.li@intel.com>,
        "wei.huang2@amd.com" <wei.huang2@amd.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF1bdjZdIEtWTTogWDg2OiBzdXBwb3J0?=
 =?utf-8?Q?_APERF/MPERF_registers?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3Y2XSBLVk06IFg4Njogc3VwcG9ydCBBUEVSRi9N?=
 =?utf-8?Q?PERF_registers?=
Thread-Index: AQHWOtrZ4X/t3pkmBEG7o3WCZUgoeKjIxz2AgAChEWD//5ArAIAAyszA
Date:   Fri, 5 Jun 2020 09:41:52 +0000
Message-ID: <c67d15322f9942aa92b6cf57011c0abe@baidu.com>
References: <1591321466-2046-1-git-send-email-lirongqing@baidu.com>
 <be39b88c-bfb7-0634-c53b-f00d8fde643c@intel.com>
 <c21c6ffa19b6483ea57feab3f98f279c@baidu.com>
 <3a88bd63-ff51-ad70-d92e-893660c63bca@linux.intel.com>
In-Reply-To: <3a88bd63-ff51-ad70-d92e-893660c63bca@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.27]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2020-06-05 17:41:53:011
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex14_GRAY_Inside_WithoutAtta_2020-06-05
 17:41:52:917
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IExpa2UgWHUgW21haWx0
bzpsaWtlLnh1QGxpbnV4LmludGVsLmNvbV0NCj4g5Y+R6YCB5pe26Ze0OiAyMDIw5bm0NuaciDXm
l6UgMTM6MjkNCj4g5pS25Lu25Lq6OiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+
OyBsaWtlLnh1QGludGVsLmNvbQ0KPiDmioTpgIE6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHg4NkBrZXJuZWwub3JnOw0KPiBocGFAenl0b3IuY29t
OyBicEBhbGllbjguZGU7IG1pbmdvQHJlZGhhdC5jb207IHRnbHhAbGludXRyb25peC5kZTsNCj4g
am1hdHRzb25AZ29vZ2xlLmNvbTsgd2FucGVuZ2xpQHRlbmNlbnQuY29tOyB2a3V6bmV0c0ByZWRo
YXQuY29tOw0KPiBzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29tOyBwYm9uemluaUByZWRo
YXQuY29tOyB4aWFveWFvLmxpQGludGVsLmNvbTsNCj4gd2VpLmh1YW5nMkBhbWQuY29tDQo+IOS4
u+mimDogUmU6IOetlOWkjTogW1BBVENIXVt2Nl0gS1ZNOiBYODY6IHN1cHBvcnQgQVBFUkYvTVBF
UkYgcmVnaXN0ZXJzDQo+IA0KPiBPbiAyMDIwLzYvNSAxMjoyMywgTGksUm9uZ3Fpbmcgd3JvdGU6
DQo+ID4NCj4gPg0KPiA+PiAtLS0tLemCruS7tuWOn+S7ti0tLS0tDQo+ID4+IOWPkeS7tuS6ujog
WHUsIExpa2UgW21haWx0bzpsaWtlLnh1QGludGVsLmNvbV0NCj4gPj4g5Y+R6YCB5pe26Ze0OiAy
MDIw5bm0NuaciDXml6UgMTA6MzINCj4gPj4g5pS25Lu25Lq6OiBMaSxSb25ncWluZyA8bGlyb25n
cWluZ0BiYWlkdS5jb20+DQo+ID4+IOaKhOmAgTogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zzsga3ZtQHZnZXIua2VybmVsLm9yZzsNCj4gPj4geDg2QGtlcm5lbC5vcmc7IGhwYUB6eXRvci5j
b207IGJwQGFsaWVuOC5kZTsgbWluZ29AcmVkaGF0LmNvbTsNCj4gPj4gdGdseEBsaW51dHJvbml4
LmRlOyBqbWF0dHNvbkBnb29nbGUuY29tOyB3YW5wZW5nbGlAdGVuY2VudC5jb207DQo+ID4+IHZr
dXpuZXRzQHJlZGhhdC5jb207IHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb207DQo+ID4+
IHBib256aW5pQHJlZGhhdC5jb207IHhpYW95YW8ubGlAaW50ZWwuY29tOyB3ZWkuaHVhbmcyQGFt
ZC5jb20NCj4gPj4g5Li76aKYOiBSZTogW1BBVENIXVt2Nl0gS1ZNOiBYODY6IHN1cHBvcnQgQVBF
UkYvTVBFUkYgcmVnaXN0ZXJzDQo+ID4+DQo+ID4+IEhpIFJvbmdRaW5nLA0KPiA+Pg0KPiA+PiBP
biAyMDIwLzYvNSA5OjQ0LCBMaSBSb25nUWluZyB3cm90ZToNCj4gPj4+IEd1ZXN0IGtlcm5lbCBy
ZXBvcnRzIGEgZml4ZWQgY3B1IGZyZXF1ZW5jeSBpbiAvcHJvYy9jcHVpbmZvLCB0aGlzIGlzDQo+
ID4+PiBjb25mdXNlZCB0byB1c2VyIHdoZW4gdHVyYm8gaXMgZW5hYmxlLCBhbmQgYXBlcmYvbXBl
cmYgY2FuIGJlIHVzZWQNCj4gPj4+IHRvIHNob3cgY3VycmVudCBjcHUgZnJlcXVlbmN5IGFmdGVy
IDdkNTkwNWRjMTRhDQo+ID4+PiAiKHg4NiAvIENQVTogQWx3YXlzIHNob3cgY3VycmVudCBDUFUg
ZnJlcXVlbmN5IGluIC9wcm9jL2NwdWluZm8pIg0KPiA+Pj4gc28gZ3Vlc3Qgc2hvdWxkIHN1cHBv
cnQgYXBlcmYvbXBlcmYgY2FwYWJpbGl0eQ0KPiA+Pj4NCj4gPj4+IFRoaXMgcGF0Y2ggaW1wbGVt
ZW50cyBhcGVyZi9tcGVyZiBieSB0aHJlZSBtb2RlOiBub25lLCBzb2Z0d2FyZQ0KPiA+Pj4gZW11
bGF0aW9uLCBhbmQgcGFzcy10aHJvdWdoDQo+ID4+Pg0KPiA+Pj4gTm9uZTogZGVmYXVsdCBtb2Rl
LCBndWVzdCBkb2VzIG5vdCBzdXBwb3J0IGFwZXJmL21wZXJmDQo+ID4+IHMvTm9uZS9Ob3RlDQo+
ID4+Pg0KPiA+Pj4gU29mdHdhcmUgZW11bGF0aW9uOiB0aGUgcGVyaW9kIG9mIGFwZXJmL21wZXJm
IGluIGd1ZXN0IG1vZGUgYXJlDQo+ID4+PiBhY2N1bXVsYXRlZCBhcyBlbXVsYXRlZCB2YWx1ZQ0K
PiA+Pj4NCj4gPj4+IFBhc3MtdGhvdWdoOiBpdCBpcyBvbmx5IHN1aXRhYmxlIGZvciBLVk1fSElO
VFNfUkVBTFRJTUUsIEJlY2F1c2UNCj4gPj4+IHRoYXQgaGludCBndWFyYW50ZWVzIHdlIGhhdmUg
YSAxOjEgdkNQVTpDUFUgYmluZGluZyBhbmQgZ3VhcmFudGVlZA0KPiA+Pj4gbm8gb3Zlci1jb21t
aXQuDQo+ID4+IFRoZSBmbGFnICJLVk1fSElOVFNfUkVBTFRJTUUgMCIgKGluIHRoZQ0KPiA+PiBE
b2N1bWVudGF0aW9uL3ZpcnQva3ZtL2NwdWlkLnJzdCkgaXMgY2xhaW1lZCBhcyAiZ3Vlc3QgY2hl
Y2tzIHRoaXMNCj4gPj4gZmVhdHVyZSBiaXQgdG8gZGV0ZXJtaW5lIHRoYXQgdkNQVXMgYXJlIG5l
dmVyIHByZWVtcHRlZCBmb3IgYW4gdW5saW1pdGVkDQo+IHRpbWUgYWxsb3dpbmcgb3B0aW1pemF0
aW9ucyIuDQo+ID4+DQo+ID4+IEkgY291bGRuJ3Qgc2VlIGl0cyByZWxhdGlvbnNoaXAgd2l0aCAi
MToxIHZDUFU6IHBDUFUgYmluZGluZyIuDQo+ID4+IFRoZSBwYXRjaCBkb2Vzbid0IGNoZWNrIHRo
aXMgZmxhZyBhcyB3ZWxsIGZvciB5b3VyIHBhc3MtdGhyb3VnaCBwdXJwb3NlLg0KPiA+Pg0KPiA+
PiBUaGFua3MsDQo+ID4+IExpa2UgWHUNCj4gPg0KPiA+DQo+ID4gSSB0aGluayB0aGlzIGlzIHVz
ZXIgc3BhY2Ugam9icyB0byBiaW5kIEhJTlRfUkVBTFRJTUUgYW5kIG1wZXJmIHBhc3N0aHJvdWdo
LA0KPiBLVk0ganVzdCBkbyB3aGF0IHVzZXJzcGFjZSB3YW50cy4NCj4gPg0KPiANCj4gVGhhdCdz
IGZpbmUgZm9yIHVzZXIgc3BhY2UgdG8gYmluZCBISU5UX1JFQUxUSU1FIGFuZCBtcGVyZiBwYXNz
dGhyb3VnaO+8jA0KPiBCdXQgSSB3YXMgYXNraW5nIHdoeSBISU5UX1JFQUxUSU1FIG1lYW5zICIx
OjEgdkNQVTogcENQVSBiaW5kaW5nIi4NCj4gDQo+IEFzIHlvdSBzYWlkLCAiUGFzcy10aG91Z2g6
IGl0IGlzIG9ubHkgc3VpdGFibGUgZm9yIEtWTV9ISU5UU19SRUFMVElNRSIsIHdoaWNoDQo+IG1l
YW5zLCBLVk0gbmVlZHMgdG8gbWFrZSBzdXJlIHRoZSBrdm0tPmFyY2guYXBlcmZtcGVyZl9tb2Rl
IHZhbHVlIGNvdWxkDQo+ICJvbmx5IiBiZSBzZXQgdG8gS1ZNX0FQRVJGTVBFUkZfUFQgd2hlbiB0
aGUgY2hlY2sNCj4ga3ZtX3BhcmFfaGFzX2hpbnQoS1ZNX0hJTlRTX1JFQUxUSU1FKSBpcyBwYXNz
ZWQuDQo+IA0KDQpwaW5pbmcgdmNwdSBjYW4gZW5zdXJlIHRoYXQgZ3Vlc3QgZ2V0IGNvcnJlY3Qg
bXBlcmYvYXBlcmYsIGJ1dCBhIHVzZXINCmhhcyB0aGUgY2hvaWNlIHRvIG5vdCBwaW4sIGF0IHRo
YXQgY29uZGl0aW9uLCBkbyBub3QgdGhpbmsgaXQgaXMgYnVnLCB0aGlzIHdhbnRzIHRvIHNheQ0K
DQo+IFNwZWNpZmljYWxseSwgdGhlIEtWTV9ISU5UU19SRUFMVElNRSBpcyBhIHBlci1rdm0gY2Fw
YWJpbGl0eSB3aGlsZSB0aGUNCj4ga3ZtX2FwZXJmbXBlcmZfbW9kZSBpcyBhIHBlci12bSBjYXBh
YmlsaXR5LiBJdCdzIHVucmVzb2x2ZWQuDQo+IA0KDQpEbyB5b3UgaGF2ZSBhbnkgc29sdXRpb24/
DQoNCi1Sb25ncWluZw0KDQo+IEtWTSBkb2Vzbid0IGFsd2F5cyBkbyB3aGF0IHVzZXJzcGFjZSB3
YW50cyBlc3BlY2lhbGx5IHlvdSdyZSB0cnlpbmcgdG8NCj4gZXhwb3NlIHNvbWUgZmVhdHVyZXMg
YWJvdXQgcG93ZXIgYW5kIHRoZXJtYWwgbWFuYWdlbWVudCBpbiB0aGUNCj4gdmlydHVhbGl6YXRp
b24gY29udGV4dC4NCj4gDQo+ID4gYW5kIHRoaXMgZ2l2ZXMgdXNlciBzcGFjZSBhIHBvc3NpYmls
aXR5LCBndWVzdCBoYXMgcGFzc3Rocm91Z2gNCj4gPiBtcGVyZmFwZXJmIHdpdGhvdXQgSElOVF9S
RUFMVElNRSwgZ3Vlc3QgY2FuIGdldCBjb2Fyc2UgY3B1IGZyZXF1ZW5jeQ0KPiA+IHdpdGhvdXQg
cGVyZm9ybWFuY2UgZWZmZWN0IGlmIGd1ZXN0IGNhbiBlbmR1cmUgZXJyb3IgZnJlcXVlbmN5DQo+
ID4gb2NjYXNpb25hbGx5DQo+ID4NCj4gDQo+IA0KPiA+DQo+ID4gLUxpDQo+ID4NCg0K
