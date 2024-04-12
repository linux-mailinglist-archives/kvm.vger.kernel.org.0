Return-Path: <kvm+bounces-14574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A9D8A36F0
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACAF6B2193A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF54D1514C7;
	Fri, 12 Apr 2024 20:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZA+bJo15"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4967214A091;
	Fri, 12 Apr 2024 20:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712953143; cv=none; b=PTRelW0I/4kjVhLlJA1j4rmLdhzpEv47arah/FtPOsbqNqPxgQCDr6/u7O88DURXi3pko9DIOEt9gxmQVkEzCWFlSqbubWIpibyh020jVdcezetGBPkNchi5oJ8sWKAY/CaaIDmjrHplCOIyBWzNFCIFUVe2yf9cll73BDHF2/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712953143; c=relaxed/simple;
	bh=IrUgnuln+72xJ472g+onjqmOEecUVLRY/dkhYblU0KU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FlYwaSi5NBon52iG/QA+jqpV1WERgo2kTCZmUwWvXE80Pje7kdxKsePTQQieeNl8Y4y26oedHy77n1plpuwh5SnWUq/HcV1zCNgyy+rRZoNK21cJCw7lV4yx+1YzE7nfh3/oT09RzCmgD02C2QiYvG8nQcftWDSTWoHc3PewSwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZA+bJo15; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712953142; x=1744489142;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IrUgnuln+72xJ472g+onjqmOEecUVLRY/dkhYblU0KU=;
  b=ZA+bJo15e0bVs9zRzrK/fVRSot5nrtPQqg/WU29weJ1/ZYh+J/XQEgvv
   UiQ2bfDL5PKYSwyjSqODOSnFj0fE6/ghJyufRWeRbQ50YLbQyNhaCCcUe
   RYilMJ6weZn/VhEGKb7UjllWniZBdMDO1VJHnSLraWeIYPFssGJREnvNf
   38+KmvMzVcdSldGRWV6V2SY+ttgu9Uc0uVRDY3YbBUVYpCnJSEYC1oV1C
   EW/qmfYKQI48vjYWVGy4qJfT2d33Nz6D4tnESqIoYL7TfOSz48ber2nqJ
   GZPHsC39FmOYWhD5xCH5MNWBeymuuZ4x582gMl+bw1wgz9sxTleBFuaCN
   g==;
X-CSE-ConnectionGUID: dQ/Qv+ziS8Csx2n3a829nA==
X-CSE-MsgGUID: WRGiyciHTRS+r9TXYo1xaw==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="18983202"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="18983202"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:19:01 -0700
X-CSE-ConnectionGUID: C3oOFipARtGuROw7YXTjlw==
X-CSE-MsgGUID: slfodUq8T6mwNojyHtN1IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21399438"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:19:00 -0700
Date: Fri, 12 Apr 2024 13:19:00 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 080/130] KVM: TDX: restore host xsave state when exit
 from the guest TD
Message-ID: <20240412201900.GK3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <2894ed10014279f4b8caab582e3b7e7061b5dad3.1708933498.git.isaku.yamahata@intel.com>
 <57c1a18b-b8b0-4368-99b3-b6ad4ad0e614@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <57c1a18b-b8b0-4368-99b3-b6ad4ad0e614@linux.intel.com>

On Sun, Apr 07, 2024 at 11:47:00AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > On exiting from the guest TD, xsave state is clobbered.  Restore xsave
> > state on TD exit.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> > v19:
> > - Add EXPORT_SYMBOL_GPL(host_xcr0)
> > 
> > v15 -> v16:
> > - Added CET flag mask
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
> >   arch/x86/kvm/x86.c     |  1 +
> >   2 files changed, 20 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 9616b1aab6ce..199226c6cf55 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -2,6 +2,7 @@
> >   #include <linux/cpu.h>
> >   #include <linux/mmu_context.h>
> > +#include <asm/fpu/xcr.h>
> >   #include <asm/tdx.h>
> >   #include "capabilities.h"
> > @@ -534,6 +535,23 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >   	 */
> >   }
> > +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +
> > +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
> > +	    host_xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
> > +		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
> > +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
> > +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
> The comment needs to be updated to reflect the case for CET.
> 
> > +	    host_xss != (kvm_tdx->xfam &
> > +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET)))
> 
> For TDX_TD_XFAM_CET, maybe no need to make it TDX specific?
> 
> BTW, the definitions for XFEATURE_MASK_CET_USER/XFEATURE_MASK_CET_KERNEL
> have been merged.
> https://lore.kernel.org/all/20230613001108.3040476-25-rick.p.edgecombe%40intel.com
> You can resolve the TODO in https://lore.kernel.org/kvm/5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com/

Yes, will update those constants to use the one in arch/x86/include/asm/fpu/types.h
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

