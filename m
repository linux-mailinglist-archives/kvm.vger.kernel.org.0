Return-Path: <kvm+bounces-65723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFCDCB4E6F
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:46:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A210A30189AA
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB9A29C328;
	Thu, 11 Dec 2025 06:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QQjM4OIe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3DA1DE3DF
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435526; cv=none; b=gHQYQIICDt6IUHEDZEehONKEktFzACZSYBZ0DoS/d36y8DnpPJMNIkjEcpSlyOtoO458d/AOWoUy6clBOLf8bR/EiNIMfYKTZ1DuWXBdKOtASA3yNs6/WI7FpdODt6WTmNKEmec0XKywVDUcpmSOWbzZfacsfwQC7nRsYPmM11E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435526; c=relaxed/simple;
	bh=CFa6/whO2jUKzVYTeIsLH5faSzFY4R8NNpzl+PRAX4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KXc/qIsmf9Sz4AzAqEMPWnC3acEyrmAawkRNASoD0xSMNP0UggdrnlapIyXbDhT4kCzKnw1HZ0c8OQVNW9dBoZ1deCREB6iaUSHn5Jtf2bR1xNOgpab6KXQirI9U4ejWokfIOp0XJwy427SIlz6atg8AD+ZQJxPrbKRplpdBy5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QQjM4OIe; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765435526; x=1796971526;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CFa6/whO2jUKzVYTeIsLH5faSzFY4R8NNpzl+PRAX4Y=;
  b=QQjM4OIeueT56qhKJgx1dZ6eox+u5VgU5wa+Aolv1a7XLf60ckGE9gwF
   576D01M1m2aKoageY8WQpq6WPr09kdgpt4a1Cy7jxHwgrr1VlHQ75QXZ3
   ZmoKfyoTRXUwLHPb2SI0XiB9cc1ARbkOQoua6vSTwD4+gkcJ+wgnibaLM
   F15c2GRVUIbbtDVwHv1he5HdN8yh184rbVIGm8mKy1IxEQ5/JArrEQ43G
   vLYNZ8LD7Y0aB7JwCVADhiEMQuNugSJtaesza5af92fyNbmXoYJbJLyu7
   4wT2o5uVNb4ImPbBL+5v0sB02LhlGFNMzBEuPQ3Saw1KWOwDbV7+ZuCDi
   Q==;
X-CSE-ConnectionGUID: BGYdrqupRRSQPrEvJGT+aw==
X-CSE-MsgGUID: 9zeg5yePRZGYaIAhPL8ABQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67584460"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67584460"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 22:45:26 -0800
X-CSE-ConnectionGUID: 4sJvJOJHQF2hRNS+dBsaMw==
X-CSE-MsgGUID: xBF87zguSUaD29drkk+LXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196494997"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 10 Dec 2025 22:45:22 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 5/9] i386/cpu-dump: Dump entended GPRs for APX supported guest
Date: Thu, 11 Dec 2025 15:09:38 +0800
Message-Id: <20251211070942.3612547-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211070942.3612547-1-zhao1.liu@intel.com>
References: <20251211070942.3612547-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dump EGPRs when guest supports APX.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v1:
 * New patch.
---
 target/i386/cpu-dump.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu-dump.c b/target/i386/cpu-dump.c
index 67bf31e0caaf..b51076f87115 100644
--- a/target/i386/cpu-dump.c
+++ b/target/i386/cpu-dump.c
@@ -354,8 +354,7 @@ void x86_cpu_dump_state(CPUState *cs, FILE *f, int flags)
         qemu_fprintf(f, "RAX=%016" PRIx64 " RBX=%016" PRIx64 " RCX=%016" PRIx64 " RDX=%016" PRIx64 "\n"
                      "RSI=%016" PRIx64 " RDI=%016" PRIx64 " RBP=%016" PRIx64 " RSP=%016" PRIx64 "\n"
                      "R8 =%016" PRIx64 " R9 =%016" PRIx64 " R10=%016" PRIx64 " R11=%016" PRIx64 "\n"
-                     "R12=%016" PRIx64 " R13=%016" PRIx64 " R14=%016" PRIx64 " R15=%016" PRIx64 "\n"
-                     "RIP=%016" PRIx64 " RFL=%08x [%c%c%c%c%c%c%c] CPL=%d II=%d A20=%d SMM=%d HLT=%d\n",
+                     "R12=%016" PRIx64 " R13=%016" PRIx64 " R14=%016" PRIx64 " R15=%016" PRIx64 "\n",
                      env->regs[R_EAX],
                      env->regs[R_EBX],
                      env->regs[R_ECX],
@@ -371,7 +370,32 @@ void x86_cpu_dump_state(CPUState *cs, FILE *f, int flags)
                      env->regs[12],
                      env->regs[13],
                      env->regs[14],
-                     env->regs[15],
+                     env->regs[15]);
+
+        if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_APX) {
+            qemu_fprintf(f, "R16=%016" PRIx64 " R17=%016" PRIx64 " R18=%016" PRIx64 " R19=%016" PRIx64 "\n"
+                         "R20=%016" PRIx64 " R21=%016" PRIx64 " R22=%016" PRIx64 " R23=%016" PRIx64 "\n"
+                         "R24=%016" PRIx64 " R25=%016" PRIx64 " R26=%016" PRIx64 " R27=%016" PRIx64 "\n"
+                         "R28=%016" PRIx64 " R29=%016" PRIx64 " R30=%016" PRIx64 " R31=%016" PRIx64 "\n",
+                         env->regs[16],
+                         env->regs[17],
+                         env->regs[18],
+                         env->regs[19],
+                         env->regs[20],
+                         env->regs[21],
+                         env->regs[22],
+                         env->regs[23],
+                         env->regs[24],
+                         env->regs[25],
+                         env->regs[26],
+                         env->regs[27],
+                         env->regs[28],
+                         env->regs[29],
+                         env->regs[30],
+                         env->regs[31]);
+        }
+
+        qemu_fprintf(f, "RIP=%016" PRIx64 " RFL=%08x [%c%c%c%c%c%c%c] CPL=%d II=%d A20=%d SMM=%d HLT=%d\n",
                      env->eip, eflags,
                      eflags & DF_MASK ? 'D' : '-',
                      eflags & CC_O ? 'O' : '-',
-- 
2.34.1


