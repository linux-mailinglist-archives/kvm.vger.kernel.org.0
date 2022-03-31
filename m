Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5984EE3DE
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 00:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiCaWOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 18:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242163AbiCaWN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 18:13:59 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88C448387;
        Thu, 31 Mar 2022 15:12:11 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id bx5so706729pjb.3;
        Thu, 31 Mar 2022 15:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vCuKnlIkIF1U52URDbeCfdFXzTCZO5yLRnSuRmNZDTg=;
        b=jLI5fEKywdGVJ8nCSblEuDyw950v5tUkGWvVa7S/9AdZcO2zsVFekf1jLskLdzInt3
         Nlm4m5ZHpgCzewevLv7Sxep0d3vvYHSrJdKWuV4mJER02bM+xRidWFrDkreKhB7zCQNz
         oKU+pEBMa5RlgIlAVTP00UqqIqxQd+HMn+ovuj87OJr3m1boMX+yAhCzLVqgxeGJ2QV9
         s7oA/U95+9JZpf7FgcKHJ0Lg+ldlFQWTNd8Zs9TSSWvzdS9u1dYWueji/1CIyeq0nL3I
         iYuAAXWTbk+jO3cUzEpJeoY+p99U7B8Gl6y0Obydv03+Q9V97Y04dmPlQ+9HWVfxm2cb
         BQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vCuKnlIkIF1U52URDbeCfdFXzTCZO5yLRnSuRmNZDTg=;
        b=4f8AGlC+KUJIgFDLW5vOLZAv37nDrBhK9CkOeTTVvZQP9BNkTim1zvc4W7yB3MRtcz
         ByvZvo7kHcppIBY6uTqUmAIK9Qi+ZsJXzCXYfzbWwfE4oBgYTMosoUPspyL9HuHySZJb
         ebYOd9hCMcC7etYstFQjVMXbSeic+hYjOw8uOWFjIXjfoyMx9SGKQcPQzx0T7hkrEiLR
         vUSHrNbKzKBrDb3NGWgWxtp24gb9lXyvXkPS5LTet+tDScv8hK4uYDstDw/9FhpuoaHq
         2na9K9qk0xZU8RRmaNLNXFG/r+NaY/dmTJR+hhdzBp2ErfB0mIBvP58IczR+34kDatiY
         tBjw==
X-Gm-Message-State: AOAM533JBBTDXkxx5i7pviasuZwfAAQ8rIC6NC9NKarJe1VJWf+mbeQR
        FInlelMbbd9NZE1pkZlrQvI=
X-Google-Smtp-Source: ABdhPJyaloOyeeeO7jInz6cnyL9tEcOEfqsRopwyhmSiTJEYmHtlHVpnxguCb2dkaHkc5SS+IwdYZg==
X-Received: by 2002:a17:90b:38c7:b0:1c7:6afb:fac6 with SMTP id nn7-20020a17090b38c700b001c76afbfac6mr8326585pjb.198.1648764731073;
        Thu, 31 Mar 2022 15:12:11 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id f21-20020a056a00239500b004fb02a7a45bsm440664pfc.214.2022.03.31.15.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:12:09 -0700 (PDT)
Date:   Thu, 31 Mar 2022 15:12:07 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 024/104] KVM: TDX: create/destroy VM structure
Message-ID: <20220331221207.GD2084469@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <36805b6b6b668669d5205183c338a4020df584dd.1646422845.git.isaku.yamahata@intel.com>
 <fedfdfbc26965145dcbf4aa893328cce172f2f3b.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fedfdfbc26965145dcbf4aa893328cce172f2f3b.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 05:17:37PM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 1c8222f54764..702953fd365f 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -31,14 +31,324 @@ struct tdx_capabilities {
> >  	struct tdx_cpuid_config cpuid_configs[TDX_MAX_NR_CPUID_CONFIGS];
> >  };
> >  
> > +/* KeyID used by TDX module */
> > +static u32 tdx_global_keyid __read_mostly;
> > +
> 
> It's really not clear why you need to know tdx_global_keyid in the context of
> creating/destroying a TD.

TDX module mpas TDR with TDX global key id. This page includes key id assigned
to this TD.  Then, TDX modules maps other TD-related pages with the HKID.
TDR requires the TDX global key id for cache flush unlike other TD-related
pages.
I'll add a comment.


> >  /* Capabilities of KVM + the TDX module. */
> >  struct tdx_capabilities tdx_caps;
> >  
> > +static DEFINE_MUTEX(tdx_lock);
> >  static struct mutex *tdx_mng_key_config_lock;
> >  
> >  static u64 hkid_mask __ro_after_init;
> >  static u8 hkid_start_pos __ro_after_init;
> >  
> > +static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> > +{
> > +	pa &= ~hkid_mask;
> > +	pa |= (u64)hkid << hkid_start_pos;
> > +
> > +	return pa;
> > +}
> > +
> > +static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> > +{
> > +	return kvm_tdx->tdr.added;
> > +}
> > +
> > +static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> > +{
> > +	tdx_keyid_free(kvm_tdx->hkid);
> > +	kvm_tdx->hkid = -1;
> > +}
> > +
> > +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> > +{
> > +	return kvm_tdx->hkid > 0;
> > +}
> > +
> > +static void tdx_clear_page(unsigned long page)
> > +{
> > +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > +	unsigned long i;
> > +
> > +	/* Zeroing the page is only necessary for systems with MKTME-i. */
> 
> "only necessary for systems  with MKTME-i" because of what?
> 
> Please be more clear that on MKTME-i system, when re-assign one page from old
> keyid to a new keyid, MOVDIR64B is required to clear/write the page with new
> keyid to prevent integrity error when read on the page with new keyid.

Let me borrow this sentence as a comment on it.


> > +static int __tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb, u16 hkid)
> > +{
> > +	struct tdx_module_output out;
> > +	u64 err;
> > +
> > +	err = tdh_phymem_page_reclaim(pa, &out);
> > +	if (WARN_ON_ONCE(err)) {
> > +		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> > +		return -EIO;
> > +	}
> > +
> > +	if (do_wb) {
> 
> In the callers, please add some comments explaining why do_wb is needed, and why
> is not needed.

Will do.

> > +static int tdx_do_tdh_mng_key_config(void *param)
> > +{
> > +	hpa_t *tdr_p = param;
> > +	int cpu, cur_pkg;
> > +	u64 err;
> > +
> > +	cpu = raw_smp_processor_id();
> > +	cur_pkg = topology_physical_package_id(cpu);
> > +
> > +	mutex_lock(&tdx_mng_key_config_lock[cur_pkg]);
> > +	do {
> > +		err = tdh_mng_key_config(*tdr_p);
> > +	} while (err == TDX_KEY_GENERATION_FAILED);
> > +	mutex_unlock(&tdx_mng_key_config_lock[cur_pkg]);
> 
> Why not squashing patch 20 ("KVM: TDX: allocate per-package mutex") into this
> patch?  

Will do.


> > +
> > +	if (WARN_ON_ONCE(err)) {
> > +		pr_tdx_error(TDH_MNG_KEY_CONFIG, err, NULL);
> > +		return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int tdx_vm_init(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	cpumask_var_t packages;
> > +	int ret, i;
> > +	u64 err;
> > +
> > +	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
> > +	kvm->max_vcpus = 0;
> > +
> > +	kvm_tdx->hkid = tdx_keyid_alloc();
> > +	if (kvm_tdx->hkid < 0)
> > +		return -EBUSY;
> > +
> > +	ret = tdx_alloc_td_page(&kvm_tdx->tdr);
> > +	if (ret)
> > +		goto free_hkid;
> > +
> > +	kvm_tdx->tdcs = kcalloc(tdx_caps.tdcs_nr_pages, sizeof(*kvm_tdx->tdcs),
> > +				GFP_KERNEL_ACCOUNT);
> > +	if (!kvm_tdx->tdcs)
> > +		goto free_tdr;
> > +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> > +		ret = tdx_alloc_td_page(&kvm_tdx->tdcs[i]);
> > +		if (ret)
> > +			goto free_tdcs;
> > +	}
> > +
> > +	mutex_lock(&tdx_lock);
> > +	err = tdh_mng_create(kvm_tdx->tdr.pa, kvm_tdx->hkid);
> > +	mutex_unlock(&tdx_lock);
> 
> Please add comment explaining why locking is needed.

I'll add a comment on tdx_lock. Not each TDX seamcalls.


> > diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> > index 0bed43879b82..3dd5b4c3f04c 100644
> > --- a/arch/x86/kvm/vmx/tdx_ops.h
> > +++ b/arch/x86/kvm/vmx/tdx_ops.h
> > @@ -6,6 +6,7 @@
> >  
> >  #include <linux/compiler.h>
> >  
> > +#include <asm/cacheflush.h>
> >  #include <asm/asm.h>
> >  #include <asm/kvm_host.h>
> >  
> > @@ -15,8 +16,14 @@
> >  
> >  #ifdef CONFIG_INTEL_TDX_HOST
> >  
> > +static inline void tdx_clflush_page(hpa_t addr)
> > +{
> > +	clflush_cache_range(__va(addr), PAGE_SIZE);
> > +}
> > +
> >  static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
> >  {
> > +	tdx_clflush_page(addr);
> 
> Please add comment to explain why clflush is needed.
> 
> And you don't need the tdx_clflush_page() wrapper -- it's not a TDX specific
> ops.  You can just use clflush_cache_range().

Will remove it.

The plan was to enhance tdx_cflush_page(addr, page_level) to support large page
to avoid repeating page_level_to_size. Defer it to large page support.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
