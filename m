Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0A1223E4D
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 16:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGQOjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 10:39:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726855AbgGQOjS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jul 2020 10:39:18 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HEWl6x067581;
        Fri, 17 Jul 2020 10:39:02 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32ax790mb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 10:39:02 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06HEUBma024426;
        Fri, 17 Jul 2020 14:39:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 329nmyk1aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 14:39:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06HEcvD129557112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 14:38:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C23924C044;
        Fri, 17 Jul 2020 14:38:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F05A4C040;
        Fri, 17 Jul 2020 14:38:55 +0000 (GMT)
Received: from localhost.localdomain.localdomain (unknown [9.77.207.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jul 2020 14:38:54 +0000 (GMT)
From:   Athira Rajeev <atrajeev@linux.vnet.ibm.com>
To:     mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, maddy@linux.vnet.ibm.com,
        mikey@neuling.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        ego@linux.vnet.ibm.com, svaidyan@in.ibm.com, acme@kernel.org,
        jolsa@kernel.org
Subject: [v3 08/15] powerpc/perf: power10 Performance Monitoring support
Date:   Fri, 17 Jul 2020 10:38:20 -0400
Message-Id: <1594996707-3727-9-git-send-email-atrajeev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_06:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 suspectscore=1
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Base enablement patch to register performance monitoring
hardware support for power10. Patch introduce the raw event
encoding format, defines the supported list of events, config
fields for the event attributes and their corresponding bit values
which are exported via sysfs.

Patch also enhances the support function in isa207_common.c to
include power10 pmu hardware.

[Enablement of base PMU driver code]
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
[Addition of ISA macros for counter support functions]
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
[Fix compilation warning for missing prototype for init_power10_pmu]
Reported-by: kernel test robot <lkp@intel.com>
---
 arch/powerpc/perf/Makefile              |   2 +-
 arch/powerpc/perf/core-book3s.c         |   2 +
 arch/powerpc/perf/internal.h            |   1 +
 arch/powerpc/perf/isa207-common.c       |  59 ++++-
 arch/powerpc/perf/isa207-common.h       |  33 ++-
 arch/powerpc/perf/power10-events-list.h |  70 ++++++
 arch/powerpc/perf/power10-pmu.c         | 410 ++++++++++++++++++++++++++++++++
 7 files changed, 566 insertions(+), 11 deletions(-)
 create mode 100644 arch/powerpc/perf/power10-events-list.h
 create mode 100644 arch/powerpc/perf/power10-pmu.c

diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
index 53d614e..c02854d 100644
--- a/arch/powerpc/perf/Makefile
+++ b/arch/powerpc/perf/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_PPC_PERF_CTRS)	+= core-book3s.o bhrb.o
 obj64-$(CONFIG_PPC_PERF_CTRS)	+= ppc970-pmu.o power5-pmu.o \
 				   power5+-pmu.o power6-pmu.o power7-pmu.o \
 				   isa207-common.o power8-pmu.o power9-pmu.o \
-				   generic-compat-pmu.o
+				   generic-compat-pmu.o power10-pmu.o
 obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
 
 obj-$(CONFIG_PPC_POWERNV)	+= imc-pmu.o
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index ca32fc0..0ffb757d 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2332,6 +2332,8 @@ static int __init init_ppc64_pmu(void)
 		return 0;
 	else if (!init_power9_pmu())
 		return 0;
+	else if (!init_power10_pmu())
+		return 0;
 	else if (!init_ppc970_pmu())
 		return 0;
 	else
diff --git a/arch/powerpc/perf/internal.h b/arch/powerpc/perf/internal.h
index f755c64..80bbf72 100644
--- a/arch/powerpc/perf/internal.h
+++ b/arch/powerpc/perf/internal.h
@@ -9,4 +9,5 @@
 extern int init_power7_pmu(void);
 extern int init_power8_pmu(void);
 extern int init_power9_pmu(void);
+extern int init_power10_pmu(void);
 extern int init_generic_compat_pmu(void);
diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index 2fe63f2..77643f3 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -55,7 +55,9 @@ static bool is_event_valid(u64 event)
 {
 	u64 valid_mask = EVENT_VALID_MASK;
 
-	if (cpu_has_feature(CPU_FTR_ARCH_300))
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		valid_mask = p10_EVENT_VALID_MASK;
+	else if (cpu_has_feature(CPU_FTR_ARCH_300))
 		valid_mask = p9_EVENT_VALID_MASK;
 
 	return !(event & ~valid_mask);
@@ -69,6 +71,14 @@ static inline bool is_event_marked(u64 event)
 	return false;
 }
 
+static unsigned long sdar_mod_val(u64 event)
+{
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		return p10_SDAR_MODE(event);
+
+	return p9_SDAR_MODE(event);
+}
+
 static void mmcra_sdar_mode(u64 event, unsigned long *mmcra)
 {
 	/*
@@ -79,7 +89,7 @@ static void mmcra_sdar_mode(u64 event, unsigned long *mmcra)
 	 * MMCRA[SDAR_MODE] will be programmed as "0b01" for continous sampling
 	 * mode and will be un-changed when setting MMCRA[63] (Marked events).
 	 *
-	 * Incase of Power9:
+	 * Incase of Power9/power10:
 	 * Marked event: MMCRA[SDAR_MODE] will be set to 0b00 ('No Updates'),
 	 *               or if group already have any marked events.
 	 * For rest
@@ -90,8 +100,8 @@ static void mmcra_sdar_mode(u64 event, unsigned long *mmcra)
 	if (cpu_has_feature(CPU_FTR_ARCH_300)) {
 		if (is_event_marked(event) || (*mmcra & MMCRA_SAMPLE_ENABLE))
 			*mmcra &= MMCRA_SDAR_MODE_NO_UPDATES;
-		else if (p9_SDAR_MODE(event))
-			*mmcra |=  p9_SDAR_MODE(event) << MMCRA_SDAR_MODE_SHIFT;
+		else if (sdar_mod_val(event))
+			*mmcra |= sdar_mod_val(event) << MMCRA_SDAR_MODE_SHIFT;
 		else
 			*mmcra |= MMCRA_SDAR_MODE_DCACHE;
 	} else
@@ -134,7 +144,11 @@ static bool is_thresh_cmp_valid(u64 event)
 	/*
 	 * Check the mantissa upper two bits are not zero, unless the
 	 * exponent is also zero. See the THRESH_CMP_MANTISSA doc.
+	 * Power10: thresh_cmp is replaced by l2_l3 event select.
 	 */
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		return false;
+
 	cmp = (event >> EVENT_THR_CMP_SHIFT) & EVENT_THR_CMP_MASK;
 	exp = cmp >> 7;
 
@@ -251,7 +265,12 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp)
 
 	pmc   = (event >> EVENT_PMC_SHIFT)        & EVENT_PMC_MASK;
 	unit  = (event >> EVENT_UNIT_SHIFT)       & EVENT_UNIT_MASK;
-	cache = (event >> EVENT_CACHE_SEL_SHIFT)  & EVENT_CACHE_SEL_MASK;
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		cache = (event >> EVENT_CACHE_SEL_SHIFT) &
+			p10_EVENT_CACHE_SEL_MASK;
+	else
+		cache = (event >> EVENT_CACHE_SEL_SHIFT) &
+			EVENT_CACHE_SEL_MASK;
 	ebb   = (event >> EVENT_EBB_SHIFT)        & EVENT_EBB_MASK;
 
 	if (pmc) {
@@ -283,7 +302,10 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp)
 	}
 
 	if (unit >= 6 && unit <= 9) {
-		if (cpu_has_feature(CPU_FTR_ARCH_300)) {
+		if (cpu_has_feature(CPU_FTR_ARCH_31) && (unit == 6)) {
+			mask |= CNST_L2L3_GROUP_MASK;
+			value |= CNST_L2L3_GROUP_VAL(event >> p10_L2L3_EVENT_SHIFT);
+		} else if (cpu_has_feature(CPU_FTR_ARCH_300)) {
 			mask  |= CNST_CACHE_GROUP_MASK;
 			value |= CNST_CACHE_GROUP_VAL(event & 0xff);
 
@@ -367,6 +389,7 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
 			       struct perf_event *pevents[])
 {
 	unsigned long mmcra, mmcr1, mmcr2, unit, combine, psel, cache, val;
+	unsigned long mmcr3;
 	unsigned int pmc, pmc_inuse;
 	int i;
 
@@ -379,7 +402,7 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
 			pmc_inuse |= 1 << pmc;
 	}
 
-	mmcra = mmcr1 = mmcr2 = 0;
+	mmcra = mmcr1 = mmcr2 = mmcr3 = 0;
 
 	/* Second pass: assign PMCs, set all MMCR1 fields */
 	for (i = 0; i < n_ev; ++i) {
@@ -438,8 +461,17 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
 			mmcra |= val << MMCRA_THR_CTL_SHIFT;
 			val = (event[i] >> EVENT_THR_SEL_SHIFT) & EVENT_THR_SEL_MASK;
 			mmcra |= val << MMCRA_THR_SEL_SHIFT;
-			val = (event[i] >> EVENT_THR_CMP_SHIFT) & EVENT_THR_CMP_MASK;
-			mmcra |= thresh_cmp_val(val);
+			if (!cpu_has_feature(CPU_FTR_ARCH_31)) {
+				val = (event[i] >> EVENT_THR_CMP_SHIFT) &
+					EVENT_THR_CMP_MASK;
+				mmcra |= thresh_cmp_val(val);
+			}
+		}
+
+		if (cpu_has_feature(CPU_FTR_ARCH_31) && (unit == 6)) {
+			val = (event[i] >> p10_L2L3_EVENT_SHIFT) &
+				p10_EVENT_L2L3_SEL_MASK;
+			mmcr2 |= val << p10_L2L3_SEL_SHIFT;
 		}
 
 		if (event[i] & EVENT_WANTS_BHRB) {
@@ -460,6 +492,14 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
 				mmcr2 |= MMCR2_FCS(pmc);
 		}
 
+		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+			if (pmc <= 4) {
+				val = (event[i] >> p10_EVENT_MMCR3_SHIFT) &
+					p10_EVENT_MMCR3_MASK;
+				mmcr3 |= val << MMCR3_SHIFT(pmc);
+			}
+		}
+
 		hwc[i] = pmc - 1;
 	}
 
@@ -480,6 +520,7 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
 	mmcr->mmcr1 = mmcr1;
 	mmcr->mmcra = mmcra;
 	mmcr->mmcr2 = mmcr2;
+	mmcr->mmcr3 = mmcr3;
 
 	return 0;
 }
diff --git a/arch/powerpc/perf/isa207-common.h b/arch/powerpc/perf/isa207-common.h
index df968fd..044de65 100644
--- a/arch/powerpc/perf/isa207-common.h
+++ b/arch/powerpc/perf/isa207-common.h
@@ -87,6 +87,31 @@
 	 EVENT_LINUX_MASK					|	\
 	 EVENT_PSEL_MASK))
 
+/* Contants to support power10 raw encoding format */
+#define p10_SDAR_MODE_SHIFT		22
+#define p10_SDAR_MODE_MASK		0x3ull
+#define p10_SDAR_MODE(v)		(((v) >> p10_SDAR_MODE_SHIFT) & \
+					p10_SDAR_MODE_MASK)
+#define p10_EVENT_L2L3_SEL_MASK		0x1f
+#define p10_L2L3_SEL_SHIFT		3
+#define p10_L2L3_EVENT_SHIFT		40
+#define p10_EVENT_THRESH_MASK		0xffffull
+#define p10_EVENT_CACHE_SEL_MASK	0x3ull
+#define p10_EVENT_MMCR3_MASK		0x7fffull
+#define p10_EVENT_MMCR3_SHIFT		45
+
+#define p10_EVENT_VALID_MASK		\
+	((p10_SDAR_MODE_MASK   << p10_SDAR_MODE_SHIFT		|	\
+	(p10_EVENT_THRESH_MASK  << EVENT_THRESH_SHIFT)		|	\
+	(EVENT_SAMPLE_MASK     << EVENT_SAMPLE_SHIFT)		|	\
+	(p10_EVENT_CACHE_SEL_MASK  << EVENT_CACHE_SEL_SHIFT)	|	\
+	(EVENT_PMC_MASK        << EVENT_PMC_SHIFT)		|	\
+	(EVENT_UNIT_MASK       << EVENT_UNIT_SHIFT)		|	\
+	(p9_EVENT_COMBINE_MASK << p9_EVENT_COMBINE_SHIFT)	|	\
+	(p10_EVENT_MMCR3_MASK  << p10_EVENT_MMCR3_SHIFT)	|	\
+	(EVENT_MARKED_MASK     << EVENT_MARKED_SHIFT)		|	\
+	 EVENT_LINUX_MASK					|	\
+	EVENT_PSEL_MASK))
 /*
  * Layout of constraint bits:
  *
@@ -135,6 +160,9 @@
 #define CNST_CACHE_PMC4_VAL	(1ull << 54)
 #define CNST_CACHE_PMC4_MASK	CNST_CACHE_PMC4_VAL
 
+#define CNST_L2L3_GROUP_VAL(v)	(((v) & 0x1full) << 55)
+#define CNST_L2L3_GROUP_MASK	CNST_L2L3_GROUP_VAL(0x1f)
+
 /*
  * For NC we are counting up to 4 events. This requires three bits, and we need
  * the fifth event to overflow and set the 4th bit. To achieve that we bias the
@@ -191,7 +219,7 @@
 #define MMCRA_THR_CTR_EXP(v)		(((v) >> MMCRA_THR_CTR_EXP_SHIFT) &\
 						MMCRA_THR_CTR_EXP_MASK)
 
-/* MMCR1 Threshold Compare bit constant for power9 */
+/* MMCRA Threshold Compare bit constant for power9 */
 #define p9_MMCRA_THR_CMP_SHIFT	45
 
 /* Bits in MMCR2 for PowerISA v2.07 */
@@ -202,6 +230,9 @@
 #define MAX_ALT				2
 #define MAX_PMU_COUNTERS		6
 
+/* Bits in MMCR3 for PowerISA v3.10 */
+#define MMCR3_SHIFT(pmc)		(49 - (15 * ((pmc) - 1)))
+
 #define ISA207_SIER_TYPE_SHIFT		15
 #define ISA207_SIER_TYPE_MASK		(0x7ull << ISA207_SIER_TYPE_SHIFT)
 
diff --git a/arch/powerpc/perf/power10-events-list.h b/arch/powerpc/perf/power10-events-list.h
new file mode 100644
index 0000000..60c1b81
--- /dev/null
+++ b/arch/powerpc/perf/power10-events-list.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Performance counter support for POWER10 processors.
+ *
+ * Copyright 2020 Madhavan Srinivasan, IBM Corporation.
+ * Copyright 2020 Athira Rajeev, IBM Corporation.
+ */
+
+/*
+ * Power10 event codes.
+ */
+EVENT(PM_RUN_CYC,				0x600f4);
+EVENT(PM_DISP_STALL_CYC,			0x100f8);
+EVENT(PM_EXEC_STALL,				0x30008);
+EVENT(PM_RUN_INST_CMPL,				0x500fa);
+EVENT(PM_BR_CMPL,                               0x4d05e);
+EVENT(PM_BR_MPRED_CMPL,                         0x400f6);
+
+/* All L1 D cache load references counted at finish, gated by reject */
+EVENT(PM_LD_REF_L1,				0x100fc);
+/* Load Missed L1 */
+EVENT(PM_LD_MISS_L1,				0x3e054);
+/* Store Missed L1 */
+EVENT(PM_ST_MISS_L1,				0x300f0);
+/* L1 cache data prefetches */
+EVENT(PM_LD_PREFETCH_CACHE_LINE_MISS,		0x1002c);
+/* Demand iCache Miss */
+EVENT(PM_L1_ICACHE_MISS,			0x200fc);
+/* Instruction fetches from L1 */
+EVENT(PM_INST_FROM_L1,				0x04080);
+/* Instruction Demand sectors wriittent into IL1 */
+EVENT(PM_INST_FROM_L1MISS,			0x03f00000001c040);
+/* Instruction prefetch written into IL1 */
+EVENT(PM_IC_PREF_REQ,				0x040a0);
+/* The data cache was reloaded from local core's L3 due to a demand load */
+EVENT(PM_DATA_FROM_L3,				0x01340000001c040);
+/* Demand LD - L3 Miss (not L2 hit and not L3 hit) */
+EVENT(PM_DATA_FROM_L3MISS,			0x300fe);
+/* Data PTEG reload */
+EVENT(PM_DTLB_MISS,				0x300fc);
+/* ITLB Reloaded */
+EVENT(PM_ITLB_MISS,				0x400fc);
+
+EVENT(PM_RUN_CYC_ALT,				0x0001e);
+EVENT(PM_RUN_INST_CMPL_ALT,			0x00002);
+
+/*
+ * Memory Access Events
+ *
+ * Primary PMU event used here is PM_MRK_INST_CMPL (0x401e0)
+ * To enable capturing of memory profiling, these MMCRA bits
+ * needs to be programmed and corresponding raw event format
+ * encoding.
+ *
+ * MMCRA bits encoding needed are
+ *     SM (Sampling Mode)
+ *     EM (Eligibility for Random Sampling)
+ *     TECE (Threshold Event Counter Event)
+ *     TS (Threshold Start Event)
+ *     TE (Threshold End Event)
+ *
+ * Corresponding Raw Encoding bits:
+ *     sample [EM,SM]
+ *     thresh_sel (TECE)
+ *     thresh start (TS)
+ *     thresh end (TE)
+ */
+
+EVENT(MEM_LOADS,				0x34340401e0);
+EVENT(MEM_STORES,				0x343c0401e0);
diff --git a/arch/powerpc/perf/power10-pmu.c b/arch/powerpc/perf/power10-pmu.c
new file mode 100644
index 0000000..ba19f40
--- /dev/null
+++ b/arch/powerpc/perf/power10-pmu.c
@@ -0,0 +1,410 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Performance counter support for POWER10 processors.
+ *
+ * Copyright 2020 Madhavan Srinivasan, IBM Corporation.
+ * Copyright 2020 Athira Rajeev, IBM Corporation.
+ */
+
+#define pr_fmt(fmt)	"power10-pmu: " fmt
+
+#include "isa207-common.h"
+#include "internal.h"
+
+/*
+ * Raw event encoding for Power10:
+ *
+ *        60        56        52        48        44        40        36        32
+ * | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - |
+ *   | | [ ]   [ src_match ] [  src_mask ]   | [ ] [ l2l3_sel ]  [  thresh_ctl   ]
+ *   | |  |                                  |  |                         |
+ *   | |  *- IFM (Linux)                     |  |        thresh start/stop -*
+ *   | *- BHRB (Linux)                       |  src_sel
+ *   *- EBB (Linux)                          *invert_bit
+ *
+ *        28        24        20        16        12         8         4         0
+ * | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - |
+ *   [   ] [  sample ]   [ ] [ ]   [ pmc ]   [unit ]   [ ]   m   [    pmcxsel    ]
+ *     |        |        |    |                        |     |
+ *     |        |        |    |                        |     *- mark
+ *     |        |        |    *- L1/L2/L3 cache_sel    |
+ *     |        |        sdar_mode                     |
+ *     |        *- sampling mode for marked events     *- combine
+ *     |
+ *     *- thresh_sel
+ *
+ * Below uses IBM bit numbering.
+ *
+ * MMCR1[x:y] = unit    (PMCxUNIT)
+ * MMCR1[24]   = pmc1combine[0]
+ * MMCR1[25]   = pmc1combine[1]
+ * MMCR1[26]   = pmc2combine[0]
+ * MMCR1[27]   = pmc2combine[1]
+ * MMCR1[28]   = pmc3combine[0]
+ * MMCR1[29]   = pmc3combine[1]
+ * MMCR1[30]   = pmc4combine[0]
+ * MMCR1[31]   = pmc4combine[1]
+ *
+ * if pmc == 3 and unit == 0 and pmcxsel[0:6] == 0b0101011
+ *	MMCR1[20:27] = thresh_ctl
+ * else if pmc == 4 and unit == 0xf and pmcxsel[0:6] == 0b0101001
+ *	MMCR1[20:27] = thresh_ctl
+ * else
+ *	MMCRA[48:55] = thresh_ctl   (THRESH START/END)
+ *
+ * if thresh_sel:
+ *	MMCRA[45:47] = thresh_sel
+ *
+ * if l2l3_sel:
+ * MMCR2[56:60] = l2l3_sel[0:4]
+ *
+ * MMCR1[16] = cache_sel[0]
+ * MMCR1[17] = cache_sel[1]
+ *
+ * if mark:
+ *	MMCRA[63]    = 1		(SAMPLE_ENABLE)
+ *	MMCRA[57:59] = sample[0:2]	(RAND_SAMP_ELIG)
+ *	MMCRA[61:62] = sample[3:4]	(RAND_SAMP_MODE)
+ *
+ * if EBB and BHRB:
+ *	MMCRA[32:33] = IFM
+ *
+ * MMCRA[SDAR_MODE]  = sdar_mode[0:1]
+ */
+
+/*
+ * Some power10 event codes.
+ */
+#define EVENT(_name, _code)     enum{_name = _code}
+
+#include "power10-events-list.h"
+
+#undef EVENT
+
+/* MMCRA IFM bits - POWER10 */
+#define POWER10_MMCRA_IFM1		0x0000000040000000UL
+#define POWER10_MMCRA_BHRB_MASK		0x00000000C0000000UL
+
+/* Table of alternatives, sorted by column 0 */
+static const unsigned int power10_event_alternatives[][MAX_ALT] = {
+	{ PM_RUN_CYC_ALT,		PM_RUN_CYC },
+	{ PM_RUN_INST_CMPL_ALT,		PM_RUN_INST_CMPL },
+};
+
+static int power10_get_alternatives(u64 event, unsigned int flags, u64 alt[])
+{
+	int num_alt = 0;
+
+	num_alt = isa207_get_alternatives(event, alt,
+					  ARRAY_SIZE(power10_event_alternatives), flags,
+					  power10_event_alternatives);
+
+	return num_alt;
+}
+
+GENERIC_EVENT_ATTR(cpu-cycles,			PM_RUN_CYC);
+GENERIC_EVENT_ATTR(instructions,		PM_RUN_INST_CMPL);
+GENERIC_EVENT_ATTR(branch-instructions,		PM_BR_CMPL);
+GENERIC_EVENT_ATTR(branch-misses,		PM_BR_MPRED_CMPL);
+GENERIC_EVENT_ATTR(cache-references,		PM_LD_REF_L1);
+GENERIC_EVENT_ATTR(cache-misses,		PM_LD_MISS_L1);
+GENERIC_EVENT_ATTR(mem-loads,			MEM_LOADS);
+GENERIC_EVENT_ATTR(mem-stores,			MEM_STORES);
+
+CACHE_EVENT_ATTR(L1-dcache-load-misses,		PM_LD_MISS_L1);
+CACHE_EVENT_ATTR(L1-dcache-loads,		PM_LD_REF_L1);
+CACHE_EVENT_ATTR(L1-dcache-prefetches,		PM_LD_PREFETCH_CACHE_LINE_MISS);
+CACHE_EVENT_ATTR(L1-dcache-store-misses,	PM_ST_MISS_L1);
+CACHE_EVENT_ATTR(L1-icache-load-misses,		PM_L1_ICACHE_MISS);
+CACHE_EVENT_ATTR(L1-icache-loads,		PM_INST_FROM_L1);
+CACHE_EVENT_ATTR(L1-icache-prefetches,		PM_IC_PREF_REQ);
+CACHE_EVENT_ATTR(LLC-load-misses,		PM_DATA_FROM_L3MISS);
+CACHE_EVENT_ATTR(LLC-loads,			PM_DATA_FROM_L3);
+CACHE_EVENT_ATTR(branch-load-misses,		PM_BR_MPRED_CMPL);
+CACHE_EVENT_ATTR(branch-loads,			PM_BR_CMPL);
+CACHE_EVENT_ATTR(dTLB-load-misses,		PM_DTLB_MISS);
+CACHE_EVENT_ATTR(iTLB-load-misses,		PM_ITLB_MISS);
+
+static struct attribute *power10_events_attr[] = {
+	GENERIC_EVENT_PTR(PM_RUN_CYC),
+	GENERIC_EVENT_PTR(PM_RUN_INST_CMPL),
+	GENERIC_EVENT_PTR(PM_BR_CMPL),
+	GENERIC_EVENT_PTR(PM_BR_MPRED_CMPL),
+	GENERIC_EVENT_PTR(PM_LD_REF_L1),
+	GENERIC_EVENT_PTR(PM_LD_MISS_L1),
+	GENERIC_EVENT_PTR(MEM_LOADS),
+	GENERIC_EVENT_PTR(MEM_STORES),
+	CACHE_EVENT_PTR(PM_LD_MISS_L1),
+	CACHE_EVENT_PTR(PM_LD_REF_L1),
+	CACHE_EVENT_PTR(PM_LD_PREFETCH_CACHE_LINE_MISS),
+	CACHE_EVENT_PTR(PM_ST_MISS_L1),
+	CACHE_EVENT_PTR(PM_L1_ICACHE_MISS),
+	CACHE_EVENT_PTR(PM_INST_FROM_L1),
+	CACHE_EVENT_PTR(PM_IC_PREF_REQ),
+	CACHE_EVENT_PTR(PM_DATA_FROM_L3MISS),
+	CACHE_EVENT_PTR(PM_DATA_FROM_L3),
+	CACHE_EVENT_PTR(PM_BR_MPRED_CMPL),
+	CACHE_EVENT_PTR(PM_BR_CMPL),
+	CACHE_EVENT_PTR(PM_DTLB_MISS),
+	CACHE_EVENT_PTR(PM_ITLB_MISS),
+	NULL
+};
+
+static struct attribute_group power10_pmu_events_group = {
+	.name = "events",
+	.attrs = power10_events_attr,
+};
+
+PMU_FORMAT_ATTR(event,          "config:0-59");
+PMU_FORMAT_ATTR(pmcxsel,        "config:0-7");
+PMU_FORMAT_ATTR(mark,           "config:8");
+PMU_FORMAT_ATTR(combine,        "config:10-11");
+PMU_FORMAT_ATTR(unit,           "config:12-15");
+PMU_FORMAT_ATTR(pmc,            "config:16-19");
+PMU_FORMAT_ATTR(cache_sel,      "config:20-21");
+PMU_FORMAT_ATTR(sdar_mode,      "config:22-23");
+PMU_FORMAT_ATTR(sample_mode,    "config:24-28");
+PMU_FORMAT_ATTR(thresh_sel,     "config:29-31");
+PMU_FORMAT_ATTR(thresh_stop,    "config:32-35");
+PMU_FORMAT_ATTR(thresh_start,   "config:36-39");
+PMU_FORMAT_ATTR(l2l3_sel,       "config:40-44");
+PMU_FORMAT_ATTR(src_sel,        "config:45-46");
+PMU_FORMAT_ATTR(invert_bit,     "config:47");
+PMU_FORMAT_ATTR(src_mask,       "config:48-53");
+PMU_FORMAT_ATTR(src_match,      "config:54-59");
+
+static struct attribute *power10_pmu_format_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_pmcxsel.attr,
+	&format_attr_mark.attr,
+	&format_attr_combine.attr,
+	&format_attr_unit.attr,
+	&format_attr_pmc.attr,
+	&format_attr_cache_sel.attr,
+	&format_attr_sdar_mode.attr,
+	&format_attr_sample_mode.attr,
+	&format_attr_thresh_sel.attr,
+	&format_attr_thresh_stop.attr,
+	&format_attr_thresh_start.attr,
+	&format_attr_l2l3_sel.attr,
+	&format_attr_src_sel.attr,
+	&format_attr_invert_bit.attr,
+	&format_attr_src_mask.attr,
+	&format_attr_src_match.attr,
+	NULL,
+};
+
+static struct attribute_group power10_pmu_format_group = {
+	.name = "format",
+	.attrs = power10_pmu_format_attr,
+};
+
+static const struct attribute_group *power10_pmu_attr_groups[] = {
+	&power10_pmu_format_group,
+	&power10_pmu_events_group,
+	NULL,
+};
+
+static int power10_generic_events[] = {
+	[PERF_COUNT_HW_CPU_CYCLES] =			PM_RUN_CYC,
+	[PERF_COUNT_HW_INSTRUCTIONS] =			PM_RUN_INST_CMPL,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] =		PM_BR_CMPL,
+	[PERF_COUNT_HW_BRANCH_MISSES] =			PM_BR_MPRED_CMPL,
+	[PERF_COUNT_HW_CACHE_REFERENCES] =		PM_LD_REF_L1,
+	[PERF_COUNT_HW_CACHE_MISSES] =			PM_LD_MISS_L1,
+};
+
+static u64 power10_bhrb_filter_map(u64 branch_sample_type)
+{
+	u64 pmu_bhrb_filter = 0;
+
+	/* BHRB and regular PMU events share the same privilege state
+	 * filter configuration. BHRB is always recorded along with a
+	 * regular PMU event. As the privilege state filter is handled
+	 * in the basic PMC configuration of the accompanying regular
+	 * PMU event, we ignore any separate BHRB specific request.
+	 */
+
+	/* No branch filter requested */
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY)
+		return pmu_bhrb_filter;
+
+	/* Invalid branch filter options - HW does not support */
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
+		return -1;
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL)
+		return -1;
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_CALL)
+		return -1;
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
+		pmu_bhrb_filter |= POWER10_MMCRA_IFM1;
+		return pmu_bhrb_filter;
+	}
+
+	/* Every thing else is unsupported */
+	return -1;
+}
+
+static void power10_config_bhrb(u64 pmu_bhrb_filter)
+{
+	pmu_bhrb_filter &= POWER10_MMCRA_BHRB_MASK;
+
+	/* Enable BHRB filter in PMU */
+	mtspr(SPRN_MMCRA, (mfspr(SPRN_MMCRA) | pmu_bhrb_filter));
+}
+
+#define C(x)	PERF_COUNT_HW_CACHE_##x
+
+/*
+ * Table of generalized cache-related events.
+ * 0 means not supported, -1 means nonsensical, other values
+ * are event codes.
+ */
+static u64 power10_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
+	[C(L1D)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)] = PM_LD_REF_L1,
+			[C(RESULT_MISS)] = PM_LD_MISS_L1,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)] = 0,
+			[C(RESULT_MISS)] = PM_ST_MISS_L1,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)] = PM_LD_PREFETCH_CACHE_LINE_MISS,
+			[C(RESULT_MISS)] = 0,
+		},
+	},
+	[C(L1I)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)] = PM_INST_FROM_L1,
+			[C(RESULT_MISS)] = PM_L1_ICACHE_MISS,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)] = PM_INST_FROM_L1MISS,
+			[C(RESULT_MISS)] = -1,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)] = PM_IC_PREF_REQ,
+			[C(RESULT_MISS)] = 0,
+		},
+	},
+	[C(LL)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)] = PM_DATA_FROM_L3,
+			[C(RESULT_MISS)] = PM_DATA_FROM_L3MISS,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = -1,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = 0,
+		},
+	},
+	 [C(DTLB)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)] = 0,
+			[C(RESULT_MISS)] = PM_DTLB_MISS,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = -1,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = -1,
+		},
+	},
+	[C(ITLB)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)] = 0,
+			[C(RESULT_MISS)] = PM_ITLB_MISS,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = -1,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = -1,
+		},
+	},
+	[C(BPU)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)] = PM_BR_CMPL,
+			[C(RESULT_MISS)] = PM_BR_MPRED_CMPL,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = -1,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = -1,
+		},
+	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = -1,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = -1,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)] = -1,
+			[C(RESULT_MISS)] = -1,
+		},
+	},
+};
+
+#undef C
+
+static struct power_pmu power10_pmu = {
+	.name			= "POWER10",
+	.n_counter		= MAX_PMU_COUNTERS,
+	.add_fields		= ISA207_ADD_FIELDS,
+	.test_adder		= ISA207_TEST_ADDER,
+	.group_constraint_mask	= CNST_CACHE_PMC4_MASK,
+	.group_constraint_val	= CNST_CACHE_PMC4_VAL,
+	.compute_mmcr		= isa207_compute_mmcr,
+	.config_bhrb		= power10_config_bhrb,
+	.bhrb_filter_map	= power10_bhrb_filter_map,
+	.get_constraint		= isa207_get_constraint,
+	.get_alternatives	= power10_get_alternatives,
+	.get_mem_data_src	= isa207_get_mem_data_src,
+	.get_mem_weight		= isa207_get_mem_weight,
+	.disable_pmc		= isa207_disable_pmc,
+	.flags			= PPMU_HAS_SIER | PPMU_ARCH_207S |
+				  PPMU_ARCH_310S,
+	.n_generic		= ARRAY_SIZE(power10_generic_events),
+	.generic_events		= power10_generic_events,
+	.cache_events		= &power10_cache_events,
+	.attr_groups		= power10_pmu_attr_groups,
+	.bhrb_nr		= 32,
+};
+
+int init_power10_pmu(void)
+{
+	int rc;
+
+	/* Comes from cpu_specs[] */
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power10"))
+		return -ENODEV;
+
+	rc = register_power_pmu(&power10_pmu);
+	if (rc)
+		return rc;
+
+	/* Tell userspace that EBB is supported */
+	cur_cpu_spec->cpu_user_features2 |= PPC_FEATURE2_EBB;
+
+	return 0;
+}
-- 
1.8.3.1

