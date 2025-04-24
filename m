Return-Path: <kvm+bounces-44072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8FF1A9A24E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFFFF18894AB
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58A711E3762;
	Thu, 24 Apr 2025 06:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d9Tmj1Ln"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C0E19CCEA;
	Thu, 24 Apr 2025 06:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745476434; cv=none; b=PckO/jjVo20UONbbDxSVPbxaLHBocQtGQx+hUlTZqKsIUbSte3UoZ65IzaLVDlkoMBcPki6QDUIlhU/Wx3R5DfU02kP7NyJBJ220fScJ9CxiSXHHs56FzvhzZ+q3WXZ7L9CmEle+3HPtQkFQry6JvfW9cZnPwbgnUwdz22RCkvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745476434; c=relaxed/simple;
	bh=dcxOn/nuTpss+vf24oXBlr34cv3+AgMg/89LV6ad5rM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TguzyjdlRYpyypXyh4QUvrvtNBCfYKkjtbEMK/0nzZUX5u513PJQOkTmS4FuqpjpqMMLcQWvVOAiN5DmhvKBqoB1SXzIwEj1xoXcVVYQzA42EdGavwq3N894EfUsXKQ2ctQa7fwbdwz2vPtLt4uubZNIwIJLHV/KQady6rYldR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d9Tmj1Ln; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745476432; x=1777012432;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dcxOn/nuTpss+vf24oXBlr34cv3+AgMg/89LV6ad5rM=;
  b=d9Tmj1LnQP9hx66yDS6p8glM4v/kq94XcF1sxC/aAvR91xyy4tJ+J2QP
   qpEVmOZKrirDlBd0Za96P28j8Q4H2kLk2chbF+PwbPt3u/j5Il0yPnUte
   WfSjkje9MkPX46sLkjidfG9wEgPo/kJ/aThqvgdRR9RLzQlTQBeH/3iXM
   Ll7egNGKwyjLOAXGECBHUTgJExXBYpJK3QeEaLcWtg+/hvEmu0yx2a55p
   yYy1g6OkFMA58JQznGkzpwwwrPmv7ZyHHyosO9TYGQT0/AEWSvVVpMknQ
   xGZZ1ZeXi66cRiJa2PAsxZXlV0TaYHZDkRpephhm1uYf/1j72MBA6MMKO
   w==;
X-CSE-ConnectionGUID: uh33JJM0TIKbNwp+P2uWIQ==
X-CSE-MsgGUID: 5cQyryPySRKKPU1udgZxkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47226706"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="47226706"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 23:33:51 -0700
X-CSE-ConnectionGUID: l3lwgHW4RvWGJqWYsXT+Ow==
X-CSE-MsgGUID: x4fuAgz/TQeaZNeRxG6fQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="163563116"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 23:33:39 -0700
Message-ID: <7c44da88-72bb-4d1f-9f38-bf0e7e79b7a0@linux.intel.com>
Date: Thu, 24 Apr 2025 14:33:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 12/34] x86/msr: Remove pmu_msr_{read,write}()
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
 namhyung@kernel.org, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com,
 adrian.hunter@intel.com, kan.liang@linux.intel.com, wei.liu@kernel.org,
 ajay.kaher@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
 tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
 seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
 kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-13-xin@zytor.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250422082216.1954310-13-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 4/22/2025 4:21 PM, Xin Li (Intel) wrote:
> As pmu_msr_{read,write}() are now wrappers of pmu_msr_chk_emulated(),
> remove them and use pmu_msr_chk_emulated() directly.
>
> While at it, convert the data type of MSR index to u32 in functions
> called in pmu_msr_chk_emulated().
>
> Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> ---
>  arch/x86/xen/enlighten_pv.c | 17 ++++++++++-------
>  arch/x86/xen/pmu.c          | 24 ++++--------------------
>  arch/x86/xen/xen-ops.h      |  3 +--
>  3 files changed, 15 insertions(+), 29 deletions(-)
>
> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
> index 1418758b57ff..b5a8bceb5f56 100644
> --- a/arch/x86/xen/enlighten_pv.c
> +++ b/arch/x86/xen/enlighten_pv.c
> @@ -1089,8 +1089,9 @@ static void xen_write_cr4(unsigned long cr4)
>  static u64 xen_do_read_msr(unsigned int msr, int *err)
>  {
>  	u64 val = 0;	/* Avoid uninitialized value for safe variant. */
> +	bool emulated;
>  
> -	if (pmu_msr_read(msr, &val, err))
> +	if (pmu_msr_chk_emulated(msr, &val, true, &emulated) && emulated)

ah, here it is.

Could we merge this patch and previous patch into a single patch? It's
unnecessary to just modify the pmu_msr_read()/pmu_msr_write() in previous
patch and delete them immediately. It just wastes the effort.


>  		return val;
>  
>  	if (err)
> @@ -1133,6 +1134,7 @@ static void xen_do_write_msr(unsigned int msr, unsigned int low,
>  			     unsigned int high, int *err)
>  {
>  	u64 val;
> +	bool emulated;
>  
>  	switch (msr) {
>  	case MSR_FS_BASE:
> @@ -1162,12 +1164,13 @@ static void xen_do_write_msr(unsigned int msr, unsigned int low,
>  	default:
>  		val = (u64)high << 32 | low;
>  
> -		if (!pmu_msr_write(msr, val)) {
> -			if (err)
> -				*err = native_write_msr_safe(msr, low, high);
> -			else
> -				native_write_msr(msr, low, high);
> -		}
> +		if (pmu_msr_chk_emulated(msr, &val, false, &emulated) && emulated)
> +			return;
> +
> +		if (err)
> +			*err = native_write_msr_safe(msr, low, high);
> +		else
> +			native_write_msr(msr, low, high);
>  	}
>  }
>  
> diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
> index 95caae97a394..afb02f43ee3f 100644
> --- a/arch/x86/xen/pmu.c
> +++ b/arch/x86/xen/pmu.c
> @@ -128,7 +128,7 @@ static inline uint32_t get_fam15h_addr(u32 addr)
>  	return addr;
>  }
>  
> -static inline bool is_amd_pmu_msr(unsigned int msr)
> +static bool is_amd_pmu_msr(u32 msr)
>  {
>  	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
>  	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
> @@ -194,8 +194,7 @@ static bool is_intel_pmu_msr(u32 msr_index, int *type, int *index)
>  	}
>  }
>  
> -static bool xen_intel_pmu_emulate(unsigned int msr, u64 *val, int type,
> -				  int index, bool is_read)
> +static bool xen_intel_pmu_emulate(u32 msr, u64 *val, int type, int index, bool is_read)
>  {
>  	uint64_t *reg = NULL;
>  	struct xen_pmu_intel_ctxt *ctxt;
> @@ -257,7 +256,7 @@ static bool xen_intel_pmu_emulate(unsigned int msr, u64 *val, int type,
>  	return false;
>  }
>  
> -static bool xen_amd_pmu_emulate(unsigned int msr, u64 *val, bool is_read)
> +static bool xen_amd_pmu_emulate(u32 msr, u64 *val, bool is_read)
>  {
>  	uint64_t *reg = NULL;
>  	int i, off = 0;
> @@ -298,8 +297,7 @@ static bool xen_amd_pmu_emulate(unsigned int msr, u64 *val, bool is_read)
>  	return false;
>  }
>  
> -static bool pmu_msr_chk_emulated(unsigned int msr, uint64_t *val, bool is_read,
> -				 bool *emul)
> +bool pmu_msr_chk_emulated(u32 msr, u64 *val, bool is_read, bool *emul)
>  {
>  	int type, index = 0;
>  
> @@ -313,20 +311,6 @@ static bool pmu_msr_chk_emulated(unsigned int msr, uint64_t *val, bool is_read,
>  	return true;
>  }
>  
> -bool pmu_msr_read(u32 msr, u64 *val)
> -{
> -	bool emulated;
> -
> -	return pmu_msr_chk_emulated(msr, val, true, &emulated) && emulated;
> -}
> -
> -bool pmu_msr_write(u32 msr, u64 val)
> -{
> -	bool emulated;
> -
> -	return pmu_msr_chk_emulated(msr, &val, false, &emulated) && emulated;
> -}
> -
>  static u64 xen_amd_read_pmc(int counter)
>  {
>  	struct xen_pmu_amd_ctxt *ctxt;
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index a1875e10be31..fde9f9d7415f 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -271,8 +271,7 @@ void xen_pmu_finish(int cpu);
>  static inline void xen_pmu_init(int cpu) {}
>  static inline void xen_pmu_finish(int cpu) {}
>  #endif
> -bool pmu_msr_read(u32 msr, u64 *val);
> -bool pmu_msr_write(u32 msr, u64 val);
> +bool pmu_msr_chk_emulated(u32 msr, u64 *val, bool is_read, bool *emul);
>  int pmu_apic_update(uint32_t reg);
>  u64 xen_read_pmc(int counter);
>  

