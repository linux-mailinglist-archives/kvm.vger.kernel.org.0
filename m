Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B793C4C35C4
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 20:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbiBXTVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 14:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiBXTVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 14:21:48 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB302556D7
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 11:21:11 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 12so2605868pgd.0
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 11:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=buZeMMVEZNxJ9jtUAqpS4JjRjBkU1+tY8v267yDAbwc=;
        b=dKy4uqv5OzjCTEM0+zVRvI4NpI0iUo7MzB7YLGzlwAI4Lrt6/v+uA+3GMOek5aOmYA
         EFsG3A0SpditdPp1qoNY+aAoTKLxVWCvKbbr9SwRVJRVhvlsEriUI653++aoCm0wa2mW
         t0qz9ZAQIB8si3KfqE5/QpjVDD4x0fLbA+8XdLyPQBXhZJropKr6+BmaAZCMjlk4qWh/
         Vp/g3n6xAhEk5ar2R3eyPROhWjCMlS0Mhz4G/DAN049AZUZEDp8qB803djgpnSYyWGIO
         MRiqQNYm3ogxIQJxxBK2YZzzZLV70lj4VhRrNF9Mb7X1YCJkkc/Pcp79RM9kMVqdQZwt
         kOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=buZeMMVEZNxJ9jtUAqpS4JjRjBkU1+tY8v267yDAbwc=;
        b=mUP/JqOTGs0oTlLQ+/RpCepKiMYdFEsq63CA/d/6+7M61vk7azP41AHcwUp1EIY+Z6
         tShFh7QaOoeCx8GaX6Xsp5CbaY5Atwstd/yEV72N7nQnAuw6GsrRZYNxcGOzM9acIJ2h
         f88lupVKQp80WDR+e+Mw6fHoZLqzd57rxvBwQekcWqRb3rAE5njHZD1xKJJ0tJD1oQfj
         8EFQn2FMoPnTksEJ8T/xVqrXcSgzVTEUjAT6S+ywffZYNtLgzEHt7lBf12GAV9W0mjlo
         h08rifKyEZdQCbnFdYarqfxn/2MUsC9MgkC5rk/ylm5Q4/mt1usFt/H+ALZeu8d7WBP6
         0P5g==
X-Gm-Message-State: AOAM533SCOg9zT+aJ51AW+lfaGzuiir5bp9WeIzG7X6igmlFo0Nemn3A
        BmsXtqMwpAnD9k2S1N+aWIqtWv63rgMi99a6pgHhVg==
X-Google-Smtp-Source: ABdhPJztyqj5MGLlL7KLRRbyHUJfurkoa20BcSTPWiYpjxXeB7YyxXdCtCmdHdJvPZQnORUYi5UG8svMKjtdQ5rqcOE=
X-Received: by 2002:a62:1c47:0:b0:4f1:2735:3219 with SMTP id
 c68-20020a621c47000000b004f127353219mr4248806pfc.70.1645730470591; Thu, 24
 Feb 2022 11:21:10 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-20-dmatlack@google.com>
 <8735k84i6f.wl-maz@kernel.org>
In-Reply-To: <8735k84i6f.wl-maz@kernel.org>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 24 Feb 2022 11:20:44 -0800
Message-ID: <CALzav=d9dRWCV=R8Ypvy4KzgzPQvd-7qhGTbxso5r9eTh9kkqw@mail.gmail.com>
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

On Thu, Feb 24, 2022 at 3:29 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 03 Feb 2022 01:00:47 +0000,
> David Matlack <dmatlack@google.com> wrote:
> >
> > Allow the capacity of the kvm_mmu_memory_cache struct to be chosen at
> > declaration time rather than being fixed for all declarations. This will
> > be used in a follow-up commit to declare an cache in x86 with a capacity
> > of 512+ objects without having to increase the capacity of all caches in
> > KVM.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 +-
> >  arch/arm64/kvm/mmu.c              | 12 ++++++------
> >  arch/mips/include/asm/kvm_host.h  |  2 +-
> >  arch/x86/include/asm/kvm_host.h   |  8 ++++----
> >  include/linux/kvm_types.h         | 24 ++++++++++++++++++++++--
> >  virt/kvm/kvm_main.c               |  8 +++++++-
> >  6 files changed, 41 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 3b44ea17af88..a450b91cc2d9 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -357,7 +357,7 @@ struct kvm_vcpu_arch {
> >       bool pause;
> >
> >       /* Cache some mmu pages needed inside spinlock regions */
> > -     struct kvm_mmu_memory_cache mmu_page_cache;
> > +     DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
>
> I must say I'm really not a fan of the anonymous structure trick. I
> can see why you are doing it that way, but it feels pretty brittle.

Yeah I don't love it. It's really optimizing for minimizing the patch diff.

The alternative I considered was to dynamically allocate the
kvm_mmu_memory_cache structs. This would get rid of the anonymous
struct and the objects array, and also eliminate the rather gross
capacity hack in kvm_mmu_topup_memory_cache().

The downsides of this approach is more code and more failure paths if
the allocation fails.

>
> >
> >       /* Target CPU and feature flags */
> >       int target;
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index bc2aba953299..9c853c529b49 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -765,7 +765,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >  {
> >       phys_addr_t addr;
> >       int ret = 0;
> > -     struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> > +     DEFINE_KVM_MMU_MEMORY_CACHE(cache) page_cache = {};
> > +     struct kvm_mmu_memory_cache *cache = &page_cache.cache;
> >       struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> >                                    KVM_PGTABLE_PROT_R |
> > @@ -774,18 +775,17 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >       if (is_protected_kvm_enabled())
> >               return -EPERM;
> >
> > +     cache->gfp_zero = __GFP_ZERO;
>
> nit: consider this instead, which preserves the existing flow:

Will do.

>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 26d6c53be083..86a7ebd03a44 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -764,7 +764,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  {
>         phys_addr_t addr;
>         int ret = 0;
> -       DEFINE_KVM_MMU_MEMORY_CACHE(cache) page_cache = {};
> +       DEFINE_KVM_MMU_MEMORY_CACHE(cache) page_cache = {
> +               .cache = { .gfp_zero = __GFP_ZERO},
> +       };
>         struct kvm_mmu_memory_cache *cache = &page_cache.cache;
>         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> @@ -774,7 +776,6 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>         if (is_protected_kvm_enabled())
>                 return -EPERM;
>
> -       cache->gfp_zero = __GFP_ZERO;
>         size += offset_in_page(guest_ipa);
>         guest_ipa &= PAGE_MASK;
>
> but whole "declare the outer structure and just use the inner one"
> hack is... huh... :-/

Yeah it's not great. Unfortunately (or maybe fortunately?) anonymous
structs cannot be defined in functions. So naming the outer struct is
necessary even though we only need to use the inner one.

>
> This hunk also conflicts with what currently sits in -next. Not a big
> deal, but just so you know.

Ack.

>
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index dceac12c1ce5..9575fb8d333f 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -78,14 +78,34 @@ struct gfn_to_pfn_cache {
> >   * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
> >   * holding MMU locks.  Note, these caches act more like prefetch buffers than
> >   * classical caches, i.e. objects are not returned to the cache on being freed.
> > + *
> > + * The storage for the cache objects is laid out after the struct to allow
> > + * different declarations to choose different capacities. If the capacity field
> > + * is 0, the capacity is assumed to be KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE.
> >   */
> >  struct kvm_mmu_memory_cache {
> >       int nobjs;
> > +     int capacity;
> >       gfp_t gfp_zero;
> >       struct kmem_cache *kmem_cache;
> > -     void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> > +     void *objects[0];
>
> The VLA police is going to track you down ([0] vs []).

Thanks!


>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
