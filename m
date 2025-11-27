Return-Path: <kvm+bounces-64818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D61C8CAE2
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 03:38:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E65AA4E5FB9
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1DC26E165;
	Thu, 27 Nov 2025 02:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZYeqgLBA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6612817C203;
	Thu, 27 Nov 2025 02:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764211124; cv=none; b=YBmpa8F9O4zhkE4ZijcdVkNQeOJ9kNl+vw9hmePq9ckWjp9SSeX/g+09YCgOG8DHRGpXFJqiR84j4ap3u9Cp3WQe0E/C+n8V2Sj9MVKKorzG5ko3uGfipPJj8iSrQSPLO0Fhr4p450facxgOhxWk1fLur07V9X7vB0Jwumu2UZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764211124; c=relaxed/simple;
	bh=ZeSo/NAMMzsDPSFfLLW7h+9kdfdUjhO8M6Ls87/oJJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hd9+LRkwcrzBGRvwVsuz31Kk+LsCyzOUfgUnBkB7rcmmAqkMX83IEWyiydhBH7oGksr5BMf+tY4792ECBvA2gYy4N4Iru38bW5+7R7bEq34IOsztRznZW7hC1od7TPJjQwlswKUzMH297vPDy6lUScAZ43tcwlNOCpH7LcyMeMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZYeqgLBA; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764211122; x=1795747122;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZeSo/NAMMzsDPSFfLLW7h+9kdfdUjhO8M6Ls87/oJJE=;
  b=ZYeqgLBAF0ri+Uf6f5bmvM8UQPouhxA+8e3ytVuSB9XQ/zKA5pgfwQPY
   +16xFN8cJfBRXtYAPWhiPZDlfoN2b6lwDBy/BjQt28HF+YlIvOAuHraMA
   PzA6XI6oNOqQBn4YR7G9dRS6FIdvy/QASD4sgsoHXT1IPR4atMJ7DuSZJ
   2XrIHUQPS4RhrQGI9NL/kjQNnTfqFT/Qb1gCmQ8e6ib0YuXHssCYWXPma
   tXYyQZpDspKFRcxoZ5AdBLg0/djwxDxbhHbMniXhTybbFcLZ0XjOUfCzs
   C1AJDCfUY2+clIT7h71vetmuHhXwoKxdc0bIaVqN1pTb4RYQmnTh3CIw3
   g==;
X-CSE-ConnectionGUID: JChUElf3TZ+qtv1mkVSjxA==
X-CSE-MsgGUID: xPAGP7pUS5ava/kvTAELdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="65260351"
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="65260351"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 18:38:42 -0800
X-CSE-ConnectionGUID: U3q8/CSqRhWZizfM161IQw==
X-CSE-MsgGUID: 5DqnL/e1TpibBrz066G4RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="193209888"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 18:38:37 -0800
Message-ID: <9dcaa60c-6ffa-4f94-b002-3510110782dd@linux.intel.com>
Date: Thu, 27 Nov 2025 10:38:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y"
 <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-13-rick.p.edgecombe@intel.com>
 <7a6f5b4e-ad7b-4ad0-95fd-e1698f9b4e06@linux.intel.com>
 <af0e05e39229adb814601eb9ce720a0278be3c2f.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <af0e05e39229adb814601eb9ce720a0278be3c2f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/27/2025 6:33 AM, Edgecombe, Rick P wrote:
>>>     
>>>     static int tdx_topup_external_fault_cache(struct kvm_vcpu *vcpu, unsigned int cnt)
>>>     {
>>> -	struct vcpu_tdx *tdx = to_tdx(vcpu);
>>> +	struct tdx_prealloc *prealloc = &to_tdx(vcpu)->prealloc;
>>> +	int min_fault_cache_size;
>>>     
>>> -	return kvm_mmu_topup_memory_cache(&tdx->mmu_external_spt_cache, cnt);
>>> +	/* External page tables */
>>> +	min_fault_cache_size = cnt;
>>> +	/* Dynamic PAMT pages (if enabled) */
>>> +	min_fault_cache_size += tdx_dpamt_entry_pages() * PT64_ROOT_MAX_LEVEL;
>> Is the value PT64_ROOT_MAX_LEVEL intended, since dynamic PAMT pages are only
>> needed for 4KB level?
> I'm not sure I follow. We need DPAMT backing for each S-EPT page table.
Oh, right!

IIUIC,  PT64_ROOT_MAX_LEVEL is actually
- PT64_ROOT_MAX_LEVEL - 1 for S-ETP pages since root page is not needed.
- 1 for TD private memory page

It's better to add a comment about it.



