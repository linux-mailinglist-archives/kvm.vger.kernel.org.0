Return-Path: <kvm+bounces-30668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 085389BC5A6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:39:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39EE01C21254
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 056A91FEFD9;
	Tue,  5 Nov 2024 06:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UlnwIWiW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD741FCC63
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788730; cv=none; b=rUudOncCXiPWe4hDPqdKWbpfsYdc+zhv5Cv28AXsQ3JiyVKz7J2MhwhVD84mVf7SyZH13JPdobfhSOuL/rRwRXeGBSngjqjowj9lRiRbTnBjX5vaDy2b3TJd4AARzt74SIDo0QXYWqKeS3zE/CYIxw0YVIUc+FWrLpW5Hd3B+uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788730; c=relaxed/simple;
	bh=nkZUZZFxnGCMa4wnPLMg+4QnO1QTfXvDpRrYii+EGk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BRobEZ1JbzhUNWz2kLWTO4AudX2mDh81lQN78SxCS3SGLOdTkknmlH6HHX5yCVPrysh92z1r3cxCp1RXqU7PQGYXnUgPUaEApRL9oBRHqAjQkoD+AdJVrtNDvQaXADvbf4NZyaiht2eQAUww4zmdH2KB+w8+q0mx12vYd8vtOzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UlnwIWiW; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788729; x=1762324729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nkZUZZFxnGCMa4wnPLMg+4QnO1QTfXvDpRrYii+EGk0=;
  b=UlnwIWiWx8qVUdgBbwuOlUHPhJlmbuSle0raEy4zI9Kip/yqU04AhoF3
   XhqwXM4Pbg5xitPIzps+egixalq78MC0lbwW9a6NcQRNeO5YkntyznnUK
   mCe+5XJIhI3jl27DcI6DTf9QZa/nTzEYwKwhih+7E18yhDfqb2pw+Dkxb
   eb1pcLtTUYBaM1UcKTFM4nJ65wFpxY09Q9lcfgqjUxxWdjdqA1d8/fFel
   vHrGTanIubo/2a2a97Nj70Swr1JW21iQBwonVPsnzRVIR5kgw8nYJCw1d
   67zDqZPX6sBoCLUuahofnPduVy2XkJ5C/BNSiFHrimE2Ew5PXPsAiE/YR
   g==;
X-CSE-ConnectionGUID: B8qzzp6cTMGcJmp1SFS4mA==
X-CSE-MsgGUID: PmA/w4PbQAureUh/nMuxPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689702"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689702"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:38:49 -0800
X-CSE-ConnectionGUID: tBqCUn3tQC6VO3jLGAIGQg==
X-CSE-MsgGUID: Ion8spsGRbqXdvTLwF6aBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989310"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:44 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 34/60] i386/tdx: implement tdx_cpu_realizefn()
Date: Tue,  5 Nov 2024 01:23:42 -0500
Message-Id: <20241105062408.3533704-35-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For TDX guest, KVM doesn't allow phys_bits configuration and the
phys_bits can only be native/host value.

Add the logic to set cpu->phys_bits to host value when user doesn't
give a explicit one and error out when user desires a different one
than host value.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v6:
 - new patches;
---
 target/i386/host-cpu.c |  2 +-
 target/i386/host-cpu.h |  1 +
 target/i386/kvm/tdx.c  | 17 +++++++++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
index 03b9d1b169a5..e2c59e5ae288 100644
--- a/target/i386/host-cpu.c
+++ b/target/i386/host-cpu.c
@@ -15,7 +15,7 @@
 #include "sysemu/sysemu.h"
 
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
index 61fb1f184149..289722a129ce 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -23,6 +23,8 @@
 
 #include <linux/kvm_para.h>
 
+#include "cpu.h"
+#include "host-cpu.h"
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/tdvf.h"
@@ -389,6 +391,20 @@ static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
     object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
 }
 
+static void tdx_cpu_realizefn(X86ConfidentialGuest *cg, CPUState *cs,
+                              Error **errp)
+{
+    X86CPU *cpu = X86_CPU(cs);
+    uint32_t host_phys_bits = host_cpu_phys_bits();
+
+    if (!cpu->phys_bits) {
+        cpu->phys_bits = host_phys_bits;
+    } else if (cpu->phys_bits != host_phys_bits) {
+        error_setg(errp, "TDX only supports host physical bits (%u)",
+                   host_phys_bits);
+    }
+}
+
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
 {
     if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
@@ -733,4 +749,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
     klass->kvm_init = tdx_kvm_init;
     x86_klass->kvm_type = tdx_kvm_type;
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
+    x86_klass->cpu_realizefn = tdx_cpu_realizefn;
 }
-- 
2.34.1


