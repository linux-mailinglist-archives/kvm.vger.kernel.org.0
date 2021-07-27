Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB983D6F8E
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 08:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhG0GkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 02:40:03 -0400
Received: from mx20.baidu.com ([111.202.115.85]:56166 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234349AbhG0GkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 02:40:02 -0400
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 674A8B6713C6F3DA0DD3;
        Tue, 27 Jul 2021 14:39:58 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 27 Jul 2021 14:39:58 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Tue, 27 Jul 2021 14:39:58 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF0gS1ZNOiBDb25zaWRlciBTTVQgaWRs?=
 =?utf-8?Q?e_status_when_halt_polling?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogQ29uc2lkZXIgU01UIGlkbGUgc3RhdHVz?=
 =?utf-8?Q?_when_halt_polling?=
Thread-Index: AQHXfr4fbqZtloIq0E2JewUw/QgE86tOkBDQgABUwoCABqQwgIAA3MfA
Date:   Tue, 27 Jul 2021 06:39:58 +0000
Message-ID: <e68a267a328648c484132bafd022671c@baidu.com>
References: <20210722035807.36937-1-lirongqing@baidu.com>
 <CANRm+Cx-5Yyxx5A4+qkYa01MG4BCdwXPd++bmxzOid+XL267cQ@mail.gmail.com>
 <4efe4fdb91b747da93d7980c10d016c9@baidu.com> <YP9gkSk+CHdKLP/Q@google.com>
In-Reply-To: <YP9gkSk+CHdKLP/Q@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.193.253]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFNlYW4gQ2hyaXN0b3Bo
ZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiDlj5HpgIHml7bpl7Q6IDIwMjHlubQ35pyIMjfm
l6UgOToyNg0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4N
Cj4g5oqE6YCBOiBXYW5wZW5nIExpIDxrZXJuZWxsd3BAZ21haWwuY29tPjsgUGFvbG8gQm9uemlu
aQ0KPiA8cGJvbnppbmlAcmVkaGF0LmNvbT47IEluZ28gTW9sbmFyIDxtaW5nb0ByZWRoYXQuY29t
PjsgUGV0ZXIgWmlqbHN0cmENCj4gPHBldGVyekBpbmZyYWRlYWQub3JnPjsga3ZtIDxrdm1Admdl
ci5rZXJuZWwub3JnPjsgTEtNTA0KPiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz4NCj4g
5Li76aKYOiBSZTog562U5aSNOiBbUEFUQ0hdIEtWTTogQ29uc2lkZXIgU01UIGlkbGUgc3RhdHVz
IHdoZW4gaGFsdCBwb2xsaW5nDQo+IA0KPiBSYXRoZXIgdGhhbiBkaXNhbGxvd2luZyBoYWx0LXBv
bGxpbmcgZW50aXJlbHksIG9uIHg4NiBpdCBzaG91bGQgYmUgc3VmZmljaWVudCB0bw0KPiBzaW1w
bHkgaGF2ZSB0aGUgaGFyZHdhcmUgdGhyZWFkIHlpZWxkIHRvIGl0cyBzaWJsaW5nKHMpIHZpYSBQ
QVVTRS4gIEl0IHByb2JhYmx5DQo+IHdvbid0IGdldCBiYWNrIGFsbCBwZXJmb3JtYW5jZSwgYnV0
IEkgd291bGQgZXhwZWN0IGl0IHRvIGJlIGNsb3NlLg0KPiANCj4gVGhpcyBjb21waWxlcyBvbiBh
bGwgS1ZNIGFyY2hpdGVjdHVyZXMsIGFuZCBBRkFJQ1QgdGhlIGludGVuZGVkIHVzYWdlIG9mDQo+
IGNwdV9yZWxheCgpIGlzIGlkZW50aWNhbCBmb3IgYWxsIGFyY2hpdGVjdHVyZXMuDQo+IA0KDQpS
ZWFzb25hYmxlLCB0aGFua3MsIEkgd2lsbCByZXNlbmQgaXQNCg0KLUxpDQoNCg0KPiBkaWZmIC0t
Z2l0IGEvdmlydC9rdm0va3ZtX21haW4uYyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMgaW5kZXgNCj4g
Njk4MGRhYmU5ZGY1Li5hMDdlY2IzYzY3ZmIgMTAwNjQ0DQo+IC0tLSBhL3ZpcnQva3ZtL2t2bV9t
YWluLmMNCj4gKysrIGIvdmlydC9rdm0va3ZtX21haW4uYw0KPiBAQCAtMzExMSw2ICszMTExLDcg
QEAgdm9pZCBrdm1fdmNwdV9ibG9jayhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgIH0NCj4gICAgICAgICAgICAgICAgICAgICAgICAgcG9sbF9lbmQgPSBjdXIgPSBrdGltZV9n
ZXQoKTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgY3B1X3JlbGF4KCk7DQo+ICAgICAgICAg
ICAgICAgICB9IHdoaWxlIChrdm1fdmNwdV9jYW5fcG9sbChjdXIsIHN0b3ApKTsNCj4gICAgICAg
ICB9DQo+IA0KDQo=
