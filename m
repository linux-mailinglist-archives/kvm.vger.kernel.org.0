Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30B91F0660
	for <lists+kvm@lfdr.de>; Sat,  6 Jun 2020 13:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgFFLxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jun 2020 07:53:42 -0400
Received: from mx24.baidu.com ([111.206.215.185]:36350 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725831AbgFFLxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jun 2020 07:53:41 -0400
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 48047EE440090CF01259;
        Sat,  6 Jun 2020 19:53:30 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Sat, 6 Jun 2020 19:53:29 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Sat, 6 Jun 2020 19:53:23 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
CC:     Xiaoyao Li <xiaoyao.li@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "wei.huang2@amd.com" <wei.huang2@amd.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3Y2XSBLVk06IFg4Njogc3VwcG9ydCBBUEVSRi9N?=
 =?utf-8?Q?PERF_registers?=
Thread-Topic: [PATCH][v6] KVM: X86: support APERF/MPERF registers
Thread-Index: AQHWOtrZ4X/t3pkmBEG7o3WCZUgoeKjI8MGAgAAac4CAALL6AIAAAaWAgAG8BDA=
Date:   Sat, 6 Jun 2020 11:53:23 +0000
Message-ID: <15a134b739614f8bbaf18ce40662f6b3@baidu.com>
References: <1591321466-2046-1-git-send-email-lirongqing@baidu.com>
 <b70d03dd-947f-dee5-5499-3b381372497d@intel.com>
 <72a75924-c3cb-6b23-62bd-67b739dec166@redhat.com>
 <CALMp9eSrDehftA5o6tU2sE_098F2ucztYtzhvgguYDnWqwHJaw@mail.gmail.com>
 <a1aa9cc5-96c7-11fe-17e1-22fe46b940f3@redhat.com>
In-Reply-To: <a1aa9cc5-96c7-11fe-17e1-22fe46b940f3@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.127.81.84]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex14_2020-06-06 19:53:30:236
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex14_GRAY_Inside_WithoutAtta_2020-06-06
 19:53:30:173
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFBhb2xvIEJvbnppbmkg
W21haWx0bzpwYm9uemluaUByZWRoYXQuY29tXQ0KPiDlj5HpgIHml7bpl7Q6IDIwMjDlubQ25pyI
NuaXpSAxOjIyDQo+IOaUtuS7tuS6ujogSmltIE1hdHRzb24gPGptYXR0c29uQGdvb2dsZS5jb20+
DQo+IOaKhOmAgTogWGlhb3lhbyBMaSA8eGlhb3lhby5saUBpbnRlbC5jb20+OyBMaSxSb25ncWlu
ZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+Ow0KPiBMS01MIDxsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnPjsga3ZtIGxpc3QgPGt2bUB2Z2VyLmtlcm5lbC5vcmc+OyB0aGUNCj4gYXJjaC94ODYg
bWFpbnRhaW5lcnMgPHg4NkBrZXJuZWwub3JnPjsgSCAuIFBldGVyIEFudmluIDxocGFAenl0b3Iu
Y29tPjsNCj4gQm9yaXNsYXYgUGV0a292IDxicEBhbGllbjguZGU+OyBJbmdvIE1vbG5hciA8bWlu
Z29AcmVkaGF0LmNvbT47IFRob21hcw0KPiBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPjsg
V2FucGVuZyBMaSA8d2FucGVuZ2xpQHRlbmNlbnQuY29tPjsgVml0YWx5DQo+IEt1em5ldHNvdiA8
dmt1em5ldHNAcmVkaGF0LmNvbT47IFNlYW4gQ2hyaXN0b3BoZXJzb24NCj4gPHNlYW4uai5jaHJp
c3RvcGhlcnNvbkBpbnRlbC5jb20+OyB3ZWkuaHVhbmcyQGFtZC5jb20NCj4g5Li76aKYOiBSZTog
W1BBVENIXVt2Nl0gS1ZNOiBYODY6IHN1cHBvcnQgQVBFUkYvTVBFUkYgcmVnaXN0ZXJzDQo+IA0K
PiBPbiAwNS8wNi8yMCAxOToxNiwgSmltIE1hdHRzb24gd3JvdGU6DQo+ID4+Pj4gQEAgLTQ5MzAs
NiArNDkzOSwxMSBAQCBpbnQga3ZtX3ZtX2lvY3RsX2VuYWJsZV9jYXAoc3RydWN0IGt2bQ0KPiAq
a3ZtLA0KPiA+Pj4+ICAgICAgICAgICBrdm0tPmFyY2guZXhjZXB0aW9uX3BheWxvYWRfZW5hYmxl
ZCA9IGNhcC0+YXJnc1swXTsNCj4gPj4+PiAgICAgICAgICAgciA9IDA7DQo+ID4+Pj4gICAgICAg
ICAgIGJyZWFrOw0KPiA+Pj4+ICsgICAgY2FzZSBLVk1fQ0FQX0FQRVJGTVBFUkY6DQo+ID4+Pj4g
KyAgICAgICAga3ZtLT5hcmNoLmFwZXJmbXBlcmZfbW9kZSA9DQo+ID4+Pj4gKyAgICAgICAgICAg
IGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9BUEVSRk1QRVJGKSA/DQo+IGNhcC0+YXJnc1swXSA6
DQo+ID4+Pj4gKyAwOw0KPiA+Pj4gU2hvdWxkbid0IGNoZWNrIHdoZXRoZXIgY2FwLT5hcmdzWzBd
IGlzIGEgdmFsaWQgdmFsdWU/DQo+ID4+IFllcywgb25seSB2YWxpZCB2YWx1ZXMgc2hvdWxkIGJl
IGFsbG93ZWQuDQo+ID4+DQo+ID4+IEFsc28sIGl0IHNob3VsZCBmYWlsIHdpdGggLUVJTlZBTCBp
ZiB0aGUgaG9zdCBkb2VzIG5vdCBoYXZlDQo+ID4+IFg4Nl9GRUFUVVJFX0FQRVJGTVBFUkYuDQo+
ID4gU2hvdWxkIGVuYWJsaW5nL2Rpc2FibGluZyB0aGlzIGNhcGFiaWxpdHkgYmUgZGlzYWxsb3dl
ZCBvbmNlIHZDUFVzDQo+ID4gaGF2ZSBiZWVuIGNyZWF0ZWQ/DQo+ID4NCj4gDQo+IFRoYXQncyBh
IGdvb2QgaWRlYSwgeWVzLg0KPiANCj4gUGFvbG8NCg0KDQpUaGFuayB5b3UgYWxsLCBJIHdpbGwg
c2VuZCBhIG5ldyB2ZXJzaW9uDQoNCi1MaQ0K
