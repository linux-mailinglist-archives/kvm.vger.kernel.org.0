Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8920E115B6F
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 07:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfLGGxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Dec 2019 01:53:06 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:60264 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbfLGGxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Dec 2019 01:53:06 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 389A7A547C66DEA8BCE8;
        Sat,  7 Dec 2019 14:53:03 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 7 Dec 2019 14:53:03 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 7 Dec 2019 14:53:02 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Sat, 7 Dec 2019 14:53:02 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
CC:     Liran Alon <liran.alon@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: vmx: remove unreachable statement in
 vmx_get_msr_feature()
Thread-Topic: [PATCH] KVM: vmx: remove unreachable statement in
 vmx_get_msr_feature()
Thread-Index: AdWsyg0ykRpYj0RCSySPadjbFxdshg==
Date:   Sat, 7 Dec 2019 06:53:02 +0000
Message-ID: <de7e3807522a493c8cb6012063491a96@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPiB3cm90ZToNCj4+IFdhbnBlbmcg
TGkgPGtlcm5lbGx3cEBnbWFpbC5jb20+IHdyb3RlOg0KPj4+Pg0KPj4+Pj4NCj4+Pj4+IEkgcGVy
c29uYWxseSBqdXN0IHByZWZlciB0byByZW1vdmUgdGhlIOKAnGRlZmF1bHTigJ0gY2FzZSBhbmQg
Y2hhbmdlIHRoaXMg4oCccmV0dXJuIDA74oCdIHRvIOKAnHJldHVybiAxO+KAnS4NCj4+Pj4+IEJ1
dCBpdOKAmXMgYSBtYXR0ZXIgb2YgdGFzdGUgb2YgY291cnNlLg0KPj4+Pj4NCj4+Pj4gWWVzLiBB
cyB3aGF0ICIgVHVybmlwIGdyZWVucywgYWxsIGhhdmUgbG92ZSAiIHNhaWQuIF5fXg0KPj4+DQo+
Pj4gQWN0dWFsbHkgaXQgaXMgYSBncmVhdCBhcHByZWNpYXRlZCB0byBpbnRyb2R1Y2Ugc29tZXRo
aW5nIG1vcmUgdXNlZnVsIGluc3RlYWQgb2YgdG9ucyBvZiBjbGVhbnVwcywgSSBzYXcgZ3V5cyBk
aWQgb25lIGNsZWFudXAgYW5kIGNhbiBpbmN1ciBzZXZlcmFsIGJ1Z3MgYmVmb3JlLg0KPj4+DQo+
PiBJJ2QgbGlrZSB0byBpbnRyb2R1Y2Ugc29tZXRoaW5nIG1vcmUgdXNlZnVsLCBidXQgc2lkZSBj
b3JuZXIgY2xlYW51cHMgDQo+PiBtYXkgYmUgaGFyZCB0byBmb3VuZCBvdXQgc29tZXRoaW5nIHRv
IGludHJvZHVjZS4gQW5kIHN1Y2ggY2xlYW51cHMgY2FuIA0KPj4gYWxzbyBiZSB2YWxpZGF0ZWQg
YnkgY29kZSBpbnNwZWN0aW9uIHRvIGF2b2lkIHNvbWV0aGluZyBiYWQuIE1hbnkgdGhhbmtzLg0K
Pj4gDQo+DQo+WWVhaCwgSSB0aGluayB5b3UgaGF2ZSBiZWVuIGRvaW5nIGEgZ29vZCBqb2IuICBV
c3VhbGx5LCB3aGVuIHRoZSBjbGVhbnVwcyBpbnRyb2R1Y2UgYnVncyB0aGVyZSBhcmUgbWFueSBv
dGhlciAic3VzcGljaW91cyIgdGhpbmdzLiAgRm9yIG1lIGl0J3MgY2xlYXIgdGhhdCB5b3UncmUg
bGVhcm5pbmcgdGhlIGNvZGUgYW5kIG5vdCBqdXN0IG1lc3NpbmcgYXJvdW5kLg0KPg0KPlBhb2xv
DQoNCk1hbnkgdGhhbmtzIGZvciB5b3VyIGFwcHJvdmUuIEkgcmVhbGx5IGZlZWwgZ3JhdGVmdWwg
Zm9yIGl0LiBJbiBmYWN0LCBJIGFtIGludmVzdGlnYXRpbmcgdGhlDQpjb2RlIGFuZCBleHBlY3Qg
YSBkZWVwIHVuZGVyc3RhbmRpbmcuIEJ1dCBpdCdzIHJlYWxseSBhIGVub3Jtb3VzLCBzb3BoaXN0
aWNhdGVkIGFuZA0Kd29uZGVyZnVsIHdvcmxkLCB3aGF0IEkgY2FuIGRvIG5vdyBpcyB0cnkgdG8g
a2VlcCB0aGUgY29kZSBjbGVhbi4gTWF5YmUgSSBjb3VsZCBpbnRyb2R1Y2Ugc29tZSB1c2VmdWwN
CmZlYXR1cmVzIHNvbWVkYXkuIE1hbnkgdGhhbmtzIGFnYWluLg0KDQpCZXN0IHdpc2hlcy4NCg==
