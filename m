Return-Path: <kvm+bounces-68408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EA20D38931
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 23:26:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4280D30B785F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 22:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2AC311C06;
	Fri, 16 Jan 2026 22:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ioo0vsqU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30341187346;
	Fri, 16 Jan 2026 22:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768602341; cv=none; b=EdKQUI9/wEzEuwf+eCMYDYyROWQsEWOXZ9soMhGSIPU5mqYf22gcnG4Na5U5pGjHXq6qrMPdt2ytgSePE+Ao9ausTJgSbbqvPdyuBY+mbP5cI3/9HbgwY1apnLJZdW9zeow1zPdCBU9+l6wkEEpRwJDQyiDHc7AmeHQdwFADVEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768602341; c=relaxed/simple;
	bh=2UMphO5hUDcS+n3m7RntOy0DoZnWNDfrIvER9BMsKN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vFjQTEfKASxn6fBdPYShpIAjIqfttJkbyd6Alv6gq5ji4ovjGUOretccupWK50ax3VsZVAzfTofrsIaU0v6fZuA5A85isqjW1TF1npwDdk5ya2Tq2z26oKL7mnZr9ttVWKQo+fAn/ckj3khTdZYVygkLBt0K9etQJEZcz5xVJIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ioo0vsqU; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768602339; x=1800138339;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2UMphO5hUDcS+n3m7RntOy0DoZnWNDfrIvER9BMsKN8=;
  b=Ioo0vsqUaM1UDQzaWS+tjdrr6jbd4wiYeP+cbOOoap2yardVgFZYdpJD
   o20v7iecEYOIL8/+pK4AWhD0JHw+u+HY1OnnRXQDC/JDi8mc6N1AkyoIv
   K3zCk93UPQ0q8bLK2CpzkeCLAOMaWMjciiPfxLvN6iIeweuZ8PEKSQl8N
   8xBmNJfD3yLjFqrrSSNFOex/U95FGt82oEXXA8D8H1pJVoPFUKr2FcQJs
   IBG18fJJp9tKZNeukaaLaMgGF86390ltkqNEmvMUde48tAewENkOW5cjT
   mXnOPqzkXX/yeTUBD2iVjXPJqybmtxYjoM7+NA1FwGeegZkM5COdAofLJ
   g==;
X-CSE-ConnectionGUID: RY033MZfSPqz3P2RBkTBvA==
X-CSE-MsgGUID: /fumV/DQTy2Xog79Mri1Kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="73551703"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="73551703"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 14:25:39 -0800
X-CSE-ConnectionGUID: oHey0hvlQi2XDmmu34Vadg==
X-CSE-MsgGUID: PyHVCVRQRcyzK2icp3AtnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="210212287"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.136]) ([10.125.111.136])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 14:25:36 -0800
Message-ID: <d119c824-4770-41d2-a926-4ab5268ea3a6@intel.com>
Date: Fri, 16 Jan 2026 14:25:35 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Sean Christopherson <seanjc@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Ackerley Tng <ackerleytng@google.com>,
 Vishal Annapurve <vannapurve@google.com>, pbonzini@redhat.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 rick.p.edgecombe@intel.com, kas@kernel.org, tabba@google.com,
 michael.roth@amd.com, david@kernel.org, sagis@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, nik.borisov@suse.com, pgonda@google.com,
 fan.du@intel.com, jun.miao@intel.com, francescolavra.fl@gmail.com,
 jgross@suse.com, ira.weiny@intel.com, isaku.yamahata@intel.com,
 xiaoyao.li@intel.com, kai.huang@intel.com, binbin.wu@linux.intel.com,
 chao.p.peng@intel.com, chao.gao@intel.com
References: <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com>
 <aWgyhmTJphGQqO0Y@google.com>
 <435b8d81-b4de-4933-b0ae-357dea311488@intel.com>
 <aWpyA0_r_yVewnfx@google.com>
 <1b236a64-d511-49a2-9962-55f4b1eb08e3@intel.com>
 <aWqYlXg4CS6vxS-o@google.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aWqYlXg4CS6vxS-o@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/16/26 11:59, Sean Christopherson wrote:
> The SEAMCALL itself.  I'm saying that TDH_MEM_PAGE_AUG is really just the S-EPT
> version of "make this PTE PRESENT", and that piling on sanity checks that aren't
> fundamental to TDX shouldn't be done when KVM is writing PTEs.
> 
> In other words, something like this is totally fine:
> 
> 	KVM_MMU_WARN_ON(!tdx_is_convertible_pfn(pfn));
> 
> but this is not:
> 
> 	WARN_ON_ONCE(!page_mapping(pfn_to_page(pfn)));

OK, I think I've got a better idea what you're aiming for. I think
that's totally doable going forward.

