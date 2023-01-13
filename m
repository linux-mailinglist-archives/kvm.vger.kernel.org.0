Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B354669B6C
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 16:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjAMPIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 10:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjAMPHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 10:07:43 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532C1983C2;
        Fri, 13 Jan 2023 06:58:56 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id x37so22705807ljq.1;
        Fri, 13 Jan 2023 06:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JkDoHBIJfbA19g2LLJ3wPQuirEuYMlmrafAEnI1nQ2I=;
        b=AzpiJlar93wHyhlv+etJHh23TDOkbzgvldXFMAB+AslCegAZ4HgHBZ1Vsd408kZIkl
         NSBhD18Dd785xA7uSihLa1iLyNkcYAHy4J7AtJsbfmQAqAd+Rn9aIoHmwjUdSdZJWQ+8
         ldIeBfxbY0Mh0lMhKYKCpXGS9Q1ZY7B/Vl6VAPKOtL/7VBF5+rr/wbYJjsHF7qS5bRr/
         PsqnF4MbEs0cT95U6gtCBx+0piusRfsYydiQUBVQmOTnFMercu+jnZ3ZSXkWbdsY30iB
         +KWKan83UUqUyaHogi3JFWPQ3cX7Aumk4IZM8x6YXimkJstItp6v+2cLzXIr/qgQuLi+
         /BWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JkDoHBIJfbA19g2LLJ3wPQuirEuYMlmrafAEnI1nQ2I=;
        b=VhoOhW3eitRLoVKu0YtTkgq4j3b+llPiI8hLhyBxlrLoFc/zjM/zYHuqlNeIJrM1qy
         2sVB0fly4vdgPxF44dVIZfuTaSRveBaLkYZnnH70ne4HJEVnCIi5Dcl3utxFoQEldoYz
         faBBMh0kY8INEzzD9+05OGLzKEoxBuOYVc+h6UXhoz6eXVNs3Z4hnfEkpl8Y1MwLXFOc
         SQIJzkXulmv0KBPikZPKXIb+/8qP4RuzO2VDkgDAGa551I4Q75IF/MrRm6/xM2iB7VWH
         CTth0iJM3UAhjTzmj5MN0orBGIXNM/yPa5Q39xwPxBBz7UwATJpCnPcZueb7iwjMdAQJ
         wk5w==
X-Gm-Message-State: AFqh2kpPubk5hIvsmz75f/9J6rx9qugKu1u4151LZWc5VlshDQRC/pEG
        Fp+d/wGSJgxWHrVpVRHnakA=
X-Google-Smtp-Source: AMrXdXuzCrpEuvOfBaHeR4h3bI0SiFPLPZ+/Vh1It6hy+CtDwV7JfuIZyEZ/60g9Hro3tBawmjgF7A==
X-Received: by 2002:a05:651c:b0b:b0:282:3c84:b2a with SMTP id b11-20020a05651c0b0b00b002823c840b2amr2506538ljr.1.1673621934096;
        Fri, 13 Jan 2023 06:58:54 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id a20-20020a2eb554000000b00281002589e0sm2576731ljn.96.2023.01.13.06.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 06:58:53 -0800 (PST)
Date:   Fri, 13 Jan 2023 16:58:51 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v11 019/113] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20230113165851.00005dae@gmail.com>
In-Reply-To: <a0b5c459cce27c83a1275a3108f810299635d217.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <a0b5c459cce27c83a1275a3108f810299635d217.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 08:31:27 -0800
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX requires additional parameters for TDX VM for confidential execution
> to protect its confidentiality of its memory contents and its CPU state
> from any other software, including VMM. When creating guest TD VM before
> creating vcpu, the number of vcpu, TSC frequency (that is same among
> vcpus. and it can't be changed.)  CPUIDs which is emulated by the TDX
> module. It means guest can trust those CPUIDs. and sha384 values for
> measurement.
> 
> Add new subcommand, KVM_TDX_INIT_VM, to pass parameters for TDX guest.
> It assigns encryption key to the TDX guest for memory encryption.  TDX
> encrypts memory per-guest bases.  It assigns device model passes per-VM
> parameters for the TDX guest.  The maximum number of vcpus, tsc frequency
> (TDX guest has fised VM-wide TSC frequency. not per-vcpu.  The TDX guest
> can not change it.), attributes (production or debug), available extended
> features (which is reflected into guest XCR0, IA32_XSS MSR), cpuids,
> sha384 measurements, and etc.
> 
> This subcommand is called before creating vcpu and KVM_SET_CPUID2, i.e.
> cpuids configurations aren't available yet.  So CPUIDs configuration
> values needs to be passed in struct kvm_tdx_init_vm.  It's device model
> responsibility to make this cpuid config for KVM_TDX_INIT_VM and
> KVM_SET_CPUID2.
> 

I find this one is take much more time to review than others. Mostly what I
noticed are:

It takes quite so much time to switch between the code and the TDX module
spec when verifying the configuration of TD params structs. I would suggest
to organize TD params structs setup part better:

a. Describe the steps, like step 1: xxx and step 2:xxx. Make it more
informative and purpose-oriented if necessary.

b. Separate them into small inline functions and add comments there. So
the setup_td_params() will look much cleaner to read and follow.
For example:

+	max_pa = 36;
+	entry = tdx_find_cpuid_entry(cpuid, 0x80000008, 0);
+	if (entry)
+		max_pa = entry->eax & 0xff;
+
+	td_params->eptp_controls = VMX_EPTP_MT_WB;
+	/*
+	 * No CPU supports 4-level && max_pa > 48.
+	 * "5-level paging and 5-level EPT" section 4.1 4-level EPT
+	 * "4-level EPT is limited to translating 48-bit guest-physical
+	 *  addresses."
+	 * cpu_has_vmx_ept_5levels() check is just in case.
+	 */
+	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
+		td_params->eptp_controls |= VMX_EPTP_PWL_5;
+		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
+	} else {
+		td_params->eptp_controls |= VMX_EPTP_PWL_4;
+	}
+

The above snippet can be wrapped in a function as setup_eptp_controls()
and then explain the purpose in the comments inside that function.
Also, it would be easier to define the macros for magic numbers inside
those functions. 

c. Organize the CPUID virtualization in dedicated functions and brief
the details there. The detail of CPUID virtualization seems super huge
in the TDX module ABI spec (it took me quite some time to go through it).
It would be better to have a brief to help people understand it without
going through the related details.

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/tdx.h            |   3 +
>  arch/x86/include/uapi/asm/kvm.h       |  31 ++++
>  arch/x86/kvm/vmx/tdx.c                | 229 ++++++++++++++++++++++++--
>  arch/x86/kvm/vmx/tdx.h                |  20 +++
>  tools/arch/x86/include/uapi/asm/kvm.h |  33 ++++
>  5 files changed, 306 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 2ca6e8ce1e43..d7ce2217279f 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -105,6 +105,9 @@ static inline long tdx_kvm_hypercall(unsigned int
> nr, unsigned long p1, #endif /* CONFIG_INTEL_TDX_GUEST &&
> CONFIG_KVM_GUEST */ 
>  #ifdef CONFIG_INTEL_TDX_HOST
> +
> +/* -1 indicates CPUID leaf with no sub-leaves. */
> +#define TDX_CPUID_NO_SUBLEAF	((u32)-1)
>  struct tdx_cpuid_config {
>  	u32	leaf;
>  	u32	sub_leaf;
> diff --git a/arch/x86/include/uapi/asm/kvm.h
> b/arch/x86/include/uapi/asm/kvm.h index 610b1de9eb2b..b8f28d86d4fd 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -535,6 +535,7 @@ struct kvm_pmu_event_filter {
>  /* Trust Domain eXtension sub-ioctl() commands. */
>  enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };
> @@ -580,4 +581,34 @@ struct kvm_tdx_capabilities {
>  	struct kvm_tdx_cpuid_config cpuid_configs[0];
>  };
>  
> +struct kvm_tdx_init_vm {
> +	__u64 attributes;
> +	__u64 mrconfigid[6];	/* sha384 digest */
> +	__u64 mrowner[6];	/* sha384 digest */
> +	__u64 mrownerconfig[6];	/* sha348 digest */
> +	union {
> +		/*
> +		 * KVM_TDX_INIT_VM is called before vcpu creation, thus
> before
> +		 * KVM_SET_CPUID2.  CPUID configurations needs to be
> passed.
> +		 *
> +		 * This configuration supersedes KVM_SET_CPUID{,2}.
> +		 * The user space VMM, e.g. qemu, should make them
> consistent
> +		 * with this values.
> +		 * sizeof(struct kvm_cpuid_entry2) *
> KVM_MAX_CPUID_ENTRIES(256)
> +		 * = 8KB.
> +		 */
> +		struct {
> +			struct kvm_cpuid2 cpuid;
> +			/* 8KB with KVM_MAX_CPUID_ENTRIES. */
> +			struct kvm_cpuid_entry2 entries[];
> +		};
> +		/*
> +		 * For future extensibility.
> +		 * The size(struct kvm_tdx_init_vm) = 16KB.
> +		 * This should be enough given sizeof(TD_PARAMS) = 1024
> +		 */
> +		__u64 reserved[2029];
> +	};
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index d11950d18226..0b309bbfe4e5 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,7 +6,6 @@
>  #include "capabilities.h"
>  #include "x86_ops.h"
>  #include "tdx.h"
> -#include "tdx_ops.h"
>  #include "x86.h"
>  
>  #undef pr_fmt
> @@ -269,12 +268,15 @@ static int tdx_do_tdh_mng_key_config(void *param)
>  	return 0;
>  }
>  
> -static int __tdx_td_init(struct kvm *kvm);
> -
>  int tdx_vm_init(struct kvm *kvm)
>  {
> -	/* Place holder for now. */
> -	return __tdx_td_init(kvm);
> +	/*
> +	 * This function initializes only KVM software construct.  It
> doesn't
> +	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
> +	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
> +	 */
> +
> +	return 0;
>  }
>  
>  int tdx_dev_ioctl(void __user *argp)
> @@ -323,9 +325,147 @@ int tdx_dev_ioctl(void __user *argp)
>  	return 0;
>  }
>  
> -static int __tdx_td_init(struct kvm *kvm)
> +/*
> + * cpuid entry lookup in TDX cpuid config way.
> + * The difference is how to specify index(subleaves).
> + * Specify index to TDX_CPUID_NO_SUBLEAF for CPUID leaf with
> no-subleaves.
> + */
> +static const struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(const struct
> kvm_cpuid2 *cpuid,
> +							   u32
> function, u32 index) +{
> +	int i;
> +
> +	/* In TDX CPU CONFIG, TDX_CPUID_NO_SUBLEAF means index = 0. */
> +	if (index == TDX_CPUID_NO_SUBLEAF)
> +		index = 0;
> +
> +	for (i = 0; i < cpuid->nent; i++) {
> +		const struct kvm_cpuid_entry2 *e = &cpuid->entries[i];
> +
> +		if (e->function == function &&
> +		    (e->index == index ||
> +		     !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
> +			return e;
> +	}
> +	return NULL;
> +}
> +
> +static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> +			struct kvm_tdx_init_vm *init_vm)
> +{
> +	const struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
> +	const struct kvm_cpuid_entry2 *entry;
> +	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
> +	int max_pa;
> +	int i;
> +
> +	if (kvm->created_vcpus)
> +		return -EBUSY;
> +	td_params->max_vcpus = kvm->max_vcpus;
> +	td_params->attributes = init_vm->attributes;
> +	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> +		/*
> +		 * TODO: save/restore PMU related registers around
> TDENTER.
> +		 * Once it's done, remove this guard.
> +		 */
> +		pr_warn("TD doesn't support perfmon yet. KVM needs to
> save/restore "
> +			"host perf registers properly.\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	for (i = 0; i < tdx_caps.nr_cpuid_configs; i++) {
> +		const struct tdx_cpuid_config *config =
> &tdx_caps.cpuid_configs[i];
> +		const struct kvm_cpuid_entry2 *entry =
> +			tdx_find_cpuid_entry(cpuid, config->leaf,
> config->sub_leaf);
> +		struct tdx_cpuid_value *value =
> &td_params->cpuid_values[i]; +
> +		if (!entry)
> +			continue;
> +
> +		value->eax = entry->eax & config->eax;
> +		value->ebx = entry->ebx & config->ebx;
> +		value->ecx = entry->ecx & config->ecx;
> +		value->edx = entry->edx & config->edx;
> +	}
> +
> +	max_pa = 36;
> +	entry = tdx_find_cpuid_entry(cpuid, 0x80000008, 0);
> +	if (entry)
> +		max_pa = entry->eax & 0xff;
> +
> +	td_params->eptp_controls = VMX_EPTP_MT_WB;
> +	/*
> +	 * No CPU supports 4-level && max_pa > 48.
> +	 * "5-level paging and 5-level EPT" section 4.1 4-level EPT
> +	 * "4-level EPT is limited to translating 48-bit guest-physical
> +	 *  addresses."
> +	 * cpu_has_vmx_ept_5levels() check is just in case.
> +	 */
> +	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
> +		td_params->eptp_controls |= VMX_EPTP_PWL_5;
> +		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
> +	} else {
> +		td_params->eptp_controls |= VMX_EPTP_PWL_4;
> +	}
> +
> +	/* Setup td_params.xfam */
> +	entry = tdx_find_cpuid_entry(cpuid, 0xd, 0);
> +	if (entry)
> +		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx
> << 32));
> +	else
> +		guest_supported_xcr0 = 0;
> +	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
> +
> +	entry = tdx_find_cpuid_entry(cpuid, 0xd, 1);
> +	if (entry)
> +		guest_supported_xss = (entry->ecx | ((u64)entry->edx <<
> 32));
> +	else
> +		guest_supported_xss = 0;
> +	/* PT can be exposed to TD guest regardless of KVM's XSS
> support */
> +	guest_supported_xss &= (kvm_caps.supported_xss |
> XFEATURE_MASK_PT); +
> +	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
> +	if (td_params->xfam & XFEATURE_MASK_LBR) {
> +		/*
> +		 * TODO: once KVM supports LBR(save/restore LBR related
> +		 * registers around TDENTER), remove this guard.
> +		 */
> +		pr_warn("TD doesn't support LBR yet. KVM needs to
> save/restore "
> +			"IA32_LBR_DEPTH properly.\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (td_params->xfam & XFEATURE_MASK_XTILE) {
> +		/*
> +		 * TODO: once KVM supports AMX(save/restore AMX related
> +		 * registers around TDENTER), remove this guard.
> +		 */
> +		pr_warn("TD doesn't support AMX yet. KVM needs to
> save/restore "
> +			"IA32_XFD, IA32_XFD_ERR properly.\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	td_params->tsc_frequency =
> +		TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
> +
> +#define MEMCPY_SAME_SIZE(dst, src)				\
> +	do {							\
> +		BUILD_BUG_ON(sizeof(dst) != sizeof(src));	\
> +		memcpy((dst), (src), sizeof(dst));		\
> +	} while (0)
> +
> +	MEMCPY_SAME_SIZE(td_params->mrconfigid, init_vm->mrconfigid);
> +	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
> +	MEMCPY_SAME_SIZE(td_params->mrownerconfig,
> init_vm->mrownerconfig); +
> +	return 0;
> +}
> +
> +static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct tdx_module_output out;
>  	cpumask_var_t packages;
>  	unsigned long *tdcs_pa = NULL;
>  	unsigned long tdr_pa = 0;
> @@ -439,10 +579,13 @@ static int __tdx_td_init(struct kvm *kvm)
>  		}
>  	}
>  
> -	/*
> -	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT
> requires a dedicated
> -	 * ioctl() to define the configure CPUID values for the TD.
> -	 */
> +	err = tdh_mng_init(kvm_tdx->tdr_pa, __pa(td_params), &out);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_INIT, err, &out);
> +		ret = -EIO;
> +		goto teardown;
> +	}
> +
>  	return 0;
>  
>  	/*
> @@ -477,6 +620,69 @@ static int __tdx_td_init(struct kvm *kvm)
>  	return ret;
>  }
>  
> +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct kvm_tdx_init_vm *init_vm = NULL;
> +	struct td_params *td_params = NULL;
> +	void *entries_end;
> +	int ret;
> +
> +	BUILD_BUG_ON(sizeof(*init_vm) != 16 * 1024);
> +	BUILD_BUG_ON((sizeof(*init_vm) - offsetof(typeof(*init_vm),
> entries)) /
> +		     sizeof(init_vm->entries[0]) <
> KVM_MAX_CPUID_ENTRIES);
> +	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
> +
> +	if (is_hkid_assigned(kvm_tdx))
> +		return -EINVAL;
> +
> +	if (cmd->flags)
> +		return -EINVAL;
> +
> +	init_vm = kzalloc(sizeof(*init_vm), GFP_KERNEL);
> +	if (!init_vm)
> +		return -ENOMEM;
> +	if (copy_from_user(init_vm, (void __user *)cmd->data,
> sizeof(*init_vm))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret = -EINVAL;
> +	if (init_vm->cpuid.padding)
> +		goto out;
> +	/* init_vm->entries shouldn't overrun. */
> +	entries_end = init_vm->entries + init_vm->cpuid.nent;
> +	if (entries_end > (void *)(init_vm + 1))
> +		goto out;
> +	/* Unused part must be zero. */
> +	if (memchr_inv(entries_end, 0, (void *)(init_vm + 1) -
> entries_end))
> +		goto out;
> +
> +	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
> +	if (!td_params) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = setup_tdparams(kvm, td_params, init_vm);
> +	if (ret)
> +		goto out;
> +
> +	ret = __tdx_td_init(kvm, td_params);
> +	if (ret)
> +		goto out;
> +
> +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx,
> TD_TDCS_EXEC_TSC_OFFSET);
> +	kvm_tdx->attributes = td_params->attributes;
> +	kvm_tdx->xfam = td_params->xfam;
> +
> +out:
> +	/* kfree() accepts NULL. */
> +	kfree(init_vm);
> +	kfree(td_params);
> +	return ret;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -490,6 +696,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	mutex_lock(&kvm->lock);
>  
>  	switch (tdx_cmd.id) {
> +	case KVM_TDX_INIT_VM:
> +		r = tdx_td_init(kvm, &tdx_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index e78d72cf4c3a..1b950f98242e 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -2,6 +2,8 @@
>  #ifndef __KVM_X86_TDX_H
>  #define __KVM_X86_TDX_H
>  
> +#include "tdx_ops.h"
> +
>  #ifdef CONFIG_INTEL_TDX_HOST
>  struct kvm_tdx {
>  	struct kvm kvm;
> @@ -9,7 +11,11 @@ struct kvm_tdx {
>  	unsigned long tdr_pa;
>  	unsigned long *tdcs_pa;
>  
> +	u64 attributes;
> +	u64 xfam;
>  	int hkid;
> +
> +	u64 tsc_offset;
>  };
>  
>  struct vcpu_tdx {
> @@ -36,6 +42,20 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu
> *vcpu) {
>  	return container_of(vcpu, struct vcpu_tdx, vcpu);
>  }
> +
> +static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx,
> u32 field) +{
> +	struct tdx_module_output out;
> +	u64 err;
> +
> +	err = tdh_mng_rd(kvm_tdx->tdr_pa, TDCS_EXEC(field), &out);
> +	if (unlikely(err)) {
> +		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field,
> err);
> +		return 0;
> +	}
> +	return out.r8;
> +}
> +
>  #else
>  struct kvm_tdx {
>  	struct kvm kvm;
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h
> b/tools/arch/x86/include/uapi/asm/kvm.h index 04562740691b..eb800965b589
> 100644 --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -530,6 +530,7 @@ struct kvm_pmu_event_filter {
>  /* Trust Domain eXtension sub-ioctl() commands. */
>  enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };
> @@ -575,4 +576,36 @@ struct kvm_tdx_capabilities {
>  	struct kvm_tdx_cpuid_config cpuid_configs[0];
>  };
>  
> +struct kvm_tdx_init_vm {
> +	__u64 attributes;
> +	__u32 max_vcpus;
> +	__u32 padding;
> +	__u64 mrconfigid[6];    /* sha384 digest */
> +	__u64 mrowner[6];       /* sha384 digest */
> +	__u64 mrownerconfig[6]; /* sha348 digest */
> +	union {
> +		/*
> +		 * KVM_TDX_INIT_VM is called before vcpu creation, thus
> before
> +		 * KVM_SET_CPUID2.  CPUID configurations needs to be
> passed.
> +		 *
> +		 * This configuration supersedes KVM_SET_CPUID{,2}.
> +		 * The user space VMM, e.g. qemu, should make them
> consistent
> +		 * with this values.
> +		 * sizeof(struct kvm_cpuid_entry2) *
> KVM_MAX_CPUID_ENTRIES(256)
> +		 * = 8KB.
> +		 */
> +		struct {
> +			struct kvm_cpuid2 cpuid;
> +			/* 8KB with KVM_MAX_CPUID_ENTRIES. */
> +			struct kvm_cpuid_entry2 entries[];
> +		};
> +		/*
> +		 * For future extensibility.
> +		 * The size(struct kvm_tdx_init_vm) = 16KB.
> +		 * This should be enough given sizeof(TD_PARAMS) = 1024
> +		 */
> +		__u64 reserved[2028];
> +	};
> +};
> +
>  #endif /* _ASM_X86_KVM_H */

