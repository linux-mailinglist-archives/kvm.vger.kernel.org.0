Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770F63BF31C
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhGHA7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:19088 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhGHA6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209462012"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209462012"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770092"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 32/44] tdx: add kvm_tdx_enabled() accessor for later use
Date:   Wed,  7 Jul 2021 17:55:02 -0700
Message-Id: <26d88e7618038c1fed501352a04144745abd12ae.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/sysemu/tdx.h  | 1 +
 target/i386/kvm/kvm.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/sysemu/tdx.h b/include/sysemu/tdx.h
index 70eb01348f..f3eced10f9 100644
--- a/include/sysemu/tdx.h
+++ b/include/sysemu/tdx.h
@@ -6,6 +6,7 @@
 #include "hw/i386/pc.h"
 
 bool kvm_has_tdx(KVMState *s);
+bool kvm_tdx_enabled(void);
 int tdx_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory);
 #endif
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index af6b5f350e..76c3ea9fac 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -152,6 +152,11 @@ int kvm_set_vm_type(MachineState *ms, int kvm_type)
     return -ENOTSUP;
 }
 
+bool kvm_tdx_enabled(void)
+{
+    return vm_type == KVM_X86_TDX_VM;
+}
+
 int kvm_has_pit_state2(void)
 {
     return has_pit_state2;
-- 
2.25.1

