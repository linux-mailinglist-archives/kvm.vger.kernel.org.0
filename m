Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582DA1B8DED
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 10:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgDZIas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 04:30:48 -0400
Received: from mx22.baidu.com ([220.181.50.185]:50150 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726141AbgDZIas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 04:30:48 -0400
Received: from Bc-Mail-Ex13.internal.baidu.com (unknown [172.31.51.53])
        by Forcepoint Email with ESMTPS id 0CDCC1A3C048E6D289AF;
        Sun, 26 Apr 2020 16:30:27 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.51.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Sun, 26 Apr 2020 16:30:26 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Sun, 26 Apr 2020 16:30:26 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Peter Zijlstra <peterz@infradead.org>
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
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBbUkZDXSBrdm06IHg4NjogZW11bGF0ZSBBUEVSRi9N?=
 =?gb2312?Q?PERF_registers?=
Thread-Topic: [PATCH] [RFC] kvm: x86: emulate APERF/MPERF registers
Thread-Index: AQHWGh9bZdasuQhOo023NQfHi2P1S6iLC0mA
Date:   Sun, 26 Apr 2020 08:30:26 +0000
Message-ID: <4fecc02b00f6469e81ffc40de4f7188c@baidu.com>
References: <1587704935-30960-1-git-send-email-lirongqing@baidu.com>
 <20200424100143.GZ20730@hirez.programming.kicks-ass.net>
In-Reply-To: <20200424100143.GZ20730@hirez.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.27]
x-baidu-bdmsfe-datecheck: 1_Bc-Mail-Ex13_2020-04-26 16:30:26:950
x-baidu-bdmsfe-viruscheck: Bc-Mail-Ex13_GRAY_Inside_WithoutAtta_2020-04-26
 16:30:26:919
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gQnV0IHRoZW4gaGVyZSB5b3Ugb25seSBlbXVsYXRlIGl0IGZvciBWTVgsIHdoaWNoIHRo
ZW4gcmVzdWx0cyBpbiBTVk0gZ3Vlc3RzDQo+IGdvaW5nIHdvYmJseS4NCj4gDQo+IEFsc28sIG9u
IEludGVsLCB0aGUgbW9tZW50IHlvdSBhZHZlcnRpc2UgQVBFUkZNUEVSRiwgd2UnbGwgdHJ5IGFu
ZCByZWFkDQo+IE1TUl9QTEFURk9STV9JTkZPIC8gTVNSX1RVUkJPX1JBVElPX0xJTUlUKiwgSSBk
b24ndCBzdXBwb3NlIHlvdSdyZQ0KPiBwYXNzaW5nIHRob3NlIHRocm91Z2ggYXMgd2VsbD8NCj4g
DQoNCmluaXRfZnJlcV9pbnZhcmlhbmNlKHZvaWQpIGlzIHRyeWluZyByZWFkIE1TUl9QTEFURk9S
TV9JTkZPIC8gTVNSX1RVUkJPX1JBVElPX0xJTUlUKiwNCnNob3VsZCB3ZSBhZGQgYSBjaGVjayBv
ZiB0dXJibyBzdGF0dXMgaW4gaW5pdF9mcmVxX2ludmFyaWFuY2UsIHRvIGF2b2lkIHRoZSByZWFk
aW5nPw0KDQpJdCBpcyB1bm5lY2Vzc2FyeSB0byBjYWxsIGludGVsX3NldF9tYXhfZnJlcV9yYXRp
byAgSWYgdHVyYm8gaXMgZGlzYWJsZWQNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9z
bXBib290LmMgYi9hcmNoL3g4Ni9rZXJuZWwvc21wYm9vdC5jDQppbmRleCBmZTNhYjk2MzJmM2Iu
LjU0ZmI4ODMyMzI5MyAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2tlcm5lbC9zbXBib290LmMNCisr
KyBiL2FyY2gveDg2L2tlcm5lbC9zbXBib290LmMNCkBAIC0yMDA5LDYgKzIwMDksOSBAQCBzdGF0
aWMgdm9pZCBpbml0X2ZyZXFfaW52YXJpYW5jZSh2b2lkKQ0KICAgICAgICBpZiAoc21wX3Byb2Nl
c3Nvcl9pZCgpICE9IDAgfHwgIWJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9BUEVSRk1QRVJGKSkN
CiAgICAgICAgICAgICAgICByZXR1cm47DQogDQorICAgICAgIGlmICh0dXJib19kaXNhYmxlZCgp
KQ0KKyAgICAgICAgICAgICAgIHJldHVybjsNCisNCiAgICAgICAgaWYgKGJvb3RfY3B1X2RhdGEu
eDg2X3ZlbmRvciA9PSBYODZfVkVORE9SX0lOVEVMKQ0KICAgICAgICAgICAgICAgIHJldCA9IGlu
dGVsX3NldF9tYXhfZnJlcV9yYXRpbygpOw0KDQotTGkNCg==
