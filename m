Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0F310C5D9
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 10:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfK1JUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 04:20:22 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:42796 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726510AbfK1JUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 04:20:22 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 372C97DF42E69E39CF90;
        Thu, 28 Nov 2019 17:20:19 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 28 Nov 2019 17:20:18 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 28 Nov 2019 17:20:18 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 28 Nov 2019 17:20:18 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "will@kernel.org" <will@kernel.org>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: vgic: Use warpper function to lock/unlock all vcpus
 in kvm_vgic_create()
Thread-Topic: [PATCH] KVM: vgic: Use warpper function to lock/unlock all vcpus
 in kvm_vgic_create()
Thread-Index: AdWly9EF1J/EpZSsQNGjM4qqDvLl/w==
Date:   Thu, 28 Nov 2019 09:20:18 +0000
Message-ID: <ba063b6de6b14fedb09c9d382120bf46@huawei.com>
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

RXJpYyB3cm90ZToNCj4+IEZyb206IE1pYW9oZSBMaW4gPGxpbm1pYW9oZUBodWF3ZWkuY29tPg0K
Pj4gDQo+PiBVc2Ugd2FycHBlciBmdW5jdGlvbiBsb2NrX2FsbF92Y3B1cygpL3VubG9ja19hbGxf
dmNwdXMoKQ0KPiBzL3dhcnBwZXIvd3JhcHBlciBhbmQgYWxzbyBpbiB0aGUgdGl0bGUuDQoNCkhp
LCBFcmljOg0KTWFueSB0aGFua3MgZm9yIHlvdXIgcmV2aWV3LiBJIHdvdWxkIGZpeCB0aGlzIGFu
ZCBzZW5kIGEgcGF0Y2ggdjIuDQpUaGFua3MgYWdhaW4uDQo=
