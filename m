Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED685712D2
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 09:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiGLHLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 03:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiGLHLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 03:11:37 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67DD275DE;
        Tue, 12 Jul 2022 00:11:36 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x184so6753784pfx.2;
        Tue, 12 Jul 2022 00:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=36QpzK/RLMwVL3iIGsDgJ6InsJXS/K/2EfpSQVCK3ng=;
        b=oRPYwbu4peS6xoWNYL0Hx5E08NIYXjf5EXhVGKhfsDadMmx7OiDqMhIGbJEqSGi6K6
         DKXB/T15o/lVgQPIgoBQnvxoDxzdW29Cd231MgO2kHAc7u1INJVv+nQw+yYAhn9lYSP5
         Z+5unLnFAf2Cpr2ju7Nss2hki8p7Txl46fOWcwaOhuF8ChQdMdBD0Os2PCdplKtIpQLD
         eHzldbZpb5sqeJYUPteRE/Tie3aqISqk69Ry7+zY5+FSc7Q55Lzvb6+yhBNvIffAUfyw
         CgsVITkmAvroFcE7vRx3gGrx//X8+MJ3jlqCIvfs5VX3XjiepaFHjjx4StQDbtr9rI+P
         VJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=36QpzK/RLMwVL3iIGsDgJ6InsJXS/K/2EfpSQVCK3ng=;
        b=SZLQrk0+5dfap53o/U5odvOCMECXrY18L69vXklmzBp6J5ykgTJI7QMTZqA3AOE9yE
         dLFkfmbE0+OSJYZvyoso9A1xwYqPOLqtOUDedrkK6ssny21F17yN75KPzdNkpjeNrCvf
         PLStO9KKwp3hu0WU3YTjorMd7l8WgKFH5TBMGYWELviUi0gTa977hfhvpwdeuPBCkLHf
         LuuUq0Ks3kW2KYShyqQcFUVUaRMf1qdUFSQ5X1tzT7WlP8NNQMNLH0WBG91Cy3I5ub4z
         SPwMByMGedYP3yIc3Cw6L2kWaZx/Jc6Qn8Fw643dvScd05x7tjZdABCbrdN0lbcbfYI9
         fdug==
X-Gm-Message-State: AJIora8piYJIQ6sZd9HOJgR9hLbaP80TxP1YCV1BZl7rmlmneWUK0jZn
        CcTyp2IWN83f+3ob3eBhTac=
X-Google-Smtp-Source: AGRyM1t1Y309cOO4YyTQyLM8N5hAOot3fPML+U7ZTJ52UuSyO8srhaIF3ji6unLsytrR0qkXwBqlpQ==
X-Received: by 2002:a63:3cd:0:b0:415:f76d:fb4 with SMTP id 196-20020a6303cd000000b00415f76d0fb4mr8821269pgd.587.1657609895912;
        Tue, 12 Jul 2022 00:11:35 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id j6-20020a634a46000000b0040cfb5151fcsm5336425pgl.74.2022.07.12.00.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:11:35 -0700 (PDT)
Date:   Tue, 12 Jul 2022 00:11:34 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 025/102] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20220712071134.GH1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <cb901b3a0eb475d7a33507318c1ba95120fc425e.1656366338.git.isaku.yamahata@intel.com>
 <dd6a51df-995c-6793-3988-b096188cd447@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dd6a51df-995c-6793-3988-b096188cd447@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 04:30:53PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 6/28/2022 5:53 AM, isaku.yamahata@intel.com wrote:
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
> >   arch/x86/include/asm/tdx.h            |   3 +
> >   arch/x86/include/uapi/asm/kvm.h       |  33 +++++
> >   arch/x86/kvm/vmx/tdx.c                | 206 ++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/tdx.h                |  23 +++
> >   tools/arch/x86/include/uapi/asm/kvm.h |  33 +++++
> >   6 files changed, 300 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 342decc69649..81638987cdb9 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1338,6 +1338,8 @@ struct kvm_arch {
> >   	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
> >   	 */
> >   	u32 max_vcpu_ids;
> > +
> > +	gfn_t gfn_shared_mask;
> 
> I think it's better to put in a seperate patch or the patch that consumes
> it.
> 
> >   };
> ...
> 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 2a9dfd54189f..1273b60a1a00 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -438,6 +438,209 @@ int tdx_dev_ioctl(void __user *argp)
> >   	return 0;
> >   }
> > +/*
> > + * cpuid entry lookup in TDX cpuid config way.
> > + * The difference is how to specify index(subleaves).
> > + * Specify index to TDX_CPUID_NO_SUBLEAF for CPUID leaf with no-subleaves.
> > + */
> > +static const struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(
> > +	const struct kvm_cpuid2 *cpuid, u32 function, u32 index)
> > +{
> > +	int i;
> > +
> > +
> 
> superfluous line
> 
> > +	/* In TDX CPU CONFIG, TDX_CPUID_NO_SUBLEAF means index = 0. */
> > +	if (index == TDX_CPUID_NO_SUBLEAF)
> > +		index = 0;
> > +
> > +	for (i = 0; i < cpuid->nent; i++) {
> > +		const struct kvm_cpuid_entry2 *e = &cpuid->entries[i];
> > +
> > +		if (e->function == function &&
> > +		    (e->index == index ||
> > +		     !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
> > +			return e;
> > +	}
> > +	return NULL;
> > +}
> 
> no need for kvm_tdx->tsc_khz field. We have kvm->arch.default_tsc_khz.
> It seems kvm_tdx->tsc_khz is not used in the following patches.
> 
> ...
> 
> > +
> > +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> > +	kvm_tdx->attributes = td_params->attributes;
> > +	kvm_tdx->xfam = td_params->xfam;
> > +	kvm_tdx->tsc_khz = TDX_TSC_25MHZ_TO_KHZ(td_params->tsc_frequency);
> > +	kvm->max_vcpus = td_params->max_vcpus;
> > +
> > +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> > +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
> > +	else
> > +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
> > +
> 
> ....
> 
> > diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> > index a9ea3573be1b..779dfd683d66 100644
> > --- a/tools/arch/x86/include/uapi/asm/kvm.h
> > +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> > @@ -531,6 +531,7 @@ struct kvm_pmu_event_filter {
> >   /* Trust Domain eXtension sub-ioctl() commands. */
> >   enum kvm_tdx_cmd_id {
> >   	KVM_TDX_CAPABILITIES = 0,
> > +	KVM_TDX_INIT_VM,
> >   	KVM_TDX_CMD_NR_MAX,
> >   };
> > @@ -576,4 +577,36 @@ struct kvm_tdx_capabilities {
> >   	struct kvm_tdx_cpuid_config cpuid_configs[0];
> >   };
> > +struct kvm_tdx_init_vm {
> > +	__u64 attributes;
> > +	__u32 max_vcpus;
> > +	__u32 tsc_khz;
> 
> it needs to align with arch/x86/include/uapi/asm/kvm.h that @tsc_khz needs
> to be removed.

Thanks, I fixed this patch as follows.


diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 81638987cdb9..342decc69649 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1338,8 +1338,6 @@ struct kvm_arch {
         * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
         */
        u32 max_vcpu_ids;
-
-       gfn_t gfn_shared_mask;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 190b77f9cdd1..570127d4e566 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -441,7 +441,6 @@ static const struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(
 {
        int i;
 
-
        /* In TDX CPU CONFIG, TDX_CPUID_NO_SUBLEAF means index = 0. */
        if (index == TDX_CPUID_NO_SUBLEAF)
                index = 0;
@@ -619,7 +618,6 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
        kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
        kvm_tdx->attributes = td_params->attributes;
        kvm_tdx->xfam = td_params->xfam;
-       kvm_tdx->tsc_khz = TDX_TSC_25MHZ_TO_KHZ(td_params->tsc_frequency);
        kvm->max_vcpus = td_params->max_vcpus;
 
        if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 8a0793fcc3ab..3e5782438dc9 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -25,7 +25,6 @@ struct kvm_tdx {
        int hkid;
 
        u64 tsc_offset;
-       unsigned long tsc_khz;
 };
 
 struct vcpu_tdx {
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 18654ba2ee87..965a1c2e347d 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -581,7 +581,7 @@ struct kvm_tdx_capabilities {
 struct kvm_tdx_init_vm {
        __u64 attributes;
        __u32 max_vcpus;
-       __u32 tsc_khz;
+       __u32 padding;
        __u64 mrconfigid[6];    /* sha384 digest */
        __u64 mrowner[6];       /* sha384 digest */
        __u64 mrownerconfig[6]; /* sha348 digest */
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
