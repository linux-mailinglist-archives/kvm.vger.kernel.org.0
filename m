Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414D65A1A20
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243717AbiHYUQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 16:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243710AbiHYUQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 16:16:06 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CAAC00D2;
        Thu, 25 Aug 2022 13:16:03 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c2so19468478plo.3;
        Thu, 25 Aug 2022 13:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=t8dgVLt6RxR9wgKTRsjhJVMVR7VPTX1fjOn2ns4d40k=;
        b=IyJJewpy3Yv3iUdb/WDtGjY7eFy/em3mbHSJqHOK4x4qbVXD3brrAIy/OjVB1ZqHV8
         uwMHd1jZAKk9EiIY9BdFwQfM0sgoC0eiJtZ3HHPDvn5gudl+sImdS+mXAmSnhDwa6hJF
         MSa8wmLSGH99hVuo8fzHhiOYj4PnW6Y/42lYSDBPyAJVFpnMFnVvKVsQbO/k7DHgkBoF
         YCFet56p5aLiotCTYZq5AOmR3A9R0yVMvnsxaNuXNHWkppKFKrtIUH158dGRw8dDE0j6
         tT37u0C0D8LioQhsBblBpb9iHaNF8+vrWdVdf4+DO4DHimfXNb0NbzeX7i++cokx/6eM
         CGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=t8dgVLt6RxR9wgKTRsjhJVMVR7VPTX1fjOn2ns4d40k=;
        b=LaP2WLDKuBoxOs/VDB7e3VVZ4e6WY+79+vY5D0WlyuwAe45pBisI5L+qjzHfRFQcIJ
         FqsPxA7C0vujRNcRADozyw+KtKI3bav13G/ya9t+q6jW2cF+TFUE5EE7OINtIkSipM8y
         oGn+6YW/rNlO4oBIZuIwvs9ZUfiZ7TlIyFT1QsTiBOKWwA17eFX9gq1RaeTkx0ue1f8u
         z7uv+khAGF9QVjHpvPI0XJceSyi6QhpXn3umKKCyn6iNGEbIZcW4HLZov4COKrfz5KIf
         Av0tN3EvuS9UwYqEPkO+mKZbkCZ3kLK5B0/IoKsnAS7oWWdLOnPAVh1A0CxpfYNZ78i1
         V7Mg==
X-Gm-Message-State: ACgBeo2o75zol2/Odt5t6f9u4ExUnjJyu7dumEpuaOlN+T6qvC0GJqPQ
        pfdtCXcdq7S6U13qO7ZzODHLq9JmwSk=
X-Google-Smtp-Source: AA6agR6l0jdZR1jmkC7KCdZkfIkRPeqDu008xJTBdNnLlDTpxdxkwXQooc17n6SFtn+NTeMOTY2j2w==
X-Received: by 2002:a17:902:7d86:b0:170:a752:cbd1 with SMTP id a6-20020a1709027d8600b00170a752cbd1mr694029plm.17.1661458562667;
        Thu, 25 Aug 2022 13:16:02 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id i13-20020a170902cf0d00b0016c0eb202a5sm15041727plg.225.2022.08.25.13.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 13:16:02 -0700 (PDT)
Date:   Thu, 25 Aug 2022 13:16:00 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v8 009/103] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20220825201600.GB2538772@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <b6f8588f51f530e3904d2b98199aba6547032ea4.1659854790.git.isaku.yamahata@intel.com>
 <031bfeab66f425080616f91007afc9140a1d40a0.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <031bfeab66f425080616f91007afc9140a1d40a0.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 08, 2022 at 10:41:27AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > +int __init tdx_module_setup(void)
> > +{
> > +	const struct tdsysinfo_struct *tdsysinfo;
> > +	int ret = 0;
> > +
> > +	BUILD_BUG_ON(sizeof(*tdsysinfo) != 1024);
> > +	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
> > +
> > +	ret = tdx_init();
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
> > +	return 0;
> > +}
> > +
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> 
> Function argument isn't used.
> 
> > +{
> > +	if (!enable_ept) {
> > +		pr_warn("Cannot enable TDX with EPT disabled\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!platform_tdx_enabled()) {
> > +		pr_warn("Cannot enable TDX on TDX disabled platform\n");
> > +		return -ENODEV;
> > +	}
> 
> I am not sure whether this is necessary, as tdx_init() will call it internally
> anyway.
> 
> > +
> > +	pr_info("kvm: TDX is supported. x86 phys bits %d\n",
> > +		boot_cpu_data.x86_phys_bits);
> 
> Is it a little early to say "TDX is supported" before tdx_init() is called?
> 
> I don't think the whole tdx_hardware_setup() is even necessary?  Looks nothing
> is serious here anyway, and all staff can be done in tdx_module_setup().

With the reorganize of kvm initialization[1], we have only one callback
(kvm_arch_hardware_setup()).  And yes, the message should be output after
tdx_init().

[1] https://lore.kernel.org/lkml/cover.1660974106.git.isaku.yamahata@intel.com/

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
