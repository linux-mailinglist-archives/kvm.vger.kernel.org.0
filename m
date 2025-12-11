Return-Path: <kvm+bounces-65722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B0BCB4E58
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:45:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A2BDF3012750
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F29029B8E6;
	Thu, 11 Dec 2025 06:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KczaCiXp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCFD1DE3DF
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435523; cv=none; b=vEUnYIkKq1Zny6W4d7R+l8LisIkRO11NPXRywFmFukTOYzfpDAslzBomkucxefqOVcN+FJRopEolcJ88zMjkJ2md7P/lLc89j0sOu7DykYu2qiYI2ZPLgSPU3xjRSBCiMoNIvG0QwAMM/YpRm7wk0SfdpkxbryNXOMTAh2vuCis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435523; c=relaxed/simple;
	bh=AAwlqTwB410hyqefXXy/dD4A7aaN/xQJizRLgtK6BV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LYn4vbHsAxrxjzBnAeesYgcboV7NMb65k4H8r+PjGyVTPJXbLmJvKmzG3FxQ9CBUObtJ9u7bptRwNjVhcA2QOU1pFuQvzPYmOG1lERksm4WwB0ZId5KsNyY3+5M+svCPKzlc8fyS3iBrTFmRxt/CUIKYNjcj5aOR4nMQVkeVQ/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KczaCiXp; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765435523; x=1796971523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AAwlqTwB410hyqefXXy/dD4A7aaN/xQJizRLgtK6BV8=;
  b=KczaCiXpwJp5FRExsULzmhDP6G6SoSTPxNpMu6/MJychCLkub/0LLSxD
   QxoGb0GRbIFjfHIrRbIq7AEuC6xDUvux0mK5+0joytwJF/6jC12ks61z9
   oX8zncPZbIu968hucFGFPOtpJ/UmOHKs2gg2xFO2MyCVkW0Bsp44qT3rz
   6NEbkeDM3epMS+jRo8RhYbl8ZGgAGlGngRfmGq4GKcleyTj3RzRlGJITu
   TA+Sx7mmxwo45M8UtxyXeBkY8yS5aCsf3Vq3DEAVMbqqWQ5Igxz8ULRBt
   yyfgDofreQlJpluXWkTYnozeDytg8GifgcNTiaKfRk6GfL6GA3GUplwqj
   g==;
X-CSE-ConnectionGUID: ooUVi8TURFeqpSruvh16Ag==
X-CSE-MsgGUID: ozsU+YQwQGSpe8jfdpeHNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67584446"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208,217";a="67584446"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 22:45:22 -0800
X-CSE-ConnectionGUID: vbRkNfnKTRi85KVnVnSreA==
X-CSE-MsgGUID: KaMqOnujSrKZD3Qt8U9Phg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208,217";a="196494981"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 10 Dec 2025 22:45:19 -0800
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
Subject: [PATCH v2 4/9] i386/gdbstub: Add APX support for gdbstub
Date: Thu, 11 Dec 2025 15:09:37 +0800
Message-Id: <20251211070942.3612547-5-zhao1.liu@intel.com>
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

Add i386-64bit-apx.xml from gdb to allow QEMU gdbstub parse APX EGPRs,
and implement the callbacks to allow gdbstub access EGPRs of guest.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v1:
 * New patch.
---
 configs/targets/x86_64-softmmu.mak |  2 +-
 gdb-xml/i386-64bit-apx.xml         | 26 +++++++++++
 target/i386/cpu.h                  | 16 +++++++
 target/i386/gdbstub.c              | 69 +++++++++++++++++++++++++++++-
 4 files changed, 110 insertions(+), 3 deletions(-)
 create mode 100644 gdb-xml/i386-64bit-apx.xml

diff --git a/configs/targets/x86_64-softmmu.mak b/configs/targets/x86_64-softmmu.mak
index 5619b2bc6865..5180560d4d61 100644
--- a/configs/targets/x86_64-softmmu.mak
+++ b/configs/targets/x86_64-softmmu.mak
@@ -2,5 +2,5 @@ TARGET_ARCH=x86_64
 TARGET_BASE_ARCH=i386
 TARGET_KVM_HAVE_GUEST_DEBUG=y
 TARGET_KVM_HAVE_RESET_PARKED_VCPU=y
-TARGET_XML_FILES= gdb-xml/i386-64bit.xml
+TARGET_XML_FILES= gdb-xml/i386-64bit.xml gdb-xml/i386-64bit-apx.xml
 TARGET_LONG_BITS=64
diff --git a/gdb-xml/i386-64bit-apx.xml b/gdb-xml/i386-64bit-apx.xml
new file mode 100644
index 000000000000..11a4ec67cae4
--- /dev/null
+++ b/gdb-xml/i386-64bit-apx.xml
@@ -0,0 +1,26 @@
+<?xml version="1.0"?>
+<!-- Copyright (C) 2024 Free Software Foundation, Inc.
+
+     Copying and distribution of this file, with or without modification,
+     are permitted in any medium without royalty provided the copyright
+     notice and this notice are preserved.  -->
+
+<!DOCTYPE feature SYSTEM "gdb-target.dtd">
+<feature name="org.gnu.gdb.i386.apx">
+  <reg name="r16" bitsize="64" type="int64"/>
+  <reg name="r17" bitsize="64" type="int64"/>
+  <reg name="r18" bitsize="64" type="int64"/>
+  <reg name="r19" bitsize="64" type="int64"/>
+  <reg name="r20" bitsize="64" type="int64"/>
+  <reg name="r21" bitsize="64" type="int64"/>
+  <reg name="r22" bitsize="64" type="int64"/>
+  <reg name="r23" bitsize="64" type="int64"/>
+  <reg name="r24" bitsize="64" type="int64"/>
+  <reg name="r25" bitsize="64" type="int64"/>
+  <reg name="r26" bitsize="64" type="int64"/>
+  <reg name="r27" bitsize="64" type="int64"/>
+  <reg name="r28" bitsize="64" type="int64"/>
+  <reg name="r29" bitsize="64" type="int64"/>
+  <reg name="r30" bitsize="64" type="int64"/>
+  <reg name="r31" bitsize="64" type="int64"/>
+</feature>
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 9bf5d0b41efe..edc18e4b3da8 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -61,6 +61,22 @@ enum {
     R_R13 = 13,
     R_R14 = 14,
     R_R15 = 15,
+    R_R16 = 16,
+    R_R17 = 17,
+    R_R18 = 18,
+    R_R19 = 19,
+    R_R20 = 20,
+    R_R21 = 21,
+    R_R22 = 22,
+    R_R23 = 23,
+    R_R24 = 24,
+    R_R25 = 25,
+    R_R26 = 26,
+    R_R27 = 27,
+    R_R28 = 28,
+    R_R29 = 29,
+    R_R30 = 30,
+    R_R31 = 31,
 
     R_AL = 0,
     R_CL = 1,
diff --git a/target/i386/gdbstub.c b/target/i386/gdbstub.c
index 04c49e802d7d..91943f5ab941 100644
--- a/target/i386/gdbstub.c
+++ b/target/i386/gdbstub.c
@@ -27,9 +27,11 @@
 #endif
 
 #ifdef TARGET_X86_64
-static const int gpr_map[16] = {
+static const int gpr_map[CPU_NB_EREGS] = {
     R_EAX, R_EBX, R_ECX, R_EDX, R_ESI, R_EDI, R_EBP, R_ESP,
-    8, 9, 10, 11, 12, 13, 14, 15
+    R_R8, R_R9, R_R10, R_R11, R_R12, R_R13, R_R14, R_R15,
+    R_R16, R_R17, R_R18, R_R19, R_R20, R_R21, R_R22, R_R23,
+    R_R24, R_R25, R_R26, R_R27, R_R28, R_R29, R_R30, R_R31,
 };
 #else
 #define gpr_map gpr_map32
@@ -444,8 +446,71 @@ static int x86_cpu_gdb_write_linux_register(CPUState *cs, uint8_t *mem_buf,
 
 #endif
 
+#ifdef TARGET_X86_64
+static int i386_cpu_gdb_get_egprs(CPUState *cs, GByteArray *mem_buf, int n)
+{
+    CPUX86State *env = &X86_CPU(cs)->env;
+
+    if (n >= 0 && n < EGPR_NUM) {
+        /* EGPRs can be only directly accessible in 64-bit mode. */
+        if (env->hflags & HF_CS64_MASK) {
+            return gdb_get_reg64(mem_buf, env->regs[gpr_map[n + CPU_NB_REGS]]);
+        } else {
+            return gdb_get_regl(mem_buf, 0);
+        }
+    }
+
+    return 0;
+}
+
+static int i386_cpu_gdb_set_egprs(CPUState *cs, uint8_t *mem_buf, int n)
+{
+    CPUX86State *env = &X86_CPU(cs)->env;
+
+    if (n >= 0 && n < EGPR_NUM) {
+        /*
+         * EGPRs can be only directly accessible in 64-bit mode, and require
+         * XCR0[APX_F] (at least for modification in gdbstub) to be enabled.
+         */
+        if (env->hflags & HF_CS64_MASK && env->xcr0 & XSTATE_APX_MASK) {
+            env->regs[gpr_map[n + CPU_NB_REGS]] = ldtul_p(mem_buf);
+
+            /*
+             * Per SDM Vol 1, "Processor Tracking of XSAVE-Managed State",
+             * XSTATE_BV[i] *may* be either 0 or 1 if the state component is
+             * in its initial configuration.
+             *
+             * However, it is observed on Diamond Rapids (DMR) that
+             * XSTATE_BV[APX_F] is set whenever EGPRs are modified, regardless
+             * of the value written (even if zero).
+             *
+             * Since GDB modifies the software register cache directly,
+             * manually force the bit set to emulate this behavior observed
+             * on hardware.
+             */
+            if (!(env->xstate_bv & XSTATE_APX_MASK)) {
+                env->xstate_bv |= XSTATE_APX_MASK;
+            }
+        }
+        return sizeof(target_ulong);
+    }
+    return 0;
+}
+#endif
+
 void x86_cpu_gdb_init(CPUState *cs)
 {
+#ifdef TARGET_X86_64
+    CPUX86State *env = &X86_CPU(cs)->env;
+
+    if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_APX) {
+        gdb_register_coprocessor(cs, i386_cpu_gdb_get_egprs,
+                                 i386_cpu_gdb_set_egprs,
+                                 gdb_find_static_feature("i386-64bit-apx.xml"),
+                                 0);
+    }
+#endif
+
 #ifdef CONFIG_LINUX_USER
     gdb_register_coprocessor(cs, x86_cpu_gdb_read_linux_register,
                              x86_cpu_gdb_write_linux_register,
-- 
2.34.1


