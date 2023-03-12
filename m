Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0247E6B69D2
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjCLSHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbjCLSFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:05:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325DB521CD;
        Sun, 12 Mar 2023 11:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644080; x=1710180080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jHMqhN9ugEGh0NufyWtBJEiXKjl22/YZnuAcWnYx9WU=;
  b=bFO4DTGlAKvEuL20S8pCVOL4/26nHpF7Qtj728GtzW4gJAm6SUQCnM+F
   8J1UTeeZD/tvWX5D+AN/nBLKRMPlWc/jC2lIgwz3//3vbMo0YJ6PzKGi7
   oVuLGB09HLOdE+jspmxfzHrhc43QHp+lka4hXIeTZqOn+j9J6gVf1z9ZE
   xs3NTdbhkcQeU+PGc2JY+JPUwchjuz3VLlw7hCGz0p5/W+IJuBktLfMT2
   IqSIQMhMGukowx9U8HAThZuWbrCXglunWEyMDc73njU+xmrYtz46DmMgq
   91q19AmT6fKKD4pR4xASo0k3m8+H94tiR8X20xwNv20i6POib9LEB6lfr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316660156"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316660156"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596878"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596878"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:18 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 113/113] [MARKER] the end of (the first phase of) TDX KVM patch series
Date:   Sun, 12 Mar 2023 10:57:17 -0700
Message-Id: <af455bd9233d89034be3007550c0209df72914f1.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the end of (the first phase of) patch series
of TDX KVM support.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/index.rst              |  1 -
 .../virt/kvm/intel-tdx-layer-status.rst       | 33 -------------------
 2 files changed, 34 deletions(-)
 delete mode 100644 Documentation/virt/kvm/intel-tdx-layer-status.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index 40ffc25f3cd1..eafacbff1f4e 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -22,4 +22,3 @@ KVM
 
    intel-tdx
    tdx-tdp-mmu
-   intel-tdx-layer-status.rst
diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
deleted file mode 100644
index 7a16fa284b6f..000000000000
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ /dev/null
@@ -1,33 +0,0 @@
-.. SPDX-License-Identifier: GPL-2.0
-
-===================================
-Intel Trust Dodmain Extensions(TDX)
-===================================
-
-Layer status
-============
-What qemu can do
-----------------
-- TDX VM TYPE is exposed to Qemu.
-- Qemu can create/destroy guest of TDX vm type.
-- Qemu can create/destroy vcpu of TDX vm type.
-- Qemu can populate initial guest memory image.
-- Qemu can finalize guest TD.
-- Qemu can start to run vcpu. But vcpu can not make progress yet.
-
-Patch Layer status
-------------------
-  Patch layer                          Status
-
-* TDX, VMX coexistence:                 Applied
-* TDX architectural definitions:        Applied
-* TD VM creation/destruction:           Applied
-* TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Applied
-* TD finalization:                      Applied
-* TD vcpu enter/exit:                   Applied
-* TD vcpu interrupts/exit/hypercall:    Not yet
-
-* KVM MMU GPA shared bits:              Applied
-* KVM TDP refactoring for TDX:          Applied
-* KVM TDP MMU hooks:                    Applied
-- 
2.25.1

