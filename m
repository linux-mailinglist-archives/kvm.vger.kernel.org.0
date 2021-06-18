Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7873AC7A1
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 11:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhFRJdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 05:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbhFRJc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 05:32:29 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6707BC0613A3
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 02:30:17 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id w23-20020a9d5a970000b02903d0ef989477so9054953oth.9
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 02:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=77mzIJgsnd6fd7VLB24yLdWxFauCP3v4BC+3010BcoI=;
        b=splN4F0W2+ZYXW8DQ+07l5RKaruWT5ZPxUWsjzNl0oY2XTzTCR6O8vimbufSv6f3vL
         PdIdB2fFYw/cg01yOh2vFuNnt9hjIKDpyHEYO71Hc+iwk6TfEmRw0y9B3tIGcgXeHo+c
         N6E2cG8vYoY/4zV02vTQ1kqMVPzdus88HcTB+hxJIGCc1O6QG+R2p+toipCf9CjfkhKZ
         Ndy7h6uRN1EYXnhOI8K0E3syWmJGpVfs4IARtSp07Z4tMQ0TPasM2HPJs6pNWLtuZy3+
         y3euoAub9b+8Y/e3HycDRmitzm0NAHM7fpEtcqTCAsNuzrL158zM4nLnYpdDHv8SuSPc
         77DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=77mzIJgsnd6fd7VLB24yLdWxFauCP3v4BC+3010BcoI=;
        b=aSSH8OstYV4e7tGrPBN4BGpNEdi3H38pAwCBwXrncuQmNbbFnFD5yrcwSyNa4nHtgd
         ELZzaLU0FeqINqDDuulkjLBgq4oqqlcfohOkYuK6NoT3Prf8AWemmytjz1Irdy34h7gJ
         y8+ZLXqUmuXFTOKDzYlvQDu0z9QgbIjLQaAOwxZQj8c0IiUIS91YAWGe+mWmG9w3gE3y
         Qf/hLnoOrL6gDNM4PeThcZ188ghF9NEvNKZIaO/f7fME2ctfmIdRrXYCHJrdQ4FQEiiU
         fTjqYW3XUSPvvKS5PjMpbK3zQIV3o/Mc7fo3QP5ZDm36bT7UX81JJsjmm18RCYPCyRGN
         R52Q==
X-Gm-Message-State: AOAM532FY4/VgXJTFRMiYFOU1BV2VH7Xg3KsxgmyVGw3NqSxAyaAz3ZE
        luDxpEK4rKmxvgj2q2m6OoohA97BwUy/IKfmj+6bEQ==
X-Google-Smtp-Source: ABdhPJyIgn+m9LaLC8tfpgMI6o5DwNs431a/XgStcK+ZHToBxiaKuPwfiAkwxBcEas0/uG7N+C3oGG+BgIoYjsXskfY=
X-Received: by 2002:a05:6830:1002:: with SMTP id a2mr8203403otp.144.1624008616648;
 Fri, 18 Jun 2021 02:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210617105824.31752-1-wangyanan55@huawei.com> <20210617105824.31752-4-wangyanan55@huawei.com>
In-Reply-To: <20210617105824.31752-4-wangyanan55@huawei.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Fri, 18 Jun 2021 10:29:40 +0100
Message-ID: <CA+EHjTxS9Kae3dXLsC7XDi4neb21JGwOxZzsBN8OevczRPXn8Q@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] KVM: arm64: Tweak parameters of guest cache
 maintenance functions
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yanan,

On Thu, Jun 17, 2021 at 11:58 AM Yanan Wang <wangyanan55@huawei.com> wrote:
>
> Adjust the parameter "kvm_pfn_t pfn" of __clean_dcache_guest_page
> and __invalidate_icache_guest_page to "void *va", which paves the
> way for converting these two guest CMO functions into callbacks in
> structure kvm_pgtable_mm_ops. No functional change.
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h |  9 ++-------
>  arch/arm64/kvm/mmu.c             | 28 +++++++++++++++-------------
>  2 files changed, 17 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 25ed956f9af1..6844a7550392 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -187,10 +187,8 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
>         return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
>  }
>
> -static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
> +static inline void __clean_dcache_guest_page(void *va, size_t size)
>  {
> -       void *va = page_address(pfn_to_page(pfn));
> -
>         /*
>          * With FWB, we ensure that the guest always accesses memory using
>          * cacheable attributes, and we don't have to clean to PoC when
> @@ -203,16 +201,13 @@ static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
>         kvm_flush_dcache_to_poc(va, size);
>  }
>
> -static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
> -                                                 unsigned long size)
> +static inline void __invalidate_icache_guest_page(void *va, size_t size)
>  {
>         if (icache_is_aliasing()) {
>                 /* any kind of VIPT cache */
>                 __flush_icache_all();
>         } else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
>                 /* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
> -               void *va = page_address(pfn_to_page(pfn));
> -
>                 invalidate_icache_range((unsigned long)va,
>                                         (unsigned long)va + size);
>         }
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5742ba765ff9..b980f8a47cbb 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -126,6 +126,16 @@ static void *kvm_host_va(phys_addr_t phys)
>         return __va(phys);
>  }
>
> +static void clean_dcache_guest_page(void *va, size_t size)
> +{
> +       __clean_dcache_guest_page(va, size);
> +}
> +
> +static void invalidate_icache_guest_page(void *va, size_t size)
> +{
> +       __invalidate_icache_guest_page(va, size);
> +}
> +
>  /*
>   * Unmapping vs dcache management:
>   *
> @@ -693,16 +703,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>         kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
>  }
>
> -static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
> -{
> -       __clean_dcache_guest_page(pfn, size);
> -}
> -
> -static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
> -{
> -       __invalidate_icache_guest_page(pfn, size);
> -}
> -
>  static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>  {
>         send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
> @@ -1013,11 +1013,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 prot |= KVM_PGTABLE_PROT_W;
>
>         if (fault_status != FSC_PERM && !device)
> -               clean_dcache_guest_page(pfn, vma_pagesize);
> +               clean_dcache_guest_page(page_address(pfn_to_page(pfn)),
> +                                       vma_pagesize);
>
>         if (exec_fault) {
>                 prot |= KVM_PGTABLE_PROT_X;
> -               invalidate_icache_guest_page(pfn, vma_pagesize);
> +               invalidate_icache_guest_page(page_address(pfn_to_page(pfn)),
> +                                            vma_pagesize);
>         }
>
>         if (device)
> @@ -1219,7 +1221,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>          * We've moved a page around, probably through CoW, so let's treat it
>          * just like a translation fault and clean the cache to the PoC.
>          */
> -       clean_dcache_guest_page(pfn, PAGE_SIZE);
> +       clean_dcache_guest_page(page_address(pfn_to_page(pfn), PAGE_SIZE);
>
>         /*
>          * The MMU notifiers will have unmapped a huge PMD before calling
> --
> 2.23.0


Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
