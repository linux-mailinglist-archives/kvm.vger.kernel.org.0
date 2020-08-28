Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E752553E4
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 06:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgH1EyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 00:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgH1EyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 00:54:06 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E93CC06121B
        for <kvm@vger.kernel.org>; Thu, 27 Aug 2020 21:54:06 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id s13so40417wmh.4
        for <kvm@vger.kernel.org>; Thu, 27 Aug 2020 21:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xCkPRCKVOyv6UdC08SrLjktcyNyR3bWo2BWIKaXwLIU=;
        b=wzNVuFCj/YGjuC6NDV1gHwffImireBFCVYVdrHj0WUr+2vvzYZTAgyeaw28x2dUPbd
         ShRUHS3rP6pBj/FcTwkdikNlfeGx1bWm7WEKfEBmWiEz88ZxRXe1AW8Kh5Xr3w95ZWOL
         uEhmg2WHxPEEvrNNBPr3SeykviI0capLfcMCr2WBcnYmQ84GYJYfxoWbI6GtvVjSlMpD
         6xi87zx7+KFN+ckqJiXSKbzlyFqWY0+REM6PQJGxTAifwXNGrlEMz+pdRTl7AGAPKNG/
         KwjOIJsHc0Opqh3TdvhPlFlqCdC0Dt7M1TzJLiHSACfAwNSWnvbjVieHE0Jndxidt1hH
         BM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xCkPRCKVOyv6UdC08SrLjktcyNyR3bWo2BWIKaXwLIU=;
        b=FjoW3p3T8uKX9OI5xvycXS3jKWqiHfDaNQEQEBODMwn2BMsIdiaBr8bBs7lpqgQj3Q
         TUtpa+Vt8WQh33QP76g1oBvO+ZXrIgTt8RgczIETJL2cHQqBMZMTaRQd2fwXrQvjur5a
         3LsZb4d07JJWF+bIBonFQR9wsXszKbOsnQXx8pWFRwAID9S7Z1i0FPN7uegP6fqf9dP1
         QfTiGCTuugcmzoGLiER0WBKycd13pKfNwuOKz5zmOulXrGcmgvUknUabkY+ZRtxv5y9e
         zoXMQ4TJBmwfTjDcAGgM5GIfLwKUvuGGtkIdaTt3sO7WRHzta7vfooPHUTfNiLH0164k
         afAw==
X-Gm-Message-State: AOAM531W0l67EMCDmEq7RP7156R6qZb3tVVIcXInlPDtWLUBCIi7uQg7
        w2pMUW0jd9qBKmhyDwsQxSd5+qMwZOnzp8vz/QHliQ==
X-Google-Smtp-Source: ABdhPJz3rZLWV6A3Em0ve8Z6e606P/Ks47lsI+RkOV083HeFssFde+guqsIX7d3OuAhb6RNGeYB7ks4hletdcMQevi4=
X-Received: by 2002:a1c:1b17:: with SMTP id b23mr101507wmb.152.1598590444059;
 Thu, 27 Aug 2020 21:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200827082251.1591-1-jiangyifei@huawei.com> <20200827082251.1591-3-jiangyifei@huawei.com>
In-Reply-To: <20200827082251.1591-3-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 28 Aug 2020 10:23:52 +0530
Message-ID: <CAAhSdy36ZCubU-1+WzjMzBaR+RipgEhvRqd9AT+28=99-EUDaQ@mail.gmail.com>
Subject: Re: [PATCH RFC 2/2] target/kvm: Add interfaces needed for log dirty
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Atish Patra <atish.patra@wdc.com>, deepa.kernel@gmail.com,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        wu.wubin@huawei.com,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        "dengkai (A)" <dengkai1@huawei.com>,
        yinyipeng <yinyipeng1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 27, 2020 at 1:54 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Add two interfaces of log dirty for kvm_main.c, and detele the interface
> kvm_vm_ioctl_get_dirty_log which is redundantly defined.
>
> CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT is added in defconfig.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
> ---
>  arch/riscv/configs/defconfig |  1 +
>  arch/riscv/kvm/Kconfig       |  1 +
>  arch/riscv/kvm/mmu.c         | 43 ++++++++++++++++++++++++++++++++++++
>  arch/riscv/kvm/vm.c          |  6 -----
>  4 files changed, 45 insertions(+), 6 deletions(-)
>
> diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
> index d36e1000bbd3..857d799672c2 100644
> --- a/arch/riscv/configs/defconfig
> +++ b/arch/riscv/configs/defconfig
> @@ -19,6 +19,7 @@ CONFIG_SOC_VIRT=y
>  CONFIG_SMP=y
>  CONFIG_VIRTUALIZATION=y
>  CONFIG_KVM=y
> +CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
>  CONFIG_HOTPLUG_CPU=y
>  CONFIG_MODULES=y
>  CONFIG_MODULE_UNLOAD=y
> diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
> index 2356dc52ebb3..91fcffc70e5d 100644
> --- a/arch/riscv/kvm/Kconfig
> +++ b/arch/riscv/kvm/Kconfig
> @@ -26,6 +26,7 @@ config KVM
>         select KVM_MMIO
>         select HAVE_KVM_VCPU_ASYNC_IOCTL
>         select SRCU
> +       select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>         help
>           Support hosting virtualized guest machines.
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 88bce80ee983..df2a470c25e4 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -358,6 +358,43 @@ void stage2_wp_memory_region(struct kvm *kvm, int slot)
>         kvm_flush_remote_tlbs(kvm);
>  }
>
> +/**
> + * kvm_mmu_write_protect_pt_masked() - write protect dirty pages
> + * @kvm:    The KVM pointer
> + * @slot:   The memory slot associated with mask
> + * @gfn_offset: The gfn offset in memory slot
> + * @mask:   The mask of dirty pages at offset 'gfn_offset' in this memory
> + *      slot to be write protected
> + *
> + * Walks bits set in mask write protects the associated pte's. Caller must
> + * acquire kvm_mmu_lock.
> + */
> +static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
> +        struct kvm_memory_slot *slot,
> +        gfn_t gfn_offset, unsigned long mask)
> +{
> +    phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
> +    phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
> +    phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
> +
> +    stage2_wp_range(kvm, start, end);
> +}
> +
> +/*
> + * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
> + * dirty pages.
> + *
> + * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
> + * enable dirty logging for them.
> + */
> +void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> +        struct kvm_memory_slot *slot,
> +        gfn_t gfn_offset, unsigned long mask)
> +{
> +    kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
> +}
> +
> +
>  int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>                    unsigned long size, bool writable)
>  {
> @@ -433,6 +470,12 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  {
>  }
>
> +void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> +                                       struct kvm_memory_slot *memslot)
> +{
> +       kvm_flush_remote_tlbs(kvm);
> +}
> +
>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
>  {
>  }
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 4f2498198cb5..f7405676903b 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -12,12 +12,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/kvm_host.h>
>
> -int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
> -{
> -       /* TODO: To be added later. */
> -       return -ENOTSUPP;
> -}
> -
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>         int r;
> --
> 2.19.1
>
>

I already have a similar change as part of v14 KVM RISC-V series.

Let us coordinate better. Please let us know in-advance for any
KVM RISC-V feature you plan to work on. Otherwise, this leads to
efforts wasted at your end or at our end.

Regards,
Anup
