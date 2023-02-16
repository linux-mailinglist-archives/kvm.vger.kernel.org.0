Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D22699BFA
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBPSO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPSOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:14:55 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30B530C6
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:14:53 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id ow4so1142651qkn.1
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3r4RDI5/ND95D3FHxdSWmhErNcQIg7xBHStY1H5A3qI=;
        b=PkGFoumz4SnpwQ9+GSogVdbWJa5o6EivrdKnfSyuk8a/f26g6y79N3g7WvWfbhdLxU
         u29Vk2vEylYCPZDe0jZtL7FZZOM16+RUng88NX+XpwVgMk0+vzgioTgUfqrylVbNvSa1
         HhDQsiVktAgMDyM/eXrX1A814Me3tQ/8RKd4A6hvsrhDO63IfGPwFOoAsZ+H7lwDgwP2
         L8YgS+m6CyKXRlfkzEkyYmz+hZIaBAyeSsrpLLAx7Gcu4EmIcZJIjhDWLD+6PUf+N4lJ
         63a6aELYwD0+NJWSo9/CVFfU1AXNUIOxv3vL4KddB8utJaVdKYqTVdESeP8dv5M8OFBy
         TdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3r4RDI5/ND95D3FHxdSWmhErNcQIg7xBHStY1H5A3qI=;
        b=5qv42E632bmI/dKwe5TcuPmdYlJxT0jFfU+QoP/1fZ3EXumbu7A7w3MPH5GVskDuo4
         dB6Xg++B0br6FymQFW23njDtkhAVKP/d3EgUDI63j4wqmJStSSuixLrYOhOVXjAGE9qE
         ABf6CBZGdSungDpwfD8+fOnBWmRRX2jftw6AOOux3StWVGPGApZIJSF2/NP1hNTkPy7U
         rLoTsEW37zVe0Znb4+IRFL5Vw4OAV1zSgk9RntMh/YjOy4gsRUSELywO08OuRypb97uC
         GabpnctRhVdtU1GAYcXQ7qBEFncHvZThHd6P70pSLiBSfgOxVh7SZE2yOkP9c400pPua
         bZzA==
X-Gm-Message-State: AO0yUKUAUXrkHaL32ps+powJx6oT+f5bi+bVU5AROWhTOC1vUkgHcQNm
        N8oEF9O/BnbVrHBNP443C7+Ex1cwAraRkcMTVl9OfQ==
X-Google-Smtp-Source: AK7set+eJOrr95yLq/jzBEi0O1hYYKrmXkVkBeJACrnwd3R1mPd45ws8fND3WIrOB9gNmbpc0CdvWP8hYP3+kUJIWPg=
X-Received: by 2002:a05:620a:1eb:b0:73b:79fb:ffb8 with SMTP id
 x11-20020a05620a01eb00b0073b79fbffb8mr399194qkn.11.1676571292328; Thu, 16 Feb
 2023 10:14:52 -0800 (PST)
MIME-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com> <20230215174046.2201432-5-ricarkol@google.com>
 <Y+16gsTbsZyUBMAt@linux.dev> <CAOHnOrzoBp7zh=yjjtgto-m1p1P1sWQ5gJRTzChemGk93J+T4g@mail.gmail.com>
In-Reply-To: <CAOHnOrzoBp7zh=yjjtgto-m1p1P1sWQ5gJRTzChemGk93J+T4g@mail.gmail.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 16 Feb 2023 10:14:41 -0800
Message-ID: <CAOHnOry-RG=nyvbWkSV5pCh--9pp=DtcXXNL=bguAW3o+XV0Pw@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
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

On Thu, Feb 16, 2023 at 10:07 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Feb 15, 2023 at 4:36 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Wed, Feb 15, 2023 at 05:40:38PM +0000, Ricardo Koller wrote:
> >
> > [...]
> >
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > index fed314f2b320..e2fb78398b3d 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -1229,6 +1229,111 @@ int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> > >       return 0;
> > >  }
> > >
> > > +struct stage2_split_data {
> > > +     struct kvm_s2_mmu               *mmu;
> > > +     void                            *memcache;
> > > +     u64                             mc_capacity;
> > > +};
> > > +
> > > +/*
> > > + * Get the number of page-tables needed to replace a bock with a fully
> > > + * populated tree, up to the PTE level, at particular level.
> > > + */
> > > +static inline u32 stage2_block_get_nr_page_tables(u32 level)
> > > +{
> > > +     switch (level) {
> > > +     /* There are no blocks at level 0 */
> > > +     case 1: return 1 + PTRS_PER_PTE;
> > > +     case 2: return 1;
> > > +     case 3: return 0;
> > > +     default:
> > > +             WARN_ON_ONCE(1);
> > > +             return ~0;
> > > +     }
> > > +}
> >
> > This doesn't take into account our varying degrees of hugepage support
> > across page sizes. Perhaps:
> >
> >   static inline int stage2_block_get_nr_page_tables(u32 level)
> >   {
> >           if (WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
> >                            level >= KVM_PGTABLE_MAX_LEVELS))
> >                   return -EINVAL;
> >
> >           switch (level) {
> >           case 1:
> >                 return PTRS_PER_PTE + 1;
> >           case 2:
> >                 return 1;
> >           case 3:
> >                 return 0;
> >           }
> >   }
> >
> > paired with an explicit error check and early return on the caller side.
>
> Sounds good, will add this to the next version.
>
> >
> > > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > > +                            enum kvm_pgtable_walk_flags visit)
> > > +{
> > > +     struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > > +     struct stage2_split_data *data = ctx->arg;
> > > +     kvm_pte_t pte = ctx->old, new, *childp;
> > > +     enum kvm_pgtable_prot prot;
> > > +     void *mc = data->memcache;
> > > +     u32 level = ctx->level;
> > > +     u64 phys, nr_pages;
> > > +     bool force_pte;
> > > +     int ret;
> > > +
> > > +     /* No huge-pages exist at the last level */
> > > +     if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > > +             return 0;
> > > +
> > > +     /* We only split valid block mappings */
> > > +     if (!kvm_pte_valid(pte))
> > > +             return 0;
> > > +
> > > +     nr_pages = stage2_block_get_nr_page_tables(level);
> > > +     if (data->mc_capacity >= nr_pages) {
> > > +             /* Build a tree mapped down to the PTE granularity. */
> > > +             force_pte = true;
> > > +     } else {
> > > +             /*
> > > +              * Don't force PTEs. This requires a single page of PMDs at the
> > > +              * PUD level, or a single page of PTEs at the PMD level. If we
> > > +              * are at the PUD level, the PTEs will be created recursively.
> > > +              */
> > > +             force_pte = false;
> > > +             nr_pages = 1;
> > > +     }
> >
> > Do we know if the 'else' branch here is even desirable? I.e. has
> > recursive shattering been tested with PUD hugepages (HugeTLB 1G) and
> > shown to improve guest performance while dirty tracking?
>
> Yes, I think it's desirable. Here are some numbers on a neoverse n1 using
> dirty_log_perf_test (152 vcpus, 1G each, 4K pages):
>
> CHUNK_SIZE=1G
> Enabling dirty logging time: 2.468014046s
> Iteration 1 dirty memory time: 4.275447900s
>
> CHUNK_SIZE=2M
> Enabling dirty logging time: 2.692124099s
> Iteration 1 dirty memory time: 4.284682220s
>
> Enabling dirty logging increases as expected when using a smaller CHUNK_SIZE,
> but not by too much (~9%). It's a fair tradeoff for users not willing
> to allocate large
> caches.
>
> >
> > The observations we've made on existing systems were that the successive
> > break-before-make operations led to a measurable slowdown in guest
> > pre-copy performance. Recursively building the page tables should
> > actually result in *more* break-before-makes than if we just let the vCPU
> > fault path lazily shatter hugepages.
> >
> > --
> > Thanks,
> > Oliver

There is a terribly offensive image that was attached to the previous
email. I would like to apologize for
attaching it. I don't know how that happened.

Ricardo
