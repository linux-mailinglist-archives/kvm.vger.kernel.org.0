Return-Path: <kvm+bounces-67702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 832D3D11392
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:30:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 29ECC305B596
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 08:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECAF33F365;
	Mon, 12 Jan 2026 08:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TWUOEi8a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91378217F27;
	Mon, 12 Jan 2026 08:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768206619; cv=none; b=P9JNAOxVde50j1q0S1FjuQ4fc9K9EtHOX0Ih5XkeLtMRb5ZOeCrHIqJglehNkWS8LVpnfusG5cYKf2W6lD7Ux7cqe6OYpklIJ50/tj+UxmrZeme/TqqDvpNV06rR0dkjOvFVegCpgBGueT+L+N+FyXEeOX0jFBXzJWv7Xfvd8zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768206619; c=relaxed/simple;
	bh=jrAgn4dXHsnYYAywiEulVTrTcFbmHdDn3kMlPlVibnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U+YmxD4keenCwKBx2hv+IKF4xnmGuemjJCmwjckQEkXfrDNC/Up5Q8DxgfsiShVEt4EQGJjwC6BAgrjImZ6jC6u1NYntrStmMJf1ccRQfEhWXsVZaHuhdQvReIRuC0XpgHL4T93X9veH70XYDn+LnkvWrk25wRna4UnWvoTvvdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TWUOEi8a; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768206619; x=1799742619;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jrAgn4dXHsnYYAywiEulVTrTcFbmHdDn3kMlPlVibnA=;
  b=TWUOEi8af1Fz1UKE8Kq/L1D2m2YL97wrGnPzbYYvs2oQrJsMiSoWxY56
   LQzGeAPY9JJsQtpJpvGf2Q6ioRUWRMgPHCR3+vt0EOcJuQ+ygpL0uoYQ/
   mtteQXwhmsIlJUXZ7NtS3Wnr7Tx09T9rOiDMisH/jxhe5iCJ36IqWgohy
   NxeQoSaFejQJH7oJaaVsezhxvoNSspoz4KhijPZ6QDd9BiHFSDpcl3ZrA
   AZlx1vv/NuvdPE6KDpXpPYZ1xMze2fZsnamGQHUgPh7VqLpNkl5aU43z1
   j/xy9BCaCXwIpwWrygrm+nPeUqqPdfaCAWEI3iJPXTBf5B/myRcdvvhUB
   g==;
X-CSE-ConnectionGUID: g/p/UFU5QGusmqUrU+DdCA==
X-CSE-MsgGUID: TDf9Y1QIQpOXcZwVGx0phw==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="86893547"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="86893547"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 00:30:19 -0800
X-CSE-ConnectionGUID: AzF1K0QHQtGgfl9q+ehw0A==
X-CSE-MsgGUID: DOnwtQKmSaa/NPKCnoECyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="235271172"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 00:30:15 -0800
Message-ID: <de791cf0-9259-48f0-96d7-5248b145c7e4@linux.intel.com>
Date: Mon, 12 Jan 2026 16:30:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/virt/tdx: Retrieve TDX module version
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, x86@kernel.org, Chao Gao <chao.gao@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <20260109-tdx_print_module_version-v2-1-e10e4ca5b450@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260109-tdx_print_module_version-v2-1-e10e4ca5b450@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/10/2026 3:14 AM, Vishal Verma wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> Each TDX module has several bits of metadata about which specific TDX
> module it is. The primary bit of info is the version, which has an x.y.z
> format. These represent the major version, minor version, and update
> version respectively. Knowing the running TDX Module version is valuable
> for bug reporting and debugging. Note that the module does expose other
> pieces of version-related metadata, such as build number and date. Those
> aren't retrieved for now, that can be added if needed in the future.
> 
> Retrieve the TDX Module version using the existing metadata reading
> interface. Later changes will expose this information. The metadata
> reading interfaces have existed for quite some time, so this will work
> with older versions of the TDX module as well - i.e. this isn't a new
> interface.
> 
> As a side note, the global metadata reading code was originally set up
> to be auto-generated from a JSON definition [1]. However, later [2] this
> was found to be unsustainable, and the autogeneration approach was
> dropped in favor of just manually adding fields as needed (e.g. as in
> this patch).

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Link: https://lore.kernel.org/kvm/CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com/ # [1]
> Link: https://lore.kernel.org/all/1e7bcbad-eb26-44b7-97ca-88ab53467212@intel.com/ # [2]
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  arch/x86/include/asm/tdx_global_metadata.h  |  7 +++++++
>  arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 16 ++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
> index 060a2ad744bff..40689c8dc67eb 100644
> --- a/arch/x86/include/asm/tdx_global_metadata.h
> +++ b/arch/x86/include/asm/tdx_global_metadata.h
> @@ -5,6 +5,12 @@
>  
>  #include <linux/types.h>
>  
> +struct tdx_sys_info_version {
> +	u16 minor_version;
> +	u16 major_version;
> +	u16 update_version;
> +};
> +
>  struct tdx_sys_info_features {
>  	u64 tdx_features0;
>  };
> @@ -35,6 +41,7 @@ struct tdx_sys_info_td_conf {
>  };
>  
>  struct tdx_sys_info {
> +	struct tdx_sys_info_version version;
>  	struct tdx_sys_info_features features;
>  	struct tdx_sys_info_tdmr tdmr;
>  	struct tdx_sys_info_td_ctrl td_ctrl;
> diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> index 13ad2663488b1..0454124803f36 100644
> --- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> +++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> @@ -7,6 +7,21 @@
>   * Include this file to other C file instead.
>   */
>  
> +static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version)
> +{
> +	int ret = 0;
> +	u64 val;
> +
> +	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000003, &val)))
> +		sysinfo_version->minor_version = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000004, &val)))
> +		sysinfo_version->major_version = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000005, &val)))
> +		sysinfo_version->update_version = val;
> +
> +	return ret;
> +}
> +
>  static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
>  {
>  	int ret = 0;
> @@ -89,6 +104,7 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
>  {
>  	int ret = 0;
>  
> +	ret = ret ?: get_tdx_sys_info_version(&sysinfo->version);
>  	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
>  	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
>  	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
> 


