Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3422173BEF6
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 21:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbjFWThv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 15:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjFWTht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 15:37:49 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593251FC6
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 12:37:44 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56942667393so13170917b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 12:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687549063; x=1690141063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xi03PcQlzLUPg60JS878wSJG0NHmPGcINWnga6lnDGk=;
        b=F5XENiq53fCdxmPXSDw3oZXVQxMfKAsVXMbijdo/ZA9TCR0ose5RAsilA4Q+6qJ8U7
         7BG583RXlFo3BvS7H7DUUSoG2pLDtzc1MW61wWgDt0d5UzT5kI4FeDcSLtAdJeZycz1x
         MyvFd9x7x+g/BMDIkcXiN7513doMU9oeMAAK32vJuEdBdY6wiBcNIn7u0qCs+lbAjC7W
         ZLdA1UJcxqCyycHu0AiKHi+v7aB4n+x1sPnR2cFdrk3FCuUqui0vtqXrEE/YvRXuzV97
         zpZPIhs7SFFhoHsNZkE6BAIH6IXNnM0ClLjC8B+rziZuFgZbfj5/U58FytQqAjLa/cUS
         rPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687549063; x=1690141063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xi03PcQlzLUPg60JS878wSJG0NHmPGcINWnga6lnDGk=;
        b=D2pALlaxA/hlDLz618dj2FOUvESTngEOcfiLN83jRFmWXcitzzjPwpvn2E/zAzL9P4
         UB4ylyEOlKMYJfnJFGzssOOWINgJ2NxJXZ5cRTfGpLCWW1NgIjADFCca1AwSYYR2IqiV
         3lv6CgFAn3Sx5ZpOXkD/4ng4MtWZeBWtR3TZIRzHSYK+ETivbphqHE8QBjhtEzi0X3zZ
         5ysnWoJV0XcomsujApZP+pf2mn9FFBJ/cQb/5VQlwK4H2uHC5M439TZ7qDYMt+6E8yVH
         i9QO6PYTsorKWYHCaGbEHmX3hVjY0TMdKMXBkjVJFoltSuwBWpQlRpgyLuDBcC7q8NK6
         RXKw==
X-Gm-Message-State: AC+VfDxCgAKV7Wo35FzhkQ64t4ARCasEGcCK7l4z/tOJa5UAs1qrY+DQ
        lDyZuZX/fk+wumLoqYKFFywFyZWURbs=
X-Google-Smtp-Source: ACHHUZ5iHF1LvGk4T4mkRO1dk7b3zvSByLk2x6aU/q82+4HM5UnIBJsMJHMgNj5jkfNWRAhtpSQnpYPMhAo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4041:0:b0:576:750d:5fdf with SMTP id
 m1-20020a814041000000b00576750d5fdfmr1347898ywn.4.1687549063590; Fri, 23 Jun
 2023 12:37:43 -0700 (PDT)
Date:   Fri, 23 Jun 2023 12:37:42 -0700
In-Reply-To: <20230620190443.GU2244082@ls.amr.corp.intel.com>
Mime-Version: 1.0
References: <cover.1686858861.git.isaku.yamahata@intel.com>
 <e8d3ab4a56d69a09ba74ff1c439f904075d38c16.1686858861.git.isaku.yamahata@intel.com>
 <20230620162835.xsmaao63brira7as@amd.com> <20230620190443.GU2244082@ls.amr.corp.intel.com>
Message-ID: <ZJX0hk+KpQP0KUyB@google.com>
Subject: Re: [RFC PATCH 5/6] KVM: Add flags to struct kvm_gfn_range
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Michael Roth <michael.roth@amd.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023, Isaku Yamahata wrote:
> On Tue, Jun 20, 2023 at 11:28:35AM -0500,
> Michael Roth <michael.roth@amd.com> wrote:
> 
> > On Thu, Jun 15, 2023 at 01:12:18PM -0700, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > TDX and SEV-SNP need to know the reason for a callback by
> > > kvm_unmap_gfn_range().  mmu notifier, set memory attributes ioctl or KVM
> > > gmem callback.  The callback handler changes the behavior or does the
> > > additional housekeeping operation.  For mmu notifier, it's zapping shared
> > > PTE.  For set memory attributes, it's the conversion of memory attributes
> > > (private <=> shared).  For KVM gmem, it's punching a hole in the range, and
> > > releasing the file.
> > 
> > I think it's still an open topic that we need to hear more from Sean about:
> > 
> >   https://lore.kernel.org/lkml/20230522235838.ov3722lcusotzlvo@amd.com/
> > 
> > but I *think* we were leaning toward decoupling the act of invalidating
> > GFNs, vs. the act of invalidating/free'ing gmem pages.

Yes.  Ignore any comments I made about not introducing new hooks, I messed up and
forgot the full context.

> > One concrete example of where this seperation makes sense if with
> > hole-punching. SNP has unique platform-specific stuff it has to do before
> > free'ing that gmem page back to the host. If we try to plumb this through
> > kvm_unmap_gfn_range() via a special flag then it's a little awkward
> > because:
> > 
> > a) Presumably that hole-punch would have occurred after a preceeding
> >    KVM_SET_MEMORY_ATTRIBUTES was issued to switch the page to shared
> >    state in the xarray. So all it should really need to do is handle
> >    that platform-specific behavior, like updating RMP table in case of
> >    SNP. But none of the other details like GFN ranges are relevant in
> >    that case, RMP updates here only need the PFN, so we end up walking
> >    memslots to do GFN->PFN translations, when it would actually be much
> >    more efficient to do these translations by translating the
> >    hole-punched FD offset range to the corresponding folio()'s backing
> >    those ranges
> > 
> > b) It places an unecessary dependency on having an active memslot to do
> >    those translations. This ends up not being an issue with current
> >    version of gmem patchset because the release() happens *before*
> >    gmem_unbind(), so there is a memslot associated with the ranges at
> >    gmem_release() time, but in the initial version of gmem it was the
> >    reverse, so if things ever changed again in this regard we'd once
> >    again have to completely rework how to issue these platform-specific
> >    invalidation callbacks.
> > 
> > I really *really* like having a separate, simple invalidation mechanism
> > in place that just converts FD offsets to PFNs and then passes those on
> > to platform-defined handlers to clean up pages before free'ing them back
> > to the system. It's versatile in that it can be called pretty much
> > anywhere regardless of where we are in KVM lifecycle, it's robust in
> > that it doesn't rely on unecessary outside dependencies, and it avoids
> > added uneeded complexity to paths like kvm_unmap_gfn_range().
> > 
> > That's the approach taken with SNP hypervisor v9 series, with the
> > gmem hook being introduced here:
> > 
> >   https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#m3ad8245235a27ed0f41c359c191dcda6c77af043
> > 
> > and the SEV-SNP implementation of that hook being here:
> > 
> >   https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#m6ac04b44722dbc07839011816e94fadf5ad6794e
> > 
> > Would a similar approach work for TDX? At least WRT cleaning up pages
> > before returning them back to the host? If we could isolate that
> > requirement/handling from all the other aspects of invalidations it
> > really seems like it would cause us less headaches down the road.
> 
> In short, TDX KVM doesn't need an extra callback for invalidating/freeing gmem
> pages. kvm_unmap_gfn_range() callback works.  Instead TDX needs attributes
> (private-or-shared) for it.

Just because TDX doesn't strictly need a separate callback doesn't mean it
wouldn't be useful and beneficial.  SNP doesn't "need" a separate callback either,
i.e. we could make kvm_unmap_gfn_range() work, but it would be ugly and inflexible.

E.g. as Mike pointed out in the other thread, reclaiming physical memory when
SPTEs are zapped is suboptimal if the memory is not actually discarded.

  : There's also cases like userspaces that opt to not discard memory after
  : conversions because they highly favor performance over memory usage. In
  : those cases it would make sense to defer marking the pages as shared in
  : the RMP until the FALLOC_FL_PUNCH_HOLE, rather than triggering it via
  : KVM MMU invalidation path after a conversion.

And to some extent, I would even argue that TDX does "need" the separate hook,
because doing PAGE.WBINVD while holding mmu_lock for write is going to be slooow.
Even if the PAGE.WBINVD isn't redundant, i.e. the memory is never converted back
to private, deferring the cache flush until the backing store is freed is a win
for guest performance during conversions.

> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 1a47cedae8a1..c049c0aa44d6 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -256,12 +256,21 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
> > >  #endif
> > >  
> > >  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
> > > +
> > > +#define KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR		BIT(0)
> > 
> > Can you go into more detail on why special handling is needed for
> > SET_MEM_ATTR?
> 
> When in TDX, the VMM zaps a private page from the encrypted page table and the
> VMM adds the page back to the same GPA, it results in zeroing page and guest
> needs to accept the page again.  When converting a page from shared to private,
> KVM needs to zap only shared pages.  So the callback needs to know this zap
> is for converting shared-to-private or private-to-shared.

That doesn't answer Mike's question.  You answered why KVM needs to know whether
to zap shared vs. private, but not why SET_MEM_ATTR is a special case.

> > > +#define KVM_GFN_RANGE_FLAGS_GMEM_PUNCH_HOLE		BIT(1)
> > > +#define KVM_GFN_RANGE_FLAGS_GMEM_RELEASE		BIT(2)
> > 
> > Would the need to distinguish between PUNCH_HOLE/RELEASE go away in the
> > TDX case if you take the above approach? For SNP, the answer is yes. If
> > that's also the case for TDX I think that would be another argument in
> > favor of decoupling these from existing KVM MMU invalidation path.
> 
> TDX doesn't need gmem_invalidate callback.  TDx doesn't need the difference
> betwee punch hole and release. So in short TDX needs
> KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR and KVM_GFN_RANGE_FLAGS_GMEM.

TDX needs to now what flavor of mappings, i.e. EPT vs. S-EPT, are in scope, TDX
doesn't need to know who/what initiated a zap.  And for that, a simple private vs.
shared flag would suffice.

However, looking at kvm_mem_attrs_changed() again, I think invoking kvm_unmap_gfn_range()
from generic KVM code is a mistake and shortsighted.  Zapping in response to
*any* attribute change is very private/shared centric.  E.g. if/when we extend
attributes to provide per-page RWX protections, zapping existing SPTEs in response
to granting *more* permissions may not be necessary or even desirable.

And for SNP, isn't zapping unnecessary?  KVM needs to update the RMP, but there's
no need to zap NPT entries.  Or do RMP lookups need to be blocked while the RMP
is being updated?

Regardless of what SNP needs to do on attribute changes, rather than using
kvm_unmap_gfn_range(), I think kvm_mem_attrs_changed() should look something like:


	struct kvm_gfn_range gfn_range;
	struct kvm_memory_slot *slot;
	struct kvm_memslots *slots;
	struct kvm_memslot_iter iter;
	bool flush = false;
	int i;

	gfn_range.may_block = true;
	gfn_range.attrs = attrs;

	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
		slots = __kvm_memslots(kvm, i);

		kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
			slot = iter.slot;
			gfn_range.start = max(start, slot->base_gfn);
			gfn_range.end = min(end, slot->base_gfn + slot->npages);
			if (gfn_range.start >= gfn_range.end)
				continue;
			gfn_range.slot = slot;

			flush |= kvm_arch_set_memory_attributes(kvm, &gfn_range);
		}
	}

	if (flush)
		kvm_flush_remote_tlbs(kvm);

At that point, a single "is_private" or "is_shared" flag is awkward and arguably
wrong, because the changing attributes affect both.  The fact that TDX only needs
to zap one or the other is an implementation detail, not a fundamental truth of
the update itself.

We could just have kvm_arch_set_memory_attributes() take individual params instead
of taking a kvm_gfn_range pointer, but that's a missed opportunitiy IMO as this
really is just another variation of gfn-based notification to arch MMU code.

Going with my union suggestion from the MGLRU thread[*], I think we should aim
for making kvm_gfn_range look like this:

struct kvm_gfn_range {
	struct kvm_memory_slot *slot;
	gfn_t start;
	gfn_t end;
	union {
		struct test_clear_young_metadata *metadata;
		unsigned long attributes;
		pte_t pte;
		unsigned long callback_arg; /* needs a better name */
	};
	bool only_private;
	bool only_shared;
	bool may_block;
};

That way kvm_arch_set_memory_attributes() can communicate that it affects both
shared and private mappings, i.e. can leave it to TDX to precisely zap only the
necessary tree.  It's a bit unfortunate that the existing mmu_notifier usage
would need to explicitly say "only_shared", but that's literally one line of code
in __kvm_handle_hva_range(), and on the plus side would clearly document that
hva-based notifications are shared-only.

[*] https://lore.kernel.org/all/ZItNoeWriZgLUaon@google.com
