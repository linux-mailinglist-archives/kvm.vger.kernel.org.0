Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF396A4D0C
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjB0VUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjB0VUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:20:21 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B027B77E;
        Mon, 27 Feb 2023 13:20:19 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so11517714pjb.1;
        Mon, 27 Feb 2023 13:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mzVXQggtOobfBwCbKENEFcfZTb45xXxRQbGAXng82eE=;
        b=S6K+0fH0JV3Ogc3poqLVldxlaohsch5Fa86VWJBFqBOH1aSFKzml7V+6hFCsQTqw48
         ok6jiOtJklAATvdvNQoraD5/FbL3Dsn2b4egXSosqnr26iNl7p4NqNWEKzOHcWhjyyUU
         1cpzO89bKnCmNu/R/Rda0+4nA0aef39RdeTlBktM5U38ooogN132T+bZ/fKA2ltGOTwe
         +7YjpN9iKjBcxWmSA2pP+WPC833D9TnnK+TGkbQYQ3jSYwHw2HxP3cvFTGnmuuPHdU8T
         D1O9O7D8GGoUCACaFLr4ZJnNdhz90kFVvqGbIGve3EaIoGvU+MvAOVRTv93TaZW0r8l6
         IthA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzVXQggtOobfBwCbKENEFcfZTb45xXxRQbGAXng82eE=;
        b=WKAtOvbiabWrvQDrn9/FXx7vJ/2g14eHRmduajEihI8BdVEVTCvQb0Uq2UwNEN5Ytd
         lwqEqt6qHZ99KHquRaQDGFnJhNhuwUv1+3rMoB9aW9UK/qbTQhpqFmwPyEVW1fG7Gm9A
         HXEsTi0n/l9fdlqzFy1lclgkO/klMWd50z7wccUDQdS/QlDkZNZ7EbB45a7Sk9Vqo2pL
         4lYZZQZVDXQWfI00zVHhtFF3iQzvaPt5HO3nyqmuSvy9EXn98Nquuxfja2WZ0FddnDkF
         0SAlMNXbte7iqGWSn7EAYRTkX7g2NVjGhUE8Y2fC24wmBeUmNysR/mjRLhhteHieELPj
         EKPw==
X-Gm-Message-State: AO0yUKUXXqZGIKLXQaL1EOVfw1RCSSX6nIYpu5aiY/J5fgptJ+4K8q9h
        NdJzfgaCm29GZmAxBhduHNf58MS2GHg=
X-Google-Smtp-Source: AK7set8RgpRUvVFn7ZYltwP/WygS5hJFl5EF+79HG7HJVMgMmXACH5zdi2H/TKntwtoMyZv0Z2sbHw==
X-Received: by 2002:a17:902:e812:b0:19a:70f9:affb with SMTP id u18-20020a170902e81200b0019a70f9affbmr488068plg.2.1677532818682;
        Mon, 27 Feb 2023 13:20:18 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id t8-20020a1709027fc800b0019ca68ef7c3sm5024552plb.74.2023.02.27.13.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:20:17 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:20:16 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 014/113] x86/virt/tdx: Add a helper function to
 return system wide info about TDX module
Message-ID: <20230227212016.GD4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <3c7b93a184e36729aeaad2df2b5f450fb564ee92.1673539699.git.isaku.yamahata@intel.com>
 <4db01adf3023ae14084495d15949a70b39d80e58.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4db01adf3023ae14084495d15949a70b39d80e58.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 04:19:47AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-01-12 at 08:31 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX KVM needs system-wide information about the TDX module, struct
> > tdsysinfo_struct.  Add a helper function tdx_get_sysinfo() to return it
> > instead of KVM getting it with various error checks.  Make KVM call the
> > function and stash the info.  Move out the struct definition about it to
> > common place arch/x86/include/asm/tdx.h.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/tdx.h  | 54 +++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/tdx.c      | 49 ++++++++++++++++++++++++++++++++-
> >  arch/x86/virt/vmx/tdx/tdx.c | 21 ++++++++++++---
> >  arch/x86/virt/vmx/tdx/tdx.h | 51 -----------------------------------
> >  4 files changed, 119 insertions(+), 56 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index ed9cf61ff8b4..2ca6e8ce1e43 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -105,6 +105,58 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
> >  #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
> >  
> >  #ifdef CONFIG_INTEL_TDX_HOST
> > +struct tdx_cpuid_config {
> > +	u32	leaf;
> > +	u32	sub_leaf;
> > +	u32	eax;
> > +	u32	ebx;
> > +	u32	ecx;
> > +	u32	edx;
> > +} __packed;
> > +
> > +#define TDSYSINFO_STRUCT_SIZE		1024
> > +#define TDSYSINFO_STRUCT_ALIGNMENT	1024
> > +
> > +/*
> > + * The size of this structure itself is flexible.  The actual structure
> > + * passed to TDH.SYS.INFO must be padded to TDSYSINFO_STRUCT_SIZE and be
> > + * aligned to TDSYSINFO_STRUCT_ALIGNMENT using DECLARE_PADDED_STRUCT().
> > + */
> > +struct tdsysinfo_struct {
> > +	/* TDX-SEAM Module Info */
> > +	u32	attributes;
> > +	u32	vendor_id;
> > +	u32	build_date;
> > +	u16	build_num;
> > +	u16	minor_version;
> > +	u16	major_version;
> > +	u8	reserved0[14];
> > +	/* Memory Info */
> > +	u16	max_tdmrs;
> > +	u16	max_reserved_per_tdmr;
> > +	u16	pamt_entry_size;
> > +	u8	reserved1[10];
> > +	/* Control Struct Info */
> > +	u16	tdcs_base_size;
> > +	u8	reserved2[2];
> > +	u16	tdvps_base_size;
> > +	u8	tdvps_xfam_dependent_size;
> > +	u8	reserved3[9];
> > +	/* TD Capabilities */
> > +	u64	attributes_fixed0;
> > +	u64	attributes_fixed1;
> > +	u64	xfam_fixed0;
> > +	u64	xfam_fixed1;
> > +	u8	reserved4[32];
> > +	u32	num_cpuid_config;
> > +	/*
> > +	 * The actual number of CPUID_CONFIG depends on above
> > +	 * 'num_cpuid_config'.
> > +	 */
> > +	DECLARE_FLEX_ARRAY(struct tdx_cpuid_config, cpuid_configs);
> > +} __packed;
> > +
> > +const struct tdsysinfo_struct *tdx_get_sysinfo(void);
> >  bool platform_tdx_enabled(void);
> >  int tdx_enable(void);
> >  /*
> > @@ -120,6 +172,8 @@ void tdx_keyid_free(int keyid);
> >  u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> >  	       struct tdx_module_output *out);
> >  #else	/* !CONFIG_INTEL_TDX_HOST */
> > +struct tdsysinfo_struct;
> > +static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
> >  static inline bool platform_tdx_enabled(void) { return false; }
> >  static inline int tdx_enable(void)  { return -EINVAL; }
> >  static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 6c7d9ec53046..2adf5551ab26 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -11,9 +11,34 @@
> >  #undef pr_fmt
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >  
> > +#define TDX_MAX_NR_CPUID_CONFIGS					\
> > +	((TDSYSINFO_STRUCT_SIZE -					\
> > +		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
> > +		/ sizeof(struct tdx_cpuid_config))
> > +
> > +struct tdx_capabilities {
> > +	u8 tdcs_nr_pages;
> > +	u8 tdvpx_nr_pages;
> > +
> > +	u64 attrs_fixed0;
> > +	u64 attrs_fixed1;
> > +	u64 xfam_fixed0;
> > +	u64 xfam_fixed1;
> > +
> > +	u32 nr_cpuid_configs;
> > +	struct tdx_cpuid_config cpuid_configs[TDX_MAX_NR_CPUID_CONFIGS];
> > +};
> > +
> > +/* Capabilities of KVM + the TDX module. */
> > +static struct tdx_capabilities tdx_caps;
> > +
> >  static int __init tdx_module_setup(void)
> >  {
> > -	int ret;
> > +	const struct tdsysinfo_struct *tdsysinfo;
> > +	int ret = 0;
> > +
> > +	BUILD_BUG_ON(sizeof(*tdsysinfo) > TDSYSINFO_STRUCT_SIZE);
> > +	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
> >  
> >  	ret = tdx_enable();
> >  	if (ret) {
> > @@ -21,6 +46,28 @@ static int __init tdx_module_setup(void)
> >  		return ret;
> >  	}
> >  
> > +	tdsysinfo = tdx_get_sysinfo();
> > +	if (tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS)
> > +		return -EIO;
> 
> This check basically means TDX module is buggy (or kernel has bug).  Do we
> really need this check?  Is TDX module that buggy?
> 
> IMHO you don't need this one, or use WARN() if you want to catch kernel bug?

Ok, I made it WARN_ON().

> > +
> > +	tdx_caps = (struct tdx_capabilities) {
> > +		.tdcs_nr_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE,
> > +		/*
> > +		 * TDVPS = TDVPR(4K page) + TDVPX(multiple 4K pages).
> > +		 * -1 for TDVPR.
> > +		 */
> > +		.tdvpx_nr_pages = tdsysinfo->tdvps_base_size / PAGE_SIZE - 1,
> > +		.attrs_fixed0 = tdsysinfo->attributes_fixed0,
> > +		.attrs_fixed1 = tdsysinfo->attributes_fixed1,
> > +		.xfam_fixed0 =	tdsysinfo->xfam_fixed0,
> > +		.xfam_fixed1 = tdsysinfo->xfam_fixed1,
> > +		.nr_cpuid_configs = tdsysinfo->num_cpuid_config,
> > +	};
> > +	if (!memcpy(tdx_caps.cpuid_configs, tdsysinfo->cpuid_configs,
> > +			tdsysinfo->num_cpuid_config *
> > +			sizeof(struct tdx_cpuid_config)))
> > +		return -EIO;
> 
> Why introducing 'struct tdx_capabilities' and above code here in this patch?
> 
> It's entirely not clear why the new structure is needed -- nothing mentioned in
> changelog, nor there's any comment.  Please explain in the changelog or move
> this chunk to where it is needed.
> 
> Technical side, is 'struct tdx_capabilities' really needed? Or is it just for
> convenience?

I made use of tdsysinfo where possible.
Because it's convenient to cache the number of tdcs_pages and tdvps_pages, it
renamed tdx_capabilities into tdx_info to keep those two. and Move it to the
patch that uses the value.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
