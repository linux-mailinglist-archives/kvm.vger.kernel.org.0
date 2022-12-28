Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2350B658734
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 23:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbiL1WIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 17:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiL1WIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 17:08:36 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6852164A8
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 14:08:35 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 83so17924570yba.11
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 14:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YFmT1RbRY2MiIuNa8vXvMeSsKecA+sxnnRk+S1rI/aM=;
        b=ZGTQYSeMLqYLGKqHPxnJbd0Zwy4SZ/AJKqP0yOjlh5NSKTiFVLZBgh5CzCApX4TtD3
         Jtje+YOR8NfqnfYpXbRUlUwhS0MygaKlU/dQQrSo5oyri0BGQvOwyjCuM+PzRu4nw5He
         X+VZmZkKTGas1/h+Cj6JPBr2f2R8nNWibgk5ZQ8jmId5WI2N+dXjgZlzErzQ6JbI0Pf8
         GiN3wP+70Ayem/IawljNtJOKhxaabL2PzYEp3mUl4coFQh9yeg4CeFQZ5F1ePQQsMJ7P
         tkRFu4KaknR/qKEX2HTv/RTuGnGQy30Rv7mL5zTOucZuMMptA8AlRv0oxMth07tvaov/
         nHeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YFmT1RbRY2MiIuNa8vXvMeSsKecA+sxnnRk+S1rI/aM=;
        b=x8eIqGf/gPM/TVW2t5eIVG9It9MTmYJUJhKCX908roDyiB0zp1bhf3hKbrc98e+AQS
         IKC3XReWhyx4dG48qPh8TIcNiIsW68Sk0q7jUAu+LygTDpHAzaOA2QOdCwdLnbqq/8IZ
         6wu1Rh/TtNcBMWuhrWh6UGydbZVaEFdZOyXpprf03bQSENMVsmSN3zAp9YjOZiNbs7da
         6Jzx6DpNf3AH25UmB/dPmhkEcHgbE+F+6nH/3/S3Rx5SAkmVxrFY1D+0xtCPixqJQPzh
         ZIrBJX7qHR5i+yFiDJiuJykII+Gpy3oArN4I1xRE2q8n5ATSxQ9aMWRneH+ZD6c8XO0L
         4inQ==
X-Gm-Message-State: AFqh2krjV0R18U4wXydtGI7RdqwHj//URlfFBHhhRFmgAtG/pYf+ECrD
        WXZIW3LtcTFCt536SGt7Qiv7ueqjeW5X48MPcmAMVw==
X-Google-Smtp-Source: AMrXdXscwnAjfQMw8pz5aqoA/zKx0GyOKdolI4qVIQsjUfEHRJGsh3dGUkro5TfGdkIZdsPoD9Ws+WmRx+cwCdgEhag=
X-Received: by 2002:a25:ad44:0:b0:784:7f2f:fc14 with SMTP id
 l4-20020a25ad44000000b007847f2ffc14mr789383ybe.2.1672265314525; Wed, 28 Dec
 2022 14:08:34 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-7-vipinsh@google.com>
 <CANgfPd_=WwrgVVQnooZLCSXpSnEjRVOdt6qZtrvhO_wmxc5Tzg@mail.gmail.com>
In-Reply-To: <CANgfPd_=WwrgVVQnooZLCSXpSnEjRVOdt6qZtrvhO_wmxc5Tzg@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 28 Dec 2022 14:07:58 -0800
Message-ID: <CAHVum0dkqp1MnMyqoOQdGp2K74h5NFrzZ4KaT=0+ezVP-JJnVQ@mail.gmail.com>
Subject: Re: [Patch v3 6/9] KVM: Provide NUMA node support to kvm_mmu_memory_cache{}
To:     Ben Gardon <bgardon@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 27, 2022 at 11:10 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Dec 21, 2022 at 6:35 PM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > Add 'node' variable in kvm_mmu_memory_cache{} to denote which NUMA node
> > this cache should allocate memory from. Default initialize to
> > NUMA_NO_NODE in all architectures.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/arm64/kvm/arm.c      |  2 +-
> >  arch/arm64/kvm/mmu.c      |  4 +++-
> >  arch/mips/kvm/mips.c      |  2 ++
> >  arch/riscv/kvm/mmu.c      |  2 +-
> >  arch/riscv/kvm/vcpu.c     |  2 +-
> >  arch/x86/kvm/mmu/mmu.c    | 22 ++++++++++++----------
> >  include/linux/kvm_host.h  |  6 ++++++
> >  include/linux/kvm_types.h |  2 ++
> >  8 files changed, 28 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 9c5573bc4614..52a41f4532e2 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -340,7 +340,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >         vcpu->arch.target = -1;
> >         bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> >
> > -       vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache, NULL, NUMA_NO_NODE);
> >
> >         /*
> >          * Default value for the FP state, will be overloaded at load
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 31d7fa4c7c14..bd07155e17fa 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -894,12 +894,14 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >  {
> >         phys_addr_t addr;
> >         int ret = 0;
> > -       struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
> > +       struct kvm_mmu_memory_cache cache;
> >         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> >                                      KVM_PGTABLE_PROT_R |
> >                                      (writable ? KVM_PGTABLE_PROT_W : 0);
> >
> > +       INIT_KVM_MMU_MEMORY_CACHE(&cache, NULL, NUMA_NO_NODE);
> > +
> >         if (is_protected_kvm_enabled())
> >                 return -EPERM;
> >
> > diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> > index a25e0b73ee70..b017c29a9340 100644
> > --- a/arch/mips/kvm/mips.c
> > +++ b/arch/mips/kvm/mips.c
> > @@ -304,6 +304,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >                      HRTIMER_MODE_REL);
> >         vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
> >
> > +       vcpu->arch.mmu_page_cache.node = NUMA_NO_NODE;
> > +
>
> It looks weird to have MIPS not using the initialization MACRO. Should
> it just have a GFP_ZERO parameter?

MIPS is not setting GFP_ZERO explicitly before my series, so, I didn't
make it GFP_ZERO. I am not sure if MIPS needs it or not, I tried to
keep the same functionality in my patch.

May be someone from MIPS can tell more about it.

>
> >         /*
> >          * Allocate space for host mode exception handlers that handle
> >          * guest mode exits
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index 34b57e0be2ef..119de4520cc6 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -353,9 +353,9 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> >         phys_addr_t addr, end;
> >         struct kvm_mmu_memory_cache pcache = {
> >                 .gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
> > -               .gfp_zero = __GFP_ZERO,
> >         };
> >
> > +       INIT_KVM_MMU_MEMORY_CACHE(&pcache, NULL, NUMA_NO_NODE);
> >         end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
> >         pfn = __phys_to_pfn(hpa);
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 7c08567097f0..189b14feb365 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -161,7 +161,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >
> >         /* Mark this VCPU never ran */
> >         vcpu->arch.ran_atleast_once = false;
> > -       vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache, NULL, NUMA_NO_NODE);
> >         bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
> >
> >         /* Setup ISA features available to VCPU */
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6f6a10d7a871..23a3b82b2384 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5954,13 +5954,14 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
> >  {
> >         int ret;
> >
> > -       vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> > -       vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
> > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_pte_list_desc_cache,
> > +                                 pte_list_desc_cache, NUMA_NO_NODE);
> >
> > -       vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> > -       vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache,
> > +                                 mmu_page_header_cache, NUMA_NO_NODE);
> >
> > -       vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadow_page_cache,
> > +                                 NULL, NUMA_NO_NODE);
> >         spin_lock_init(&vcpu->arch.mmu_shadow_page_cache_lock);
> >
> >         vcpu->arch.mmu = &vcpu->arch.root_mmu;
> > @@ -6124,14 +6125,15 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> >         node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> >         kvm_page_track_register_notifier(kvm, node);
> >
> > -       kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> > -       kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
> > +       INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache,
> > +                                 mmu_page_header_cache, NUMA_NO_NODE);
> >
> > -       kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
> > +       INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache,
> > +                                 NULL, NUMA_NO_NODE);
> >         spin_lock_init(&kvm->arch.split_shadow_page_cache_lock);
> >
> > -       kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
> > -       kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
> > +       INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache,
> > +                                 pte_list_desc_cache, NUMA_NO_NODE);
> >
> >         return 0;
> >  }
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index a262e15ebd19..719687a37ef7 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2302,4 +2302,10 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
> >  /* Max number of entries allowed for each kvm dirty ring */
> >  #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
> >
> > +#define INIT_KVM_MMU_MEMORY_CACHE(_cache, _kmem_cache, _node) ({       \
> > +       (_cache)->kmem_cache = _kmem_cache;                             \
> > +       (_cache)->gfp_zero = __GFP_ZERO;                                \
> > +       (_cache)->node = _node;                                         \
> > +})
> > +
>
> Given that this initialization is probably not happening in a super
> hot path, is there any downside to just using a function for the
> initialization?
>

It can totally be a function as well. I will make it function in the
next version.


> >  #endif
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index 76de36e56cdf..9c70ce95e51f 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -97,6 +97,8 @@ struct kvm_mmu_memory_cache {
> >         struct kmem_cache *kmem_cache;
> >         int capacity;
> >         void **objects;
> > +       /* Node on which memory should be allocated by default */
> > +       int node;
> >  };
> >  #endif
> >
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
