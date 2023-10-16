Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9D87CAF3A
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjJPQbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbjJPQaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:30:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0900676B0;
        Mon, 16 Oct 2023 09:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473375; x=1729009375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kTm2N9RfSmKUFkaBFlwPDYytjDkSW5CSsRnqKsK/nWI=;
  b=QR4LsI2g/txju0eboUOJWVsuuMj4DYRjrah+DIZc8TKMd85IjPHhJgsm
   L9a17xGqX0Ksb+/lVJk+wgtkE805uH5hyYVd83wGXuBuekfjFgZEU9JAL
   Uxl8tAsQRi0XbLzhmQ7v6tlRBFCvYIIisgjmvLwyWyz2wpy6pDUqTvpPm
   iBADsdzY2aqXBrIv9ZzoR6In/i0REwXzjp2TDus8scbsmUIXm8HO0Eb6B
   bAT9goiJUBP5vCxYdx/bA9UElXQYWQ0aWK8vh5kni4HGhx5ZMnfq6Td7l
   UYIW0QUIYyRVxn2zrFRpJR7MwhYecsf5n6NJPFyYKrH6X9rPzatabDu++
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922184"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922184"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1003006502"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1003006502"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:14 -0700
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
Subject: [PATCH v16 116/116] [MARKER] the end of (the first phase of) TDX KVM patch series
Date:   Mon, 16 Oct 2023 09:15:08 -0700
Message-Id: <b2978fc9e738813371b512f1bcdf1b575959c9ba.1697471314.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the end of (the first phase of) patch series
of TDX KVM support.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/index.rst              |  1 -
 .../virt/kvm/intel-tdx-layer-status.rst       | 33 -------------------
 2 files changed, 34 deletions(-)
 delete mode 100644 Documentation/virt/kvm/intel-tdx-layer-status.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ccff56dca2b1..5e78a8fc2fbd 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -20,4 +20,3 @@ KVM
    halt-polling
    review-checklist
 
-   intel-tdx-layer-status
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

