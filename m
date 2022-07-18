Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5F8577CEF
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 09:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbiGRH6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 03:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbiGRH6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 03:58:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317AC183BD;
        Mon, 18 Jul 2022 00:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658131101; x=1689667101;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+BDZxa4+mDfmbiUpV7OYkV9hvGump0+Dz2UalQqK8Z8=;
  b=VAqzBZV1LPuTERT3YRxUC1+VXNuwoboZXhJ7nVUj/aZBF/dxmBo4ltPh
   CUZXE/wq99fr8bOJeDUE4lANRP2BjW3I8KoWtleyc5+3NyUSwqQGTEObe
   I/bWvXbYeaCJIvAVZHQgTSY4IGdI7uiUMNITxnwavVMco+RF8eEvm/ej0
   Xe7kgkJhaiTOuNtzX5iK7nS98MfK0EBLxlLzu1j2yZ5p0nfuWwxN6TgWg
   fVAefRc3gPpECsupmLY8nqS71Hi3pN+z1803M666zqeCzP8A7cWDRmRA2
   4M2jmBPXWYCzgtGoiyHooelM1zkKRhTUD/8VzeX7dN5K6i0uu5PDEpc+3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="286179888"
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="286179888"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 00:58:20 -0700
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="655169692"
Received: from yangxuan-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.171.3])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 00:58:17 -0700
Date:   Mon, 18 Jul 2022 15:58:15 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: X86: Fix the comments in prepare_vmcs02_rare()
Message-ID: <20220718075815.enldntoehbiphhpv@linux.intel.com>
References: <20220715114211.53175-1-yu.c.zhang@linux.intel.com>
 <20220715114211.53175-3-yu.c.zhang@linux.intel.com>
 <YtGOL4jIMQwoW5vb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtGOL4jIMQwoW5vb@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022 at 03:56:31PM +0000, Sean Christopherson wrote:
> On Fri, Jul 15, 2022, Yu Zhang wrote:
> > Although EB.PF in vmcs02 is still set by simply "or"ing the EB of
> > vmcs01 and vmcs12, the explanation is obsolete. "enable_ept" being
> > set is not the only reason for L0 to clear its EB.PF.
> > 
> > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 778f82015f03..634a7d218048 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2451,10 +2451,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> >  	 * is not easy (if at all possible?) to merge L0 and L1's desires, we
> >  	 * simply ask to exit on each and every L2 page fault. This is done by
> >  	 * setting MASK=MATCH=0 and (see below) EB.PF=1.
> > -	 * Note that below we don't need special code to set EB.PF beyond the
> > -	 * "or"ing of the EB of vmcs01 and vmcs12, because when enable_ept,
> > -	 * vmcs01's EB.PF is 0 so the "or" will take vmcs12's value, and when
> > -	 * !enable_ept, EB.PF is 1, so the "or" will always be 1.
> > +	 * Note that EB.PF is set by "or"ing of the EB of vmcs01 and vmcs12,
> > +	 * because when L0 has no desire to intercept #PF, vmcs01's EB.PF is 0
> > +	 * so the "or" will take vmcs12's value, otherwise EB.PF is 1, so the
> > +	 * "or" will always be 1.
> 
> Oof!  I was going to respond with a variety of nits (about the existing comment),
> and even suggest that we address the TODO just out of sight, but looking at all
> of this made me realize there's a bug here!  vmx_update_exception_bitmap() doesn't
> update MASK and MATCH!
> 
> Hitting the bug is extremely unlikely, as it would require changing the guest's
> MAXPHYADDR via KVM_SET_CPUID2 _after_ KVM_SET_NESTED_STATE, but before KVM_RUN
> (because KVM now disallows changin CPUID after KVM_RUN).
> 
> During KVM_SET_CPUID2, KVM will invoke vmx_update_exception_bitmap() to refresh
> the exception bitmap to handle the ept=1 && allow_smaller_maxphyaddr=1 scenario.
> But when L2 is active, vmx_update_exception_bitmap() assumes vmcs02 already has
> the correct MASK+MATCH because of the "clear both if KVM and L1 both want #PF"
> behavior.  But if KVM's desire to intercept #PF changes from 0=>1, then KVM will
> run L2 with the MASK+MATCH from vmcs12 because vmx_need_pf_intercept() would have
> returned false at the time of prepare_vmcs02_rare().

And then the #PF could be missed in L0 because previously both L1 and L0 has no
desire to intercept it, meanwhile KVM fails to update this after migration(I guess
the only scenario for this to happen is migration?). Is this understanding correct? 

> 
> Fixing the bug is fairly straightforward, and presents a good opportunity to
> clean up the code (and this comment) and address the TODO.
> 
> Unless someone objects to my suggestion for patch 01, can you send a new version
> of patch 01?  I'll send a separate series to fix this theoretical bug, avoid
> writing MASK+MATCH when vmcs0x.EXCEPTION_BITMAP.PF+0, and to address the TODO.

Sure, I will send another version of patch 01.

> 
> E.g. I believe this is what we want to end up with:
> 
> 	if (vmcs12)
> 		eb |= vmcs12->exception_bitmap;
> 
> 	/*
> 	 * #PF is conditionally intercepted based on the #PF error code (PFEC)
> 	 * combined with the exception bitmap.  #PF is intercept if:
> 	 *
> 	 *    EXCEPTION_BITMAP.PF=1 && ((PFEC & MASK) == MATCH).
> 	 *
> 	 * If any #PF is being intercepted, update MASK+MATCH, otherwise leave
> 	 * them alone they do not affect interception (EXCEPTION_BITMAP.PF=0).
> 	 */
> 	if (eb & (1u << PF_VECTOR)) {
> 		/*
> 		 * If EPT is enabled, #PF is only intercepted if MAXPHYADDR is
> 		 * smaller on the guest than on the host.  In that case, KVM
> 		 * only needs to intercept present, non-reserved #PF.  If EPT
> 		 * is disabled, i.e. KVM is using shadow paging, KVM needs to
> 		 * intercept all #PF.  Note, whether or not KVM wants to
> 		 * intercept _any_ #PF is handled below.
> 		 */
> 		if (enable_ept) {
> 			pfec_mask = PFERR_PRESENT_MASK | PFERR_RSVD_MASK;
> 			pfec_match = PFERR_PRESENT_MASK;
> 		} else {
> 			pfec_mask = 0;
> 			pfec_match = 0;
> 		}
> 
> 		if (!(vmcs12->exception_bitmap & (1u << PF_VECTOR))) {
> 			/* L1 doesn't want to intercept #PF, use KVM's MASK+MATCH. */
> 		} else if (!kvm_needs_pf_intercept) {
> 			/* KVM doesn't want to intercept #PF, use L1's MASK+MATCH. */
> 			pfec_mask = vmcs12->page_fault_error_code_mask;
> 			pfec_match = vmcs12->page_fault_error_code_match;
> 		} else if (pfec_mask != vmcs12->page_fault_error_code_mask ||
> 			   pfec_match != vmcs12->page_fault_error_code_mask) {
> 			/*
> 			 * KVM and L1 want to intercept #PF with different MASK
> 			 * and/or MATCH.  For simplicity, intercept all #PF by
> 			 * clearing MASK+MATCH.  Merging KVM's and L1's desires
> 			 * is quite complex, while the odds of meaningfully
> 			 * reducing what #PFs are intercept are low.
> 			 */
> 			pfec_mask = 0;
> 			pfec_match = 0;
> 		} else {
> 			/* KVM and L1 have identical MASK+MATCH. */
> 		}
> 		vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, pfec_mask);
> 		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, pfec_match);
> 	}

And we do not need to update the PFEC_MASK & PFEC_MATCH in prepare_vmcs02_rare()
anymore, right? Thanks!

B.R.
Yu
