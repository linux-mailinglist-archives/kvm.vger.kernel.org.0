Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9990D10AC25
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 09:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfK0IrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 03:47:09 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2091 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726092AbfK0IrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 03:47:09 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 62DF1EFFDFA9A6E46914;
        Wed, 27 Nov 2019 16:47:06 +0800 (CST)
Received: from dggeme765-chm.china.huawei.com (10.3.19.111) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 27 Nov 2019 16:47:06 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme765-chm.china.huawei.com (10.3.19.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 27 Nov 2019 16:47:05 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 27 Nov 2019 16:47:05 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "gary.hook@amd.com" <gary.hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2] KVM: SVM: Fix "error" isn't initialized
Thread-Topic: [PATCH v2] KVM: SVM: Fix "error" isn't initialized
Thread-Index: AdWk9Gm4M611HFaZTlSzM0B9cT25RQ==
Date:   Wed, 27 Nov 2019 08:47:05 +0000
Message-ID: <a5d0e94ba8cc4926a1ef27e6efcee594@huawei.com>
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

PiBGcm9tIGU3ZjljNzg2ZTQzZWY0Zjg5MGI4YTAxZjE1ZjhmMDA3ODZmNGIxNGEgTW9uIFNlcCAx
NyAwMDowMDowMCAyMDAxDQo+IEZyb206IEhhaXdlaSBMaSA8bGloYWl3ZWlAdGVuY2VudC5jb20+
DQo+IERhdGU6IFdlZCwgMjcgTm92IDIwMTkgMTU6MDA6NDkgKzA4MDANCj4gU3ViamVjdDogW1BB
VENIIHYyXSBmaXg6ICdlcnJvcicgaXMgbm90IGluaXRpYWxpemVkDQo+DQo+IFRoZXJlIGFyZSBh
IGJ1bmNoIG9mIGVycm9yIHBhdGhzIHdlcmUgImVycm9yIiBpc24ndCBpbml0aWFsaXplZC4NCj4g
QEAgLTE1NSw2ICsxNTUsOCBAQCBzdGF0aWMgaW50IF9fc2V2X2RvX2NtZF9sb2NrZWQoaW50IGNt
ZCwgdm9pZCAqZGF0YSwgaW50ICpwc3BfcmV0KQ0KPiAgIAl1bnNpZ25lZCBpbnQgcGh5c19sc2Is
IHBoeXNfbXNiOw0KPiAgIAl1bnNpZ25lZCBpbnQgcmVnLCByZXQgPSAwOw0KPg0KPiArCSpwc3Bf
cmV0ID0gLTE7DQo+ICsNCj4gICAJaWYgKCFwc3ApDQo+ICAgCQlyZXR1cm4gLUVOT0RFVjsNCj4N
Cg0KVGhlIGFyZyBwc3BfcmV0IG1heSBiZSBOVUxMIGluIHNvbWUgcGF0aCBzdWNoIGFzIHNldl9n
dWVzdF9kZl9mbHVzaChOVUxMKS4NClNvIHlvdSBoYXZlIHRvIGNoZWNrIGl0IGFnYWluc3QgTlVM
TC4NClRoYW5rcy4NCg==
