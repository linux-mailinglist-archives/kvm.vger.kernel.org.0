Return-Path: <kvm+bounces-13263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 340BA89385E
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 08:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91F28281B80
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 06:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FADF946C;
	Mon,  1 Apr 2024 06:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PO+6ArL9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B30BE4B;
	Mon,  1 Apr 2024 06:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711952866; cv=none; b=Gyxvgs+AdptxaO3zM98Rbuh0tBInvlY/4R+RRZm+CpX2ejPtmKCoaLJwZyOPOKSH/f/jngeQX2XhYuMFf/DDpSEZpgtkBBHlh9/ZVyuQlpb1A1z6/0oae5OBS6WXF26mwz+brIAUwutOyPW53bIR3Rpb43xofBnyjpJdoHFy/iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711952866; c=relaxed/simple;
	bh=FRDWwGwoWrT2hdGyeXRnP8I/oB4ub4bNpO9ycKIRPhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UpcyuPPYnBIFTkrRXTMpV6gbcEq3Gvrg8TBpVUa/uX64bfnJDLH/WNkbLgnv/pXGmXWm1qdkYju5szaCw/fKzgC0nXzYiGTl78Zzt4xeIyYaoJa1nrIeK9lQccO78Fg5En8yDLq1g3xpcXoQ4QiPqK1Ovn1V9W3a3Cwqn5zZk14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PO+6ArL9; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711952865; x=1743488865;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FRDWwGwoWrT2hdGyeXRnP8I/oB4ub4bNpO9ycKIRPhk=;
  b=PO+6ArL9RzVcZUfJBdIhXMhRltt3+HpvaB7ScXWJk+gsctqNjrYCmIPg
   +fmn8saGt3a8ffoiMW9AyJSKTT2JMpGI1NslhRSyxwqpbxCYK04Ub/F/I
   35FlnffGWJZPpzvAmy/S6RUNB6vZXSetxthc29Ar8AmiWjHLCckQmiAGD
   oyZ10xM6qLGQRemkq5kOKzSRIfCB+Udmc/ivnpeLr7I+V19pYqc5WP0Pc
   BL8A1KU7y0gYl9m7M1aODXg5zlRkmu8hzIeDEmOeVeBKClc+jjaR8HlxR
   FrkOZjQAxES3vGnk7hn1KLN1T1+S4S6Fyf6FlQwapIQ0UPk3s5pZZCxMF
   A==;
X-CSE-ConnectionGUID: 9uG+lN7bRLODWahnWE8a0g==
X-CSE-MsgGUID: inVB4OkiSiWQ+zEmYwuLcA==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="17691543"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="17691543"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 23:27:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="17650268"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 23:27:31 -0700
Message-ID: <005c16a4-b88c-4389-8834-a4fc98a8ba02@intel.com>
Date: Mon, 1 Apr 2024 14:27:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/9] KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a
 single 64-bit value
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xin Li <xin3.li@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-6-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240309012725.1409949-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/2024 9:27 AM, Sean Christopherson wrote:
> Track the "basic" capabilities VMX MSR as a single u64 in vmcs_config
> instead of splitting it across three fields, that obviously don't combine
> into a single 64-bit value, so that KVM can use the macros that define MSR
> bits using their absolute position.  Replace all open coded shifts and
> masks, many of which are relative to the "high" half, with the appropriate
> macro.
> 
> Opportunistically use VMX_BASIC_32BIT_PHYS_ADDR_ONLY instead of an open
> coded equivalent, and clean up the related comment to not reference a
> specific SDM section (to the surprise of no one, the comment is stale).
> 
> No functional change intended (though obviously the code generation will
> be quite different).
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog]

The patch author doesn't match with the signed-off

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/vmx.h      |  5 +++++
>   arch/x86/kvm/vmx/capabilities.h |  6 ++----
>   arch/x86/kvm/vmx/vmx.c          | 28 ++++++++++++++--------------
>   3 files changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index c3a97dca4a33..ce6d166fc3c5 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -150,6 +150,11 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
>   	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
>   }
>   
> +static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
> +{
> +	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;

#define VMX_BASIC_MEM_TYPE_SHIFT		50

We have the shift defined in previous patch, we need to use it I think,
Any maybe, we can define the MASK as well.

Otherwise, this cleanup is good.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

