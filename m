Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7495200F9
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 17:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbiEIPWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 11:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238216AbiEIPW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 11:22:27 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C87C222418;
        Mon,  9 May 2022 08:18:32 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 204so9717508pfx.3;
        Mon, 09 May 2022 08:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F11bJSvRSuvN/SHjhjFzW+byxtXfmKmWV2fVMaZadjE=;
        b=jrhn3l5skkXHzqFUIIOIPhiBGjU/roJkEjsIqzsQ7TmGeEYFvnzx24TRGBz6k27yyB
         vTJhvgztD2YbRJjiR7qQfWD2VE3CLe6jvVLb2yh8UA5OGprsSYOEkKdcBtUxS2iPV91B
         i8woZ8102iJaI8Y9sSxConAogpqIiHRTyFCNP1NUsLDTdvDhv1bbAqB0U3jYtn3PALn5
         hA6zF3t5bqQ5OTrWuKuV3tiZ4JaC74YhwX23HJ0hjNTKFCGtHO+g6JeYEohCfZargKBO
         Wv5qKeoZqBUt4UiE5CihCFz5QFYfvcQhloTqjN/o2YpauLWGsYVBmpjYQTHcl7G/lUjh
         e1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F11bJSvRSuvN/SHjhjFzW+byxtXfmKmWV2fVMaZadjE=;
        b=jvrVAtpZpeN+ydXtSMyyLlVt7UHprczZe83xJFqDWYr/n0F/wLlaqJgrLGKsocD7Dy
         xmxq+hXhmp1bBPOGAB8o06310bysPD38+6CYV1CPUis3y1mswNBWpnZ9K2jtdUTd9gLK
         jEKJCuDbGDUP0sq9uTNCATXnL8l1Jqbpd60YB+r5k5ee3fOj40FFZvmc0TnoFCiUDPES
         Pu3zCzJwwUE339EGKtaiuy4lEus6IM6yCuEnsqy5ujaKKAnqX3nuARDW0NCi0XJouc8u
         zRLSOVcGhCVnNg0Z19sOW9eq+R9SgTAHIdUBQXLPzT2CFoDAlN+KIQvlKDCvIAucvGdy
         xuSQ==
X-Gm-Message-State: AOAM532E3gHe51eGGTn9q/i/Hs9NNvYsCn27tfQE1QohG5k/u/X4CRps
        icp6LlfsgxfZGxGZnU6Erv4=
X-Google-Smtp-Source: ABdhPJwmmUun/L1C8pABLm/Uye5YTEf7HqZKeH6FteUGKdA7PmS8OHIKsZmclIVOAlkNYQggHuHEXw==
X-Received: by 2002:a63:7d4a:0:b0:398:dad:6963 with SMTP id m10-20020a637d4a000000b003980dad6963mr13588181pgn.329.1652109511555;
        Mon, 09 May 2022 08:18:31 -0700 (PDT)
Received: from localhost ([192.55.54.48])
        by smtp.gmail.com with ESMTPSA id 12-20020aa7910c000000b0050dc76281c4sm8693399pfh.158.2022.05.09.08.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:18:30 -0700 (PDT)
Date:   Mon, 9 May 2022 08:18:29 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [RFC PATCH v6 025/104] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20220509151829.GC2789321@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <fbc23565f7556e7b33227bcad95441195bb4758d.1651774250.git.isaku.yamahata@intel.com>
 <b3d587fd-1bf2-411c-96a9-6750e9aeefa2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b3d587fd-1bf2-411c-96a9-6750e9aeefa2@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:54:31PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 5/6/2022 2:14 AM, isaku.yamahata@intel.com wrote:
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
> > to make this cpuid config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h       |   2 +
> >   arch/x86/include/uapi/asm/kvm.h       |  33 +++++
> >   arch/x86/kvm/vmx/tdx.c                | 205 ++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/tdx.h                |  23 +++
> >   tools/arch/x86/include/uapi/asm/kvm.h |  33 +++++
> >   5 files changed, 296 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index e6f6f8c8619f..bc2038157f11 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1250,6 +1250,8 @@ struct kvm_arch {
> >   	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
> >   	 */
> >   	u32 max_vcpu_ids;
> > +
> > +	gfn_t gfn_shared_mask;
> >   };
> >   struct kvm_vm_stat {
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index ca85a070ac19..0f067fe7c186 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -532,6 +532,7 @@ struct kvm_pmu_event_filter {
> >   /* Trust Domain eXtension sub-ioctl() commands. */
> >   enum kvm_tdx_cmd_id {
> >   	KVM_TDX_CAPABILITIES = 0,
> > +	KVM_TDX_INIT_VM,
> >   	KVM_TDX_CMD_NR_MAX,
> >   };
> > @@ -577,4 +578,36 @@ struct kvm_tdx_capabilities {
> >   	struct kvm_tdx_cpuid_config cpuid_configs[0];
> >   };
> > +struct kvm_tdx_init_vm {
> > +	__u64 attributes;
> > +	__u32 max_vcpus;
> > +	__u32 tsc_khz;
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
> > +		__u64 reserved[2028];
> 
> I don't think it's a good idea to put the CPUID configs at the end of this
> structure and put it into a union.
> 
> 1. The union makes the Array of Length zero entries[] pointless.
> 2. It wastes memory that when new field to be added in the future, it has to
> be put after union instead of inside union.

Hmm, I checked this as there was a suggestion to do so.
I have to admit that it's ugly for future reserved area.  The options I can
think of are

A. add a pointer to struct kvm_cpuid2 (previous v5 patch)
B. this patch.
C. Add VM-scoped KVM_SET_CPUID2.
D. Discard arbitrary array kvm_cpu_id_entry2.
   Use TDX_MAX_NR_CPUID_CONFIGS(=37) only for TDX CPUID_CONFIGS.
   Add 0x80000008, 0xd which is needed to determine other values.

My preference is options A.
B. too ugly
C. overkill
D. In future we don't know which extra CPUID is needed.


> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index a4be3ef313b2..095ca7952114 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -438,6 +438,208 @@ int tdx_dev_ioctl(void __user *argp)
> >   	return 0;
> >   }
> > +#define TDX_CPUID_NO_INDEX	((u32)-1)
> 
> why do you bother introduing it in this version? I think we can use 0 for
> those leaves without significant index as previous versions.

This is how TDX CPUID_CONFIG defines it.  So I moved it the definitions to
header file and Added comment on it.


> > +static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> > +			struct kvm_tdx_init_vm *init_vm)
> > +{
> > +	const struct kvm_cpuid_entry2 *entry;
> > +	u64 guest_supported_xcr0;
> > +	u64 guest_supported_xss;
> > +	u32 guest_tsc_khz;
> > +	int max_pa;
> > +	int i;
> > +
> > +	td_params->max_vcpus = init_vm->max_vcpus;
> > +
> > +	td_params->attributes = init_vm->attributes;
> > +	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> > +		/*
> > +		 * TODO: save/restore PMU related registers around TDENTER.
> > +		 * Once it's done, remove this guard.
> > +		 */
> > +		pr_warn("TD doesn't support perfmon yet. KVM needs to save/restore "
> > +			"host perf registers properly.\n");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	for (i = 0; i < tdx_caps.nr_cpuid_configs; i++) {
> > +		const struct tdx_cpuid_config *config = &tdx_caps.cpuid_configs[i];
> > +		const struct kvm_cpuid_entry2 *entry =
> > +			tdx_find_cpuid_entry(init_vm, config->leaf, config->sub_leaf);
> > +		struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
> 
> why
> 
> 	if (!entry)
> 		continue;
> 
> get lost in this version?

Thanks for catching it. somehow it's lost.


> > +		value->eax = entry->eax & config->eax;
> > +		value->ebx = entry->ebx & config->ebx;
> > +		value->ecx = entry->ecx & config->ecx;
> > +		value->edx = entry->edx & config->edx;
> > +	}
> > +
> > +	max_pa = 36;
> > +	entry = tdx_find_cpuid_entry(init_vm, 0x80000008, TDX_CPUID_NO_INDEX);
> > +	if (entry)
> > +		max_pa = entry->eax & 0xff;
> > +
> > +	td_params->eptp_controls = VMX_EPTP_MT_WB;
> > +	/*
> > +	 * No CPU supports 4-level && max_pa > 48.
> > +	 * "5-level paging and 5-level EPT" section 4.1 4-level EPT
> > +	 * "4-level EPT is limited to translating 48-bit guest-physical
> > +	 *  addresses."
> > +	 * cpu_has_vmx_ept_5levels() check is just in case.
> > +	 */
> > +	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
> > +		td_params->eptp_controls |= VMX_EPTP_PWL_5;
> > +		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
> > +	} else {
> > +		td_params->eptp_controls |= VMX_EPTP_PWL_4;
> > +	}
> > +
> > +	/* Setup td_params.xfam */
> > +	entry = tdx_find_cpuid_entry(init_vm, 0xd, 0);
> > +	if (entry)
> > +		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
> > +	else
> > +		guest_supported_xcr0 = 0;
> > +	guest_supported_xcr0 &= supported_xcr0;
> > +
> > +	entry = tdx_find_cpuid_entry(init_vm, 0xd, 1);
> > +	if (entry)
> > +		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
> > +	else
> > +		guest_supported_xss = 0;
> > +	/* PT can be exposed to TD guest regardless of KVM's XSS support */
> > +	guest_supported_xss &= (supported_xss | XFEATURE_MASK_PT);
> > +
> > +	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
> > +	if (td_params->xfam & XFEATURE_MASK_LBR) {
> > +		/*
> > +		 * TODO: once KVM supports LBR(save/restore LBR related
> > +		 * registers around TDENTER), remove this guard.
> > +		 */
> > +		pr_warn("TD doesn't support LBR yet. KVM needs to save/restore "
> > +			"IA32_LBR_DEPTH properly.\n");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	if (td_params->xfam & XFEATURE_MASK_XTILE) {
> > +		/*
> > +		 * TODO: once KVM supports AMX(save/restore AMX related
> > +		 * registers around TDENTER), remove this guard.
> > +		 */
> > +		pr_warn("TD doesn't support AMX yet. KVM needs to save/restore "
> > +			"IA32_XFD, IA32_XFD_ERR properly.\n");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	if (init_vm->tsc_khz) {
> > +		guest_tsc_khz = init_vm->tsc_khz;
> > +		kvm->arch.default_tsc_khz = guest_tsc_khz;
> > +	} else
> > +		guest_tsc_khz = kvm->arch.default_tsc_khz;
> > +	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(guest_tsc_khz);
> > +
> > +#define MEMCPY_SAME_SIZE(dst, src)				\
> > +	do {							\
> > +		BUILD_BUG_ON(sizeof(dst) != sizeof(src));	\
> > +		memcpy((dst), (src), sizeof(dst));		\
> > +	} while (0)
> > +
> > +	MEMCPY_SAME_SIZE(td_params->mrconfigid, init_vm->mrconfigid);
> > +	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
> > +	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
> > +
> > +	return 0;
> > +}
> > +
> > +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	struct kvm_tdx_init_vm *init_vm = NULL;
> > +	struct td_params *td_params = NULL;
> > +	struct tdx_module_output out;
> > +	int ret;
> > +	u64 err;
> > +
> > +	BUILD_BUG_ON(sizeof(*init_vm) != 16 * 1024);
> > +	BUILD_BUG_ON((sizeof(*init_vm) - offsetof(typeof(*init_vm), entries)) /
> > +		     sizeof(init_vm->entries[0]) < KVM_MAX_CPUID_ENTRIES);
> > +	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
> > +
> > +	if (is_td_initialized(kvm))
> > +		return -EINVAL;
> > +
> > +	if (cmd->flags)
> > +		return -EINVAL;
> > +
> > +	init_vm = kzalloc(sizeof(*init_vm), GFP_KERNEL);
> > +	if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {
> > +		ret = -EFAULT;
> > +		goto out;
> > +	}
> > +
> > +	if (init_vm->max_vcpus > KVM_MAX_VCPUS) {
> > +		ret = -EINVAL;
> > +		goto out;
> > +	}
> > +
> > +	if (tdx_caps.nr_cpuid_configs > KVM_MAX_CPUID_ENTRIES) {
> > +		/* tdx_caps.nr_cpuis_configs should be smaller. */
> > +		pr_warn("too large nr_cpuid_configs\n");
> > +		ret = -E2BIG;
> > +		goto out;
> > +	}
> 
> No need to validate tdx_caps.nr_cpuid_configs here. It should and already
> has been validated when tdx_caps is setting up in tdx_module_setup()

Will drop it.


Here is the update diff. I didn't addressed an issue of kvm_cpuid_entry2 yet.


diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 03ee6dcac06f..0e8ab52a0bb3 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -92,6 +92,8 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 
 #ifdef CONFIG_INTEL_TDX_HOST
 
+/* -1 indicates CPUID leaf with no sub-leaves. */
+#define TDX_CPUID_NO_SUBLEAF	((u32)-1)
 struct tdx_cpuid_config {
 	u32	leaf;
 	u32	sub_leaf;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index f058eab57c32..469f3fb98e10 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -584,7 +584,7 @@ struct kvm_tdx_capabilities {
 struct kvm_tdx_init_vm {
 	__u64 attributes;
 	__u32 max_vcpus;
-	__u32 tsc_khz;
+	__u32 padding;
 	__u64 mrconfigid[6];	/* sha384 digest */
 	__u64 mrowner[6];	/* sha384 digest */
 	__u64 mrownerconfig[6];	/* sha348 digest */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 63f3b83b228e..9b28337b55f1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -597,6 +597,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.apic)
 		return -EINVAL;
 
+	fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	vcpu->arch.apic->guest_apic_protected = true;
 	INIT_LIST_HEAD(&tdx->pi_wakeup_list);
 
@@ -2394,7 +2395,11 @@ int tdx_dev_ioctl(void __user *argp)
 	return 0;
 }
 
-#define TDX_CPUID_NO_INDEX	((u32)-1)
+/*
+ * cpuid entry lookup in TDX cpuid config way.
+ * The difference is how to specify index(subleaves).
+ * Specify index to TDX_CPUID_NO_SUBLEAF for CPUID leaf with no-subleaves.
+ */
 static const struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(
 	const struct kvm_tdx_init_vm *init_vm, u32 function, u32 index)
 {
@@ -2405,7 +2410,8 @@ static const struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(
 
 		if (e->function == function &&
 		    (e->index == index ||
-		     !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
+		     (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) &&
+		      index == TDX_CPUID_NO_SUBLEAF)))
 			return e;
 	}
 	return NULL;
@@ -2417,7 +2423,6 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	const struct kvm_cpuid_entry2 *entry;
 	u64 guest_supported_xcr0;
 	u64 guest_supported_xss;
-	u32 guest_tsc_khz;
 	int max_pa;
 	int i;
 
@@ -2440,6 +2445,9 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 			tdx_find_cpuid_entry(init_vm, config->leaf, config->sub_leaf);
 		struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
 
+		if (!entry)
+			continue;
+
 		value->eax = entry->eax & config->eax;
 		value->ebx = entry->ebx & config->ebx;
 		value->ecx = entry->ecx & config->ecx;
@@ -2447,7 +2455,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	}
 
 	max_pa = 36;
-	entry = tdx_find_cpuid_entry(init_vm, 0x80000008, TDX_CPUID_NO_INDEX);
+	entry = tdx_find_cpuid_entry(init_vm, 0x80000008, TDX_CPUID_NO_SUBLEAF);
 	if (entry)
 		max_pa = entry->eax & 0xff;
 
@@ -2494,12 +2502,8 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 		return -EOPNOTSUPP;
 	}
 
-	if (init_vm->tsc_khz) {
-		guest_tsc_khz = init_vm->tsc_khz;
-		kvm->arch.default_tsc_khz = guest_tsc_khz;
-	} else
-		guest_tsc_khz = kvm->arch.default_tsc_khz;
-	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(guest_tsc_khz);
+	td_params->tsc_frequency =
+		TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
 
 #define MEMCPY_SAME_SIZE(dst, src)				\
 	do {							\
@@ -2545,13 +2549,6 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 		goto out;
 	}
 
-	if (tdx_caps.nr_cpuid_configs > KVM_MAX_CPUID_ENTRIES) {
-		/* tdx_caps.nr_cpuis_configs should be smaller. */
-		pr_warn("too large nr_cpuid_configs\n");
-		ret = -E2BIG;
-		goto out;
-	}
-
 	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
 	if (!td_params) {
 		ret = -ENOMEM;


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
