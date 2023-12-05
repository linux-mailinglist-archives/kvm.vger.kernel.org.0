Return-Path: <kvm+bounces-3529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F531805252
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:22:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A6891F214B8
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD48C5D912;
	Tue,  5 Dec 2023 11:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="myRA8Ja+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9AE181;
	Tue,  5 Dec 2023 03:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701775286; x=1733311286;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1fzGqu48NP+nQ4Wei8H/FiUdtI6VnB83SN+47a+BzSw=;
  b=myRA8Ja+dUdub1a7KyjB7/p2MVH7fkCVHnvJVBUUwrWUUd539Q+xUF8W
   pIqj4d2dUztVL9o/aKLqd0p8+/2LrSVB3oSDDIuXAWDqPq7qc/dmjVZ9J
   Xpd9v2adglCfivUGblJNnIghjlMug/uJyFBEHS3vvIzsdNLlZq/hNFqTg
   ke3DGztD3ax3aOexd4KZprYE4yOMVU/t3QeEb+JuGhRsgA82Xdf1q5WYt
   BHWtlezpZOykIkBADbm/O7dgPS8Bg44+TNw2SSmRUfSVYkDpOthtG0nsB
   2qhY8FP4h2eCMGyGoOvvVmYOsLfaVDI4/XNC3//qGPtCv4WtzynR+kVqb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="942449"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="942449"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 03:21:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="1018192939"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="1018192939"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2023 03:21:19 -0800
From: Xin Li <xin3.li@intel.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	peterz@infradead.org,
	jgross@suse.com,
	ravi.v.shankar@intel.com,
	mhiramat@kernel.org,
	andrew.cooper3@citrix.com,
	jiangshanlai@gmail.com,
	nik.borisov@suse.com,
	shan.kang@intel.com
Subject: [PATCH v13 12/35] x86/cpu: Add MSR numbers for FRED configuration
Date: Tue,  5 Dec 2023 02:50:01 -0800
Message-ID: <20231205105030.8698-13-xin3.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205105030.8698-1-xin3.li@intel.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 737a52b89e64..d1d6b3c3e6bd 100644
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
index 1d51e1850ed0..74f2c63ce717 100644
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
2.43.0


