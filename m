Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272C013D1CE
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 03:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbgAPCBa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 15 Jan 2020 21:01:30 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2559 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730481AbgAPCBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 21:01:30 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id A8E43419CB98BBC2D2B3;
        Thu, 16 Jan 2020 10:01:27 +0800 (CST)
Received: from dggeme714-chm.china.huawei.com (10.1.199.110) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 10:01:27 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme714-chm.china.huawei.com (10.1.199.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 16 Jan 2020 10:01:27 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 16 Jan 2020 10:01:27 +0800
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
Subject: Re: [PATCH] KVM: arm/arm64: Fix some obsolete comments
Thread-Topic: [PATCH] KVM: arm/arm64: Fix some obsolete comments
Thread-Index: AdXMEIsRM8NLXBleSYieolgkDnr4pA==
Date:   Thu, 16 Jan 2020 02:01:27 +0000
Message-ID: <9a12f0f18f37418e921afede5f6e3645@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

friendly ping. :)
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Fix various comments, including comment typo, and obsolete comments no longer make sense.
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/arm/arch_timer.c    | 5 ++---
>  virt/kvm/arm/arm.c           | 1 -
>  virt/kvm/arm/vgic/vgic-its.c | 2 +-
>  3 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c index 73867f97040c..d8d2f4bec935 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -322,9 +322,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
>  	}
>  
>  	/*
> -	 * If the timer can fire now, we don't need to have a soft timer
> -	 * scheduled for the future.  If the timer cannot fire at all,
> -	 * then we also don't need a soft timer.
> +	 * If the timer cannot fire at all, we don't need to have a
> +	 * soft timer scheduled for the future.
>  	 */
>  	if (!kvm_timer_irq_can_fire(ctx)) {
>  		soft_timer_cancel(&ctx->hrtimer);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c index 8de4daf25097..7687663ab71b 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -525,7 +525,6 @@ static bool need_new_vmid_gen(struct kvm_vmid *vmid)
>  
>  /**
>   * update_vmid - Update the vmid with a valid VMID for the current generation
> - * @kvm: The guest that struct vmid belongs to
>   * @vmid: The stage-2 VMID information struct
>   */
>  static void update_vmid(struct kvm_vmid *vmid) diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c index 98c7360d9fb7..d64569b30b5c 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2564,7 +2564,7 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)  }
>  
>  /**
> - * vgic_its_save_tables_v0 - Save the ITS tables into guest ARM
> + * vgic_its_save_tables_v0 - Save the ITS tables into guest RAM
>   * according to v0 ABI
>   */
>  static int vgic_its_save_tables_v0(struct vgic_its *its)
> --
> 2.19.1
>
