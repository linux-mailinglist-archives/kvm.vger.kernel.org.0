Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56A317B424
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 03:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCFCFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 21:05:44 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2598 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726300AbgCFCFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 21:05:43 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 1D553813662A715DAA7F;
        Fri,  6 Mar 2020 10:05:41 +0800 (CST)
Received: from dggeme702-chm.china.huawei.com (10.1.199.98) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 6 Mar 2020 10:05:40 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme702-chm.china.huawei.com (10.1.199.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 6 Mar 2020 10:05:40 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Fri, 6 Mar 2020 10:05:40 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86: small optimization for is_mtrr_mask calculation
Thread-Topic: [PATCH] KVM: x86: small optimization for is_mtrr_mask
 calculation
Thread-Index: AdXzWwIZgYDieYaoSGWM6QNNY//RGA==
Date:   Fri, 6 Mar 2020 02:05:40 +0000
Message-ID: <82b7d2d8c75e4c80a7704ae43940392a@huawei.com>
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

SGksDQpQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPiB3cm90ZToNCj5PbiAwNS8w
My8yMCAwMzo0OCwgbGlubWlhb2hlIHdyb3RlOg0KPj4gRnJvbTogTWlhb2hlIExpbiA8bGlubWlh
b2hlQGh1YXdlaS5jb20+DQo+PiANCj4+IFdlIGNhbiBnZXQgaXNfbXRycl9tYXNrIGJ5IGNhbGN1
bGF0aW5nIChtc3IgLSAweDIwMCkgJSAyIGRpcmVjdGx5Lg0KPj4gIAkJaW5kZXggPSAobXNyIC0g
MHgyMDApIC8gMjsNCj4+IC0JCWlzX210cnJfbWFzayA9IG1zciAtIDB4MjAwIC0gMiAqIGluZGV4
Ow0KPj4gKwkJaXNfbXRycl9tYXNrID0gKG1zciAtIDB4MjAwKSAlIDI7DQo+PiAgCQlpZiAoIWlz
X210cnJfbWFzaykNCj4+ICAJCQkqcGRhdGEgPSB2Y3B1LT5hcmNoLm10cnJfc3RhdGUudmFyX3Jh
bmdlc1tpbmRleF0uYmFzZTsNCj4+ICAJCWVsc2UNCj4+IA0KPg0KPklmIHlvdSdyZSBnb2luZyB0
byBkbyB0aGF0LCBtaWdodCBhcyB3ZWxsIHVzZSAiPj4gMSIgZm9yIGluZGV4IGluc3RlYWQgb2Yg
Ii8gMiIsIGFuZCAibXNyICYgMSIgZm9yIGlzX210cnJfbWFzay4NCj4NCg0KTWFueSB0aGFua3Mg
Zm9yIHN1Z2dlc3Rpb24uIFdoYXQgZG8geW91IG1lYW4gaXMgbGlrZSB0aGlzID8NCg0KCWluZGV4
ID0gKG1zciAtIDB4MjAwKSA+PiAxOw0KCWlzX210cnJfbWFzayA9IG1zciAmIDE7DQoNClRoYW5r
cyBhZ2Fpbi4NCg==
