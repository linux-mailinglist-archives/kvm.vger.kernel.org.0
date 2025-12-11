Return-Path: <kvm+bounces-65702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15470CB4CBF
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A7D09301B2D9
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B598F288502;
	Thu, 11 Dec 2025 05:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UcXA2q2D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C766428BA95
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431837; cv=none; b=bOKOXjKhnpGz9tj8kmXvg06l22j1Pqo6d4E7E2Yk8bH1pxZ4IQaHu7JTscYrh9+4cAr+mKS/anXeZc2yKmifR/QUnjnWQQRXXPINW+jvKnaid2KDuuob79q0oBGubqP3dICVmpEx+iy5TCONbw5kmCE/AV2xtINcqCWjlvIQPT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431837; c=relaxed/simple;
	bh=FovsNeUNQb3Mbfo6UFh8WpHvsMB68L7Ws+8KaJE9y0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WUgLrLSejQhlzIqIPZvJOmm8I5khGk3QOSaSyfCgjhpXXNJVvnuYnXPzjSIDu/ffqfKaOSGL2zW522fOxvfc0jsOK50reF9JgM9HbjpVfLTI+yhXw0Qv3IrfSTECSPwQwdmf+vqwMCQEkHLo8trPI55fi9lGIhRcDMhXHDKZrBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UcXA2q2D; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431836; x=1796967836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FovsNeUNQb3Mbfo6UFh8WpHvsMB68L7Ws+8KaJE9y0g=;
  b=UcXA2q2DnkUyi8QH6Ak/HFJGCtmxdT42VKcmJb0wfqLrsHvxpkTX1qaH
   6o80sZcW5P0jTOJt1TPMZWobr/sX6owSSwhX5Ak9+udRb4OoKpzftLQWk
   O9xoR0rL4QfRBK8U/SLUc72zL+8nKIcAw+YnHvBf8vTwU9VTatfOEXSyz
   2i+eKQ3i6kyl+Q3dZUtbmonrAmzAUlHiau4fVIQkYJ+Jyi+Az/+odAmoP
   TVoOXFUAR/2dEQkKbxDM1jOfKH2vMKlpwgvMC7ACb8BVLCmy1/yITZHv3
   EBaK5dWXUvfqvEHar1mWGyLcYMn8IznmUP21urzgTNwGWzziaHZn2yyuV
   g==;
X-CSE-ConnectionGUID: uqg58k9FRzCqN1z5aIUBRA==
X-CSE-MsgGUID: Z+4KWpGUTdaDQzo25hofCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409886"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409886"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:43:55 -0800
X-CSE-ConnectionGUID: JHbUU9LCTeSpZFIdC6bKkw==
X-CSE-MsgGUID: WwYbV4ehQbOgFCvOn3sbzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366081"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:52 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 09/22] i386/cpu: Fix supervisor xstate initialization
Date: Thu, 11 Dec 2025 14:07:48 +0800
Message-Id: <20251211060801.3600039-10-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211060801.3600039-1-zhao1.liu@intel.com>
References: <20251211060801.3600039-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Gao <chao.gao@intel.com>

Arch lbr is a supervisor xstate, but its area is not covered in
x86_cpu_init_xsave().

Fix it by checking supported xss bitmap.

In addition, drop the (uint64_t) type casts for supported_xcr0 since
x86_cpu_get_supported_feature_word() returns uint64_t so that the cast
is not needed. Then ensure line length is within 90 characters.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Fix shift for CXRO high 32 bits.
---
 target/i386/cpu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 62769db3ebb7..859cb889a37c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9711,20 +9711,23 @@ static void x86_cpu_post_initfn(Object *obj)
 static void x86_cpu_init_xsave(void)
 {
     static bool first = true;
-    uint64_t supported_xcr0;
+    uint64_t supported_xcr0, supported_xss;
     int i;
 
     if (first) {
         first = false;
 
         supported_xcr0 =
-            ((uint64_t) x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_HI) << 32) |
+            x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_HI) << 32 |
             x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_LO);
+        supported_xss =
+            x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XSS_HI) << 32 |
+            x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XSS_LO);
 
         for (i = XSTATE_SSE_BIT + 1; i < XSAVE_STATE_AREA_COUNT; i++) {
             ExtSaveArea *esa = &x86_ext_save_areas[i];
 
-            if (!(supported_xcr0 & (1 << i))) {
+            if (!((supported_xcr0 | supported_xss) & (1 << i))) {
                 esa->size = 0;
             }
         }
-- 
2.34.1


