Return-Path: <kvm+bounces-15001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C4288A8C1A
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 21:28:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E3D51C20FFC
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 19:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B2628DD5;
	Wed, 17 Apr 2024 19:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bpyFimpT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13805171A1;
	Wed, 17 Apr 2024 19:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713382123; cv=none; b=mFXfdvzhlG+eyD3kjAVzYqcH66S5o67ZdtSSB6MzGf58XhxNMqyW/vORLlA+UzBLeCxCX5eTrISm9zRDBCDqgIOovCO2iCHiEpITA110/ifSlMBMjw0EJCPsBJ8d0ORTyUcXdLXAD2GV1V3Ok8NP82inU7e2zAxuVQc3gLoNDAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713382123; c=relaxed/simple;
	bh=EIlDoNIPXH+XILg6sUfM2OP7zrOgxF9nJjznQmRNeLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGUfmABIZuDzqZfad8MLTnY2Dd5fWYXTDVPEL+XWhDEMUe8T408N/sVriSP9p0AOkv46zCLF69YmWSFjGX+ku4VcT/d0GmPXpVkGJkcYUNPWfc3arGxQJCB0uJICegi2drA/J2DoQZjUpNdAN5tef/OlINUB4OBIlXYXr9zM7Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bpyFimpT; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713382122; x=1744918122;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EIlDoNIPXH+XILg6sUfM2OP7zrOgxF9nJjznQmRNeLE=;
  b=bpyFimpT7EJ7fifmPbb+Z8xifEh/VKWull5RRmJN72Xa9TTSsoxE96T+
   2PwkYpITBkyGPYLX2R0X2UhDt0FOshP4ysXL8moSidAhs9muJeBqCGMHJ
   LKtG63gz8h2wID3wJKJp4QtNnwV8DDRW6akdUBzpQG+rK2ETLhQqwc6EM
   S98Gq6CmHs+RIFdgs6M5smPEs4veu4fQmNkfbOrk/9J3zNSyC5PKiCPEM
   YdcKR+MydzigMTeA5laXKyoDh5YA0P5xHyTymmvo4K68PJnuHEJfvFflg
   IitZ18Yz0FjIP1xNNmRsOSpEB7zU5ydmiP1m9ZVSK0hDQ/IgvsSCiHNX+
   Q==;
X-CSE-ConnectionGUID: nf7GmXoiRRSPCfQM0ICJsA==
X-CSE-MsgGUID: oCdNKcj9St2m+FZGshSePA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9118392"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="9118392"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 12:28:38 -0700
X-CSE-ConnectionGUID: Frk9jLpxQyubAijxw+aNbw==
X-CSE-MsgGUID: vCczW+iySzeVk2qn/vJHGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="53932182"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 12:28:38 -0700
Date: Wed, 17 Apr 2024 12:28:37 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	isaku.yamahata@intel.com, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 6/7] KVM: x86: Implement kvm_arch_vcpu_map_memory()
Message-ID: <20240417192837.GI3039520@ls.amr.corp.intel.com>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
 <20240417153450.3608097-7-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240417153450.3608097-7-pbonzini@redhat.com>

On Wed, Apr 17, 2024 at 11:34:49AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Wire KVM_MAP_MEMORY ioctl to kvm_mmu_map_tdp_page() to populate guest
> memory.  When KVM_CREATE_VCPU creates vCPU, it initializes the x86
> KVM MMU part by kvm_mmu_create() and kvm_init_mmu().  vCPU is ready to
> invoke the KVM page fault handler.


As a record for the past discussion and to address Rick comment at
https://lore.kernel.org/all/75b213fd73fcb5872703f89a9c6bb67ea91e3bd7.camel@intel.com/

  The current implementation supports TDP only because the population with GVA
  is moot based on the thread [1].  If necessary, this restriction can be
  relaxed in future.
  
  [1] https://lore.kernel.org/all/116179545fafbf39ed01e1f0f5ac76e0467fc09a.camel@intel.com/


> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-ID: <7138a3bc00ea8d3cbe0e59df15f8c22027005b59.1712785629.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/Kconfig |  1 +
>  arch/x86/kvm/x86.c   | 43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 7632fe6e4db9..e58360d368ec 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -44,6 +44,7 @@ config KVM
>  	select KVM_VFIO
>  	select HAVE_KVM_PM_NOTIFIER if PM
>  	select KVM_GENERIC_HARDWARE_ENABLING
> +	select KVM_GENERIC_MAP_MEMORY
>  	help
>  	  Support hosting fully virtualized guest machines using hardware
>  	  virtualization extensions.  You will need a fairly recent
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83b8260443a3..f84c75c2a47f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4715,6 +4715,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_MEMORY_FAULT_INFO:
>  		r = 1;
>  		break;
> +	case KVM_CAP_MAP_MEMORY:
> +		r = tdp_enabled;
> +		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
>  		r = KVM_EXIT_HYPERCALL_VALID_MASK;
>  		break;
> @@ -5867,6 +5870,46 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
> +			     struct kvm_map_memory *mapping)
> +{
> +	u64 mapped, end, error_code = 0;
> +	u8 level = PG_LEVEL_4K;
> +	int r;
> +
> +	/*
> +	 * Shadow paging uses GVA for kvm page fault.  The first implementation
> +	 * supports GPA only to avoid confusion.
> +	 */
> +	if (!tdp_enabled)
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * reload is efficient when called repeatedly, so we can do it on
> +	 * every iteration.
> +	 */
> +	kvm_mmu_reload(vcpu);
> +
> +	if (kvm_arch_has_private_mem(vcpu->kvm) &&
> +	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(mapping->base_address)))
> +		error_code |= PFERR_PRIVATE_ACCESS;
> +
> +	r = kvm_tdp_map_page(vcpu, mapping->base_address, error_code, &level);
> +	if (r)
> +		return r;
> +
> +	/*
> +	 * level can be more than the alignment of mapping->base_address if
> +	 * the mapping can use a huge page.
> +	 */
> +	end = (mapping->base_address & KVM_HPAGE_MASK(level)) +
> +		KVM_HPAGE_SIZE(level);

end = ALIGN(mapping->base_address, KVM_HPAGE_SIZE(level));

ALIGN() simplifies this as Chao pointed out.
https://lore.kernel.org/all/Zh94V8ochIXEkO17@chao-email/


> +	mapped = min(mapping->size, end - mapping->base_address);
> +	mapping->size -= mapped;
> +	mapping->base_address += mapped;
> +	return r;
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
> -- 
> 2.43.0
> 
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

