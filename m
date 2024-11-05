Return-Path: <kvm+bounces-30659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD3B19BC59D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ACD91C20BFC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2811F5857;
	Tue,  5 Nov 2024 06:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W5Lupe+5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672601F16B
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788694; cv=none; b=e08ZnbWfl25IqRX7qOzzT5m+hsf/xvm7V2VgP3qkE/ZwQWMWTOKrFNZH2FLI/ECXsoWzRMbv0oQpbxnRBtq8NQe4b735c9uCghHVs6KUe1D4607Y1scYp9o8K5MMb9jNB9w3Ai5QT/yyj9nR8Xlxg0lyBCMLhlcXIECL21U5Amk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788694; c=relaxed/simple;
	bh=rvObCK3RI5s5qGyDuVPMqNnDGspWafj/j5UMlEUdJUA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LXJwU3bHQUbBHLoa7SusnryTXdre2/LOe857swM3H5rGa7vjv2mvA5+CztNoDbvI30urHchxoCL2gj3Q75CcEgOgHRdOff2isoFH2xAgabTFYU5W9LWkZ9dvAHNWfuvmbOxriKTbn7onxVeuwcZCJDxMKwl3tOTJrrO+V2zhiLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W5Lupe+5; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788692; x=1762324692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rvObCK3RI5s5qGyDuVPMqNnDGspWafj/j5UMlEUdJUA=;
  b=W5Lupe+57xANXsdG93Gq8HFS6IfT3xLqoMw0a1tdK+x47/QGoK6jt0cL
   r9AG8G2LTDVZwI/J4XfXmIWfESFubh1zup7DZ4OYvTZ9WkLySJ+uCFR/C
   3KfH7T8hHT8+qAVgxTrCNLjKudONhT2NEjC5AuubIJHxWW9i025PTnPc4
   n7HGx19dpvNnUfdlpZXKShIyX764Azkpceh3CorRIm/qgerzPmLKjbvW7
   hnDGzKjIpIdiypNw3rI3WGADAB1kRf0tupd9mWnU9VwrVga1iYXxDhJ9C
   oxHaETdD43aQl+VuP+wRG/H0F+DSfxPFmdszZitWxcebt7XkS3LxVuIdo
   A==;
X-CSE-ConnectionGUID: 1W5tzAhFTeKIm1RenTtduw==
X-CSE-MsgGUID: OcDaAO9VTiOxIPVagvxtCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689578"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689578"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:38:12 -0800
X-CSE-ConnectionGUID: O+gOavi8QUaJkXjcuFvZWw==
X-CSE-MsgGUID: f4LDZ/alR22cvlK2YFWB8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989038"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:06 -0800
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
Subject: [PATCH v6 25/60] i386/tdx: Add TDVF memory via KVM_TDX_INIT_MEM_REGION
Date: Tue,  5 Nov 2024 01:23:33 -0500
Message-Id: <20241105062408.3533704-26-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDVF firmware (CODE and VARS) needs to be copied to TD's private
memory via KVM_TDX_INIT_MEM_REGION, as well as TD HOB and TEMP memory.

If the TDVF section has TDVF_SECTION_ATTRIBUTES_MR_EXTEND set in the
flag, calling KVM_TDX_EXTEND_MEMORY to extend the measurement.

After populating the TDVF memory, the original image located in shared
ramblock can be discarded.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes in v6:
 - switch back to use KVM_TDX_INIT_MEM_REGION according to KVM's change;
---
 target/i386/kvm/tdx.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 6720c785a4ad..0a6ac62de7ff 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -18,6 +18,7 @@
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
 #include "sysemu/sysemu.h"
+#include "exec/ramblock.h"
 
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
@@ -253,6 +254,8 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
+    RAMBlock *ram_block;
+    int r;
 
     tdx_init_ram_entries();
 
@@ -278,6 +281,42 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
           sizeof(TdxRamEntry), &tdx_ram_entry_compare);
 
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
+
+    for_each_tdx_fw_entry(tdvf, entry) {
+        struct kvm_tdx_init_mem_region region;
+        uint32_t flags;
+
+        region = (struct kvm_tdx_init_mem_region) {
+            .source_addr = (uint64_t)entry->mem_ptr,
+            .gpa = entry->address,
+            .nr_pages = entry->size >> 12,
+        };
+
+        flags = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
+                KVM_TDX_MEASURE_MEMORY_REGION : 0;
+
+        do {
+            r = tdx_vcpu_ioctl(first_cpu, KVM_TDX_INIT_MEM_REGION, flags,
+                               &region);
+        } while (r == -EAGAIN || r == -EINTR);
+        if (r < 0) {
+            error_report("KVM_TDX_INIT_MEM_REGION failed %s", strerror(-r));
+            exit(1);
+        }
+
+        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
+            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
+            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
+            entry->mem_ptr = NULL;
+        }
+    }
+
+    /*
+     * TDVF image has been copied into private region above via
+     * KVM_MEMORY_MAPPING. It becomes useless.
+     */
+    ram_block = tdx_guest->tdvf_mr->ram_block;
+    ram_block_discard_range(ram_block, 0, ram_block->max_length);
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.34.1


