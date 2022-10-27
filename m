Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BC260F0E9
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 09:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiJ0HIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 03:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbiJ0HII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 03:08:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1388E150FA1;
        Thu, 27 Oct 2022 00:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666854488; x=1698390488;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZEw4AdzoTbupv5CY5sbrw/+AFSIjuYDs6zyBb+6MS8M=;
  b=KJz8Gy8R6UOxHMWOOTbYaL5GbjLiHpBcw+N2mX3ZDZccOIXeQjmkJEKN
   OvGbbSUigMV8C2bAyVSAb5gQSo471LCEuUT7a9dJ3mVmyYBycqu8sJ+qs
   0yoGR7JXKbdYqd+87KXoiwdBByiGlAADgWtnfKmA5l5hZh2akynoCIc6S
   rzQU+JJxMjSwDXC8VDYLz1UgvBLtgCJcpEYYZI9tsxBa8K3EsQD9JONUa
   KlvRiKKLcYRuoGLNDV46ACQswSJY5OFRorLc2zAYpBYt4mTOT/4SJ/rjM
   LLf92rgncPcd8g+KZwd/vqnQapIS1Rjmx3bRlT9nM8PZ0VAL7x18/cYtD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="291450838"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="291450838"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 00:08:07 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737561555"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="737561555"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.55]) ([10.249.175.55])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 00:08:02 -0700
Message-ID: <80e8111b-76a2-4999-782b-fdd4b9f425fa@intel.com>
Date:   Thu, 27 Oct 2022 15:08:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
Subject: Re: [PATCH v6 01/21] x86/tdx: Use enum to define page level of TDX
 supported page sizes
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1666824663.git.kai.huang@intel.com>
 <8a5b40d43f8b993a48b99d6647b16a82b433627c.1666824663.git.kai.huang@intel.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <8a5b40d43f8b993a48b99d6647b16a82b433627c.1666824663.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/2022 7:16 AM, Kai Huang wrote:
> TDX supports 4K, 2M and 1G page sizes.  When TDX guest accepts one page
> via try_accept_one(), it passes the page size level to the TDX module.
> Currently try_accept_one() uses hard-coded magic number for that.
> 
> Introduce a new enum type to represent the page level of TDX supported
> page sizes to replace the hard-coded values.  Both initializing the TDX
> module and KVM TDX support will need to use that too.
> 
> Also, currently try_accept_one() uses an open-coded switch statement to
> get the TDX page level from the kernel page level.  As KVM will also
> need to do the same thing, introduce a common helper to convert the
> kernel page level to the TDX page level.
> 
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/coco/tdx/tdx.c    | 20 ++++----------------
>   arch/x86/include/asm/tdx.h | 33 +++++++++++++++++++++++++++++++++
>   2 files changed, 37 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> index 928dcf7a20d9..c5ff9647213d 100644
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -655,7 +655,6 @@ static bool try_accept_one(phys_addr_t *start, unsigned long len,
>   {
>   	unsigned long accept_size = page_level_size(pg_level);
>   	u64 tdcall_rcx;
> -	u8 page_size;
>   
>   	if (!IS_ALIGNED(*start, accept_size))
>   		return false;
> @@ -663,27 +662,16 @@ static bool try_accept_one(phys_addr_t *start, unsigned long len,
>   	if (len < accept_size)
>   		return false;
>   
> +	/* TDX only supports 4K/2M/1G page sizes */

yes, a page can be mapped as 1G size to TD via secure/shared EPT. But 
for this particular TDX_ACCEPT_PAGE case, it only supports 4K and 2M 
currently, which is defined in TDX module spec.

This also implies one thing can be improved in current kernel that 
trying accepting a page from 1G in tdx_enc_status_changed() can be 
optimized to from 2M. It can be changed to start from 1G when TDX 
supports accepting 1G page directly.

> +	if (pg_level < PG_LEVEL_4K || pg_level > PG_LEVEL_1G)
> +		return false;
>   	/*
>   	 * Pass the page physical address to the TDX module to accept the
>   	 * pending, private page.
>   	 *
>   	 * Bits 2:0 of RCX encode page size: 0 - 4K, 1 - 2M, 2 - 1G.

Maybe the “page size” can be adjusted to “TDX page level” accordingly.

>   	 */
> -	switch (pg_level) {
> -	case PG_LEVEL_4K:
> -		page_size = 0;
> -		break;
> -	case PG_LEVEL_2M:
> -		page_size = 1;
> -		break;
> -	case PG_LEVEL_1G:
> -		page_size = 2;
> -		break;
> -	default:
> -		return false;
> -	}
> -
> -	tdcall_rcx = *start | page_size;
> +	tdcall_rcx = *start | to_tdx_pg_level(pg_level);
>   	if (__tdx_module_call(TDX_ACCEPT_PAGE, tdcall_rcx, 0, 0, 0, NULL))
>   		return false;
>   
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 020c81a7c729..1c166fb9c22f 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -20,6 +20,39 @@
>   
>   #ifndef __ASSEMBLY__
>   
> +#include <asm/pgtable_types.h>
> +
> +/*
> + * The page levels of TDX supported page sizes (4K/2M/1G).
> + *
> + * Those values are part of the TDX module ABI.  Do not change them.
> + */
> +enum tdx_pg_level {
> +	TDX_PG_LEVEL_4K,
> +	TDX_PG_LEVEL_2M,
> +	TDX_PG_LEVEL_1G,
> +	TDX_PG_LEVEL_NUM
> +};
> +
> +/*
> + * Get the TDX page level based on the kernel page level.  The caller
> + * to make sure only pass 4K/2M/1G kernel page level.
> + */
> +static inline enum tdx_pg_level to_tdx_pg_level(enum pg_level pglvl)
> +{
> +	switch (pglvl) {
> +	case PG_LEVEL_4K:
> +		return TDX_PG_LEVEL_4K;
> +	case PG_LEVEL_2M:
> +		return TDX_PG_LEVEL_2M;
> +	case PG_LEVEL_1G:
> +		return TDX_PG_LEVEL_1G;
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +	return TDX_PG_LEVEL_NUM;
> +}
> +
>   /*
>    * Used to gather the output registers values of the TDCALL and SEAMCALL
>    * instructions when requesting services from the TDX module.

