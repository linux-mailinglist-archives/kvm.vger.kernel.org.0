Return-Path: <kvm+bounces-67460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 37391D05D23
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 20:24:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8C637302D89C
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 19:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899A732252D;
	Thu,  8 Jan 2026 19:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ld6TtS+F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD092EF64D;
	Thu,  8 Jan 2026 19:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767900271; cv=none; b=rj+l+Pjs/Ma3rJXxD4TfHLoCHYHtykX+5qld1aKKjEhuxKszTT6pk1IxRiDhGZwVf54Wr0fIoqjNp456tRTmb4Cdb7vOcN3ntd2GBBE1W7oGQtcTj5f5zu0h0feAEvrDKGPvAY3hQh4GN7Bxm0O0LdsMMpdgGzryN8BeTNwiPQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767900271; c=relaxed/simple;
	bh=R0a9LK1dYONZ116Zzg82ms1SgdZNEc+inhazljThNaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FgfCtngSsRcG13uEorF+OIYAg0UhqR+ITQuSEjOFXwAkFSknZ95p/6uu7p5VrN/UC6Z/Q9jRqSoj3h3xXjkndFQw+YCYzOVEmCc1PbSQdQov47xJ0kw1hRYgkZ8Jp5ih4+6O9bIUD6NQ53RuF7+Sx3tUvCY+r5BHFkiUhhJmC2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ld6TtS+F; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767900270; x=1799436270;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=R0a9LK1dYONZ116Zzg82ms1SgdZNEc+inhazljThNaw=;
  b=Ld6TtS+FGA9fK1NmnKwAsrv6+95QQMicr5fV0B5NzuYERoVyi57+qtmz
   Js+mxIAipM7ESkWj0TGUUOFGK2bt70rVO63c42Hu8bPF7DOAu/MBD2gHJ
   zuKe7Sm969yKSvFK/sI72E/2QbRSp0RBNTl/TxATB69IDNW6dofqrEtYp
   n2PPiqU42/kQVcZhrsCM4rqXe0ayd6NJPFV0cKmw/fF5J0/b9TG5cADw0
   VBx6OH40M+/dn66TSi8aWLh811P+qxPZI5wqVmlvzsBc9CJUO9bM2Z61C
   dayvaAZ0POgBjxzt6ruWkQgp+4eo6dXfee/PKPdCBqS7xKVQU2pwKO8z6
   w==;
X-CSE-ConnectionGUID: XjHip6hFT4S+o/g2JzIM5g==
X-CSE-MsgGUID: NnmGgk6LQ86Cl1EDFZVzmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="80393800"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="80393800"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 11:24:30 -0800
X-CSE-ConnectionGUID: mOruqMKQRGKRsG/VbtDp4A==
X-CSE-MsgGUID: BW83T7JuRdKJHD4dVPrVTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="240768750"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.109.197]) ([10.125.109.197])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 11:24:30 -0800
Message-ID: <305c16d7-803e-42fa-b540-025e8571452b@intel.com>
Date: Thu, 8 Jan 2026 11:24:29 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
To: Ackerley Tng <ackerleytng@google.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 kas@kernel.org, tabba@google.com, michael.roth@amd.com, david@kernel.org,
 vannapurve@google.com, sagis@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, nik.borisov@suse.com, pgonda@google.com,
 fan.du@intel.com, jun.miao@intel.com, francescolavra.fl@gmail.com,
 jgross@suse.com, ira.weiny@intel.com, isaku.yamahata@intel.com,
 xiaoyao.li@intel.com, kai.huang@intel.com, binbin.wu@linux.intel.com,
 chao.p.peng@intel.com, chao.gao@intel.com
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101826.24870-1-yan.y.zhao@intel.com>
 <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com>
 <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
 <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com>
 <CAEvNRgEA69UL_=T+vE6z0wxNf59ie9neSbpyrp58_784C8vL9w@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAEvNRgEA69UL_=T+vE6z0wxNf59ie9neSbpyrp58_784C8vL9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/26 11:05, Ackerley Tng wrote:
...
>> All of those properties are important and they're *GONE* if you use a
>> pfn. It's even worse if you use a raw physical address.
> 
> We were thinking through what it would take to have TDs use VM_PFNMAP
> memory, where the memory may not actually have associated struct
> pages. Without further work, having struct pages in the TDX interface
> would kind of lock out those sources of memory. Is TDX open to using
> non-kernel managed memory?

I was afraid someone was going to bring that up. I'm not open to such a
beast today. I'd certainly look at the patches, but it would be a hard
sell and it would need an awfully strong justification.

> For type safety, would phyrs help? [1] Perhaps starting with pfn/paddrs
> + nr_pages would allow transitioning to phyrs later. Using pages would
> be okay for now, but I would rather not use folios.

I don't have any first-hand experience with phyrs. It seems interesting,
but might be unwieldy to use in practice, kinda how the proposed code
got messy when folios got thrown in.

