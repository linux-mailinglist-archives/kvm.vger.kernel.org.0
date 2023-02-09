Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A30690E2B
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 17:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjBIQRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 11:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBIQRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 11:17:46 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693D05C8B7
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 08:17:44 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id o4so1034124qkk.8
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 08:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l1q8uW0wC/1vWAZXokeTVo9Y4zK7AFLn1ur6xrYX4nk=;
        b=fIa9y6cFDGARPrJ6HuTtffnePwOxRbuOWLC7qFX5a3jiIz3aI3ik+3aUq0Lo3y6atO
         AsjYsS14l156jUjaWZM8li0qXoZcJi4T1gHhuBcrwYMS3Lk+rU2D3u2e51rNdn3xtWww
         FdtZtUHr4rErjRJy8kQ1UG63mCdK5f3LhvgEAtP3A1NWcM53pg1m4LsM5O4+xnBzmd5S
         HZvdz3j1Vhn46syiQjSd3BTPQ5vs6GQObiIbyqgmRY3DYP3fCUA1/7vsSdz4p7URcBRu
         /V9e3SbYscRQk8e83DzI375nR2V+5BCXmZOm2Fg7ugFWp27urhJxUeAngTbvXI5cYAFI
         8foA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1q8uW0wC/1vWAZXokeTVo9Y4zK7AFLn1ur6xrYX4nk=;
        b=ovsTdGntn29NWZC/bh3AXPos/yCVCT681Zxl9L0/jZNZd7vT0ZnNCkw4OEu23vywaC
         WWRBNd47Np+xiyF2ycRRrJDCmuJdBBqS7HKl7+2qeNfw+evk7su9kvo61MCxxxGgoRYG
         ZFcxxm6zpbtmJi3NmigsCb8alDMfogYd+8nuxj46r1drc3k311ZL8IECD6Tj/a64Rup7
         ExtcQ97vEedNs0V27BV8/MPiaL5tHP74uXE4kKnATZwLhR+uh8PBMwaWpjsHxV0ZBG7i
         mM1Wvh+K+N4zJ/UYaU4i053YdSwXMdiCYvdSLdUVHtYepVMGWv7j/vyXv1168OmlmLH9
         0fbQ==
X-Gm-Message-State: AO0yUKUT2sXN55BU65Bjog4X/sf7lxvuiLZYYn+XZt9XZnLJyc+I3nR4
        XBhm1Lh+GrQvWQ2SGX9XR85k9jmsnLmF65sWrKccMw==
X-Google-Smtp-Source: AK7set+q5rR8zs3pDnPffpgGO74oRQG7dg4owyQaCmgIY+opp5dyvSdYVuNeefYP2QHG8fZFj8OPgv4nwH550N7P0zs=
X-Received: by 2002:a37:c8e:0:b0:735:274f:816e with SMTP id
 136-20020a370c8e000000b00735274f816emr989957qkm.390.1675959463346; Thu, 09
 Feb 2023 08:17:43 -0800 (PST)
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <20230206165851.3106338-5-ricarkol@google.com>
 <cae4a1d9-b5c2-2929-6d88-5a3fbe719651@redhat.com> <CAOHnOrxqEsbRD302Wwn9N06d6xj5NWy4p+C9DBjEm6Z4z2FvXg@mail.gmail.com>
In-Reply-To: <CAOHnOrxqEsbRD302Wwn9N06d6xj5NWy4p+C9DBjEm6Z4z2FvXg@mail.gmail.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 9 Feb 2023 08:17:31 -0800
Message-ID: <CAOHnOrwprM8v3xXCA5sEVD1cHVQRS6vsPvdXiC1NocrzyQcoYw@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To:     Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
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

"(> > > +     if (data->mc_capacity < nr_pages)
> > > +             return -ENOMEM;
> > > +
> > > +     phys = kvm_pte_to_phys(pte);
> > > +     prot = kvm_pgtable_stage2_pte_prot(pte);
> > > +
> > > +     ret = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, &new, phys,
> > > +                                              level, prot, mc, force_pte);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     if (!stage2_try_break_pte(ctx, data->mmu)) {
> > > +             childp = kvm_pte_follow(new, mm_ops);
> > > +             kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
> > > +             mm_ops->put_page(childp);
> > > +             return -EAGAIN;
> > > +     }
> > > +
> > > +     /*
> > > +      * Note, the contents of the page table are guaranteed to be made
> > > +      * visible before the new PTE is assigned because stage2_make_pte()
> > > +      * writes the PTE using smp_store_release().
> > > +      */
> > > +     stage2_make_pte(ctx, new);
> > > +     dsb(ishst);
> > > +     data->mc_capacity -= nr_pages;
> > > +     return 0;
> > > +}
> > > +
> >
> > I think it's possible 'data->mc_capability' to be replaced by 'mc->nobjs'
> > because they're same thing. With this, we needn't to maintain a duplicate
> > 'data->mc_capability' since 'data->mc' has been existing.
>
> Ah, nice, yes. That would be simpler.
>

Actually, there's a complication. The memcache details are hidden
inside of pgtable.c,
so different types of memcaches (for vhe and nvhe) can be used for allocations.
Specifically, the memcache objects are passed as an opaque pointer ("void *")
and can be used with "struct hyp_pool" and "struct kvm_mmu_memory_cache".

So, here are all the options that I can think of:

        1. stage2_split_walker() is just used on the VHE case with the
        "struct kvm_mmu_memory_cache" memcache, so we could just use it
        instead of a "void *":

                kvm_pgtable_stage2_split(..., struct kvm_mmu_memory_cache *mc);

        However, it could be used for the NVHE case as well, plus
        this would go against the overall design of pgtable.c which tries
        to use opaque objects for most things.

        2. add a "get_nobjs()" method to both memcaches. This is tricky
        because "struct hyp_pool" doesn't directly track its capacity. I
        would rather not mess with it.

        3. This whole accounting of available pages in the memcache is
        needed because of the way I implemented stage2_split_walker() and
        the memcache interface.  stage2_split_walker() tries to allocate
        as many pages for the new table as allowed by the capacity of the
        memcache. The issue with blindingly trying until the allocation
        fails is that kvm_mmu_memory_cache_alloc() WARNs and tries to
        allocate using GFP_ATOMIC when !nobjs. We don't want to do that,
        so we could extend kvm_pgtable_mm_ops.zalloc_page() with a
        NO_GFP_ATOMIC_ON_EMPTY (or similar). This flag would have to be
        ignored on the hyp side.

        4. what this patch is currently doing: tracking the capacity by
        hand.

I prefer options 4 and 3. WDYT?

Thanks,
Ricardo

> Thanks!
> Ricardo
>
> >
> > > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > > +                          void *mc, u64 mc_capacity)
> > > +{
> > > +     struct stage2_split_data split_data = {
> > > +             .mmu            = pgt->mmu,
> > > +             .memcache       = mc,
> > > +             .mc_capacity    = mc_capacity,
> > > +     };
> > > +
> > > +     struct kvm_pgtable_walker walker = {
> > > +             .cb     = stage2_split_walker,
> > > +             .flags  = KVM_PGTABLE_WALK_LEAF,
> > > +             .arg    = &split_data,
> > > +     };
> > > +
> > > +     return kvm_pgtable_walk(pgt, addr, size, &walker);
> > > +}
> > > +
> > >   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> > >                             struct kvm_pgtable_mm_ops *mm_ops,
> > >                             enum kvm_pgtable_stage2_flags flags,
> > >
> >
> > Thanks,
> > Gavin
> >
