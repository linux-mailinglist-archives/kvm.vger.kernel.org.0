Return-Path: <kvm+bounces-65243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB152CA1879
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 21:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B22DE30141F2
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 20:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599FB311C32;
	Wed,  3 Dec 2025 20:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gz5QFZc7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BD03074BA;
	Wed,  3 Dec 2025 20:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764792825; cv=none; b=Kr8Q/NIUFMIiPnljMCPpjjYnlRqJD1N4MjwEINO6HaFkxfOykjlYtSy964ZGp1MiCWxqcmjKtMLrcQINJW3Xv3o3QDtqZl85EAfkrx6znVgr9ESHNHvntqvEQySN+u3eXeYdrwmCrT3rjWt5aWgpaCUdwwlIXMoIrcLWBiQcX74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764792825; c=relaxed/simple;
	bh=yyo+qq6+FG5ZCy6uELXhH+AuAig0kMCUw6zL2jpI/Rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J8kRkzlj1FjMjtKbZtCPh2K/EbudINrgZ4nmyzu5udnUvGieilPKHdbuCR7xVCwscMYCHXGWCe49ga/eT8vlz8Qnva197C7qHII0hvHVLVOgxeRi4DIYc0OPpUX0iYtRWPBRB+E7j2rk7Z6sefSE+8jhWsYW1BkM5hdy+1HXQuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gz5QFZc7; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764792824; x=1796328824;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yyo+qq6+FG5ZCy6uELXhH+AuAig0kMCUw6zL2jpI/Rg=;
  b=gz5QFZc7dGTDu/IDlJ6oHjaoalpCou9hH9ER/N+969kLEtBaYl9wnkcm
   FePRK3+DMEHmZQyOyBrRwXCgyjv6UPYoHnxBQO2b+HgoIN8BZKQTiBALi
   WYC6oe8qG2lAJnryOshe0xBMFMzYfW4czNHJezw9ghqTkbwYr+BsXdy7/
   5Rbo0iy9wHIHgT6uyNtswiv8N8s0p0yR6RTralcKqGOXy6AQOEP+aT5W6
   BBrw0IXSO4/czzsS6tpQuSPayvPw07DjuRBwQFAgShJnk9aYFk0Pvchq1
   m+hqgrT62udoIa25Znfn+loZ8KkeRfVf4d2QN+CYKjrH1uRtY6urpBlOr
   Q==;
X-CSE-ConnectionGUID: rzQNuV8yRjeHl1jSlKmf8w==
X-CSE-MsgGUID: 5c1rICgoRGCtLwF5stf9ZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66525433"
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="66525433"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 12:13:43 -0800
X-CSE-ConnectionGUID: Z2Ku/y2YSeeMYlx8WfFOcw==
X-CSE-MsgGUID: b0nhFu+kT7asOtyHm+x0OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="225733064"
Received: from tslove-mobl4.amr.corp.intel.com (HELO [10.125.108.18]) ([10.125.108.18])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 12:13:41 -0800
Message-ID: <408079db-c488-492e-b6e7-063dea3cb861@intel.com>
Date: Wed, 3 Dec 2025 12:13:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "kas@kernel.org" <kas@kernel.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
 <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
 <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
 <f080efe3-6bf4-4631-9018-2dbf546c25fb@suse.com>
 <0274cee22d90cbfd2b26c52b864cde6dba04fc60.camel@intel.com>
 <7xbqq2uplwkc36q6jyorxe6u3fboka3snwar6parado5ysz25o@qrstyzh3okgh>
 <89d5876f-625b-43a6-bcad-d8caa4cbda2b@suse.com>
 <04c51f1d-b79b-4ff8-b141-5888407a318e@intel.com>
 <bb174006cbe969fc71fe71a3e12003ab9052213c.camel@intel.com>
 <474f5ace-e237-4c01-b0bc-d3e68ecc937b@intel.com>
 <8bd4850b0c74fbed531232a4a69603882a5562a1.camel@intel.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <8bd4850b0c74fbed531232a4a69603882a5562a1.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/3/25 11:59, Edgecombe, Rick P wrote:
> On Wed, 2025-12-03 at 10:21 -0800, Dave Hansen wrote:
>>> Thanks Dave. Yes, let's stick to the spec. I'm going to try to pull the
>>> loops
>>> out too because we can get rid of the union array thing too.
>>
>> Also, I honestly don't see the problem with just allocating an order-1
>> page for this. Yeah, the TDX modules doesn't need physically contiguous
>> pages, but it's easier for _us_ to lug them around if they are
>> physically contiguous.
> 
> We have two spin locks to contend with for these allocations. One is the global
> spin lock on the arch/x86 side. In this case, the the pages don't have to be
> passed far, like:
> 
> tdx_pamt_get(some_page, NULL)
> 	page1 = alloc()
> 	page2 = alloc()
> 
> 	scoped_guard(spinlock, &pamt_lock) {
> 		tdh_phymem_pamt_add(.., page1, page2)
> 			/* Pack into struct */
> 			seamcall()
> 	}
> 
> I think it's not too bad?

No, that's not bad.

The thing I thought was annoying was in the past when there were a bunch
of functions with two explicit page pointers plumbed in to them.

> So if we decide to pass a single order-1 page into tdx_pamt_get() instead of
> order_0_cache, we can stop passing the cache between KVM and arch/x86, but we
> then need two cache's instead of one. One for order-0 S-EPT page tables and one
> for order-1 DPAMT page pairs.
> 
> Also, if we have to allocate the order-1 page in each caller, it simplifies the
> arch/x86 code, but duplicates the allocation in the KVM callers (only 2 today
> though).
> 
> So I'm suspicious it's not going to be a big win, but I'll give it a try.

Yeah, the value of doing order-1 is super low if it means managing a
second cache.

>> Plus, if you permanently allocate 2 order-0 pages, you are _probably_
>> going to permanently destroy 2 potential future 2MB pages. The order-1
>> allocation will only destroy 1.
> 
> Doesn't the buddy allocator try to avoid splitting larger blocks? I guess you
> mean in the worst case, but the DPAMT should also not be allocated forever
> either. So I think it's only at the intersection of two worst cases? Worth it?

It's not splitting them in this case. They're *already* split:

# cat /proc/buddyinfo
...
Node 0, zone   Normal  32903  33566 ...

See, there are already ~33,000 4k pages sitting there. Those will be
consumed first on any 4k allocation. So, yeah, it'll avoid splitting an
8k block to get 4k pages normally.

BTW, I *DO* expect the DPAMT pages to be mostly allocated forever. Maybe
I'm just a pessimist, but you can't get them back for compaction or
reclaim, so they're basically untouchable. Sure, if you kill all the TDX
guests you get them back, but that's a very different kind of kernel
memory from stuff that's truly reclaimable under pressure.


