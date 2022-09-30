Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30AC5F0926
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiI3Kch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbiI3K1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:27:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035F758B69;
        Fri, 30 Sep 2022 03:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533211; x=1696069211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sOBwFi6TijFmWxRR2u7LJCs6ZAO9aD248QKXtMkkXSw=;
  b=e1DBSzh2YbCM1KOgqHWww2U1C+WX19MvVBNJa523OFH6dWy+Ir0uaums
   oU0lsP/9HTmn6iL5Ai4ckcMlnGvxI5U0hE4zfA8xEKAs+Huqiai4gs7qq
   QqHEu7Vi8Q6LteBE+zpzh673hFD0hfJjGNpIp5JSJoo9ouoeV6g5t/amH
   nM+NIYFFNWAg5FC6wrSlYXAJAdAMw/ggowwqIsnO4x18MFVYKZYiE7o1d
   kPLV2v7JAlXLXwp+3O7BK2NMJ8uN6D0MMfoXLpf9AXPNjLmsr3lB1d035
   vpHCER+xqWJKUd1cqZE4YcqKOjRvkxBcIo/OiY6UJxWBHMeGUSAe1yRDE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328540189"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="328540189"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:09 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807855"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807855"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:09 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 105/105] [MARKER] the end of (the first phase of) TDX KVM patch series
Date:   Fri, 30 Sep 2022 03:18:39 -0700
Message-Id: <981f4f50663e0e86f6cfebef0c3ea0fe662f9be3.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 .../virt/kvm/intel-tdx-layer-status.rst       | 33 -------------------
 1 file changed, 33 deletions(-)
 delete mode 100644 Documentation/virt/kvm/intel-tdx-layer-status.rst

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
deleted file mode 100644
index 1cec14213f69..000000000000
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
-* KVM TDP MMU MapGPA:                   Applied
-- 
2.25.1

