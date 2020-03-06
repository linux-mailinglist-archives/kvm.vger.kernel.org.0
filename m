Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC2D17B477
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 03:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCFCaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 21:30:20 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbgCFCaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 21:30:20 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 3B670B3110407F097E6C;
        Fri,  6 Mar 2020 10:30:18 +0800 (CST)
Received: from dggeme701-chm.china.huawei.com (10.1.199.97) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 6 Mar 2020 10:30:17 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme701-chm.china.huawei.com (10.1.199.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 6 Mar 2020 10:30:17 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Fri, 6 Mar 2020 10:30:17 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     "hpa@zytor.com" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH] KVM: x86: small optimization for is_mtrr_mask calculation
Thread-Topic: [PATCH] KVM: x86: small optimization for is_mtrr_mask
 calculation
Thread-Index: AdXzXu2PSc7pa5yVRvaRRlGuRkJn5g==
Date:   Fri, 6 Mar 2020 02:30:17 +0000
Message-ID: <9063b8c3e1664c72b05ea92865f88c68@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

V2FucGVuZyBMaSA8a2VybmVsbHdwQGdtYWlsLmNvbT4gd3JvdGU6DQo+T24gRnJpLCA2IE1hciAy
MDIwIGF0IDEwOjIzLCBsaW5taWFvaGUgPGxpbm1pYW9oZUBodWF3ZWkuY29tPiB3cm90ZToNCj4+
DQo+PiBocGFAenl0b3IuY29tIHdyb3RlOg0KPj4gPj5PbiBNYXJjaCA1LCAyMDIwIDY6MDU6NDAg
UE0gUFNULCBsaW5taWFvaGUgPGxpbm1pYW9oZUBodWF3ZWkuY29tPiB3cm90ZToNCj4+ID4+SGks
DQo+PiA+PlBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4gPj5N
YW55IHRoYW5rcyBmb3Igc3VnZ2VzdGlvbi4gV2hhdCBkbyB5b3UgbWVhbiBpcyBsaWtlIHRoaXMg
Pw0KPj4gPj4NCj4+ID4+ICAgICAgaW5kZXggPSAobXNyIC0gMHgyMDApID4+IDE7DQo+PiA+PiAg
ICAgIGlzX210cnJfbWFzayA9IG1zciAmIDE7DQo+PiA+Pg0KPj4gPj5UaGFua3MgYWdhaW4uDQo+
PiA+DQo+PiA+WW91IHJlYWxpemUgdGhhdCB0aGUgY29tcGlsZXIgd2lsbCBwcm9iYWJseSBwcm9k
dWNlIGV4YWN0bHkgdGhlIHNhbWUgY29kZSwgcmlnaHQ/IEFzIHN1Y2gsIGl0IGlzIGFib3V0IG1h
a2luZyB0aGUgY29kZSBlYXN5IGZvciB0aGUgaHVtYW4gcmVhZGVyLg0KPj4gPg0KPj4gPkV2ZW4g
aWYgaXQgZGlkbid0LCB0aGlzIGNvZGUgaXMgYXMgZmFyIGZyb20gcGVyZm9ybWFuY2UgY3JpdGlj
YWwgYXMgb25lIGNhbiBwb3NzaWJseSBnZXQuDQo+Pg0KPj4gWWVwLCBpdCBsb29rcyBnYWluIGxp
dHRsZS4gVGhhbmtzLg0KPg0KPlBsZWFzZSBwb3N0IHRoZSBwZXJmb3JtYW5jZSBudW1iZXIgd2hl
biB5b3UgbWVudGlvbiBvcHRpbWl6ZSBYWFggbGF0ZXIuDQo+DQoNClN1cmUsIEkgd291bGQgdGFr
ZSBjYXJlIG9mIHRoaXMuIFRoYW5rcyBmb3IgeW91ciByZW1pbmRlciENCg0K
