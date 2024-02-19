Return-Path: <kvm+bounces-9101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8995385A8B2
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 17:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 406BA286423
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 16:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4294F40BE3;
	Mon, 19 Feb 2024 16:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LcFu7nFB"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4393FE48;
	Mon, 19 Feb 2024 16:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708359583; cv=none; b=j980dTp0KvRQ5KHipdcAcVMP/eIb8dnoA2Bk9kCcyiBps+rHKtUU++Ec20NOqrFlHtY6kNsLRg1cUY0RCWQx2Rxbwx8uUUZDnt0ocyUabmlfRLitMOXHeIkqVOLRxSnT0Y7+JiRoh/dle2j3uM16bJi2hVr+x6uOYt6OfsoTOT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708359583; c=relaxed/simple;
	bh=CCQr+ijyKhWZPcR9JlzOqYAcD5yfmv7exDlNbD4ziFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LOVuYK4nW0Q3hH3XjuAPwq41ZXYmb9ogYbeIm+1xM+ZYqCnbZ8mqLPYs2ZTKAPQ6XiXo7i+gONNiPwi+/oWSYkHNxoh4OuiuxhbRqR2qyX/n7IFaMEXfGwz0XCaNwJrbCVoaHalnWC9Ppfhn67Z+8YeJdy7TiR6wO21UKlKfFLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LcFu7nFB; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708359572; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Rp0rNlHKY/gI4G+2NB8qz4OKmVp7L7LVpxE15Ms/r98=;
	b=LcFu7nFBZCmx9f0bg5ZhmQXi5bd4ueTI1F3RxZ3nZnEznH4ue0t1e+/SqGi9UOBWLwE83UDMdjrKPY5byzNux9FZGEDL7ms2EG39h92kau40W+c+rp2HxPwPOMeYvk1Qu8S4t5jF/67ZU8d9K20pX5W7X2BPLTAi0H1d0Bd8IKY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=yaoma@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0W0tz6nw_1708359568;
Received: from localhost.localdomain(mailfrom:yaoma@linux.alibaba.com fp:SMTPD_---0W0tz6nw_1708359568)
          by smtp.aliyun-inc.com;
          Tue, 20 Feb 2024 00:19:31 +0800
From: Bitao Hu <yaoma@linux.alibaba.com>
To: tglx@linutronix.de,
	dianders@chromium.org,
	pmladek@suse.com,
	akpm@linux-foundation.org,
	kernelfans@gmail.com,
	liusong@linux.alibaba.com,
	deller@gmx.de,
	npiggin@gmail.com,
	jan.kiszka@siemens.com,
	kbingham@kernel.org
Cc: linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Bitao Hu <yaoma@linux.alibaba.com>
Subject: [PATCHv8 2/2] watchdog/softlockup: report the most frequent interrupts
Date: Tue, 20 Feb 2024 00:19:20 +0800
Message-Id: <20240219161920.15752-3-yaoma@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20240219161920.15752-1-yaoma@linux.alibaba.com>
References: <20240219161920.15752-1-yaoma@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the watchdog determines that the current soft lockup is due
to an interrupt storm based on CPU utilization, reporting the
most frequent interrupts could be good enough for further
troubleshooting.

Below is an example of interrupt storm. The call tree does not
provide useful information, but we can analyze which interrupt
caused the soft lockup by comparing the counts of interrupts.

[ 2987.488075] watchdog: BUG: soft lockup - CPU#9 stuck for 23s! [kworker/9:1:214]
[ 2987.488607] CPU#9 Utilization every 4s during lockup:
[ 2987.488941]  #1:   0% system,          0% softirq,   100% hardirq,     0% idle
[ 2987.489357]  #2:   0% system,          0% softirq,   100% hardirq,     0% idle
[ 2987.489771]  #3:   0% system,          0% softirq,   100% hardirq,     0% idle
[ 2987.490186]  #4:   0% system,          0% softirq,   100% hardirq,     0% idle
[ 2987.490601]  #5:   0% system,          0% softirq,   100% hardirq,     0% idle
[ 2987.491034] CPU#9 Detect HardIRQ Time exceeds 50%. Most frequent HardIRQs:
[ 2987.491493]  #1: 330985      irq#7
[ 2987.491743]  #2: 5000        irq#10
[ 2987.492039]  #3: 9           irq#91
[ 2987.492318]  #4: 3           irq#118
...
[ 2987.492728] Call trace:
[ 2987.492729]  __do_softirq+0xa8/0x364

Signed-off-by: Bitao Hu <yaoma@linux.alibaba.com>
---
 arch/mips/dec/setup.c                |   2 +-
 arch/parisc/kernel/smp.c             |   2 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c |   2 +-
 include/linux/irqdesc.h              |   9 ++-
 include/linux/kernel_stat.h          |   4 +
 kernel/irq/internals.h               |   2 +-
 kernel/irq/irqdesc.c                 |  34 ++++++--
 kernel/irq/proc.c                    |   9 +--
 kernel/watchdog.c                    | 115 ++++++++++++++++++++++++++-
 scripts/gdb/linux/interrupts.py      |   6 +-
 10 files changed, 159 insertions(+), 26 deletions(-)

diff --git a/arch/mips/dec/setup.c b/arch/mips/dec/setup.c
index 6c3704f51d0d..87f0a1436bf9 100644
--- a/arch/mips/dec/setup.c
+++ b/arch/mips/dec/setup.c
@@ -756,7 +756,7 @@ void __init arch_init_irq(void)
 				NULL))
 			pr_err("Failed to register fpu interrupt\n");
 		desc_fpu = irq_to_desc(irq_fpu);
-		fpu_kstat_irq = this_cpu_ptr(desc_fpu->kstat_irqs);
+		fpu_kstat_irq = this_cpu_ptr(&desc_fpu->kstat_irqs->cnt);
 	}
 	if (dec_interrupt[DEC_IRQ_CASCADE] >= 0) {
 		if (request_irq(dec_interrupt[DEC_IRQ_CASCADE], no_action,
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 444154271f23..800eb64e91ad 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -344,7 +344,7 @@ static int smp_boot_one_cpu(int cpuid, struct task_struct *idle)
 		struct irq_desc *desc = irq_to_desc(i);
 
 		if (desc && desc->kstat_irqs)
-			*per_cpu_ptr(desc->kstat_irqs, cpuid) = 0;
+			*per_cpu_ptr(desc->kstat_irqs, cpuid) = (struct irqstat) { };
 	}
 #endif
 
diff --git a/arch/powerpc/kvm/book3s_hv_rm_xics.c b/arch/powerpc/kvm/book3s_hv_rm_xics.c
index e42984878503..f2636414d82a 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_xics.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_xics.c
@@ -837,7 +837,7 @@ static inline void this_cpu_inc_rm(unsigned int __percpu *addr)
  */
 static void kvmppc_rm_handle_irq_desc(struct irq_desc *desc)
 {
-	this_cpu_inc_rm(desc->kstat_irqs);
+	this_cpu_inc_rm(&desc->kstat_irqs->cnt);
 	__this_cpu_inc(kstat.irqs_sum);
 }
 
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index d9451d456a73..2912b1998670 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -17,6 +17,11 @@ struct irq_desc;
 struct irq_domain;
 struct pt_regs;
 
+struct irqstat {
+	unsigned int	cnt;
+	unsigned int	ref;
+};
+
 /**
  * struct irq_desc - interrupt descriptor
  * @irq_common_data:	per irq and chip data passed down to chip functions
@@ -55,7 +60,7 @@ struct pt_regs;
 struct irq_desc {
 	struct irq_common_data	irq_common_data;
 	struct irq_data		irq_data;
-	unsigned int __percpu	*kstat_irqs;
+	struct irqstat __percpu	*kstat_irqs;
 	irq_flow_handler_t	handle_irq;
 	struct irqaction	*action;	/* IRQ action list */
 	unsigned int		status_use_accessors;
@@ -119,7 +124,7 @@ extern struct irq_desc irq_desc[NR_IRQS];
 static inline unsigned int irq_desc_kstat_cpu(struct irq_desc *desc,
 					      unsigned int cpu)
 {
-	return desc->kstat_irqs ? *per_cpu_ptr(desc->kstat_irqs, cpu) : 0;
+	return desc->kstat_irqs ? per_cpu(desc->kstat_irqs->cnt, cpu) : 0;
 }
 
 static inline struct irq_desc *irq_data_to_desc(struct irq_data *data)
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 9935f7ecbfb9..9cbb1361f957 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -79,6 +79,10 @@ static inline unsigned int kstat_cpu_softirqs_sum(int cpu)
 	return sum;
 }
 
+extern void kstat_snapshot_irqs(void);
+
+extern unsigned int kstat_get_irq_since_snapshot(unsigned int irq);
+
 /*
  * Number of interrupts per specific IRQ source, since bootup
  */
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index bcc7f21db9ee..1d92532c2aae 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -258,7 +258,7 @@ static inline void irq_state_set_masked(struct irq_desc *desc)
 
 static inline void __kstat_incr_irqs_this_cpu(struct irq_desc *desc)
 {
-	__this_cpu_inc(*desc->kstat_irqs);
+	__this_cpu_inc(desc->kstat_irqs->cnt);
 	__this_cpu_inc(kstat.irqs_sum);
 }
 
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 27ca1c866f29..9cd17080b2d8 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -122,7 +122,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
 	desc->name = NULL;
 	desc->owner = owner;
 	for_each_possible_cpu(cpu)
-		*per_cpu_ptr(desc->kstat_irqs, cpu) = 0;
+		*per_cpu_ptr(desc->kstat_irqs, cpu) = (struct irqstat) { };
 	desc_smp_init(desc, node, affinity);
 }
 
@@ -418,8 +418,8 @@ static struct irq_desc *alloc_desc(int irq, int node, unsigned int flags,
 	desc = kzalloc_node(sizeof(*desc), GFP_KERNEL, node);
 	if (!desc)
 		return NULL;
-	/* allocate based on nr_cpu_ids */
-	desc->kstat_irqs = alloc_percpu(unsigned int);
+
+	desc->kstat_irqs = alloc_percpu(struct irqstat);
 	if (!desc->kstat_irqs)
 		goto err_desc;
 
@@ -593,7 +593,7 @@ int __init early_irq_init(void)
 	count = ARRAY_SIZE(irq_desc);
 
 	for (i = 0; i < count; i++) {
-		desc[i].kstat_irqs = alloc_percpu(unsigned int);
+		desc[i].kstat_irqs = alloc_percpu(struct irqstat);
 		alloc_masks(&desc[i], node);
 		raw_spin_lock_init(&desc[i].lock);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
@@ -952,8 +952,7 @@ unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	return desc && desc->kstat_irqs ?
-			*per_cpu_ptr(desc->kstat_irqs, cpu) : 0;
+	return desc && desc->kstat_irqs ? per_cpu(desc->kstat_irqs->cnt, cpu) : 0;
 }
 
 static bool irq_is_nmi(struct irq_desc *desc)
@@ -975,10 +974,31 @@ static unsigned int kstat_irqs(unsigned int irq)
 		return data_race(desc->tot_count);
 
 	for_each_possible_cpu(cpu)
-		sum += data_race(*per_cpu_ptr(desc->kstat_irqs, cpu));
+		sum += data_race(per_cpu(desc->kstat_irqs->cnt, cpu));
 	return sum;
 }
 
+void kstat_snapshot_irqs(void)
+{
+	struct irq_desc *desc;
+	unsigned int irq;
+
+	for_each_irq_desc(irq, desc) {
+		if (!desc->kstat_irqs)
+			continue;
+		this_cpu_write(desc->kstat_irqs->ref, this_cpu_read(desc->kstat_irqs->cnt));
+	}
+}
+
+unsigned int kstat_get_irq_since_snapshot(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc || !desc->kstat_irqs)
+		return 0;
+	return this_cpu_read(desc->kstat_irqs->cnt) - this_cpu_read(desc->kstat_irqs->ref);
+}
+
 /**
  * kstat_irqs_usr - Get the statistics for an interrupt from thread context
  * @irq:	The interrupt number
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 623b8136e9af..3ad40cf30c66 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -488,18 +488,15 @@ int show_interrupts(struct seq_file *p, void *v)
 	if (!desc || irq_settings_is_hidden(desc))
 		goto outsparse;
 
-	if (desc->kstat_irqs) {
-		for_each_online_cpu(j)
-			any_count |= data_race(*per_cpu_ptr(desc->kstat_irqs, j));
-	}
+	if (desc->kstat_irqs)
+		any_count = data_race(desc->tot_count);
 
 	if ((!desc->action || irq_desc_is_chained(desc)) && !any_count)
 		goto outsparse;
 
 	seq_printf(p, "%*d: ", prec, i);
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", desc->kstat_irqs ?
-					*per_cpu_ptr(desc->kstat_irqs, j) : 0);
+		seq_printf(p, "%10u ", desc->kstat_irqs ? per_cpu(desc->kstat_irqs->cnt, j) : 0);
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (desc->irq_data.chip) {
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 69e72d7e461d..7796c991b64e 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -12,22 +12,25 @@
 
 #define pr_fmt(fmt) "watchdog: " fmt
 
-#include <linux/mm.h>
 #include <linux/cpu.h>
-#include <linux/nmi.h>
 #include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
 #include <linux/kernel_stat.h>
+#include <linux/kvm_para.h>
 #include <linux/math64.h>
+#include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/nmi.h>
+#include <linux/stop_machine.h>
 #include <linux/sysctl.h>
 #include <linux/tick.h>
+
 #include <linux/sched/clock.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/isolation.h>
-#include <linux/stop_machine.h>
 
 #include <asm/irq_regs.h>
-#include <linux/kvm_para.h>
 
 static DEFINE_MUTEX(watchdog_mutex);
 
@@ -417,13 +420,104 @@ static void print_cpustat(void)
 	}
 }
 
+#define HARDIRQ_PERCENT_THRESH		50
+#define NUM_HARDIRQ_REPORT		5
+struct irq_counts {
+	int irq;
+	u32 counts;
+};
+
+static DEFINE_PER_CPU(bool, snapshot_taken);
+
+/* Tabulate the most frequent interrupts. */
+static void tabulate_irq_count(struct irq_counts *irq_counts, int irq, u32 counts, int rank)
+{
+	int i;
+	struct irq_counts new_count = {irq, counts};
+
+	for (i = 0; i < rank; i++) {
+		if (counts > irq_counts[i].counts)
+			swap(new_count, irq_counts[i]);
+	}
+}
+
+/*
+ * If the hardirq time exceeds HARDIRQ_PERCENT_THRESH% of the sample_period,
+ * then the cause of softlockup might be interrupt storm. In this case, it
+ * would be useful to start interrupt counting.
+ */
+static bool need_counting_irqs(void)
+{
+	u8 util;
+	int tail = __this_cpu_read(cpustat_tail);
+
+	tail = (tail + NUM_HARDIRQ_REPORT - 1) % NUM_HARDIRQ_REPORT;
+	util = __this_cpu_read(cpustat_util[tail][STATS_HARDIRQ]);
+	return util > HARDIRQ_PERCENT_THRESH;
+}
+
+static void start_counting_irqs(void)
+{
+	if (!__this_cpu_read(snapshot_taken)) {
+		kstat_snapshot_irqs();
+		__this_cpu_write(snapshot_taken, true);
+	}
+}
+
+static void stop_counting_irqs(void)
+{
+	__this_cpu_write(snapshot_taken, false);
+}
+
+static void print_irq_counts(void)
+{
+	unsigned int i, count;
+	struct irq_counts irq_counts_sorted[NUM_HARDIRQ_REPORT] = {
+		{-1, 0}, {-1, 0}, {-1, 0}, {-1, 0}, {-1, 0}
+	};
+
+	if (__this_cpu_read(snapshot_taken)) {
+		for_each_active_irq(i) {
+			count = kstat_get_irq_since_snapshot(i);
+			tabulate_irq_count(irq_counts_sorted, i, count, NUM_HARDIRQ_REPORT);
+		}
+
+		/*
+		 * We do not want the "watchdog: " prefix on every line,
+		 * hence we use "printk" instead of "pr_crit".
+		 */
+		printk(KERN_CRIT "CPU#%d Detect HardIRQ Time exceeds %d%%. Most frequent HardIRQs:\n",
+		       smp_processor_id(), HARDIRQ_PERCENT_THRESH);
+
+		for (i = 0; i < NUM_HARDIRQ_REPORT; i++) {
+			if (irq_counts_sorted[i].irq == -1)
+				break;
+
+			printk(KERN_CRIT "\t#%u: %-10u\tirq#%d\n",
+				i + 1, irq_counts_sorted[i].counts,
+				irq_counts_sorted[i].irq);
+		}
+
+		/*
+		 * If the hardirq time is less than HARDIRQ_PERCENT_THRESH% in the last
+		 * sample_period, then we suspect the interrupt storm might be subsiding.
+		 */
+		if (!need_counting_irqs())
+			stop_counting_irqs();
+	}
+}
+
 static void report_cpu_status(void)
 {
 	print_cpustat();
+	print_irq_counts();
 }
 #else
 static inline void update_cpustat(void) { }
 static inline void report_cpu_status(void) { }
+static inline bool need_counting_irqs(void) { return false; }
+static inline void start_counting_irqs(void) { }
+static inline void stop_counting_irqs(void) { }
 #endif
 
 /*
@@ -527,6 +621,18 @@ static int is_softlockup(unsigned long touch_ts,
 			 unsigned long now)
 {
 	if ((watchdog_enabled & WATCHDOG_SOFTOCKUP_ENABLED) && watchdog_thresh) {
+		/*
+		 * If period_ts has not been updated during a sample_period, then
+		 * in the subsequent few sample_periods, period_ts might also not
+		 * be updated, which could indicate a potential softlockup. In
+		 * this case, if we suspect the cause of the potential softlockup
+		 * might be interrupt storm, then we need to count the interrupts
+		 * to find which interrupt is storming.
+		 */
+		if (time_after_eq(now, period_ts + get_softlockup_thresh() / 5) &&
+		    need_counting_irqs())
+			start_counting_irqs();
+
 		/* Warn about unreasonable delays. */
 		if (time_after(now, period_ts + get_softlockup_thresh()))
 			return now - touch_ts;
@@ -549,6 +655,7 @@ static DEFINE_PER_CPU(struct cpu_stop_work, softlockup_stop_work);
 static int softlockup_fn(void *data)
 {
 	update_touch_ts();
+	stop_counting_irqs();
 	complete(this_cpu_ptr(&softlockup_completion));
 
 	return 0;
diff --git a/scripts/gdb/linux/interrupts.py b/scripts/gdb/linux/interrupts.py
index ef478e273791..7e50f3b9dfad 100644
--- a/scripts/gdb/linux/interrupts.py
+++ b/scripts/gdb/linux/interrupts.py
@@ -37,7 +37,7 @@ def show_irq_desc(prec, irq):
     any_count = 0
     if desc['kstat_irqs']:
         for cpu in cpus.each_online_cpu():
-            any_count += cpus.per_cpu(desc['kstat_irqs'], cpu)
+            any_count += cpus.per_cpu(desc['kstat_irqs'], cpu)['cnt']
 
     if (desc['action'] == 0 or irq_desc_is_chained(desc)) and any_count == 0:
         return text;
@@ -45,7 +45,7 @@ def show_irq_desc(prec, irq):
     text += "%*d: " % (prec, irq)
     for cpu in cpus.each_online_cpu():
         if desc['kstat_irqs']:
-            count = cpus.per_cpu(desc['kstat_irqs'], cpu)
+            count = cpus.per_cpu(desc['kstat_irqs'], cpu)['cnt']
         else:
             count = 0
         text += "%10u" % (count)
@@ -177,7 +177,7 @@ def arm_common_show_interrupts(prec):
         if desc == 0:
             continue
         for cpu in cpus.each_online_cpu():
-            text += "%10u" % (cpus.per_cpu(desc['kstat_irqs'], cpu))
+            text += "%10u" % (cpus.per_cpu(desc['kstat_irqs'], cpu)['cnt'])
         text += "      %s" % (ipi_types[ipi].string())
         text += "\n"
     return text
-- 
2.37.1 (Apple Git-137.1)


