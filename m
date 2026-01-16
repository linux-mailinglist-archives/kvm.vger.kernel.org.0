Return-Path: <kvm+bounces-68339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7056DD33993
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F03B23015DCB
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FFD39C623;
	Fri, 16 Jan 2026 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QEtOqZ5o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C1639A809;
	Fri, 16 Jan 2026 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768582629; cv=none; b=XxTi/V5TkhClin1CdEgIbZER1LWQ83eoVWpQ29HWQG/Me4smAM5tVCNPFpHUz2bRqG3WuJSvXhFH3VFEywc5vEg4rzFnk8qWpqTQwmmEwiLGqxb7qpQP6vlLBU3A17B0TJALVDG0vK3W/S057Ai0kNfLO+8eEwEhpH+yIF1/kxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768582629; c=relaxed/simple;
	bh=8glcXvh09XDfM2nhmq4IFfaeSh6pl3rPFOgKkUCgmMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HCNPxDwI/k7ets+EYYguAJXeSVPy09syhFgJLm9uXxtTx3aayvVtGglFMXE6ZtEihGCopUCY3B8DdAkQqfP0/upVkkUVvDBmpHZAw6nGJGJGuRqQWxNz4LM/BtW4FES2bXMEYzCvomGrecN/WWDzluv9VkLWAZiyuqzLhEGnCI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QEtOqZ5o; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768582628; x=1800118628;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8glcXvh09XDfM2nhmq4IFfaeSh6pl3rPFOgKkUCgmMs=;
  b=QEtOqZ5oUs+0l3F43pHGMlPZw3wxtYPBwUdMcJZd+U4l0rHgFquDIAJE
   46vm69mRE2CQO6HgDaLECwSthGPIPQTS83jdVhW9uPhr0kdEF7t962nKB
   rcs8EXJY2+cq8z7eNb0HE3bQb/Gx7YSa+iPJnTkGCmTDPc/4CbJi8UI8C
   v/jE2ZfXfmmQSD104Yu/5Cr4LPPBkzqnI0MxmLYpznMAvk/ScjtWv4XmT
   +e97Jp1LIIO9NGaABEgpWMW2QpcuAhFMHyZ4fqXGz3T+/uzxzM1Ve45RB
   djFcnC4twm/0s8emxZrPQ5wMfXuNdH50xRjHax3BPKB6RNxA7hPJsbR9J
   A==;
X-CSE-ConnectionGUID: fRn4pC6JTZqlFY3Qfxy2qw==
X-CSE-MsgGUID: CK4h2v0gRPOYUDMXecLO+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="87474904"
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="87474904"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 08:57:07 -0800
X-CSE-ConnectionGUID: Ugi92nmrT9qi2mxKH3rxxg==
X-CSE-MsgGUID: jc4lTBQVQ2m6hdD5M/XwLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="205319728"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.136]) ([10.125.111.136])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 08:57:06 -0800
Message-ID: <435b8d81-b4de-4933-b0ae-357dea311488@intel.com>
Date: Fri, 16 Jan 2026 08:57:05 -0800
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
References: <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com>
 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
 <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com>
 <aWgyhmTJphGQqO0Y@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aWgyhmTJphGQqO0Y@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 16:19, Sean Christopherson wrote:
>> 'struct page' gives us two things: One is the type safety, but I'm
>> pretty flexible on how that's implemented as long as it's not a raw u64
>> getting passed around everywhere.
> I don't necessarily disagree on the type safety front, but for the specific code
> in question, any type safety is a facade.  Everything leading up to the TDX code
> is dealing with raw PFNs and/or PTEs.  Then the TDX code assumes that the PFN
> being mapped into the guest is backed by a struct page, and that the folio size
> is consistent with @level, without _any_ checks whatsover.  This is providing
> the exact opposite of safety.
> 
>   static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> 			    enum pg_level level, kvm_pfn_t pfn)
>   {
> 	int tdx_level = pg_level_to_tdx_sept_level(level);
> 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> 	struct page *page = pfn_to_page(pfn);    <==================

I of course agree that this is fundamentally unsafe, it's just not
necessarily bad code.

I hope we both agree that this could be made _more_ safe by, for
instance, making sure the page is in a zone, pfn_valid(), and a few more
things.

In a perfect world, these conversions would happen at a well-defined
layer (KVM=>TDX) and in relatively few places. That layer transition is
where the sanity checks happen. It's super useful to have:

struct page *kvm_pfn_to_tdx_private_page(kvm_pfn_t pfn)
{
	struct page *page = pfn_to_page(pfn);
#ifdef DEBUG
	WARN_ON_ONCE(pfn_valid(pfn));
	// page must be from a "file"???
	WARN_ON_ONCE(!page_mapping(page));
	WARN_ON_ONCE(...);
#endif
	return page;
}

*EVEN* if the pfn_to_page() itself is unsafe, and even if the WARN()s
are compiled out, this explicitly lays out the assumptions and it means
someone reading TDX code has an easier idea comprehending it.

It's also not a crime to do the *same* checking on kvm_pfn_t and not
have a type transition. I just like the idea of changing the type so
that the transition line is clear and the concept is carried (forced,
even) through the layers of helpers.

