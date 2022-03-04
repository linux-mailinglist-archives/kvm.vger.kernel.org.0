Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CC14CDE23
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiCDUG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiCDUGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:06:04 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7B373056;
        Fri,  4 Mar 2022 12:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424063; x=1677960063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wgNcf013hisCgpPJ0l/y+lMK2HaU5nXC6kAb2xW4hPM=;
  b=b1BB5upYwz0ZcK+O3FC1jz2PJeioiFSa5NN7wgGnMFkWpoV4LHecIY+r
   NhTC+1P6dObUuX457SCkTKO+UsheP6XCBMEZ9k65aGxPiFb8soLM9ZQH+
   P9+DxM0TzGnb2HCcZ38sWYhZn7YuZ9+LGZrJecAf0ownjn7C5Hly2i71W
   te2FbIq3cuyglGlQylu6wVAhDiEA920HJmQfnKXNhXrJxm9cyn2Ba+a66
   lZY1i8CbT+cDjVNSkLnBXv3LFpjaIKD+JpPGFZ/0gVWTci8bac6Vq5V6s
   Bv0Y3Brbe/BnZwueIaSgimymChnavZUocS/OyFr7YukJnnO7xHE9BXk3i
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983327"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983327"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:08 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344135"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:07 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 011/104] [MARKER] The start of TDX KVM patch series: TDX architectural definitions
Date:   Fri,  4 Mar 2022 11:48:27 -0800
Message-Id: <2fe33c8a0dae28acf001deffed51adcb5a74c96f.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TDX architectural
definitions.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../virt/kvm/intel-tdx-layer-status.rst       | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/virt/kvm/intel-tdx-layer-status.rst

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
new file mode 100644
index 000000000000..d4db90cb098b
--- /dev/null
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -0,0 +1,29 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Intel Trust Dodmain Extensions(TDX)
+===================================
+
+Layer status
+============
+What qemu can do
+----------------
+- TDX VM TYPE is exposed to Qemu.
+- Qemu can try to create VM of TDX VM type and then fails.
+
+Patch Layer status
+------------------
+  Patch layer                          Status
+* TDX, VMX coexistence:                 Applied
+* TDX architectural definitions:        Applying
+* TD VM creation/destruction:           Not yet
+* TD vcpu creation/destruction:         Not yet
+* TDX EPT violation:                    Not yet
+* TD finalization:                      Not yet
+* TD vcpu enter/exit:                   Not yet
+* TD vcpu interrupts/exit/hypercall:    Not yet
+
+* KVM MMU GPA stolen bits:              Not yet
+* KVM TDP refactoring for TDX:          Not yet
+* KVM TDP MMU hooks:                    Not yet
+* KVM TDP MMU MapGPA:                   Not yet
-- 
2.25.1

