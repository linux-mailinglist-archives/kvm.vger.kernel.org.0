Return-Path: <kvm+bounces-49329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C707AD7DE3
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:53:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E72663A9A59
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CEB2E6D3B;
	Thu, 12 Jun 2025 21:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LRqFgLXk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5A32D8765;
	Thu, 12 Jun 2025 21:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765036; cv=none; b=LPT41nXakwqOaOzlDSUdVn81JmNH3nTbCXgqU8K48dR/55j0dgcJuO3qMSoLeJck9rD4cGuHey0ExnyEt/XtiqN8UFZzT59SW+04GBxe7W2QwVwcL/LjElijDTKhk7aKXj+p7h2MWhfsHtAQvNGokpeQJq7iEyRAT1TlYCHSVA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765036; c=relaxed/simple;
	bh=wx+UnzyhcoYcIjxMnfjwt2d75sp1lBjQuwAGslQWWB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx+AqiUJWCwBhtiPDSdmvV+ROW/OU9Rc8WlymYqnVh6zeEimfzuOJHj3mD2KGD/jAVufmuB1HQ1xbhRIa3nQF1vbAHuYaKH+58WDIyKrf1IuzSr2aQc4KuQ6hCz96nD/hQZSNpX793YAuQCNq68F9E8OwxwyL89x4MANFUzkmN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LRqFgLXk; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765035; x=1781301035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wx+UnzyhcoYcIjxMnfjwt2d75sp1lBjQuwAGslQWWB0=;
  b=LRqFgLXkXDovoV84UmzWezIE77sG3NEOUGu6sBU9UzJNV3yJn8SAn+nG
   +VrYyonKxHGijDGaoa7t6YxkPakmXlSmn6WiX8+imEhlqbdMxMKQLCXS7
   tLBiE5Q3X0TpLlUSjXv7z6i7LbsaOm5bjJ2lj14d8xp5NjR/NZ0Cp8H3s
   shmBXa/ZdPHvbljmwV0C4nSyws+gqEaYSGXWFbgcrmk5Nklr1aN5c/ZSF
   481wSNj2A0rvmzqO8uOp1O3vjrQVnmibaYDUwch4arR/CX9UdknInszYx
   81aXgyaFkZy2TClI8iSCDQwwICElNDji3Rr1VGD+g+CGQtsr/2oGsc3zu
   g==;
X-CSE-ConnectionGUID: X8UxNGyeQ32NjAtMzzV6Pw==
X-CSE-MsgGUID: YJpUpASxTRa+moGGWIyB6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065386"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065386"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:34 -0700
X-CSE-ConnectionGUID: th5cflvlQBaz4G40fNcT3g==
X-CSE-MsgGUID: hkSE3mUdRl6F+sj6KPmmxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184881990"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:33 -0700
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
Subject: [PATCH v7 08/10] x86/nmi: Enable NMI-source for IPIs delivered as NMIs
Date: Thu, 12 Jun 2025 14:48:47 -0700
Message-ID: <20250612214849.3950094-9-sohil.mehta@intel.com>
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

With the IPI handling APIs ready to support the new NMI encoding, encode
the NMI delivery mode directly with the NMI-source vectors to trigger
NMIs.

Move most of the existing NMI-based IPIs to use the new NMI-source
vectors, except for the microcode rendezvous NMI and the crash reboot
NMI. NMI handling for them is special-cased in exc_nmi() and does not
need NMI-source reporting.

However, in the future, it might be useful to assign a source vector to
all NMI sources to improve isolation and debuggability.

Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v7: No change.

v6: Include asm/nmi.h to avoid compile errors. (LKP)

v5: Encode APIC_DM_NMI directly with the NMI-source vector.
---
 arch/x86/include/asm/apic.h      | 8 ++++++++
 arch/x86/kernel/apic/hw_nmi.c    | 2 +-
 arch/x86/kernel/cpu/mce/inject.c | 2 +-
 arch/x86/kernel/kgdb.c           | 2 +-
 arch/x86/kernel/nmi_selftest.c   | 2 +-
 arch/x86/kernel/smp.c            | 2 +-
 6 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 32cdd81e5e45..5789df1708bd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -14,6 +14,7 @@
 #include <asm/msr.h>
 #include <asm/hardirq.h>
 #include <asm/io.h>
+#include <asm/nmi.h>
 #include <asm/posted_intr.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
@@ -23,6 +24,13 @@
 #define APIC_EXTNMI_ALL		1
 #define APIC_EXTNMI_NONE	2
 
+/* Trigger NMIs with source information */
+#define TEST_NMI		(APIC_DM_NMI | NMIS_VECTOR_TEST)
+#define SMP_STOP_NMI		(APIC_DM_NMI | NMIS_VECTOR_SMP_STOP)
+#define BT_NMI			(APIC_DM_NMI | NMIS_VECTOR_BT)
+#define KGDB_NMI		(APIC_DM_NMI | NMIS_VECTOR_KGDB)
+#define MCE_NMI			(APIC_DM_NMI | NMIS_VECTOR_MCE)
+
 /*
  * Debugging macros
  */
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 4e04f13d2de9..586f4b25feae 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -33,7 +33,7 @@ u64 hw_nmi_get_sample_period(int watchdog_thresh)
 #ifdef arch_trigger_cpumask_backtrace
 static void nmi_raise_cpu_backtrace(cpumask_t *mask)
 {
-	__apic_send_IPI_mask(mask, NMI_VECTOR);
+	__apic_send_IPI_mask(mask, BT_NMI);
 }
 
 void arch_trigger_cpumask_backtrace(const cpumask_t *mask, int exclude_cpu)
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 320068e01c22..81a04836ac74 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -270,7 +270,7 @@ static void __maybe_unused raise_mce(struct mce *m)
 					mce_irq_ipi, NULL, 0);
 				preempt_enable();
 			} else if (m->inject_flags & MCJ_NMI_BROADCAST)
-				__apic_send_IPI_mask(mce_inject_cpumask, NMI_VECTOR);
+				__apic_send_IPI_mask(mce_inject_cpumask, MCE_NMI);
 		}
 		start = jiffies;
 		while (!cpumask_empty(mce_inject_cpumask)) {
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index dfde434d2992..013feeb6a9ef 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -416,7 +416,7 @@ static void kgdb_disable_hw_debug(struct pt_regs *regs)
  */
 void kgdb_roundup_cpus(void)
 {
-	apic_send_IPI_allbutself(NMI_VECTOR);
+	apic_send_IPI_allbutself(KGDB_NMI);
 }
 #endif
 
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index f3918888e494..d5578370b47f 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -72,7 +72,7 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 	/* sync above data before sending NMI */
 	wmb();
 
-	__apic_send_IPI_mask(mask, NMI_VECTOR);
+	__apic_send_IPI_mask(mask, TEST_NMI);
 
 	/* Don't wait longer than a second */
 	timeout = USEC_PER_SEC;
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 1ed065b78467..239e9bf97abb 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -217,7 +217,7 @@ static void native_stop_other_cpus(int wait)
 			pr_emerg("Shutting down cpus with NMI\n");
 
 			for_each_cpu(cpu, &cpus_stop_mask)
-				__apic_send_IPI(cpu, NMI_VECTOR);
+				__apic_send_IPI(cpu, SMP_STOP_NMI);
 		}
 		/*
 		 * Don't wait longer than 10 ms if the caller didn't
-- 
2.43.0


