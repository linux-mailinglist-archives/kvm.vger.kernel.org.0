Return-Path: <kvm+bounces-36537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 821E0A1B72D
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E4FF188336C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5435B8633B;
	Fri, 24 Jan 2025 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h3HwEA5X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273853596F
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737726017; cv=none; b=p8N4Z29IFY8GZ0PeO483bWSHjH3dvRgezAhSdehLvkR4B3iHy4ZVf+/cwF1gzSF47Cc91B3vQIbQOaKP6ImGHOds2MLLJv0OLYzGTHg+ATVxJBwEbKZ2zrUms8uOLiz+KIF3/EmOZ9KN06ion9GINLzQKXRTEc3CNeotKGk83u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737726017; c=relaxed/simple;
	bh=OqgpOogLszpg5BDG/eo1xK00WrrRCqKOdIeFumdWFTk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YpRwPqlYMCPDXHAwflyMhhVA1Qf9qgno1A8A8v7fq48w8LMvprp1uEG3XXyeHqEccFhD0PxAQ/yY4Kn1nw8OkHMaOevDZMdPYc8AOGdeszkne4E3wAGenNcDIRZ15cA/qv0AB11gKOYN+69morvzWQ+W4aYTP2fgPwnwdXrQ//k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h3HwEA5X; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737726014; x=1769262014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OqgpOogLszpg5BDG/eo1xK00WrrRCqKOdIeFumdWFTk=;
  b=h3HwEA5Xrv0DRPKxqP7bAK5+rETo5ykzcbANaikP4s8ZfnNtsLPqssIn
   cbrQz0L2KdzPCFlgKTRJIRkeCMdgypVicenqgvOQV+UbREPY51uSXg7K8
   bqB1hXMJV1TzSFBzn3mm7MYHpNNgviTvuP3tzabFmm3dJCnK/1DjCURyK
   mSaRmnEhqBwZLOxbwWyO92pWVxxoF2viwQNxH3poU2m77rMC1++VVM1Ww
   rCuWFNmZEOI1wbHIRhN/qTNTkiB+JGlQgdY2iuNgo+qQjVD0zupw81ENZ
   4U2a72w58v7dI31cirhmG8vZb+3H0hCgetS2OOa6XlJr1ZoMY5wi/N4Yz
   A==;
X-CSE-ConnectionGUID: SZN2b29AS0KGAKMFxxL7IQ==
X-CSE-MsgGUID: IKUsaSBdQ1GTsAa4yUl8DQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246667"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246667"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:40:13 -0800
X-CSE-ConnectionGUID: Rka8XYisTLCFKxcHr0WtQg==
X-CSE-MsgGUID: T4TiYUwjRJGLYlDfunmQiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804494"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:40:09 -0800
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
Subject: [PATCH v7 51/52] i386/tdx: Validate phys_bits against host value
Date: Fri, 24 Jan 2025 08:20:47 -0500
Message-Id: <20250124132048.3229049-52-xiaoyao.li@intel.com>
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

For TDX guest, the phys_bits is not configurable and can only be
host/native value.

Validate phys_bits inside tdx_check_features().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/host-cpu.c | 2 +-
 target/i386/host-cpu.h | 1 +
 target/i386/kvm/tdx.c  | 8 ++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
index 3e4e85e729c8..8a15af458b05 100644
--- a/target/i386/host-cpu.c
+++ b/target/i386/host-cpu.c
@@ -15,7 +15,7 @@
 #include "system/system.h"
 
 /* Note: Only safe for use on x86(-64) hosts */
-static uint32_t host_cpu_phys_bits(void)
+uint32_t host_cpu_phys_bits(void)
 {
     uint32_t eax;
     uint32_t host_phys_bits;
diff --git a/target/i386/host-cpu.h b/target/i386/host-cpu.h
index 6a9bc918baa4..b97ec01c9bec 100644
--- a/target/i386/host-cpu.h
+++ b/target/i386/host-cpu.h
@@ -10,6 +10,7 @@
 #ifndef HOST_CPU_H
 #define HOST_CPU_H
 
+uint32_t host_cpu_phys_bits(void);
 void host_cpu_instance_init(X86CPU *cpu);
 void host_cpu_max_instance_init(X86CPU *cpu);
 bool host_cpu_realizefn(CPUState *cs, Error **errp);
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index bb75eb06dad9..c906a76c4c0e 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -24,6 +24,7 @@
 
 #include "cpu.h"
 #include "cpu-internal.h"
+#include "host-cpu.h"
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/tdvf.h"
@@ -838,6 +839,13 @@ static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
         return -1;
     }
 
+    if (cpu->phys_bits != host_cpu_phys_bits()) {
+        error_report("TDX requires guest CPU physical bits (%u) "
+                     "to match host CPU physical bits (%u)",
+                     cpu->phys_bits, host_cpu_phys_bits());
+        exit(1);
+    }
+
     return 0;
 }
 
-- 
2.34.1


