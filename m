Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE92810A8B0
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 03:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfK0CVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 21:21:37 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:58412 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725883AbfK0CVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 21:21:36 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id CA40AF7C76B9AB5BCBC5;
        Wed, 27 Nov 2019 10:21:33 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 27 Nov 2019 10:21:33 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 27 Nov 2019 10:21:33 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 27 Nov 2019 10:21:33 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Colin King <colin.king@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: fix comparison of u8 with -1
Thread-Topic: [PATCH] KVM: x86/mmu: fix comparison of u8 with -1
Thread-Index: AdWkyNHy+cUOsrTJRk2lD/BPSadTkg==
Date:   Wed, 27 Nov 2019 02:21:32 +0000
Message-ID: <141f8e0da70a400282824a09bcb56501@huawei.com>
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

DQo+IFRoZSBjb21wYXJpc29uIG9mIHRoZSB1OCB2YWx1ZSBfX2VudHJ5LT51IHdpdGggLTEgaXMg
YWx3YXlzIGdvaW5nIHRvIGJlIGZhbHNlIGJlY2F1c2UNCj4gYSBfX2VudHJ5LXUgY2FuIG5ldmVy
IGJlIG5lZ2F0aXZlLg0KDQpzL19fZW50cnktdS9fX2VudHJ5LT51Lw0KDQpUaGFua3MuDQo=
