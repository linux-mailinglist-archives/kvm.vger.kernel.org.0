Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5D0774F99
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjHHX4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjHHX4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:56:14 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC60BD
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:56:13 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c79a5565aso4246467a12.3
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691538973; x=1692143773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XgoBtS59LZuoBAyEloPvADSmnrKxGh/v4r7Okvrfr4o=;
        b=Q6/BjIT8mjhrv07nsAbmoicM/qHEosdwfknD5hDC0C02vvZ/1F1ijLo0pMCvbgvuaJ
         FPehy1Ab0tZr56BJl4xw6YJXPeMsDYqA/G6PU/IK2Y+P7axa5Jirw92bqk3Z0uxK14Si
         6MUrKEbWhluUamwzEwLQ62wXmiS5bUPopiSaIFq9c8iQ/6ukqmm9bbadnll32FMJB96X
         cLXaFhlYzBYIb0wJdq1zRYXKVSRNTLY0EqC/5EGEYC05HropJaGaiUiS4brw6U+DblUi
         slMKXrah5BAK2kSaNWEZOQHSrfv0iH3TM2zaEgPsnX6CM8Jr0kH3SrUlN38WBn08OnQM
         qY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691538973; x=1692143773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XgoBtS59LZuoBAyEloPvADSmnrKxGh/v4r7Okvrfr4o=;
        b=QOnZy4MkKFYs9XAKtcZJOU/rzZmXaBuOm9kghhiNmZIu1PsISRbqWne5Iy6EI5uX0O
         VYkVH6QJV625hd1WmoskaUiwjSfKBDdJMkDG6padmg2mkP+IjtxepMU1o+498KbEiRIb
         lD3cmeLRdbu803FxWzbrSP9LH/h2/CCpyrI1JWA7IuzWR+xEEulU6FYtqroRoZhQxi+y
         H+plyjg6j5oZ/bM+r4V4zG6kxXYxaVcJ27sBGKDZmYO+ug6XWT9/qCID0/8XwLFj8q/k
         vdxYO+pPlGgLofzEaSK97Hpi/DBu48v7YPXZbynaa3t590MilTnLkXiqo8DnYBy4iRJj
         ++qg==
X-Gm-Message-State: AOJu0YxB6gCInsC9knAzqvf6a7OHp81Zok7B9qWPwcXuCRZtBpAC2xEi
        Cf/xSeWCO/NEgXLZVqUVyjxJP79vU84=
X-Google-Smtp-Source: AGHT+IFCy98whUjzcexHxPN7DcnWkTBvcwwuL6i8yxqfvEo6t02c7Nz85aa9s5UPPKWZzlxIm3hK6x9XiBs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7702:0:b0:564:9d36:f3e7 with SMTP id
 s2-20020a637702000000b005649d36f3e7mr21257pgc.0.1691538973466; Tue, 08 Aug
 2023 16:56:13 -0700 (PDT)
Date:   Tue, 8 Aug 2023 16:56:11 -0700
In-Reply-To: <ZNJSBS9w+6cS5eRM@nvidia.com>
Mime-Version: 1.0
References: <20230808071329.19995-1-yan.y.zhao@intel.com> <20230808071702.20269-1-yan.y.zhao@intel.com>
 <ZNI14eN4bFV5eO4W@nvidia.com> <ZNJQf1/jzEeyKaIi@google.com> <ZNJSBS9w+6cS5eRM@nvidia.com>
Message-ID: <ZNLWG++qK1mZcEOq@google.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages for
 NUMA migration
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mike.kravetz@oracle.com, apopple@nvidia.com,
        rppt@kernel.org, akpm@linux-foundation.org, kevin.tian@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023, Jason Gunthorpe wrote:
> On Tue, Aug 08, 2023 at 07:26:07AM -0700, Sean Christopherson wrote:
> > On Tue, Aug 08, 2023, Jason Gunthorpe wrote:
> > > On Tue, Aug 08, 2023 at 03:17:02PM +0800, Yan Zhao wrote:
> > > > @@ -859,6 +860,21 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> > > >  		    !is_last_spte(iter.old_spte, iter.level))
> > > >  			continue;
> > > >  
> > > > +		if (skip_pinned) {
> > > > +			kvm_pfn_t pfn = spte_to_pfn(iter.old_spte);
> > > > +			struct page *page = kvm_pfn_to_refcounted_page(pfn);
> > > > +			struct folio *folio;
> > > > +
> > > > +			if (!page)
> > > > +				continue;
> > > > +
> > > > +			folio = page_folio(page);
> > > > +
> > > > +			if (folio_test_anon(folio) && PageAnonExclusive(&folio->page) &&
> > > > +			    folio_maybe_dma_pinned(folio))
> > > > +				continue;
> > > > +		}
> > > > +
> > > 
> > > I don't get it..
> > > 
> > > The last patch made it so that the NUMA balancing code doesn't change
> > > page_maybe_dma_pinned() pages to PROT_NONE
> > > 
> > > So why doesn't KVM just check if the current and new SPTE are the same
> > > and refrain from invalidating if nothing changed?
> > 
> > Because KVM doesn't have visibility into the current and new PTEs when the zapping
> > occurs.  The contract for invalidate_range_start() requires that KVM drop all
> > references before returning, and so the zapping occurs before change_pte_range()
> > or change_huge_pmd() have done antyhing.
> > 
> > > Duplicating the checks here seems very frail to me.
> > 
> > Yes, this is approach gets a hard NAK from me.  IIUC, folio_maybe_dma_pinned()
> > can yield different results purely based on refcounts, i.e. KVM could skip pages
> > that the primary MMU does not, and thus violate the mmu_notifier contract.  And
> > in general, I am steadfastedly against adding any kind of heuristic to KVM's
> > zapping logic.
> > 
> > This really needs to be fixed in the primary MMU and not require any direct
> > involvement from secondary MMUs, e.g. the mmu_notifier invalidation itself needs
> > to be skipped.
> 
> This likely has the same issue you just described, we don't know if it
> can be skipped until we iterate over the PTEs and by then it is too
> late to invoke the notifier. Maybe some kind of abort and restart
> scheme could work?

Or maybe treat this as a userspace config problem?  Pinning DMA pages in a VM,
having a fair amount of remote memory, *and* expecting NUMA balancing to do anything
useful for that VM seems like a userspace problem.

Actually, does NUMA balancing even support this particular scenario?  I see this
in do_numa_page()

	/* TODO: handle PTE-mapped THP */
	if (PageCompound(page))
		goto out_map;

and then for PG_anon_exclusive

	 * ... For now, we only expect it to be
	 * set on tail pages for PTE-mapped THP.
	 */
	PG_anon_exclusive = PG_mappedtodisk,

which IIUC means zapping these pages to do migrate_on-fault will never succeed.

Can we just tell userspace to mbind() the pinned region to explicitly exclude the
VMA(s) from NUMA balancing?
