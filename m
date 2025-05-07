Return-Path: <kvm+bounces-45680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D05AAD2A9
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 03:22:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F184984C59
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48471917FB;
	Wed,  7 May 2025 01:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lOQOBuRb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD05D146D6A;
	Wed,  7 May 2025 01:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746580887; cv=none; b=QxUO0F33/RN3YsroUy6FWd7TAvG1vQCZD6Ao1L5miz1kSuXi8XWpsHmYEe2H6aV2BildyHO0ylDkXn+Fyaq9YKy/OqsxWj0NaVpHGw2I8XdilcG2NWISZFOdhbYCpYXHiqCkF6EoUqGWRIdATAfWngNx69iEj/ID5qRy40djhZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746580887; c=relaxed/simple;
	bh=v/Zoi16xkEM8MbGWyex+8/EXfPFcUVcaXJjb5wJejTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIXOtmwzypNG28hkpgDYbfplvraP9E+/WgWk7a73+1kNwitpHxspdlBe3mLmTdlKXHihHoyv54XBLB+3KmbX7wR3XrPZPJcHICvbq9ikY/TSszSMLbN5uvg9JiCu8LzXTZp1kNbaaLMhlxIHz6ZEjxMSKzVh+GWwNJyHNBqqolk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lOQOBuRb; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746580886; x=1778116886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v/Zoi16xkEM8MbGWyex+8/EXfPFcUVcaXJjb5wJejTo=;
  b=lOQOBuRbkp9PG30XejPZloJeMLOZwBGi9/5FrMtmLmglw0b32K9xucBX
   KizQMexXtYsneDl8tN4wqoOuqn+IvEUz0zu2Tgn0M7mLCBzQYH1l6erlO
   rV9gSQodeLA4mhc0ewrEPTJINfQqNhRLPJOQEzpvZabhrIozCNkHRRWQU
   ZmymswyHL8dmklKSor6G6EG/CJjpygq+7IF4l/R7SoOoy+pNHE5+KCb5H
   mWPoAAx270W2WaIEv/287nIXFCy1hBVzGGH33CeS01vVwMDERox6q5mcU
   9VhQwXDlOu76Zy9uSl8daItjbmOcEnhd0tvGNRmGx8/s+NWkTaD/rv5/V
   A==;
X-CSE-ConnectionGUID: omlrrlElSiud9NRC6f0YRw==
X-CSE-MsgGUID: i9Q6ttffSdyqPr9V28Xo8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47383936"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47383936"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 18:21:23 -0700
X-CSE-ConnectionGUID: pH9blC9iTa6kq0ekspUXrg==
X-CSE-MsgGUID: nOH3urOJTlC2ORo8CW0eTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="136808745"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa009.fm.intel.com with ESMTP; 06 May 2025 18:21:23 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v5 3/9] x86/nmi: Extend the registration interface to include the NMI-source vector
Date: Tue,  6 May 2025 18:21:39 -0700
Message-ID: <20250507012145.2998143-4-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250507012145.2998143-1-sohil.mehta@intel.com>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare for NMI-source reporting, add a source vector argument to the
NMI handler registration interface. Later, this will be used to
register NMI handlers with a unique source vector that can be used to
identify the originator of the NMI.

For now, just extend the interface and pass zero as the source vector
for all handlers. No functional change intended.

Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v5: Split the patch into two parts. This one only extends the interface.
---
 arch/x86/events/amd/ibs.c         | 2 +-
 arch/x86/events/core.c            | 2 +-
 arch/x86/include/asm/nmi.h        | 5 ++++-
 arch/x86/kernel/apic/hw_nmi.c     | 3 +--
 arch/x86/kernel/cpu/mce/inject.c  | 2 +-
 arch/x86/kernel/cpu/mshyperv.c    | 3 +--
 arch/x86/kernel/kgdb.c            | 6 ++----
 arch/x86/kernel/nmi_selftest.c    | 7 +++----
 arch/x86/kernel/smp.c             | 4 ++--
 arch/x86/platform/uv/uv_nmi.c     | 4 ++--
 drivers/acpi/apei/ghes.c          | 2 +-
 drivers/char/ipmi/ipmi_watchdog.c | 3 +--
 drivers/edac/igen6_edac.c         | 3 +--
 drivers/watchdog/hpwdt.c          | 6 +++---
 14 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 0252b7ea8bca..45dece8bee84 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1486,7 +1486,7 @@ static __init int perf_event_ibs_init(void)
 	if (ret)
 		goto err_op;
 
-	ret = register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs");
+	ret = register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs", 0);
 	if (ret)
 		goto err_nmi;
 
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 6866cc5acb0b..b84b8be1f075 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2115,7 +2115,7 @@ static int __init init_hw_perf_events(void)
 		x86_pmu.config_mask = X86_RAW_EVENT_MASK;
 
 	perf_events_lapic_init();
-	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI");
+	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI", 0);
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, x86_pmu.cntr_mask64,
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 79d88d12c8fb..f0a577bf7bba 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -54,6 +54,7 @@ struct nmiaction {
 	u64			max_duration;
 	unsigned long		flags;
 	const char		*name;
+	u8			source_vector;
 };
 
 /**
@@ -62,6 +63,7 @@ struct nmiaction {
  * @fn:   The NMI handler
  * @fg:   Flags associated with the NMI handler
  * @n:    Name of the NMI handler
+ * @src:  NMI-source based vector for the NMI handler
  * @init: Optional __init* attributes for struct nmiaction
  *
  * Adds the provided handler to the list of handlers for the specified
@@ -75,13 +77,14 @@ struct nmiaction {
  *
  * Return: 0 on success, or an error code on failure.
  */
-#define register_nmi_handler(t, fn, fg, n, init...)	\
+#define register_nmi_handler(t, fn, fg, n, src, init...)	\
 ({							\
 	static struct nmiaction init fn##_na = {	\
 		.list = LIST_HEAD_INIT(fn##_na.list),	\
 		.handler = (fn),			\
 		.name = (n),				\
 		.flags = (fg),				\
+		.source_vector = (src),			\
 	};						\
 	__register_nmi_handler((t), &fn##_na);		\
 })
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 45af535c44a0..612b77660d05 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -53,8 +53,7 @@ NOKPROBE_SYMBOL(nmi_cpu_backtrace_handler);
 
 static int __init register_nmi_cpu_backtrace_handler(void)
 {
-	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler,
-				0, "arch_bt");
+	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", 0);
 	return 0;
 }
 early_initcall(register_nmi_cpu_backtrace_handler);
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 06e3cf7229ce..17804ba0b02f 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -774,7 +774,7 @@ static int __init inject_init(void)
 
 	debugfs_init();
 
-	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify");
+	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify", 0);
 	mce_register_injector_chain(&inject_nb);
 
 	setup_inj_struct(&i_mce);
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 3e2533954675..d643d6fb3cfa 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -548,8 +548,7 @@ static void __init ms_hyperv_init_platform(void)
 			lapic_timer_period);
 	}
 
-	register_nmi_handler(NMI_UNKNOWN, hv_nmi_unknown, NMI_FLAG_FIRST,
-			     "hv_nmi_unknown");
+	register_nmi_handler(NMI_UNKNOWN, hv_nmi_unknown, NMI_FLAG_FIRST, "hv_nmi_unknown", 0);
 #endif
 
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 9c9faa1634fb..ab2d1b79b79e 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -602,13 +602,11 @@ int kgdb_arch_init(void)
 	if (retval)
 		goto out;
 
-	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler,
-					0, "kgdb");
+	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler, 0, "kgdb", 0);
 	if (retval)
 		goto out1;
 
-	retval = register_nmi_handler(NMI_UNKNOWN, kgdb_nmi_handler,
-					0, "kgdb");
+	retval = register_nmi_handler(NMI_UNKNOWN, kgdb_nmi_handler, 0, "kgdb", 0);
 
 	if (retval)
 		goto out2;
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index a010e9d062bf..b203e4371816 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -40,8 +40,7 @@ static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 static void __init init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
-	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk",
-			__initdata);
+	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk", 0, __initdata);
 }
 
 static void __init cleanup_nmi_testsuite(void)
@@ -63,8 +62,8 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 {
 	unsigned long timeout;
 
-	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
-				 NMI_FLAG_FIRST, "nmi_selftest", __initdata)) {
+	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback, NMI_FLAG_FIRST,
+				 "nmi_selftest", 0, __initdata)) {
 		nmi_fail = FAILURE;
 		return;
 	}
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 18266cc3d98c..b80812aa06c3 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -142,8 +142,8 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
 
 static int register_stop_handler(void)
 {
-	return register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-				    NMI_FLAG_FIRST, "smp_stop");
+	return register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback, NMI_FLAG_FIRST, "smp_stop",
+				    0);
 }
 
 static void native_stop_other_cpus(int wait)
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 5c50e550ab63..473c34eb264c 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -1029,10 +1029,10 @@ static int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
 
 static void uv_register_nmi_notifier(void)
 {
-	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
+	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv", 0))
 		pr_warn("UV: NMI handler failed to register\n");
 
-	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi_ping, 0, "uvping"))
+	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi_ping, 0, "uvping", 0))
 		pr_warn("UV: PING NMI handler failed to register\n");
 }
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index b72772494655..95bd3a64608f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1318,7 +1318,7 @@ static void ghes_nmi_add(struct ghes *ghes)
 {
 	mutex_lock(&ghes_list_mutex);
 	if (list_empty(&ghes_nmi))
-		register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes");
+		register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes", 0);
 	list_add_rcu(&ghes->list, &ghes_nmi);
 	mutex_unlock(&ghes_list_mutex);
 }
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index f1875b2bebbc..5db402c4b9e7 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1267,8 +1267,7 @@ static void check_parms(void)
 		}
 	}
 	if (do_nmi && !nmi_handler_registered) {
-		rv = register_nmi_handler(NMI_UNKNOWN, ipmi_nmi, 0,
-						"ipmi");
+		rv = register_nmi_handler(NMI_UNKNOWN, ipmi_nmi, 0, "ipmi", 0);
 		if (rv) {
 			pr_warn("Can't register nmi handler\n");
 			return;
diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 5807517ee32d..3a6e7334e94c 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1363,8 +1363,7 @@ static int register_err_handler(void)
 		return 0;
 	}
 
-	rc = register_nmi_handler(NMI_SERR, ecclog_nmi_handler,
-				  0, IGEN6_NMI_NAME);
+	rc = register_nmi_handler(NMI_SERR, ecclog_nmi_handler, 0, IGEN6_NMI_NAME, 0);
 	if (rc) {
 		igen6_printk(KERN_ERR, "Failed to register NMI handler\n");
 		return rc;
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index ae30e394d176..5246706afcf6 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -242,13 +242,13 @@ static int hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	/*
 	 * Only one function can register for NMI_UNKNOWN
 	 */
-	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt");
+	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt", 0);
 	if (retval)
 		goto error;
-	retval = register_nmi_handler(NMI_SERR, hpwdt_pretimeout, 0, "hpwdt");
+	retval = register_nmi_handler(NMI_SERR, hpwdt_pretimeout, 0, "hpwdt", 0);
 	if (retval)
 		goto error1;
-	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt");
+	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt", 0);
 	if (retval)
 		goto error2;
 
-- 
2.43.0


