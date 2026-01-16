Return-Path: <kvm+bounces-68354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (unknown [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B611D37A9A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:46:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6340C3040225
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB14339B48E;
	Fri, 16 Jan 2026 17:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="frU3eb6Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99101395DAC;
	Fri, 16 Jan 2026 17:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768585520; cv=none; b=FOsfDLLGNpliZ1uAwr7cXB59IUaG2HNEm5IFo7/hZpunO58GUlgQVhwMADvTmw++CRG+/STZHw7f8yz8evztBWrq4DrVWfw3VCzN2Jg+AKUF47Q9zMvkB8paJE2cgyWIbI126mvjd5S71gaPvTY8E2Ez5ZugTNKk4JIr5e7prTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768585520; c=relaxed/simple;
	bh=/xT83Eh6bYVdn/N5xvtNgZhtXxIpKst1Z74URHIELpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oGb5ZMHmo7PqSh/XRjvVMQgRHktoWOZs+dGPKNXWm7meZ1ezsyK8OS2DCGN/VUZpNiRelWAWY4gJ54Kidx3l9crNb/9n6d3LeYI9PwodbDwiJbMUxNtdvFnreGnrGWSFfDayrcubEIObAeIoZcJCN1cMQuLINwkGCF9f4OqaSgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=frU3eb6Q; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768585517; x=1800121517;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/xT83Eh6bYVdn/N5xvtNgZhtXxIpKst1Z74URHIELpw=;
  b=frU3eb6QvGNRvucj6OsJWvV+3NTUX0ldbzATYQjGyFMqQP30yWv+xb5t
   hsBzppJ/Ybk6QHFHI2f/05DfxRhk4M4719XlgS42eoAN1saUy8TAiNtBo
   NhKwx3bGEllY6pyZqSZXvVrd9sQ+s9S8K9KWyKaCTQmrjDXpju+qI+vA9
   dg5G+O0ssZmsIGkUYKSEsABz+G5eQwWCH+i4ILh7uWocQHvTNeTcUAafa
   vy0RUuxtLZoy6BWmTS36Cp914M+TMlgoPTaZrNsw6uVKhW5G7EV2KYA+c
   hF1sGjW6KgjBzI9whee4ndi6EgUUZ81F8gOcaZecovbvlTyWnUETj49zp
   Q==;
X-CSE-ConnectionGUID: K5h71EgCSySoBwwnfleOLw==
X-CSE-MsgGUID: TkYbT2EhQ6ybr25g2vjGGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="87319629"
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="87319629"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 09:45:17 -0800
X-CSE-ConnectionGUID: 08OeCHOJR52LEtDb5TMLVA==
X-CSE-MsgGUID: RDM8YWSyQjONjxbO4TLo+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="204516461"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.136]) ([10.125.111.136])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 09:45:16 -0800
Message-ID: <1b236a64-d511-49a2-9962-55f4b1eb08e3@intel.com>
Date: Fri, 16 Jan 2026 09:45:16 -0800
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
References: <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
 <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com>
 <aWgyhmTJphGQqO0Y@google.com>
 <435b8d81-b4de-4933-b0ae-357dea311488@intel.com>
 <aWpyA0_r_yVewnfx@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aWpyA0_r_yVewnfx@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/16/26 09:14, Sean Christopherson wrote:
...
>> *EVEN* if the pfn_to_page() itself is unsafe, and even if the WARN()s
>> are compiled out, this explicitly lays out the assumptions and it means
>> someone reading TDX code has an easier idea comprehending it.
> I object to the existence of those assumptions.  Why the blazes does TDX care
> how KVM and guest_memfd manages memory? 

For me, it's because TDX can't take arbitrary kvm_pfn_t's for private
memory. It's got to be able to be converted in the hardware, and also
have allocated TDX metadata (PAMT) that the TDX module was handed at
module init time. I thought kvm_pfn_t might, for instance be pointing
over to a shared page or MMIO. Those can't be used for TD private memory.

I think it's a pretty useful convention to know that the generic,
flexible kvm_pfn_t has been winnowed down to a more restrictive type
that is what TDX needs.

But, honestly, my big aversion was to u64's everywhere. I can certainly
live with a few kvm_pfn_t's in the TDX code. It doesn't have to be
'struct page'.

> If you want to assert that the pfn is compatible with TDX, then by
> all means.  But I am NOT accepting any more KVM code that assumes
> TDX memory is backed by refcounted struct page.  If I had been
> paying more attention when the initial TDX series landed, I would
> have NAK'd that too.
I'm kinda surprised by that. The only memory we support handing into TDs
for private memory is refcounted struct page. I can imagine us being
able to do this with DAX pages in the near future, but those have
'struct page' too, and I think they're refcounted pretty normally now as
well.

The TDX module initialization is pretty tied to NUMA nodes, too. If it's
in a NUMA node, the TDX module is told about it and it also universally
gets a 'struct page'.

Is there some kind of memory that I'm missing? What else *is* there? :)

> tdh_mem_page_aug() is just an absurdly slow way of writing a PTE.  It doesn't
> _need_ the pfn to be backed a struct page, at all.  IMO, what you're asking for
> is akin to adding a pile of unnecessary assumptions to e.g. __set_spte() and
> __kvm_tdp_mmu_write_spte().  No thanks.

Which part is absurdly slow? page_to_phys()? Isn't that just a shift by
an immediate and a subtraction of an immediate? Yeah, the subtraction
immediate is chonky so the instruction is big.

But at a quick glance I'm not seeing anything absurd.

