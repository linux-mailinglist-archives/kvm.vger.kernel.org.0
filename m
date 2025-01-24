Return-Path: <kvm+bounces-36513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F38A6A1B70B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:39:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA8727A42A4
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90AF78F5D;
	Fri, 24 Jan 2025 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jqyrN7w/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EC0482EB
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725925; cv=none; b=h0l71aOS8rEW3b9t+ViIFxcrpCer1t+ht/gVXaQ2A3hEddHbYx+R3C+3hQglUCdCu/IgmOgO4h90C2geB5U185RWB/7WU9KcrmQ08Rr3jI4wSSrSoEYupVAfcZc2Co1gfhmVOnudQGe0PcmdqZvNNYvin7EMMIrOr4wLT8LpmnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725925; c=relaxed/simple;
	bh=PnMivpqsKENYPJ5DahWXLvF1ZEiK4OeXxRfzVf2Js5A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bEdYrlEGmMEf/ejZDr3oaBS6Y6W3UsnJyMOus7Y1nHGr3BBxdKtBj+rtwO5qS8jfO+X3YUMM0HH2T6ukEmwhm4Vm28i3nZkF8OmvtBm5op2uyWcg21WcuOU0Y1XTq/WeOwN/KhtEhgMFWyZolT2DJHjl00iD9/FnRQTRhWbZQOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jqyrN7w/; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725925; x=1769261925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PnMivpqsKENYPJ5DahWXLvF1ZEiK4OeXxRfzVf2Js5A=;
  b=jqyrN7w/g4SvbTCneHmpCfXuu+xOyZq8+OHUaihaJmU99mLCgOmY9PND
   F9PWtgbmwReZ2AhH8a0zZjjDgvuRphvsyU5aWCU4f2n7PRD1KIdJHNmDP
   SosWCWTqnAV1L1g1ad8LOOtGzrLZkITDiF83ORIa4JtGJaHIjLHimLVOf
   PKUSrBc/Rya4w2oMcL1MGfdus4Nr9gnkjJXlaFVQc9RIMSQk+4kI0AdeZ
   K9kqtN7Ey1txikASOddbSTrNozI8jhwhmJ3CHfr+dwEgduwqtlrhQjclb
   1TxxQ/Dl1QGzNpIv1FRi2sMxYPBmaxkAYDIhcvfwoJB4lhTmim0FrhPuM
   A==;
X-CSE-ConnectionGUID: jNuUNd8gSTmPsqEnNSsDSA==
X-CSE-MsgGUID: EbmJHj84TOyzICPzElcqOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246450"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246450"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:44 -0800
X-CSE-ConnectionGUID: iD2telCRSlykT7C4RRvX3Q==
X-CSE-MsgGUID: Q+yP9ClSSDGhPcs6vcezJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804345"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:40 -0800
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
Subject: [PATCH v7 27/52] i386/tdx: Handle KVM_SYSTEM_EVENT_TDX_FATAL
Date: Fri, 24 Jan 2025 08:20:23 -0500
Message-Id: <20250124132048.3229049-28-xiaoyao.li@intel.com>
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

TD guest can use TDG.VP.VMCALL<REPORT_FATAL_ERROR> to request
termination. KVM translates such request into KVM_EXIT_SYSTEM_EVENT with
type of KVM_SYSTEM_EVENT_TDX_FATAL.

Add hanlder for such exit. Parse and print the error message, and
terminate the TD guest in the handler.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v6:
 - replace the patch " i386/tdx: Handle TDG.VP.VMCALL<REPORT_FATAL_ERROR>"
   in v5;
---
 target/i386/kvm/kvm.c      | 10 ++++++++++
 target/i386/kvm/tdx-stub.c |  5 +++++
 target/i386/kvm/tdx.c      | 24 ++++++++++++++++++++++++
 target/i386/kvm/tdx.h      |  2 ++
 4 files changed, 41 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7de5014051eb..a76f34537908 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6128,6 +6128,16 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
     case KVM_EXIT_HYPERCALL:
         ret = kvm_handle_hypercall(run);
         break;
+    case KVM_EXIT_SYSTEM_EVENT:
+        switch (run->system_event.type) {
+        case KVM_SYSTEM_EVENT_TDX_FATAL:
+            ret = tdx_handle_report_fatal_error(cpu, run);
+            break;
+        default:
+            ret = -1;
+            break;
+        }
+        break;
     default:
         fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
         ret = -1;
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index 7748b6d0a446..720a4ff046ee 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -13,3 +13,8 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
 {
     return -EINVAL;
 }
+
+int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 1d0cf29c39f9..f857fddd839b 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -601,6 +601,30 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
     return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
 }
 
+int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run)
+{
+    uint64_t error_code = run->system_event.data[0];
+    char *message = NULL;
+
+    if (error_code & 0xffff) {
+        error_report("TDX: REPORT_FATAL_ERROR: invalid error code: 0x%lx",
+                     error_code);
+        return -1;
+    }
+
+    /* It has optional message */
+    if (run->system_event.data[2]) {
+#define TDX_FATAL_MESSAGE_MAX        64
+        message = g_malloc0(TDX_FATAL_MESSAGE_MAX + 1);
+
+        memcpy(message, &run->system_event.data[2], TDX_FATAL_MESSAGE_MAX);
+        message[TDX_FATAL_MESSAGE_MAX] = '\0';
+    }
+
+    error_report("TD guest reports fatal error. %s", message ? : "");
+    return -1;
+}
+
 static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 36a7400e7480..04b5afe199f9 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -8,6 +8,7 @@
 #endif
 
 #include "confidential-guest.h"
+#include "cpu.h"
 #include "hw/i386/tdvf.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
@@ -59,5 +60,6 @@ bool is_tdx_vm(void);
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
 void tdx_set_tdvf_region(MemoryRegion *tdvf_mr);
 int tdx_parse_tdvf(void *flash_ptr, int size);
+int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


