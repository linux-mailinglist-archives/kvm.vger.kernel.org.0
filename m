Return-Path: <kvm+bounces-65725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C56CB4E88
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2891A301E1A8
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9AD29A32D;
	Thu, 11 Dec 2025 06:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aACYaang"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD6B29B8C7
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435534; cv=none; b=dS54ARfOQccM/igofGckaVZyk9AYj/W5iZR6y04xU97hbjza4zYeDHRYatpelVTV7gZg+lQ+6k6uJy9kac0MXXsaGB63Ga6CnwHhDFJcIFF+TSEFLoEVhqNiIRIvXfJTCbYSgLC1DmMFAu87/aC+i+PGJ/1vL0AzpY/mgHkhE3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435534; c=relaxed/simple;
	bh=j1lNybIRHI6DJw4Z3blCneXAJwSfecOkeUpkRkadyAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eaiQ/C6fkT+c/7RHjTmh4NuoJ029KMy2BlKkt3O2g5c+N+2GGgH6TT2tCoXPtYtD4+kikensQiZKb3lo9M0T3gfMQ//dsO7QH7o5FTQb0huY0tMhkSAb3RziKGfHpmxS4Z7bT0vW0NTj33PcM4s9pW78EDjSKucq3ad9cnO6Ncw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aACYaang; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765435534; x=1796971534;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j1lNybIRHI6DJw4Z3blCneXAJwSfecOkeUpkRkadyAI=;
  b=aACYaangw5y0RYoyZedNntBsXGx5s/21G/rkV8+/sfm3iijzE2m9FrQ7
   qSmcBeIxBn+2S20RBFlXh95dWL/pOMPcEfVOXLtF99YiIf8if3UrLDrnP
   ZsBHwVPWK+mQraVP7SKrHxlv8XP5Lccm+qZteLnlieqSZ1CFyi0+agj1y
   0tfi5hn6I3lg7bOqgxZRE8QBEnDUfqZDoB1bJqnYKlAXM5Zx8jvbAEyop
   dSSOmfwrYBbQl3zVqWdR6xMZkcTa9iAeEHOQrBJqpdCcdOICKiLyn75OO
   rc/GC9DA9hJ8ULkaw86gCIwEJiMqeM/xxx6tC30GA8OpCeYuLSEqyklzI
   A==;
X-CSE-ConnectionGUID: M8GrmgCCQBGMd3Vke7eoXg==
X-CSE-MsgGUID: ad1MbjclRuiNnQ7dLK/G6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67584481"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67584481"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 22:45:32 -0800
X-CSE-ConnectionGUID: Q2YHT5SBQdOe7je04jo1ZQ==
X-CSE-MsgGUID: gDb1d5ukQtOD7OhQ8nJKJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196495019"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 10 Dec 2025 22:45:29 -0800
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
Subject: [PATCH v2 7/9] i386/cpu: Add APX migration support
Date: Thu, 11 Dec 2025 15:09:40 +0800
Message-Id: <20251211070942.3612547-8-zhao1.liu@intel.com>
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

Add a VMStateDescription to migrate APX EGPRs.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v1:
 * Use CPUX86State.regs instead of a new array.
---
 target/i386/machine.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 0882dc3eb09e..df550dec4749 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1741,6 +1741,28 @@ static const VMStateDescription vmstate_cet = {
     },
 };
 
+#ifdef TARGET_X86_64
+static bool apx_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return !!(env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_APX);
+}
+
+static const VMStateDescription vmstate_apx = {
+    .name = "cpu/apx",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = apx_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINTTL_SUB_ARRAY(env.regs, X86CPU, CPU_NB_REGS,
+                                 CPU_NB_EREGS - CPU_NB_REGS),
+        VMSTATE_END_OF_LIST()
+    }
+};
+#endif
+
 const VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1892,6 +1914,9 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_triple_fault,
         &vmstate_pl0_ssp,
         &vmstate_cet,
+#ifdef TARGET_X86_64
+        &vmstate_apx,
+#endif
         NULL
     }
 };
-- 
2.34.1


