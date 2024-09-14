Return-Path: <kvm+bounces-26909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A5DC978EB3
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2304028A88A
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001951D094D;
	Sat, 14 Sep 2024 07:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TXqMVrPH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70411D094B;
	Sat, 14 Sep 2024 07:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297311; cv=none; b=NZ6bau/dZZEGhpjQAL7mRQtpYYk/VJuSxKUAp6CVHW6axiGvwwMfVHKNUm2uAqKIh8NSJq1Qf3uGHLlt6vqGR2MXFULO+wriEOBSpYy7n61WzqxFXt6wfssFcBmZJBGd1kNjPF+TErcimhjLnqzzCgo3wZeSlOOli8wNM0PHvA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297311; c=relaxed/simple;
	bh=bTi4JEytAfv9XQr8gZo88mP9Wtsmpx188j38MU3wAF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UVCYoW71kivBKkXmSS/vEpiYXSoKPVfs1oxfKXhimqmOZztj48C/rYslbKwaxIsCt6pdfDtSDmvyvAP52z6C0K78PcgdmP+1KN6kmkEybYnZqVwoFu0eQrCuVtkfNMZjUSl8C6ZncyYg7H95VLFwiu0k31KBqrRlCq8160QIJGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TXqMVrPH; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297310; x=1757833310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bTi4JEytAfv9XQr8gZo88mP9Wtsmpx188j38MU3wAF8=;
  b=TXqMVrPHOonJMrqC4sq/GntlI4N6yv+zVz+woRutbic9dUDNESTkM6bH
   KMscDBWBIiJcSwzqd3mo7W92bgUPQPdT1qYwVO7ifXRJ/+LjbpbbeQ6pV
   d+/mKf/rEiES20hjCUzSeVIwzDnnXPSZX0ETPW2P4AxhHXoN+kGmY1t1s
   dlErG7X1je/8t9ZBswjKZSkLw/Bh8fd2BMm4Nd+KYZRPU5+a5Tzr05KJU
   4XBEZoiL4ABcCJ43vgLjU1n+1yliuV7m9SeXQJ9DUSScL4qpg3SnHeHDs
   LamLOsi1NprCnTG6Wh39WA1qUnZ20JxiM10xZcj/Ej6cqelYRlNoOiZi6
   A==;
X-CSE-ConnectionGUID: nAvVpfcTQe+nvmlONoiCPA==
X-CSE-MsgGUID: rRnZi0wrSfyfuECxklDgig==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778864"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778864"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:50 -0700
X-CSE-ConnectionGUID: ASuQKp2xTxSTyR9A5j7IRw==
X-CSE-MsgGUID: QHlGzxcRSwuZueFyHGuN/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950998"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:46 -0700
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
Subject: [kvm-unit-tests patch v6 14/18] x86: pmu: Improve LLC misses event verification
Date: Sat, 14 Sep 2024 10:17:24 +0000
Message-Id: <20240914101728.33148-15-dapeng1.mi@linux.intel.com>
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

When running pmu test on SPR, sometimes the following failure is
reported.

1 <= 0 <= 1000000
FAIL: Intel: llc misses-4

Currently The LLC misses occurring only depends on probability. It's
possible that there is no LLC misses happened in the whole loop(),
especially along with processors have larger and larger cache size just
like what we observed on SPR.

Thus, add clflush instruction into the loop() asm blob and ensure once
LLC miss is triggered at least.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 13c7c45d..c9160423 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -20,19 +20,30 @@
 #define EXPECTED_BRNCH 5
 
 
-/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
-#define EXTRA_INSTRNS  (3 + 3)
+/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
+#define EXTRA_INSTRNS  (3 + 3 + 2)
 #define LOOP_INSTRNS   (N * 10 + EXTRA_INSTRNS)
 #define LOOP_BRANCHES  (N)
-#define LOOP_ASM(_wrmsr)						\
+#define LOOP_ASM(_wrmsr, _clflush)					\
 	_wrmsr "\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
+	_clflush "\n\t"                                 		\
+	"mfence;\n\t"                                   		\
 	"1: mov (%1), %2; add $64, %1;\n\t"				\
 	"nop; nop; nop; nop; nop; nop; nop;\n\t"			\
 	"loop 1b;\n\t"							\
 	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
 	_wrmsr "\n\t"
 
+#define _loop_asm(_wrmsr, _clflush)				\
+do {								\
+	asm volatile(LOOP_ASM(_wrmsr, _clflush)			\
+		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
+		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
+		       "0"(N), "1"(buf)				\
+		     : "edi");					\
+} while (0)
+
 typedef struct {
 	uint32_t ctr;
 	uint32_t idx;
@@ -89,14 +100,17 @@ static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 static unsigned int fixed_counters_num;
 
-
 static inline void __loop(void)
 {
 	unsigned long tmp, tmp2, tmp3;
+	u32 global_ctl = 0;
+	u32 eax = 0;
+	u32 edx = 0;
 
-	asm volatile(LOOP_ASM("nop")
-		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
-		     : "0"(N), "1"(buf));
+	if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("nop", "clflush (%1)");
+	else
+		_loop_asm("nop", "nop");
 }
 
 /*
@@ -109,15 +123,14 @@ static inline void __loop(void)
 static inline void __precise_loop(u64 cntrs)
 {
 	unsigned long tmp, tmp2, tmp3;
-	unsigned int global_ctl = pmu.msr_global_ctl;
+	u32 global_ctl = pmu.msr_global_ctl;
 	u32 eax = cntrs & (BIT_ULL(32) - 1);
 	u32 edx = cntrs >> 32;
 
-	asm volatile(LOOP_ASM("wrmsr")
-		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
-		     : "a"(eax), "d"(edx), "c"(global_ctl),
-		       "0"(N), "1"(buf)
-		     : "edi");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("wrmsr", "clflush (%1)");
+	else
+		_loop_asm("wrmsr", "nop");
 }
 
 static inline void loop(u64 cntrs)
-- 
2.40.1


