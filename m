Return-Path: <kvm+bounces-67687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F6DD10589
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 03:31:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 187BA3019952
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 02:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3116303CAE;
	Mon, 12 Jan 2026 02:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EuQsjunq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988D027472;
	Mon, 12 Jan 2026 02:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768185096; cv=none; b=ZgoRe5AsthjZbKai1J7dG59dFGV36Z8lLqGU0I2JHTyzPwPudHlIM5xaxJTQxDyKk5p6YJ/dJ5yihCs4I2N0644zDxrZXpe8Dx9sn8jrqwIN8Aq1wikpSu4A/oO9jd9Jt4vEPNW3vgvHAdVNpAxz7tsHm4uUesLSkgg00ctw5Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768185096; c=relaxed/simple;
	bh=bsKZnROZ3ZAmLrfMM/dNfinovFFuhABv7ylOUzRbge0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xid0UAbg05T0MJ0FY3A1MuDoCRjr8fAzvzWSqJu3qO4AqyX3ErTi4Qce2G8IaPY0aZ9YON4Sbhkqb2C8hLs2KX6RkPx6OvxYoSelCaD5whLh9rW9zl5S6QkeK7HC1I3Sxf0aUqmwNv5huJksUCOqndkdH0xhNU9kNTKhA/EBV8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EuQsjunq; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768185096; x=1799721096;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bsKZnROZ3ZAmLrfMM/dNfinovFFuhABv7ylOUzRbge0=;
  b=EuQsjunqD1qCOpNwTHIZ27ALeDSa8Ah4/522He6jfUKvppmi8BNClVWQ
   PTI1n0q8fhJar7M0h6evmC+/rPCyH25ahqRbDGMcfwN5kcTVp9kuZc3cO
   EMUMWjxOHWiL9C/2Zhi7s+XyQbzO5OOID6wch/e1l41eoQ4Z06aHEe0Cd
   Ke/JODu0C+rq9kSHDc2mX7g700wgRktYdVgdGfB7drYO4YqmrQWc70zF4
   DFCUXyDrXoPCNmCKlrOPcDDrS8cILWTFWCfVGqg1RpQLOWVg56tTFvL9R
   NidGiY5uU0CdheGIi7kGd21xWAzKPC6u8/irThhIfvx4QGr3dXasH60xM
   A==;
X-CSE-ConnectionGUID: +gypNE4rR02kWCzbKnHgdw==
X-CSE-MsgGUID: E8Jh5xKlS6+gHrUNpEAKjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="68664923"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="68664923"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:31:35 -0800
X-CSE-ConnectionGUID: eaTG7udHQb6QZjGJtZac9Q==
X-CSE-MsgGUID: 6CK773nKTrS9trH1KFQ8LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208464323"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:31:31 -0800
Message-ID: <41951d4b-43a4-4978-8e78-aa031e423601@intel.com>
Date: Mon, 12 Jan 2026 10:31:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] x86/virt/tdx: Print TDX module version during init
To: Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org
Cc: x86@kernel.org, Chao Gao <chao.gao@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/2026 3:14 AM, Vishal Verma wrote:
> It is useful to print the TDX module version in dmesg logs. This is
> currently the only way to determine the module version from the host. It
> also creates a record for any future problems being investigated. This
> was also requested in [1].
> 
> Include the version in the log messages during init, e.g.:
> 
>    virt/tdx: TDX module version: 1.5.24
>    virt/tdx: 1034220 KB allocated for PAMT
>    virt/tdx: module initialized
> 
> Print the version in get_tdx_sys_info(), right after the version
> metadata is read, which makes it available even if there are subsequent
> initialization failures.
> 
> Based on a patch by Kai Huang <kai.huang@intel.com> [2]
> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/all/CAGtprH8eXwi-TcH2+-Fo5YdbEwGmgLBh9ggcDvd6N=bsKEJ_WQ@mail.gmail.com/ # [1]
> Link: https://lore.kernel.org/all/6b5553756f56a8e3222bfc36d0bdb3e5192137b7.1731318868.git.kai.huang@intel.com # [2]
> ---
>   arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> index 0454124803f3..4c9917a9c2c3 100644
> --- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> +++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> @@ -105,6 +105,12 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
>   	int ret = 0;
>   
>   	ret = ret ?: get_tdx_sys_info_version(&sysinfo->version);
> +
> +	pr_info("Module version: %u.%u.%02u\n",
> +		sysinfo->version.major_version,
> +		sysinfo->version.minor_version,
> +		sysinfo->version.update_version);
> +
>   	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
>   	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
>   	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
> 


