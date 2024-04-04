Return-Path: <kvm+bounces-13512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37FE6897D55
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 03:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35E681C244B7
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 01:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F668C12C;
	Thu,  4 Apr 2024 01:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h+v2n6Ry"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC1F3C30;
	Thu,  4 Apr 2024 01:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712193348; cv=none; b=mSR+7SHSxU2rt9suStrQQy0XZ/M/cJa0v59wICqjJ5zmjlBqu+JACnyzzNFKXclZV8FKt2OaREJlYzNxHW1YFbi24D4EfJmmsd2MbjOteIoCI/mrU6dUgOBiLm50B2QnnUdmlyuz0PooogopoPLwME5yyQsoBMcTcRFwY+YhTcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712193348; c=relaxed/simple;
	bh=iV+fYLEUuD3qMKnGQDEMm+oR9vl6EeMmdnznRKNEQ+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NvtCHKq3qv6Z9E+6IkzvmdjXPEegNJ+aJNCjaQxW70+46Fka077641dClh3MOcLfSp8Yay58pJFExo86RKsq5OEJPjofhpdXbqg/WAo1YgpAy2iXj6dSVzK4yKypTaaJ+69cb6XD6bAGfVyucgHYVocsgJoSxguZNOjH9KLc38M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h+v2n6Ry; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712193347; x=1743729347;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iV+fYLEUuD3qMKnGQDEMm+oR9vl6EeMmdnznRKNEQ+I=;
  b=h+v2n6Rydh4/WzD9edHnspAYv5u1//8gvmn+PdDCqbUkhNNo4GL0IVAR
   lHu2XeEPjnSl61kaGBZRMtyMWZSifl3SSWs2IoLwJzBSSuFrTB0Hz1Wbh
   Axb9NQg5WyiZlYgAO5MCPHrE0lnijg8xaTLx6PlBSkBGUWn5xUfGFbVZA
   Ihh1aIlntK2rjh6NXNT2RarERcArSRDG1kaVoWvdnpXgLI6uvg740C07o
   r9H45jfKmppfCL/TrjEK99TM0q/eFI846dxCKkF8uVIJb+RhSx8hrU+7H
   7Gn75KhNtuc7U1unMGPZwMj186cXtxmYFIWg2mQspUZW0N1eFVlwhol9T
   w==;
X-CSE-ConnectionGUID: iSV7s0yfSUKRfAWZ394bUg==
X-CSE-MsgGUID: JXA9hbjLSjS/74tqn8ao2w==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7628285"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="7628285"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 18:15:47 -0700
X-CSE-ConnectionGUID: YwN6getFSA+MsprrZH5IDw==
X-CSE-MsgGUID: UyC81w+aRRCQF2ecc+pMdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="23317387"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 18:15:46 -0700
Date: Wed, 3 Apr 2024 18:15:45 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 104/130] KVM: TDX: Add a place holder for handler of
 TDX hypercalls (TDG.VP.VMCALL)
Message-ID: <20240404011545.GO2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1c66bfde36f08eacbe2f5c50f88adf80e3d87ea7.1708933498.git.isaku.yamahata@intel.com>
 <ZgqFhx7JjhzKXjqb@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgqFhx7JjhzKXjqb@chao-email>

On Mon, Apr 01, 2024 at 05:59:35PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> > static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> > {
> > 	return tdx->td_vcpu_created;
> >@@ -897,6 +932,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> > 
> > 	tdx_complete_interrupts(vcpu);
> > 
> >+	if (tdx->exit_reason.basic == EXIT_REASON_TDCALL)
> >+		tdx->tdvmcall.rcx = vcpu->arch.regs[VCPU_REGS_RCX];
> 
> kvm_rcx_read()?
> 
> 		
> >+	else
> >+		tdx->tdvmcall.rcx = 0;
> 
> RCX on TDVMCALL exit is supposed to be consumed by TDX module. I don't get why
> caching it is necessary. Can tdx->tdvmcall be simply dropped?

Now it's not used. Will drop tdvmcall.

It was originally used to remember a original register mask of TDVMCALL, and
tdx_complete_vp_vmcall() used it as a valid value to copy back the output
values.  The current tdx_complete_vp_vmcall() uses kvm_rcx_read() because even
if the user space changes rcx, it doesn't harm to KVM.  KVM does what the user
space tells.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

