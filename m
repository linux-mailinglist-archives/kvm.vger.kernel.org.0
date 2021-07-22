Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AC43D2336
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 14:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhGVLgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 07:36:23 -0400
Received: from mx21.baidu.com ([220.181.3.85]:34472 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231724AbhGVLgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 07:36:23 -0400
Received: from BC-Mail-Ex25.internal.baidu.com (unknown [172.31.51.19])
        by Forcepoint Email with ESMTPS id 7A46AD832354F75AE26A;
        Thu, 22 Jul 2021 20:16:54 +0800 (CST)
Received: from BJHW-Mail-Ex16.internal.baidu.com (10.127.64.39) by
 BC-Mail-Ex25.internal.baidu.com (172.31.51.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Thu, 22 Jul 2021 20:16:54 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex16.internal.baidu.com (10.127.64.39) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 22 Jul 2021 20:16:54 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Thu, 22 Jul 2021 20:16:54 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogQ29uc2lkZXIgU01UIGlkbGUgc3RhdHVz?=
 =?utf-8?Q?_when_halt_polling?=
Thread-Topic: [PATCH] KVM: Consider SMT idle status when halt polling
Thread-Index: AQHXfr4fbqZtloIq0E2JewUw/QgE86tOkBDQgABUwoA=
Date:   Thu, 22 Jul 2021 12:16:53 +0000
Message-ID: <4efe4fdb91b747da93d7980c10d016c9@baidu.com>
References: <20210722035807.36937-1-lirongqing@baidu.com>
 <CANRm+Cx-5Yyxx5A4+qkYa01MG4BCdwXPd++bmxzOid+XL267cQ@mail.gmail.com> 
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.194.42]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex16_2021-07-22 20:16:54:183
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ID4gU01UIHNpYmxpbmdzIHNoYXJlIGNhY2hlcyBhbmQgb3RoZXIgaGFyZHdhcmUsIGhhbHQg
cG9sbGluZyB3aWxsDQo+ID4gPiBkZWdyYWRlIGl0cyBzaWJsaW5nIHBlcmZvcm1hbmNlIGlmIGl0
cyBzaWJsaW5nIGlzIGJ1c3kNCj4gPg0KPiA+IERvIHlvdSBoYXZlIGFueSByZWFsIHNjZW5hcmlv
IGJlbmVmaXRzPyBBcyB0aGUgcG9sbGluZyBuYXR1cmUsIHNvbWUNCj4gPiBjbG91ZCBwcm92aWRl
cnMgd2lsbCBjb25maWd1cmUgdG8gdGhlaXIgcHJlZmVycmVkIGJhbGFuY2Ugb2YgY3B1IHVzYWdl
DQo+ID4gYW5kIHBlcmZvcm1hbmNlLCBhbmQgb3RoZXIgY2xvdWQgcHJvdmlkZXJzIGZvciB0aGVp
ciBORlYgc2NlbmFyaW9zDQo+ID4gd2hpY2ggYXJlIG1vcmUgc2Vuc2l0aXZlIHRvIGxhdGVuY3kg
YXJlIHZDUFUgYW5kIHBDUFUgMToxIHBpbu+8jHlvdQ0KPiA+IGRlc3Ryb3kgdGhlc2Ugc2V0dXBz
Lg0KPiA+DQo+ID4gICAgIFdhbnBlbmcNCj4gDQoNCg0KUnVuIGEgY29weSAoc2luZ2xlIHRocmVh
ZCkgVW5peGJlbmNoLCB3aXRoIG9yIHdpdGhvdXQgYSBidXN5IHBvbGwgcHJvZ3JhbSBpbiBpdHMg
U01UIHNpYmxpbmcsICBhbmQgVW5peGJlbmNoIHNjb3JlIGNhbiBsb3dlciAxLzMgd2l0aCBTTVQg
YnVzeSBwb2xsaW5nIHByb2dyYW0NCg0KQ2FuIHRoaXMgY2FzZSBzaG93IHRoaXMgaXNzdWU/DQoN
Ci1MaSANCg0KDQo+IFRydWUsIGl0IGJlbmVmaXRzIGZvciBvdXIgcmVhbCBzY2VuYXJpby4NCj4g
DQo+IHRoaXMgcGF0Y2ggY2FuIGxvd2VyIG91ciB3b3JrbG9hZCBjb21wdXRlIGxhdGVuY3kgaW4g
b3VyIG11bHRpcGxlIGNvcmVzIFZNDQo+IHdoaWNoIHZDUFUgYW5kIHBDUFUgaXMgMToxIHBpbiwg
YW5kIHRoZSB3b3JrbG9hZCB3aXRoIGxvdHMgb2YgY29tcHV0YXRpb24gYW5kDQo+IG5ldHdvcmtp
bmcgcGFja2V0cy4NCj4gDQo+IC1MaQ0K
