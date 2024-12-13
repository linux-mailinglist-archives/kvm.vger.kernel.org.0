Return-Path: <kvm+bounces-33738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B4349F122C
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A99BA16A8D5
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86AD61E411D;
	Fri, 13 Dec 2024 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SfMYwcVb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8DC57C9F;
	Fri, 13 Dec 2024 16:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734107423; cv=none; b=essuIm6Y6xWO1gMde4oiafuLfpwytHs4Ltjcat6YKoV/Hb1b1cfR9dBAgjMscmMkN6uEPbJUmvmnIB2GbIacSspLROa+couM07JWh9pac+oGFzF9BwhBHbK31cZfIv9x63+7hHL520DyG/3oyMn9Ek+axJBEsPX3J29jLEdPD9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734107423; c=relaxed/simple;
	bh=n7Y3u1viKbpen2gpCV4aMU6Z6h7LLCZKOtcecnQzgMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iyQ0UwTJpJhKC+kJhFo9KxVl5DwnIqA+n/xS93qe+a2i22t+65rURoDsWQsozxyoaCxIxPCH293xiLTJVQcHgUsZdrgWCs9IB49ZRDpDqQwvQBadOsYQjXMgv/BXnsbWIWfZKVscfXQp8sUx15LRMKmaXaHZIVo68q+dVb+D060=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SfMYwcVb; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734107421; x=1765643421;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n7Y3u1viKbpen2gpCV4aMU6Z6h7LLCZKOtcecnQzgMo=;
  b=SfMYwcVbO1Q/E5FULhxjuVjZs4KmKvCiYd1F9jUb/0rQep0JmyZQS06M
   9BVwcmvTnvPI19iQdrYQlJwI2p0Vn5BtMeL+KPBsYniqffC2JZ7oAwez3
   bEqqlwISOBdqlOY47a28ooXlJCML8wCGa0RHr3V841gmAjbj4SnXG4d3v
   fgZRvNZpT51tZUaYczC+l/ud8fCXIG+6BVIpc7HYdeOl8PAVTHRKDSqS3
   8zRdPVAhOjGjDutdjniSEsXwfIVy/hjUiE82M7QN+IGHKO0F5TjwL46Iq
   1uPwSRotLRvBSV9Ph9S4gSxT5Tfv3S0pMZNw2OuvVXcQffDws2VlMbVil
   A==;
X-CSE-ConnectionGUID: Woh5SEC2QgqrdIdLFlunPg==
X-CSE-MsgGUID: jkDPurkHSIWGmUGaBBc9yw==
X-IronPort-AV: E=McAfee;i="6700,10204,11285"; a="59960622"
X-IronPort-AV: E=Sophos;i="6.12,231,1728975600"; 
   d="scan'208";a="59960622"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 08:30:21 -0800
X-CSE-ConnectionGUID: 11fwTFv/TG6aYKyRWj7Nhg==
X-CSE-MsgGUID: CL43aukUQauL+gUCEFF/pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="96439824"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.163])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 08:30:15 -0800
Message-ID: <f7cd9af3-8b6a-4984-80ef-e9129d8d94bd@intel.com>
Date: Fri, 13 Dec 2024 18:30:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
To: Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-2-adrian.hunter@intel.com>
 <fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com>
 <0226840c-a975-42a5-9ddf-a54da7ef8746@intel.com>
 <56db8257-6da2-400d-8306-6e21d9af81f8@intel.com>
 <d1952eb7-8eb0-441b-85fc-3075c7b11cb9@intel.com>
 <6af0f1c3-92eb-407e-bb19-6aeca9701e41@intel.com>
 <ff4d5877-52ad-4e12-94a0-dfbe01a7a8a0@intel.com>
 <d1b0323f-2458-420b-800e-a26ba6550de7@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <d1b0323f-2458-420b-800e-a26ba6550de7@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/12/24 18:16, Dave Hansen wrote:
> On 12/11/24 10:43, Adrian Hunter wrote:
> ...
>> -	size = tdvmcall_a0_read(vcpu);
>> -	write = tdvmcall_a1_read(vcpu);
>> -	port = tdvmcall_a2_read(vcpu);
>> +	size  = tdx->vp_enter_out.io_size;
>> +	write = tdx->vp_enter_out.io_direction == TDX_WRITE;
>> +	port  = tdx->vp_enter_out.io_port;
> ...> +	case TDVMCALL_IO:
>> +		out->io_size		= args.r12;
>> +		out->io_direction	= args.r13 ? TDX_WRITE : TDX_READ;
>> +		out->io_port		= args.r14;
>> +		out->io_value		= args.r15;
>> +		break;
> 
> I honestly don't understand the need for the abstracted structure to sit
> in the middle. It doesn't get stored or serialized or anything, right?
> So why have _another_ structure?
> 
> Why can't this just be (for instance):
> 
> 	size = tdx->foo.r12;
> 
> ?
> 
> Basically, you hand around the raw arguments until you need to use them.

That sounds like what we have at present?  That is:

u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args)
{
	args->rcx = tdvpr;

	return __seamcall_saved_ret(TDH_VP_ENTER, args);
}

And then either add Rick's struct tdx_vp?  Like so:

u64 tdh_vp_enter(struct tdx_vp *vp, struct tdx_module_args *args)
{
	args->rcx = tdx_tdvpr_pa(vp);

	return __seamcall_saved_ret(TDH_VP_ENTER, args);
}

Or leave it to the caller:

u64 tdh_vp_enter(struct tdx_module_args *args)
{
	return __seamcall_saved_ret(TDH_VP_ENTER, args);
}

Or forget the wrapper altogether, and let KVM call
__seamcall_saved_ret() ?


