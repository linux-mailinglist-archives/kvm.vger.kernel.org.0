Return-Path: <kvm+bounces-67250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 81DC5CFF495
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 19:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 46F503646D78
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E94743A0B26;
	Wed,  7 Jan 2026 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mK+FVVj2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48693A0B3A;
	Wed,  7 Jan 2026 16:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767804006; cv=none; b=dyJBDo5vlF8t4eqHTT4ierdSWsO61ObzYVCOeJVz3vdwhv/Jao1aLco8AoXOtmyhATFouJhdQxePgX2CDayJ1AoOhqrqBw6llr3WOXREP9Z/NkrmCaqkhEplf5VoBNTsd6tnv2UWWbtDR6DcK38pudWQKUx/upKedQA/bos+fvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767804006; c=relaxed/simple;
	bh=CB2zMbNYO93W6LZtbnqlBYrZeMYIOCmm41I2CVMJN68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YyzHBC1F2mmnZDKYOpp3Adf0iJgOmw2chWfMb0cfNDlORz1Wzeg0CRcIvxdNW2zECMrdVdpScIUxBP+KOHUrthxQS0JKC1dVNokuZVZFtEBYmiljBRVmvanIdN9BvTR2+eUO1faqwAkJRoGma3yiygufPih1qpULiflMYBdSD7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mK+FVVj2; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767804000; x=1799340000;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CB2zMbNYO93W6LZtbnqlBYrZeMYIOCmm41I2CVMJN68=;
  b=mK+FVVj2dGbvxBtGLKP2hSUYQuhw89QCaC2Vw0op0CoZibN3MUr/sQgw
   WYhzujQxcBldujEsQ6h3I8JjVo08h/pNc3NRDU6zdCKtV+sLWWZ8E1KcV
   jpdpOdrVOt2qKula6NAKTblQcgEwbsF1aQkj2xFqkfgp9JGDcmcISIdks
   zHygCImt9Tug8uOhi9j7QVsUb68eZH1DiJGJZmySxON0CsR9QZDExb3hs
   lmtsiZkyzl5k7QYuXdE+G9jSIE+441lqjYi2hRvHmS4Xu2iCzKPxXFXpy
   mGXtNlHaV3LuOyx4lT+OWKjimBoxCn7/1FhlXMh55XsbhIz1xhK3wVF01
   Q==;
X-CSE-ConnectionGUID: WwqSQ1pOTSy1+0zkzWpLoA==
X-CSE-MsgGUID: WOsfPQ5LR3u26vWLyNJK/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="72811144"
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="72811144"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 08:39:57 -0800
X-CSE-ConnectionGUID: sR530GWCQTuEA6Aub0X1og==
X-CSE-MsgGUID: 0ki8MnLiQSKYmtevaJ4h4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="202096370"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.109.145]) ([10.125.109.145])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 08:39:57 -0800
Message-ID: <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com>
Date: Wed, 7 Jan 2026 08:39:55 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 kas@kernel.org, tabba@google.com, ackerleytng@google.com,
 michael.roth@amd.com, david@kernel.org, vannapurve@google.com,
 sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com,
 nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com,
 jun.miao@intel.com, francescolavra.fl@gmail.com, jgross@suse.com,
 ira.weiny@intel.com, isaku.yamahata@intel.com, xiaoyao.li@intel.com,
 kai.huang@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com,
 chao.gao@intel.com
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101826.24870-1-yan.y.zhao@intel.com>
 <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com>
 <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzUVEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gKEludGVsIFdvcmsgQWRkcmVzcykgPGRhdmUuaGFuc2VuQGludGVs
 LmNvbT7CwXgEEwECACIFAlQ+9J0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGg1
 lTBwyZKwLZUP/0dnbhDc229u2u6WtK1s1cSd9WsflGXGagkR6liJ4um3XCfYWDHvIdkHYC1t
 MNcVHFBwmQkawxsYvgO8kXT3SaFZe4ISfB4K4CL2qp4JO+nJdlFUbZI7cz/Td9z8nHjMcWYF
 IQuTsWOLs/LBMTs+ANumibtw6UkiGVD3dfHJAOPNApjVr+M0P/lVmTeP8w0uVcd2syiaU5jB
 aht9CYATn+ytFGWZnBEEQFnqcibIaOrmoBLu2b3fKJEd8Jp7NHDSIdrvrMjYynmc6sZKUqH2
 I1qOevaa8jUg7wlLJAWGfIqnu85kkqrVOkbNbk4TPub7VOqA6qG5GCNEIv6ZY7HLYd/vAkVY
 E8Plzq/NwLAuOWxvGrOl7OPuwVeR4hBDfcrNb990MFPpjGgACzAZyjdmYoMu8j3/MAEW4P0z
 F5+EYJAOZ+z212y1pchNNauehORXgjrNKsZwxwKpPY9qb84E3O9KYpwfATsqOoQ6tTgr+1BR
 CCwP712H+E9U5HJ0iibN/CDZFVPL1bRerHziuwuQuvE0qWg0+0SChFe9oq0KAwEkVs6ZDMB2
 P16MieEEQ6StQRlvy2YBv80L1TMl3T90Bo1UUn6ARXEpcbFE0/aORH/jEXcRteb+vuik5UGY
 5TsyLYdPur3TXm7XDBdmmyQVJjnJKYK9AQxj95KlXLVO38lczsFNBFRjzmoBEACyAxbvUEhd
 GDGNg0JhDdezyTdN8C9BFsdxyTLnSH31NRiyp1QtuxvcqGZjb2trDVuCbIzRrgMZLVgo3upr
 MIOx1CXEgmn23Zhh0EpdVHM8IKx9Z7V0r+rrpRWFE8/wQZngKYVi49PGoZj50ZEifEJ5qn/H
 Nsp2+Y+bTUjDdgWMATg9DiFMyv8fvoqgNsNyrrZTnSgoLzdxr89FGHZCoSoAK8gfgFHuO54B
 lI8QOfPDG9WDPJ66HCodjTlBEr/Cwq6GruxS5i2Y33YVqxvFvDa1tUtl+iJ2SWKS9kCai2DR
 3BwVONJEYSDQaven/EHMlY1q8Vln3lGPsS11vSUK3QcNJjmrgYxH5KsVsf6PNRj9mp8Z1kIG
 qjRx08+nnyStWC0gZH6NrYyS9rpqH3j+hA2WcI7De51L4Rv9pFwzp161mvtc6eC/GxaiUGuH
 BNAVP0PY0fqvIC68p3rLIAW3f97uv4ce2RSQ7LbsPsimOeCo/5vgS6YQsj83E+AipPr09Caj
 0hloj+hFoqiticNpmsxdWKoOsV0PftcQvBCCYuhKbZV9s5hjt9qn8CE86A5g5KqDf83Fxqm/
 vXKgHNFHE5zgXGZnrmaf6resQzbvJHO0Fb0CcIohzrpPaL3YepcLDoCCgElGMGQjdCcSQ+Ci
 FCRl0Bvyj1YZUql+ZkptgGjikQARAQABwsFfBBgBAgAJBQJUY85qAhsMAAoJEGg1lTBwyZKw
 l4IQAIKHs/9po4spZDFyfDjunimEhVHqlUt7ggR1Hsl/tkvTSze8pI1P6dGp2XW6AnH1iayn
 yRcoyT0ZJ+Zmm4xAH1zqKjWplzqdb/dO28qk0bPso8+1oPO8oDhLm1+tY+cOvufXkBTm+whm
 +AyNTjaCRt6aSMnA/QHVGSJ8grrTJCoACVNhnXg/R0g90g8iV8Q+IBZyDkG0tBThaDdw1B2l
 asInUTeb9EiVfL/Zjdg5VWiF9LL7iS+9hTeVdR09vThQ/DhVbCNxVk+DtyBHsjOKifrVsYep
 WpRGBIAu3bK8eXtyvrw1igWTNs2wazJ71+0z2jMzbclKAyRHKU9JdN6Hkkgr2nPb561yjcB8
 sIq1pFXKyO+nKy6SZYxOvHxCcjk2fkw6UmPU6/j/nQlj2lfOAgNVKuDLothIxzi8pndB8Jju
 KktE5HJqUUMXePkAYIxEQ0mMc8Po7tuXdejgPMwgP7x65xtfEqI0RuzbUioFltsp1jUaRwQZ
 MTsCeQDdjpgHsj+P2ZDeEKCbma4m6Ez/YWs4+zDm1X8uZDkZcfQlD9NldbKDJEXLIjYWo1PH
 hYepSffIWPyvBMBTW2W5FRjJ4vLRrJSUoEfJuPQ3vW9Y73foyo/qFoURHO48AinGPZ7PC7TF
 vUaNOTjKedrqHkaOcqB185ahG2had0xnFsDPlx5y
In-Reply-To: <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/7/26 01:12, Yan Zhao wrote:
...
> However, my understanding is that it's better for functions expecting huge pages
> to explicitly receive "folio" instead of "page". This way, people can tell from
> a function's declaration what the function expects. Is this understanding
> correct?

In a perfect world, maybe.

But, in practice, a 'struct page' can still represent huge pages and
*does* represent huge pages all over the kernel. There's no need to cram
a folio in here just because a huge page is involved.

> Passing "start_idx" along with "folio" is due to the requirement of mapping only
> a sub-range of a huge folio. e.g., we allow creating a 2MB mapping starting from
> the nth idx of a 1GB folio.
> 
> On the other hand, if we instead pass "page" to tdh_mem_page_aug() for huge
> pages and have tdh_mem_page_aug() internally convert it to "folio" and
> "start_idx", it makes me wonder if we could have previously just passed "pfn" to
> tdh_mem_page_aug() and had tdh_mem_page_aug() convert it to "page".

As a general pattern, I discourage folks from using pfns and physical
addresses when passing around references to physical memory. They have
zero type safety.

It's also not just about type safety. A 'struct page' also *means*
something. It means that the kernel is, on some level, aware of and
managing that memory. It's not MMIO. It doesn't represent the physical
address of the APIC page. It's not SGX memory. It doesn't have a
Shared/Private bit.

All of those properties are important and they're *GONE* if you use a
pfn. It's even worse if you use a raw physical address.

Please don't go back to raw integers (pfns or paddrs).

>>> -	tdx_clflush_page(page);
>>> +	if (start_idx + npages > folio_nr_pages(folio))
>>> +		return TDX_OPERAND_INVALID;
>>
>> Why is this necessary? Would it be a bug if this happens?
> This sanity check is due to the requirement in KVM that mapping size should be
> no larger than the backend folio size, which ensures the mapping pages are
> physically contiguous with homogeneous page attributes. (See the discussion
> about "EPT mapping size and folio size" in thread [1]).
> 
> Failure of the sanity check could only be due to bugs in the caller (KVM). I
> didn't convert the sanity check to an assertion because there's already a
> TDX_BUG_ON_2() on error following the invocation of tdh_mem_page_aug() in KVM.

We generally don't protect against bugs in callers. Otherwise, we'd have
a trillion NULL checks in every function in the kernel.

The only reason to add caller sanity checks is to make things easier to
debug, and those almost always include some kind of spew:
WARN_ON_ONCE(), pr_warn(), etc...

>>> +	for (int i = 0; i < npages; i++)
>>> +		tdx_clflush_page(folio_page(folio, start_idx + i));
>>
>> All of the page<->folio conversions are kinda hurting my brain. I think
>> we need to decide what the canonical type for these things is in TDX, do
>> the conversion once, and stick with it.
> Got it!
> 
> Since passing in base "page" or base "pfn" may still require the
> wrappers/helpers to internally convert them to "folio" for sanity checks, could
> we decide that "folio" and "start_idx" are the canonical params for functions
> expecting huge pages? Or do you prefer KVM to do the sanity check by itself?

I'm not convinced the sanity check is a good idea in the first place. It
just adds complexity.

