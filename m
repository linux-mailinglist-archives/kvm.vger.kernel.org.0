Return-Path: <kvm+bounces-36514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F259CA1B70C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:39:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE4E93AE010
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A898B139597;
	Fri, 24 Jan 2025 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LK7SeoEs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7BD482EB
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725929; cv=none; b=qJbTYXDyMDAjcnqsYSbfME89q+fecyNM5DTfw6J3n3D9qcHWAi7k/g309Np6lkFiddbhcTc8SweF6aV4dD8YBbxeVgcg9e4vb42qiV61+tqpHpXHTGvlUZI5pvK6rBksKBoW8Lu2nTWCCsWAPfZaOScdenYHCf/A7pDfgODthrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725929; c=relaxed/simple;
	bh=85XePJaofoFgh2exxL+wI9EtRIBe+GFG6YbreIJ1ZbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GrJms7kl0wUiW/1+eEQ9+tXRS5CmBDor4pX8VErLboC9uKAy0ypDsshdUrmB2ezIdcRXa/3gfMXYShNFeS9HAEQkmz+HAgj6cchAUSXCex86MAaiZNXwBBOGNdf1iDqsCGldgxP7izH075m5l7XBydQkwgracy27C+4q6C6H1Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LK7SeoEs; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725929; x=1769261929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=85XePJaofoFgh2exxL+wI9EtRIBe+GFG6YbreIJ1ZbA=;
  b=LK7SeoEsT2kF1oA3Qj3aYg+IYgxUAd/8hnwg1wMZARrsiQzb/lF+Dku4
   a63IchaZRcU2jmzmPqqYw/tNf8QDnzyItJL8rqnqF+Y5Pq7DYAHhsirc8
   +H5fp4Thy27GUrLZPgBOO+gvlZuP7fUv5lkVyN8pOgsYdxpFVipYTp89l
   p3U4Q/PpFK7EZDrKsem3p4ZfxCNS4fVKqUDEs1cw8PG6jhZUL70hwTGN3
   ytBBdG7uY9UG8Zp5PP9SyHYEbCizMc0OOHyzzDV573hSq8y9SSW2L5zkj
   w6AQxyvi2L03yQTRTJJwYnXgQ62UKk1btsUUMT6EVNUEETLKnqeD1PcPA
   g==;
X-CSE-ConnectionGUID: Rho807jDSd+kV13dJNjy9w==
X-CSE-MsgGUID: 4B8HHJKQRwiGRKS2cLkVjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246457"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246457"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:48 -0800
X-CSE-ConnectionGUID: mMNcARQFQ2m0Qdea8T315A==
X-CSE-MsgGUID: CcvpFmjiSHeAN8kNvKqavA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804358"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:44 -0800
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
Subject: [PATCH v7 28/52] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with GuestPanic facility
Date: Fri, 24 Jan 2025 08:20:24 -0500
Message-Id: <20250124132048.3229049-29-xiaoyao.li@intel.com>
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

Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility

Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v6:
- change error_code of GuestPanicInformationTdx from uint64_t to
  uint32_t, to only contains the bit 31:0 returned in r12.

Changes in v5:
- mention additional error information in gpa when it presents;
- refine the documentation; (Markus)

Changes in v4:
- refine the documentation; (Markus)

Changes in v3:
- Add docmentation of new type and struct; (Daniel)
- refine the error message handling; (Daniel)
---
 qapi/run-state.json   | 31 ++++++++++++++++++--
 system/runstate.c     | 67 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.c | 24 +++++++++++++++-
 3 files changed, 119 insertions(+), 3 deletions(-)

diff --git a/qapi/run-state.json b/qapi/run-state.json
index ce95cfa46b73..e63611780a2c 100644
--- a/qapi/run-state.json
+++ b/qapi/run-state.json
@@ -501,10 +501,12 @@
 #
 # @s390: s390 guest panic information type (Since: 2.12)
 #
+# @tdx: tdx guest panic information type (Since: 9.0)
+#
 # Since: 2.9
 ##
 { 'enum': 'GuestPanicInformationType',
-  'data': [ 'hyper-v', 's390' ] }
+  'data': [ 'hyper-v', 's390', 'tdx' ] }
 
 ##
 # @GuestPanicInformation:
@@ -519,7 +521,8 @@
  'base': {'type': 'GuestPanicInformationType'},
  'discriminator': 'type',
  'data': {'hyper-v': 'GuestPanicInformationHyperV',
-          's390': 'GuestPanicInformationS390'}}
+          's390': 'GuestPanicInformationS390',
+          'tdx' : 'GuestPanicInformationTdx'}}
 
 ##
 # @GuestPanicInformationHyperV:
@@ -598,6 +601,30 @@
           'psw-addr': 'uint64',
           'reason': 'S390CrashReason'}}
 
+##
+# @GuestPanicInformationTdx:
+#
+# TDX Guest panic information specific to TDX, as specified in the
+# "Guest-Hypervisor Communication Interface (GHCI) Specification",
+# section TDG.VP.VMCALL<ReportFatalError>.
+#
+# @error-code: TD-specific error code
+#
+# @message: Human-readable error message provided by the guest. Not
+#     to be trusted.
+#
+# @gpa: guest-physical address of a page that contains more verbose
+#     error information, as zero-terminated string.  Present when the
+#     "GPA valid" bit (bit 63) is set in @error-code.
+#
+#
+# Since: 10.0
+##
+{'struct': 'GuestPanicInformationTdx',
+ 'data': {'error-code': 'uint32',
+          'message': 'str',
+          '*gpa': 'uint64'}}
+
 ##
 # @MEMORY_FAILURE:
 #
diff --git a/system/runstate.c b/system/runstate.c
index 272801d30769..c4244c8915c6 100644
--- a/system/runstate.c
+++ b/system/runstate.c
@@ -565,6 +565,60 @@ static void qemu_system_wakeup(void)
     }
 }
 
+static char *tdx_parse_panic_message(char *message)
+{
+    bool printable = false;
+    char *buf = NULL;
+    int len = 0, i;
+
+    /*
+     * Although message is defined as a json string, we shouldn't
+     * unconditionally treat it as is because the guest generated it and
+     * it's not necessarily trustable.
+     */
+    if (message) {
+        /* The caller guarantees the NULL-terminated string. */
+        len = strlen(message);
+
+        printable = len > 0;
+        for (i = 0; i < len; i++) {
+            if (!(0x20 <= message[i] && message[i] <= 0x7e)) {
+                printable = false;
+                break;
+            }
+        }
+    }
+
+    if (len == 0) {
+        buf = g_malloc(1);
+        buf[0] = '\0';
+    } else {
+        if (!printable) {
+            /* 3 = length of "%02x " */
+            buf = g_malloc(len * 3);
+            for (i = 0; i < len; i++) {
+                if (message[i] == '\0') {
+                    break;
+                } else {
+                    sprintf(buf + 3 * i, "%02x ", message[i]);
+                }
+            }
+            if (i > 0) {
+                /* replace the last ' '(space) to NULL */
+                buf[i * 3 - 1] = '\0';
+            } else {
+                buf[0] = '\0';
+            }
+
+        } else {
+            buf = g_malloc(len);
+            memcpy(buf, message, len);
+        }
+    }
+
+    return buf;
+}
+
 void qemu_system_guest_panicked(GuestPanicInformation *info)
 {
     qemu_log_mask(LOG_GUEST_ERROR, "Guest crashed");
@@ -606,7 +660,20 @@ void qemu_system_guest_panicked(GuestPanicInformation *info)
                           S390CrashReason_str(info->u.s390.reason),
                           info->u.s390.psw_mask,
                           info->u.s390.psw_addr);
+        } else if (info->type == GUEST_PANIC_INFORMATION_TYPE_TDX) {
+            char *message = tdx_parse_panic_message(info->u.tdx.message);
+            qemu_log_mask(LOG_GUEST_ERROR,
+                          "\nTDX guest reports fatal error:"
+                          " error code: 0x%" PRIx32 " error message:\"%s\"\n",
+                          info->u.tdx.error_code, message);
+            g_free(message);
+            if (info->u.tdx.gpa != -1ull) {
+                qemu_log_mask(LOG_GUEST_ERROR, "Additional error information "
+                              "can be found at gpa page: 0x%" PRIx64 "\n",
+                              info->u.tdx.gpa);
+            }
         }
+
         qapi_free_GuestPanicInformation(info);
     }
 }
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index f857fddd839b..591de30eedf4 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -16,6 +16,7 @@
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
 #include "crypto/hash.h"
+#include "system/runstate.h"
 #include "system/system.h"
 #include "exec/ramblock.h"
 
@@ -601,10 +602,25 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
     return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
 }
 
+static void tdx_panicked_on_fatal_error(X86CPU *cpu, uint64_t error_code,
+                                        char *message, uint64_t gpa)
+{
+    GuestPanicInformation *panic_info;
+
+    panic_info = g_new0(GuestPanicInformation, 1);
+    panic_info->type = GUEST_PANIC_INFORMATION_TYPE_TDX;
+    panic_info->u.tdx.error_code = (uint32_t) error_code;
+    panic_info->u.tdx.message = message;
+    panic_info->u.tdx.gpa = gpa;
+
+    qemu_system_guest_panicked(panic_info);
+}
+
 int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run)
 {
     uint64_t error_code = run->system_event.data[0];
     char *message = NULL;
+    uint64_t gpa = -1ull;
 
     if (error_code & 0xffff) {
         error_report("TDX: REPORT_FATAL_ERROR: invalid error code: 0x%lx",
@@ -621,7 +637,13 @@ int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run)
         message[TDX_FATAL_MESSAGE_MAX] = '\0';
     }
 
-    error_report("TD guest reports fatal error. %s", message ? : "");
+#define TDX_REPORT_FATAL_ERROR_GPA_VALID    BIT_ULL(63)
+    if (error_code & TDX_REPORT_FATAL_ERROR_GPA_VALID) {
+        gpa = run->system_event.data[1];
+    }
+
+    tdx_panicked_on_fatal_error(cpu, error_code, message, gpa);
+
     return -1;
 }
 
-- 
2.34.1


