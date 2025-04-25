Return-Path: <kvm+bounces-44252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A588FA9BF8C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3DB91B6481F
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 07:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD022376F8;
	Fri, 25 Apr 2025 07:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AYBWMJKo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996A322F392;
	Fri, 25 Apr 2025 07:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745565163; cv=none; b=A3rm9QuRB/DtHl33P3tweL7n+H8nV08wE3MyPDUbNMcdSjyCI7B92i/AYqk5ZiOCoPTLjsb+0K/qSpzOGLSdJR4Qe6epw2TmRYvaRA95Fq97l29mshScU11Njud5SHj6WivVsDmPstpX8TIv21SBYk1E9byyCwISs0GGnJKx1YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745565163; c=relaxed/simple;
	bh=d/b568s6HApQOCiprMr5s7J7XabhVr0AUnYNmAFHfCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n8Gu2rSIt53fFLryFzE/ZINBJyLKPA6HU7oiRHFthS3Q6wPV87recUarYAglz0zimQ+P4ZpLuEo1QSCz5B/12S1qrKUWYIxpBWa2eYo/+c87CtyzVF352KcOYvZlU6LrlH8K9mGilvWdqWWrgKeD09uirQnJo4jIOIRmVKm6FjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AYBWMJKo; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745565162; x=1777101162;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d/b568s6HApQOCiprMr5s7J7XabhVr0AUnYNmAFHfCg=;
  b=AYBWMJKo9hCO9FNV6T1mQtaR4sdeHIxC3U2i//HdeBb6KfxQx3MFa2bY
   4nEqLYwyTVnoECp7w22dlr6fO+z3mMJw3wjubgHUbG/7hooS646EN1kl3
   bRb/lJjsT9ocSTslJhSRpCU3qJcsIi6OYwhZ4u0BgpjWOHcmOR8KdngTl
   QWTmRN9gQykflJkHAVO1pIfM4v7WTP+rfqlisMnCenkge/nQRuQlXVqzd
   XLmROHzSPUCoFQ6nN28AjMgvTVpLf7cmgPkjNBEfNWPiCbFCYUZxTeaIY
   8mXGGFCGGpltGSr8oG7d7gvR92MG521MJBajNS1YgNRQt9j9kluHTVeLG
   w==;
X-CSE-ConnectionGUID: VvuGBx6wSe+eKL55C5W6/g==
X-CSE-MsgGUID: owHMe5ulSEOAraTan0nY6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="64636834"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="64636834"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:12:41 -0700
X-CSE-ConnectionGUID: ZOI/EPSLRKOOrlSJflAP5w==
X-CSE-MsgGUID: 9919dTXsShehyniJZvSzHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="133343271"
Received: from yijiemei-mobl.ccr.corp.intel.com (HELO [10.238.2.108]) ([10.238.2.108])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:12:35 -0700
Message-ID: <8e15c41e-730f-493e-9628-99046af50c1e@linux.intel.com>
Date: Fri, 25 Apr 2025 15:12:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030445.32704-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250424030445.32704-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/2025 11:04 AM, Yan Zhao wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> Add a wrapper tdh_mem_page_demote() to invoke SEAMCALL TDH_MEM_PAGE_DEMOTE
> to demote a huge leaf entry to a non-leaf entry in S-EPT. Currently, the
> TDX module only supports demotion of a 2M huge leaf entry. After a
> successful demotion, the old 2M huge leaf entry in S-EPT is replaced with a
> non-leaf entry, linking to the newly-added page table page. The newly
> linked page table page then contains 512 leaf entries, pointing to the 2M

2M or 4K?

> guest private pages.
[...]

