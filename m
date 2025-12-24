Return-Path: <kvm+bounces-66673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 827C9CDBC90
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 10:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EFBC9300E3E2
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 09:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32386331206;
	Wed, 24 Dec 2025 09:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gxDWFbJ4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A4232E724;
	Wed, 24 Dec 2025 09:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766568412; cv=none; b=Qayy4HOqCLJTltwZvejOLU45SclviP6pOvq+LTnbkAxyYZytOlOAZDEco6VC/ZLQo4EoNf6d28DuEv7N1/5Gn+dsXb16bHQH/a6cmNS3jrX+gzC4hfsUHg/92Dimr9CenSmWkVNHUeF/lXbGF42xe8Hg9ILR355VI1jkgiXcNgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766568412; c=relaxed/simple;
	bh=TRlVfYA4X4+m5hfXKcWKobnYHz0xkycISytSKfcbTCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tqpUT2ZyGvqykUOaUgnVYVt0Qd3CzhXqFnTqs1XEAGJ71AC+599VEDpBvVXtK0v8PxBF+BNHu4qLfAVhMu+hnyDQZDpRtNoXks1g3oVt1xEMaGhV2GWbX9SXJHV2J8VcfXttjipM44R/epPiUCzEBrLpUBJQZpE98bCd6wnsbEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gxDWFbJ4; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766568410; x=1798104410;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TRlVfYA4X4+m5hfXKcWKobnYHz0xkycISytSKfcbTCQ=;
  b=gxDWFbJ4YDYYMMvneD5KMeyYRVv+EbqdW9C6XvOsvILz5MRNsCJX3c3H
   LNy5KTAE7MZgTbkuvMrwJziuMWCI1MhWxhTGzWzM7CrivDSKrGmNvE7iP
   5Sw7XQZPakG9vGFdokB7B9tVviUy5BXpdnp9SpWOHslycAHqMhnzFbZPV
   65kEQQ3TfgJLOZEoEzWtKj92iqus2g4B1jE+/kChSSJZs+LiueLsadRpN
   eFUH5T1p3f+c3cfoA4K0bmYCrFbuq/2Oy6SKaDGY6z0rhLFgtBdnvAZMS
   qvZ8JY6W7qtwjmeCYYXtJa5SJoBYzuEmnbogAx+e2jo5A8q74gtrK+SQg
   g==;
X-CSE-ConnectionGUID: rbaE+OdpQIu9ErWo2ab+tQ==
X-CSE-MsgGUID: YVBKWiIVRJuuOaR7AdhMTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11651"; a="67406352"
X-IronPort-AV: E=Sophos;i="6.21,173,1763452800"; 
   d="scan'208";a="67406352"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2025 01:26:49 -0800
X-CSE-ConnectionGUID: IRYhiV5+SfemeYLvd3Ltkg==
X-CSE-MsgGUID: yGfTIJg+SLiCIrS7TGzEVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,173,1763452800"; 
   d="scan'208";a="200883541"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa010.fm.intel.com with ESMTP; 24 Dec 2025 01:26:45 -0800
Date: Wed, 24 Dec 2025 17:10:16 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
	isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
	seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
	x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
	binbin.wu@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Message-ID: <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121005125.417831-5-rick.p.edgecombe@intel.com>

> diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> index 13ad2663488b..00ab0e550636 100644
> --- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> +++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> @@ -33,6 +33,13 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
>  		sysinfo_tdmr->pamt_2m_entry_size = val;
>  	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000012, &val)))
>  		sysinfo_tdmr->pamt_1g_entry_size = val;
> +	/*
> +	 * Don't fail here if tdx_supports_dynamic_pamt() isn't supported. The
> +	 * TDX code can fallback to normal PAMT if it's not supported.
> +	 */
> +	if (!ret && tdx_supports_dynamic_pamt(&tdx_sysinfo) &&
> +	    !(ret = read_sys_metadata_field(0x9100000100000013, &val)))
> +		sysinfo_tdmr->pamt_page_bitmap_entry_bits = val;

Is it better we seal the awkward pattern inside the if (dpamt supported)  block:

	if (tdx_support_dynamic_pamt(&tdx_sysinfo))
		if (!ret && !(ret = read_sys_metadata_field(0x9100000100000013, &val)))
			sysinfo_tdmr->pamt_page_bitmap_entry_bits = val;

so we don't have to get used to another variant of the awkward pattern :)

Thanks,
Yilun

>  
>  	return ret;
>  }
> -- 
> 2.51.2
> 
> 

