Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A748D4CDFFF
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiCDWAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 17:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiCDWAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 17:00:30 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9CD27C79E
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 13:59:41 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id w27so16421534lfa.5
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 13:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BtrvCWsQ64YFp3h9oAPJA16IsXpHc/2uDSri6G0fZb0=;
        b=ktHJgkgtlLgszitMgAArRAwGg3lLTgm+WB+GXS/+G6o5xQbXKURF/ExMeh38VtXdJa
         TIDA2CwC/8hOqePPTSkoPQCMowBnJxz2eFWb5hT8Q1DV8FTo/Uoj5KVPMPghcckYWuwJ
         u7cSmwlvgHoCfClTrHTnrOHK8xuB8Yp/rWytRumvSMS2A16GthaNtXpgyhQXkYU+peF8
         hIu034ZS04AjVWD3Vsi+RM0kmBM0CpuFlk3vBtL0M/2Ey44p84mW5xRpTKr8u5aRHjM/
         AMqJmdV7VdrHGJHjq3n6r5qUkPFGsrtA3jfwjXzvd+otHtu0DrTdWKNZM9wNnwLSZJN9
         cTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BtrvCWsQ64YFp3h9oAPJA16IsXpHc/2uDSri6G0fZb0=;
        b=RkB0sv1II7UuGJUAxjrP8RP+f+Nx0sxMPE59xzTjjHRn3K03Mfmc2lDVeZ7dS+LXFJ
         kNmThzPc/ZGJOENf0I7EB7Cpf75RCRpXuRncHSYQIDAKc/nWr/bYVHC+KwfIfxqxtRy5
         KuKhQWCHINUrjA0rHRsKv7PzOwjRCTfAlL4ap0vmv8iUlyXO0gvAcFlmjel2M2GggcLe
         4Qgej/0J8t2qZEXEKBzKS5x1wXO9SC8QSNPBPDI9Vh/yR3KZ/3TWPt2msI/tmdM3fGXW
         q0iPuglNtv26j3WUqPSclNYeMtZUmt16auvyPIAMCGRXyAo18yGIjUdOSmlZjdzPOrdP
         HMUA==
X-Gm-Message-State: AOAM5327wXClcx2pfBEGoGHVBNgsLwNjpQXOCzY00tPG2fG8y6l6fAj1
        WSDia1ATCLvz68GlBuUYdWzJfDbiXyvmx1wnUwgtlQ==
X-Google-Smtp-Source: ABdhPJzVkw+HYqLcvBkjy1IvnCooXAEHqQZsZ8WKUkAPZ8kRj8mffLOgFvG2nZ3LYI0+KO8bHkdZOvQIzSyZNDh8yS4=
X-Received: by 2002:a05:6512:1287:b0:447:5c8a:c9e2 with SMTP id
 u7-20020a056512128700b004475c8ac9e2mr541951lfs.64.1646431179283; Fri, 04 Mar
 2022 13:59:39 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-20-dmatlack@google.com>
 <8735k84i6f.wl-maz@kernel.org> <CALzav=d9dRWCV=R8Ypvy4KzgzPQvd-7qhGTbxso5r9eTh9kkqw@mail.gmail.com>
In-Reply-To: <CALzav=d9dRWCV=R8Ypvy4KzgzPQvd-7qhGTbxso5r9eTh9kkqw@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 4 Mar 2022 13:59:12 -0800
Message-ID: <CALzav=ccRmvCB+FsN64JujOVpb7-ocdzkiBrYLFGFRQUa7DbWQ@mail.gmail.com>
Subject: Re: [PATCH 19/23] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 11:20 AM David Matlack <dmatlack@google.com> wrote:
>
> On Thu, Feb 24, 2022 at 3:29 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Thu, 03 Feb 2022 01:00:47 +0000,
> > David Matlack <dmatlack@google.com> wrote:
> > >

[...]

> > >
> > >       /* Cache some mmu pages needed inside spinlock regions */
> > > -     struct kvm_mmu_memory_cache mmu_page_cache;
> > > +     DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
> >
> > I must say I'm really not a fan of the anonymous structure trick. I
> > can see why you are doing it that way, but it feels pretty brittle.
>
> Yeah I don't love it. It's really optimizing for minimizing the patch diff.
>
> The alternative I considered was to dynamically allocate the
> kvm_mmu_memory_cache structs. This would get rid of the anonymous
> struct and the objects array, and also eliminate the rather gross
> capacity hack in kvm_mmu_topup_memory_cache().
>
> The downsides of this approach is more code and more failure paths if
> the allocation fails.

I tried changing all kvm_mmu_memory_cache structs to be dynamically
allocated, but it created a lot of complexity to the setup/teardown
code paths in x86, arm64, mips, and riscv (the arches that use the
caches). I don't think this route is worth it, especially since these
structs don't *need* to be dynamically allocated.

When you said the anonymous struct feels brittle, what did you have in
mind specifically?

>
> >
> > >
> > >       /* Target CPU and feature flags */
> > >       int target;
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index bc2aba953299..9c853c529b49 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -765,7 +765,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> > >  {
> > >       phys_addr_t addr;
> > >       int ret = 0;
> > > -     struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> > > +     DEFINE_KVM_MMU_MEMORY_CACHE(cache) page_cache = {};
> > > +     struct kvm_mmu_memory_cache *cache = &page_cache.cache;
> > >       struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> > >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> > >                                    KVM_PGTABLE_PROT_R |
> > > @@ -774,18 +775,17 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> > >       if (is_protected_kvm_enabled())
> > >               return -EPERM;
> > >
> > > +     cache->gfp_zero = __GFP_ZERO;
> >
> > nit: consider this instead, which preserves the existing flow:
>
> Will do.
>
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 26d6c53be083..86a7ebd03a44 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -764,7 +764,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >  {
> >         phys_addr_t addr;
> >         int ret = 0;
> > -       DEFINE_KVM_MMU_MEMORY_CACHE(cache) page_cache = {};
> > +       DEFINE_KVM_MMU_MEMORY_CACHE(cache) page_cache = {
> > +               .cache = { .gfp_zero = __GFP_ZERO},
> > +       };
> >         struct kvm_mmu_memory_cache *cache = &page_cache.cache;
> >         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> > @@ -774,7 +776,6 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >         if (is_protected_kvm_enabled())
> >                 return -EPERM;
> >
> > -       cache->gfp_zero = __GFP_ZERO;
> >         size += offset_in_page(guest_ipa);
> >         guest_ipa &= PAGE_MASK;
> >
> > but whole "declare the outer structure and just use the inner one"
> > hack is... huh... :-/
>
> Yeah it's not great. Unfortunately (or maybe fortunately?) anonymous
> structs cannot be defined in functions. So naming the outer struct is
> necessary even though we only need to use the inner one.

I see two alternatives to make this cleaner:

1. Dynamically allocate just this cache. The caches defined in
vcpu_arch will continue to use DEFINE_KVM_MMU_MEMORY_CACHE(). This
would get rid of the outer struct but require an extra memory
allocation.
2. Move this cache to struct kvm_arch using
DEFINE_KVM_MMU_MEMORY_CACHE(). Then we don't need to stack allocate it
or dynamically allocate it.

Do either of these approaches appeal to you more than the current one?

>
> >
> > This hunk also conflicts with what currently sits in -next. Not a big
> > deal, but just so you know.
>
> Ack.
>
> >
> > > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > > index dceac12c1ce5..9575fb8d333f 100644
> > > --- a/include/linux/kvm_types.h
> > > +++ b/include/linux/kvm_types.h
> > > @@ -78,14 +78,34 @@ struct gfn_to_pfn_cache {
> > >   * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
> > >   * holding MMU locks.  Note, these caches act more like prefetch buffers than
> > >   * classical caches, i.e. objects are not returned to the cache on being freed.
> > > + *
> > > + * The storage for the cache objects is laid out after the struct to allow
> > > + * different declarations to choose different capacities. If the capacity field
> > > + * is 0, the capacity is assumed to be KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE.
> > >   */
> > >  struct kvm_mmu_memory_cache {
> > >       int nobjs;
> > > +     int capacity;
> > >       gfp_t gfp_zero;
> > >       struct kmem_cache *kmem_cache;
> > > -     void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> > > +     void *objects[0];
> >
> > The VLA police is going to track you down ([0] vs []).
>
> Thanks!
>
>
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
