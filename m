Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6487CAFA1
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbjJPQgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbjJPQfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:35:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F9F44B0;
        Mon, 16 Oct 2023 09:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473199; x=1729009199;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gZq/xU5HPMr+7bL2m3UNHQGfAGkvgf+PBtN9vzhZEYs=;
  b=KWmdNsa2wsp4bphLYkP4G4fMLRLeWwiFYJEkDbAt9AX0q4bny7UB5nIX
   WCMP0C1of2bui3MZiMBHWGvyMEgTTuflm6ma1XcVHN39vLPZbG20BbPLA
   f6QLcsOnCd4loVsGawvrcVeP8vQGkT/kbcigPzxO4PFAGIRG+itkppgj+
   6sjPR9LlBCoth8fiQ+BqoDTSZHFLD3oHOpnIwmZF4wKKd+0QSAk/AJKaL
   vT4ExxDqh0nDcH3eQnTG+a6bw4Vz8Cin6Rc2iy3vwfvqQL35XKyVLhTjW
   sQ9W2qy4+QkUTSvtP5uoow+xuEOswBKc2GyfsAlU2L/wPOJ91X5O8t+SH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825899"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825899"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087125984"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087125984"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:24 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 008/116] [MARKER] The start of TDX KVM patch series: TDX architectural definitions
Date:   Mon, 16 Oct 2023 09:13:20 -0700
Message-Id: <c7ed370e721ec44750cef13e8bddf7418c30e3d1.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
 Documentation/virt/kvm/index.rst              |  2 ++
 .../virt/kvm/intel-tdx-layer-status.rst       | 29 +++++++++++++++++++
 2 files changed, 31 insertions(+)
 create mode 100644 Documentation/virt/kvm/intel-tdx-layer-status.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ad13ec55ddfe..ccff56dca2b1 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -19,3 +19,5 @@ KVM
    vcpu-requests
    halt-polling
    review-checklist
+
+   intel-tdx-layer-status
diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
new file mode 100644
index 000000000000..f11ea701dc19
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
+
+* TDX, VMX coexistence:                 Applied
+* TDX architectural definitions:        Applying
+* TD VM creation/destruction:           Not yet
+* TD vcpu creation/destruction:         Not yet
+* TDX EPT violation:                    Not yet
+* TD finalization:                      Not yet
+* TD vcpu enter/exit:                   Not yet
+* TD vcpu interrupts/exit/hypercall:    Not yet
+
+* KVM MMU GPA shared bits:              Not yet
+* KVM TDP refactoring for TDX:          Not yet
+* KVM TDP MMU hooks:                    Not yet
-- 
2.25.1

