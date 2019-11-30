Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB6A10DCE6
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2019 08:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfK3HU1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 30 Nov 2019 02:20:27 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2096 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbfK3HU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Nov 2019 02:20:27 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 314F03BD4D38557D7AB9;
        Sat, 30 Nov 2019 15:20:25 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 30 Nov 2019 15:20:24 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 30 Nov 2019 15:20:24 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Sat, 30 Nov 2019 15:20:24 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     "maz@kernel.org" <maz@kernel.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "will@kernel.org" <will@kernel.org>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: arm: get rid of unused arg in cpu_init_hyp_mode()
Thread-Topic: [PATCH] KVM: arm: get rid of unused arg in cpu_init_hyp_mode()
Thread-Index: AdWnTmGujmIRIVH4Q4a12QHyDyOpdA==
Date:   Sat, 30 Nov 2019 07:20:24 +0000
Message-ID: <8efe4ab7f8c44c48a70378247c511edc@huawei.com>
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

>From: Miaohe Lin <linmiaohe@huawei.com>
>
>As arg dummy is not really needed, there's no need to pass NULL when calling cpu_init_hyp_mode(). So clean it up.
>
>Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>---
> virt/kvm/arm/arm.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c index 86c6aa1cb58e..a5470f1b1a19 100644
>--- a/virt/kvm/arm/arm.c
>+++ b/virt/kvm/arm/arm.c
>@@ -1315,7 +1315,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
> 	}
> }
>
>-static void cpu_init_hyp_mode(void *dummy)
>+static void cpu_init_hyp_mode(void)
> {
> 	phys_addr_t pgd_ptr;
> 	unsigned long hyp_stack_ptr;
>@@ -1349,7 +1349,7 @@ static void cpu_hyp_reinit(void)
> 	if (is_kernel_in_hyp_mode())
> 		kvm_timer_init_vhe();
> 	else
>-		cpu_init_hyp_mode(NULL);
>+		cpu_init_hyp_mode();
> 
> 	kvm_arm_init_debug();
> 
friendly ping ...
