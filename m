Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C6628D45
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 00:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbiKNXSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 18:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiKNXSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 18:18:39 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4F9DD8;
        Mon, 14 Nov 2022 15:18:38 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id h14so11733020pjv.4;
        Mon, 14 Nov 2022 15:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8dymv2saYBr2By1+NFXF4EikWqYGNz69/voRvVoo1Zo=;
        b=m5IQS9N8Cp43nCpysBl/EjXXCvod9wuPVQPiVX9SMTscUsws7dDCMtdnCmM+iJJLTK
         X12Xtp7CrZFKcr5r3G8+kKxjoRUdWTFLU7k25x82/B15cSOH8MTgJGss5Uhyz78YHA7z
         O+qsfjmDz+82/tLCX+tElVSxJM33sLfgaiD7LiVvjCQyGqovgo+MEaj0TJP4QsTSXmJq
         ZkC67QCkfVcaBN8+xbGEQ76DgjTDhymbac5N987zhZwHvVAxA1/uMR6rpaJHhcipl3ru
         7GLnzpOoQ4Ub6sortxxblsdPPG/EAH6V9r9RKbFX09wRf0qVmejKmFNyVY5MRNMwREi/
         Vcvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8dymv2saYBr2By1+NFXF4EikWqYGNz69/voRvVoo1Zo=;
        b=Uxze36f//fyiAczqVR22WcFtzlbm7UAPJxs7T6QLX+wm8jlBo/izlLaJQhbBXOfCTN
         QGWc27ePq0aOG+a3vaIK39+xogTwzV8xA90CQEENrysBrKqoiDGEM5+aZNvs1APsO3b5
         2B7JZlj08+qg2XoAfLNotrkLx2cTBr6WxtYluayLaTi7MlMR7n8XaKcX4AmHg1rBE7RD
         44S9nODuqlJkjUSf0J4YdAm+VkhP0hQCGjcmCe+WaueYRDAVBrvkZsQBQQjR3tkcYegb
         gZ5KJgFKK5boOiUz+PyIIfPYJbO21LqOD9yul7wwdXXnoRwbCOEBf/W6NUIP1RGilFrt
         g0FQ==
X-Gm-Message-State: ANoB5pk6Sq5KSAFeXkyvULu004244gPqhArddhb3T8s1zb1NOOtctuvx
        l6rxHgt2XJGLXwifuRlV1sM=
X-Google-Smtp-Source: AA0mqf74LaFMnikeWDT4E+k+vJ9wrTm+aIQasGiaSHczbExGwD8k9YQ7A+JqoTjSZo2+gk9nGTBKlw==
X-Received: by 2002:a17:90b:310f:b0:200:1df3:a7a9 with SMTP id gc15-20020a17090b310f00b002001df3a7a9mr15445387pjb.202.1668467917837;
        Mon, 14 Nov 2022 15:18:37 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id x7-20020a170902a38700b00186b5c1a715sm8125441pla.182.2022.11.14.15.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 15:18:37 -0800 (PST)
Date:   Mon, 14 Nov 2022 15:18:35 -0800
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
Subject: Re: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20221114231835.GA2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
 <0feaa13fa5bf45258f2ebb8407eaefadf5c48976.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0feaa13fa5bf45258f2ebb8407eaefadf5c48976.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 01:29:46AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> > +
> > +#define TDX_MAX_NR_CPUID_CONFIGS					\
> > +	((sizeof(struct tdsysinfo_struct) -				\
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
> 
> I think you can introduce this tdx_capabilities in another patch.
> 
> As claimed this patch can just focus on initializing the TDX module.  Whether
> you need this tdx_capabilities or tdx_sysinfo is enough can be done in the patch
> when they are really needed.  It makes review easier otherwise people won't be
> able to tell why tdx_capabilities is needed here.

Ok, the previous patch ("x86/virt/tdx: Add a helper function to return
system wide info about TDX module ") and this part will be moved right before the
first use of tdx_caps. "KVM: TDX: create/destroy VM structure"


> > +
> > +static int __init tdx_module_setup(void)
> > +{
> > +	const struct tdsysinfo_struct *tdsysinfo;
> > +	int ret = 0;
> > +
> > +	BUILD_BUG_ON(sizeof(*tdsysinfo) != 1024);
> > +	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
> > +
> > +	ret = tdx_enable();
> > +	if (ret) {
> > +		pr_info("Failed to initialize TDX module.\n");
> > +		return ret;
> > +	}
> > +
> > +	tdsysinfo = tdx_get_sysinfo();
> > +	if (tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS)
> > +		return -EIO;
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
> > +
> > +	pr_info("kvm: TDX is supported. x86 phys bits %d\n",
> > +		boot_cpu_data.x86_phys_bits);
> 
> What''s the benefit of print out x86_phys_bits?  Looks a little bit weird here.
> 
> TDX host code will print out TDX private KeyID range.  I think that is useful
> enough?

Ok, please make TDX host code print it.  I will remove key id rane.


> > +
> > +	return 0;
> > +}
> > +
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > +{
> > +	int r;
> > +
> > +	if (!enable_ept) {
> > +		pr_warn("Cannot enable TDX with EPT disabled\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* MOVDIR64B instruction is needed. */
> > +	if (!static_cpu_has(X86_FEATURE_MOVDIR64B)) {
> > +		pr_warn("Cannot enable TDX with MOVDIR64B supported ");
> 					   ^
> 					   without
> > +		return -ENODEV;
> > +	}
> 
> I think you should explain why MOVDIR64B is required, otherwise this just comes
> out of blue.
> 
> Btw, is this absolutely required?  TDX also supports Li-mode, which doesn't have
> integrity check.  So theoretically with Li-mode, normal zeroing is also OK but
> doesn't need to use MOVDIR64B.
> 
> That being said, do we have a way to tell whether TDX works in Ci or Li mode?

As long as I don't know.  When clearing page, we can use
if (featuremovdir64b) movdir64b else memset(0).

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
