Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10436573B08
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 18:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbiGMQUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 12:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236611AbiGMQUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 12:20:23 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C125B10543
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 09:20:21 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y141so10666442pfb.7
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 09:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=USCiroLCrx1eIq2fE4NYNm6R4ZIjqYme9mNE6xCMEl8=;
        b=Xf6ZO3PaMEbsrJI7bGyWHJCyL4Xdxdh/LvmuLEmZg+LZJ81dntvVDVy3z1J1R1NXiN
         PhWXnLZcZcy5NUwWwLNBfUaheFglFCLfwr5rBhXCTHCS4/tEJC3XRDNouu4cOuiWfyTZ
         Yr+TTFMlF7k/64LmrChBbZ4LDctiuOGpvEJusA+lTqZLIkNzCDEAli8hOr8vtvnodtX3
         TVvP7dap8Iic5YyG1DYOvHj8X5EQC2mDGBGl1mLRJpl4Knzu909OK9Hos13GNQDvvjWh
         n8El1qMVOxfswaUcb5Kd3/CzFNI+qRrQEvOLPTCHTyBGIEm4oGqkl1nYA57Ef7+CPwmB
         l4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=USCiroLCrx1eIq2fE4NYNm6R4ZIjqYme9mNE6xCMEl8=;
        b=TqAQ8pBoip25BFkbnAfms1SYXB7vystaHMcKU4nZqXrIY+1NgxWdmySBafBzE7OZoN
         AFO4oF1n4ZcOvQWg1nhJmio8mnRUVbwcKGlYtIigX16v7Txn8QZ3I67NJ7hxE/tu1c08
         UBaLYjRS+pbjc3jw8mXWn18ahmzKhfvfGVYk1+KDibftyF28Ys0iGY9dZpFtCnB6iGAx
         fjaT8nZwr5uMFzdQU73TNEcpXWXSMAIPIT6vRraODHS5q/ss8p6fvpRRuWHnlt6pBND+
         nKlM1i0yzDE0ktoapZng7Wo9fbD7OLpz0vnEWP89oDsVCK3c386ZKNSMMEuABnSNcsl6
         db3A==
X-Gm-Message-State: AJIora/PTsSBNZqUiu65g5PkJ3AmX2sU6o62arbBptLHEqplHXnyjByX
        bDVsxUj9fzVw1WeS1GCJ2BjVNQ==
X-Google-Smtp-Source: AGRyM1v7wfGBI2arrpxI58f3YqoOlxayVweaZeWPprONuwOCugvkhCrXpy57Q1/ZI9gHgsylwPlTig==
X-Received: by 2002:a63:1619:0:b0:40d:37aa:9ace with SMTP id w25-20020a631619000000b0040d37aa9acemr3477474pgl.609.1657729221066;
        Wed, 13 Jul 2022 09:20:21 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id jj14-20020a170903048e00b0016c5b2a16ffsm3886385plb.142.2022.07.13.09.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 09:20:20 -0700 (PDT)
Date:   Wed, 13 Jul 2022 16:20:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 9/9] KVM: x86/mmu: Promote pages in-place when
 disabling dirty logging
Message-ID: <Ys7wwPRaUOmvqFjb@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <20220321224358.1305530-10-bgardon@google.com>
 <YkH0O2Qh7lRizGtC@google.com>
 <CANgfPd8V_34TBb3m-JpmczZnY3t5aaFwHNZq1W0eknumbrXCRw@mail.gmail.com>
 <Ys4CD/VHtbrBVi6a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys4CD/VHtbrBVi6a@google.com>
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

On Tue, Jul 12, 2022, Sean Christopherson wrote:
> On Mon, Mar 28, 2022, Ben Gardon wrote:
> > On Mon, Mar 28, 2022 at 10:45 AM David Matlack <dmatlack@google.com> wrote:
> > > If iter.old_spte is not a leaf, the only loop would always continue to
> > > the next SPTE. Now we try to promote it and if that fails we run through
> > > the rest of the loop. This seems broken. For example, in the next line
> > > we end up grabbing the pfn of the non-leaf SPTE (which would be the PFN
> > > of the TDP MMU page table?) and treat that as the PFN backing this GFN,
> > > which is wrong.
> > >
> > > In the worst case we end up zapping an SPTE that we didn't need to, but
> > > we should still fix up this code.
> 
> My thought to remedy this is to drop the @pfn argument to kvm_mmu_max_mapping_level().
> It's used only for historical reasons, where KVM didn't walk the host page tables
> to get the max mapping level and instead pulled THP information out of struct page.
> I.e. KVM needed the pfn to get the page.
> 
> That would also allow KVM to use huge pages for things that aren't backed by
> struct page (I know of at least one potential use case).
> 
> I _think_ we can do the below.  It's compile tested only at this point, and I
> want to split some of the changes into separate patches, e.g. the WARN on the step-up
> not going out-of-bounds.  I'll put this on the backburner for now, it's too late
> for 5.20, and too many people are OOO :-)

Heh, that was a bit of a lie.  _Now_ it's going on the backburner.

Thinking about the pfn coming from the old leaf SPTE made me realize all of the
information we need to use __make_spte() during promotion is available in the
existing leaf SPTE.

If KVM first retrieves a PRESENT leaf SPTE, then pfn _can't_ be different, because
that would mean KVM done messed up and didn't zap existing entries in response to
a MMU notifier invalidation, and holding mmu_lock prevents new invalidations.
And because the primary MMU must invalidate before splitting a huge page, having a
valid leaf SPTE means that host mapping level can't become stale until mmu_lock is
dropped.  In other words, KVM can compute the huge pfn by using the smaller pfn
and adjusting based on the target mapping level.

As for the EPT memtype, that can also come from the existing leaf SPTE.  KVM only
forces the memtype for host MMIO pfns, and if the primary MMU maps a huge page that
straddles host MMIO (UC) and regular memory (WB), then the kernel is already hosed.
If the VM doesn't have non-coherent DMA, then the EPT memtype will be WB regardless
of the page size.  That means KVM just needs to reject promotion if the VM has
non-coherent DMA and the target pfn is not host MMIO, else KVM can use the leaf's
memtype as-is.

Using the pfn avoids gup() (fast-only, but still), and using the memtype avoids
having to split vmx_get_mt_mask() and add another kvm_x86_ops hook.

And digging into all of that yielded another optimization.  kvm_tdp_page_fault()
needs to restrict the host mapping level if and only if it may consume the guest
MTRRs.  If KVM ignores the guest MTRRs, then the fact that they're inconsistent
across a TDP page is irrelevant because the _guest_ MTRRs are completely virtual
and are not consumed by either EPT or NPT.  I doubt this meaningfully affects
whether or not KVM can create huge pages for real world VMs, but it does avoid
having to walk the guest variable MTRRs when faulting in a huge page.

Compile tested only at this point, but I'm mostly certain my logic is sound.

int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
{
	/*
	 * If the guest's MTRRs may be used, restrict the mapping level to
	 * ensure KVM uses a consistent memtype across the entire mapping.
	 */
	if (kvm_may_need_guest_mtrrs(vcpu->kvm)) {
		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
			gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);

			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
				break;
		}
	}

	return direct_page_fault(vcpu, fault);
}

static int try_promote_to_huge_page(struct kvm *kvm,
				    struct rsvd_bits_validate *rsvd_bits,
				    const struct kvm_memory_slot *slot,
				    u64 leaf_spte, struct tdp_iter *iter)
{
	struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
	kvm_pfn_t pfn;
	u64 new_spte;
	u8 mt_mask;

	if (WARN_ON_ONCE(slot->flags & KVM_MEM_READONLY))
		return -EINVAL;

	pfn = spte_to_pfn(leaf_spte) & ~(KVM_PAGES_PER_HPAGE(iter->level) - 1);
	mt_mask = leaf_spte & shadow_memtype_mask;

	/*
	 * Bail if KVM needs guest MTRRs to compute the memtype and will not
	 * force the memtype (host MMIO).  There is no guarantee the guest uses
	 * a consistent MTRR memtype for the entire huge page, and MTRRs are
	 * tracked per vCPU, not per VM.
	 */
	if (kvm_may_need_guest_mtrrs(kvm) && !kvm_is_mmio_pfn(pfn))
		return -EIO;

	__make_spte(kvm, sp, slot, ACC_ALL, iter->gfn, pfn, 0, false, true,
		    true, mt_mask, rsvd_bits, &new_spte);

	return tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
}
