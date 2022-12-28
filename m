Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3BA658732
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 23:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiL1WIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 17:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiL1WIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 17:08:31 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB6F1573F
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 14:08:30 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 188so2417153ybi.9
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 14:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SvSokKNDJAEaCfD8TFes2TiKScYf/bbpWdZ8iiamMQI=;
        b=G6tLhpCctymZGps2C7oBomuMrBuFUXYLeMlyrHYm3Ewycr1zXfhDAD3ZXQ9C/LujI5
         pNUj2Y8vsyzwDdfYSoOhRNdCAnpZJ0viroJi0xsxmiN2ZwSFSKjHE/q375i0GHYX47Xz
         S59I1WUDc2OS7fe12DnmoB5NqrLS4MS1R5kZQy6XTXaxjrdKtscaXueETMeCY6oTDfl1
         0ZlR6ouZBcw9krdKyLVwRBq9+yO+iSl6bl0J3eQZhoiGXqN54/WH9OR79MRccWvN5zW1
         mJx/WEYHt+WrZeiexQCDuGcPDgliv9ppZ24lFCEnYmDBZ5VmeOHtWICkOp0hm/lNv4Uy
         OZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SvSokKNDJAEaCfD8TFes2TiKScYf/bbpWdZ8iiamMQI=;
        b=if3ki4qLYuAc6jYegBK3Gg7Z0wsaA3wSHixLEOaleDOsQfRCHjhvNTTt32lj4KT70d
         ISRWxMUExo4VlvS75RgpsQSfs+LU2VDL+jkXmgz/ZUh0CEfVpXzroMG35HdQEM34g0pM
         3yiVkq+YAjbVG/5sENsShFcKsASeZP/9Zk3+Dsype++/IJ978Wp0RHc9SNvD+CgBUtnP
         3jxeQxMX0dCdfAzol1ZyyFXeKnciUGhc+XNpPoRwenIfOkJt5KuEY+7xiTkadqORqoUY
         ByEMRacFDbVOXk7u4u8zJU4PwpXAuIxvSwb6+NpTVGfe9ZP9can2Q7eCrW6eZDrjqVss
         kHBg==
X-Gm-Message-State: AFqh2kqNDiJbhmm5/ED6MSPCbcI/r+n2KHbR8tvY2flLpZsmr1h6u1md
        mZQHi1m1MAEhsNPKdaXjbY5h9+5B3To+l6GDqiYdAA==
X-Google-Smtp-Source: AMrXdXsNne76itO5MZNg4bRFkxgBFTb13yuqOJTu1VvBm4GBb6avUKvLFmThJUW29NQhtlXUQg+taJlE/cCxo4qaKNU=
X-Received: by 2002:a25:3745:0:b0:75b:b01c:6a2c with SMTP id
 e66-20020a253745000000b0075bb01c6a2cmr2908470yba.166.1672265309768; Wed, 28
 Dec 2022 14:08:29 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-6-vipinsh@google.com>
 <CANgfPd-x+w8DnyfnLeMCWApbNyAbxOdS8e-nhoSq7txSu2mHXA@mail.gmail.com>
In-Reply-To: <CANgfPd-x+w8DnyfnLeMCWApbNyAbxOdS8e-nhoSq7txSu2mHXA@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 28 Dec 2022 14:07:54 -0800
Message-ID: <CAHVum0fy_rKO1+yg0_Y8ZFA8cpYHK1Q3qA=pZx5pjG1Et3ftkw@mail.gmail.com>
Subject: Re: [Patch v3 5/9] KVM: x86/mmu: Allocate TDP page table's page on
 correct NUMA node on split
To:     Ben Gardon <bgardon@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 27, 2022 at 11:02 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Dec 21, 2022 at 6:35 PM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > When dirty log is enabled, huge pages are split. Page table's pages
>
> Nit: Suggest "When huge pages are split for dirty log" since this can
> happen at various points during dirty logging.
> Same below.
>

Yeah, this should be updated.

> > during the split are allocated based on the current thread NUMA node or
> > mempolicy. This causes inefficient page table accesses if underlying
> > page is on a different NUMA node
> >
> > Allocate page table's pages on the same NUMA node as the underlying huge
> > page when dirty log is enabled and huge pages are split.
> >
> > The performance gain during the pre-copy phase of live migrations of a
> > 416 vCPUs and 11 TiB memory VM  on a 8 node host was seen in the range
> > of 130% to 150%.
> >
> > Suggested-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++----
> >  include/linux/kvm_host.h   | 18 ++++++++++++++++++
> >  2 files changed, 26 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 4974fa96deff..376b8dceb3f9 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1403,7 +1403,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
> >         return spte_set;
> >  }
> >
> > -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> > +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(int nid, gfp_t gfp)
> >  {
> >         struct kvm_mmu_page *sp;
> >
> > @@ -1413,7 +1413,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> >         if (!sp)
> >                 return NULL;
> >
> > -       sp->spt = (void *)__get_free_page(gfp);
> > +       sp->spt = kvm_mmu_get_free_page(nid, gfp);
> > +
>
> Just so that kvm_mmu_get_free_page isn't dead code in the previous
> commit, I'd do this refactor there and just pass NUMA_NO_NODE here.
>

Agreed.

> >         if (!sp->spt) {
> >                 kmem_cache_free(mmu_page_header_cache, sp);
> >                 return NULL;
> > @@ -1427,6 +1428,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> >                                                        bool shared)
> >  {
> >         struct kvm_mmu_page *sp;
> > +       int nid;
> > +
> > +       nid = kvm_pfn_to_page_table_nid(spte_to_pfn(iter->old_spte));
> >
> >         /*
> >          * Since we are allocating while under the MMU lock we have to be
> > @@ -1437,7 +1441,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> >          * If this allocation fails we drop the lock and retry with reclaim
> >          * allowed.
> >          */
> > -       sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> > +       sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_NOWAIT | __GFP_ACCOUNT);
> >         if (sp)
> >                 return sp;
> >
> > @@ -1449,7 +1453,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> >                 write_unlock(&kvm->mmu_lock);
> >
> >         iter->yielded = true;
> > -       sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
> > +       sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_KERNEL_ACCOUNT);
> >
> >         if (shared)
> >                 read_lock(&kvm->mmu_lock);
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index d48064503b88..a262e15ebd19 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1583,6 +1583,24 @@ void kvm_arch_sync_events(struct kvm *kvm);
> >  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
> >
> >  struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn);
> > +
> > +/*
> > + * Tells the appropriate NUMA node location of the page table's page based on
> > + * pfn it will point to.
> > + *
> > + * Return the nid of the page if pfn is valid and backed by a refcounted page,
> > + * otherwise, return the nearest memory node for the current CPU.
>
> Nit: Should this be "current thread"?

I will say "current thread CPU". As memory nodes are near to CPUs
whereas threads can execute on multiple CPUs throughout its lifetime.

>
> > + */
> > +static inline int kvm_pfn_to_page_table_nid(kvm_pfn_t pfn)
>
> This could just be kvm_pfn_nid (or even better kvm_pfn_node_id) since
> this really has nothing to do with page tables. We just want to know
> which NUMA node backs the given PFN.

Apart from NUMA node backing the given PFN, it can also return the
nearest NUMA node via numa_mem_id(). So, it is actually telling which
NUMA node is the best one for the page table's page, given a PFN.


>
> > +{
> > +       struct page *page = kvm_pfn_to_refcounted_page(pfn);
> > +
> > +       if (page)
> > +               return page_to_nid(page);
> > +       else
> > +               return numa_mem_id();
> > +}
> > +
> >  bool kvm_is_zone_device_page(struct page *page);
> >
> >  struct kvm_irq_ack_notifier {
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
