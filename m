Return-Path: <kvm+bounces-65720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C86CB4E62
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:46:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 227E83013E9B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB2A298CBC;
	Thu, 11 Dec 2025 06:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F18NIbO+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E291129D28A
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435517; cv=none; b=WNX58R9apTRosAUpxxoV08TG5p1YGAyH+hTSaydZ8pRP6aU6NPRMMv5wRqz1Jdr0vH1/mgIudvVriMAJd+419PcyIC/XMrXEAHK5/cxC+QQqZxbzYyFWz3sOC0qzsw1VcL2YEOErQmbZcCc11pbm+IbCVx+lucl+BXJknxTxF28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435517; c=relaxed/simple;
	bh=3LMmQ+qXdaBeNuD7ppu1lZ8wt0GZHeCMjJGChKX52uI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W0O7mdwD7Cdm+qb9QX1VLoPuSK9qMTL9Hc5uwMz6fhwaA1O0eudYpPSu7p7V2FRDcEIl0cLWYZ+ARF1FBp5QXPCifVxyM5qQ6J6h0UCQQtFEnW82R9QLKPS7wMKPmwjUtDIEESLLgqZNQQN3Xv/LUP0aRBLLdGgdTwmR1BEb46k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F18NIbO+; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765435516; x=1796971516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3LMmQ+qXdaBeNuD7ppu1lZ8wt0GZHeCMjJGChKX52uI=;
  b=F18NIbO+L1wEhto45UVXp+R0oJ+Cy4WnpExW2D+BrsFHwdLraVg3d/Ra
   /J2Iwibui4kD5NlduxSnejffcbpKZRZrp6UUPv0FuVg/OrnI0FctqEm9A
   RwWBOKVf3cHCgg4Ti/EB+jAb3Vw84q8GuuALhgAgg2N0I0jDz/3CPuPrC
   y8uGeFSCB+tB79/4mh/jUg8ZSH95WdQLyoMPyn42qN74MdudbtR0QzhgZ
   dPc8NvmbQoKmMXsjOY/Tgnnu5yfDM/2qK69Gtzck32Xn/Xro4+6fSetgJ
   qNInVVBfYBrLULEUeMqQf2joTxCgnr1t4XezdBgHPwkrPqilYtsM0CW1Q
   w==;
X-CSE-ConnectionGUID: Dhf+WLa0Rj+HKvj4mFlu5w==
X-CSE-MsgGUID: XrY4B+sERUOeVCvWumv7hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67584430"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67584430"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 22:45:15 -0800
X-CSE-ConnectionGUID: JzHfmoiFT3GsHnb+rR5rnQ==
X-CSE-MsgGUID: ih5q40xQRais0FNChce/QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196494942"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 10 Dec 2025 22:45:12 -0800
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
Subject: [PATCH v2 2/9] i386/machine: Use VMSTATE_UINTTL_SUB_ARRAY for vmstate of CPUX86State.regs
Date: Thu, 11 Dec 2025 15:09:35 +0800
Message-Id: <20251211070942.3612547-3-zhao1.liu@intel.com>
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

Before expanding the number of elements in the CPUX86State.regs array,
first use VMSTATE_UINTTL_SUB_ARRAY for the regs' vmstate to avoid the
type_check_array failure.

VMSTATE_UINTTL_SUB_ARRAY will also be used for subsequently added elements
in regs array.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v1:
 * New patch.
---
 include/migration/cpu.h | 4 ++++
 target/i386/machine.c   | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/migration/cpu.h b/include/migration/cpu.h
index ca7cc0479e79..1335abe22301 100644
--- a/include/migration/cpu.h
+++ b/include/migration/cpu.h
@@ -21,6 +21,8 @@
     VMSTATE_UINT64_V(_f, _s, _v)
 #define VMSTATE_UINTTL_ARRAY_V(_f, _s, _n, _v)                        \
     VMSTATE_UINT64_ARRAY_V(_f, _s, _n, _v)
+#define VMSTATE_UINTTL_SUB_ARRAY(_f, _s, _start, _num)                \
+    VMSTATE_UINT64_SUB_ARRAY(_f, _s, _start, _num)
 #define VMSTATE_UINTTL_2DARRAY_V(_f, _s, _n1, _n2, _v)                \
     VMSTATE_UINT64_2DARRAY_V(_f, _s, _n1, _n2, _v)
 #define VMSTATE_UINTTL_TEST(_f, _s, _t)                               \
@@ -40,6 +42,8 @@
     VMSTATE_UINT32_V(_f, _s, _v)
 #define VMSTATE_UINTTL_ARRAY_V(_f, _s, _n, _v)                        \
     VMSTATE_UINT32_ARRAY_V(_f, _s, _n, _v)
+#define VMSTATE_UINTTL_SUB_ARRAY(_f, _s, _start, _num)                \
+    VMSTATE_UINT32_SUB_ARRAY(_f, _s, _start, _num)
 #define VMSTATE_UINTTL_2DARRAY_V(_f, _s, _n1, _n2, _v)                \
     VMSTATE_UINT32_2DARRAY_V(_f, _s, _n1, _n2, _v)
 #define VMSTATE_UINTTL_TEST(_f, _s, _t)                               \
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 57a968c30db3..0882dc3eb09e 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1748,7 +1748,7 @@ const VMStateDescription vmstate_x86_cpu = {
     .pre_save = cpu_pre_save,
     .post_load = cpu_post_load,
     .fields = (const VMStateField[]) {
-        VMSTATE_UINTTL_ARRAY(env.regs, X86CPU, CPU_NB_REGS),
+        VMSTATE_UINTTL_SUB_ARRAY(env.regs, X86CPU, 0, CPU_NB_REGS),
         VMSTATE_UINTTL(env.eip, X86CPU),
         VMSTATE_UINTTL(env.eflags, X86CPU),
         VMSTATE_UINT32(env.hflags, X86CPU),
-- 
2.34.1


