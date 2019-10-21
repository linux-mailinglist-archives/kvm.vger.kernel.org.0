Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24627DE6BF
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 10:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfJUIjQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 21 Oct 2019 04:39:16 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:36642 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfJUIjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 04:39:15 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 0477F4D2FF7C58E08319;
        Mon, 21 Oct 2019 16:39:13 +0800 (CST)
Received: from dggeme765-chm.china.huawei.com (10.3.19.111) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 21 Oct 2019 16:39:12 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme765-chm.china.huawei.com (10.3.19.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Mon, 21 Oct 2019 16:39:12 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Mon, 21 Oct 2019 16:39:12 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: remove redundant code in kvm_arch_vm_ioctl
Thread-Topic: [PATCH] KVM: remove redundant code in kvm_arch_vm_ioctl
Thread-Index: AdWH6kPXLNyqJ2lVU0Oc7cFVv0sKlA==
Date:   Mon, 21 Oct 2019 08:39:12 +0000
Message-ID: <f892609629d7429182ed90422bfd3806@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Mon, 21 Oct 2019, tglx wrote:
>On Mon, 21 Oct 2019, Miaohe Lin wrote:
>> If we reach here with r = 0, we will reassign r = 0 unnecesarry, then 
>> do the label set_irqchip_out work.
>> If we reach here with r != 0, then we will do the label work directly. 
>> So this if statement and r = 0 assignment is redundant.
>
>Can you please get rid of that odd jump label completely?
>
>  		if (irqchip_kernel(kvm))
>			r = kvm_vm_ioctl_set_irqchip(kvm, chip);
>
>Hmm?

Sure, thanks for your reply. I will send patch v2 to complete it.
Thanks again.
