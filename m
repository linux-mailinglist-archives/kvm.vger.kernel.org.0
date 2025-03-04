Return-Path: <kvm+bounces-40090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F01E8A4F0C0
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 23:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 675207A5D9A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 22:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A4226A0ED;
	Tue,  4 Mar 2025 22:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AYlmf9NZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C71C204F61;
	Tue,  4 Mar 2025 22:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741128634; cv=none; b=LAgiLp7j8qmaR7/ytbFjLXvZYu8SYQdCxzJgfIik3smUpR2AwSs+C5K63WOFl5Zx+p9ccRfGUiwAmmjaGrNh5vE2iPLBTfLz6CYPJuODgPv3iL2rMZY+fYGv0iRVV64cJaOzKhWRUAo4t5MGFNw4CXPg8Jp+91eXkwKQ4WVP8aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741128634; c=relaxed/simple;
	bh=JpXLnfHFb7X6UP0T5PPovzxp39AnpKclEfcPTpKIoM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fo/rNKAyLQVqiintX6uXQp+hjyYzHGawrkYn4tY4X/AyZ/sjug2eZ+0KSmX2VdXTsN8Sj8VdZq/uGHlHTxXGOjhYHvAygmy0CXSNvxVk0EaPYggQyAOLGDGMbPpJ3vWXt4qua73LQNuBw3NYly6BGN1gCQDVvzm41o2egUKhQ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AYlmf9NZ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741128632; x=1772664632;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JpXLnfHFb7X6UP0T5PPovzxp39AnpKclEfcPTpKIoM0=;
  b=AYlmf9NZvtYzAq2mS4AZiXQvk3JLl51uRHEKQ3m4mj+dktqY+qpF+6N2
   SkTyGkE0UUBIC63A4cMoGZREjjkA2OPGcNkQRf/OW+RmttF8r1Xsv5SDL
   TsGd3sQ987zXjxe1NXtDUM71fAOR9v7SqYLqxKv5E1xunJYpKOPchq+fV
   G0+mEwb2QdHgLkvlJr6/36shlZoDf6ORSNmW857arNQRx+s9bOf1V2VT0
   vh/no3Iu+A/c+gWlkKr3JMzKeSeFHuI7RAZ8pQ+nC+xtYv+V4mZzm5nD/
   0dt86LeV1bLuZYIRJh27S9iDK8OW7y2xz2DaDX2nV1+aFjiDFRyeBCWWF
   g==;
X-CSE-ConnectionGUID: gn+q8SB5Rgm7rzQ5JnD+cg==
X-CSE-MsgGUID: 5RcmavH9QtGiwFL9AHKuKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42202307"
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="42202307"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 14:50:31 -0800
X-CSE-ConnectionGUID: gbqYRql8TV+FDo28CzqB6A==
X-CSE-MsgGUID: VOax7jffTVO2U8+anUc4sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118413778"
Received: from kinlongk-mobl1.amr.corp.intel.com (HELO [10.125.109.165]) ([10.125.109.165])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 14:50:30 -0800
Message-ID: <ea73a36a-8ac5-462b-a97e-c398f6307f2f@intel.com>
Date: Tue, 4 Mar 2025 14:50:48 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] x86/fpu/xstate: Introduce fpu_guest_cfg for guest
 FPU configuration
To: Chao Gao <chao.gao@intel.com>, tglx@linutronix.de, x86@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: peterz@infradead.org, rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
 weijiang.yang@intel.com, john.allen@amd.com
References: <20241126101710.62492-1-chao.gao@intel.com>
 <20241126101710.62492-5-chao.gao@intel.com>
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
In-Reply-To: <20241126101710.62492-5-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/24 02:17, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Define new fpu_guest_cfg to hold all guest FPU settings so that it can
> differ from generic kernel FPU settings, e.g., enabling CET supervisor
> xstate by default for guest fpstate while it's remained disabled in
> kernel FPU config.
> 
> The kernel dynamic xfeatures are specifically used by guest fpstate now,
> add the mask for guest fpstate so that guest_perm.__state_perm ==
> (fpu_kernel_cfg.default_xfeature | XFEATURE_MASK_KERNEL_DYNAMIC). And
> if guest fpstate is re-allocated to hold user dynamic xfeatures, the
> resulting permissions are consumed before calculate new guest fpstate.

This kinda restates what the code does, but I don't think it matches the
code.

> With new guest FPU config added, there're 3 categories of FPU configs in
> kernel, the usages and key fields are recapped as below.

This changelog is pretty rough. It's got a lot of words but not much
substance.


> kernel FPU config:
>   @fpu_kernel_cfg.max_features
>   - all known and CPU supported user and supervisor features except
>     independent kernel features
> 
>   @fpu_kernel_cfg.default_features
>   - all known and CPU supported user and supervisor features except
>     dynamic kernel features, independent kernel features and dynamic
>     userspace features.
> 
>   @fpu_kernel_cfg.max_size
>   - size of compacted buffer with 'fpu_kernel_cfg.max_features'
> 
>   @fpu_kernel_cfg.default_size
>   - size of compacted buffer with 'fpu_kernel_cfg.default_features'
> 
> user FPU config:
>   @fpu_user_cfg.max_features
>   - all known and CPU supported user features
> 
>   @fpu_user_cfg.default_features
>   - all known and CPU supported user features except dynamic userspace
>     features.
> 
>   @fpu_user_cfg.max_size
>   - size of non-compacted buffer with 'fpu_user_cfg.max_features'
> 
>   @fpu_user_cfg.default_size
>   - size of non-compacted buffer with 'fpu_user_cfg.default_features'
> 
> guest FPU config:
>   @fpu_guest_cfg.max_features
>   - all known and CPU supported user and supervisor features except
>     independent kernel features.
> 
>   @fpu_guest_cfg.default_features
>   - all known and CPU supported user and supervisor features except
>     independent kernel features and dynamic userspace features.
> 
>   @fpu_guest_cfg.max_size
>   - size of compacted buffer with 'fpu_guest_cfg.max_features'
> 
>   @fpu_guest_cfg.default_size
>   - size of compacted buffer with 'fpu_guest_cfg.default_features'

This looks like kerneldoc, not changelog. Are you sure you want it _here_?


> diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
> index b49e65120d34..da6583a1c0a2 100644
> --- a/arch/x86/include/asm/fpu/types.h
> +++ b/arch/x86/include/asm/fpu/types.h
> @@ -611,6 +611,6 @@ struct fpu_state_config {
>  };
>  
>  /* FPU state configuration information */
> -extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
> +extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg, fpu_guest_cfg;
>  
>  #endif /* _ASM_X86_FPU_TYPES_H */
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 1209c7aebb21..9e2e5c46cf28 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -33,9 +33,10 @@ DEFINE_STATIC_KEY_FALSE(__fpu_state_size_dynamic);
>  DEFINE_PER_CPU(u64, xfd_state);
>  #endif
>  
> -/* The FPU state configuration data for kernel and user space */
> +/* The FPU state configuration data for kernel, user space and guest. */
>  struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
>  struct fpu_state_config fpu_user_cfg __ro_after_init;
> +struct fpu_state_config fpu_guest_cfg __ro_after_init;
>  
>  /*
>   * Represents the initial FPU state. It's mostly (but not completely) zeroes,
> @@ -536,8 +537,15 @@ void fpstate_reset(struct fpu *fpu)
>  	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
>  	fpu->perm.__state_size		= fpu_kernel_cfg.default_size;
>  	fpu->perm.__user_state_size	= fpu_user_cfg.default_size;
> -	/* Same defaults for guests */
> -	fpu->guest_perm = fpu->perm;
> +
> +	/* Guest permission settings */
> +	fpu->guest_perm.__state_perm	= fpu_guest_cfg.default_features;
> +	fpu->guest_perm.__state_size	= fpu_guest_cfg.default_size;
> +	/*
> +	 * Set guest's __user_state_size to fpu_user_cfg.default_size so that
> +	 * existing uAPIs can still work.
> +	 */
> +	fpu->guest_perm.__user_state_size = fpu_user_cfg.default_size;
>  }
>  
>  static inline void fpu_inherit_perms(struct fpu *dst_fpu)
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index c38e477e3e45..17c3255dfa41 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -686,6 +686,7 @@ static int __init init_xstate_size(void)
>  {
>  	/* Recompute the context size for enabled features: */
>  	unsigned int user_size, kernel_size, kernel_default_size;
> +	unsigned int guest_default_size;
>  	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
>  
>  	/* Uncompacted user space size */
> @@ -707,13 +708,18 @@ static int __init init_xstate_size(void)
>  	kernel_default_size =
>  		xstate_calculate_size(fpu_kernel_cfg.default_features, compacted);
>  
> +	guest_default_size =
> +		xstate_calculate_size(fpu_guest_cfg.default_features, compacted);
> +
>  	if (!paranoid_xstate_size_valid(kernel_size))
>  		return -EINVAL;
>  
>  	fpu_kernel_cfg.max_size = kernel_size;
>  	fpu_user_cfg.max_size = user_size;
> +	fpu_guest_cfg.max_size = kernel_size;
>  
>  	fpu_kernel_cfg.default_size = kernel_default_size;
> +	fpu_guest_cfg.default_size = guest_default_size;
>  	fpu_user_cfg.default_size =
>  		xstate_calculate_size(fpu_user_cfg.default_features, false);
>  
> @@ -829,6 +835,10 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>  	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
>  	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>  
> +	fpu_guest_cfg.max_features = fpu_kernel_cfg.max_features;
> +	fpu_guest_cfg.default_features = fpu_guest_cfg.max_features;
> +	fpu_guest_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;

I thought this was saying above that it was _setting_ dynamic features.

Why _not_ set them by default?

