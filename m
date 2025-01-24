Return-Path: <kvm+bounces-36531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D6CA1B723
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C40563A222A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B6D0153814;
	Fri, 24 Jan 2025 13:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lBrI+CQP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC58482EB
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725992; cv=none; b=q549OnRGgqqnSehwjyJ/XvOCUW7Joih9SvnWizH0evVtUG2nHPvdmRfLYIj29l7/VW2LdLdrvtIWhfqrZsaBbf6Voe4eBAngGEAdvUAtBRD9+gDyH2h9KrNobyRzB4+o3jXEEJDTpZTSb+yEZCnErqD1dm6z+DseU4kUV/MeFwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725992; c=relaxed/simple;
	bh=MtLjr/vDOT3CoWD5owRZWIVQtD1iwql3z/OowZZmgx4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CGYkJANVeORNySWvwEOsyGBG179kVdr720uImWgfJ2birgfV3yvL/UO+3th1X4bcW0CeLsFt3ysBoZSYG0L6jdByvPI/IfIlw9bYKp9VXvDy+GdknajAvwOqmWCtYzc2Inur4B70SeAJxMrwA4N4zktiliMNb4pNaqewp+fLyC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lBrI+CQP; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725992; x=1769261992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MtLjr/vDOT3CoWD5owRZWIVQtD1iwql3z/OowZZmgx4=;
  b=lBrI+CQP7M1FieLqBarU4KpFaFeKEknhmephQYpy7P/DqdwZrWPukGtl
   /SjyZ192bae6rO7GB0F8NNc0f93WuJyyecp4ACqPqH9/5NT4BtZDyv9QG
   gF6RvulWXmUTpuRMxPN3dOnxPwZanImAbtw8LiQie5y8o32w7Q+ArOCP7
   J5T9T/TIH3b4VZMbhCjms7peMjVEBznwZYR6A+OsRNGTJYkqWjbQYG5P1
   TGezcHB8TbwgP95oB6mUqDKGNI/esep3vOyXstc3N9qmwviNAfcJVHltB
   fgmqEeNfyS76AMUogoD2bk+Y4gHg92ul96mMzXCyjAqeI/E0NtldGxJlT
   g==;
X-CSE-ConnectionGUID: gS9iIzM8TJS7dqJBiIHvYA==
X-CSE-MsgGUID: mvF5p8qLSHW8XPpYjiASkA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246599"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246599"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:51 -0800
X-CSE-ConnectionGUID: 2caIy9gBT8q37pJ029fZIg==
X-CSE-MsgGUID: bGDRdGsuR5WmR5zvmRHLNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804467"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:47 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 45/52] i386/tdx: Mask off CPUID bits by unsupported XFAM
Date: Fri, 24 Jan 2025 08:20:41 -0500
Message-Id: <20250124132048.3229049-46-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mask off the CPUID bits as unsupported if its matched XFAM bit is
not supported. Otherwise, it might fail the check in setup_td_xfam() as
unsupported XFAM being requested.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 3997a439f054..b46e581bb40e 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -22,6 +22,8 @@
 
 #include <linux/kvm_para.h>
 
+#include "cpu.h"
+#include "cpu-internal.h"
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/tdvf.h"
@@ -579,6 +581,42 @@ static void tdx_mask_cpuid_by_attrs(uint32_t feature, uint32_t index,
     }
 }
 
+static void tdx_mask_cpuid_by_xfam(uint32_t feature, uint32_t index,
+                                          int reg, uint32_t *value)
+{
+    const FeatureWordInfo *f;
+    const ExtSaveArea *esa;
+    uint64_t unavail = 0;
+    int i;
+
+    assert(tdx_caps);
+
+    for (i = 0; i < ARRAY_SIZE(x86_ext_save_areas); i++) {
+        if ((1ULL << i) & tdx_caps->supported_xfam) {
+            continue;
+        }
+
+        if (!((1ULL << i) & CPUID_XSTATE_MASK)) {
+            continue;
+        }
+
+        esa = &x86_ext_save_areas[i];
+        f = &feature_word_info[esa->feature];
+        assert(f->type == CPUID_FEATURE_WORD);
+        if (f->cpuid.eax != feature ||
+            (f->cpuid.needs_ecx && f->cpuid.ecx != index) ||
+            f->cpuid.reg != reg) {
+            continue;
+        }
+
+        unavail |= esa->bits;
+    }
+
+    if (unavail) {
+        *value &= ~unavail;
+    }
+}
+
 static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
                                           uint32_t feature, uint32_t index,
                                           int reg, uint32_t value)
@@ -613,6 +651,7 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
     }
 
     tdx_mask_cpuid_by_attrs(feature, index, reg, &value);
+    tdx_mask_cpuid_by_xfam(feature, index, reg, &value);
 
     e = cpuid_find_entry(&tdx_fixed0_bits.cpuid, feature, index);
     if (e) {
-- 
2.34.1


