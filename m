Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00E96BA902
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 08:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjCOH1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 03:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjCOH1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 03:27:19 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBDF5B404;
        Wed, 15 Mar 2023 00:27:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so957683pjp.2;
        Wed, 15 Mar 2023 00:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678865234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ILLBIlXm9Rz3Tg1L2PxIbv3bGEf+crUkn4jQUAdjYNM=;
        b=YbdzLSouNrZFwPLkP5FuJ6zDO5iDkMI/UoYlJjr0pzIdLse0F+JFWyqZIgXVA5NgtO
         6bLbnArKVvMG4k/zpNWcgVRSYpSZ3crXglPfFSXMcX9ba1QOMFFDrbBCoM92I13td9nU
         OWe3Yxh0r9we/buosUhYOp673EbTx6Mzm2biUGgQfWNzITvSK5GQm7x/OD14cHPIUM4m
         YrlZGTbzCX0t1jIjmlI83xnhlpNGcaGyi+qPv01MXFPSDbgzRIN4N3LyDY44jYAC/bdt
         QVSvKFu8Tl0xdMeherYZAOp2uj2VrOcVMxM4lsFyOF8YqaRHzuFLMsgzhgOSJGF6yhmm
         EZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678865234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ILLBIlXm9Rz3Tg1L2PxIbv3bGEf+crUkn4jQUAdjYNM=;
        b=QBqL1pA7jU2b4PNYkYuY8oRNfJjhNCYiQT+3zKL3yDBplJ7HM2Cd0Xdxtt/xuzZtE2
         i3IHD9++aBtnAi3BdiAq/ad7rYRgaHdSn664sBALSGXcd/v/E0+fs0UsYNHuVjgTE+n3
         a08D2cMIGPvlIjH+r+HKIisEeuUcrtulcASOmgPyWrhHxNjEWwmaBjNNI2kXzI+KL5NH
         XNf0iDxMq4tY84TPXOQD7AND8X9h36aFJ20PLHCjg893qZ0LsFl3x8C1/bF6XNoxyylu
         9Okc9zOyhw/zNM4/HTCDTZiSCLTXT3usijQCSrHLbPV1gSFB+qrYMxOFPYD367A+eIuP
         qLfQ==
X-Gm-Message-State: AO0yUKUYurD81iXOzskDxrP70etSQS0qo/KIyDxi9KXhi2TJwj9SXegt
        /W6611o2EdjBSAjyuyKckHg=
X-Google-Smtp-Source: AK7set+peO+ucdIIiVtE9U04DHqz4I6q3J5F5EAWPy87pPdizSkXTsww6nTtutMzoI7UQKR3dcRcwg==
X-Received: by 2002:a17:90a:2c47:b0:23d:2532:ae34 with SMTP id p7-20020a17090a2c4700b0023d2532ae34mr6105227pjm.2.1678865233752;
        Wed, 15 Mar 2023 00:27:13 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090a015600b00234899c65e7sm655943pje.28.2023.03.15.00.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 00:27:13 -0700 (PDT)
Date:   Wed, 15 Mar 2023 00:27:11 -0700
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
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20230315072711.GF3922605@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
 <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023 at 02:38:06AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sun, 2023-03-12 at 10:55 -0700, isaku.yamahata@intel.com wrote:
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > +{
> > +	int r;
> > +
> > +	if (!enable_ept) {
> > +		pr_warn("Cannot enable TDX with EPT disabled\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
> > +	cpus_read_lock();
> > +	/* TDX requires VMX. */
> > +	r = vmxon_all();
> 
> Why not using hardware_enable_all()?
> 
> > +	if (!r) {
> > +		int cpu;
> > +
> > +		/*
> > +		 * Because tdx_cpu_enabel() acquire spin locks, on_each_cpu()
> > +		 * can't be used.
> > +		 */
> > +		for_each_online_cpu(cpu) {
> > +			if (smp_call_on_cpu(cpu, tdx_cpu_enable_cpu, NULL, false))
> > +				r = -EIO;
> > +		}
> > +		if (!r)
> > +			r = tdx_module_setup();
> > +	}
> > +	vmxoff_all();
> > +	cpus_read_unlock();
> > +
> > +	return r;
> > +}
> 
> I think you should use hardware_enable_all(), and just do something similar to
> below in vmx_hardware_enable():

The use of hardware_enable_all() make us circle back to refactoring KVM
hardware initialization topic.  I'd like to stay away from it for now for TDX.
I find that vmxon_all() is unnecessary and we can move VMXON to
tdx_cpu_enable_cpu().
Here is the version of dropping vmxon_all().

From f8fa8fe9786f1c4d4a3b0af0d0228d2842984cba Mon Sep 17 00:00:00 2001
Message-Id: <f8fa8fe9786f1c4d4a3b0af0d0228d2842984cba.1678864879.git.isaku.yamahata@intel.com>
In-Reply-To: <d2aa2142665b8204b628232ab615c98090371c99.1678864879.git.isaku.yamahata@intel.com>
References: <d2aa2142665b8204b628232ab615c98090371c99.1678864879.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Tue, 22 Feb 2022 14:44:15 -0800
Subject: [PATCH] KVM: TDX: Initialize the TDX module when loading the
 KVM intel kernel module

TDX requires several initialization steps for KVM to create guest TDs.
Detect CPU feature, enable VMX (TDX is based on VMX), detect the TDX module
availability, and initialize it.

There are several options on when to initialize the TDX module.  A.) kernel
module loading time, B.) the first guest TD creation time.  A.) was chosen.
With B.), a user may hit an error of the TDX initialization when trying to
create the first guest TD.  The machine that fails to initialize the TDX
module can't boot any guest TD further.  Such failure is undesirable and a
surprise because the user expects that the machine can accommodate guest
TD, but actually not.  So A.) is better than B.).

Introduce a module parameter, kvm_intel.tdx, to explicitly enable TDX KVM
support.  It's off by default to keep same behavior for those who don't use
TDX.  Implement hardware_setup method to detect TDX feature of CPU and
initialize TDX module.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile      |  1 +
 arch/x86/kvm/vmx/main.c    | 18 +++++++++-
 arch/x86/kvm/vmx/tdx.c     | 74 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     |  7 ++++
 arch/x86/kvm/vmx/x86_ops.h |  9 +++++
 5 files changed, 108 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 0e894ae23cbc..4b01ab842ab7 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -25,6 +25,7 @@ kvm-$(CONFIG_KVM_SMM)	+= smm.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/hyperv.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
 			   svm/sev.o svm/hyperv.o
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 3f49e8e38b6b..5c9f5e00b3c4 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,22 @@
 #include "nested.h"
 #include "pmu.h"
 
+static bool enable_tdx __ro_after_init;
+module_param_named(tdx, enable_tdx, bool, 0444);
+
+static __init int vt_hardware_setup(void)
+{
+	int ret;
+
+	ret = vmx_hardware_setup();
+	if (ret)
+		return ret;
+
+	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
+
+	return 0;
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS		       \
 (						       \
        BIT(APICV_INHIBIT_REASON_DISABLE)|	       \
@@ -159,7 +175,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..8d265d7ae6fb
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+
+#include <asm/tdx.h>
+
+#include "capabilities.h"
+#include "x86_ops.h"
+#include "x86.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+static int __init tdx_module_setup(void)
+{
+	int ret;
+
+	ret = tdx_enable();
+	if (ret) {
+		pr_info("Failed to initialize TDX module.\n");
+		return ret;
+	}
+
+	pr_info("TDX is supported.\n");
+	return 0;
+}
+
+static int __init tdx_cpu_enable_cpu(void *unused)
+{
+	int r;
+
+	/*
+	 * TDX requires VMX. Because thread can be migrated, keep VMXON on
+	 * all online cpus until all TDX module initialization is done.
+	 */
+	r = vmxon();
+	if (r)
+		return r;
+	return tdx_cpu_enable();
+}
+
+static void __init tdx_vmxoff_cpu(void *unused)
+{
+	WARN_ON_ONCE(cpu_vmxoff());
+}
+
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	int cpu;
+	int r = 0;
+
+	if (!enable_ept) {
+		pr_warn("Cannot enable TDX with EPT disabled\n");
+		return -EINVAL;
+	}
+
+	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
+	cpus_read_lock();
+	/*
+	 * Because tdx_cpu_enable() acquires spin locks, on_each_cpu()
+	 * can't be used.
+	 */
+	for_each_online_cpu(cpu) {
+		if (smp_call_on_cpu(cpu, tdx_cpu_enable_cpu, NULL, false)) {
+			r = -EIO;
+			break;
+		}
+	}
+	if (!r)
+		r = tdx_module_setup();
+	on_each_cpu(tdx_vmxoff_cpu, NULL, 1);
+	cpus_read_unlock();
+
+	return r;
+}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3bbd07412f00..ce48e0bc9e00 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8123,6 +8123,13 @@ static unsigned int vmx_handle_intel_pt_intr(void)
 	return 1;
 }
 
+__init int vmxon(void)
+{
+	if (cr4_read_shadow() & X86_CR4_VMXE)
+		return -EBUSY;
+	return kvm_cpu_vmxon(__pa(this_cpu_read(vmxarea)));
+}
+
 static __init void vmx_setup_user_return_msrs(void)
 {
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 051b5c4b5c2f..892c39f7d771 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -20,6 +20,9 @@ bool kvm_is_vmx_supported(void);
 int __init vmx_init(void);
 void vmx_exit(void);
 
+__init int vmxon(void);
+__init int vmx_hardware_setup(void);
+
 extern struct kvm_x86_ops vt_x86_ops __initdata;
 extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
@@ -133,4 +136,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+#else
+static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1



-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
