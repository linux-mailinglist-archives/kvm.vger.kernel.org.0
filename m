Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A470161EC4
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 02:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgBRB4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 20:56:20 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2964 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726108AbgBRB4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 20:56:19 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id CD48718DE2656FD75CA8;
        Tue, 18 Feb 2020 09:56:17 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 18 Feb 2020 09:56:17 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 18 Feb 2020 09:56:17 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Tue, 18 Feb 2020 09:56:17 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: apic: remove unused function apic_lvt_vector()
Thread-Topic: [PATCH] KVM: apic: remove unused function apic_lvt_vector()
Thread-Index: AdXl/mukwxIGAhU+rEGyO/fRDkVJww==
Date:   Tue, 18 Feb 2020 01:56:17 +0000
Message-ID: <5c43bef1c82f4324935e341c744fdd9c@huawei.com>
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

UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4gd3JvdGU6DQo+T24gMTcvMDIvMjAg
MTg6MDIsIFZpdGFseSBLdXpuZXRzb3Ygd3JvdGU6DQo+PiANCj4+IEFsc28sIGFwaWNfbHZ0X2Vu
YWJsZWQoKSBpcyBvbmx5IHVzZWQgb25jZSB3aXRoIEFQSUNfTFZUVCBhcyB0aGUgDQo+PiBzZWNv
bmQgYXJndW1lbnQgc28gSSdkIHN1Z2dlc3Qgd2UgYWxzbyBkbzoNCj4+IA0KPj4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2t2bS9sYXBpYy5jIGIvYXJjaC94ODYva3ZtL2xhcGljLmMgaW5kZXggDQo+
PiANCj4+IGluIGFkZGl0aW9uIHRvIHRoZSBhYm92ZS4NCj4+IA0KPj4gLS0gVml0YWx5DQo+DQo+
U291bmRzIGdvb2QuDQo+DQoNCldpbGwgZG8uIFRoYW5rcyBhbGwgb2YgeW91Lg0KDQo=
