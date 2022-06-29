Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB87560008
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 14:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiF2Me3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 08:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiF2Me0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 08:34:26 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D2D25E9C
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 05:34:24 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v9so6657179wrp.7
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 05:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RMd3beZelLDV4ezdXlil9kUUgFUc4WQ7K60RuFKw/HY=;
        b=HFmBaReI/awGH6JxHKqA0o52Y+nCod1lVVxfWiH3shSbFiyHLla0MRYnSnu4q5JFrb
         pbesCQB/VAWWKhlG44+uPHWsAK8kVQwBzQKG2iqOxe0+hvAJ3XrzG+QosKPe2++K2ic9
         x6jQrhQpOyizj2mujtCW7y7EZcvF14yE5o4JLM1mO0UU2x0+JKcgqxlIaN+n5s9ldGd+
         58rB9NtKG/Xcbc6qzcki4hpQhA2IJOBs0vj5LGuwCa6lBtNVuBkP+sfAb56SRs+q3TNN
         cYRCEV6z3ob5N4N0KzC+mlEQuemepjFmB+rKy9LXsHry+gvAQxHAx+rILCbMkFcm6XmT
         B/tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RMd3beZelLDV4ezdXlil9kUUgFUc4WQ7K60RuFKw/HY=;
        b=KbFzfXAqr5VNvQkH+eaMADsX8ME5RgpIsjuO/trUuZ13GaVStV8OoaHFQ0cEMpV+kC
         ft1T27aCQBxdNMXU++BI7Tq94UJFCItymYhuS1+PauNH8HJikqQMY9tWXWiuP40pJMyh
         Q1QVAwrpz+dNprtI/JsQf7PGgSOyFJJiVYRoe/4hP3T9YrafpiEVGG5KcnWndIqaijzH
         K1rXYmQCJG1ri/pnh6xV2iCl9DFmGI818CoMh7ox11epwO8MLDCIm9sInMbZnHkDpfXk
         ItZ0hLLoshrsU9PbBi+O1aU81v2r947Y1iWwtSGs7SnNBmHzBkfyyi8Qal08DxmPhJbY
         fdPA==
X-Gm-Message-State: AJIora/1+Y42AQ6BuWmnS0rvY9Rnj9+IDGpu3qlL+BsLnLBhGCE3gBTM
        TCxD7AslvTiXPtU4bir6z/gRw8Q22qPSIRHmNwMKNQ==
X-Google-Smtp-Source: AGRyM1vHzEYK7IrZRPnLMo7jwGLEHZdyKlPQc/XxGbF7tfOWTgbjqH9u+T/F4WwdgU+B5/nG0P1vjFNjGYxAy24rfgc=
X-Received: by 2002:a5d:4532:0:b0:21b:ab1e:e9fa with SMTP id
 j18-20020a5d4532000000b0021bab1ee9famr2902041wra.214.1656506062697; Wed, 29
 Jun 2022 05:34:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220622192710.2547152-1-pbonzini@redhat.com> <20220622192710.2547152-22-pbonzini@redhat.com>
In-Reply-To: <20220622192710.2547152-22-pbonzini@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 29 Jun 2022 18:04:12 +0530
Message-ID: <CAAhSdy0iVQH__-nD6-ioGSDbAaCaeMxbBp2+-06=wJjDOcxPOQ@mail.gmail.com>
Subject: Re: [PATCH v7 21/23] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        KVM General <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 12:57 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> From: David Matlack <dmatlack@google.com>
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
> Message-Id: <20220516232138.1783324-22-dmatlack@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

For KVM RISC-V
Reviewed-by: Anup Patel <anup@brainfault.org>
Tested-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/arm64/kvm/mmu.c      |  2 +-
>  arch/riscv/kvm/mmu.c      |  5 +----
>  include/linux/kvm_host.h  |  1 +
>  include/linux/kvm_types.h |  6 +++++-
>  virt/kvm/kvm_main.c       | 33 ++++++++++++++++++++++++++++++---
>  5 files changed, 38 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f5651a05b6a8..87f1cd0df36e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -786,7 +786,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  {
>         phys_addr_t addr;
>         int ret = 0;
> -       struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> +       struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
>         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
>                                      KVM_PGTABLE_PROT_R |
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 1c00695ebee7..081f8d2b9cf3 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -350,10 +350,7 @@ static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
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
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a2bbdf3ab086..3554e48406e4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1356,6 +1356,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
>
>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> +int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min);
>  int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
>  void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
>  void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index f328a01db4fe..4d933518060f 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -85,12 +85,16 @@ struct gfn_to_pfn_cache {
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
> index 5b8ae83e09d7..45188d11812c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -396,14 +396,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>                 return (void *)__get_free_page(gfp_flags);
>  }
>
> -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
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
> @@ -411,6 +428,11 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
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
> @@ -424,6 +446,11 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
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
> 2.31.1
>
>
