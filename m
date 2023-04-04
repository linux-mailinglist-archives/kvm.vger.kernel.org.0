Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EA06D5E3A
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbjDDKyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbjDDKxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:53:50 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B524237;
        Tue,  4 Apr 2023 03:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680605594; x=1712141594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9ZDzco+F9bEe6GLOCDycLaH8JYPs/ssjd/Vxju2hLBE=;
  b=Oj+6CnneUeAPLf1Z9tCAQuNyyHvSlkTDwQESKSd0a2/DKtLNLQdoBVCD
   BSF/A6TVfvFr/0yzn2QN835fUGvDszzRJHJfV309MAntP0gOQf6XXAWUr
   ZrEbai6Pa8LyN8yIiVpi5O4hnqGrQBfZWdMhQqpYT8sOJH599TZyCIyVr
   bslmrCXVGN7qg8YSMH4uP/DOFb6mKctaDi0ckCzSjqJXkOuLg/ZhX5SPo
   S658QIpSP+JyJBfguiI70BZ0raEjhAGpNaT/o8ktAHjxh0+U12SK1ZVXD
   +mziK21JnHwNncSYfrbKOZH2MaU2S0Y/yTTTv0bcOlDCH6Ma0xEjdbKIf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="330734043"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="330734043"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:53:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="775597814"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="775597814"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Apr 2023 03:53:02 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v7 12/33] x86/cpu: add MSR numbers for FRED configuration
Date:   Tue,  4 Apr 2023 03:26:55 -0700
Message-Id: <20230404102716.1795-13-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404102716.1795-1-xin3.li@intel.com>
References: <20230404102716.1795-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add MSR numbers for the FRED configuration registers.

Originally-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/msr-index.h       | 13 ++++++++++++-
 tools/arch/x86/include/asm/msr-index.h | 13 ++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ad35355ee43e..87db728f8bbc 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -36,8 +36,19 @@
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 #define EFER_AUTOIBRS		(1<<_EFER_AUTOIBRS)
 
-/* Intel MSRs. Some also available on other CPUs */
+/* FRED MSRs */
+#define MSR_IA32_FRED_RSP0	0x1cc /* Level 0 stack pointer */
+#define MSR_IA32_FRED_RSP1	0x1cd /* Level 1 stack pointer */
+#define MSR_IA32_FRED_RSP2	0x1ce /* Level 2 stack pointer */
+#define MSR_IA32_FRED_RSP3	0x1cf /* Level 3 stack pointer */
+#define MSR_IA32_FRED_STKLVLS	0x1d0 /* Exception stack levels */
+#define MSR_IA32_FRED_SSP0	MSR_IA32_PL0_SSP /* Level 0 shadow stack pointer */
+#define MSR_IA32_FRED_SSP1	0x1d1 /* Level 1 shadow stack pointer */
+#define MSR_IA32_FRED_SSP2	0x1d2 /* Level 2 shadow stack pointer */
+#define MSR_IA32_FRED_SSP3	0x1d3 /* Level 3 shadow stack pointer */
+#define MSR_IA32_FRED_CONFIG	0x1d4 /* Entrypoint and interrupt stack level */
 
+/* Intel MSRs. Some also available on other CPUs */
 #define MSR_TEST_CTRL				0x00000033
 #define MSR_TEST_CTRL_SPLIT_LOCK_DETECT_BIT	29
 #define MSR_TEST_CTRL_SPLIT_LOCK_DETECT		BIT(MSR_TEST_CTRL_SPLIT_LOCK_DETECT_BIT)
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index ad35355ee43e..87db728f8bbc 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -36,8 +36,19 @@
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 #define EFER_AUTOIBRS		(1<<_EFER_AUTOIBRS)
 
-/* Intel MSRs. Some also available on other CPUs */
+/* FRED MSRs */
+#define MSR_IA32_FRED_RSP0	0x1cc /* Level 0 stack pointer */
+#define MSR_IA32_FRED_RSP1	0x1cd /* Level 1 stack pointer */
+#define MSR_IA32_FRED_RSP2	0x1ce /* Level 2 stack pointer */
+#define MSR_IA32_FRED_RSP3	0x1cf /* Level 3 stack pointer */
+#define MSR_IA32_FRED_STKLVLS	0x1d0 /* Exception stack levels */
+#define MSR_IA32_FRED_SSP0	MSR_IA32_PL0_SSP /* Level 0 shadow stack pointer */
+#define MSR_IA32_FRED_SSP1	0x1d1 /* Level 1 shadow stack pointer */
+#define MSR_IA32_FRED_SSP2	0x1d2 /* Level 2 shadow stack pointer */
+#define MSR_IA32_FRED_SSP3	0x1d3 /* Level 3 shadow stack pointer */
+#define MSR_IA32_FRED_CONFIG	0x1d4 /* Entrypoint and interrupt stack level */
 
+/* Intel MSRs. Some also available on other CPUs */
 #define MSR_TEST_CTRL				0x00000033
 #define MSR_TEST_CTRL_SPLIT_LOCK_DETECT_BIT	29
 #define MSR_TEST_CTRL_SPLIT_LOCK_DETECT		BIT(MSR_TEST_CTRL_SPLIT_LOCK_DETECT_BIT)
-- 
2.34.1

