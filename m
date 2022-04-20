Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B39050919C
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 22:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382248AbiDTUvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 16:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382229AbiDTUvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 16:51:16 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F076109D;
        Wed, 20 Apr 2022 13:48:29 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x1so3063085pfj.2;
        Wed, 20 Apr 2022 13:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MKwKMF305k1uklJFmuEMqNg2d9qXtFZii4xVA5HUZT4=;
        b=CGNy8tZSDOkOGhImMYorqMkVnTgi2K7e3giswSJWajYiEGN98O5uBByIyfxplMg8Yy
         iokkV8GEArky3vquh0P6zdiFk7Y7r0k9ng+KKRvYabA1IKmUJcSGO17LRTWIadmNAuUt
         w26fIKwDNs10nMioRYJMGMJ9Jx3Ay1Hd9MrkxW8dQBimc/e3jj7I4yovEbJk4/XgSIWx
         CCK+Sag3fSqGzIAZa5l6w5N6SxSdaoLFcHqOUTtScWI3gemljhwE5dqIsdpjhWCU7ZWn
         VRtkZoH2FHFVXTR2okg4oGGsmGP6V5ToqdCGW26rsXnxLnVLtnvhzorVG04LHkWcmJwv
         PGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MKwKMF305k1uklJFmuEMqNg2d9qXtFZii4xVA5HUZT4=;
        b=MIeiEHfTgLnv8MZL9LggUSUH6DY561e6xMm7bjSLeY24/I33YRla0upleBxyIfJ2CW
         mFZ+h0JftNeeNMCvyXSZ7FesF70FeeK4dz2PDhMm8dimfcAdcWkMLFiDmsYBm9f32tiT
         6a2Nnluz88l9IeI39YvHoxGVINWOvPzztQnOuGOyzxKuEsfnvuI2jc3p2UjqMiLY6zDe
         UEP70YDAGV2FvA9rAzaVSb7+8JtT750riPpvma3MpElGriCTiFlcNBKfMb1/F6nGqLg/
         txh+qNFqb1sgKCNYQZePtvcDmqxA45DR4Zj4xe6bUEmHNltrNYeppLReFa16sffHnw5j
         a53A==
X-Gm-Message-State: AOAM531sXSbRXA3uJ3nO0Wxew2WYfJPNNWpNF9MAZuwqk80+9cAt8s5T
        P46ClwnHF3Vc0dA39jxtlT8=
X-Google-Smtp-Source: ABdhPJzqqvd2FuNKMq7tuAvRt+SzJFLR7/ZPuBrlrIT1WQC9u81oxFin6DpOv73t1DBscbZ9de3p/w==
X-Received: by 2002:a63:5223:0:b0:39d:2318:f99d with SMTP id g35-20020a635223000000b0039d2318f99dmr20684191pgb.268.1650487708909;
        Wed, 20 Apr 2022 13:48:28 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id i22-20020a17090a7e1600b001b917d4a1a6sm76195pjl.2.2022.04.20.13.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:48:27 -0700 (PDT)
Date:   Wed, 20 Apr 2022 13:48:26 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v3 10/21] x86/virt/tdx: Add placeholder to coveret all
 system RAM as TDX memory
Message-ID: <20220420204826.GA2789321@ls.amr.corp.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
 <6230ef28be8c360ab326c8f592acf1964ac065c1.1649219184.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6230ef28be8c360ab326c8f592acf1964ac065c1.1649219184.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Subject: Re: [PATCH v3 10/21] x86/virt/tdx: Add placeholder to coveret all system RAM as TDX memory

Nitpick: coveret => convert

Thanks,

On Wed, Apr 06, 2022 at 04:49:22PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> TDX provides increased levels of memory confidentiality and integrity.
> This requires special hardware support for features like memory
> encryption and storage of memory integrity checksums.  Not all memory
> satisfies these requirements.
> 
> As a result, TDX introduced the concept of a "Convertible Memory Region"
> (CMR).  During boot, the firmware builds a list of all of the memory
> ranges which can provide the TDX security guarantees.  The list of these
> ranges, along with TDX module information, is available to the kernel by
> querying the TDX module.
> 
> In order to provide crypto protection to TD guests, the TDX architecture
> also needs additional metadata to record things like which TD guest
> "owns" a given page of memory.  This metadata essentially serves as the
> 'struct page' for the TDX module.  The space for this metadata is not
> reserved by the hardware upfront and must be allocated by the kernel
> and given to the TDX module.
> 
> Since this metadata consumes space, the VMM can choose whether or not to
> allocate it for a given area of convertible memory.  If it chooses not
> to, the memory cannot receive TDX protections and can not be used by TDX
> guests as private memory.
> 
> For every memory region that the VMM wants to use as TDX memory, it sets
> up a "TD Memory Region" (TDMR).  Each TDMR represents a physically
> contiguous convertible range and must also have its own physically
> contiguous metadata table, referred to as a Physical Address Metadata
> Table (PAMT), to track status for each page in the TDMR range.
> 
> Unlike a CMR, each TDMR requires 1G granularity and alignment.  To
> support physical RAM areas that don't meet those strict requirements,
> each TDMR permits a number of internal "reserved areas" which can be
> placed over memory holes.  If PAMT metadata is placed within a TDMR it
> must be covered by one of these reserved areas.
> 
> Let's summarize the concepts:
> 
>  CMR - Firmware-enumerated physical ranges that support TDX.  CMRs are
>        4K aligned.
> TDMR - Physical address range which is chosen by the kernel to support
>        TDX.  1G granularity and alignment required.  Each TDMR has
>        reserved areas where TDX memory holes and overlapping PAMTs can
>        be put into.
> PAMT - Physically contiguous TDX metadata.  One table for each page size
>        per TDMR.  Roughly 1/256th of TDMR in size.  256G TDMR = ~1G
>        PAMT.
> 
> As one step of initializing the TDX module, the memory regions that TDX
> module can use must be configured to the TDX module via an array of
> TDMRs.
> 
> Constructing TDMRs to build the TDX memory consists below steps:
> 
> 1) Create TDMRs to cover all memory regions that TDX module can use;
> 2) Allocate and set up PAMT for each TDMR;
> 3) Set up reserved areas for each TDMR.
> 
> Add a placeholder right after getting TDX module and CMRs information to
> construct TDMRs to do the above steps, as the preparation to configure
> the TDX module.  Always free TDMRs at the end of the initialization (no
> matter successful or not), as TDMRs are only used during the
> initialization.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 47 +++++++++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h | 23 ++++++++++++++++++
>  2 files changed, 70 insertions(+)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 482e6d858181..ec27350d53c1 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -13,6 +13,7 @@
>  #include <linux/cpu.h>
>  #include <linux/smp.h>
>  #include <linux/atomic.h>
> +#include <linux/slab.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/cpufeature.h>
> @@ -594,8 +595,29 @@ static int tdx_get_sysinfo(void)
>  	return sanitize_cmrs(tdx_cmr_array, cmr_num);
>  }
>  
> +static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
> +{
> +	int i;
> +
> +	for (i = 0; i < tdmr_num; i++) {
> +		struct tdmr_info *tdmr = tdmr_array[i];
> +
> +		/* kfree() works with NULL */
> +		kfree(tdmr);
> +		tdmr_array[i] = NULL;
> +	}
> +}
> +
> +static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
> +{
> +	/* Return -EFAULT until constructing TDMRs is done */
> +	return -EFAULT;
> +}
> +
>  static int init_tdx_module(void)
>  {
> +	struct tdmr_info **tdmr_array;
> +	int tdmr_num;
>  	int ret;
>  
>  	/* TDX module global initialization */
> @@ -613,11 +635,36 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out;
>  
> +	/*
> +	 * Prepare enough space to hold pointers of TDMRs (TDMR_INFO).
> +	 * TDX requires TDMR_INFO being 512 aligned.  Each TDMR is
> +	 * allocated individually within construct_tdmrs() to meet
> +	 * this requirement.
> +	 */
> +	tdmr_array = kcalloc(tdx_sysinfo.max_tdmrs, sizeof(struct tdmr_info *),
> +			GFP_KERNEL);
> +	if (!tdmr_array) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* Construct TDMRs to build TDX memory */
> +	ret = construct_tdmrs(tdmr_array, &tdmr_num);
> +	if (ret)
> +		goto out_free_tdmrs;
> +
>  	/*
>  	 * Return -EFAULT until all steps of TDX module
>  	 * initialization are done.
>  	 */
>  	ret = -EFAULT;
> +out_free_tdmrs:
> +	/*
> +	 * TDMRs are only used during initializing TDX module.  Always
> +	 * free them no matter the initialization was successful or not.
> +	 */
> +	free_tdmrs(tdmr_array, tdmr_num);
> +	kfree(tdmr_array);
>  out:
>  	return ret;
>  }
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 2f21c45df6ac..05bf9fe6bd00 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -89,6 +89,29 @@ struct tdsysinfo_struct {
>  	};
>  } __packed __aligned(TDSYSINFO_STRUCT_ALIGNMENT);
>  
> +struct tdmr_reserved_area {
> +	u64 offset;
> +	u64 size;
> +} __packed;
> +
> +#define TDMR_INFO_ALIGNMENT	512
> +
> +struct tdmr_info {
> +	u64 base;
> +	u64 size;
> +	u64 pamt_1g_base;
> +	u64 pamt_1g_size;
> +	u64 pamt_2m_base;
> +	u64 pamt_2m_size;
> +	u64 pamt_4k_base;
> +	u64 pamt_4k_size;
> +	/*
> +	 * Actual number of reserved areas depends on
> +	 * 'struct tdsysinfo_struct'::max_reserved_per_tdmr.
> +	 */
> +	struct tdmr_reserved_area reserved_areas[0];
> +} __packed __aligned(TDMR_INFO_ALIGNMENT);
> +
>  /*
>   * P-SEAMLDR SEAMCALL leaf function
>   */
> -- 
> 2.35.1
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
