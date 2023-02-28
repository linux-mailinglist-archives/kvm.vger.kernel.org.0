Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965156A580B
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 12:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbjB1L2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 06:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjB1L2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 06:28:40 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E178B17CC2;
        Tue, 28 Feb 2023 03:28:10 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id y11so5900415plg.1;
        Tue, 28 Feb 2023 03:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8sEZtEDUtp++YGWscI9RdY1PvIeVhmUGhPtnf7bR5fo=;
        b=Z+nXjGfvKRo+pHxzlYzctPl69DTXhZrlvgicQDGz7aUj5msN0PAEbzLBTj1eAf4oQ5
         SPwmjqb3KmI4J1/YsKgOFuF3vZ+/Ou9vEFemPT647eACcRaaKvkQn4QBrU86lxz3dw1A
         KmUCIlPTOUIuFcD9zDNkGuBhXdp7iSXccGNO9ynEfFT+gnEKbDjPHHZqB5eTZJXRxv2W
         ztDwaYvlv2/IPd+Zq4m1m/jTVoNzcuh4gSfMX1vHi+0g0KLwUKp4zW2GoUZZrgxeJeoA
         0As0ubFOJhddR09LtmRUzwq8y0oUOhFwvyz/SicFr0wZypEnoCHejH9pZJsWe88uP1GY
         6nOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8sEZtEDUtp++YGWscI9RdY1PvIeVhmUGhPtnf7bR5fo=;
        b=KEftnxqXje49O/GQidHyNzpDHJHCr2at55kpdQfjfBO7QBg5Jioz7HIKLNg7R+AGUs
         FeJNsgrbYwc171rFwx9KaAKhhCJlmz1iPxV29Cm4SkvvybTGA07WRv0WzFOa3KWwV9VJ
         vFg+YSxFVuL2mloXS+VzGrpokTy8MVOAknDgr9osrMVAw4PdXdoD6LthqnZfO5o7iqxL
         90kYEZQK8ewjKB6XpJNsLhzEE8bhpVylOIYhxkn9D77suyZInwzzMdk1YapLqSr02Nwc
         49JI8yVtnQS+tfmHom/rLZcKVvPOLlFyOH0PRTkkQwFKxonqoF0Sfs92SFnV/lXuaud+
         R5YA==
X-Gm-Message-State: AO0yUKUUCQ1TPJ6WPlIwUUNNSEI6WTaXCAXKYrAviORAjVKgyEzC2Pse
        hGnyOyLiQIjKQN/ivbCb+BPAAj2OrkM=
X-Google-Smtp-Source: AK7set8U2DkwXfu7IG8b3YfD2r6P1iOr26Wow3qNuzKU60WYJEjKFDKbxO8V1IWi0RXh2Ampn7QnWw==
X-Received: by 2002:a17:90b:3909:b0:233:b73c:18c9 with SMTP id ob9-20020a17090b390900b00233b73c18c9mr2839205pjb.40.1677583638254;
        Tue, 28 Feb 2023 03:27:18 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id ay22-20020a17090b031600b00227223c58ecsm5984960pjb.42.2023.02.28.03.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 03:27:17 -0800 (PST)
Date:   Tue, 28 Feb 2023 03:27:16 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 024/113] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <20230228112716.GX4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <c8f51a32315dce7d4f48d9ae6668da249e22a432.1673539699.git.isaku.yamahata@intel.com>
 <339a959c4a68ccd13d081efecc69707ddb3ea7c9.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <339a959c4a68ccd13d081efecc69707ddb3ea7c9.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 10:37:43AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-01-12 at 08:31 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TD guest vcpu need to be configured before ready to run which requests
> > addtional information from Device model (e.g. qemu), one 64bit value is
> > passed to vcpu's RCX as an initial value.  
> > 
> 
> The first half sentence doesn't parse to me.  It also has grammar issue.
> 
> Also, the second half only talks about TDH.VP.INIT, but there's more regarding
> to creating/initializing a TDX guest vcpu.  IMHO It would be better if you can
> briefly describe the whole sequence here so people can get some idea about your
> code below.
> 
> Btw, I don't understand what's the point of pointing out "64bit value passed to
> vcpu's RCX ...".  You can add this to the comment instead.  If it is important,
> then please add more to explain it so people can understand more. 
> 

RCX and 64bit value doesn't make much sense in the commit message. I dropped
those sentence.

Here is the updated commit message.

    KVM: TDX: Do TDX specific vcpu initialization
    
    TD guest vcpu needs TDX specific initialization before running.  Repurpose
    KVM_MEMORY_ENCRYPT_OP to vcpu-scope, add a new sub-command
    KVM_TDX_INIT_VCPU, and implement the callback for it.

> > Repurpose KVM_MEMORY_ENCRYPT_OP
> > to vcpu-scope and add new sub-commands KVM_TDX_INIT_VCPU under it for such
> > additional vcpu configuration.
> 
> I am not sure using the same command for both per-VM and per-vcpu ioctls is a
> good idea.  Is there any existing example does this?

There are some. Please break Documentation/virt/kvm/api.rst with "type:".
You can see some ioctl supports multiple type.

  Type: system ioctl, vm ioctl
  Type: vcpu ioctl / vm ioctl
  Type: device ioctl, vm ioctl, vcpu ioctl


> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 099f0737a5aa..e2f5a07ad4e5 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -49,6 +49,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> >  	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> >  }
> >  
> > +static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> > +{
> > +	return tdx->tdvpr_pa;
> > +}
> > +
> >  static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> >  {
> >  	return kvm_tdx->tdr_pa;
> > @@ -65,6 +70,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> >  	return kvm_tdx->hkid > 0;
> >  }
> >  
> > +static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
> > +{
> > +	return kvm_tdx->finalized;
> > +}
> > +
> >  static void tdx_clear_page(unsigned long page_pa)
> >  {
> >  	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > @@ -327,7 +337,21 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> >  
> >  void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> >  {
> > -	/* This is stub for now.  More logic will come. */
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	int i;
> > +
> > +	/* Can't reclaim or free pages if teardown failed. */
> > +	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
> > +		return;
> 
> You may want to WARN() if it's a kernel bug you want to catch.

No, it's not a bug to come here with hkid freed because vcpus_free method
can be called after vm destruction.


> > +
> > +	if (tdx->tdvpx_pa) {
> > +		for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
> > +			tdx_reclaim_td_page(tdx->tdvpx_pa[i]);
> > +		kfree(tdx->tdvpx_pa);
> > +		tdx->tdvpx_pa = NULL;
> > +	}
> > +	tdx_reclaim_td_page(tdx->tdvpr_pa);
> > +	tdx->tdvpr_pa = 0;
> >  }
> >  
> >  void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > @@ -337,6 +361,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  	/* TDX doesn't support INIT event. */
> >  	if (WARN_ON_ONCE(init_event))
> >  		goto td_bugged;
> > +	if (WARN_ON_ONCE(is_td_vcpu_created(to_tdx(vcpu))))
> > +		goto td_bugged;
> 
> Again, not sure can we use KVM_BUG_ON()?

I converted it into KVM_BUG_ON()


> >  	/* TDX rquires X2APIC. */
> >  	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
> > @@ -791,6 +817,125 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> >  	return r;
> >  }
> >  
> > +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	unsigned long *tdvpx_pa = NULL;
> > +	unsigned long tdvpr_pa;
> > +	unsigned long va;
> > +	int ret, i;
> > +	u64 err;
> > +
> > +	if (is_td_vcpu_created(tdx))
> > +		return -EINVAL;
> 
> Ditto.  WARN()?

No. KVM_TDX_INIT_VCPU can be called multiple times.  It's not kernel bug, but
misuse of the ioctl.


> > +
> > +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +	if (!va)
> > +		return -ENOMEM;
> > +	tdvpr_pa = __pa(va);
> > +
> > +	tdvpx_pa = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx_pa),
> > +			   GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> 
> kcalloc() uses __GFP_ZERO internally.
> 
> > +	if (!tdvpx_pa) {
> > +		ret = -ENOMEM;
> > +		goto free_tdvpr;
> > +	}
> > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +		if (!va)
> > +			goto free_tdvpx;
> > +		tdvpx_pa[i] = __pa(va);
> > +	}
> > +
> > +	err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
> > +	if (WARN_ON_ONCE(err)) {
> > +		ret = -EIO;
> > +		pr_tdx_error(TDH_VP_CREATE, err, NULL);
> > +		goto td_bugged_free_tdvpx;
> > +	}
> > +	tdx->tdvpr_pa = tdvpr_pa;
> > +
> > +	tdx->tdvpx_pa = tdvpx_pa;
> > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > +		err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
> > +		if (WARN_ON_ONCE(err)) {
> > +			ret = -EIO;
> > +			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
> > +			for (; i < tdx_caps.tdvpx_nr_pages; i++) {
> > +				free_page((unsigned long)__va(tdvpx_pa[i]));
> > +				tdvpx_pa[i] = 0;
> > +			}
> > +			goto td_bugged;
> > +		}
> > +	}
> > +
> > +	err = tdh_vp_init(tdx->tdvpr_pa, vcpu_rcx);
> > +	if (WARN_ON_ONCE(err)) {
> > +		ret = -EIO;
> > +		pr_tdx_error(TDH_VP_INIT, err, NULL);
> > +		goto td_bugged;
> > +	}
> > +
> > +	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > +
> > +	return 0;
> > +
> > +td_bugged_free_tdvpx:
> > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > +		free_page((unsigned long)__va(tdvpx_pa[i]));
> > +		tdvpx_pa[i] = 0;
> > +	}
> > +	kfree(tdvpx_pa);
> > +td_bugged:
> > +	vcpu->kvm->vm_bugged = true;
> > +	return ret;
> > +
> > +free_tdvpx:
> > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
> > +		if (tdvpx_pa[i])
> > +			free_page((unsigned long)__va(tdvpx_pa[i]));
> > +	kfree(tdvpx_pa);
> 
> This piece of code appears 3 times in this function (and there are 3 'return
> ret;').  I am sure it can be done in one place instead. Can you reorganize?

I improved the logic to delete the duplication.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
