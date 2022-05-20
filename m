Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7A252F61B
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiETXVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346800AbiETXVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:21:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD414BFE8
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:21:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nr2-20020a17090b240200b001df2b1bfc40so12670798pjb.5
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vzWy36SV70oGThfupbvfIZkL0sVsaRG9SWDfcZdtlJQ=;
        b=lN7Y7+QKSnX1g1Z60bLjM4iWl87aoR9T814AacfSRyZTmRTEWJITp6vJ3NWWyXiCvR
         dfLpe7ie2QGt+4SwLHfiAbpbvkXDREfRJUXkXG4E7c5GBMx/ZReoL2VSWOkTGlXLyhv/
         nTas9unyMXpH3yHzeM0t61M9UULwnLUDyx0yz4Bomp+CeF/M/Zg7W7UulInMqWpYLQQh
         lCO5L1/oEvDUVdJqrswD5YnGpv/+Ccm04dnC4nQmy9NcKlHUpQ+RSOt3Cbr3/XcwpPzI
         f6VQFWzEj5O0pjup6nFrisxtnmrM2ze7I9BypHVYzrIkZNwA61cXhgYYu4/rjwzFEmFe
         xXQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vzWy36SV70oGThfupbvfIZkL0sVsaRG9SWDfcZdtlJQ=;
        b=re5iXlSMdgd1Qj4eB3vBMmectNHRRQk11pWJ6M5OngMZd7lPL1X9np8vVIZMV29kp5
         IT2f1sNhObOnDXPY9rE7KEwOd0A0asxp5mzq+aLUtkl26YOZDc3/UcM92gFkuAXJR7tu
         26ULCCcOAfIy/w7FvcJmZa7qYR1hORnrq4zn+x95nkPFQc3ev0QG3bdcRFUO59ozsFrH
         ML7+q8Pf0/oXPSdBkvgXlhW+UigwIpMNknHGL5LT0jLJbtxzwtwCl0zDNiDRImBun6UG
         0a+rmRlNib5GUOTbmMTyO1z2g54IGKztMX1B/SZ85GSOte3rAG8fHk8jcF1JZnskqKBx
         Rrhw==
X-Gm-Message-State: AOAM5339cWE9RdSnN/E2vy0VQwtB0fC3+j/OT3zwP9/grmy3Ha1VouLf
        YrIPhhwe5yzuQANWAnJ5R1joglnKjIyRO+Hl1rZPfQ==
X-Google-Smtp-Source: ABdhPJySUNVZa4u/tFmo/ooXWHV/EsEeWLOC2QwQKyKmHE2nFS6KRVSmNTIX6aSBDSvERUiVXg2IFDKwt9TqKAzdoOU=
X-Received: by 2002:a17:902:dac3:b0:161:a5b5:c8c0 with SMTP id
 q3-20020a170902dac300b00161a5b5c8c0mr11804733plx.61.1653088872630; Fri, 20
 May 2022 16:21:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com> <20220516232138.1783324-22-dmatlack@google.com>
In-Reply-To: <20220516232138.1783324-22-dmatlack@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 20 May 2022 16:21:01 -0700
Message-ID: <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 4:24 PM David Matlack <dmatlack@google.com> wrote:
>
> Allow the capacity of the kvm_mmu_memory_cache struct to be chosen at
> declaration time rather than being fixed for all declarations. This will
> be used in a follow-up commit to declare an cache in x86 with a capacity
> of 512+ objects without having to increase the capacity of all caches in
> KVM.
>
> This change requires each cache now specify its capacity at runtime,
> since the cache struct itself no longer has a fixed capacity known at
> compile time. To protect against someone accidentally defining a
> kvm_mmu_memory_cache struct directly (without the extra storage), this
> commit includes a WARN_ON() in kvm_mmu_topup_memory_cache().
>
> In order to support different capacities, this commit changes the
> objects pointer array to be dynamically allocated the first time the
> cache is topped-up.
>
> While here, opportunistically clean up the stack-allocated
> kvm_mmu_memory_cache structs in riscv and arm64 to use designated
> initializers.
>
> No functional change intended.
>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/arm64/kvm/mmu.c      |  2 +-
>  arch/riscv/kvm/mmu.c      |  5 +----
>  include/linux/kvm_types.h |  6 +++++-
>  virt/kvm/kvm_main.c       | 33 ++++++++++++++++++++++++++++++---
>  4 files changed, 37 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 53ae2c0640bc..f443ed845f85 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -764,7 +764,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  {
>         phys_addr_t addr;
>         int ret = 0;
> -       struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> +       struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
>         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
>                                      KVM_PGTABLE_PROT_R |
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index f80a34fbf102..4d95ebe4114f 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -347,10 +347,7 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>         int ret = 0;
>         unsigned long pfn;
>         phys_addr_t addr, end;
> -       struct kvm_mmu_memory_cache pcache;
> -
> -       memset(&pcache, 0, sizeof(pcache));
> -       pcache.gfp_zero = __GFP_ZERO;
> +       struct kvm_mmu_memory_cache pcache = { .gfp_zero = __GFP_ZERO };
>
>         end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>         pfn = __phys_to_pfn(hpa);
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index ac1ebb37a0ff..68529884eaf8 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -83,12 +83,16 @@ struct gfn_to_pfn_cache {
>   * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
>   * holding MMU locks.  Note, these caches act more like prefetch buffers than
>   * classical caches, i.e. objects are not returned to the cache on being freed.
> + *
> + * The @capacity field and @objects array are lazily initialized when the cache
> + * is topped up (__kvm_mmu_topup_memory_cache()).
>   */
>  struct kvm_mmu_memory_cache {
>         int nobjs;
>         gfp_t gfp_zero;
>         struct kmem_cache *kmem_cache;
> -       void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> +       int capacity;
> +       void **objects;
>  };
>  #endif
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e089db822c12..5e2e75014256 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -369,14 +369,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>                 return (void *)__get_free_page(gfp_flags);
>  }
>
> -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
>  {
> +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
>         void *obj;
>
>         if (mc->nobjs >= min)
>                 return 0;
> -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> +
> +       if (unlikely(!mc->objects)) {
> +               if (WARN_ON_ONCE(!capacity))
> +                       return -EIO;
> +
> +               mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> +               if (!mc->objects)
> +                       return -ENOMEM;
> +
> +               mc->capacity = capacity;

Do we want to ensure the minimum value of the capacity? I think
otherwise, we may more likely start using memory from GFP_ATOMIC if
the capacity is less than, say 5? But the minimum value seems related
to each cache type.

> +       }
> +
> +       /* It is illegal to request a different capacity across topups. */
> +       if (WARN_ON_ONCE(mc->capacity != capacity))
> +               return -EIO;
> +
> +       while (mc->nobjs < mc->capacity) {
> +               obj = mmu_memory_cache_alloc_obj(mc, gfp);
>                 if (!obj)
>                         return mc->nobjs >= min ? 0 : -ENOMEM;
>                 mc->objects[mc->nobjs++] = obj;
> @@ -384,6 +401,11 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>         return 0;
>  }
>
> +int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +{
> +       return __kvm_mmu_topup_memory_cache(mc, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, min);
> +}
> +
>  int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
>  {
>         return mc->nobjs;
> @@ -397,6 +419,11 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
>                 else
>                         free_page((unsigned long)mc->objects[--mc->nobjs]);
>         }
> +
> +       kvfree(mc->objects);
> +
> +       mc->objects = NULL;
> +       mc->capacity = 0;
>  }
>
>  void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> --
> 2.36.0.550.gb090851708-goog
>
