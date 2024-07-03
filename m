Return-Path: <kvm+bounces-20873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 66AB3924DA5
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE7FFB24C5F
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1311E44C87;
	Wed,  3 Jul 2024 02:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OGLV37+T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA7045945;
	Wed,  3 Jul 2024 02:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972783; cv=none; b=o9ckoxnUkeJ51yHYZ/MkUTouEJqnHwj2d0gkDX8ZPqFvTE4ZvT42v9dcEpXMQ3iH01OOyYXIHuDh8HBRMWKTpW91Oeq83B9n6ygcZsaebvCgSBXWO8H4ZM7X5ddiTkHcZf1C9sdLRWDpr143EfdlclRFaM7eUtSpPGNMSa6ixGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972783; c=relaxed/simple;
	bh=Zl1kZq1pxJSML3CbfbN+iyCEBOKjlxxYS2XjXy//qFo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mn0PUUmETkY2/41pZanXHvhKxhgluAn6IyDKulKSBeTa4flaxyDm2J2vy1mgFJA6t0fAxs03iuz9ngpdZnkI/qNxi+DWLtAcoq7NEyQ6W3GtclBAebbBeVhUf1HFA5Y9DvOOPvrbBYd6T3cD14snU/Gjvi8kKVg/CORncCxAQnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OGLV37+T; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972782; x=1751508782;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zl1kZq1pxJSML3CbfbN+iyCEBOKjlxxYS2XjXy//qFo=;
  b=OGLV37+TIbCuIFAtylwl5kRb4OxP+RN3P35tjF7vR7AI9Yx3Hc8y/TtB
   zd21bafRW/izAUFgzKigKJZ3RlXlju3O8e3u84S9JoZ3P03OPiHsN8aol
   yfCY9TXHJYZ5iy9U750IU4/7QjNIR2RfXYt2iOe3j/NYUeYENg0rUZ9M1
   E33YwqruWb6lXMVRe+hirQxFafdfWEdsJ5Dbx9BkTz6xMTkJO6YOOwfLf
   kv3NV+RAqL984jwOgeXZ0/fQwnwIaJAQ/aZDl4WHQBmtaetZ7BS6Xaahv
   quceVf0hY4cddrAjY1IWULssR549xdBr05HImE79Xjv+l2XO1hK3Bie74
   A==;
X-CSE-ConnectionGUID: VJQKb2rtQTqHWkdLM0aUBg==
X-CSE-MsgGUID: WS1cdR2GSWeogCmX8kp+5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311077"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311077"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:01 -0700
X-CSE-ConnectionGUID: K6hM714ZTYGI8vVaMt71uQ==
X-CSE-MsgGUID: TRcay0+3Qge8775M72nq3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148669"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:58 -0700
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
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v5 11/18] x86: pmu: Enable and disable PMCs in loop() asm blob
Date: Wed,  3 Jul 2024 09:57:05 +0000
Message-Id: <20240703095712.64202-12-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
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
index 31b49a74..d005e376 100644
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
@@ -74,13 +83,43 @@ char *buf;
 static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 
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
@@ -180,18 +219,17 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
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
@@ -203,14 +241,24 @@ static void stop_event(pmu_counter_t *evt)
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
@@ -220,9 +268,11 @@ static void measure_one(pmu_counter_t *evt)
 
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
@@ -485,7 +535,7 @@ static void check_running_counter_wrmsr(void)
 	report_prefix_push("running counter wrmsr");
 
 	start_event(&evt);
-	loop();
+	__loop();
 	wrmsr(MSR_GP_COUNTERx(0), 0);
 	stop_event(&evt);
 	report(evt.count < gp_events[instruction_idx].min, "cntr");
@@ -502,7 +552,7 @@ static void check_running_counter_wrmsr(void)
 
 	wrmsr(MSR_GP_COUNTERx(0), count);
 
-	loop();
+	__loop();
 	stop_event(&evt);
 
 	if (this_cpu_has_perf_global_status()) {
@@ -643,7 +693,7 @@ static void warm_up(void)
 	 * the real verification.
 	 */
 	while (i--)
-		loop();
+		loop(0);
 }
 
 static void check_counters(void)
-- 
2.40.1


