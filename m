Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9A16BC26B
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 01:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbjCPA1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 20:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjCPA1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 20:27:07 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D02F90B48;
        Wed, 15 Mar 2023 17:27:05 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so4007065pjz.1;
        Wed, 15 Mar 2023 17:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678926425;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7kp2ykOHqeXEhJ5HQKyydNdoEh9q1zt7bKLuqihsZ2Y=;
        b=SVYElEYJ3abksE2LMCHs0pMJFxFSAJeyI1thaodhHM7qY6Mn3VvbsipGx2MlNZYopj
         423bdMvbxXdDcoRob1c8bYYiFul/weRVZ9G6gDRqCO5Jn+8td9LHLVOV8iY3gmSb7tAv
         jqwsa9ZCIfBfuVSnNwXiNC5of1CNagRRH6wEPNItiae+96kpLBuVRVR88B53YrzZoCrN
         WxGV5CSgvyguGskVICERfkNOnGAPAy+/9CchKwMMfCyHxbCV0WmDYoOTb2esdcaGbyga
         d/mTdGihoKs+a8UsR60Ooo1d7vJwq2DKnarpObc1Ajc/d872FCrLWe02f8Rlciyt7F0u
         cDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678926425;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7kp2ykOHqeXEhJ5HQKyydNdoEh9q1zt7bKLuqihsZ2Y=;
        b=mzkCR3vVebq1gu5ydG4QHq9cvvp5fnkOcM00B53ce7kMI4cWoDzV3+z6YvXa4e1akU
         UMGLbV956meA7iBKbP8Dlcc4Rqhc2OD6lJQBB6frR4AnZDkFtwe5m8dDHffr4lZc+73+
         4umkh+Y/kRTzfnrxggJZpaAhjOGHmUEhRvSP1cBtUNVUy8z8T/cO3yPIAQn2fzLTvZqI
         z17J0eHJghkKNQ8QCVbjXrJGcpoaLYrZjQIQu3MXbOVlxfI+f/0x5/RSNdNP5kUoIquy
         ciJZmMo9vgVi0vmaSd0fnWOKjWXnhneaZB76mG7CGT8BI+HfKHLG6S8tZRuLL217jQSE
         J6Zw==
X-Gm-Message-State: AO0yUKWfkRqnsftTs3mw4fthWOD8M2LSsUOBqjen2cQ30D6zeBkhU8Sd
        wfZlxolPh2Erf0SgHhNFUfs=
X-Google-Smtp-Source: AK7set//+89O4/dHP8vaW5p1mnNOS9+pc+0VfoN591ACXpJ1Pf2/fyshQPP7RlF7KLOEx9yDAYYfhw==
X-Received: by 2002:a17:903:2012:b0:19e:baa6:5860 with SMTP id s18-20020a170903201200b0019ebaa65860mr1075959pla.2.1678926424694;
        Wed, 15 Mar 2023 17:27:04 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id io21-20020a17090312d500b001a075503ab8sm2406935plb.132.2023.03.15.17.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 17:27:03 -0700 (PDT)
Date:   Wed, 15 Mar 2023 17:27:02 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20230316002702.GA197448@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
 <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
 <20230315072711.GF3922605@ls.amr.corp.intel.com>
 <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 09:46:00AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> > > 
> > > I think you should use hardware_enable_all(), and just do something similar to
> > > below in vmx_hardware_enable():
> > 
> > The use of hardware_enable_all() make us circle back to refactoring KVM
> > hardware initialization topic.  I'd like to stay away from it for now for TDX.
> 
> Sean's series to improve hardware enable has been merged to upstream already.  

I revised the patch and I can use hardware_enable_all().

> > +	for_each_online_cpu(cpu) {
> > +		if (smp_call_on_cpu(cpu, tdx_cpu_enable_cpu, NULL, false)) {
> > +			r = -EIO;
> > +			break;
> > +		}
> > +	}
> > +	if (!r)
> > +		r = tdx_module_setup();
> > +	on_each_cpu(tdx_vmxoff_cpu, NULL, 1);
> > +	cpus_read_unlock();
> > +
> > +	return r;
> > +}
> 
> I think you can merge next patch with this one because they are kinda related.  
> 
> Putting them together allows people to review more easily.

Finally I come up with the version that uses kvm_hardware_enable_all().
that doesn't issue cpus_read_lock().
I had to patch tdx_cpu_enable(). I'll reply to the patch itself.


From 38774fc6e2bc5f0eddd0a0ab035ba8e712ee5ff2 Mon Sep 17 00:00:00 2001
Message-Id: <38774fc6e2bc5f0eddd0a0ab035ba8e712ee5ff2.1678926122.git.isaku.yamahata@intel.com>
In-Reply-To: <d2aa2142665b8204b628232ab615c98090371c99.1678926122.git.isaku.yamahata@intel.com>
References: <d2aa2142665b8204b628232ab615c98090371c99.1678926122.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Tue, 22 Feb 2022 14:44:15 -0800
Subject: [PATCH] KVM: TDX: Initialize the TDX module when loading the
 KVM intel kernel module

TDX requires several initialization steps for KVM to create guest TDs.
Detect CPU feature, enable VMX (TDX is based on VMX) on all online CPUs,
detect the TDX module availability, initialize it and disable VMX.

To enable VMX on all online CPUs, utilize kvm_hardware_enable_all() that
calls hardware_enable() methods.  The method also initialize each CPU for
TDX.  TDX requires to call a TDX initialization function per logical
processor (LP) before the LP uses TDX.  When CPU is onlined, call the TDX
LP initialization API when cpu is onlined.  If it failed refuse onlininig
of the cpu for simplicity instead of TDX avoiding the LP.

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
 arch/x86/kvm/vmx/main.c    | 34 ++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 46 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  8 +++++++
 arch/x86/kvm/x86.c         | 10 +++++++++
 5 files changed, 97 insertions(+), 2 deletions(-)
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
index 3f49e8e38b6b..f7bfa9888d9e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,36 @@
 #include "nested.h"
 #include "pmu.h"
 
+static bool enable_tdx __ro_after_init;
+module_param_named(tdx, enable_tdx, bool, 0444);
+
+static int vt_hardware_enable(void)
+{
+	int ret;
+
+	ret = vmx_hardware_enable();
+	if (ret || !enable_tdx)
+		return ret;
+
+	ret = tdx_cpu_enable();
+	if (ret)
+		vmx_hardware_disable();
+	return ret;
+}
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
@@ -24,7 +54,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
-	.hardware_enable = vmx_hardware_enable,
+	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
@@ -159,7 +189,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..f13fdf71430b
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,46 @@
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
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	int r = 0;
+
+	if (!enable_ept) {
+		pr_warn("Cannot enable TDX with EPT disabled\n");
+		return -EINVAL;
+	}
+
+	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
+	cpus_read_lock();
+	r = kvm_hardware_enable_all();
+	if (!r) {
+		r = tdx_module_setup();
+		kvm_hardware_disable_all();
+	}
+	cpus_read_unlock();
+
+	return r;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 051b5c4b5c2f..f59e5197836a 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -20,6 +20,8 @@ bool kvm_is_vmx_supported(void);
 int __init vmx_init(void);
 void vmx_exit(void);
 
+__init int vmx_hardware_setup(void);
+
 extern struct kvm_x86_ops vt_x86_ops __initdata;
 extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
@@ -133,4 +135,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+#else
+static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2125fcaa3973..b264012a8478 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9435,6 +9435,16 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	kvm_init_pmu_capability(ops->pmu_ops);
 
+	/*
+	 * TDX requires those methods to enable VMXON by
+	 * kvm_hardware_enable/disable_all()
+	 */
+	static_call_update(kvm_x86_check_processor_compatibility,
+			   ops->runtime_ops->check_processor_compatibility);
+	static_call_update(kvm_x86_hardware_enable,
+			   ops->runtime_ops->hardware_enable);
+	static_call_update(kvm_x86_hardware_disable,
+			   ops->runtime_ops->hardware_disable);
 	r = ops->hardware_setup();
 	if (r != 0)
 		goto out_mmu_exit;
-- 
2.25.1



-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
