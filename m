Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FDA6AD55B
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjCGDGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjCGDFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:05:31 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B320F79B18;
        Mon,  6 Mar 2023 19:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158327; x=1709694327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dhlfn7qvLhWN1c0RzKGaosBPQEjw24rUF7QUjxaHu4I=;
  b=edIJhD0LTcRMGO0YippofLbxAZsAkSKyvwtRTV9vI8+q4QfQv+BQnISF
   AfWZ5+VKss0v9A5ptP6r1qoMHceLRCRBb5WKTOsfZ5O1RhM9u0nSNEzsT
   B9h9d6sea24xRXufO5u2kpDVcNbri0ZjTtVjVetsUFJROfVjoGLwdjuEK
   RXVQ2AWO0oSTZNe9IY3r44btbyCey6c2jE+1ohnNiMoGGNn2nUtTeADPV
   vP1sCtV/rh04vzkhLW0ktYQsY2lMB5Pvhq5tqvP8aey6PgOXalepDSJ07
   CeLjtNdg1rjcjC6lGX+oavMFIvIjtlMwME9+ofylfaaEw7df46cX8B5We
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072419"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072419"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409801"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409801"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:14 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 12/34] x86/cpu: add MSR numbers for FRED configuration
Date:   Mon,  6 Mar 2023 18:39:24 -0800
Message-Id: <20230307023946.14516-13-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307023946.14516-1-xin3.li@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 37ff47552bcb..0ade66db3627 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -34,8 +34,19 @@
 #define EFER_LMSLE		(1<<_EFER_LMSLE)
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 
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

