Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46428114AA5
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 02:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfLFBx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 20:53:27 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2471 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbfLFBx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 20:53:27 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id DCB0DE52C2AA5EC43B2E;
        Fri,  6 Dec 2019 09:53:15 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 6 Dec 2019 09:53:15 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 6 Dec 2019 09:53:15 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Fri, 6 Dec 2019 09:53:15 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Liran Alon <liran.alon@oracle.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
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
Thread-Index: AdWr1N3SQRWT5jFmmU6+ynSksRvCDQ==
Date:   Fri, 6 Dec 2019 01:53:14 +0000
Message-ID: <833788ce05014084af1e6160fb81e5cd@huawei.com>
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

Pg0KPkkgcGVyc29uYWxseSBqdXN0IHByZWZlciB0byByZW1vdmUgdGhlIOKAnGRlZmF1bHTigJ0g
Y2FzZSBhbmQgY2hhbmdlIHRoaXMg4oCccmV0dXJuIDA74oCdIHRvIOKAnHJldHVybiAxO+KAnS4N
Cj5CdXQgaXTigJlzIGEgbWF0dGVyIG9mIHRhc3RlIG9mIGNvdXJzZS4NCj4NClllcy4gQXMgd2hh
dCAiIFR1cm5pcCBncmVlbnMsIGFsbCBoYXZlIGxvdmUgIiBzYWlkLiBeX14NCg==
