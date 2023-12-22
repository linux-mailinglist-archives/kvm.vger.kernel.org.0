Return-Path: <kvm+bounces-5130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31AB981C731
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 10:14:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DADAA1F227D7
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 09:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7F3FC1F;
	Fri, 22 Dec 2023 09:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VtPxiPId"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C001FBE8
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 09:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703236439; x=1734772439;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1D7KQ6om+191RblVh2tcDXW6qZjNZ5uTw46ob4sfG+M=;
  b=VtPxiPIdebETJggi3ktORpxmpoRtswyxW9xm+DbpyyDUiFDYY5/N+ez1
   eshHxQh0EzWmwb2WPl6IP3KltPAmM8r7frAqWYYs4a1hyFZ1x5usq0hsY
   w/9SkDP/JnA/NAlGbckcnf7OKoT4NZR1KELw+XQQ7QU5p6FdxaTXgo4lN
   LH4rg3ZonVfIGdC0XHvX97pZmrG1E4g53VO/Cz6mWOS7qpPlagUw3DhYe
   OjEOr6G+u/ZPuuooCGDipOXkwCd20RycIVHnptVGC/PmJpFmh0L02zk01
   KICs3owfgVMapOuIcaJSuTFsCHENQNyixMJlCc8VrdNlK2a4XkgRZdTqD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10931"; a="482276112"
X-IronPort-AV: E=Sophos;i="6.04,296,1695711600"; 
   d="scan'208";a="482276112"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2023 01:13:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,296,1695711600"; 
   d="scan'208";a="18651217"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa002.jf.intel.com with ESMTP; 22 Dec 2023 01:13:55 -0800
Date: Fri, 22 Dec 2023 17:26:40 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xin Li <xin3.li@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	richard.henderson@linaro.org, pbonzini@redhat.com,
	eduardo@habkost.net, seanjc@google.com, chao.gao@intel.com,
	hpa@zytor.com, xiaoyao.li@intel.com, weijiang.yang@intel.com
Subject: Re: [PATCH v3 2/6] target/i386: mark CR4.FRED not reserved
Message-ID: <ZYVWUHt6EAVN9YMp@intel.com>
References: <20231109072012.8078-1-xin3.li@intel.com>
 <20231109072012.8078-3-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109072012.8078-3-xin3.li@intel.com>

On Wed, Nov 08, 2023 at 11:20:08PM -0800, Xin Li wrote:
> Date: Wed,  8 Nov 2023 23:20:08 -0800
> From: Xin Li <xin3.li@intel.com>
> Subject: [PATCH v3 2/6] target/i386: mark CR4.FRED not reserved
> X-Mailer: git-send-email 2.42.0
> 
> The CR4.FRED bit, i.e., CR4[32], is no longer a reserved bit when FRED
> is exposed to guests, otherwise it is still a reserved bit.
> 
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

>  target/i386/cpu.h | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 5faf00551d..e210957cba 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -262,6 +262,12 @@ typedef enum X86Seg {
>  #define CR4_PKE_MASK   (1U << 22)
>  #define CR4_PKS_MASK   (1U << 24)
>  
> +#ifdef TARGET_X86_64
> +#define CR4_FRED_MASK   (1ULL << 32)
> +#else
> +#define CR4_FRED_MASK   0
> +#endif
> +
>  #define CR4_RESERVED_MASK \
>  (~(target_ulong)(CR4_VME_MASK | CR4_PVI_MASK | CR4_TSD_MASK \
>                  | CR4_DE_MASK | CR4_PSE_MASK | CR4_PAE_MASK \
> @@ -269,7 +275,8 @@ typedef enum X86Seg {
>                  | CR4_OSFXSR_MASK | CR4_OSXMMEXCPT_MASK | CR4_UMIP_MASK \
>                  | CR4_LA57_MASK \
>                  | CR4_FSGSBASE_MASK | CR4_PCIDE_MASK | CR4_OSXSAVE_MASK \
> -                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK))
> +                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
> +                | CR4_FRED_MASK))
>  
>  #define DR6_BD          (1 << 13)
>  #define DR6_BS          (1 << 14)
> @@ -2520,6 +2527,9 @@ static inline uint64_t cr4_reserved_bits(CPUX86State *env)
>      if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS)) {
>          reserved_bits |= CR4_PKS_MASK;
>      }
> +    if (!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED)) {
> +        reserved_bits |= CR4_FRED_MASK;
> +    }
>      return reserved_bits;
>  }
>  
> -- 
> 2.42.0
> 
> 

