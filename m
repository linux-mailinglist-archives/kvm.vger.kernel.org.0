Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27E46B6459
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjCLJzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjCLJyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1036237F16
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614891; x=1710150891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y7eZSVWfaVJ80/+HifZ4lqREIqeP96Wq+cH04Crn9rw=;
  b=cJVqZ8SlgIK/IuprMqut2sSkoJrl9Zqv1lfEl8NRoleDTFrC2uj5ZhlT
   PLnbsu0p+R2wGXCytcTZ2lL1V7WGmVkeKNKUULoMB4NwS702Onw+p2BCZ
   bUQA/bIB9lDkCoJWPAtXfMAaWS1WhmEaCngmFfjWnnlnCB+sQlvw4HOsI
   y4FbtBQNDdQqx6JWUPOdRTX7jPSPpSIu8iL0rgcCodtTrhw/BqwL0DmLP
   u5aNP9OSzR3rzp7QwiXbv2WH0PVg8RUSXzLx90cqmiV0dBymQJnNlfRmb
   A1x4uU/z648AA+6Ax2uLxvetLk8XFquF9sCyGKJy7hkpui+KbO1pa9Ax+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622930"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622930"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852409016"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852409016"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:32 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-2 11/17] pkvm: x86: Define empty debug functions for hypervisor
Date:   Mon, 13 Mar 2023 02:01:06 +0800
Message-Id: <20230312180112.1778254-12-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180112.1778254-1-jason.cj.chen@intel.com>
References: <20230312180112.1778254-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use pkvm_dbg/pkvm_info/pkvm_err as debug functions for pKVM runtime.

Define all these debug functions as empty functions now, it's also the
configuration of final release, as no additional debug console support
in pKVM now and such runtime debug functions shall avoid to access
host kernel debug APIs (e.g. printk) for isolation purpose.

Future will enable a debug mode for pKVM by taking use of linux
printk with some extra addon to access host kernel code - it's a
tmp quick debug method as it does not follow above rules for isolation.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/debug.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/debug.h b/arch/x86/kvm/vmx/pkvm/hyp/debug.h
new file mode 100644
index 000000000000..97f633ca0bac
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/debug.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#ifndef _PKVM_DEBUG_H_
+#define _PKVM_DEBUG_H_
+
+#define pkvm_dbg(x...)
+#define pkvm_info(x...)
+#define pkvm_err(x...)
+
+#endif
-- 
2.25.1

