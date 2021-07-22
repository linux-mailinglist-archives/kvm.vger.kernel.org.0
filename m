Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD4D3D1EB6
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 09:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhGVGa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 02:30:26 -0400
Received: from mx21.baidu.com ([220.181.3.85]:57046 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229969AbhGVGaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 02:30:24 -0400
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id 66883EBB53FD7BC60DC8;
        Thu, 22 Jul 2021 15:10:55 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 22 Jul 2021 15:10:55 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Thu, 22 Jul 2021 15:10:55 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogQ29uc2lkZXIgU01UIGlkbGUgc3RhdHVz?=
 =?utf-8?Q?_when_halt_polling?=
Thread-Topic: [PATCH] KVM: Consider SMT idle status when halt polling
Thread-Index: AQHXfr4fbqZtloIq0E2JewUw/QgE86tOkBDQ
Date:   Thu, 22 Jul 2021 07:10:55 +0000
Message-ID: <1c26ad3589f8495f9f30fdab485d353d@baidu.com>
References: <20210722035807.36937-1-lirongqing@baidu.com>
 <CANRm+Cx-5Yyxx5A4+qkYa01MG4BCdwXPd++bmxzOid+XL267cQ@mail.gmail.com>
In-Reply-To: <CANRm+Cx-5Yyxx5A4+qkYa01MG4BCdwXPd++bmxzOid+XL267cQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.194.42]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex13_2021-07-22 15:10:55:398
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFdhbnBlbmcgTGkgPGtl
cm5lbGx3cEBnbWFpbC5jb20+DQo+IOWPkemAgeaXtumXtDogMjAyMeW5tDfmnIgyMuaXpSAxMzo1
NQ0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4g5oqE
6YCBOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPjsgSW5nbyBNb2xuYXINCj4g
PG1pbmdvQHJlZGhhdC5jb20+OyBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+
OyBrdm0NCj4gPGt2bUB2Z2VyLmtlcm5lbC5vcmc+OyBMS01MIDxsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnPg0KPiDkuLvpopg6IFJlOiBbUEFUQ0hdIEtWTTogQ29uc2lkZXIgU01UIGlkbGUg
c3RhdHVzIHdoZW4gaGFsdCBwb2xsaW5nDQo+IA0KPiBPbiBUaHUsIDIyIEp1bCAyMDIxIGF0IDEy
OjA3LCBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+IHdyb3RlOg0KPiA+DQo+ID4g
U01UIHNpYmxpbmdzIHNoYXJlIGNhY2hlcyBhbmQgb3RoZXIgaGFyZHdhcmUsIGhhbHQgcG9sbGlu
ZyB3aWxsDQo+ID4gZGVncmFkZSBpdHMgc2libGluZyBwZXJmb3JtYW5jZSBpZiBpdHMgc2libGlu
ZyBpcyBidXN5DQo+IA0KPiBEbyB5b3UgaGF2ZSBhbnkgcmVhbCBzY2VuYXJpbyBiZW5lZml0cz8g
QXMgdGhlIHBvbGxpbmcgbmF0dXJlLCBzb21lIGNsb3VkDQo+IHByb3ZpZGVycyB3aWxsIGNvbmZp
Z3VyZSB0byB0aGVpciBwcmVmZXJyZWQgYmFsYW5jZSBvZiBjcHUgdXNhZ2UgYW5kDQo+IHBlcmZv
cm1hbmNlLCBhbmQgb3RoZXIgY2xvdWQgcHJvdmlkZXJzIGZvciB0aGVpciBORlYgc2NlbmFyaW9z
IHdoaWNoIGFyZSBtb3JlDQo+IHNlbnNpdGl2ZSB0byBsYXRlbmN5IGFyZSB2Q1BVIGFuZCBwQ1BV
IDE6MSBwaW7vvIx5b3UNCj4gZGVzdHJveSB0aGVzZSBzZXR1cHMuDQo+DQo+ICAgICBXYW5wZW5n
DQoNClRydWUsIGl0IGJlbmVmaXRzIGZvciBvdXIgcmVhbCBzY2VuYXJpby4NCg0KdGhpcyBwYXRj
aCBjYW4gbG93ZXIgb3VyIHdvcmtsb2FkIGNvbXB1dGUgbGF0ZW5jeSBpbiBvdXIgbXVsdGlwbGUg
Y29yZXMgVk0gd2hpY2ggdkNQVSBhbmQgcENQVSBpcyAxOjEgcGluLCBhbmQgdGhlIHdvcmtsb2Fk
IHdpdGggbG90cyBvZiBjb21wdXRhdGlvbiBhbmQgbmV0d29ya2luZyBwYWNrZXRzLg0KDQotTGkN
Cg==
