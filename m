Return-Path: <kvm+bounces-58517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14B45B94D87
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 09:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2272918A80AE
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100CC3164BE;
	Tue, 23 Sep 2025 07:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RtenWnvZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB9A238C0D;
	Tue, 23 Sep 2025 07:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758613558; cv=none; b=YLAhgIFk47a8JN5MOmak/cVQ5xR6ZIfJ09VIDW+F2w3zt1fRjyn+JTSoaZn+IsA3Lnn75+35j5MEiEkzQ0o5ESHEMD6J3Q9vB7PTfrxjDlH5sRa5ElV0ALUq3YTwroIwX7eOPB9N+q1atnKvNiVhEwTTHvvE7pqlOmtZWRiUY28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758613558; c=relaxed/simple;
	bh=QjOVUv6N/38FhKzxHyEcHyndPdo/xaEAfc+lb6/Y+zw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pHSMJoV+KiTujjblaTeVZIEfHYHYqRU7JigNyk/kOVpk2yXikJ2KdtXlvQU+vF4lDpnFImivnbph+Qv4fNfhBDH/ZH127AQBac+NDpKv32fIZGl/44eFpta0+m6uwvyszfY4y+n4MS5U3szqiIZoVnyzwI50SWBiKbdXNwhqz+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RtenWnvZ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758613556; x=1790149556;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QjOVUv6N/38FhKzxHyEcHyndPdo/xaEAfc+lb6/Y+zw=;
  b=RtenWnvZVnqKysXW2RyF+HxwwMl6g4oWJm5C2rS0Ib1d2fq0TpqEdZ7M
   T8xR+XS9l3jdHxvrueCl/sc/Nvuv8KbtBUGzSa8mfG2GVGOAeVLpia7jA
   uR+TGM+wHMoQIwqoNfK/FJy7oHEdO393kL5aXBhlcfSRFwmDFqG47Byc5
   Uucd42ym+Bx4/aTG3TqhcZ9jGnQGrixPenBRdiJGh9yPNdpadeVoYb5iX
   a1vBB+m0XR+rJCR7JmvSuE+ZYSrYAQLHyYZCEcp90vpsjqCXpeP8+uwQ0
   8U2oIy2jtuvstj7W9Gp8s4FNaF8YjjG8E0sD102n3PtFwzyM2jNhw00Pa
   A==;
X-CSE-ConnectionGUID: x//NEh/BSwGIT0YqUDzaTg==
X-CSE-MsgGUID: 7ID78B0QQTG9R0Hf9LK5JA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="64711073"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="64711073"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 00:45:55 -0700
X-CSE-ConnectionGUID: yY7r16ZVR8OCZNQEBYwXTw==
X-CSE-MsgGUID: WUkDkTurR2u61OLg4ILnMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="177145492"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 00:45:51 -0700
Message-ID: <47f8b553-1cb0-4fb0-993b-affd4468475e@linux.intel.com>
Date: Tue, 23 Sep 2025 15:45:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/16] x86/virt/tdx: Allocate reference counters for
 PAMT memory
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kas@kernel.org, bp@alien8.de, chao.gao@intel.com,
 dave.hansen@linux.intel.com, isaku.yamahata@intel.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, x86@kernel.org, yan.y.zhao@intel.com,
 vannapurve@google.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-6-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250918232224.2202592-6-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/19/2025 7:22 AM, Rick Edgecombe wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> The PAMT memory holds metadata for TDX protected memory. With Dynamic
> PAMT, the 4KB range of PAMT is allocated on demand. The kernel supplies
> the TDX module with a page pair that covers 2MB of host physical memory.
>
> The kernel must provide this page pair before using pages from the range
> for TDX. If this is not done, any SEAMCALL that attempts to use the memory
> will fail.
>
> Allocate reference counters for every 2MB range to track PAMT memory usage.
> This is necessary to accurately determine when PAMT memory needs to be
> allocated and when it can be freed.
>
> This allocation will currently consume 2 MB for every 1 TB of address
> space from 0 to max_pfn (highest pfn of RAM). The allocation size will
> depend on how the ram is physically laid out. In a worse case scenario
> where the entire 52 address space is covered this would be 8GB. Then
                   ^
                  52-bit
> the DPAMT refcount allocations could hypothetically exceed the savings
> from Dynamic PAMT, which is 4GB per TB. This is probably unlikely.
>
> However, future changes will reduce this refcount overhead to make DPAMT
> always a net win.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [Add feedback, update log]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> v3:
>   - Split out lazily populate optimization to next patch (Dave)
>   - Add comment around pamt_refcounts (Dave)
>   - Improve log
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 47 ++++++++++++++++++++++++++++++++++++-
>   1 file changed, 46 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 4e4aa8927550..0ce4181ca352 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -29,6 +29,7 @@
>   #include <linux/acpi.h>
>   #include <linux/suspend.h>
>   #include <linux/idr.h>
> +#include <linux/vmalloc.h>
>   #include <asm/page.h>
>   #include <asm/special_insns.h>
>   #include <asm/msr-index.h>
> @@ -50,6 +51,16 @@ static DEFINE_PER_CPU(bool, tdx_lp_initialized);
>   
>   static struct tdmr_info_list tdx_tdmr_list;
>   
> +/*
> + * On a machine with Dynamic PAMT, the kernel maintains a reference counter
> + * for every 2M range. The counter indicates how many users there are for
> + * the PAMT memory of the 2M range.
> + *
> + * The kernel allocates PAMT memory when the first user arrives and
> + * frees it when the last user has left.
> + */
> +static atomic_t *pamt_refcounts;
> +
>   static enum tdx_module_status_t tdx_module_status;
>   static DEFINE_MUTEX(tdx_module_lock);
>   
> @@ -183,6 +194,34 @@ int tdx_cpu_enable(void)
>   }
>   EXPORT_SYMBOL_GPL(tdx_cpu_enable);
>   
> +/*
> + * Allocate PAMT reference counters for all physical memory.
> + *
> + * It consumes 2MiB for every 1TiB of physical memory.
> + */
> +static int init_pamt_metadata(void)
> +{
> +	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);

Is there guarantee that max_pfn is PTRS_PER_PTE aligned?
If not, it should be rounded up.

> +
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return 0;
> +
> +	pamt_refcounts = vmalloc(size);
> +	if (!pamt_refcounts)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
>
[...]

