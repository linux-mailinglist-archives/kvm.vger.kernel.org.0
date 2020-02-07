Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C65E1550C6
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 03:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgBGCsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 21:48:18 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2943 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726597AbgBGCsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 21:48:17 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 13E5B12A85AF405533A0;
        Fri,  7 Feb 2020 10:48:15 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 7 Feb 2020 10:48:14 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 7 Feb 2020 10:48:14 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Fri, 7 Feb 2020 10:48:14 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86: remove duplicated KVM_REQ_EVENT request
Thread-Topic: [PATCH] KVM: x86: remove duplicated KVM_REQ_EVENT request
Thread-Index: AdXdX8vAtJy1cWApRASFjXqTQFpAAQ==
Date:   Fri, 7 Feb 2020 02:48:14 +0000
Message-ID: <a95c89cdcdca4749a1ca4d779ebd4a0a@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGmjug0KVml0YWx5IEt1em5ldHNvdiA8dmt1em5ldHNAcmVkaGF0LmNvbT4gd3JpdGVzOg0KPiBs
aW5taWFvaGUgPGxpbm1pYW9oZUBodWF3ZWkuY29tPiB3cml0ZXM6DQo+PiBGcm9tOiBNaWFvaGUg
TGluIDxsaW5taWFvaGVAaHVhd2VpLmNvbT4NCj4+DQo+PiBUaGUgS1ZNX1JFUV9FVkVOVCByZXF1
ZXN0IGlzIGFscmVhZHkgbWFkZSBpbiBrdm1fc2V0X3JmbGFncygpLiBXZSANCj4+IHNob3VsZCBu
b3QgbWFrZSBpdCBhZ2Fpbi4NCj4+ICAJa3ZtX3JpcF93cml0ZSh2Y3B1LCBjdHh0LT5laXApOw0K
Pj4gIAlrdm1fc2V0X3JmbGFncyh2Y3B1LCBjdHh0LT5lZmxhZ3MpOw0KPj4gLQlrdm1fbWFrZV9y
ZXF1ZXN0KEtWTV9SRVFfRVZFTlQsIHZjcHUpOw0KPg0KPiBJIHdvdWxkJ3ZlIGFjdHVhbGx5IGRv
bmUgaXQgdGhlIG90aGVyIHdheSBhcm91bmQgYW5kIHJlbW92ZWQNCj4ga3ZtX21ha2VfcmVxdWVz
dCgpIGZyb20ga3ZtX3NldF9yZmxhZ3MoKSBhcyBpdCBpcyBub3QgYW4gb2J2aW91cyBiZWhhdmlv
ciAoZS5nLiB3aHkga3ZtX3JpcF93cml0ZSgpIGRvZW5zJ3QgZG8gdGhhdCBhbmQga3ZtX3NldF9y
ZmxhZ3MoKSBkb2VzID8pIGFkZGluZyBrdm1fbWFrZV9yZXF1ZXN0KCkgdG8gYWxsIGNhbGwgc2l0
ZXMuDQo+DQo+SW4gY2FzZSB0aGlzIGxvb2tzIGxpa2UgdG9vIGJpZyBvZiBhIGNoYW5nZSB3aXRo
IG5vIHBhcnRpY3VsYXIgZ2FpbiBJJ2Qgc3VnZ2VzdCB5b3UgYXQgbGVhc3QgbGVhdmUgYSBjb21t
ZW50IGFib3ZlIGt2bV9zZXRfcmZsYWdzKCksIHNvbWV0aGluZyBsaWtlDQo+DQo+Imt2bV9tYWtl
X3JlcXVlc3QoKSBhbHNvIHJlcXVlc3RzIEtWTV9SRVFfRVZFTlQiDQoNCkkgdGhpbmsgYWRkaW5n
IGt2bV9tYWtlX3JlcXVlc3QoKSB0byBhbGwgY2FsbCBzaXRlcyBpcyB0b28gYmlnIHdpdGhvdXQg
cGFydGljdWxhciBnYWluLiBBbmQgYWxzbyBsZWF2ZSBhIGNvbW1lbnQgYWJvdmUNCmt2bV9zZXRf
cmZsYWdzKCkgbWF5YmUgaXNuJ3QgbmVlZGVkIGFzIHJmbGFncyB1cGRhdGVzIGlzIGFuIHNpdGUg
dGhhdCBjYW4gdHJpZ2dlciBldmVudCBpbmplY3Rpb24uIFBsZWFzZSBzZWUgY29tbWl0DQooMzg0
MmQxMzVmZjI0IEtWTTogQ2hlY2sgZm9yIHBlbmRpbmcgZXZlbnRzIGJlZm9yZSBhdHRlbXB0aW5n
IGluamVjdGlvbikgZm9yIGRldGFpbC4NCg0KV2hhdCBkbyB5b3UgdGhpbms/IFRoYW5rcyBmb3Ig
eW91ciByZXZpZXcgYW55d2F5LiA6KQ0K
