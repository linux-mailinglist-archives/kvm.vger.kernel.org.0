Return-Path: <kvm+bounces-63493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A683C67BDC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:36:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D6CF23643A6
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 06:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8912EB843;
	Tue, 18 Nov 2025 06:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Aoha9Xib"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EB12EA743
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 06:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763447766; cv=none; b=Lh1+Wv06ngNNfmq6klynDoNUi7BnuxL/Vkx4MIAFk9uOoOzXmzP28A5o+KA+JvTh3MuwVyxJuFrjMTVSwDi3jAtmlR9lif2gAHg7ADhRPHi4eyJT6dMk7SWu41Awb9I1hpDbE6KldKFl1mNN8BXKLIX8zxl6wzbACEuHBMSWLVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763447766; c=relaxed/simple;
	bh=WaEyNbjG4OMiMqlQkn69ko2nv922dzbUojBAYOjs2ao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LCBUMJrNXcBEor50C8yBpgYA2xywpqWn1R1bQ/5500yGddnm9m/FqOBQuMp6mkgKorB+z4FdPg0Z4FBSPzOVuVWawh8muIQcjFS3eZNK5YyK5BVX+10ihZiE4JpS6hzSGwFCq/p+xkiFlnvhkoSbJz4FtQk0z94tERNu9cLLUx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Aoha9Xib; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763447766; x=1794983766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WaEyNbjG4OMiMqlQkn69ko2nv922dzbUojBAYOjs2ao=;
  b=Aoha9Xib4xUYyr5Eh/5kabjoaFK7NAVlyY7aDjX92cm++q7ItqjdcaAM
   /Ep0yGIVnoH0BZ8Fqc2yZjIfmcBswa9JHFH6Qzm5R4pWNpPoKaT6Q4Oha
   //jdtxeSOZWKeWQDDvX6Q7+vb0IGdwtDttLTNuQBRBsNvCeqAqE5ZCZLs
   h7I05lLxvfayb2rVWMd0duMCqWdDv9iA89lsEn5BrEntBxOqEhNk/dIJ0
   JdY35vgDSWgw5SUFM93f6RM/DBUNEOzjxj1H/5j81dFZb+oIkitm0o9Cc
   werV/+MKv8Vx6hjGqwvD/37o0DsKF6t1jiwaeU58AQXMusCtDNYnxpfnq
   g==;
X-CSE-ConnectionGUID: KJWLHTE8SC+vusqZADP9qQ==
X-CSE-MsgGUID: V4/QI/zXRhqlJDPT1ZQblQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="82850950"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="82850950"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 22:36:05 -0800
X-CSE-ConnectionGUID: pN+XznNrRACiBN2jjwKSWw==
X-CSE-MsgGUID: Y89YPDNUSVScQRjE6UELnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="189962651"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 17 Nov 2025 22:36:03 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 2/5] i386/cpu: Cache EGPRs in CPUX86State
Date: Tue, 18 Nov 2025 14:58:14 +0800
Message-Id: <20251118065817.835017-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118065817.835017-1-zhao1.liu@intel.com>
References: <20251118065817.835017-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zide Chen <zide.chen@intel.com>

Cache EGPR[16] in CPUX86State to store APX's EGPR value.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.h          |  1 +
 target/i386/xsave_helper.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index bc7e16d6e6c1..48d4d7fcbb9c 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1969,6 +1969,7 @@ typedef struct CPUArchState {
 #ifdef TARGET_X86_64
     uint8_t xtilecfg[64];
     uint8_t xtiledata[8192];
+    uint64_t egprs[EGPR_NUM];
 #endif
 
     /* sysenter registers */
diff --git a/target/i386/xsave_helper.c b/target/i386/xsave_helper.c
index 996e9f3bfef5..2e9265045520 100644
--- a/target/i386/xsave_helper.c
+++ b/target/i386/xsave_helper.c
@@ -140,6 +140,13 @@ void x86_cpu_xsave_all_areas(X86CPU *cpu, void *buf, uint32_t buflen)
 
         memcpy(tiledata, &env->xtiledata, sizeof(env->xtiledata));
     }
+
+    e = &x86_ext_save_areas[XSTATE_APX_BIT];
+    if (e->size && e->offset && buflen) {
+        XSaveAPX *apx = buf + e->offset;
+
+        memcpy(apx, &env->egprs, sizeof(env->egprs));
+    }
 #endif
 }
 
@@ -275,5 +282,12 @@ void x86_cpu_xrstor_all_areas(X86CPU *cpu, const void *buf, uint32_t buflen)
 
         memcpy(&env->xtiledata, tiledata, sizeof(env->xtiledata));
     }
+
+    e = &x86_ext_save_areas[XSTATE_APX_BIT];
+    if (e->size && e->offset) {
+        const XSaveAPX *apx = buf + e->offset;
+
+        memcpy(&env->egprs, apx, sizeof(env->egprs));
+    }
 #endif
 }
-- 
2.34.1


