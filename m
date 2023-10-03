Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EE97B615D
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 08:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbjJCGzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 02:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239204AbjJCGyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 02:54:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3BDF2;
        Mon,  2 Oct 2023 23:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696316085; x=1727852085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nTdktbAXAsluEm2oV29DBlIQh6+yrXokZRkKJ/w8Zmc=;
  b=Us9f8Tj5uCZpSnV/cmOX5Gg5cPnP1yu6wSiJdo5ENspqZ0ORmzC9eosq
   7Ffn7PJRi5OXCaHosnowkElRyDLuKJcWM9DIDb3YKN3tT6mQYN5jrMpqf
   0UWL7yZGaw8g8fEifHUEpxAdwSteSnyjtKM3d747/rKuMZHv7gQaWYF3X
   dxLeVzi+zW75TiWcwfG5gOIO2BuBUT4pK8oOh3ewZfBLjTUL3d5sfLDN4
   +saxtCCx37uMTwrDHtBOMpRoysQ80WQ91miiQAnGfsLNkbt7mrglgnpwx
   NG29sErzTiG41cXC/xRS3sCmlFj3aAgyfWCglDGNMXYfDE8HHqYb+MUj6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="367858063"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="367858063"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 23:54:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="1081900937"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="1081900937"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga005.fm.intel.com with ESMTP; 02 Oct 2023 23:54:41 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v12 14/37] x86/cpu: Add MSR numbers for FRED configuration
Date:   Mon,  2 Oct 2023 23:24:35 -0700
Message-Id: <20231003062458.23552-15-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003062458.23552-1-xin3.li@intel.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
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

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add MSR numbers for the FRED configuration registers per FRED spec 5.0.

Originally-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/msr-index.h       | 13 ++++++++++++-
 tools/arch/x86/include/asm/msr-index.h | 13 ++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 6a6b0f763f67..200d7715696d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -36,8 +36,19 @@
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 #define EFER_AUTOIBRS		(1<<_EFER_AUTOIBRS)
 
-/* Intel MSRs. Some also available on other CPUs */
+/* FRED MSRs */
+#define MSR_IA32_FRED_RSP0	0x1cc			/* Level 0 stack pointer */
+#define MSR_IA32_FRED_RSP1	0x1cd			/* Level 1 stack pointer */
+#define MSR_IA32_FRED_RSP2	0x1ce			/* Level 2 stack pointer */
+#define MSR_IA32_FRED_RSP3	0x1cf			/* Level 3 stack pointer */
+#define MSR_IA32_FRED_STKLVLS	0x1d0			/* Exception stack levels */
+#define MSR_IA32_FRED_SSP0	MSR_IA32_PL0_SSP	/* Level 0 shadow stack pointer */
+#define MSR_IA32_FRED_SSP1	0x1d1			/* Level 1 shadow stack pointer */
+#define MSR_IA32_FRED_SSP2	0x1d2			/* Level 2 shadow stack pointer */
+#define MSR_IA32_FRED_SSP3	0x1d3			/* Level 3 shadow stack pointer */
+#define MSR_IA32_FRED_CONFIG	0x1d4			/* Entrypoint and interrupt stack level */
 
+/* Intel MSRs. Some also available on other CPUs */
 #define MSR_TEST_CTRL				0x00000033
 #define MSR_TEST_CTRL_SPLIT_LOCK_DETECT_BIT	29
 #define MSR_TEST_CTRL_SPLIT_LOCK_DETECT		BIT(MSR_TEST_CTRL_SPLIT_LOCK_DETECT_BIT)
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index 1d111350197f..972d15404420 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -36,8 +36,19 @@
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 #define EFER_AUTOIBRS		(1<<_EFER_AUTOIBRS)
 
-/* Intel MSRs. Some also available on other CPUs */
+/* FRED MSRs */
+#define MSR_IA32_FRED_RSP0	0x1cc			/* Level 0 stack pointer */
+#define MSR_IA32_FRED_RSP1	0x1cd			/* Level 1 stack pointer */
+#define MSR_IA32_FRED_RSP2	0x1ce			/* Level 2 stack pointer */
+#define MSR_IA32_FRED_RSP3	0x1cf			/* Level 3 stack pointer */
+#define MSR_IA32_FRED_STKLVLS	0x1d0			/* Exception stack levels */
+#define MSR_IA32_FRED_SSP0	MSR_IA32_PL0_SSP	/* Level 0 shadow stack pointer */
+#define MSR_IA32_FRED_SSP1	0x1d1			/* Level 1 shadow stack pointer */
+#define MSR_IA32_FRED_SSP2	0x1d2			/* Level 2 shadow stack pointer */
+#define MSR_IA32_FRED_SSP3	0x1d3			/* Level 3 shadow stack pointer */
+#define MSR_IA32_FRED_CONFIG	0x1d4			/* Entrypoint and interrupt stack level */
 
+/* Intel MSRs. Some also available on other CPUs */
 #define MSR_TEST_CTRL				0x00000033
 #define MSR_TEST_CTRL_SPLIT_LOCK_DETECT_BIT	29
 #define MSR_TEST_CTRL_SPLIT_LOCK_DETECT		BIT(MSR_TEST_CTRL_SPLIT_LOCK_DETECT_BIT)
-- 
2.34.1

