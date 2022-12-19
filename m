Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEFB65099A
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 10:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiLSJx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 04:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiLSJxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 04:53:24 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B16ADEDD;
        Mon, 19 Dec 2022 01:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671443603; x=1702979603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w9ZPWATSENLE/6MAS2Y4NqDktuiBijuWsBfUlKDMimU=;
  b=kNV2c6mbSXnQndzHPrk0VHpOKOGUOvS6ckUfH5+w0jPO2E21czqLI14C
   T8kjI0Dmrl3QQWJg0bcVbrIVC/GKAPqG9SugJNdLMzxlYd01IXlXPMVKG
   5/+ayu7AoI8tZDR3GI5OuKEtwksNyypRc+cL2uLY8yVdjnAAB9h0bh0dO
   RJJXXFgQYnEi6NkKp9AuyLo3seJo6ZydXhlzfJRxQvZUkFFPCvKavZnHI
   aeKNGYzdPP7gs511CVwE/V3MYs6zazA3EtMVGbskKMHLy7BM0bXXjs/s4
   ApZ3IEH/qkDuznTNmR5wvfXnzL2s+oQbkXPsZ2s96vRpEirLFlf/bBof+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381538847"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381538847"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 01:53:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="652638886"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="652638886"
Received: from youcaiji-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.174.19])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 01:53:14 -0800
Date:   Mon, 19 Dec 2022 17:53:07 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Remove outdated comments in
 nested_vmx_setup_ctls_msrs().
Message-ID: <20221219095307.zy3dufz6hbv3zujj@linux.intel.com>
References: <20221215100558.1202615-1-yu.c.zhang@linux.intel.com>
 <Y5tmFKPj8ZX2GgUY@google.com>
 <20221216014538.3yx5mnmwz2vaa5cy@linux.intel.com>
 <Y5yhs34E169ol+qE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5yhs34E169ol+qE@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 16, 2022 at 04:49:55PM +0000, Sean Christopherson wrote:
> On Fri, Dec 16, 2022, Yu Zhang wrote:
> > > 
> > > Eh, just drop the comment.  Pretty obvious this is for secondary execution controls.
> > Thanks Sean. Well, I agree it is obvious.
> > 
> > This line was kept because there are comments for other groups of
> > control fields(e.g., exit/entry/pin-based/cpu-based controls etc.)
> > in nested_vmx_setup_ctls_msrs(). If we do not keep the one for secondary
> > cpu-based controls, we may just delete other comments as well. But
> > is that really necessary? 
> 
> Adding a patch to delete the various one-line comments is probably unnecessary
> churn.  The comments are kinda sorta helpful, but only because the function is a
> giant and thus a bit hard to follow.  A better solution than comments would be to
> add helpers for each collection ("secondary_ctls" is a bit of a lie because it
> handle VPID, EPT, VMFUNC, etc..., but whatever), e.g.

Good point. The "secondary_ctls" may be inaccurate, but I do not
have a better name in mind either...

> 
> 	nested_vmx_setup_pinbased_ctls(msrs);
> 	nested_vmx_setup_exit_ctls(msrs);
> 	nested_vmx_setup_entry_ctls(msrs);
> 	nested_vmx_setup_cpubased_ctls(msrs);
> 	nested_vmx_setup_secondary_ctls(msrs);
Adding nested_vmx_setup_secondary_ctls() will impact
1> your previous patch to expose ENABLE_USR_WAIT_PAUSE control
https://lore.kernel.org/lkml/20221213062306.667649-2-seanjc@google.com/
2> my previous patch to simplify the setting of secondary proc-
based control:
https://www.spinics.net/lists/kernel/msg4582141.html
How about we combine our previous patches and the new ones together
in next version?

One more questionable comment for nested_vmx_setup_ctls_msrs() is:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b6f4411b613e..58b491f13ed7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6744,8 +6744,6 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
 /*
  * nested_vmx_setup_ctls_msrs() sets up variables containing the values to be
  * returned for the various VMX controls MSRs when nested VMX is enabled.
- * The same values should also be used to verify that vmcs12 control fields are
- * valid during nested entry from L1 to L2.
  * Each of these control msrs has a low and high 32-bit half: A low bit is on
  * if the corresponding bit in the (32-bit) control field *must* be on, and a
  * bit in the high half is on if the corresponding bit in the control field


> 	nested_vmx_setup_misc_data(msrs);
As to the misc data msr, do we really need a seperate function for it?
If yes, then what about the vmx basic msr, the ones for fixed bits in
CR0/4? 

B.R.
Yu
