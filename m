Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4244965FD9B
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbjAFJVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjAFJUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:20 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E906B5EB;
        Fri,  6 Jan 2023 01:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996820; x=1704532820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o65+j06rKvTvMzwdKVOrgkkK4xTrmwbR1mLB3PAtwFI=;
  b=I2gXdmcrzirqaFTRfXC4AE9Wk2InjKNO4Zz9mmL83jetU1JDnJ2M3vtf
   Nsgc71wxB53t1wfq2kq0b12zWgDA3MtAXEMghO7o+x5CwKUkmv80JC9d0
   Q/G/ixouurDXenRyEyQ44VGHZ3VvFBi/M+3dfl91hghbKX2aWGm5ehtPx
   3LxgXLXY9ZkM4XlRwYzDTIUI3cUAvGJNOfzc9QWMjasedu2s90oTYklzV
   B47s4DKU9QjBh91vhC9S2XDVzl1T6QXtup75SiOesNksZDQmNPcXOhKxj
   sC3o/qqrN28rlhqZvtYjJ61zx8yriAseCKPDTyEWIPbClxNlSZw1IRJrR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511476"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511476"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139381"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139381"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:13 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 12/32] x86/cpu: add MSR numbers for FRED configuration
Date:   Fri,  6 Jan 2023 00:55:57 -0800
Message-Id: <20230106085617.17248-13-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add MSR numbers for the FRED configuration registers.

Originally-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/msr-index.h       | 12 +++++++++++-
 tools/arch/x86/include/asm/msr-index.h | 12 +++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4a2af82553e4..dea9223ec9ba 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -39,8 +39,18 @@
 #define EFER_LMSLE		(1<<_EFER_LMSLE)
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 
-/* Intel MSRs. Some also available on other CPUs */
+/* FRED MSRs */
+#define MSR_IA32_FRED_RSP0	0x1cc /* Level 0 stack pointer */
+#define MSR_IA32_FRED_RSP1	0x1cd /* Level 1 stack pointer */
+#define MSR_IA32_FRED_RSP2	0x1ce /* Level 2 stack pointer */
+#define MSR_IA32_FRED_RSP3	0x1cf /* Level 3 stack pointer */
+#define MSR_IA32_FRED_STKLVLS	0x1d0 /* Exception stack levels */
+#define MSR_IA32_FRED_SSP1	0x1d1 /* Level 1 shadow stack pointer */
+#define MSR_IA32_FRED_SSP2	0x1d2 /* Level 2 shadow stack pointer */
+#define MSR_IA32_FRED_SSP3	0x1d3 /* Level 3 shadow stack pointer */
+#define MSR_IA32_FRED_CONFIG	0x1d4 /* Entrypoint and interrupt stack level */
 
+/* Intel MSRs. Some also available on other CPUs */
 #define MSR_TEST_CTRL				0x00000033
 #define MSR_TEST_CTRL_SPLIT_LOCK_DETECT_BIT	29
 #define MSR_TEST_CTRL_SPLIT_LOCK_DETECT		BIT(MSR_TEST_CTRL_SPLIT_LOCK_DETECT_BIT)
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index f17ade084720..5c9d9040dd04 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -39,8 +39,18 @@
 #define EFER_LMSLE		(1<<_EFER_LMSLE)
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 
-/* Intel MSRs. Some also available on other CPUs */
+/* FRED MSRs */
+#define MSR_IA32_FRED_RSP0	0x1cc /* Level 0 stack pointer */
+#define MSR_IA32_FRED_RSP1	0x1cd /* Level 1 stack pointer */
+#define MSR_IA32_FRED_RSP2	0x1ce /* Level 2 stack pointer */
+#define MSR_IA32_FRED_RSP3	0x1cf /* Level 3 stack pointer */
+#define MSR_IA32_FRED_STKLVLS	0x1d0 /* Exception stack levels */
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

