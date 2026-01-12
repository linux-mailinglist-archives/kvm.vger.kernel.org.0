Return-Path: <kvm+bounces-67703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 28E53D113D1
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:32:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 37FB73004611
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 08:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3BB4340A4D;
	Mon, 12 Jan 2026 08:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="klpItBNg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE6113FEE;
	Mon, 12 Jan 2026 08:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768206738; cv=none; b=swH7vZ/mDL0xYRnAE27ElmrKHJeHoiJIA0xX/2luIDK2aAc3Gq1XldEckI1f4aCvWquGnnWyzcen9DCf1Ics5VZ1GQxzv0jpEclK9+U5dmp0POK9PNGO2qSWsAS7oUCSZGoHnXr5YcPeex4iajeRmZThGE6oxdkgYNoMWcLjDm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768206738; c=relaxed/simple;
	bh=SHfD2RJWN07Ig3ppVBYX66809qmhB/Z3/h6UsWxKPm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YO5498Zv3thIxXrKxpl5JCYNfT5Blu5k/0ivz45Du+PS/g6AwM5D0pYCnDRc5KzIAZFhnJf8SNgDwgtITC4jL0jX4SvJ1YFFoC27RlUIb82g97BMjQz7RQhZ9KSaKADgNkuy2iYikalYjVNJ+4Hhg0YPJAv9FLbgVwHWBGQHulo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=klpItBNg; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768206737; x=1799742737;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SHfD2RJWN07Ig3ppVBYX66809qmhB/Z3/h6UsWxKPm4=;
  b=klpItBNgBoYocNkeFBAVbnpPJWXCGPG3f67s6p4JMHlZFkFJ6hHrn2B0
   alW90iISqNi75NzPJx/BiKyqobtdp5kNnYITbksGt1poBnJm9uC55knvz
   37ednWMaFIwOYEKsMrkxWxJnrVAyuQ5ejkrEIIE6AL5snJdGw6i3U9wXV
   VNr1XCncnLXrTA6Fw8eyL9jYR5229ks5MUQQuRcDHejTcxQamE3GrC+OL
   hpy2dYoTh69CZ62At5Q/WqSiGJx2zEsmZ1SIbNJKwu8BfXFN9Repd0nfy
   x8dO4mBaF3brzmmCi2xb+cuNx2qbIFqZZUI8UB25eBTMCyPyhYG2ltJv9
   A==;
X-CSE-ConnectionGUID: mTO1DKfXSXedjf87AUXcMw==
X-CSE-MsgGUID: Zpfq2OTZT1Gg4aYGT4bCDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="86893676"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="86893676"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 00:32:17 -0800
X-CSE-ConnectionGUID: 3mXeXO1JTiKW1ZMdkdAAgQ==
X-CSE-MsgGUID: eJxxRbviSE6kc/PJi7/DTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="235271447"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 00:32:13 -0800
Message-ID: <da8d8997-e8b8-41e8-909b-44c49cae4a08@linux.intel.com>
Date: Mon, 12 Jan 2026 16:32:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] x86/virt/tdx: Print TDX module version during init
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, x86@kernel.org, Chao Gao <chao.gao@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/10/2026 3:14 AM, Vishal Verma wrote:
> It is useful to print the TDX module version in dmesg logs. This is
> currently the only way to determine the module version from the host. It
> also creates a record for any future problems being investigated. This
> was also requested in [1].
> 
> Include the version in the log messages during init, e.g.:
> 
>   virt/tdx: TDX module version: 1.5.24
>   virt/tdx: 1034220 KB allocated for PAMT
>   virt/tdx: module initialized
> 
> Print the version in get_tdx_sys_info(), right after the version
> metadata is read, which makes it available even if there are subsequent
> initialization failures.
> 
> Based on a patch by Kai Huang <kai.huang@intel.com> [2]

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/all/CAGtprH8eXwi-TcH2+-Fo5YdbEwGmgLBh9ggcDvd6N=bsKEJ_WQ@mail.gmail.com/ # [1]
> Link: https://lore.kernel.org/all/6b5553756f56a8e3222bfc36d0bdb3e5192137b7.1731318868.git.kai.huang@intel.com # [2]
> ---
>  arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> index 0454124803f3..4c9917a9c2c3 100644
> --- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> +++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> @@ -105,6 +105,12 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
>  	int ret = 0;
>  
>  	ret = ret ?: get_tdx_sys_info_version(&sysinfo->version);
> +
> +	pr_info("Module version: %u.%u.%02u\n",
> +		sysinfo->version.major_version,
> +		sysinfo->version.minor_version,
> +		sysinfo->version.update_version);
> +

Nit:

There is a mismatch b/t the change log and the code.

The printed message will be 
    virt/tdx: Module version: x.x.xx
instead of the format in the change log
    virt/tdx: TDX module version: x.x.xx


>  	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
>  	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
>  	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
> 


