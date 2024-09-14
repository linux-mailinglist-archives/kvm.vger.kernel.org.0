Return-Path: <kvm+bounces-26907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D115C978EB0
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9640928B9D4
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B79F1CE6E1;
	Sat, 14 Sep 2024 07:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eMopaxQI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B761D016C;
	Sat, 14 Sep 2024 07:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297304; cv=none; b=MfvRwtckpbcrxAKTrF7KgtXUhVMghou7iejnWGDri2/PLiqnSlcpjq5qKeouEJmqgJNaIKp9dpNoNOn836MeYeBr6f7nTodp1ANjnE9cKWpIcGv1oA7INm+ujsk7hppXd4/QDuIxwVNtRmPXHOwjlvraRqynBuLqm0Fc/yF0O+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297304; c=relaxed/simple;
	bh=It/DXjNoq2+jPSGksnuMJgR7XrXtesJ/3Oto5mBW+T0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B8KZNCpMA+FozemhfEbBDMzDwyUAOx23j28XfIBoW/CvpaV4SgE5EMXwkG/E+nroqY91g9tHGxzD3B8ZO9V3crTwzC6zxW57DdfLQ1rEr9e79GvnfS2yvkvXL3oGMVmoRgqFA2in6OVsVzqeJoSO/g1JX8yDILzBwzjpfP1V5uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eMopaxQI; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297303; x=1757833303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=It/DXjNoq2+jPSGksnuMJgR7XrXtesJ/3Oto5mBW+T0=;
  b=eMopaxQI9JeYP2Cje7SlMroUYeBDwVMechn94MI3VdLUi3DPi2Ola2pt
   IcywsEaCYW3nyvialO5HyCLoMO9l1NhcBetAKZbsUHUEvkB+ZELZzZuu6
   l0WfWvAkyfG9mefNGLwSxdNX8s4NmNGA/GZ/uVH1YS36xf2SoWeFCkeK2
   Mzs4NPf7W1CA6nfzj5qcEmzqU+q/c7qOxvTlm/9/5gK0MsqvvQKMlTrqv
   d2m7WsLF4rqSrWcN0yUFCdjdyxp23Yk3U7ZjlrxGX9xToseFUtGJHkyz4
   nJlx01zabzmoTyhkhrXbsiBK1kIAgF2XfoKSz3nqvOlqgWLHy/IwaBNBg
   w==;
X-CSE-ConnectionGUID: ql2ermTVQ02TEqGblJyIsw==
X-CSE-MsgGUID: 3AK6TpaZS7OosF7QBcYgcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778831"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778831"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:43 -0700
X-CSE-ConnectionGUID: o3vkwpLMQhakbp7oz1XUew==
X-CSE-MsgGUID: zUxbij7pRuyW3yaID0oeYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950974"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:40 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v6 12/18] x86: pmu: Enable and disable PMCs in loop() asm blob
Date: Sat, 14 Sep 2024 10:17:22 +0000
Message-Id: <20240914101728.33148-13-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently enabling PMCs, executing loop() and disabling PMCs are divided
3 separated functions. So there could be other instructions executed
between enabling PMCS and running loop() or running loop() and disabling
PMCs, e.g. if there are multiple counters enabled in measure_many()
function, the instructions which enabling the 2nd and more counters
would be counted in by the 1st counter.

So current implementation can only verify the correctness of count by an
rough range rather than a precise count even for instructions and
branches events. Strictly speaking, this verification is meaningless as
the test could still pass even though KVM vPMU has something wrong and
reports an incorrect instructions or branches count which is in the rough
range.

Thus, move the PMCs enabling and disabling into the loop() asm blob and
ensure only the loop asm instructions would be counted, then the
instructions or branches events can be verified with an precise count
instead of an rough range.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 80 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 15 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 91484c77..270f11b9 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -19,6 +19,15 @@
 #define EXPECTED_INSTR 17
 #define EXPECTED_BRNCH 5
 
+#define LOOP_ASM(_wrmsr)						\
+	_wrmsr "\n\t"							\
+	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
+	"1: mov (%1), %2; add $64, %1;\n\t"				\
+	"nop; nop; nop; nop; nop; nop; nop;\n\t"			\
+	"loop 1b;\n\t"							\
+	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
+	_wrmsr "\n\t"
+
 typedef struct {
 	uint32_t ctr;
 	uint32_t idx;
@@ -75,13 +84,43 @@ static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 static unsigned int fixed_counters_num;
 
-static inline void loop(void)
+
+static inline void __loop(void)
+{
+	unsigned long tmp, tmp2, tmp3;
+
+	asm volatile(LOOP_ASM("nop")
+		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
+		     : "0"(N), "1"(buf));
+}
+
+/*
+ * Enable and disable counters in a whole asm blob to ensure
+ * no other instructions are counted in the window between
+ * counters enabling and really LOOP_ASM code executing.
+ * Thus counters can verify instructions and branches events
+ * against precise counts instead of a rough valid count range.
+ */
+static inline void __precise_loop(u64 cntrs)
 {
 	unsigned long tmp, tmp2, tmp3;
+	unsigned int global_ctl = pmu.msr_global_ctl;
+	u32 eax = cntrs & (BIT_ULL(32) - 1);
+	u32 edx = cntrs >> 32;
 
-	asm volatile("1: mov (%1), %2; add $64, %1; nop; nop; nop; nop; nop; nop; nop; loop 1b"
-			: "=c"(tmp), "=r"(tmp2), "=r"(tmp3): "0"(N), "1"(buf));
+	asm volatile(LOOP_ASM("wrmsr")
+		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
+		     : "a"(eax), "d"(edx), "c"(global_ctl),
+		       "0"(N), "1"(buf)
+		     : "edi");
+}
 
+static inline void loop(u64 cntrs)
+{
+	if (!this_cpu_has_perf_global_ctrl())
+		__loop();
+	else
+		__precise_loop(cntrs);
 }
 
 volatile uint64_t irq_received;
@@ -181,18 +220,17 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
 	    ctrl = (ctrl & ~(0xf << shift)) | (usrospmi << shift);
 	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
     }
-    global_enable(evt);
     apic_write(APIC_LVTPC, PMI_VECTOR);
 }
 
 static void start_event(pmu_counter_t *evt)
 {
 	__start_event(evt, 0);
+	global_enable(evt);
 }
 
-static void stop_event(pmu_counter_t *evt)
+static void __stop_event(pmu_counter_t *evt)
 {
-	global_disable(evt);
 	if (is_gp(evt)) {
 		wrmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)),
 		      evt->config & ~EVNTSEL_EN);
@@ -204,14 +242,24 @@ static void stop_event(pmu_counter_t *evt)
 	evt->count = rdmsr(evt->ctr);
 }
 
+static void stop_event(pmu_counter_t *evt)
+{
+	global_disable(evt);
+	__stop_event(evt);
+}
+
 static noinline void measure_many(pmu_counter_t *evt, int count)
 {
 	int i;
+	u64 cntrs = 0;
+
+	for (i = 0; i < count; i++) {
+		__start_event(&evt[i], 0);
+		cntrs |= BIT_ULL(event_to_global_idx(&evt[i]));
+	}
+	loop(cntrs);
 	for (i = 0; i < count; i++)
-		start_event(&evt[i]);
-	loop();
-	for (i = 0; i < count; i++)
-		stop_event(&evt[i]);
+		__stop_event(&evt[i]);
 }
 
 static void measure_one(pmu_counter_t *evt)
@@ -221,9 +269,11 @@ static void measure_one(pmu_counter_t *evt)
 
 static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 {
+	u64 cntrs = BIT_ULL(event_to_global_idx(evt));
+
 	__start_event(evt, count);
-	loop();
-	stop_event(evt);
+	loop(cntrs);
+	__stop_event(evt);
 }
 
 static bool verify_event(uint64_t count, struct pmu_event *e)
@@ -494,7 +544,7 @@ static void check_running_counter_wrmsr(void)
 	report_prefix_push("running counter wrmsr");
 
 	start_event(&evt);
-	loop();
+	__loop();
 	wrmsr(MSR_GP_COUNTERx(0), 0);
 	stop_event(&evt);
 	report(evt.count < gp_events[instruction_idx].min, "cntr");
@@ -511,7 +561,7 @@ static void check_running_counter_wrmsr(void)
 
 	wrmsr(MSR_GP_COUNTERx(0), count);
 
-	loop();
+	__loop();
 	stop_event(&evt);
 
 	if (this_cpu_has_perf_global_status()) {
@@ -652,7 +702,7 @@ static void warm_up(void)
 	 * the real verification.
 	 */
 	while (i--)
-		loop();
+		loop(0);
 }
 
 static void check_counters(void)
-- 
2.40.1


