Return-Path: <kvm+bounces-49326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CEEAD7DD3
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 044E93A1B3E
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689802E2F06;
	Thu, 12 Jun 2025 21:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i7iAanpO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CEF2DECCC;
	Thu, 12 Jun 2025 21:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765032; cv=none; b=g6EW2EsfpH4vJacVLsHEp4ih39r5AUUJ1xru6G5R2pTsAue/eSZiYgpoM8+PsDGgK4/0Vwe6Hsl0Rx0m8H6RIMs+RlOGKgOjMaYpO6Zb1D2btoRAomWNVLQKx3ok9MOMwfxhZ7Pz/Q6jPKmirclT69lkU9g6gvdiAtESbSz3ug4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765032; c=relaxed/simple;
	bh=2/xhG0RxEEkF6sBv0GVk6FTgsRwJBueY4hWmcwCEohw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBUTx7XeIL8+worowta0kdKptu677WHVLCFgedcedX5FGeNs/Ya3BDRuoyVmqwbe543ROx/UUzeqrRQh4QW4bx6XurWAZwmUqJK0wPVyAKc4MUaWmCxWSio3RVNlCL8NDTu6n0MLVA6JrBuExgfhE5MRhztzaLO6+cULm8qcrx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i7iAanpO; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765030; x=1781301030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2/xhG0RxEEkF6sBv0GVk6FTgsRwJBueY4hWmcwCEohw=;
  b=i7iAanpOs4lEXXlOLQSODx41EBZZhF480ssfvxIf0CTBxnRdMdlZQfhC
   2w8GOHtk66oREQRw/7fvutO+oKo4WnZyHdJLEC/Y9j/96UnxNSp+3hK7i
   rOQDsAf42BXTT/EhSEzjNKP1rmPmTFTEm8UUYMz6yQ9IUHlzBZWdGLExG
   77tfGO1tye7ghXFoodLyYsyBB7FBIv4s1hd6kAqWHvwipobMCY4jBwwGL
   O5s3YEU98jBpHQoEK7R9rcKF72Isi1ThOQYqXKwE6TwHKCdXPLpQlNoiH
   3ZfJEf6tawOkG0K3g+Aau69lGRVDbNRx2IejKIUNhIr4M6/hufHNndfiu
   Q==;
X-CSE-ConnectionGUID: JbntafMlRu2Pb1iZ3ofNcg==
X-CSE-MsgGUID: SndOTVf0Rke80tYCAdHxDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065332"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065332"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:29 -0700
X-CSE-ConnectionGUID: WFypfaUVSA2ZX/aLhGqxDA==
X-CSE-MsgGUID: YgV9Uhs1SoGU4Z0OHMaH4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184881957"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:29 -0700
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
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v7 04/10] x86/nmi: Extend the registration interface to include the NMI-source vector
Date: Thu, 12 Jun 2025 14:48:43 -0700
Message-ID: <20250612214849.3950094-5-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250612214849.3950094-1-sohil.mehta@intel.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
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

Vector 0 is reserved by the hardware for situations when a source vector
is not used while generating an NMI or the originator could not be
reliably identified. Registering an NMI handler with vector 0 is
equivalent to not using NMI-source reporting.

For now, just extend the interface with no source information (vector 0)
for all the handlers. No functional change intended.

Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
Reviewed-by: Xin Li (Intel) <xin@zytor.com>
---
v7: Use an enum for defining source vectors (DaveH).
    Use NMIS_NO_SOURCE instead of zero (DaveH).
    Add review tag (Xin).

v6: No change.

v5: Split the patch into two parts. This one only extends the interface.
---
 arch/x86/events/amd/ibs.c         |  2 +-
 arch/x86/events/core.c            |  2 +-
 arch/x86/include/asm/nmi.h        | 16 +++++++++++++++-
 arch/x86/kernel/apic/hw_nmi.c     |  3 +--
 arch/x86/kernel/cpu/mce/inject.c  |  2 +-
 arch/x86/kernel/cpu/mshyperv.c    |  2 +-
 arch/x86/kernel/kgdb.c            |  6 ++----
 arch/x86/kernel/nmi_selftest.c    |  6 +++---
 arch/x86/kernel/smp.c             |  4 ++--
 arch/x86/platform/uv/uv_nmi.c     |  4 ++--
 drivers/acpi/apei/ghes.c          |  2 +-
 drivers/char/ipmi/ipmi_watchdog.c |  3 +--
 drivers/edac/igen6_edac.c         |  3 +--
 drivers/watchdog/hpwdt.c          |  6 +++---
 14 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 112f43b23ebf..6f8f0d663f2f 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1485,7 +1485,7 @@ static __init int perf_event_ibs_init(void)
 	if (ret)
 		goto err_op;
 
-	ret = register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs");
+	ret = register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs", NMIS_NO_SOURCE);
 	if (ret)
 		goto err_nmi;
 
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 7610f26dfbd9..ec59837d10d1 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2129,7 +2129,7 @@ static int __init init_hw_perf_events(void)
 		x86_pmu.config_mask = X86_RAW_EVENT_MASK;
 
 	perf_events_lapic_init();
-	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI");
+	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI", NMIS_NO_SOURCE);
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, x86_pmu.cntr_mask64,
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 79d88d12c8fb..42820c4f59b9 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -48,12 +48,24 @@ enum {
 
 typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
 
+/**
+ * enum nmi_source_vectors - NMI-source vectors are used to identify the
+ * origin of an NMI and to route the NMI directly to the appropriate
+ * handler.
+ *
+ * @NMIS_NO_SOURCE:        Reserved for undefined or unidentified sources.
+ */
+enum nmi_source_vectors {
+	NMIS_NO_SOURCE		= 0,
+};
+
 struct nmiaction {
 	struct list_head	list;
 	nmi_handler_t		handler;
 	u64			max_duration;
 	unsigned long		flags;
 	const char		*name;
+	enum nmi_source_vectors	source_vector;
 };
 
 /**
@@ -62,6 +74,7 @@ struct nmiaction {
  * @fn:   The NMI handler
  * @fg:   Flags associated with the NMI handler
  * @n:    Name of the NMI handler
+ * @src:  NMI-source vector for the NMI handler
  * @init: Optional __init* attributes for struct nmiaction
  *
  * Adds the provided handler to the list of handlers for the specified
@@ -75,13 +88,14 @@ struct nmiaction {
  *
  * Return: 0 on success, or an error code on failure.
  */
-#define register_nmi_handler(t, fn, fg, n, init...)	\
+#define register_nmi_handler(t, fn, fg, n, src, init...)\
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
index 45af535c44a0..d09e771723ed 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -53,8 +53,7 @@ NOKPROBE_SYMBOL(nmi_cpu_backtrace_handler);
 
 static int __init register_nmi_cpu_backtrace_handler(void)
 {
-	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler,
-				0, "arch_bt");
+	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", NMIS_NO_SOURCE);
 	return 0;
 }
 early_initcall(register_nmi_cpu_backtrace_handler);
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index d02c4f556cd0..ba70ef8a1964 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -775,7 +775,7 @@ static int __init inject_init(void)
 
 	debugfs_init();
 
-	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify");
+	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify", NMIS_NO_SOURCE);
 	mce_register_injector_chain(&inject_nb);
 
 	setup_inj_struct(&i_mce);
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index c78f860419d6..c093f7baab6a 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -550,7 +550,7 @@ static void __init ms_hyperv_init_platform(void)
 	}
 
 	register_nmi_handler(NMI_UNKNOWN, hv_nmi_unknown, NMI_FLAG_FIRST,
-			     "hv_nmi_unknown");
+			     "hv_nmi_unknown", NMIS_NO_SOURCE);
 #endif
 
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 102641fd2172..ae28fdeefc7f 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -602,13 +602,11 @@ int kgdb_arch_init(void)
 	if (retval)
 		goto out;
 
-	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler,
-					0, "kgdb");
+	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler, 0, "kgdb", NMIS_NO_SOURCE);
 	if (retval)
 		goto out1;
 
-	retval = register_nmi_handler(NMI_UNKNOWN, kgdb_nmi_handler,
-					0, "kgdb");
+	retval = register_nmi_handler(NMI_UNKNOWN, kgdb_nmi_handler, 0, "kgdb", NMIS_NO_SOURCE);
 
 	if (retval)
 		goto out2;
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index a010e9d062bf..c4fffa868160 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -41,7 +41,7 @@ static void __init init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
 	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk",
-			__initdata);
+			     NMIS_NO_SOURCE, __initdata);
 }
 
 static void __init cleanup_nmi_testsuite(void)
@@ -63,8 +63,8 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 {
 	unsigned long timeout;
 
-	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
-				 NMI_FLAG_FIRST, "nmi_selftest", __initdata)) {
+	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback, NMI_FLAG_FIRST,
+				 "nmi_selftest", NMIS_NO_SOURCE, __initdata)) {
 		nmi_fail = FAILURE;
 		return;
 	}
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 18266cc3d98c..c9435730dfb0 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -142,8 +142,8 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
 
 static int register_stop_handler(void)
 {
-	return register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-				    NMI_FLAG_FIRST, "smp_stop");
+	return register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback, NMI_FLAG_FIRST,
+				    "smp_stop", NMIS_NO_SOURCE);
 }
 
 static void native_stop_other_cpus(int wait)
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 5c50e550ab63..5af368710f69 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -1029,10 +1029,10 @@ static int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
 
 static void uv_register_nmi_notifier(void)
 {
-	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
+	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv", NMIS_NO_SOURCE))
 		pr_warn("UV: NMI handler failed to register\n");
 
-	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi_ping, 0, "uvping"))
+	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi_ping, 0, "uvping", NMIS_NO_SOURCE))
 		pr_warn("UV: PING NMI handler failed to register\n");
 }
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index f0584ccad451..5e8632f34769 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1421,7 +1421,7 @@ static void ghes_nmi_add(struct ghes *ghes)
 {
 	mutex_lock(&ghes_list_mutex);
 	if (list_empty(&ghes_nmi))
-		register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes");
+		register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes", NMIS_NO_SOURCE);
 	list_add_rcu(&ghes->list, &ghes_nmi);
 	mutex_unlock(&ghes_list_mutex);
 }
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index ab759b492fdd..944caef3dd31 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1227,8 +1227,7 @@ static void check_parms(void)
 		}
 	}
 	if (do_nmi && !nmi_handler_registered) {
-		rv = register_nmi_handler(NMI_UNKNOWN, ipmi_nmi, 0,
-						"ipmi");
+		rv = register_nmi_handler(NMI_UNKNOWN, ipmi_nmi, 0, "ipmi", NMIS_NO_SOURCE);
 		if (rv) {
 			pr_warn("Can't register nmi handler\n");
 			return;
diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 1930dc00c791..9c7913e5bd3e 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1419,8 +1419,7 @@ static int register_err_handler(void)
 		return 0;
 	}
 
-	rc = register_nmi_handler(NMI_SERR, ecclog_nmi_handler,
-				  0, IGEN6_NMI_NAME);
+	rc = register_nmi_handler(NMI_SERR, ecclog_nmi_handler, 0, IGEN6_NMI_NAME, NMIS_NO_SOURCE);
 	if (rc) {
 		igen6_printk(KERN_ERR, "Failed to register NMI handler\n");
 		return rc;
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index ae30e394d176..90ae59a09270 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -242,13 +242,13 @@ static int hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	/*
 	 * Only one function can register for NMI_UNKNOWN
 	 */
-	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt");
+	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt", NMIS_NO_SOURCE);
 	if (retval)
 		goto error;
-	retval = register_nmi_handler(NMI_SERR, hpwdt_pretimeout, 0, "hpwdt");
+	retval = register_nmi_handler(NMI_SERR, hpwdt_pretimeout, 0, "hpwdt", NMIS_NO_SOURCE);
 	if (retval)
 		goto error1;
-	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt");
+	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt", NMIS_NO_SOURCE);
 	if (retval)
 		goto error2;
 
-- 
2.43.0


