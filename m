Return-Path: <kvm+bounces-15200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC008AA778
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 411A91C247FD
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D39D7F46A;
	Fri, 19 Apr 2024 03:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ci7pn+oT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2821E7E794;
	Fri, 19 Apr 2024 03:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498379; cv=none; b=R0HAd4+E3cKMi062jpYWC5vJKKiVx/IEF0IlDBpJ9bSML9csmrbv5dnPSKfklFcOK6EL6J1+TUKvjoT/u8QbbKoBb9by01scgvDRUybxwThiTqND92rPQqNWDbQVysdY6uct4X390B1e51GzlxAn/74HHzYGcCfoOo2CcawMYKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498379; c=relaxed/simple;
	bh=TQbV1T1MhLXK57NxsUL2tKSbMLenSbvBlMwDGIbHruw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MzKdjZbdgdpqeWUkNUUzqX2q2BLRGBWwcW72QsHnKwv0GnR+G1rUPl2VQUg1ayXnkVNF8thL8Fb3znIMjrpE7KmVl2kU4h+Ll1Ha8HEEX9DktsYq5jMzB4DcZidSy0TEOmrxsBeV4n8nv9x2+BQvMIw/oyMDDkfPHBwxJzPHlA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ci7pn+oT; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498378; x=1745034378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TQbV1T1MhLXK57NxsUL2tKSbMLenSbvBlMwDGIbHruw=;
  b=ci7pn+oTcK3yLRwCr1zMlrHaDmRHGTbiAsq3dmNSFl4Vk9X2atfNgckn
   KjuE5E5k3ACqvehjnS1xQNyliwMxtzjXrXmQZ6onUjUqLX4WTHg+9UY7h
   RQfpO+KQieeUyG35hAnjXcVZZzg8RkIvynZ03tqwpV59Asj6R/ikjm4/E
   jQc5P8z6gjziI2pT/7mswD8dTWj7sK0LyKXvJeUxwQr7Eu4WZCEzaTvbX
   H+lGIk46OE0S+HJamCnYoYtQRPyz3d77Qu+1uhap+rl071Yuu8AlZCrgt
   tjCI7Sgvrw9uXhuMNx+9aKyWMfB2RnryQTT6i6H93sP49juLWdd/GjPJY
   g==;
X-CSE-ConnectionGUID: /sQtFKRQSzezr/wQ/jKn1Q==
X-CSE-MsgGUID: R83UI8JfRCqA48Aa//7R7A==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565506"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565506"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:46:18 -0700
X-CSE-ConnectionGUID: L8CpPe8FRx60ZEcMD0VbNA==
X-CSE-MsgGUID: b0YqDMtOQe+KMniaNCZwQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410310"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:46:15 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v4 15/17] x86: pmu: Add IBPB indirect jump asm blob
Date: Fri, 19 Apr 2024 11:52:31 +0800
Message-Id: <20240419035233.3837621-16-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
References: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the lower boundary of branch misses event is set to 0.
Strictly speaking 0 shouldn't be a valid count since it can't tell us if
branch misses event counter works correctly or even disabled. Whereas
it's also possible and reasonable that branch misses event count is 0
especailly for such simple loop() program with advanced branch
predictor.

To eliminate such ambiguity and make branch misses event verification
more acccurately, an extra IBPB indirect jump asm blob is appended and
IBPB command is leveraged to clear the branch target buffer and force to
cause a branch miss for the indirect jump.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 55 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index adc7e6c640c1..0b3dd1ba1766 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -18,25 +18,36 @@
 #define EXPECTED_INSTR 17
 #define EXPECTED_BRNCH 5
 
-
-/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
-#define EXTRA_INSTRNS  (3 + 3 + 2)
+#define IBPB_JMP_INSTRNS      7
+#define IBPB_JMP_BRANCHES     1
+#define IBPB_JMP_ASM(_wrmsr)				\
+	"mov $1, %%eax; xor %%edx, %%edx;\n\t"		\
+	"mov $73, %%ecx;\n\t"				\
+	_wrmsr "\n\t"					\
+	"lea 2f, %%rax;\n\t"				\
+	"jmp *%%rax;\n\t"				\
+	"nop;\n\t"					\
+	"2: nop;\n\t"
+
+/* GLOBAL_CTRL enable + disable + clflush/mfence + IBPB_JMP */
+#define EXTRA_INSTRNS  (3 + 3 + 2 + IBPB_JMP_INSTRNS)
 #define LOOP_INSTRNS   (N * 10 + EXTRA_INSTRNS)
-#define LOOP_BRANCHES  (N)
-#define LOOP_ASM(_wrmsr, _clflush)					\
-	_wrmsr "\n\t"							\
+#define LOOP_BRANCHES  (N + IBPB_JMP_BRANCHES)
+#define LOOP_ASM(_wrmsr1, _clflush, _wrmsr2)				\
+	_wrmsr1 "\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
 	_clflush "\n\t"                                 		\
 	"mfence;\n\t"                                   		\
 	"1: mov (%1), %2; add $64, %1;\n\t"				\
 	"nop; nop; nop; nop; nop; nop; nop;\n\t"			\
 	"loop 1b;\n\t"							\
+	IBPB_JMP_ASM(_wrmsr2) 						\
 	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
-	_wrmsr "\n\t"
+	_wrmsr1 "\n\t"
 
-#define _loop_asm(_wrmsr, _clflush)				\
+#define _loop_asm(_wrmsr1, _clflush, _wrmsr2)			\
 do {								\
-	asm volatile(LOOP_ASM(_wrmsr, _clflush)			\
+	asm volatile(LOOP_ASM(_wrmsr1, _clflush, _wrmsr2)	\
 		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
 		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
 		       "0"(N), "1"(buf)				\
@@ -99,6 +110,12 @@ char *buf;
 static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 
+static int has_ibpb(void)
+{
+	return this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
+	       this_cpu_has(X86_FEATURE_AMD_IBPB);
+}
+
 static inline void __loop(void)
 {
 	unsigned long tmp, tmp2, tmp3;
@@ -106,10 +123,14 @@ static inline void __loop(void)
 	u32 eax = 0;
 	u32 edx = 0;
 
-	if (this_cpu_has(X86_FEATURE_CLFLUSH))
-		_loop_asm("nop", "clflush (%1)");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH) && has_ibpb())
+		_loop_asm("nop", "clflush (%1)", "wrmsr");
+	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("nop", "clflush (%1)", "nop");
+	else if (has_ibpb())
+		_loop_asm("nop", "nop", "wrmsr");
 	else
-		_loop_asm("nop", "nop");
+		_loop_asm("nop", "nop", "nop");
 }
 
 /*
@@ -126,10 +147,14 @@ static inline void __precise_loop(u64 cntrs)
 	u32 eax = cntrs & (BIT_ULL(32) - 1);
 	u32 edx = cntrs >> 32;
 
-	if (this_cpu_has(X86_FEATURE_CLFLUSH))
-		_loop_asm("wrmsr", "clflush (%1)");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH) && has_ibpb())
+		_loop_asm("wrmsr", "clflush (%1)", "wrmsr");
+	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("wrmsr", "clflush (%1)", "nop");
+	else if (has_ibpb())
+		_loop_asm("wrmsr", "nop", "wrmsr");
 	else
-		_loop_asm("wrmsr", "nop");
+		_loop_asm("wrmsr", "nop", "nop");
 }
 
 static inline void loop(u64 cntrs)
-- 
2.34.1


