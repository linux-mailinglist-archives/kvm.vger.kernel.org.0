Return-Path: <kvm+bounces-67181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A284CFB09F
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 22:08:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4936F303869F
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 21:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B54F62F25E4;
	Tue,  6 Jan 2026 21:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UzOuatOC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F442BCF68;
	Tue,  6 Jan 2026 21:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767733683; cv=none; b=BLbsDVPut+dGPzAUVfgVa87ZwGrhpt5cFAz/qP62ilbS+yPyXC8U4CXITV/9ypzhV/iyTDUR+xQZpk+IHU1ecWtTdDw7TSBXIAgmSpstNqYS3MWLcqKfmlH81dcBeE8bEp1D23QKtPxY8f3R9OeQ7fgLofcgfkSXrHjvGI0zmrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767733683; c=relaxed/simple;
	bh=s1o+eQ+FFWh+r40yE/x5M9lt7UYItsaoICnPo6wuWno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ffWwDO+UJrJ3j4fV+UCJkkZzAhplOUECf3bEEj8g+JNnOSeCYnqLjhsoPC8VHvNR/7st824qE1I1CQL7E9sDYtTwLA9Cy/hDWsnfOARxbyF22UUlQMX33Gj+rdeuPzQZ4QQnpRuCplYe9e+d5PcAZnX7ufuDU6fT3d+D0EFLnQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UzOuatOC; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767733682; x=1799269682;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s1o+eQ+FFWh+r40yE/x5M9lt7UYItsaoICnPo6wuWno=;
  b=UzOuatOC83URpmOLHHxkKERQ/keE1ebpJjXtJqZ9WXI6FF3z1o/Abqms
   GLaTeHuErLlSY1gjKm7EVS1ie/C2uV8qwQnXQMR0CCaGXihE5s9hlvVy5
   V1fEVwIkZBQusXyBGAF76fTxs9uKuaY0bsYS9FBxAEVckxca4a6iLoE0V
   rvqHw5htlRCez1Hqt+kQIobLjJhlTVaKpGxNPoOikHJ6DjE4cEM+pXY/0
   WndGmiwfjZP1YpdAkfnFVQ0BNCrYJUDs1PndqIAismVVTpRtKng8C03iG
   v+cyEJVIt3aXEFUbcWKopzDPsQf/wsY2jH2ZY6i9oB80y+LfOHs4HFmjt
   g==;
X-CSE-ConnectionGUID: gYVxCM5FTSmomkIvHTnTwA==
X-CSE-MsgGUID: F5L1qljrS+yp8Aqjp6e5sA==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="80555520"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="80555520"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 13:08:01 -0800
X-CSE-ConnectionGUID: oG0dtpXcSnCNzDRCcRXRXw==
X-CSE-MsgGUID: 8iMOsDQJTU2eRiToMQXw8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="233889165"
Received: from unknown (HELO [10.24.81.162]) ([10.24.81.162])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 13:08:00 -0800
Message-ID: <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com>
Date: Tue, 6 Jan 2026 13:08:00 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
To: Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, seanjc@google.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 rick.p.edgecombe@intel.com, kas@kernel.org, tabba@google.com,
 ackerleytng@google.com, michael.roth@amd.com, david@kernel.org,
 vannapurve@google.com, sagis@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, nik.borisov@suse.com, pgonda@google.com,
 fan.du@intel.com, jun.miao@intel.com, francescolavra.fl@gmail.com,
 jgross@suse.com, ira.weiny@intel.com, isaku.yamahata@intel.com,
 xiaoyao.li@intel.com, kai.huang@intel.com, binbin.wu@linux.intel.com,
 chao.p.peng@intel.com, chao.gao@intel.com
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101826.24870-1-yan.y.zhao@intel.com>
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
In-Reply-To: <20260106101826.24870-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/26 02:18, Yan Zhao wrote:
> Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.
> 
> The SEAMCALL TDH_MEM_PAGE_AUG currently supports adding physical memory to
> the S-EPT up to 2MB in size.
> 
> While keeping the "level" parameter in the tdh_mem_page_aug() wrapper to
> allow callers to specify the physical memory size, introduce the parameters
> "folio" and "start_idx" to specify the physical memory starting from the
> page at "start_idx" within the "folio". The specified physical memory must
> be fully contained within a single folio.
> 
> Invoke tdx_clflush_page() for each 4KB segment of the physical memory being
> added. tdx_clflush_page() performs CLFLUSH operations conservatively to
> prevent dirty cache lines from writing back later and corrupting TD memory.

This changelog is heavy on the "what" and weak on the "why". It's not
telling me what I need to know.

...
> +	struct folio *folio = page_folio(page);
>  	gpa_t gpa = gfn_to_gpa(gfn);
>  	u64 entry, level_state;
>  	u64 err;
>  
> -	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
> -
> +	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, folio,
> +			       folio_page_idx(folio, page), &entry, &level_state);
>  	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
>  		return -EBUSY;

For example, 'folio' is able to be trivially derived from page. Yet,
this removes the 'page' argument and replaces it with 'folio' _and_
another value which can be derived from 'page'.

This looks superficially like an illogical change. *Why* was this done?

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index b0b33f606c11..41ce18619ffc 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1743,16 +1743,23 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
>  }
>  EXPORT_SYMBOL_GPL(tdh_vp_addcx);
>  
> -u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
> +u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct folio *folio,
> +		     unsigned long start_idx, u64 *ext_err1, u64 *ext_err2)
>  {
>  	struct tdx_module_args args = {
>  		.rcx = gpa | level,
>  		.rdx = tdx_tdr_pa(td),
> -		.r8 = page_to_phys(page),
> +		.r8 = page_to_phys(folio_page(folio, start_idx)),
>  	};
> +	unsigned long npages = 1 << (level * PTE_SHIFT);
>  	u64 ret;

This 'npages' calculation is not obviously correct. It's not clear what
"level" is or what values it should have.

This is precisely the kind of place to deploy a helper that explains
what is going on.

> -	tdx_clflush_page(page);
> +	if (start_idx + npages > folio_nr_pages(folio))
> +		return TDX_OPERAND_INVALID;

Why is this necessary? Would it be a bug if this happens?

> +	for (int i = 0; i < npages; i++)
> +		tdx_clflush_page(folio_page(folio, start_idx + i));

All of the page<->folio conversions are kinda hurting my brain. I think
we need to decide what the canonical type for these things is in TDX, do
the conversion once, and stick with it.


