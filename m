Return-Path: <kvm+bounces-65721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AFA6CB4E63
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:46:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44654301673F
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE3128B4FA;
	Thu, 11 Dec 2025 06:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JHD3bTke"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84B223EAB2
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435520; cv=none; b=craKSE5ERh4+AW1NCjRnrd6vNfxx31rLmxxDSOlVX8nloB2F9TdAvuSAqWZfF/jjzwgp6IYqn1zHRZX4V/RHNDSL2lcCQnEFPJhTj5M6b7wTFsM0SzISA99xmAZrO5/BRMnVu0JeuxHqiHX/StSRxLRlw2Y4akMEI+0N7g/AorE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435520; c=relaxed/simple;
	bh=QcNeiWPBJTnDHD4bocxcHnPK2Herab7VuYPe0hXd1Ec=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qiIE9gY9S07bpcCbATswWcr3pWnE1SLlS8CXCUFbnpPg4u2eDDB0DIwnb+3zGgkmTGQYdk88O1XOKMN864sRfGJ/Lu0cU1XKhyXbB8kfj1ojjjYcVCANFB4tV2k3SumXujud5+gyrlvez8Yb2bCazI20wnPqcLY35y1dQ6pf3XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JHD3bTke; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765435519; x=1796971519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QcNeiWPBJTnDHD4bocxcHnPK2Herab7VuYPe0hXd1Ec=;
  b=JHD3bTkeBxTMUlvuPJhCxB5idltlYpUS3239HwtCs8Zip+9P43iPymQd
   W5/0rPef9rQqy76O00/PtM2KWydVGAxqjyNRmQyxxiditGzJ5aZ4IdOGZ
   QC1eb7WDEJtfCGU//+Oay0OFhKe2B4IHZGdWGGnp4KcpDuMTqK88/Vx+1
   xtpeiQ3ltcWm9dXfTTLQQS8KNq4rluhYwUYkqbdW//9O2mroyJoF3yCWE
   Qc3AcGBJVEMAay7Ko9+MFj5nTFdPx6/cqY4MnuPl6H5dDcgFTglyZ/LiP
   s2MEMGJGW6JpiLRDMUhTrsFcs6s8MkW1EQPrY+5RXJwfzKheTaqoL3ka7
   A==;
X-CSE-ConnectionGUID: fV4TStmBSA+fOJhY+xPSHw==
X-CSE-MsgGUID: O7rFD7GvSFiXgUitZRS+kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67584436"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67584436"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 22:45:19 -0800
X-CSE-ConnectionGUID: ZxeGGYAaRgWHAdhTim1vjw==
X-CSE-MsgGUID: sqYc29jNS3GluWcNGbyJzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196494962"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 10 Dec 2025 22:45:15 -0800
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
Subject: [PATCH v2 3/9] i386/cpu: Cache EGPRs in CPUX86State
Date: Thu, 11 Dec 2025 15:09:36 +0800
Message-Id: <20251211070942.3612547-4-zhao1.liu@intel.com>
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

From: Zide Chen <zide.chen@intel.com>

Expend general registers array "regs" of CPUX86State to cache entended
GPRs.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v1:
 * Extend "regs" array instead of a new array.
---
 target/i386/cpu.h          |  7 +++++--
 target/i386/xsave_helper.c | 16 ++++++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 932982bd5dd6..9bf5d0b41efe 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1664,12 +1664,15 @@ typedef struct {
     uint64_t mask;
 } MTRRVar;
 
+#define CPU_NB_EREGS64 32
 #define CPU_NB_REGS64 16
 #define CPU_NB_REGS32 8
 
 #ifdef TARGET_X86_64
+#define CPU_NB_EREGS CPU_NB_EREGS64
 #define CPU_NB_REGS CPU_NB_REGS64
 #else
+#define CPU_NB_EREGS CPU_NB_REGS32
 #define CPU_NB_REGS CPU_NB_REGS32
 #endif
 
@@ -1901,7 +1904,7 @@ typedef struct CPUCaches {
 
 typedef struct CPUArchState {
     /* standard registers */
-    target_ulong regs[CPU_NB_REGS];
+    target_ulong regs[CPU_NB_EREGS];
     target_ulong eip;
     target_ulong eflags; /* eflags register. During CPU emulation, CC
                         flags and DF are set to zero because they are
@@ -1958,7 +1961,7 @@ typedef struct CPUArchState {
     float_status mmx_status; /* for 3DNow! float ops */
     float_status sse_status;
     uint32_t mxcsr;
-    ZMMReg xmm_regs[CPU_NB_REGS == 8 ? 8 : 32] QEMU_ALIGNED(16);
+    ZMMReg xmm_regs[CPU_NB_EREGS] QEMU_ALIGNED(16);
     ZMMReg xmm_t0 QEMU_ALIGNED(16);
     MMXReg mmx_t0;
 
diff --git a/target/i386/xsave_helper.c b/target/i386/xsave_helper.c
index 996e9f3bfef5..bab22587320d 100644
--- a/target/i386/xsave_helper.c
+++ b/target/i386/xsave_helper.c
@@ -140,6 +140,14 @@ void x86_cpu_xsave_all_areas(X86CPU *cpu, void *buf, uint32_t buflen)
 
         memcpy(tiledata, &env->xtiledata, sizeof(env->xtiledata));
     }
+
+    e = &x86_ext_save_areas[XSTATE_APX_BIT];
+    if (e->size && e->offset && buflen) {
+        XSaveAPX *apx = buf + e->offset;
+
+        memcpy(apx, &env->regs[CPU_NB_REGS],
+               sizeof(env->regs[CPU_NB_REGS]) * (CPU_NB_EREGS - CPU_NB_REGS));
+    }
 #endif
 }
 
@@ -275,5 +283,13 @@ void x86_cpu_xrstor_all_areas(X86CPU *cpu, const void *buf, uint32_t buflen)
 
         memcpy(&env->xtiledata, tiledata, sizeof(env->xtiledata));
     }
+
+    e = &x86_ext_save_areas[XSTATE_APX_BIT];
+    if (e->size && e->offset) {
+        const XSaveAPX *apx = buf + e->offset;
+
+        memcpy(&env->regs[CPU_NB_REGS], apx,
+               sizeof(env->regs[CPU_NB_REGS]) * (CPU_NB_EREGS - CPU_NB_REGS));
+    }
 #endif
 }
-- 
2.34.1


