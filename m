Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7ACC570E6A
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 01:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiGKXtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 19:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGKXs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 19:48:59 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CB9205EA;
        Mon, 11 Jul 2022 16:48:56 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so6334700pjl.4;
        Mon, 11 Jul 2022 16:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y6W9c+jiyrLTRsVzAt5WTPE8bjAK8VJBjzuZr5IC2xg=;
        b=pTYxaaMyHAMLu0eeT5adtz0YNEZ7/2rJbfSJPoLAkBmhgzduntxpQ9ZVGgeGlCKGRu
         WAdlUSRC+3UUWU4BIQtzFhM8pS/6M1xmgCT7JCd2FO+2au7vh6T4k+xB4gxlUJT0cT4W
         K28V6FQG9edxvdXQPSSC9A/WOp5FmfTmScQg6aZc9JarQcuXbD+yTQFvgg3/vHwYL1cu
         h8nXITXaU3JOCbmKsYuIhVEqHsrjou38EYTPSCmENPBgwWxeAHr3N1dR7mMViX73Q2h8
         TPVjjlk4BDY3X3SLs92/XQAvHmw6rRoZe8uNlGf2PHDb+71eqOP7ZmrR4XcfWTQRMJfX
         Ozgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y6W9c+jiyrLTRsVzAt5WTPE8bjAK8VJBjzuZr5IC2xg=;
        b=J+brrCAS+rs7sraXhYLLrzTYt/etugKS2XQ4ezUumtuV/9QyESS6LXEZ7HeYN2BW4T
         rPOlxU0v9da4AarcdJhLSLFH+ao97t1O2ma2N0CzoKoIXEO+FdTS9b2caERz+ROssUip
         5f7/R4Y7pTxFVFmjw67EunFGQHRgzr/haTKRvuvaw0ovIiqx1tPcntbltNBgov3RazP7
         febme65p60Hc474aQxqF9qKwb1w7SVNV+iGFshdqMbP5FvosMNG2axrx+axnqN3uJW1S
         3eoWIarmh/MFp2BGknD/tcml50uWGFn02BClA6MjFgHmBoosDtGn7roitQo4VG5VcV8k
         SspA==
X-Gm-Message-State: AJIora8aV98z7eL235nbslhbhLF9fG2cg+IfKfbNUFeXZo+hqh1FHxsQ
        q8LdVbj6Ecu2+5qeKHo/HJl7DtuePxs=
X-Google-Smtp-Source: AGRyM1u728QZwDiB+PGF3jSOU9Lqdm8HdeXx95WX+9E7Q0MZyU1EI2I7r+o5RabHK8X9HSTAmqPxKQ==
X-Received: by 2002:a17:90b:3505:b0:1ec:db5d:794b with SMTP id ls5-20020a17090b350500b001ecdb5d794bmr1019041pjb.24.1657583336041;
        Mon, 11 Jul 2022 16:48:56 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id q11-20020aa7982b000000b005289fad1bbesm5480721pfl.94.2022.07.11.16.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 16:48:55 -0700 (PDT)
Date:   Mon, 11 Jul 2022 16:48:53 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 006/102] KVM: TDX: Detect CPU feature on kernel module
 initialization
Message-ID: <20220711234853.GA1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <85209122d5af1a3185ff58d13528284d91035100.1656366338.git.isaku.yamahata@intel.com>
 <e1d91a805be75384e9caa76f4196a2feb4709dc1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e1d91a805be75384e9caa76f4196a2feb4709dc1.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 03:43:00PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:52 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX requires several initialization steps for KVM to create guest TDs.
> > Detect CPU feature, enable VMX (TDX is based on VMX), detect TDX module
> > availability, and initialize TDX module.  This patch implements the first
> > step to detect CPU feature.  Because VMX isn't enabled yet by VMXON
> > instruction on KVM kernel module initialization, defer further
> > initialization step until VMX is enabled by hardware_enable callback.
> 
> Not clear why you need to split into multiple patches.  If we put all
> initialization into one patch, it's much easier to see why those steps are done
> in whatever way.

I moved down this patch before "KVM: TDX: Initialize TDX module when loading
kvm_intel.ko". So the patch flow is, - detect tdx cpu feature, and then
- initialize tdx module.


> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > new file mode 100644
> > index 000000000000..c12e61cdddea
> > --- /dev/null
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -0,0 +1,40 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/cpu.h>
> > +
> > +#include <asm/tdx.h>
> > +
> > +#include "capabilities.h"
> > +#include "x86_ops.h"
> > +
> > +#undef pr_fmt
> > +#define pr_fmt(fmt) "tdx: " fmt
> > +
> > +static u64 hkid_mask __ro_after_init;
> > +static u8 hkid_start_pos __ro_after_init;
> > +
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > +{
> > +	u32 max_pa;
> > +
> > +	if (!enable_ept) {
> > +		pr_warn("Cannot enable TDX with EPT disabled\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!platform_tdx_enabled()) {
> > +		pr_warn("Cannot enable TDX on TDX disabled platform\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	/* Safe guard check because TDX overrides tlb_remote_flush callback. */
> > +	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
> > +		return -EIO;
> 
> To me it's better to move this chunk to the patch which actually implements how
> to flush TLB foro private pages.  W/o some background, it's hard to tell why TDX
> needs to overrides tlb_remote_flush callback.  Otherwise it's quite hard to
> review here.
> 
> For instance, even if it must be replaced, I am wondering why it must be empty
> at the beginning?  For instance, assuming it has an original version which does
> something:
> 
> 	x86_ops->tlb_remote_flush = vmx_remote_flush;
> 
> Why cannot it be replaced with vt_tlb_remote_flush():
> 
> 	int vt_tlb_remote_flush(struct kvm *kvm)
> 	{
> 		if (is_td(kvm))
> 			return tdx_tlb_remote_flush(kvm);
> 
> 		return vmx_remote_flush(kvm);
> 	}
> 
> ?

There is a bit tricky part.  Anyway I rewrote to follow this way.  Here is a
preparation patch to allow such direction.

Subject: [PATCH 055/290] KVM: x86/VMX: introduce vmx tlb_remote_flush and
 tlb_remote_flush_with_range

This is preparation for TDX to define its own tlb_remote_flush and
tlb_remote_flush_with_range.  Currently vmx code defines tlb_remote_flush
and tlb_remote_flush_with_range defined as NULL by default and only when
nested hyper-v guest case, they are defined to non-NULL methods.

To make TDX code to override those two methods consistently with other
methods, define vmx_tlb_remote_flush and vmx_tlb_remote_flush_with_range
as nop and call hyper-v code only when nested hyper-v guest case.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/kvm_onhyperv.c     |  5 ++++-
 arch/x86/kvm/kvm_onhyperv.h     |  1 +
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/svm/svm_onhyperv.h |  1 +
 arch/x86/kvm/vmx/main.c         |  2 ++
 arch/x86/kvm/vmx/vmx.c          | 34 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/x86_ops.h      |  3 +++
 7 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index ee4f696a0782..d43518da1c0e 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -93,11 +93,14 @@ int hv_remote_flush_tlb(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(hv_remote_flush_tlb);
 
+bool hv_use_remote_flush_tlb __ro_after_init;
+EXPORT_SYMBOL_GPL(hv_use_remote_flush_tlb);
+
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
 	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
 
-	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
+	if (hv_use_remote_flush_tlb) {
 		spin_lock(&kvm_arch->hv_root_tdp_lock);
 		vcpu->arch.hv_root_tdp = root_tdp;
 		if (root_tdp != kvm_arch->hv_root_tdp)
diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 287e98ef9df3..9a07a34666fb 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -10,6 +10,7 @@
 int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 		struct kvm_tlb_range *range);
 int hv_remote_flush_tlb(struct kvm *kvm);
+extern bool hv_use_remote_flush_tlb __ro_after_init;
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
 #else /* !CONFIG_HYPERV */
 static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ef925722ee28..a11c78c8831b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -264,7 +264,7 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 {
 	int ret = -ENOTSUPP;
 
-	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
+	if (range && kvm_available_flush_tlb_with_range())
 		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
 
 	if (ret)
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index e2fc59380465..b3cd61c62305 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -36,6 +36,7 @@ static inline void svm_hv_hardware_setup(void)
 		svm_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
 		svm_x86_ops.tlb_remote_flush_with_range =
 				hv_remote_flush_tlb_with_range;
+		hv_use_remote_flush_tlb = true;
 	}
 
 	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 252b7298b230..e52e12b8d49a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -187,6 +187,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.flush_tlb_all = vmx_flush_tlb_all,
 	.flush_tlb_current = vmx_flush_tlb_current,
+	.tlb_remote_flush = vmx_tlb_remote_flush,
+	.tlb_remote_flush_with_range = vmx_tlb_remote_flush_with_range,
 	.flush_tlb_gva = vmx_flush_tlb_gva,
 	.flush_tlb_guest = vmx_flush_tlb_guest,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5b8d399dd319..dc7ede3706e1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3110,6 +3110,33 @@ void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
+int vmx_tlb_remote_flush(struct kvm *kvm)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (hv_use_tlb_remote_flush)
+		return hv_remote_flush_tlb(kvm);
+#endif
+	/*
+	 * fallback to KVM_REQ_TLB_FLUSH.
+	 * See kvm_arch_flush_remote_tlb() and kvm_flush_remote_tlbs().
+	 */
+	return -EOPNOTSUPP;
+}
+
+int vmx_tlb_remote_flush_with_range(struct kvm *kvm,
+				    struct kvm_tlb_range *range)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (hv_use_tlb_remote_flush)
+		return hv_remote_flush_tlb_with_range(kvm, range);
+#endif
+	/*
+	 * fallback to tlb_remote_flush. See
+	 * kvm_flush_remote_tlbs_with_range()
+	 */
+	return -EOPNOTSUPP;
+}
+
 void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
@@ -8176,11 +8203,8 @@ __init int vmx_hardware_setup(void)
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
-	    && enable_ept) {
-		vt_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
-		vt_x86_ops.tlb_remote_flush_with_range =
-				hv_remote_flush_tlb_with_range;
-	}
+	    && enable_ept)
+		hv_use_tlb_remote_flush = true;
 #endif
 
 	if (!cpu_has_vmx_ple()) {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index e70f84d29d21..5ecf99170b30 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -90,6 +90,9 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 bool vmx_get_if_flag(struct kvm_vcpu *vcpu);
 void vmx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void vmx_flush_tlb_current(struct kvm_vcpu *vcpu);
+int vmx_tlb_remote_flush(struct kvm *kvm);
+int vmx_tlb_remote_flush_with_range(struct kvm *kvm,
+				    struct kvm_tlb_range *range);
 void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr);
 void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu);
 void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask);
-- 
2.25.1


> > +
> > +	max_pa = cpuid_eax(0x80000008) & 0xff;
> > +	hkid_start_pos = boot_cpu_data.x86_phys_bits;
> > +	hkid_mask = GENMASK_ULL(max_pa - 1, hkid_start_pos);
> > +	pr_info("kvm: TDX is supported. hkid start pos %d mask 0x%llx\n",
> > +		hkid_start_pos, hkid_mask);
> 
> Again, I think it's better to introduce those in the patch where you actually
> need those.  It will be more clear if you introduce those with the code which
> actually uses them.
> 
> For instance, I think both hkid_start_pos and hkid_mask are not necessary.  If
> you want to apply one keyid to an address, isn't below enough?
> 
> 	u64 phys |= ((keyid) << boot_cpu_data.x86_phys_bits);

Nice catch.  I removed max_pa, hkid_start_pos and hkid_mask.


> > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> > index 0f8a8547958f..0a5967a91e26 100644
> > --- a/arch/x86/kvm/vmx/x86_ops.h
> > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > @@ -122,4 +122,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
> >  #endif
> >  void vmx_setup_mce(struct kvm_vcpu *vcpu);
> >  
> > +#ifdef CONFIG_INTEL_TDX_HOST
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> > +#else
> > +static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
> > +#endif
> 
> I think if you introduce a "tdx_ops.h", or "tdx_x86_ops.h", and you can only
> include it when CONFIG_INTEL_TDX_HOST is true, then in tdx_ops.h you don't need
> those stubs.
> 
> Makes sense?

main.c includes many tdx_xxx().  If we do so without stubs, many
CONFIG_INTEL_TDX_HOST in main.c.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
