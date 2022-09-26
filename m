Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06ED5EAB7E
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 17:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbiIZPpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 11:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiIZPpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 11:45:03 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E51E6525A;
        Mon, 26 Sep 2022 07:30:04 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id u69so6729030pgd.2;
        Mon, 26 Sep 2022 07:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=qdllSPJNzyC4Kx7wRBbplHzTTlz+LlXLn4DAdr2tRHU=;
        b=QmK6eIciogJtR0r8Qiz/9Vj9rYXwW3bVNKfTke/24ncTGOPS35Y6yKpRO99UGuBW4a
         dACiyeSYWl+B8g2ZpLN+GRidqAEh074qKNSkRn+AnIvKr9pEPWoJBt3k5IuLsRHVUq1P
         HBzzlq+WwTzItO5ZbIPKbGgk13L6OMMWoWKx8bs5W2HH8/BS5UoY+3KHq8dp8Gg6BDKx
         qGEXNHaBdJHzwhhMacSD6RROhJ51XUIOivIVxMZ0CA9zTLesGXxyUSb05+Hvp1pjwOCk
         Hj/jIpcr5yevqKv2VDVvQ5dqJk+kBZ/ng9BvxcaUHNd6DzUuPYq2eIH4K9Hnz+m+VSow
         yTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=qdllSPJNzyC4Kx7wRBbplHzTTlz+LlXLn4DAdr2tRHU=;
        b=6qhDzA/3r9C3FE9zxkgCUuQdjm5b/0VP7izitlzvbciyje1D98Oudxy/PhHXFufkjX
         FNDCe6kE8tEWDfROGTBfoytU2Ni9O3M+lgykP1csUGKIBJAHHhYgpZ28+WR8bGdaFdW/
         GL7UWuGeoX7KPzE8BUIZ2R/4UlcUBSevx0PAn2bpXVoh6znIlrm9o2t/SgZefKEuXfzE
         Ny20VvGscMwI5WYMsf4lRplQ43eBjrlyYzEIdWdN08sJegQtJv9yq6lk7j8aUdmEtbnn
         MGBs0kp+i68fHdb35RiLQQn34Ho/lVuhPIc1JjZMTdRqawtKco9x35/CIITJHrdsCAqb
         dFTQ==
X-Gm-Message-State: ACrzQf1MdgIfDB2Vj1EYBBBmdUE8t4Npg/J/L82pSBmk40LV5Ri1pYzG
        2VRVVO8jYocs1NLJrH7G+8s=
X-Google-Smtp-Source: AMsMyM6PIww0JHutuJhc+uJWHwuHv0ACVi+95ykfI2lY3fZ7Y6PSnuPYPxqx/f+8HYDwpbl0CvjGiQ==
X-Received: by 2002:a63:7704:0:b0:439:ae51:3bc1 with SMTP id s4-20020a637704000000b00439ae513bc1mr20278617pgc.558.1664202603759;
        Mon, 26 Sep 2022 07:30:03 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f15-20020aa7968f000000b00543a098a6ffsm12218733pfk.212.2022.09.26.07.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 07:30:03 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH RFC 1/3] KVM + perf: Rename *_intel_pt_intr() for generic usage
Date:   Mon, 26 Sep 2022 22:29:36 +0800
Message-Id: <20220926142938.89608-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926142938.89608-1-likexu@tencent.com>
References: <20220926142938.89608-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The perf_guest_info_callbacks is common to KVM, while intel_pt is not,
not even common to x86. In the VMX context, it makes sense to hook
up the intel_pt specific hook, and given the uniqueness of this usage,
calling the  generic callback in the explicit location of the perf context
is not functionally broken.

Rename a bunch of intel_pt_intr() functions to the generic guest_intr().
No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/core.c    |  2 +-
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  6 +++---
 arch/x86/kvm/x86.c              |  2 +-
 include/linux/perf_event.h      | 12 +++++++-----
 kernel/events/core.c            |  9 ++++-----
 virt/kvm/kvm_main.c             |  6 +++---
 7 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 65906241207e..48e313265a15 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2962,7 +2962,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 */
 	if (__test_and_clear_bit(GLOBAL_STATUS_TRACE_TOPAPMI_BIT, (unsigned long *)&status)) {
 		handled++;
-		if (!perf_guest_handle_intel_pt_intr())
+		if (!perf_handle_guest_intr())
 			intel_pt_interrupt();
 	}
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f1d3ae0b57bb..8cf472a4ca06 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1666,7 +1666,7 @@ struct kvm_x86_init_ops {
 	int (*disabled_by_bios)(void);
 	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
-	unsigned int (*handle_intel_pt_intr)(void);
+	unsigned int (*handle_intr)(void);
 
 	struct kvm_x86_ops *runtime_ops;
 	struct kvm_pmu_ops *pmu_ops;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..a1856b11467d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8374,9 +8374,9 @@ static __init int hardware_setup(void)
 	if (!enable_ept || !enable_pmu || !cpu_has_vmx_intel_pt())
 		pt_mode = PT_MODE_SYSTEM;
 	if (pt_mode == PT_MODE_HOST_GUEST)
-		vmx_init_ops.handle_intel_pt_intr = vmx_handle_intel_pt_intr;
+		vmx_init_ops.handle_intr = vmx_handle_intel_pt_intr;
 	else
-		vmx_init_ops.handle_intel_pt_intr = NULL;
+		vmx_init_ops.handle_intr = NULL;
 
 	setup_default_sgx_lepubkeyhash();
 
@@ -8405,7 +8405,7 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_setup = hardware_setup,
-	.handle_intel_pt_intr = NULL,
+	.handle_intr = NULL,
 
 	.runtime_ops = &vmx_x86_ops,
 	.pmu_ops = &intel_pmu_ops,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6a0e5107de5c..6eff470d3f7d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11990,7 +11990,7 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	kvm_ops_update(ops);
 
-	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
+	kvm_register_perf_callbacks(ops->handle_intr);
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		kvm_caps.supported_xss = 0;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ee8b9ecdc03b..6149a977bbd0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -32,7 +32,7 @@
 struct perf_guest_info_callbacks {
 	unsigned int			(*state)(void);
 	unsigned long			(*get_ip)(void);
-	unsigned int			(*handle_intel_pt_intr)(void);
+	unsigned int			(*handle_intr)(void);
 };
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
@@ -1267,7 +1267,7 @@ extern struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 
 DECLARE_STATIC_CALL(__perf_guest_state, *perf_guest_cbs->state);
 DECLARE_STATIC_CALL(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
-DECLARE_STATIC_CALL(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
+DECLARE_STATIC_CALL(__perf_handle_guest_intr, *perf_guest_cbs->handle_intr);
 
 static inline unsigned int perf_guest_state(void)
 {
@@ -1277,16 +1277,18 @@ static inline unsigned long perf_guest_get_ip(void)
 {
 	return static_call(__perf_guest_get_ip)();
 }
-static inline unsigned int perf_guest_handle_intel_pt_intr(void)
+
+static inline unsigned int perf_handle_guest_intr(void)
 {
-	return static_call(__perf_guest_handle_intel_pt_intr)();
+	return static_call(__perf_handle_guest_intr)();
 }
+
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 #else
 static inline unsigned int perf_guest_state(void)		 { return 0; }
 static inline unsigned long perf_guest_get_ip(void)		 { return 0; }
-static inline unsigned int perf_guest_handle_intel_pt_intr(void) { return 0; }
+static inline unsigned int perf_handle_guest_intr(void) { return 0; }
 #endif /* CONFIG_GUEST_PERF_EVENTS */
 
 extern void perf_event_exec(void);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2621fd24ad26..bb1d1925f153 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6510,7 +6510,7 @@ struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 
 DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
 DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
-DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
+DEFINE_STATIC_CALL_RET0(__perf_handle_guest_intr, *perf_guest_cbs->handle_intr);
 
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 {
@@ -6522,9 +6522,8 @@ void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	static_call_update(__perf_guest_get_ip, cbs->get_ip);
 
 	/* Implementing ->handle_intel_pt_intr is optional. */
-	if (cbs->handle_intel_pt_intr)
-		static_call_update(__perf_guest_handle_intel_pt_intr,
-				   cbs->handle_intel_pt_intr);
+	if (cbs->handle_intr)
+		static_call_update(__perf_handle_guest_intr, cbs->handle_intr);
 }
 EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
 
@@ -6536,7 +6535,7 @@ void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	rcu_assign_pointer(perf_guest_cbs, NULL);
 	static_call_update(__perf_guest_state, (void *)&__static_call_return0);
 	static_call_update(__perf_guest_get_ip, (void *)&__static_call_return0);
-	static_call_update(__perf_guest_handle_intel_pt_intr,
+	static_call_update(__perf_handle_guest_intr,
 			   (void *)&__static_call_return0);
 	synchronize_rcu();
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..8190af3a12fa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5785,12 +5785,12 @@ static unsigned long kvm_guest_get_ip(void)
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.state			= kvm_guest_state,
 	.get_ip			= kvm_guest_get_ip,
-	.handle_intel_pt_intr	= NULL,
+	.handle_intr	= NULL,
 };
 
-void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void))
+void kvm_register_perf_callbacks(unsigned int (*handler)(void))
 {
-	kvm_guest_cbs.handle_intel_pt_intr = pt_intr_handler;
+	kvm_guest_cbs.handle_intr = handler;
 	perf_register_guest_info_callbacks(&kvm_guest_cbs);
 }
 void kvm_unregister_perf_callbacks(void)
-- 
2.37.3

