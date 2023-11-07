Return-Path: <kvm+bounces-1072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A367E49B0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D49228142E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF7B3714E;
	Tue,  7 Nov 2023 20:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PIH0zHhL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F23637157
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:24 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C268E10DF
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:23 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7b9e83b70so700617b3.0
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388423; x=1699993223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G4+jn87rMIg4E1shvnY+9vzkKef1Ww/NQwvl7+a5xc4=;
        b=PIH0zHhLDj18Huixxga48Jjr4C04JHIntekQyIfXzuxrAuYcD9vbs6SpVgXSuDwhWk
         G1e6tGxFe5ZIdHD0hhKtiFGlDfRMZ+YHvmIoyERR5JbYRweM7Ek4nnAxxp99gbXPU2/Q
         DEu95oIjy1XCnCFd28IALwUSh3R4bIaSY0lnLyI2jjiaiF/7p1a8urzKJCjCwBZ7MmSz
         Ley4wL1e/1FCuY07ja2YqsXJ65ccHp+yJdsI50GAJlGDNRK1IcmgIDmRTQS1ETQiQ0dq
         GlX6oO6sU9rjeon2+4ZVEvnWnLH9vY/7Lt4lY2tl7VnYm9A8xvsmijyRAfDZWokMsB+c
         1REg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388423; x=1699993223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G4+jn87rMIg4E1shvnY+9vzkKef1Ww/NQwvl7+a5xc4=;
        b=aUXZacA2KIkILO/Xy5ZQ3ep4kiuc2/ko0pbh0j+cGZD5QpKp0pitqkimRNTTq4JrLh
         fI51S50M5gjY5uxFbYGGpr+i4keXLU4BCWQanaIekLDxDngmPLKpG+cG8kcyW4yFArWU
         lqeWXWg0GV7wYgOkNSbLFd99jgtEtQirNk/VeQ8gSNr7W9ZcXf+5MCEuhJUcnRAivd2O
         VP8iBedJaZHqaMkhZw6YSwxaBMCa8vXV4IwLPnwE6hBIr8VUJDlYsBuJAm+jVtoNq4Ah
         0LNlR2gQGTpQhX7a2xn4IdJIYobZFX8TBYS6Xzs03gkwa5eIVbf9TEqWigrNRhe+v1La
         uPsg==
X-Gm-Message-State: AOJu0YxtP6CMXAlDXA9vEaIMm4Esn9P/17xdPQW9bzHEDXgw/eWqOdc/
	z6mo3b9EVEVsTw3kKb/S3yMKalvjEhzsq9/GAs3z4EmK/u6mc9k8gStOT+4miR5tNSsDsYrM/YZ
	v4xtmlRlgxDqtT4k6kyn9YOJgYkdu//fO36rOnZbaFkOmBd2qXow8PlTbMCDfVWs=
X-Google-Smtp-Source: AGHT+IEsTO9DwkSwbHP7/Lon4nUEYrXwHVJx+yshQ+l/R2Tk3D7Q5HrFIbWNrmOaRRvb20od3YsHAt1MUiccYA==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a05:690c:88f:b0:5a7:d45d:1223 with SMTP
 id cd15-20020a05690c088f00b005a7d45d1223mr91894ywb.3.1699388422661; Tue, 07
 Nov 2023 12:20:22 -0800 (PST)
Date: Tue,  7 Nov 2023 20:19:53 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-6-aghulati@google.com>
Subject: [RFC PATCH 05/14] KVM: x86: Refactor hardware enable/disable
 operations into a new file
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

Move KVM's hardware enabling to vac.{h,c} as a first step towards
building VAC and all of the system-wide virtualization support as a
separate module.

Defer moving arch code to future patches to keep the diff reasonable.

No functional change intended.

Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 virt/kvm/kvm_main.c | 197 +-------------------------------------------
 virt/kvm/vac.c      | 177 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/vac.h      |  26 ++++++
 3 files changed, 204 insertions(+), 196 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f585a159b4f5..fb50deaad3fd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -59,6 +59,7 @@
 #include "coalesced_mmio.h"
 #include "async_pf.h"
 #include "kvm_mm.h"
+#include "vac.h"
 #include "vfio.h"
 
 #include <trace/events/ipi.h>
@@ -140,8 +141,6 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -5167,200 +5166,6 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-__visible bool kvm_rebooting;
-EXPORT_SYMBOL_GPL(kvm_rebooting);
-
-static DEFINE_PER_CPU(bool, hardware_enabled);
-static int kvm_usage_count;
-
-static int __hardware_enable_nolock(void)
-{
-	if (__this_cpu_read(hardware_enabled))
-		return 0;
-
-	if (kvm_arch_hardware_enable()) {
-		pr_info("kvm: enabling virtualization on CPU%d failed\n",
-			raw_smp_processor_id());
-		return -EIO;
-	}
-
-	__this_cpu_write(hardware_enabled, true);
-	return 0;
-}
-
-static void hardware_enable_nolock(void *failed)
-{
-	if (__hardware_enable_nolock())
-		atomic_inc(failed);
-}
-
-static int kvm_online_cpu(unsigned int cpu)
-{
-	int ret = 0;
-
-	/*
-	 * Abort the CPU online process if hardware virtualization cannot
-	 * be enabled. Otherwise running VMs would encounter unrecoverable
-	 * errors when scheduled to this CPU.
-	 */
-	mutex_lock(&kvm_lock);
-	if (kvm_usage_count)
-		ret = __hardware_enable_nolock();
-	mutex_unlock(&kvm_lock);
-	return ret;
-}
-
-static void hardware_disable_nolock(void *junk)
-{
-	/*
-	 * Note, hardware_disable_all_nolock() tells all online CPUs to disable
-	 * hardware, not just CPUs that successfully enabled hardware!
-	 */
-	if (!__this_cpu_read(hardware_enabled))
-		return;
-
-	kvm_arch_hardware_disable();
-
-	__this_cpu_write(hardware_enabled, false);
-}
-
-static int kvm_offline_cpu(unsigned int cpu)
-{
-	mutex_lock(&kvm_lock);
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
-	mutex_unlock(&kvm_lock);
-	return 0;
-}
-
-static void hardware_disable_all_nolock(void)
-{
-	BUG_ON(!kvm_usage_count);
-
-	kvm_usage_count--;
-	if (!kvm_usage_count)
-		on_each_cpu(hardware_disable_nolock, NULL, 1);
-}
-
-static void hardware_disable_all(void)
-{
-	cpus_read_lock();
-	mutex_lock(&kvm_lock);
-	hardware_disable_all_nolock();
-	mutex_unlock(&kvm_lock);
-	cpus_read_unlock();
-}
-
-static int hardware_enable_all(void)
-{
-	atomic_t failed = ATOMIC_INIT(0);
-	int r;
-
-	/*
-	 * Do not enable hardware virtualization if the system is going down.
-	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
-	 * possible for an in-flight KVM_CREATE_VM to trigger hardware enabling
-	 * after kvm_reboot() is called.  Note, this relies on system_state
-	 * being set _before_ kvm_reboot(), which is why KVM uses a syscore ops
-	 * hook instead of registering a dedicated reboot notifier (the latter
-	 * runs before system_state is updated).
-	 */
-	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
-	    system_state == SYSTEM_RESTART)
-		return -EBUSY;
-
-	/*
-	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
-	 * is called, and so on_each_cpu() between them includes the CPU that
-	 * is being onlined.  As a result, hardware_enable_nolock() may get
-	 * invoked before kvm_online_cpu(), which also enables hardware if the
-	 * usage count is non-zero.  Disable CPU hotplug to avoid attempting to
-	 * enable hardware multiple times.
-	 */
-	cpus_read_lock();
-	mutex_lock(&kvm_lock);
-
-	r = 0;
-
-	kvm_usage_count++;
-	if (kvm_usage_count == 1) {
-		on_each_cpu(hardware_enable_nolock, &failed, 1);
-
-		if (atomic_read(&failed)) {
-			hardware_disable_all_nolock();
-			r = -EBUSY;
-		}
-	}
-
-	mutex_unlock(&kvm_lock);
-	cpus_read_unlock();
-
-	return r;
-}
-
-static void kvm_shutdown(void)
-{
-	/*
-	 * Disable hardware virtualization and set kvm_rebooting to indicate
-	 * that KVM has asynchronously disabled hardware virtualization, i.e.
-	 * that relevant errors and exceptions aren't entirely unexpected.
-	 * Some flavors of hardware virtualization need to be disabled before
-	 * transferring control to firmware (to perform shutdown/reboot), e.g.
-	 * on x86, virtualization can block INIT interrupts, which are used by
-	 * firmware to pull APs back under firmware control.  Note, this path
-	 * is used for both shutdown and reboot scenarios, i.e. neither name is
-	 * 100% comprehensive.
-	 */
-	pr_info("kvm: exiting hardware virtualization\n");
-	kvm_rebooting = true;
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
-}
-
-static int kvm_suspend(void)
-{
-	/*
-	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
-	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
-	 * is stable.  Assert that kvm_lock is not held to ensure the system
-	 * isn't suspended while KVM is enabling hardware.  Hardware enabling
-	 * can be preempted, but the task cannot be frozen until it has dropped
-	 * all locks (userspace tasks are frozen via a fake signal).
-	 */
-	lockdep_assert_not_held(&kvm_lock);
-	lockdep_assert_irqs_disabled();
-
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
-	return 0;
-}
-
-static void kvm_resume(void)
-{
-	lockdep_assert_not_held(&kvm_lock);
-	lockdep_assert_irqs_disabled();
-
-	if (kvm_usage_count)
-		WARN_ON_ONCE(__hardware_enable_nolock());
-}
-
-static struct syscore_ops kvm_syscore_ops = {
-	.suspend = kvm_suspend,
-	.resume = kvm_resume,
-	.shutdown = kvm_shutdown,
-};
-#else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
-static int hardware_enable_all(void)
-{
-	return 0;
-}
-
-static void hardware_disable_all(void)
-{
-
-}
-#endif /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
-
 static void kvm_iodevice_destructor(struct kvm_io_device *dev)
 {
 	if (dev->ops->destructor)
diff --git a/virt/kvm/vac.c b/virt/kvm/vac.c
index 18d2ae7d3e47..ff034a53af50 100644
--- a/virt/kvm/vac.c
+++ b/virt/kvm/vac.c
@@ -1,3 +1,180 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include "vac.h"
+
+#include <linux/cpu.h>
+#include <linux/percpu.h>
+#include <linux/mutex.h>
+
+#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+DEFINE_MUTEX(vac_lock);
+
+__visible bool kvm_rebooting;
+EXPORT_SYMBOL_GPL(kvm_rebooting);
+
+static DEFINE_PER_CPU(bool, hardware_enabled);
+static int kvm_usage_count;
+
+static int __hardware_enable_nolock(void)
+{
+	if (__this_cpu_read(hardware_enabled))
+		return 0;
+
+	if (kvm_arch_hardware_enable()) {
+		pr_info("kvm: enabling virtualization on CPU%d failed\n",
+			raw_smp_processor_id());
+		return -EIO;
+	}
+
+	__this_cpu_write(hardware_enabled, true);
+	return 0;
+}
+
+static void hardware_enable_nolock(void *failed)
+{
+	if (__hardware_enable_nolock())
+		atomic_inc(failed);
+}
+
+int kvm_online_cpu(unsigned int cpu)
+{
+	int ret = 0;
+
+	/*
+	 * Abort the CPU online process if hardware virtualization cannot
+	 * be enabled. Otherwise running VMs would encounter unrecoverable
+	 * errors when scheduled to this CPU.
+	 */
+	mutex_lock(&vac_lock);
+	if (kvm_usage_count)
+		ret = __hardware_enable_nolock();
+	mutex_unlock(&vac_lock);
+	return ret;
+}
+
+static void hardware_disable_nolock(void *junk)
+{
+	/*
+	 * Note, hardware_disable_all_nolock() tells all online CPUs to disable
+	 * hardware, not just CPUs that successfully enabled hardware!
+	 */
+	if (!__this_cpu_read(hardware_enabled))
+		return;
+
+	kvm_arch_hardware_disable();
+
+	__this_cpu_write(hardware_enabled, false);
+}
+
+int kvm_offline_cpu(unsigned int cpu)
+{
+	mutex_lock(&vac_lock);
+	if (kvm_usage_count)
+		hardware_disable_nolock(NULL);
+	mutex_unlock(&vac_lock);
+	return 0;
+}
+
+static void hardware_disable_all_nolock(void)
+{
+	BUG_ON(!kvm_usage_count);
+
+	kvm_usage_count--;
+	if (!kvm_usage_count)
+		on_each_cpu(hardware_disable_nolock, NULL, 1);
+}
+
+void hardware_disable_all(void)
+{
+	cpus_read_lock();
+	mutex_lock(&vac_lock);
+	hardware_disable_all_nolock();
+	mutex_unlock(&vac_lock);
+	cpus_read_unlock();
+}
+
+int hardware_enable_all(void)
+{
+	atomic_t failed = ATOMIC_INIT(0);
+	int r = 0;
+
+	/*
+	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
+	 * is called, and so on_each_cpu() between them includes the CPU that
+	 * is being onlined.  As a result, hardware_enable_nolock() may get
+	 * invoked before kvm_online_cpu(), which also enables hardware if the
+	 * usage count is non-zero.  Disable CPU hotplug to avoid attempting to
+	 * enable hardware multiple times.
+	 */
+	cpus_read_lock();
+	mutex_lock(&vac_lock);
+
+	kvm_usage_count++;
+	if (kvm_usage_count == 1) {
+		on_each_cpu(hardware_enable_nolock, &failed, 1);
+
+		if (atomic_read(&failed)) {
+			hardware_disable_all_nolock();
+			r = -EBUSY;
+		}
+	}
+
+	mutex_unlock(&vac_lock);
+	cpus_read_unlock();
+
+	return r;
+}
+
+static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
+		      void *v)
+{
+	/*
+	 * Some (well, at least mine) BIOSes hang on reboot if
+	 * in vmx root mode.
+	 *
+	 * And Intel TXT required VMX off for all cpu when system shutdown.
+	 */
+	pr_info("kvm: exiting hardware virtualization\n");
+	kvm_rebooting = true;
+	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	return NOTIFY_OK;
+}
+
+static int kvm_suspend(void)
+{
+	/*
+	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
+	 * callbacks, i.e. no need to acquire vac_lock to ensure the usage count
+	 * is stable.  Assert that vac_lock is not held to ensure the system
+	 * isn't suspended while KVM is enabling hardware.  Hardware enabling
+	 * can be preempted, but the task cannot be frozen until it has dropped
+	 * all locks (userspace tasks are frozen via a fake signal).
+	 */
+	lockdep_assert_not_held(&vac_lock);
+	lockdep_assert_irqs_disabled();
+
+	if (kvm_usage_count)
+		hardware_disable_nolock(NULL);
+	return 0;
+}
+
+static void kvm_resume(void)
+{
+	lockdep_assert_not_held(&vac_lock);
+	lockdep_assert_irqs_disabled();
+
+	if (kvm_usage_count)
+		WARN_ON_ONCE(__hardware_enable_nolock());
+}
+
+struct notifier_block kvm_reboot_notifier = {
+	.notifier_call = kvm_reboot,
+	.priority = 0,
+};
+
+struct syscore_ops kvm_syscore_ops = {
+	.suspend = kvm_suspend,
+	.resume = kvm_resume,
+};
+
+#endif
diff --git a/virt/kvm/vac.h b/virt/kvm/vac.h
index 8f7123a916c5..aed178a16bdb 100644
--- a/virt/kvm/vac.h
+++ b/virt/kvm/vac.h
@@ -3,4 +3,30 @@
 #ifndef __KVM_VAC_H__
 #define __KVM_VAC_H__
 
+#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+
+#include <linux/kvm_host.h>
+#include <linux/syscore_ops.h>
+
+int kvm_online_cpu(unsigned int cpu);
+int kvm_offline_cpu(unsigned int cpu);
+void hardware_disable_all(void);
+int hardware_enable_all(void);
+
+extern struct notifier_block kvm_reboot_notifier;
+
+extern struct syscore_ops kvm_syscore_ops;
+
+#else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
+static inline int hardware_enable_all(void)
+{
+	return 0;
+}
+
+static inline void hardware_disable_all(void)
+{
+
+}
+#endif /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
+
 #endif
-- 
2.42.0.869.gea05f2083d-goog


