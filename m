Return-Path: <kvm+bounces-14060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9311189E7BC
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 03:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 155D3B21E1F
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DFC610E3;
	Wed, 10 Apr 2024 01:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E8/hI7n1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CFB64A
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712712227; cv=none; b=iyQSjgp3FckVdsO9/ObG80af8q03zGi0e88BR0EDMnkiV5Bt4oj5YqpaWb0M2aTXeTDvnZN3DE9CLOeUSpfAl/l/WQRm387QqOln0agOkDGs1DbCA0yigAwq4Tf341u2V9Ol09938uW3MdPzE49U9ghU2Rn9yexHWGuA44VojIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712712227; c=relaxed/simple;
	bh=FuunY/8wfVNK0u3bG4BKNgnqtTilaD14zHndSDRbaxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OVWLLw1C9muUUHVm3OgiAO5H0moVEHJ2GtwQv2kyzbu8PDUaSAnMycY/wsLfyForF8EVCWFl0aZE12fM55BfjX0tss1/8FsuC1FmkwWv+LNl2RlE7Uw7JCzluGkVGHUovkD4LaOmV11eFq5zTxyRIyIvQgxeSnQ0RAxaPmcULJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E8/hI7n1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712712226; x=1744248226;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FuunY/8wfVNK0u3bG4BKNgnqtTilaD14zHndSDRbaxQ=;
  b=E8/hI7n1Rah5eOKKeN1TizdQz03YMXb+AC2B+5l1DTfG46xhpzq5ePFy
   /yvD/CITSr10se3xLRMNaELFWvKzs/PuETMs2JEIoV1+C0ZA78TGaX66/
   +jfT+K+M1naAduMRje5tdkeFPoAQ3EMqTp6dYI1EV9+Z6K5lNtCjn8UVC
   beOpV49qxv7H8EA/V4BJ3jZGUWFRVZYTkFWjufmrYxTrgJiqNXSauI1h6
   6FqJwXxYniOljeKCX9+U2Pn2Z1V2CtJ4rK+OomjbpvQBg5RMnNIWhEz1g
   HgOYB8CotY0LOBUjIFE1AcGtaIQaLC4DoB6pwy9YdyfK7zdyN7kGZuL4v
   g==;
X-CSE-ConnectionGUID: fYaP3L1dS8+X1AUbm4fl+g==
X-CSE-MsgGUID: g0E3WaurSOyNNOCMgBXHyw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="19442076"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="19442076"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 18:23:45 -0700
X-CSE-ConnectionGUID: 3SkqmD0ZTpGCRUn5SLlw0g==
X-CSE-MsgGUID: Pvfx93w5Qr+mcBi2wt2Kgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="20499477"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 18:23:43 -0700
Date: Wed, 10 Apr 2024 09:20:52 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
	xiaoyao.li@intel.com
Subject: Re: [PATCH] KVM: x86: Fix the condition of #PF interception caused
 by MKTME
Message-ID: <ZhXpdAdGsghYduDt@linux.bj.intel.com>
References: <20240319031111.495006-1-tao1.su@linux.intel.com>
 <ZhWRaMtsMXfHTFTH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZhWRaMtsMXfHTFTH@google.com>

On Tue, Apr 09, 2024 at 12:05:12PM -0700, Sean Christopherson wrote:
> On Tue, Mar 19, 2024, Tao Su wrote:
> > Intel MKTME repurposes several high bits of physical address as 'keyID',
> > so boot_cpu_data.x86_phys_bits doesn't hold physical address bits reported
> > by CPUID anymore.
> > 
> > If guest.MAXPHYADDR < host.MAXPHYADDR, the bit field of ‘keyID’ belongs
> > to reserved bits in guest’s view, so intercepting #PF to fix error code
> > is necessary, just replace boot_cpu_data.x86_phys_bits with
> > kvm_get_shadow_phys_bits() to fix.
> > 
> > Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 65786dbe7d60..79b1757df74a 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -15,6 +15,7 @@
> >  #include "vmx_ops.h"
> >  #include "../cpuid.h"
> >  #include "run_flags.h"
> > +#include "../mmu.h"
> >  
> >  #define MSR_TYPE_R	1
> >  #define MSR_TYPE_W	2
> > @@ -719,7 +720,8 @@ static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
> >  	if (!enable_ept)
> >  		return true;
> >  
> > -	return allow_smaller_maxphyaddr && cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
> > +	return allow_smaller_maxphyaddr &&
> > +		cpuid_maxphyaddr(vcpu) < kvm_get_shadow_phys_bits();
> 
> For posterity, because I had a brief moment where I thought we done messed up:
> 
> No change is needed in the reporting of MAXPHYADDR in KVM_GET_SUPPORTED_CPUID,
> as reporting boot_cpu_data.x86_phys_bits as MAXPHYADDR when TDP is disabled is ok
> because KVM always intercepts #PF when TDP is disabled, and KVM already reports
> the full/raw MAXPHYADDR when TDP is enabled.

You are right, but userspace can fully control guest.MAXPHYADDR when TDP is enabled.
Please see the unit-test[*], I think this issue could show up earlier if phys-bits
is set larger, such as 46-bits.

[*] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/master/x86/unittests.cfg?ref_type=heads#L156

