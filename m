Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE4E64E3E6
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 23:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiLOWqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 17:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiLOWqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 17:46:16 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46D91BEA6;
        Thu, 15 Dec 2022 14:46:14 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id t17so654523pjo.3;
        Thu, 15 Dec 2022 14:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=70UEAdLijYUUT2GZlgygFajSME7oYVbsKDLQszW/WD8=;
        b=Yj262UnvDEvuxt0tKlJdfndKc62TqyyFAzo7i3pQ/eEQjOzGJvPbLkxLGhx/bP3j6N
         wN2uKxM6mTsiH3HrlLGDCLP23LPVvvMu+HDcOV2kUpEeRrqN5TkjF4W33pz4nPWagx+i
         aOu07FBAA4sF13Ipjj609vsVWyw+Qr0W+ljzoMJUNyG6r73JKhyRToH94LISGv926Q+T
         ZjVLXv7dMlsoBk+wDa5qOLyDTJTcBqTkxT8TFBC6YBXv5Y37zj7FoGbc+fSfDboB6B6Z
         lEscnOKsYmVGdhsNDhKKxKzThdQPxj73PwBkVXTyZ3gz504gpMBPajKyB+HVG84hdbGb
         zQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=70UEAdLijYUUT2GZlgygFajSME7oYVbsKDLQszW/WD8=;
        b=40LkCOU0Y4PqIEtFTK2elS1cmhS8fgVhhPfAbQJKHDlRAY7neQAV0BUP+ATeEswees
         4aAHkuS8msAad1+KOI8izmOiJ212wy994ez5vMaVhwrk+360skwJMiMpBavxP54h2qEV
         av9mpRReE+FT7SvYmv64W/veJc7cesxQPmZPqjsdRewHR86GyjEnEn1+E1GhOMe0+TOM
         TWca71pgjwva11mlvzv22NubWjOUdHRaDySzRHXJXuUo/lISU+r8hCFzNQ6rNgqB8WV2
         Dm1lN+aqZ8Vz8Be6AxLPgEZCmiyyZHS6vHOUPz68/221o2HyR7fHUzgGEZQCuXQ7pC0i
         8E5Q==
X-Gm-Message-State: ANoB5pn3iEQVtqN1ZaTrNy8xe0+9oDHqW/vXgdxZGyhZc5RZRXVQbrVq
        uzRvECaHgMa2Byej0JrH/fCrZ2V4OLI=
X-Google-Smtp-Source: AA0mqf6fAv5n6OH/pWkd/mBMquDcQCM3BiEivdzjOGX5f0rehc+LbO+MdWJsp7GYyYOv32MYRcj58A==
X-Received: by 2002:a05:6300:8119:b0:af:88f7:26ae with SMTP id bs25-20020a056300811900b000af88f726aemr6502951pzc.23.1671144374116;
        Thu, 15 Dec 2022 14:46:14 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id mm7-20020a17090b358700b002191e769546sm160336pjb.4.2022.12.15.14.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 14:46:13 -0800 (PST)
Date:   Thu, 15 Dec 2022 14:46:12 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 047/108] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20221215224612.GI3632095@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <9e8346b692eb377576363a028c3688c66f3c0bfe.1667110240.git.isaku.yamahata@intel.com>
 <f3cb9b24c24122c590dd4ba27434b5c069f00372.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f3cb9b24c24122c590dd4ba27434b5c069f00372.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 11:17:32AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2022-10-29 at 23:22 -0700, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > TDX supports only write-back(WB) memory type for private memory
> > architecturally so that (virtualized) memory type change doesn't make sense
> > for private memory.  Also currently, page migration isn't supported for TDX
> > yet. (TDX architecturally supports page migration. it's KVM and kernel
> > implementation issue.)
> > 
> > Regarding memory type change (mtrr virtualization and lapic page mapping
> > change), pages are zapped by kvm_zap_gfn_range().  On the next KVM page
> > fault, the SPTE entry with a new memory type for the page is populated.
> > Regarding page migration, pages are zapped by the mmu notifier. On the next
> > KVM page fault, the new migrated page is populated.  Don't zap private
> > pages on unmapping for those two cases.
> > 
> > When deleting/moving a KVM memory slot, zap private pages. Typically
> > tearing down VM.  Don't invalidate private page tables. i.e. zap only leaf
> > SPTEs for KVM mmu that has a shared bit mask. The existing
> > kvm_tdp_mmu_invalidate_all_roots() depends on role.invalid with read-lock
> > of mmu_lock so that other vcpu can operate on KVM mmu concurrently.  It
> > marks the root page table invalid and zaps SPTEs of the root page
> > tables. The TDX module doesn't allow to unlink a protected root page table
> > from the hardware and then allocate a new one for it. i.e. replacing a
> > protected root page table.  Instead, zap only leaf SPTEs for KVM mmu with a
> > shared bit mask set.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     | 85 ++++++++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/mmu/tdp_mmu.c | 24 ++++++++---
> >  arch/x86/kvm/mmu/tdp_mmu.h |  5 ++-
> >  3 files changed, 103 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index faf69774c7ce..0237e143299c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1577,8 +1577,38 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >  	if (kvm_memslots_have_rmaps(kvm))
> >  		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
> >  
> > -	if (is_tdp_mmu_enabled(kvm))
> > -		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> > +	if (is_tdp_mmu_enabled(kvm)) {
> > +		bool zap_private;
> > +
> > +		if (kvm_slot_can_be_private(range->slot)) {
> > +			if (range->flags & KVM_GFN_RANGE_FLAGS_RESTRICTED_MEM)
> > +				/*
> > +				 * For private slot, the callback is triggered
> > +				 * via falloc.  Mode can be allocation or punch
> 				       ^
> 				       fallocate(), please?
> 
> > +				 * hole.  Because the private-shared conversion
> > +				 * is done via
> > +				 * KVM_MEMORY_ENCRYPT_REG/UNREG_REGION, we can
> > +				 * ignore the request from restrictedmem.
> > +				 */
> > +				return flush;
> 
> Sorry why "private-shared conversion is done via KVM_MEMORY_ENCRYPT_REG" results
> in "we can ignore the requres from restrictedmem"?
> 
> If we punch a hole, the pages are de-allocated, correct?

With v10 UPM, we can have zap_private = true always.

With v9 UPM, the callback is triggered both for allocation and punch-hole without
any further argument.  With v10 UPM, the callback is triggered only for punching
hole.  

> 
> > +			else if (range->flags & KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR) {
> > +				if (range->attr == KVM_MEM_ATTR_SHARED)
> > +					zap_private = true;
> > +				else {
> > +					WARN_ON_ONCE(range->attr != KVM_MEM_ATTR_PRIVATE);
> > +					zap_private = false;
> > +				}
> > +			} else
> > +				/*
> > +				 * kvm_unmap_gfn_range() is called via mmu
> > +				 * notifier.  For now page migration for private
> > +				 * page isn't supported yet, don't zap private
> > +				 * pages.
> > +				 */
> > +				zap_private = false;
> 
> Page migration is not the only reason that KVM will receive the MMU notifer --
> just say something like "for now all private pages are pinned during VM's life 
> time".

Will update the comment.


> 
> 
> > +		}
> > +		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush, zap_private);
> > +	}
> >  
> >  	return flush;
> >  }
> > @@ -6066,11 +6096,48 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
> >  	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
> >  }
> >  
> > +static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> > +{
> > +	bool flush = false;
> > +
> > +	write_lock(&kvm->mmu_lock);
> > +
> > +	/*
> > +	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
> > +	 * case scenario we'll have unused shadow pages lying around until they
> > +	 * are recycled due to age or when the VM is destroyed.
> > +	 */
> > +	if (is_tdp_mmu_enabled(kvm)) {
> > +		struct kvm_gfn_range range = {
> > +		      .slot = slot,
> > +		      .start = slot->base_gfn,
> > +		      .end = slot->base_gfn + slot->npages,
> > +		      .may_block = false,
> > +		};
> > +
> > +		/*
> > +		 * this handles both private gfn and shared gfn.
> > +		 * All private page should be zapped on memslot deletion.
> > +		 */
> > +		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush, true);
> > +	} else {
> > +		flush = slot_handle_level(kvm, slot, __kvm_zap_rmap, PG_LEVEL_4K,
> > +					  KVM_MAX_HUGEPAGE_LEVEL, true);
> > +	}
> > +	if (flush)
> > +		kvm_flush_remote_tlbs(kvm);
> > +
> > +	write_unlock(&kvm->mmu_lock);
> > +}
> > +
> >  static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> >  			struct kvm_memory_slot *slot,
> >  			struct kvm_page_track_notifier_node *node)
> >  {
> > -	kvm_mmu_zap_all_fast(kvm);
> > +	if (kvm_gfn_shared_mask(kvm))
> > +		kvm_mmu_zap_memslot(kvm, slot);
> > +	else
> > +		kvm_mmu_zap_all_fast(kvm);
> >  }
> 
> A comment would be nice here.

Will add a comment.


> >  
> >  int kvm_mmu_init_vm(struct kvm *kvm)
> > @@ -6173,8 +6240,18 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> >  
> >  	if (is_tdp_mmu_enabled(kvm)) {
> >  		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> > +			/*
> > +			 * zap_private = true. Zap both private/shared pages.
> > +			 *
> > +			 * kvm_zap_gfn_range() is used when PAT memory type was
> 
> Is it PAT or MTRR, or both (thus just memory type)?

Both. Will update the comment.

> 
> > +			 * changed.  Later on the next kvm page fault, populate
> > +			 * it with updated spte entry.
> > +			 * Because only WB is supported for private pages, don't
> > +			 * care of private pages.
> > +			 */
> 
> Then why bother zapping private?  If I read correctly, the changelog says "don't
> zap private"?

Right. Will fix.


> >  			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
> > -						      gfn_end, true, flush);
> > +						      gfn_end, true, flush,
> > +						      true);
> >  	}
> >  
> 
> Btw, as you mentioned in the changelog, private memory always has WB memory
> type, thus cannot be virtualized.  Is it better to modify update_mtrr() to just
> return early if the gfn range is purely private?

MTRR support in cpuid is fixed to 1, PAT in cpuid is native.
MTRR and PAT are supported on shared pages.


> IMHO the handling of MTRR/PAT virtualization for TDX guest deserves dedicated
> patch(es) to put them together so it's easier to review.  Now the relevant parts
> spread in multiple independent patches (MSR handling, vt_get_mt_mask(), etc).

Ok, let me check it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
