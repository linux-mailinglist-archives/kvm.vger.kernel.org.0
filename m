Return-Path: <kvm+bounces-32878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28E0D9E1133
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 03:21:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A904164ED8
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 835A47FBA2;
	Tue,  3 Dec 2024 02:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E0UJnLfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30C48460;
	Tue,  3 Dec 2024 02:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733192465; cv=none; b=VaGDzvLJKkww7zzNlKLH0hO71fyxWITY/AIx0BAAhjaaqquAGWV8rsYxfomsX9x9QFGnOLPHfzw3ZWBlf0enBoS6jovE37ZbtsctNTGfQc0OlVuMmUUyd1N0HhxuMJJbAoDQ5HAPkKD1sgVultjs/6CHdLoOlwklWrDFZWW1Lrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733192465; c=relaxed/simple;
	bh=6QLhNDCJd+Mbglo2M7lsrD4c4BimFb0EtNIzwqBf3NM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AQhY5BbHGo6Zq37SQHcNJs9goRp+Mhn2HT4/Yng5vQeQ5bZOHuUJfdAmtM1RiTorl7x9OWcgp8ksciorlkMwHQJMShHTP+Xze83Wtl+rQ9JLkd+JjDog1j8aU70hWp9AJ8lO4eicleVcVpR1dQhbz7KZ3FPBBN+uo2lsdIbylDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E0UJnLfZ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733192462; x=1764728462;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6QLhNDCJd+Mbglo2M7lsrD4c4BimFb0EtNIzwqBf3NM=;
  b=E0UJnLfZtxfpzR4KdewOzX5ztox+zMj2keromx1eFYwh6+XyFSM/+cbQ
   h5UOKEeloqKN2unJjSAgcCQoNqTTGJIKU1xAvycAL8HHDJrYg9epY+zLU
   T1OT3Ynb0+BxgmyU1j5BBJnD8kln9oKsbI89XvGSGyrVO/lbehuNpf+fV
   6XDhnx6/tc4RjUXhGzh8Bu3FuIqeySPNu50ScBhXtHKTgjXCLu99ZziJK
   ybGm7VWrosdwhs/qHi1x7cu+a4EOacJCuj6vNlal35NDEbm6eZNP9Io9a
   /yUQ9TgsHb4uFpXw/mmtAQPcX9y/ChIULwKYP9LutDSr+gyoJ6OuDxVSD
   w==;
X-CSE-ConnectionGUID: Dw/cLI2eQrOeIoNcmi3mwA==
X-CSE-MsgGUID: F6sB0xsxRLKkGOGzY+rS2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="37324603"
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="37324603"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 18:21:01 -0800
X-CSE-ConnectionGUID: tDGkM0k0R/iQdfQ0e2U7aA==
X-CSE-MsgGUID: Az8dXULyTU6E6BF3qMBJGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="98061415"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 18:20:58 -0800
Message-ID: <2863f94b-c01b-45f8-90fd-b237997d76ec@linux.intel.com>
Date: Tue, 3 Dec 2024 10:20:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD
 creation
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
 dave.hansen@intel.com, isaku.yamahata@gmail.com, kai.huang@intel.com,
 linux-kernel@vger.kernel.org, tony.lindgren@linux.intel.com,
 xiaoyao.li@intel.com, yan.y.zhao@intel.com, x86@kernel.org,
 adrian.hunter@intel.com, Isaku Yamahata <isaku.yamahata@intel.com>,
 Yuan Yao <yuan.yao@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
 <20241203010317.827803-3-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241203010317.827803-3-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 12/3/2024 9:03 AM, Rick Edgecombe wrote:
[...]
>   
> +/*
> + * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
> + * a CLFLUSH of pages is required before handing them to the TDX module.
> + * Be conservative and make the code simpler by doing the CLFLUSH
> + * unconditionally.
> + */
> +static void tdx_clflush_page(struct page *tdr)
The argument should have a generic name instead of tdr, because it's not
limited to TDR.

> +{
> +	clflush_cache_range(page_to_virt(tdr), PAGE_SIZE);
> +}
> +
> +u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
> +{
> +	struct tdx_module_args args = {
> +		.rcx = page_to_pfn(tdcs_page) << PAGE_SHIFT,
> +		.rdx = tdx_tdr_pa(td),
> +	};
> +
> +	tdx_clflush_page(tdcs_page);
> +	return seamcall(TDH_MNG_ADDCX, &args);
> +}
> +EXPORT_SYMBOL_GPL(tdh_mng_addcx);
> +
[...]


