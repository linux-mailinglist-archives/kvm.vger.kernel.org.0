Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF03C6190F5
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 07:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiKDGVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 02:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKDGVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 02:21:22 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448AC2A723
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 23:21:20 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id z14so5676489wrn.7
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 23:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xbUgkqdqlP0TXRThV9fNUb23PL+ZSNiv2lV8h+vDI6o=;
        b=imUXex4ARPKocmDM9ipkZFuRSOQjZGPCh8xCGhXhPFszelxiFFYyzabJtWVOBqRsOn
         UrXbYxEOedDge+aDjd+JMoQe74wgIAE/Ea0AiiaSAafhUiDs9eWNbgHHUNAec+UGqoZA
         nabhdH6HPcmnkSxd0xsffa/wZa7MwXCnhRPfhv/6a/wPALBI7yBrUQHYJdQoHPQkMMF6
         5jxd2vhLH9BwfRoCPodbrVlU7ta4IP5DRxrtw+n3eG5FOS4e3zgirCjShSh1jjHA3X9I
         o6uvV9ccxY/7c0V/5qZYHfV68GVxUBXiWyXYjvSoOkoEtKZEYMqWxQsRNuxbJJb6H3n4
         vpKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xbUgkqdqlP0TXRThV9fNUb23PL+ZSNiv2lV8h+vDI6o=;
        b=goBn5G8hhaqlan9Vvp5xA0rU8bMIA1trclK9c0ZzBB8Cmo46wlkQ82+nZAlodIGbTn
         YLWvPPnK0EimOm3k2pBCo1k87VKTXuPDAH8rNexCxQLU15Clpj8tc9seELqZscp0iA3z
         rFvdc4WqVi6BqM12cBqYCncmu4yrTTRsysI2iSyoOfbl11HG+bYN4fKJ9HQY5Z790LKU
         PAHqy2lo2oXyHYPL+b7W7CFb0jcgaRySmJIzmbdV4AdTuXlNjOJ7yTwLXaP/NQ8mbJLH
         KW9NQTf74Xb+Dv174uRiMEldHjrl/tsUtasGVfnO8uCb8+KxtTlMQOR3bLBGj7mXOrrL
         bqNw==
X-Gm-Message-State: ACrzQf2ff5CxTVRb99SXmBCUQ17+dFVyvMc2ld2ke8GD07sUGSoSHCWY
        5JokOrXELDg3e2EZYKR+2sJS2g==
X-Google-Smtp-Source: AMsMyM4RzfHZlEHKZapvxe+7lxyCsG2p54jnJRbUQA/hxMV9BGQ3GTc1YIfiW7CSzL6Q8YMCkxvWqQ==
X-Received: by 2002:a05:6000:1201:b0:236:61f4:b384 with SMTP id e1-20020a056000120100b0023661f4b384mr20419434wrx.505.1667542878791;
        Thu, 03 Nov 2022 23:21:18 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6])
        by smtp.gmail.com with ESMTPSA id w11-20020a5d608b000000b002366f9bd717sm3099924wrt.45.2022.11.03.23.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 23:21:18 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [v2 5/6] KVM: arm64: Support the VCPU preemption check
Date:   Fri,  4 Nov 2022 06:21:04 +0000
Message-Id: <20221104062105.4119003-6-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104062105.4119003-1-usama.arif@bytedance.com>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support the vcpu_is_preempted() functionality under KVM/arm64. This will
enhance lock performance on overcommitted hosts (more runnable VCPUs
than physical CPUs in the system) as doing busy waits for preempted
VCPUs will hurt system performance far worse than early yielding.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/arm64/include/asm/paravirt.h |   2 +
 arch/arm64/include/asm/spinlock.h |  16 ++++-
 arch/arm64/kernel/paravirt.c      | 112 ++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c         |   3 +
 include/linux/cpuhotplug.h        |   1 +
 5 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index 9aa193e0e8f2..4ccb4356c56b 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -19,10 +19,12 @@ static inline u64 paravirt_steal_clock(int cpu)
 }
 
 int __init pv_time_init(void);
+int __init pv_lock_init(void);
 
 #else
 
 #define pv_time_init() do {} while (0)
+#define pv_lock_init() do {} while (0)
 
 #endif // CONFIG_PARAVIRT
 
diff --git a/arch/arm64/include/asm/spinlock.h b/arch/arm64/include/asm/spinlock.h
index 0525c0b089ed..7023efa4de96 100644
--- a/arch/arm64/include/asm/spinlock.h
+++ b/arch/arm64/include/asm/spinlock.h
@@ -10,7 +10,20 @@
 
 /* See include/linux/spinlock.h */
 #define smp_mb__after_spinlock()	smp_mb()
+#define vcpu_is_preempted vcpu_is_preempted
+
+#ifdef CONFIG_PARAVIRT
+#include <linux/static_call_types.h>
+
+bool dummy_vcpu_is_preempted(int cpu);
 
+DECLARE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
+static inline bool vcpu_is_preempted(int cpu)
+{
+	return static_call(pv_vcpu_is_preempted)(cpu);
+}
+
+#else
 /*
  * Changing this will break osq_lock() thanks to the call inside
  * smp_cond_load_relaxed().
@@ -18,10 +31,11 @@
  * See:
  * https://lore.kernel.org/lkml/20200110100612.GC2827@hirez.programming.kicks-ass.net
  */
-#define vcpu_is_preempted vcpu_is_preempted
 static inline bool vcpu_is_preempted(int cpu)
 {
 	return false;
 }
 
+#endif /* CONFIG_PARAVIRT */
+
 #endif /* __ASM_SPINLOCK_H */
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index 57c7c211f8c7..a340f5f4327f 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -20,8 +20,10 @@
 #include <linux/types.h>
 #include <linux/static_call.h>
 
+#include <asm/hypervisor.h>
 #include <asm/paravirt.h>
 #include <asm/pvclock-abi.h>
+#include <asm/pvlock-abi.h>
 #include <asm/smp_plat.h>
 
 struct static_key paravirt_steal_enabled;
@@ -38,7 +40,12 @@ struct pv_time_stolen_time_region {
 	struct pvclock_vcpu_stolen_time __rcu *kaddr;
 };
 
+struct pv_lock_state_region {
+	struct pvlock_vcpu_state __rcu *kaddr;
+};
+
 static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
+static DEFINE_PER_CPU(struct pv_lock_state_region, lock_state_region);
 
 static bool steal_acc = true;
 static int __init parse_no_stealacc(char *arg)
@@ -178,3 +185,108 @@ int __init pv_time_init(void)
 
 	return 0;
 }
+
+static bool native_vcpu_is_preempted(int cpu)
+{
+	return false;
+}
+
+DEFINE_STATIC_CALL(pv_vcpu_is_preempted, native_vcpu_is_preempted);
+
+static bool para_vcpu_is_preempted(int cpu)
+{
+	struct pv_lock_state_region *reg;
+	__le64 preempted_le;
+
+	reg = per_cpu_ptr(&lock_state_region, cpu);
+	if (!reg->kaddr) {
+		pr_warn_once("PV lock enabled but not configured for cpu %d\n",
+			     cpu);
+		return false;
+	}
+
+	preempted_le = le64_to_cpu(READ_ONCE(reg->kaddr->preempted));
+
+	return !!(preempted_le);
+}
+
+static int pvlock_vcpu_state_dying_cpu(unsigned int cpu)
+{
+	struct pv_lock_state_region *reg;
+
+	reg = this_cpu_ptr(&lock_state_region);
+	if (!reg->kaddr)
+		return 0;
+
+	memunmap(reg->kaddr);
+	memset(reg, 0, sizeof(*reg));
+
+	return 0;
+}
+
+static int init_pvlock_vcpu_state(unsigned int cpu)
+{
+	struct pv_lock_state_region *reg;
+	struct arm_smccc_res res;
+
+	reg = this_cpu_ptr(&lock_state_region);
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID, &res);
+
+	if (res.a0 == SMCCC_RET_NOT_SUPPORTED) {
+		pr_warn("Failed to init PV lock data structure\n");
+		return -EINVAL;
+	}
+
+	reg->kaddr = memremap(res.a0,
+			      sizeof(struct pvlock_vcpu_state),
+			      MEMREMAP_WB);
+
+	if (!reg->kaddr) {
+		pr_warn("Failed to map PV lock data structure\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int kvm_arm_init_pvlock(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
+				"hypervisor/arm/pvlock:starting",
+				init_pvlock_vcpu_state,
+				pvlock_vcpu_state_dying_cpu);
+	if (ret < 0) {
+		pr_warn("PV-lock init failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static bool has_kvm_pvlock(void)
+{
+	return kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_PV_LOCK);
+}
+
+int __init pv_lock_init(void)
+{
+	int ret;
+
+	if (is_hyp_mode_available())
+		return 0;
+
+	if (!has_kvm_pvlock())
+		return 0;
+
+	ret = kvm_arm_init_pvlock();
+	if (ret)
+		return ret;
+
+	static_call_update(pv_vcpu_is_preempted, para_vcpu_is_preempted);
+	pr_info("using PV-lock preempted\n");
+
+	return 0;
+}
\ No newline at end of file
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index fea3223704b6..05ca07ac5800 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -42,6 +42,7 @@
 #include <asm/cpu_ops.h>
 #include <asm/kasan.h>
 #include <asm/numa.h>
+#include <asm/paravirt.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/smp_plat.h>
@@ -360,6 +361,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	smp_init_cpus();
 	smp_build_mpidr_hash();
 
+	pv_lock_init();
+
 	/* Init percpu seeds for random tags after cpus are set up. */
 	kasan_init_sw_tags();
 
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index f61447913db9..c0ee11855c73 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -192,6 +192,7 @@ enum cpuhp_state {
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
+	CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_CTI_STARTING,
 	CPUHP_AP_ARM64_ISNDEP_STARTING,
-- 
2.25.1

