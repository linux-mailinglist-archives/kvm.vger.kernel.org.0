Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C271B8BB1
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 05:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgDZDjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 23:39:47 -0400
Received: from mx22.baidu.com ([220.181.50.185]:57196 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725945AbgDZDjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 23:39:47 -0400
X-Greylist: delayed 1025 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Apr 2020 23:39:46 EDT
Received: from BJHW-Mail-Ex15.internal.baidu.com (unknown [10.127.64.38])
        by Forcepoint Email with ESMTPS id B363084C3B2F5DB7D264;
        Sun, 26 Apr 2020 11:24:13 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sun, 26 Apr 2020 11:24:13 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Sun, 26 Apr 2020 11:24:13 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "Borislav Petkov" <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIFtSRkNdIGt2bTogeDg2OiBlbXVsYXRlIEFQRVJG?=
 =?utf-8?Q?/MPERF_registers?=
Thread-Topic: [PATCH] [RFC] kvm: x86: emulate APERF/MPERF registers
Thread-Index: AQHWGh9bZdasuQhOo023NQfHi2P1S6iH0+aAgAAbkwCAAAF0AIACzsUw
Date:   Sun, 26 Apr 2020 03:24:13 +0000
Message-ID: <fd2a8092edf54a85979e5781dc354690@baidu.com>
References: <1587704935-30960-1-git-send-email-lirongqing@baidu.com>
 <20200424100143.GZ20730@hirez.programming.kicks-ass.net>
 <20200424144625.GB30013@linux.intel.com>
 <CALMp9eQtSrZMRQtxa_Z5WmjayWzJYhSrpNkQbqK5b7Ufxg-cMA@mail.gmail.com>
 <ce51d5f9-aa7b-233b-883d-802d9b00e090@redhat.com>
In-Reply-To: <ce51d5f9-aa7b-233b-883d-802d9b00e090@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.27]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex15_2020-04-26 11:24:13:665
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex15_GRAY_Inside_WithoutAtta_2020-04-26
 11:24:13:634
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFBhb2xvIEJvbnppbmkg
W21haWx0bzpwYm9uemluaUByZWRoYXQuY29tXQ0KPiDlj5HpgIHml7bpl7Q6IDIwMjDlubQ05pyI
MjXml6UgMDozMA0KPiDmlLbku7bkuro6IEppbSBNYXR0c29uIDxqbWF0dHNvbkBnb29nbGUuY29t
PjsgU2VhbiBDaHJpc3RvcGhlcnNvbg0KPiA8c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNv
bT4NCj4g5oqE6YCBOiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+OyBMaSxS
b25ncWluZw0KPiA8bGlyb25ncWluZ0BiYWlkdS5jb20+OyBMS01MIDxsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnPjsga3ZtIGxpc3QNCj4gPGt2bUB2Z2VyLmtlcm5lbC5vcmc+OyB0aGUgYXJj
aC94ODYgbWFpbnRhaW5lcnMgPHg4NkBrZXJuZWwub3JnPjsgSCAuDQo+IFBldGVyIEFudmluIDxo
cGFAenl0b3IuY29tPjsgQm9yaXNsYXYgUGV0a292IDxicEBhbGllbjguZGU+OyBJbmdvIE1vbG5h
cg0KPiA8bWluZ29AcmVkaGF0LmNvbT47IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4
LmRlPjsgSm9lcmcgUm9lZGVsDQo+IDxqb3JvQDhieXRlcy5vcmc+OyBXYW5wZW5nIExpIDx3YW5w
ZW5nbGlAdGVuY2VudC5jb20+OyBWaXRhbHkgS3V6bmV0c292DQo+IDx2a3V6bmV0c0ByZWRoYXQu
Y29tPg0KPiDkuLvpopg6IFJlOiBbUEFUQ0hdIFtSRkNdIGt2bTogeDg2OiBlbXVsYXRlIEFQRVJG
L01QRVJGIHJlZ2lzdGVycw0KPiANCj4gT24gMjQvMDQvMjAgMTg6MjUsIEppbSBNYXR0c29uIHdy
b3RlOg0KPiA+PiBBc3N1bWluZyB3ZSdyZSBnb2luZyBmb3J3YXJkIHdpdGggdGhpcywgYXQgYW4g
YWJzb2x1dGUgbWluaW11bSB0aGUNCj4gPj4gUkRNU1JzIG5lZWQgdG8gYmUgd3JhcHBlZCB3aXRo
IGNoZWNrcyBvbiBob3N0IF9hbmRfIGd1ZXN0IHN1cHBvcnQgZm9yDQo+ID4+IHRoZSBlbXVsYXRl
ZCBiZWhhdmlvci4gIEdpdmVuIHRoZSBzaWduaWZpY2FudCBvdmVyaGVhZCwgdGhpcyBtaWdodA0K
PiA+PiBldmVuIGJlIHNvbWV0aGluZyB0aGF0IHNob3VsZCByZXF1aXJlIGFuIGV4dHJhIG9wdC1p
biBmcm9tIHVzZXJzcGFjZSB0bw0KPiBlbmFibGUuDQo+ID4NCj4gPiBJIHdvdWxkIGxpa2UgdG8g
c2VlIHBlcmZvcm1hbmNlIGRhdGEgYmVmb3JlIGVuYWJsaW5nIHRoaXMgdW5jb25kaXRpb25hbGx5
Lg0KPiANCj4gSSB3b3VsZG4ndCB3YW50IHRoaXMgdG8gYmUgZW5hYmxlZCB1bmNvbmRpdGlvbmFs
bHkgYW55d2F5LCBiZWNhdXNlIHlvdSBuZWVkIHRvDQo+IHRha2UgaW50byBhY2NvdW50IGxpdmUg
bWlncmF0aW9uIHRvIGFuZCBmcm9tIHByb2Nlc3NvcnMgdGhhdCBkbyBub3QgaGF2ZQ0KPiBBUEVS
Ri9NUEVSRiBzdXBwb3J0Lg0KPiANCj4gUGFvbG8NCg0KSSB3aWxsIGFkZCBhIGt2bSBwYXJhbWV0
ZXIgdG8gY29uc2lkZXIgd2hldGhlciBlbmFibGUgTVBFUkYvQVBFUkYgZW11bGF0aW9ucywgYW5k
IG1ha2UgZGVmYXVsdCB2YWx1ZSB0byBmYWxzZQ0KDQpUaGFua3MNCg0KLUxpDQoNCg==
