Return-Path: <kvm+bounces-48781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D891DAD2DB1
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 08:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FA20170512
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A262C25F97D;
	Tue, 10 Jun 2025 06:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BFeoQojw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2533525F961;
	Tue, 10 Jun 2025 06:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749535482; cv=none; b=lloAPzppqKP7QvxN1H2vLri5nrs0N70WFIMaW25D13o8awHGISc7XIvXnk9veof+xMH8PwJHVL+KzWYfw1RFIea944mU20JnvapLqN3JnruTmlRwH9655UwIlrjtZNKeFdTr+V9IUiMXfkC3WwBfcyWlV1ppN/2Cd+vvNuCozUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749535482; c=relaxed/simple;
	bh=36UM9scINuSxOcq71r1D+EjNcNuwMHJaxBerjlV5uvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rtAHOYqZB+C6EGpPNZub6JUv9ygz/TmZg2wRi2Tzq9UjZXAGHawq9XYGNCIndnyWU05kRfmmZJr2XWtaxUigKyGlYnn4+cIWMfqEYRR08GywbfbsGJ3a+e2r2rCvHdTOo25zFKEnrNNUri3Bf8hbuwbfJSkz+7BjSgqLMFsaYdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BFeoQojw; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749535481; x=1781071481;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=36UM9scINuSxOcq71r1D+EjNcNuwMHJaxBerjlV5uvw=;
  b=BFeoQojwyUCwSp0XCKDF4ri0qwBPPRyAKfgricKiq35TsAHfLOfdKf7V
   fcrwNnhHkhTE7xt4CbFW/ajRP2oDrH3b5XqeNHvBeoRA8u+hM5BrmfT5A
   PLDI+Qw0bZyuWgy8KlcJiIZ/XkCvzc/ebTgfJaTU4rYBgEWQLsKW/vQjD
   Ju3XwZPFNDhjNkbks1X5ZINPYvmkyNPjEedpSU9L8Hc94FXZjl/NegRfh
   XyUXeeTna7G4OpDJN1vA+xzaMSLtjZ/jdaN5v7CwvkEQGgyMN4VP6JCOd
   Qfo1NhjPoAIzDejhU5ylzznE/rCE4pzdXPlakmxKqpjxt9stz/f04odc8
   g==;
X-CSE-ConnectionGUID: fq9UB+pkQ6uoyqlzSdc2iw==
X-CSE-MsgGUID: GwTM4LnqReSB47b0ADhyrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51769386"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="51769386"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 23:04:40 -0700
X-CSE-ConnectionGUID: rrwtHIuOT5Kh/SrxVy6GTw==
X-CSE-MsgGUID: k7yHa89ORIeV1yvV3umy/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="146651956"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 23:04:39 -0700
Message-ID: <04c70eb3-4323-45b5-9a07-020d627c64a4@linux.intel.com>
Date: Tue, 10 Jun 2025 14:04:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 01/16] lib: Add and use static_assert()
 convenience wrappers
To: Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-2-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529221929.3807680-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/30/2025 6:19 AM, Sean Christopherson wrote:
> Add static_assert() to wrap _Static_assert() with stringification of the
> tested expression as the assert message.  In most cases, the failed
> expression is far more helpful than a human-generated message (usually
> because the developer is forced to add _something_ for the message).
>
> For API consistency, provide a double-underscore variant for specifying a
> custom message.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/riscv/asm/isa.h      | 4 +++-
>  lib/s390x/asm/arch_def.h | 6 ++++--
>  lib/s390x/fault.c        | 3 ++-
>  lib/util.h               | 3 +++
>  x86/lam.c                | 4 ++--
>  5 files changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/lib/riscv/asm/isa.h b/lib/riscv/asm/isa.h
> index df874173..fb3af67d 100644
> --- a/lib/riscv/asm/isa.h
> +++ b/lib/riscv/asm/isa.h
> @@ -1,7 +1,9 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  #ifndef _ASMRISCV_ISA_H_
>  #define _ASMRISCV_ISA_H_
> +
>  #include <bitops.h>
> +#include <util.h>
>  #include <asm/setup.h>
>  
>  /*
> @@ -14,7 +16,7 @@ enum {
>  	ISA_SSTC,
>  	ISA_MAX,
>  };
> -_Static_assert(ISA_MAX <= __riscv_xlen, "Need to increase thread_info.isa");
> +__static_assert(ISA_MAX <= __riscv_xlen, "Need to increase thread_info.isa");
>  
>  static inline bool cpu_has_extension(int cpu, int ext)
>  {
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 03adcd3c..4c11df74 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -8,6 +8,8 @@
>  #ifndef _ASMS390X_ARCH_DEF_H_
>  #define _ASMS390X_ARCH_DEF_H_
>  
> +#include <util.h>
> +
>  struct stack_frame {
>  	struct stack_frame *back_chain;
>  	uint64_t reserved;
> @@ -62,7 +64,7 @@ struct psw {
>  	};
>  	uint64_t	addr;
>  };
> -_Static_assert(sizeof(struct psw) == 16, "PSW size");
> +static_assert(sizeof(struct psw) == 16);
>  
>  #define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
>  
> @@ -194,7 +196,7 @@ struct lowcore {
>  	uint8_t		pad_0x1400[0x1800 - 0x1400];	/* 0x1400 */
>  	uint8_t		pgm_int_tdb[0x1900 - 0x1800];	/* 0x1800 */
>  } __attribute__ ((__packed__));
> -_Static_assert(sizeof(struct lowcore) == 0x1900, "Lowcore size");
> +static_assert(sizeof(struct lowcore) == 0x1900);
>  
>  extern struct lowcore lowcore;
>  
> diff --git a/lib/s390x/fault.c b/lib/s390x/fault.c
> index a882d5d9..ad5a5f66 100644
> --- a/lib/s390x/fault.c
> +++ b/lib/s390x/fault.c
> @@ -9,6 +9,7 @@
>   */
>  #include <libcflat.h>
>  #include <bitops.h>
> +#include <util.h>
>  #include <asm/arch_def.h>
>  #include <asm/page.h>
>  #include <fault.h>
> @@ -40,7 +41,7 @@ static void print_decode_pgm_prot(union teid teid)
>  			"LAP",
>  			"IEP",
>  		};
> -		_Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES, "ESOP2 prot codes");
> +		static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES);
>  		int prot_code = teid_esop2_prot_code(teid);
>  
>  		printf("Type: %s\n", prot_str[prot_code]);
> diff --git a/lib/util.h b/lib/util.h
> index f86af6d3..00d0b47d 100644
> --- a/lib/util.h
> +++ b/lib/util.h
> @@ -8,6 +8,9 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  
> +#define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
> +#define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
> +
>  /*
>   * parse_keyval extracts the integer from a string formatted as
>   * string=integer. This is useful for passing expected values to
> diff --git a/x86/lam.c b/x86/lam.c
> index a1c98949..ad91deaf 100644
> --- a/x86/lam.c
> +++ b/x86/lam.c
> @@ -13,6 +13,7 @@
>  #include "libcflat.h"
>  #include "processor.h"
>  #include "desc.h"
> +#include <util.h>
>  #include "vmalloc.h"
>  #include "alloc_page.h"
>  #include "vm.h"
> @@ -236,8 +237,7 @@ static void test_lam_user(void)
>  	 * address for both LAM48 and LAM57.
>  	 */
>  	vaddr = alloc_pages_flags(0, AREA_NORMAL);
> -	_Static_assert((AREA_NORMAL_PFN & GENMASK(63, 47)) == 0UL,
> -			"Identical mapping range check");
> +	static_assert((AREA_NORMAL_PFN & GENMASK(63, 47)) == 0UL);
>  
>  	/*
>  	 * Note, LAM doesn't have a global control bit to turn on/off LAM

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



