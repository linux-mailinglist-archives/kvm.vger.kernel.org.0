Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FDD6C89CE
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 02:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjCYBMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 21:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjCYBMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 21:12:06 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BB3196AC;
        Fri, 24 Mar 2023 18:12:04 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k2so3395799pll.8;
        Fri, 24 Mar 2023 18:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679706723;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KDRsEzG2Gk9MVUw3sxbw395ksH9vrtegGd0MF8IuTp0=;
        b=Brbfd01VH/Aqm3LRGBm6H/CwQe+gekjCCqXgm64Ozg8Wh2iFRoYenX8cmH7fUhhWrB
         EUWvcsxuy8PXfGfQ3qZkDo82kQLfcdj4hfWmKMhYqtZ0uB9b2hTByiVcGClV4QrKI+0h
         5IEeMBqDrTrRZc/WrSHbDLCk77ERcXIzl5Ww2cC/qNX7e6UVb0wGrd+dmFqP1FvcDxCc
         vH5Qxr/bDFIERpPufFFFu0Ocbb5UA3I98VFB9w7umf11S7cFSGay+xzp4P6brWSIA6SQ
         0XNe9Y73p3kKSZUaEcfOQ1ioAtD4EILIOTES4C0zZ/WedUfjWnQq70qBt8rRDt820Ier
         JnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679706723;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KDRsEzG2Gk9MVUw3sxbw395ksH9vrtegGd0MF8IuTp0=;
        b=Xpfp4wkDZHK9bEJ8HTaS0qflhF+WGfTyiDS3wo9pLpN2t+1cx0dyaLrH4K0l0EFFRs
         F1NTgwVlY2xU56QfSLRGcxrdCqYUK77+hIGLD4hJbNi3YZlBKkXoeY385bDie+DNT1PZ
         Ed8MZ4NBDo36znmWz+c+zs+ep9DBerVPywSuw+kZK3XR/kRag8XaFksCT3H0uXwA0pID
         Bg/Jf7xK73i379GGT32sEBkhUsNex12gyCDmHExAEhHaKkT+nD0xiHwX5p4fnlWx9iRh
         jD7zwcQiIPkY8e0StSmQ2FKl0JAqYhIKYwLa9Se4Ws/rAlL3Sl1lmicla80DKBs8TH0p
         +i8A==
X-Gm-Message-State: AAQBX9ejW+xoSpmt+iGCbqMDXF90H9+f5kDgkPsG3r3JTcaaLF9FQ8Bp
        YX6hSnBqTqmBvfODtLm0FeY=
X-Google-Smtp-Source: AKy350Z06rgw09P8p9ZsWJIkVfksVckS3SRti5wDZ0Xr4+3/k0zqqKodOZ1fram+KVsPx4oi7y3Zqw==
X-Received: by 2002:a17:902:ec8c:b0:19e:8566:ea86 with SMTP id x12-20020a170902ec8c00b0019e8566ea86mr5299020plg.62.1679706723237;
        Fri, 24 Mar 2023 18:12:03 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id x5-20020a1709028ec500b001a04d37a4acsm14827032plo.9.2023.03.24.18.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 18:12:02 -0700 (PDT)
Date:   Fri, 24 Mar 2023 18:12:00 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v13 057/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Message-ID: <20230325011200.GB214881@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <cbfaedb652dad85f4020a2dcd74ac4abb5c14ac5.1678643052.git.isaku.yamahata@intel.com>
 <b3198a621a39d4c277ddf540e7a492953dc3637d.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3198a621a39d4c277ddf540e7a492953dc3637d.camel@intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 10:38:02AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sun, 2023-03-12 at 10:56 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Because TDX virtualize cpuid[0x1].EDX[MTRR: bit 12] to fixed 1, guest TD
> > thinks MTRR is supported.  Although TDX supports only WB for private GPA,
> > it's desirable to support MTRR for shared GPA.  As guest access to MTRR
> > MSRs causes #VE and KVM/x86 tracks the values of MTRR MSRs, the remining
> > part is to implement get_mt_mask method for TDX for shared GPA.
> > 
> > Pass around shared bit from kvm fault handler to get_mt_mask method so that
> > it can determine if the gfn is shared or private.  
> > 
> 
> I think we have an Xarray to query whether a given GFN is shared or private?
> Can we use that?
> 
> > Implement get_mt_mask()
> > following vmx case for shared GPA and return WB for private GPA.
> > the existing vmx_get_mt_mask() can't be directly used as CPU state(CR0.CD)
> > is protected.  GFN passed to kvm_mtrr_check_gfn_range_consistency() should
> > include shared bit.
> > 
> > Suggested-by: Kai Huang <kai.huang@intel.com>
> 
> I am not sure what is suggested by me?
> 
> I thought what I suggested is we should have a dedicated patch to handle MTRR
> for TDX putting all related things together.

Sure. After looking at the specs, my conclusion is that guest TD can't update
MTRR reliably.  Because MTRR update requires to disable cache(CR0.CR=1), cache
flush, and tlb flush. (SDM 3a 12.11.7: MTRR maintenance programming interface)
Linux implements MTRR update logic according to it.

While TDX enforces CR0.CD=0, trying to set CR0.CD=1 results in #GP.  At the
same time, it reports that MTRR is available via cpuid.  So I come up with the
followings.

- MTRRCap(RO): report no feature available
  SMRR=0: SMRR interface unsupported
  WC=0: write combining unsupported
  FIX=0: Fixed range registers unsupported
  VCNT=0: number of variable range regitsers = 0

- MTRRDefType(R/W): Only writeback even with reset state.
  E=1: enable MTRR (E=0 means all memory is UC.)
  FE=0: disable fixed range MTRRs
  type: default memory type=writeback
  Accept write this value. Other value results in #GP.

- Fixed range MTRR
  #GP as fixed range MTRRs is reported as unsupported

- Variable range MTRRs
  #GP as the number of variable range MTRRs is reported as zero
 

> > +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > +{
> > +	/* TDX private GPA is always WB. */
> > +	if (!(gfn & kvm_gfn_shared_mask(vcpu->kvm))) {
> > +		/* MMIO is only for shared GPA. */
> > +		WARN_ON_ONCE(is_mmio);
> > +		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> > +	}
> > +
> > +	/* Drop shared bit as MTRR doesn't know about shared bit. */
> > +	gfn = kvm_gfn_to_private(vcpu->kvm, gfn);
> > +
> > +	/* As TDX enforces CR0.CD to 0, pass check_cr0_cd = false. */
> > +	return __vmx_get_mt_mask(vcpu, gfn, is_mmio, false);
> > +}
> 
> 
> Do you know whether there's any use case of non-coherent device assignment to
> TDX guest?
> 
> IMHO, we should just disallow TDX guest to support non-coherent device
> assignment, so that we can just return WB for both private and shared.
> 
> If we support non-coherent device assignment, then if guest sets private memory
> to non-WB memory, it believes the memory type is non-WB, but in fact TDX always
> map private memory as WB.
> 
> Will this be a problem, i.e. if assigned device can DMA to private memory
> directly in the future?

MTRR is legacy feature and PAT replaced it.  We can rely on guest to use PAT.
Here is the new patch for MTRR.

--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -229,6 +229,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
+static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_get_mt_mask(vcpu, gfn, is_mmio);
+
+	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -349,7 +357,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_mt_mask = vmx_get_mt_mask,
+	.get_mt_mask = vt_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
 
diff -u b/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
--- b/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -347,6 +347,25 @@
 	return 0;
 }
 
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	/* TDX private GPA is always WB. */
+	if (!(gfn & kvm_gfn_shared_mask(vcpu->kvm))) {
+		/* MMIO is only for shared GPA. */
+		WARN_ON_ONCE(is_mmio);
+		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+	}
+
+	if (is_mmio)
+		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+
+	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
+		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+
+	/* TDX enforces CR0.CD = 0 and KVM MTRR emulation enforces writeback. */
+	return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+}
+
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -1256,6 +1275,45 @@
 	return ret;
 }
 
+static int tdx_vcpu_init_mtrr(struct kvm_vcpu *vcpu)
+{
+	struct msr_data msr;
+	int ret;
+	int i;
+
+	/*
+	 * To avoid confusion with reporting VNCT = 0, explicitly disable
+	 * vaiale-range reisters.
+	 */
+	for (i = 0; i < KVM_NR_VAR_MTRR; i++) {
+		/* phymask */
+		msr = (struct msr_data) {
+			.host_initiated = true,
+			.index = 0x200 + 2 * i + 1,
+			.data = 0,	/* valid = 0 to disable. */
+		};
+		ret = kvm_set_msr_common(vcpu, &msr);
+		if (ret)
+			return -EINVAL;
+	}
+
+	/* Set MTRR to use writeback on reset. */
+	msr = (struct msr_data) {
+		.host_initiated = true,
+		.index = MSR_MTRRdefType,
+		/*
+		 * Set E(enable MTRR)=1, FE(enable fixed range MTRR)=0, default
+		 * type=writeback on reset to avoid UC.  Note E=0 means all
+		 * memory is UC.
+		 */
+		.data = (1 << 11) | MTRR_TYPE_WRBACK,
+	};
+	ret = kvm_set_msr_common(vcpu, &msr);
+	if (ret)
+		return -EINVAL;
+	return 0;
+}
+
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 {
 	struct msr_data apic_base_msr;
@@ -1293,6 +1351,10 @@
 	if (kvm_set_apic_base(vcpu, &apic_base_msr))
 		return -EINVAL;
 
+	ret = tdx_vcpu_init_mtrr(vcpu);
+	if (ret)
+		return ret;
+
 	ret = tdx_td_vcpu_init(vcpu, (u64)cmd.data);
 	if (ret)
 		return ret;
@@ -1676,7 +1738,9 @@
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_ARCH_CAPABILITIES:
 	case MSR_IA32_POWER_CTL:
+	case MSR_MTRRcap:
 	case MSR_IA32_CR_PAT:
+	case MSR_MTRRdefType:
 	case MSR_IA32_TSC_DEADLINE:
 	case MSR_IA32_MISC_ENABLE:
 	case MSR_PLATFORM_INFO:
@@ -1718,16 +1782,47 @@
 
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
-	if (tdx_has_emulated_msr(msr->index, false))
-		return kvm_get_msr_common(vcpu, msr);
-	return 1;
+	switch (msr->index) {
+	case MSR_MTRRcap:
+		/*
+		 * Override kvm_mtrr_get_msr() which hardcodes the value.
+		 * Report SMRR = 0, WC = 0, FIX = 0 VCNT = 0 to disable MTRR
+		 * effectively.
+		 */
+		msr->data = 0;
+		return 0;
+	default:
+		if (tdx_has_emulated_msr(msr->index, false))
+			return kvm_get_msr_common(vcpu, msr);
+		return 1;
+	}
 }
 
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
-	if (tdx_has_emulated_msr(msr->index, true))
+	switch (msr->index) {
+	case MSR_MTRRdefType:
+		/*
+		 * Allow writeback only for all memory.
+		 * Because it's reported that fixed range MTRR isn't supported
+		 * and VCNT=0, enforce MTRRDefType.FE = 0 and don't care
+		 * variable range MTRRs. Only default memory type matters.
+		 *
+		 * bit 11 E: MTRR enable/disable
+		 * bit 12 FE: Fixed-range MTRRs enable/disable
+		 * (E, FE) = (1, 1): enable MTRR and Fixed range MTRR
+		 * (E, FE) = (1, 0): enable MTRR, disable Fixed range MTRR
+		 * (E, FE) = (0, *): disable all MTRRs.  all physical memory
+		 *                   is UC
+		 */
+		if (msr->data != ((1 << 11) | MTRR_TYPE_WRBACK))
+			return 1;
 		return kvm_set_msr_common(vcpu, msr);
-	return 1;
+	default:
+		if (tdx_has_emulated_msr(msr->index, true))
+			return kvm_set_msr_common(vcpu, msr);
+		return 1;
+	}
 }
 
 int tdx_dev_ioctl(void __user *argp)
unchanged:
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -152,6 +152,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -176,6 +177,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 



-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
