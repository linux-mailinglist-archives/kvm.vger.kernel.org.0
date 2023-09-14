Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EEB79FCDA
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbjINHL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbjINHLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:11:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12F4CF3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694675481; x=1726211481;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qfXnIUxMTE6xLftgRnkcEC0UN7IUhAHLoHV7+tKuZxw=;
  b=EEzRhFgaBthZ6saa66SXegBWF+cawcK0ma9CjClU12h0oppf5Ci7IFhl
   5YuNZt7HRIS/Y0mmNsOop1QjLkllHSAmqF33peMR5KaGoKhWenSzZJAs8
   pT5h/J0o2qC5o6i3E6XUHDs0DwQrYxifWqs5HR+CstSR9v97qBe9AU2Eg
   x9L4lrlLjL0J4PArZUYeVQgVBkha0Sd48Hs+AB3Cq63Fkc0LE7KmEkC8E
   41prDM8iXDiQrangvONdq0FQrd963EAL+FMgcQ/pjqAuhvr51DoTyNH6B
   5PAxXcndRxZky4CRUc9p/wqf1siNHOS4f1cvdOkhfCuFpW9tfkc+Cr0B7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="359135800"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="359135800"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 00:11:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779526021"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779526021"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2023 00:11:17 -0700
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Xiaoyao Li <xiaoyao.li@Intel.com>
Subject: [PATCH v4 01/21] i386: Fix comment style in topology.h
Date:   Thu, 14 Sep 2023 15:21:39 +0800
Message-Id: <20230914072159.1177582-2-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

For function comments in this file, keep the comment style consistent
with other files in the directory.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Yanan Wang <wangyanan55@huawei.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@Intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v3:
 * Optimized the description in commit message: Change "with other
   places" to "with other files in the directory". (Babu)
---
 include/hw/i386/topology.h | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
index 81573f6cfde0..5a19679f618b 100644
--- a/include/hw/i386/topology.h
+++ b/include/hw/i386/topology.h
@@ -24,7 +24,8 @@
 #ifndef HW_I386_TOPOLOGY_H
 #define HW_I386_TOPOLOGY_H
 
-/* This file implements the APIC-ID-based CPU topology enumeration logic,
+/*
+ * This file implements the APIC-ID-based CPU topology enumeration logic,
  * documented at the following document:
  *   Intel® 64 Architecture Processor Topology Enumeration
  *   http://software.intel.com/en-us/articles/intel-64-architecture-processor-topology-enumeration/
@@ -41,7 +42,8 @@
 
 #include "qemu/bitops.h"
 
-/* APIC IDs can be 32-bit, but beware: APIC IDs > 255 require x2APIC support
+/*
+ * APIC IDs can be 32-bit, but beware: APIC IDs > 255 require x2APIC support
  */
 typedef uint32_t apic_id_t;
 
@@ -58,8 +60,7 @@ typedef struct X86CPUTopoInfo {
     unsigned threads_per_core;
 } X86CPUTopoInfo;
 
-/* Return the bit width needed for 'count' IDs
- */
+/* Return the bit width needed for 'count' IDs */
 static unsigned apicid_bitwidth_for_count(unsigned count)
 {
     g_assert(count >= 1);
@@ -67,15 +68,13 @@ static unsigned apicid_bitwidth_for_count(unsigned count)
     return count ? 32 - clz32(count) : 0;
 }
 
-/* Bit width of the SMT_ID (thread ID) field on the APIC ID
- */
+/* Bit width of the SMT_ID (thread ID) field on the APIC ID */
 static inline unsigned apicid_smt_width(X86CPUTopoInfo *topo_info)
 {
     return apicid_bitwidth_for_count(topo_info->threads_per_core);
 }
 
-/* Bit width of the Core_ID field
- */
+/* Bit width of the Core_ID field */
 static inline unsigned apicid_core_width(X86CPUTopoInfo *topo_info)
 {
     return apicid_bitwidth_for_count(topo_info->cores_per_die);
@@ -87,8 +86,7 @@ static inline unsigned apicid_die_width(X86CPUTopoInfo *topo_info)
     return apicid_bitwidth_for_count(topo_info->dies_per_pkg);
 }
 
-/* Bit offset of the Core_ID field
- */
+/* Bit offset of the Core_ID field */
 static inline unsigned apicid_core_offset(X86CPUTopoInfo *topo_info)
 {
     return apicid_smt_width(topo_info);
@@ -100,14 +98,14 @@ static inline unsigned apicid_die_offset(X86CPUTopoInfo *topo_info)
     return apicid_core_offset(topo_info) + apicid_core_width(topo_info);
 }
 
-/* Bit offset of the Pkg_ID (socket ID) field
- */
+/* Bit offset of the Pkg_ID (socket ID) field */
 static inline unsigned apicid_pkg_offset(X86CPUTopoInfo *topo_info)
 {
     return apicid_die_offset(topo_info) + apicid_die_width(topo_info);
 }
 
-/* Make APIC ID for the CPU based on Pkg_ID, Core_ID, SMT_ID
+/*
+ * Make APIC ID for the CPU based on Pkg_ID, Core_ID, SMT_ID
  *
  * The caller must make sure core_id < nr_cores and smt_id < nr_threads.
  */
@@ -120,7 +118,8 @@ static inline apic_id_t x86_apicid_from_topo_ids(X86CPUTopoInfo *topo_info,
            topo_ids->smt_id;
 }
 
-/* Calculate thread/core/package IDs for a specific topology,
+/*
+ * Calculate thread/core/package IDs for a specific topology,
  * based on (contiguous) CPU index
  */
 static inline void x86_topo_ids_from_idx(X86CPUTopoInfo *topo_info,
@@ -137,7 +136,8 @@ static inline void x86_topo_ids_from_idx(X86CPUTopoInfo *topo_info,
     topo_ids->smt_id = cpu_index % nr_threads;
 }
 
-/* Calculate thread/core/package IDs for a specific topology,
+/*
+ * Calculate thread/core/package IDs for a specific topology,
  * based on APIC ID
  */
 static inline void x86_topo_ids_from_apicid(apic_id_t apicid,
@@ -155,7 +155,8 @@ static inline void x86_topo_ids_from_apicid(apic_id_t apicid,
     topo_ids->pkg_id = apicid >> apicid_pkg_offset(topo_info);
 }
 
-/* Make APIC ID for the CPU 'cpu_index'
+/*
+ * Make APIC ID for the CPU 'cpu_index'
  *
  * 'cpu_index' is a sequential, contiguous ID for the CPU.
  */
-- 
2.34.1

