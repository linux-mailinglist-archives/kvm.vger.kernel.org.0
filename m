Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1978A659044
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 19:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiL2SXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 13:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbiL2SWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 13:22:53 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6261513E9A
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 10:22:52 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id qk9so46788762ejc.3
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 10:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Zv7x2EwFCE53UN71pKw+MbADH4Kh0HBRItue+SrAL2A=;
        b=Ee4FFnw5RsWkdyVuYQT+CnRP7mXIoRfHw8CK1ekzd2++R/UDJKdHJd6ZwYEUdi6Pb6
         ib84b9pC7iF3eWIRvhUvTpJco632cgQeOELTEnvNEoAj9FsI2IlX98qWU8W3eJWRDL2J
         hctJVjlSMzGJSD9p6Om9p7e5rp5Qm3lmeYOrVaw/9vMie1Wtg2KwzDWPo0JMKde7c5XS
         2upOasG6vJj3EpyNZqR0B/XywVJf4VvVS+loSNyCTMChMaHEkTRaR9O+UBskoXe8ell/
         oiTx4otoO/sK1bUhXkK943h80fVpLCYMpcwjJNhgTrVSBnOFBAiSv/kpYaLlzTG7Jjq0
         WIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zv7x2EwFCE53UN71pKw+MbADH4Kh0HBRItue+SrAL2A=;
        b=MEMAYDQQku7FZvoPwsdbuOkF1wHdS7z8YYyQcmnAIS27EpSkJGqxXHUFu2Nq1NcERA
         nsr6n+IX3DLiS+vaoCtDtJtFQa6xROFYcBmrTrTUXp1cHi3Nopuxc0NneYHsN9HxL9tw
         1BNxOaDBukXHLqtaQfcaO0APLu6XjpPm74rZ+wpvE4sGdM5w5wkz35b9wU2Yv/aoqJaz
         skSazg4i9nV116NIDcGGu5vTD44WXYp+f0t2VITzAg5YUPzysFy6iWOLSYcMADxCac1k
         DHexCpL833xSsYz4fO5K0clMfpd3KaQYmuNVIoQ0YDlwnsHKICvuqyIX2hdxByzUifB0
         iRrQ==
X-Gm-Message-State: AFqh2kqkrhZ/77/rQ8L79vpHBBWpMx969ooK2AuicKQlKTCNbkMIbXj9
        aX7Q8tOVZ/Qy3pGDQSr8nfVkHw3loixWkVa9ExiKzIdiYi1SsQ==
X-Google-Smtp-Source: AMrXdXtqzZ9speXcpg3QjBVDwROQXiCqiwodonvRHFg07N7Y1lkVWp9l4JkmcQjuHhRzXlSIzQovqJwSsscR+2Sk0tM=
X-Received: by 2002:a17:906:6a04:b0:803:3f50:a7af with SMTP id
 qw4-20020a1709066a0400b008033f50a7afmr1959083ejc.78.1672338170886; Thu, 29
 Dec 2022 10:22:50 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-7-vipinsh@google.com>
 <CANgfPd_=WwrgVVQnooZLCSXpSnEjRVOdt6qZtrvhO_wmxc5Tzg@mail.gmail.com> <CAHVum0dkqp1MnMyqoOQdGp2K74h5NFrzZ4KaT=0+ezVP-JJnVQ@mail.gmail.com>
In-Reply-To: <CAHVum0dkqp1MnMyqoOQdGp2K74h5NFrzZ4KaT=0+ezVP-JJnVQ@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 29 Dec 2022 10:22:38 -0800
Message-ID: <CANgfPd8KU3pqSYu--bSP1QesmkrnLqqB8QH_8rZVS=8S4HNBDQ@mail.gmail.com>
Subject: Re: [Patch v3 6/9] KVM: Provide NUMA node support to kvm_mmu_memory_cache{}
To:     Vipin Sharma <vipinsh@google.com>
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

On Wed, Dec 28, 2022 at 2:08 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Tue, Dec 27, 2022 at 11:10 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > On Wed, Dec 21, 2022 at 6:35 PM Vipin Sharma <vipinsh@google.com> wrote:
> > >
> > > Add 'node' variable in kvm_mmu_memory_cache{} to denote which NUMA node
> > > this cache should allocate memory from. Default initialize to
> > > NUMA_NO_NODE in all architectures.
> > >
> > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > > ---
> > >  arch/arm64/kvm/arm.c      |  2 +-
> > >  arch/arm64/kvm/mmu.c      |  4 +++-
> > >  arch/mips/kvm/mips.c      |  2 ++
> > >  arch/riscv/kvm/mmu.c      |  2 +-
> > >  arch/riscv/kvm/vcpu.c     |  2 +-
> > >  arch/x86/kvm/mmu/mmu.c    | 22 ++++++++++++----------
> > >  include/linux/kvm_host.h  |  6 ++++++
> > >  include/linux/kvm_types.h |  2 ++
> > >  8 files changed, 28 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 9c5573bc4614..52a41f4532e2 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -340,7 +340,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >         vcpu->arch.target = -1;
> > >         bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> > >
> > > -       vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> > > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache, NULL, NUMA_NO_NODE);
> > >
> > >         /*
> > >          * Default value for the FP state, will be overloaded at load
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 31d7fa4c7c14..bd07155e17fa 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -894,12 +894,14 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> > >  {
> > >         phys_addr_t addr;
> > >         int ret = 0;
> > > -       struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
> > > +       struct kvm_mmu_memory_cache cache;
> > >         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> > >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> > >                                      KVM_PGTABLE_PROT_R |
> > >                                      (writable ? KVM_PGTABLE_PROT_W : 0);
> > >
> > > +       INIT_KVM_MMU_MEMORY_CACHE(&cache, NULL, NUMA_NO_NODE);
> > > +
> > >         if (is_protected_kvm_enabled())
> > >                 return -EPERM;
> > >
> > > diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> > > index a25e0b73ee70..b017c29a9340 100644
> > > --- a/arch/mips/kvm/mips.c
> > > +++ b/arch/mips/kvm/mips.c
> > > @@ -304,6 +304,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >                      HRTIMER_MODE_REL);
> > >         vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
> > >
> > > +       vcpu->arch.mmu_page_cache.node = NUMA_NO_NODE;
> > > +
> >
> > It looks weird to have MIPS not using the initialization MACRO. Should
> > it just have a GFP_ZERO parameter?
>
> MIPS is not setting GFP_ZERO explicitly before my series, so, I didn't
> make it GFP_ZERO. I am not sure if MIPS needs it or not, I tried to
> keep the same functionality in my patch.
>
> May be someone from MIPS can tell more about it.

That makes sense, I just don't want to see MIPS get left behind
because we move the cache init logic to a macro or function. Folks
might update the init function but forget to update MIPS too.

>
> >
> > >         /*
> > >          * Allocate space for host mode exception handlers that handle
> > >          * guest mode exits
> > > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > > index 34b57e0be2ef..119de4520cc6 100644
> > > --- a/arch/riscv/kvm/mmu.c
> > > +++ b/arch/riscv/kvm/mmu.c
> > > @@ -353,9 +353,9 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> > >         phys_addr_t addr, end;
> > >         struct kvm_mmu_memory_cache pcache = {
> > >                 .gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
> > > -               .gfp_zero = __GFP_ZERO,
> > >         };
> > >
> > > +       INIT_KVM_MMU_MEMORY_CACHE(&pcache, NULL, NUMA_NO_NODE);
> > >         end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
> > >         pfn = __phys_to_pfn(hpa);
> > >
> > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > index 7c08567097f0..189b14feb365 100644
> > > --- a/arch/riscv/kvm/vcpu.c
> > > +++ b/arch/riscv/kvm/vcpu.c
> > > @@ -161,7 +161,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >
> > >         /* Mark this VCPU never ran */
> > >         vcpu->arch.ran_atleast_once = false;
> > > -       vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> > > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache, NULL, NUMA_NO_NODE);
> > >         bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
> > >
> > >         /* Setup ISA features available to VCPU */
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 6f6a10d7a871..23a3b82b2384 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -5954,13 +5954,14 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
> > >  {
> > >         int ret;
> > >
> > > -       vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> > > -       vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
> > > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_pte_list_desc_cache,
> > > +                                 pte_list_desc_cache, NUMA_NO_NODE);
> > >
> > > -       vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> > > -       vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> > > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache,
> > > +                                 mmu_page_header_cache, NUMA_NO_NODE);
> > >
> > > -       vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> > > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadow_page_cache,
> > > +                                 NULL, NUMA_NO_NODE);
> > >         spin_lock_init(&vcpu->arch.mmu_shadow_page_cache_lock);
> > >
> > >         vcpu->arch.mmu = &vcpu->arch.root_mmu;
> > > @@ -6124,14 +6125,15 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> > >         node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> > >         kvm_page_track_register_notifier(kvm, node);
> > >
> > > -       kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> > > -       kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
> > > +       INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache,
> > > +                                 mmu_page_header_cache, NUMA_NO_NODE);
> > >
> > > -       kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
> > > +       INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache,
> > > +                                 NULL, NUMA_NO_NODE);
> > >         spin_lock_init(&kvm->arch.split_shadow_page_cache_lock);
> > >
> > > -       kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
> > > -       kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
> > > +       INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache,
> > > +                                 pte_list_desc_cache, NUMA_NO_NODE);
> > >
> > >         return 0;
> > >  }
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index a262e15ebd19..719687a37ef7 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -2302,4 +2302,10 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
> > >  /* Max number of entries allowed for each kvm dirty ring */
> > >  #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
> > >
> > > +#define INIT_KVM_MMU_MEMORY_CACHE(_cache, _kmem_cache, _node) ({       \
> > > +       (_cache)->kmem_cache = _kmem_cache;                             \
> > > +       (_cache)->gfp_zero = __GFP_ZERO;                                \
> > > +       (_cache)->node = _node;                                         \
> > > +})
> > > +
> >
> > Given that this initialization is probably not happening in a super
> > hot path, is there any downside to just using a function for the
> > initialization?
> >
>
> It can totally be a function as well. I will make it function in the
> next version.

Awesome, thanks.

>
>
> > >  #endif
> > > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > > index 76de36e56cdf..9c70ce95e51f 100644
> > > --- a/include/linux/kvm_types.h
> > > +++ b/include/linux/kvm_types.h
> > > @@ -97,6 +97,8 @@ struct kvm_mmu_memory_cache {
> > >         struct kmem_cache *kmem_cache;
> > >         int capacity;
> > >         void **objects;
> > > +       /* Node on which memory should be allocated by default */
> > > +       int node;
> > >  };
> > >  #endif
> > >
> > > --
> > > 2.39.0.314.g84b9a713c41-goog
> > >
