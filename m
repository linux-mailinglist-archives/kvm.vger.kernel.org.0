Return-Path: <kvm+bounces-13261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44675893845
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 08:15:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8C4DB20F3F
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 06:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDB4BA49;
	Mon,  1 Apr 2024 06:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZDnBQYsY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE88F11187;
	Mon,  1 Apr 2024 06:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711952044; cv=none; b=mCntmXvubO42A0vZ+fGnKuJsyl3f++BPk4UFZ5+cBNZL8RvNL7poGFqqkHpYiVDrCu2KOFtsOeew9zSjGdZwBYlFF+oBU8ZdzSTMncjldcqw6MSFaQ7HIWzGD8lr2LWuUg3VOS3YQhN+6KXJbz3OkkLHKCDt24iGEfXzoh9ayQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711952044; c=relaxed/simple;
	bh=1Z2fCk/GC0K5wH/Xh6ji0u0GfFpTzGJ75fuu/9CSOAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UR2GHmmW7G6NfTW2+IWyanfMGMgxkb0C2AILb2RYbli5Sz4c/iubTvpK4cTkz8QkD18A7X7l526a20L+6zi20ZQcQ+4M+5BjAezML5yfSzVKYHp739jvkR2M/oM3p+3fVP5cqQrn47b8zEPn3LG05j0WIPkdEmsvML9rkf9cOCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZDnBQYsY; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711952042; x=1743488042;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1Z2fCk/GC0K5wH/Xh6ji0u0GfFpTzGJ75fuu/9CSOAg=;
  b=ZDnBQYsYGT+OmcuUsfMOUpjg+bg4lwrXcnY8kt3NyhgvUlA/h0RvowJX
   3V8OuzYNkQrRMsKppmFC3oJqHz3M11fSdRoRRaRlYI7Vr4DsrSp3WEijT
   CCT1dNNu82YWiJVhcTkMOU3XJ+lpQIBTKyOybgimq2TVxFWwPOa0b4a2+
   yG/xZ06E1GI2Aznht1PT3d4gpn7Ylqo5pp0aE75gBcaZiWEoeCElE1TS0
   o84W1fzSd1a5d2puxEbLTP1GH2Gb8+Lfs09hg06ez+B1xVTqisqR8NOoo
   mkOUnG74E8eczH+E66tNnXv1CCTgXRb/j4f2skgfaKYNwbkDWyP0WmJh7
   g==;
X-CSE-ConnectionGUID: ngPhZfQqSLWMOTUtAmDRWA==
X-CSE-MsgGUID: waYteJwPTwmcZ+oTxRD9SA==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="7660147"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="7660147"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 23:14:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="48804236"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 23:13:57 -0700
Message-ID: <05484613-0d02-4ab6-a514-867a0d4459bf@intel.com>
Date: Mon, 1 Apr 2024 14:13:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/9] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to
 asm/vmx.h
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xin Li <xin3.li@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-5-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240309012725.1409949-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/2024 9:27 AM, Sean Christopherson wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Move the bit defines for MSR_IA32_VMX_BASIC from msr-index.h to vmx.h so
> that they are colocated with other VMX MSR bit defines, and with the
> helpers that extract specific information from an MSR_IA32_VMX_BASIC value.

My understanding of msr-index.h is, it contains the index of various 
MSRs and the bit definitions of each MSRs.

Put the definition of each bit or bits below the definition of MSR index 
instead of dispersed in different headers looks more intact for me.

> Opportunistically use BIT_ULL() instead of open coding hex values.
> 
> Opportunistically rename VMX_BASIC_64 to VMX_BASIC_32BIT_PHYS_ADDR_ONLY,
> as "VMX_BASIC_64" is widly misleading.  The flag enumerates that addresses
> are limited to 32 bits, not that 64-bit addresses are allowed.
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/msr-index.h | 8 --------
>   arch/x86/include/asm/vmx.h       | 7 +++++++
>   2 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index af71f8bb76ae..5ca81ad509b5 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1122,14 +1122,6 @@
>   #define MSR_IA32_VMX_VMFUNC             0x00000491
>   #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
>   
> -/* VMX_BASIC bits and bitmasks */
> -#define VMX_BASIC_VMCS_SIZE_SHIFT	32
> -#define VMX_BASIC_TRUE_CTLS		(1ULL << 55)
> -#define VMX_BASIC_64		0x0001000000000000LLU
> -#define VMX_BASIC_MEM_TYPE_SHIFT	50
> -#define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
> -#define VMX_BASIC_INOUT		0x0040000000000000LLU
> -
>   /* Resctrl MSRs: */
>   /* - Intel: */
>   #define MSR_IA32_L3_QOS_CFG		0xc81
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 4fdc76263066..c3a97dca4a33 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -133,6 +133,13 @@
>   #define VMX_VMFUNC_EPTP_SWITCHING               VMFUNC_CONTROL_BIT(EPTP_SWITCHING)
>   #define VMFUNC_EPTP_ENTRIES  512
>   
> +#define VMX_BASIC_VMCS_SIZE_SHIFT		32
> +#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(48)
> +#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
> +#define VMX_BASIC_MEM_TYPE_SHIFT		50
> +#define VMX_BASIC_INOUT				BIT_ULL(54)
> +#define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
> +
>   static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
>   {
>   	return vmx_basic & GENMASK_ULL(30, 0);


