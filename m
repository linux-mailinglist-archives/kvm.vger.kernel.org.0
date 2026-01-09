Return-Path: <kvm+bounces-67557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00E3BD08F66
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 12:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5621530230EE
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 11:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF6B3590AC;
	Fri,  9 Jan 2026 11:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K+ZAoFN0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A463233290B;
	Fri,  9 Jan 2026 11:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767958476; cv=none; b=HT1oKlv6d8ekKZcQK0cFBPMx61ELXtxE3bKaQeg9PVMtfY+DNOR/hPPR3DeU/Cmn/Vw9Od86/A3nBLQXlVBkhZoS4h8lJKmkQS6zMshm21upO767uBpzC7g8mMBMsln9reFA4m8wQUmlGBBbtk/7nWf6ABNMmnaZpoYRk4YYsB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767958476; c=relaxed/simple;
	bh=eeNJZWTZDDGtLW+bkek8h25fEwPnjJvhE4O+tprnrU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RI4KeDadcHL2OGqqUY99xpnzChN6cT7ztQNetpj34BVg3Kcq3Mw/f49kpqTWdmorca4uxCbNOMuISB6QmGnVlUoXGNP1fugZmzryoqxSV3lukyAcd8zffUQO74/I68mGmu61DCNws+Q2Fnh3qLNbxfoDN3/8C50WGDn8B9T76+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K+ZAoFN0; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767958475; x=1799494475;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eeNJZWTZDDGtLW+bkek8h25fEwPnjJvhE4O+tprnrU8=;
  b=K+ZAoFN0rglCu7WmyMmFfpmTQsBfuy/t++WxzetMa2KnzqVjfH4PzHsl
   8WX0BnkHw892Pp0wPS61DovydXIW+I6oPznmyD7/8TOX1RmP3sbA9zQWC
   dUAqK8ESDeF3LJXDcrkEqrURTVGIF3OLsxLrkJrsH5EyjhC9ktrI45V0R
   QqtxFWOVrSM3+BARbZAMaAagndrpAaZP1JLuyKcrepLgtj3olRtdbd3KG
   2v4i45ypjVzQ5leUcTNPprlmQq7gP6wOycVtxeiq2jCeByQbe/y8/H4SF
   Y68z0m8oAkxt09bIugfRiR5IxrpvtSp/XdHyzbOC07G4/kwgc6eN7NKkk
   Q==;
X-CSE-ConnectionGUID: nLIbFtU5Q7e1D09sE7XFoA==
X-CSE-MsgGUID: VVlbUe8kRUSQLAQQKjXdPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="72975722"
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="72975722"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 03:34:34 -0800
X-CSE-ConnectionGUID: hd9rf2hiRUuXA+nppEScTQ==
X-CSE-MsgGUID: Vvqh4AFdSDWUaEv1XybU7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="207931416"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 03:34:32 -0800
Message-ID: <d3d22390-6557-45a1-9979-4b4580fd629c@intel.com>
Date: Fri, 9 Jan 2026 19:34:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] KVM: VMX: Add a wrapper around ROL16() to get a
 vmcs12 from a field encoding
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20260109041523.1027323-1-seanjc@google.com>
 <20260109041523.1027323-3-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260109041523.1027323-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/2026 12:15 PM, Sean Christopherson wrote:
> Add a wrapper macro, ENC_TO_VMCS12_IDX(), to get a vmcs12 index given a
> field encoding in anticipation of add a macro to get from a vmcs12 index
                                      ^
s/add/adding ?

> back to the field encoding.  And because open coding ROL16(n, 6) everywhere
> is gross.
> 
> No functional change intended.
> 
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/vmx/hyperv_evmcs.c | 2 +-
>   arch/x86/kvm/vmx/hyperv_evmcs.h | 2 +-
>   arch/x86/kvm/vmx/vmcs.h         | 1 +
>   arch/x86/kvm/vmx/vmcs12.c       | 4 ++--
>   arch/x86/kvm/vmx/vmcs12.h       | 2 +-
>   5 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.c b/arch/x86/kvm/vmx/hyperv_evmcs.c
> index 904bfcd1519b..cc728c9a3de5 100644
> --- a/arch/x86/kvm/vmx/hyperv_evmcs.c
> +++ b/arch/x86/kvm/vmx/hyperv_evmcs.c
> @@ -7,7 +7,7 @@
>   #include "hyperv_evmcs.h"
>   
>   #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
> -#define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] = \
> +#define EVMCS1_FIELD(number, name, clean_field)[ENC_TO_VMCS12_IDX(number)] = \
>   		{EVMCS1_OFFSET(name), clean_field}
>   
>   const struct evmcs_field vmcs_field_to_evmcs_1[] = {
> diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.h b/arch/x86/kvm/vmx/hyperv_evmcs.h
> index 6536290f4274..fc7c4e7bd1bf 100644
> --- a/arch/x86/kvm/vmx/hyperv_evmcs.h
> +++ b/arch/x86/kvm/vmx/hyperv_evmcs.h
> @@ -130,7 +130,7 @@ static __always_inline int evmcs_field_offset(unsigned long field,
>   					      u16 *clean_field)
>   {
>   	const struct evmcs_field *evmcs_field;
> -	unsigned int index = ROL16(field, 6);
> +	unsigned int index = ENC_TO_VMCS12_IDX(field);
>   
>   	if (unlikely(index >= nr_evmcs_1_fields))
>   		return -ENOENT;
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index b25625314658..9aa204c87661 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -12,6 +12,7 @@
>   #include "capabilities.h"
>   
>   #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
> +#define ENC_TO_VMCS12_IDX(enc) ROL16(enc, 6)
>   
>   struct vmcs_hdr {
>   	u32 revision_id:31;
> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> index 4233b5ca9461..c2ac9e1a50b3 100644
> --- a/arch/x86/kvm/vmx/vmcs12.c
> +++ b/arch/x86/kvm/vmx/vmcs12.c
> @@ -4,10 +4,10 @@
>   #include "vmcs12.h"
>   
>   #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
> -#define FIELD(number, name)	[ROL16(number, 6)] = VMCS12_OFFSET(name)
> +#define FIELD(number, name)	[ENC_TO_VMCS12_IDX(number)] = VMCS12_OFFSET(name)
>   #define FIELD64(number, name)						\
>   	FIELD(number, name),						\
> -	[ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
> +	[ENC_TO_VMCS12_IDX(number##_HIGH)] = VMCS12_OFFSET(name) + sizeof(u32)
>   
>   const unsigned short vmcs12_field_offsets[] = {
>   	FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> index 4ad6b16525b9..7a5fdd9b27ba 100644
> --- a/arch/x86/kvm/vmx/vmcs12.h
> +++ b/arch/x86/kvm/vmx/vmcs12.h
> @@ -385,7 +385,7 @@ static inline short get_vmcs12_field_offset(unsigned long field)
>   	if (field >> 15)
>   		return -ENOENT;
>   
> -	index = ROL16(field, 6);
> +	index = ENC_TO_VMCS12_IDX(field);
>   	if (index >= nr_vmcs12_fields)
>   		return -ENOENT;
>   


