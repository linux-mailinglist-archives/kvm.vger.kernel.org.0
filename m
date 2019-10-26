Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85429E57C8
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 03:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfJZB3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 21:29:35 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2494 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725899AbfJZB3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 21:29:35 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id CEC2E40F2F2FAA7F107E;
        Sat, 26 Oct 2019 09:29:32 +0800 (CST)
Received: from dggeme714-chm.china.huawei.com (10.1.199.110) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 26 Oct 2019 09:29:32 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme714-chm.china.huawei.com (10.1.199.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 26 Oct 2019 09:29:32 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Sat, 26 Oct 2019 09:29:32 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: get rid of odd out jump label in
 pdptrs_changed
Thread-Topic: [PATCH v2] KVM: x86: get rid of odd out jump label in
 pdptrs_changed
Thread-Index: AdWLm9UWZ3qjVpzOLUqCev+vBr0wyg==
Date:   Sat, 26 Oct 2019 01:29:32 +0000
Message-ID: <061ecabeb60442dbb6ce43c9aeb23562@huawei.com>
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

DQpPbiAyNi8xMC8xOSAsIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+IFF1ZXVlZCwgdGhhbmtzIChi
dXQgaXQgbGlrZWx5IHdvbid0IGJlIG9uIGdpdC5rZXJuZWwub3JnIHVudGlsIGFmdGVyIHRoZSBl
bmQgb2YgS1ZNIEZvcnVtLCBzb3JyeSBhYm91dCB0aGF0KS4NCg0KTm90IGF0IGFsbC4gTWFueSB0
aGFua3MgZm9yIHlvdXIgY29udHJpYnV0aW9uIHRvIG1ha2UgS1ZNIG1vcmUgc3Ryb25nLCBzdGF0
YmxlIGFuZCBlZmZpY2llbnQuDQpIYXZlIGEgbmljZSBkYXkuDQoNCj4gT24gMjUvMTAvMTkgMTI6
NTQsIE1pYW9oZSBMaW4gd3JvdGU6DQo+PiBUaGUgb2RkIG91dCBqdW1wIGxhYmVsIGlzIHJlYWxs
eSBub3QgbmVlZGVkLiBHZXQgcmlkIG9mIGl0IGJ5IHJldHVybiANCj4+IHRydWUgZGlyZWN0bHkg
d2hpbGUgciA8IDAgYXMgc3VnZ2VzdGVkIGJ5IFBhb2xvLiBUaGlzIGZ1cnRoZXIgbGVhZCB0byAN
Cj4+IHZhciBjaGFuZ2VkIGJlaW5nIHVudXNlZC4NCj4+IFJlbW92ZSBpdCB0b28uDQo=
