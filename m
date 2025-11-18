Return-Path: <kvm+bounces-63470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EEDB5C671D1
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 55C9429BF6
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D35324B39;
	Tue, 18 Nov 2025 03:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pxrr1iw0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B91328B7F
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436052; cv=none; b=A4MDQ1hkNR1kz7A6VYqjrutprp0xkG6osNtq/RqyuzhzOeZE9BNuDluPO7olfQUQt74F6RvZDfQ8nhZmS2LYkQsciQ/WTRGhH9gGkYwMCdAsNbpdrthQ7BPvB/0H1LTk6glvt7Aexd+sZcXR5Xd/LtXENWc/o5ka0YaTi2rUQXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436052; c=relaxed/simple;
	bh=FovsNeUNQb3Mbfo6UFh8WpHvsMB68L7Ws+8KaJE9y0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ayYSGFWJEeFZ4Hzqv94Ws4YqYiEDtY1OrhMdDgWqiPBRDDDZcdaXAe84Sm8SzrBldEXxTZxevmUZGnKCc4cZRnDFgneCrc7sTgwOyHpKU9CF68hiG3Xum4y39WS7zdnBDseB4eQOju8HcpdJ1DquAdxLcNdMHw7LTvPhn4GZN4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pxrr1iw0; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436052; x=1794972052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FovsNeUNQb3Mbfo6UFh8WpHvsMB68L7Ws+8KaJE9y0g=;
  b=Pxrr1iw0b1+/xeE/YDHWf1KFkxXzobbVSDrX8Oqr9IR/LM3HDHvCwfA5
   MObrDBOMUqUJAL4JqvcQpUnljq5c7AslXAPWFiM3W1nxfQM53Vuax1xOl
   jvApm4+mip5NkWGYqxufW+Q0Fm5EmQFJ3AL/LIJCGm7QoLcHSk2viCfMn
   /2jKpxGfYT5UCt17WhqFA/HdoN+IKWCKAFETWcGwWt2CTox+zuZwm4PrQ
   5BK+vicL2Hfg8p0ZJ+Gjfzvzl4DkqUj513X/On88eBMVzpRwDu1jS4t6N
   yfQMfoRi0WOod7uyxWKcm8DXPEdFSj9rHQyL8cKAcNuqw1Q9l4gFRzDpn
   g==;
X-CSE-ConnectionGUID: qbskZRtMSCOWFeAu1M14pQ==
X-CSE-MsgGUID: JEuBjVYlQfeKq9X6n2qGNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053820"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053820"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:20:51 -0800
X-CSE-ConnectionGUID: jt3zLP1qQDOpCq+K7ZLdlg==
X-CSE-MsgGUID: xkS3xGu6QFSU7K/EdFT2kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537198"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:20:48 -0800
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
Subject: [PATCH v4 10/23] i386/cpu: Fix supervisor xstate initialization
Date: Tue, 18 Nov 2025 11:42:18 +0800
Message-Id: <20251118034231.704240-11-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118034231.704240-1-zhao1.liu@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
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


