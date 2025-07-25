Return-Path: <kvm+bounces-53428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2B4B11704
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 05:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9790AC7990
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 03:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB9CA238C16;
	Fri, 25 Jul 2025 03:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PnYqFEBB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9954E2746A;
	Fri, 25 Jul 2025 03:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753413726; cv=none; b=MV8aqpmv6IsREuuOxuUk2dhBPGvTPeyyUlMjms9plwB1wrQTWRwKJ7jUDrWplLTmgSyw/WYumDwAN/Phjwy3JeFcseojXdkU7+nmXK7wV4sZP9Hsy6HmO4pSIGXbC5Al5YkwMxpgTguG09QH5ARxE0ChuBu03rFwlsda+kI4El0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753413726; c=relaxed/simple;
	bh=UTR/RVHQ4XrIJ+vrlr6LTFTom0zLWQY0XXQsmCXqbh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mdMxPobHagT3EqFCmiCwsvGir2tLgEU9rbzF7WrBtYAfHfMnfV53unN5BCBHF44VkcRC4xc7u/7K0YBy2gtiMRgH7xpdn//lJjz1tBMuAnoRWgLFaKlr7K1bvOTRf616hsq+45Sayv8DlSDbX3cUdk62lmRHvGABRaOuEGnsW1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PnYqFEBB; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753413725; x=1784949725;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UTR/RVHQ4XrIJ+vrlr6LTFTom0zLWQY0XXQsmCXqbh4=;
  b=PnYqFEBB/d5vBY1m9PjmNdbR72Pko3ylwkCve61eVRh/o/KYTXXHiKIm
   S52NleAXvgfMczUcCoWsBtsuEzg98FVZjl7beHCF8dAmAU2oC2yk0Rufy
   9j5GrHyNRJ8C6S0CzzlGw3/kr7/Ec/sd9IyPqK1o4PJ6jHJGhcUqQWHNL
   5Qc7X4G/JS2eghmopjd3WMced5G02UcliC3+vrfAjFDhapYWgxPtZ7k4z
   fXX4PD+mRo/mOfTBVYSP0J/nymOJ6a3+0Cwx9FDT+FrkCgzU4hMZWWsI9
   zNGuWJL+m0WL4apBikkULEfWj6+6QLKU0e/iRhcfzBO5lerCkp9CZaE7f
   Q==;
X-CSE-ConnectionGUID: 52dX3p9mTsK/asN9oBqZqg==
X-CSE-MsgGUID: 35DU9GSwRM+Npm4s36gvTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55708291"
X-IronPort-AV: E=Sophos;i="6.16,338,1744095600"; 
   d="scan'208";a="55708291"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 20:22:04 -0700
X-CSE-ConnectionGUID: ctIEQqfVSsOJed+4VFo1YQ==
X-CSE-MsgGUID: uREjuxgAScyVMAocS17ldA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,338,1744095600"; 
   d="scan'208";a="164851137"
Received: from unknown (HELO [10.238.3.238]) ([10.238.3.238])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 20:21:59 -0700
Message-ID: <ed0c3a20-d739-456a-8675-3218592857e3@linux.intel.com>
Date: Fri, 25 Jul 2025 11:21:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 2/3] x86/tdx: Tidy reset_pamt functions
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, vannapurve@google.com, Tony Luck <tony.luck@intel.com>,
 Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin
 <hpa@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kas@kernel.org, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com
References: <20250724130354.79392-1-adrian.hunter@intel.com>
 <20250724130354.79392-3-adrian.hunter@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250724130354.79392-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/24/2025 9:03 PM, Adrian Hunter wrote:
> tdx_quirk_reset_paddr() was renamed to reflect that, in fact, the clearing
> is necessary only for hardware with a certain quirk.  That is dealt with in
> a subsequent patch.
>
> Rename reset_pamt functions to contain "quirk" to reflect the new
> functionality, and remove the now misleading comment.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>
>
> Changes in V6:
>
> 	None
>
> Changes in V5:
>
> 	New patch
>
>
>   arch/x86/virt/vmx/tdx/tdx.c | 16 ++++------------
>   1 file changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index fc8d8e444f15..9e4638f68ba0 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -660,17 +660,17 @@ void tdx_quirk_reset_page(struct page *page)
>   }
>   EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
>   
> -static void tdmr_reset_pamt(struct tdmr_info *tdmr)
> +static void tdmr_quirk_reset_pamt(struct tdmr_info *tdmr)
>   {
>   	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
>   }
>   
> -static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)
> +static void tdmrs_quirk_reset_pamt_all(struct tdmr_info_list *tdmr_list)
>   {
>   	int i;
>   
>   	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++)
> -		tdmr_reset_pamt(tdmr_entry(tdmr_list, i));
> +		tdmr_quirk_reset_pamt(tdmr_entry(tdmr_list, i));
>   }
>   
>   static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
> @@ -1142,15 +1142,7 @@ static int init_tdx_module(void)
>   	 * to the kernel.
>   	 */
>   	wbinvd_on_all_cpus();
> -	/*
> -	 * According to the TDX hardware spec, if the platform
> -	 * doesn't have the "partial write machine check"
> -	 * erratum, any kernel read/write will never cause #MC
> -	 * in kernel space, thus it's OK to not convert PAMTs
> -	 * back to normal.  But do the conversion anyway here
> -	 * as suggested by the TDX spec.
> -	 */
> -	tdmrs_reset_pamt_all(&tdx_tdmr_list);
> +	tdmrs_quirk_reset_pamt_all(&tdx_tdmr_list);
>   err_free_pamts:
>   	tdmrs_free_pamt_all(&tdx_tdmr_list);
>   err_free_tdmrs:


