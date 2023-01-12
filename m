Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658F0666976
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 04:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbjALDMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 22:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbjALDME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 22:12:04 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D95049164;
        Wed, 11 Jan 2023 19:12:03 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y1so18887660plb.2;
        Wed, 11 Jan 2023 19:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hZGA7rVAPUu/uB255K6JoKHkYFSrz5XmoEcLH/bhVQ8=;
        b=DUrZfbu0qwZ+0tkn4hivdO2hoJLgPiBKmNYUvXW0DAlVJ+wlqg4DoFamqFZ9HGpyVu
         TgxAHjnFHkUsxDSW9Ng2h+iYfxg9UtB95cA/RNhKdAnOOGy0hsiVNp+fLMBVj66mEel2
         tEXVs9PQ/OF2rsAP9nkkNhrJAJvOdVW4pOQMSY+LN+GLrwLypUW4UqoPpUQ7sTggjRo6
         ZbtAK+XwUN0d94C+bYWu9hPQ8ju/qmVRu8JV3CwEzM8XABmYpASs4K12/wTm1tV7307D
         E6mE8h4hM72tmdPHeWepfezgTRShrY4EZcZ5AQQihnhq41MEmkC3qxOp53Vj43ViUtCe
         LKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZGA7rVAPUu/uB255K6JoKHkYFSrz5XmoEcLH/bhVQ8=;
        b=gqzjjMTd88FeO1TwT/Zzdt+0TqMM+kywJMBchCH2WU+7iawO4HUefKxA16PD8xqP9w
         8JMUlc7igxUE2Nupz3fF6mGsi+GuYqta+WFTQQ+n0BNCvnJ67z2HF5DCwe2GNzhvw3r8
         jSobvHCedgdlF1NMGVT9EYWhaSUKM58Ws+bfPm0bz2UGU/Bq5UaB1Z7VVZxJcT640fUB
         HS+ajG4Rc+ltOC2orqR0fWdRVQzEt8nTu2y3gUgOjS/Mfs3xv3EBcS/IOq6rZuIo4T5F
         Pv3EVsxWSJ5tsW+qOwHUFoHmoK5lAFIyx5EztHIdzA4s+R4RAwZBxT8FISCdhM04coh3
         rSaA==
X-Gm-Message-State: AFqh2kpzilNciYvXbrjUcNwl7rOX9AMO7A730qQGdNsB2IgdYIszchLf
        sbBqbt7we/+S1lzcoVUoKgE=
X-Google-Smtp-Source: AMrXdXtB1WTseKUSthwdr3p/3ApvHsPQZy/4AjJuOCnDhggZ6pNfgzyRpS8RHOaTT6CT6yN/UX0KgQ==
X-Received: by 2002:a17:902:ec89:b0:186:b063:32e with SMTP id x9-20020a170902ec8900b00186b063032emr106429986plg.62.1673493122401;
        Wed, 11 Jan 2023 19:12:02 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id y14-20020a634b0e000000b00476c2180dbcsm8996921pga.29.2023.01.11.19.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 19:12:02 -0800 (PST)
Date:   Wed, 11 Jan 2023 19:12:01 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wang, Lei" <lei4.wang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v10 021/108] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20230112031201.GB2034518@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <ebb4beadff8e117d0fb643af4ee310b6608679bf.1667110240.git.isaku.yamahata@intel.com>
 <f9d7c13e-e96c-2afd-4c8b-cb7f17d61445@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f9d7c13e-e96c-2afd-4c8b-cb7f17d61445@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 03:59:08PM +0800,
"Wang, Lei" <lei4.wang@intel.com> wrote:

> On 10/30/2022 2:22 PM, isaku.yamahata@intel.com wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > TDX requires additional parameters for TDX VM for confidential execution to
> > protect its confidentiality of its memory contents and its CPU state from
> > any other software, including VMM. When creating guest TD VM before
> > creating vcpu, the number of vcpu, TSC frequency (that is same among
> > vcpus. and it can't be changed.)  CPUIDs which is emulated by the TDX
> > module. It means guest can trust those CPUIDs. and sha384 values for
> > measurement.
> > 
> > Add new subcommand, KVM_TDX_INIT_VM, to pass parameters for TDX guest.  It
> > assigns encryption key to the TDX guest for memory encryption.  TDX
> > encrypts memory per-guest bases.  It assigns device model passes per-VM
> > parameters for the TDX guest.  The maximum number of vcpus, tsc frequency
> > (TDX guest has fised VM-wide TSC frequency. not per-vcpu.  The TDX guest
> > can not change it.), attributes (production or debug), available extended
> > features (which is reflected into guest XCR0, IA32_XSS MSR), cpuids, sha384
> > measurements, and etc.
> > 
> > This subcommand is called before creating vcpu and KVM_SET_CPUID2, i.e.
> > cpuids configurations aren't available yet.  So CPUIDs configuration values
> > needs to be passed in struct kvm_init_vm.  It's device model responsibility
> 
> I suppose this should be kvm_tdx_init_vm.
> 
> > to make this cpuid config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/tdx.h            |   3 +
> >  arch/x86/include/uapi/asm/kvm.h       |  31 +++
> >  arch/x86/kvm/vmx/tdx.c                | 296 ++++++++++++++++++++++----
> >  arch/x86/kvm/vmx/tdx.h                |  22 ++
> >  tools/arch/x86/include/uapi/asm/kvm.h |  33 +++
> >  5 files changed, 347 insertions(+), 38 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index cd304d323d33..05ac4bfc8f8a 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -131,6 +131,9 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
> >  #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
> >  
> >  #ifdef CONFIG_INTEL_TDX_HOST
> > +
> > +/* -1 indicates CPUID leaf with no sub-leaves. */
> > +#define TDX_CPUID_NO_SUBLEAF	((u32)-1)
> >  struct tdx_cpuid_config {
> >  	u32	leaf;
> >  	u32	sub_leaf;
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 2ad9666e02a5..26661879c031 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -538,6 +538,7 @@ struct kvm_pmu_event_filter {
> >  /* Trust Domain eXtension sub-ioctl() commands. */
> >  enum kvm_tdx_cmd_id {
> >  	KVM_TDX_CAPABILITIES = 0,
> > +	KVM_TDX_INIT_VM,
> >  
> >  	KVM_TDX_CMD_NR_MAX,
> >  };
> > @@ -583,4 +584,34 @@ struct kvm_tdx_capabilities {
> >  	struct kvm_tdx_cpuid_config cpuid_configs[0];
> >  };
> >  
> > +struct kvm_tdx_init_vm {
> > +	__u64 attributes;
> > +	__u64 mrconfigid[6];	/* sha384 digest */
> > +	__u64 mrowner[6];	/* sha384 digest */
> > +	__u64 mrownerconfig[6];	/* sha348 digest */
> > +	union {
> > +		/*
> > +		 * KVM_TDX_INIT_VM is called before vcpu creation, thus before
> > +		 * KVM_SET_CPUID2.  CPUID configurations needs to be passed.
> > +		 *
> > +		 * This configuration supersedes KVM_SET_CPUID{,2}.
> > +		 * The user space VMM, e.g. qemu, should make them consistent
> > +		 * with this values.
> > +		 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(256)
> > +		 * = 8KB.
> > +		 */
> > +		struct {
> > +			struct kvm_cpuid2 cpuid;
> > +			/* 8KB with KVM_MAX_CPUID_ENTRIES. */
> > +			struct kvm_cpuid_entry2 entries[];
> > +		};
> > +		/*
> > +		 * For future extensibility.
> > +		 * The size(struct kvm_tdx_init_vm) = 16KB.
> > +		 * This should be enough given sizeof(TD_PARAMS) = 1024
> > +		 */
> > +		__u64 reserved[2029];
> > +	};
> > +};
> > +
> >  #endif /* _ASM_X86_KVM_H */
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index d77709a6da51..54045e0576e7 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -284,6 +284,205 @@ static int tdx_do_tdh_mng_key_config(void *param)
> >  int tdx_vm_init(struct kvm *kvm)
> >  {
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +
> > +	kvm_tdx->hkid = -1;
> > +
> > +	/*
> > +	 * This function initializes only KVM software construct.  It doesn't
> > +	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
> > +	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
> > +	 */
> > +
> > +	return 0;
> > +}
> > +
> > +int tdx_dev_ioctl(void __user *argp)
> > +{
> > +	struct kvm_tdx_capabilities __user *user_caps;
> > +	struct kvm_tdx_capabilities caps;
> > +	struct kvm_tdx_cmd cmd;
> > +
> > +	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
> > +		     sizeof(struct tdx_cpuid_config));
> > +
> > +	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> > +		return -EFAULT;
> > +	if (cmd.flags || cmd.error || cmd.unused)
> > +		return -EINVAL;
> > +	/*
> > +	 * Currently only KVM_TDX_CAPABILITIES is defined for system-scoped
> > +	 * mem_enc_ioctl().
> > +	 */
> > +	if (cmd.id != KVM_TDX_CAPABILITIES)
> > +		return -EINVAL;
> > +
> > +	user_caps = (void __user *)cmd.data;
> > +	if (copy_from_user(&caps, user_caps, sizeof(caps)))
> > +		return -EFAULT;
> > +
> > +	if (caps.nr_cpuid_configs < tdx_caps.nr_cpuid_configs)
> > +		return -E2BIG;
> > +
> > +	caps = (struct kvm_tdx_capabilities) {
> > +		.attrs_fixed0 = tdx_caps.attrs_fixed0,
> > +		.attrs_fixed1 = tdx_caps.attrs_fixed1,
> > +		.xfam_fixed0 = tdx_caps.xfam_fixed0,
> > +		.xfam_fixed1 = tdx_caps.xfam_fixed1,
> > +		.nr_cpuid_configs = tdx_caps.nr_cpuid_configs,
> > +		.padding = 0,
> > +	};
> > +
> > +	if (copy_to_user(user_caps, &caps, sizeof(caps)))
> > +		return -EFAULT;
> > +	if (copy_to_user(user_caps->cpuid_configs, &tdx_caps.cpuid_configs,
> > +			 tdx_caps.nr_cpuid_configs *
> > +			 sizeof(struct tdx_cpuid_config)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> 
> tdx_dev_ioctl() is introduced in previous patch with the same code added here,
> which means this is just a place change and it will confuse reviewers. Is it
> neccesary to do so?

Right. Somehow diff was also confused. I'll try to twist the previous patch to
introduce __tdx_td_init() with the previous patch.


...

> > +static inline bool is_td_initialized(struct kvm *kvm)
> > +{
> > +	return to_kvm_tdx(kvm)->hkid > 0;
> > +}
> 
> There is a similar function, is_hkid_assigned(), which is previously defined. Do
> you think redefining a new function here will bring code redundency?

I'll drop this function and replace it with is_hkid_assigned().
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
