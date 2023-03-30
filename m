Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7266CF86D
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 03:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjC3BB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 21:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3BB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 21:01:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7094A4ED4;
        Wed, 29 Mar 2023 18:01:56 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a16so15757144pjs.4;
        Wed, 29 Mar 2023 18:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680138116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ambahkN5XdW7qXHNDINIC24o08jAaGeXQsgkARkrmIU=;
        b=ouosHywmC5LEy+i6XmI8rHhLKmQifTAE77Oxt7BFzarPRrLZvQuUz025xKtrDyUL0B
         8nQp5ULIftg9mlK2GghSMJDHlSK5J/Y6pl/xgZp1YKNdQ05pOmdw9vmldaSpVyRF72OT
         woVRtqPOt3Y8ZzmMg2ZtJs4SSAwuGQtcERvWxOJBXisUZQ8NiMoPhWpRCABUta7Yofu/
         P+M4svfKhwuuk2fMfOAHtnzF4NDd6gwI9eVPkzxtW1ImPpgtXPFwoq2Dl0eGZizqUAD9
         zjvOM+Y4POvGIuHfnu7poGMB5zDRFDrs3nBUMtLW/o66ad/meUcHboIAl8WNjvGsb91G
         LMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680138116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ambahkN5XdW7qXHNDINIC24o08jAaGeXQsgkARkrmIU=;
        b=xkzpj8Sh0lGsBptpN4mcBnzOc/BbFc/95pXBxnLjUSUoyWuS669UhmezI+bhON+VYV
         uZqRfeF4R+qNrOeA3KaG0pUkhjR1n2EoyTEBO65TrpfF8NtXAPTgSJ/k3RocRzWnXd30
         MCrwJDxiQzFFxC4LjWt1XFhXA3pTr9c0FxpJDLCm6RphTfrwYMfDsrUEp7nXZze0EcWa
         y2Hi8Co1/ktHzF7d0T+gD9jOhNsGmaVaILy+8XsO9l8Qa4/iuVsYC189PQXJAds8k29l
         D4wY83kEz+JnAmGkLIDG635ZZV84WKqJkrueaAIww78sSBVxVPjWWyGMNF+1iJ/TJAT1
         oHtA==
X-Gm-Message-State: AAQBX9e7Fh+WZOSH1fSiVdWWZvJgPNCj7etTF0cu9wzkajpHxYb8nTwf
        lNQwiB+f2qfZ2h7dXUkal/M=
X-Google-Smtp-Source: AKy350bfnPPh8o+VeAI2wWqoxyNfA776Yqe7apoBE1tgQRdwqiR1e1GA/MchzzDgZvEtnVO2zrrCpQ==
X-Received: by 2002:a17:90b:4f4d:b0:23f:7c82:2463 with SMTP id pj13-20020a17090b4f4d00b0023f7c822463mr23109684pjb.9.1680138115714;
        Wed, 29 Mar 2023 18:01:55 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id rj3-20020a17090b3e8300b0023f685f7914sm2020152pjb.49.2023.03.29.18.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 18:01:55 -0700 (PDT)
Date:   Wed, 29 Mar 2023 18:01:53 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 019/113] KVM: TDX: create/destroy VM structure
Message-ID: <20230330010153.GB1112017@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <7c011a5c9dd92cfb9074297af22d132a4e57fd11.1678643052.git.isaku.yamahata@intel.com>
 <20230326140936.00003397@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230326140936.00003397@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, thanks for review.

On Sun, Mar 26, 2023 at 02:09:36PM +0300,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Sun, 12 Mar 2023 10:55:43 -0700
> isaku.yamahata@intel.com wrote:

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 8b02e605cfb5..3ede8a726b47 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -5,8 +5,9 @@
> >  
> >  #include "capabilities.h"
> >  #include "x86_ops.h"
> > -#include "x86.h"
> >  #include "tdx.h"
> > +#include "tdx_ops.h"
> > +#include "x86.h"
> >  
> >  #undef pr_fmt
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > @@ -46,11 +47,276 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> >  	return r;
> >  }
> >  
> > +struct tdx_info {
> > +	u8 nr_tdcs_pages;
> > +};
> > +
> > +/* Info about the TDX module. */
> > +static struct tdx_info tdx_info;
> > +
> > +/*
> > + * Some TDX SEAMCALLs (TDH.MNG.CREATE, TDH.PHYMEM.CACHE.WB,
> > + * TDH.MNG.KEY.RECLAIMID, TDH.MNG.KEY.FREEID etc) tries to acquire a global lock
> > + * internally in TDX module.  If failed, TDX_OPERAND_BUSY is returned without
> > + * spinning or waiting due to a constraint on execution time.  It's caller's
> > + * responsibility to avoid race (or retry on TDX_OPERAND_BUSY).  Use this mutex
> > + * to avoid race in TDX module because the kernel knows better about scheduling.
> > + */
> > +static DEFINE_MUTEX(tdx_lock);
> > +static struct mutex *tdx_mng_key_config_lock;
> > +
> > +static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> > +{
> > +	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> > +}
> > +
> > +static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> > +{
> > +	return kvm_tdx->tdr_pa;
> > +}
> > +
> > +static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> > +{
> > +	tdx_guest_keyid_free(kvm_tdx->hkid);
> > +	kvm_tdx->hkid = 0;
> > +}
> > +
> > +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> > +{
> > +	return kvm_tdx->hkid > 0;
> > +}
> > +
> >  int tdx_hardware_enable(void)
> >  {
> >  	return tdx_cpu_enable();
> >  }
> >  
> > +static void tdx_clear_page(unsigned long page_pa)
> > +{
> > +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > +	void *page = __va(page_pa);
> > +	unsigned long i;
> > +
> > +	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
> > +		clear_page(page);
> > +		return;
> > +	}
> 
> Is it possbile to have a TDX machine without MOVDIR64B support? I am not sure
> if there is any other way for the kernel to clear the posioned cache line.
> 
> If not, there should be a warn/bug at least and check if MOVDIR64B support
> when initializing the TDX.

Because the latest TDX specification uses movdir64b, it's safe for TDX
to assume movdir64b.
I'll add the check to TDX initialization part and drop it from here.


> > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	cpumask_var_t packages;
> > +	bool cpumask_allocated;
> > +	u64 err;
> > +	int ret;
> > +	int i;
> > +
> > +	if (!is_hkid_assigned(kvm_tdx))
> > +		return;
> > +
> > +	if (!is_td_created(kvm_tdx))
> > +		goto free_hkid;
> > +
> > +	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> > +	cpus_read_lock();
> > +	for_each_online_cpu(i) {
> > +		if (cpumask_allocated &&
> > +			cpumask_test_and_set_cpu(topology_physical_package_id(i),
> > +						packages))
> > +			continue;
> 
> Is this necessary to check cpumask_allocated in the while loop? if cpumask
> is not succefully allocated, wouldn't it be better to bail out just after
> it?

No because we can't return error here.  It's better to do in-efficiently freeing
resources instead of leak.

We can move the check out of loop. But it would be ugly
(if () {cpu loop} else {cpu loop} ) and this function isn't performance
critical.  Also I think it's okay to depend on compiler optimization for loop
invariant. My compiler didn't optimize it in this case, though.


> > +
> > +		/*
> > +		 * We can destroy multiple the guest TDs simultaneously.
> > +		 * Prevent tdh_phymem_cache_wb from returning TDX_BUSY by
> > +		 * serialization.
> > +		 */
> > +		mutex_lock(&tdx_lock);
> > +		ret = smp_call_on_cpu(i, tdx_do_tdh_phymem_cache_wb, NULL, 1);
> > +		mutex_unlock(&tdx_lock);
> > +		if (ret)
> > +			break;
> > +	}
> > +	cpus_read_unlock();
> > +	free_cpumask_var(packages);
> > +
> > +	mutex_lock(&tdx_lock);
> > +	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
> > +	mutex_unlock(&tdx_lock);
> > +	if (WARN_ON_ONCE(err)) {
> > +		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
> > +		pr_err("tdh_mng_key_freeid failed. HKID %d is leaked.\n",
> > +			kvm_tdx->hkid);
> > +		return;
> > +	}
> > +
> > +free_hkid:
> > +	tdx_hkid_free(kvm_tdx);
> > +}
> > +
> > +void tdx_vm_free(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	int i;
> > +
> > +	/* Can't reclaim or free TD pages if teardown failed. */
> > +	if (is_hkid_assigned(kvm_tdx))
> > +		return;
> > +
> 
> Better to explain why, as it is common to think even the teardown failed, we
> should still try to reclaim the pages as many as we can.

Ok, here is the updated comment.
 /*
  * tdx_mmu_release_hkid() failed to reclaim HKID.  Something went wrong
  * heavily with TDX module.  Give up freeing TD pages.  As the function
  * already warned, don't warn it again.
  */
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
