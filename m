Return-Path: <kvm+bounces-61909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09FA4C2DFC6
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 21:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3A49189702A
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 20:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DEB4241CB2;
	Mon,  3 Nov 2025 20:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F1IvAqiz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6673829994B;
	Mon,  3 Nov 2025 20:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762200294; cv=none; b=BwkgpyXpBQ7JTX4Xaz1YMkYSoNdXOvwlxq3SpjhuwtgDyfRMema9EkEiPjkh7sb055eWmZjecAcSZ1+sI8eIxpZqspX+peSqDPjQO9dsKsahNrwh4FtSRgNskFTU1oWKeSxZ848Q/QphNhuuUzByAUZ1dU7LOCcZ4/u5mfNQIsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762200294; c=relaxed/simple;
	bh=zSZ7IBXioErhSo4Nbik2yG9o/pB1tR/0x/oZ8K6xjb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l/Vh4aaRp9u98HWKiyV2s5gg0UTXYUfFJrhoSkJLw7pFYD4i96k2eeLszOdE39raY9/L+4nORrEAzzP1W1UZs6RUbyTUMHs8u/iPzflLn8ynqm7qgYgoo5hqhuKRWUT0J3LsqkUyONoIfir/1DDq/c5aMaP3WYeC6vXOeAV5UWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F1IvAqiz; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762200292; x=1793736292;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zSZ7IBXioErhSo4Nbik2yG9o/pB1tR/0x/oZ8K6xjb4=;
  b=F1IvAqizQIWaEQ7sEr3jwiOgypCZCJjxJnlgR4XPUIFj2dygYzdkyiq/
   7czMxFyZEP0SDasSOG7WfCvHE9vIUcFre+WdBqJvIn5zZqbAA5ZMJFriG
   xCmHV6f7iyZpkwiFxcryEWUXzhJ6S2mh7dKXdi9S7qxuGy0uiUqxTapB8
   3fZ7jy9lq/sENT1T/qJP/WEb8euWzI+yFODmr5fFlIkvOI+E3IzBtRI53
   Vnkm4DyXZDaWH6lfnbh6qtO9oOnfwBQPu/2O9g8opOlvMF8n96RKB23xs
   f2yxUY7ZjdkDoObZspoYkEZCRKK63bagnpFeh/gUZqFWd/wSnFzeUHSMT
   Q==;
X-CSE-ConnectionGUID: 76Ucoo1aSdew8KUbRVRExQ==
X-CSE-MsgGUID: pvJNbLaeRuiffoyiW/JYxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="74964537"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="74964537"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 12:04:51 -0800
X-CSE-ConnectionGUID: AqV9ayP4Qm+aU/pCsOM7vQ==
X-CSE-MsgGUID: T5HbE5iZTNiDps0DWzT1DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="186249300"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.110.129]) ([10.125.110.129])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 12:04:52 -0800
Message-ID: <40dd7445-a94d-4b90-8a8a-56c15386866a@intel.com>
Date: Mon, 3 Nov 2025 12:04:50 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] x86/bhi: Add BHB clearing for CPUs with larger
 branch history
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 David Kaplan <david.kaplan@amd.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
 <20251027-vmscape-bhb-v3-1-5793c2534e93@linux.intel.com>
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
In-Reply-To: <20251027-vmscape-bhb-v3-1-5793c2534e93@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/27/25 16:43, Pawan Gupta wrote:
> Add a version of clear_bhb_loop() that works on CPUs with larger branch
> history table such as Alder Lake and newer. This could serve as a cheaper
> alternative to IBPB mitigation for VMSCAPE.

This is missing a bit of background about clear_bhb_loop(). What does it
mitigate? This is also a better place to talk about why this loop exists
if it doesn't work on newer CPUs.

In other words, please mention BHI_DIS_S here.

> clear_bhb_loop() and the new clear_bhb_long_loop() only differ in the loop
> counter. Convert the asm implementation of clear_bhb_loop() into a macro
> that is used by both the variants, passing counter as an argument.

I find these a lot easier to review if you separate out the refactoring
from the new work. I know it's not a lot of code, but refactor first,
then add he new function in a separate patch.

> +/*
> + * A longer version of clear_bhb_loop to ensure that the BHB is cleared on CPUs

"clear_bhb_loop()", please.

> + * with larger branch history tables (i.e. Alder Lake and newer). BHI_DIS_S
> + * protects the kernel, but to mitigate the guest influence on the host
> + * userspace either IBPB or this sequence should be used. See VMSCAPE bug.
> + */
> +SYM_FUNC_START(clear_bhb_long_loop)
> +	__CLEAR_BHB_LOOP 12, 7
> +SYM_FUNC_END(clear_bhb_long_loop)
> +EXPORT_SYMBOL_GPL(clear_bhb_long_loop)
> +STACK_FRAME_NON_STANDARD(clear_bhb_long_loop)

All the pieces are out there, but I feel like we need this in one place,
somewhere:

BHI_DIS_S:  Mitigates user=>kernel attacks on new CPUs. Faster than the
            long loop.
Long Loop:  Mitigates guest=>host userspace attacks on new CPUs. Would
	    also work for user=>kernel, but BHI_DIS_S is faster.
Short Loop: The only choice on older CPUs. Used for both user=>kernel
	    and guest=>host userspace mitigation.



