Return-Path: <kvm+bounces-4681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 439D3816719
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3F3C28460D
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287D979D2;
	Mon, 18 Dec 2023 07:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lo7IFbXX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB2C11195
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883458; x=1734419458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=enMmHXaSJVBmnZBCvZzS3OxPVgZtSXoR6cF1KrOMOZg=;
  b=lo7IFbXXzXehimd/zCPqTlLGSsNJyQ3itloDgAlPBLyi+ffovXPWoKCq
   6n+2cHmggiPtByb7u4YsOo7ElZrilME5Pv30QE+zUAM6ajDbgW75bxYDY
   b+onfVuebVhA3QQPNoqFplvkECd4SL7BPFT3YYoBQEUlzc6JvEo11A6Zg
   jxKOAUkjDz+9v5RhbCtsF+6lcAONfMr8sjhu5jcnmfi/55ZOvrI8Id4Vf
   1GKL6WE6pUH3BMDmgiFKSfAJJvsKxzxgHtQet+hH0Yqx4mGgd7tHsuFgc
   LIgBHxcuvi9UrQpKygCL1Nn1ucjPBfu+udnTVsJqqZD0Wczp20ZIlVVkH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667980"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667980"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824793"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824793"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:54 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 15/18] x86 TDX: bypass unsupported syscall TF for TDX
Date: Mon, 18 Dec 2023 15:22:44 +0800
Message-Id: <20231218072247.2573516-16-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

The syscall TF is unsupported in TDX, therefore skip it directly.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-16-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 x86/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/syscall.c b/x86/syscall.c
index 402d3973..32ab143f 100644
--- a/x86/syscall.c
+++ b/x86/syscall.c
@@ -5,6 +5,7 @@
 #include "msr.h"
 #include "desc.h"
 #include "fwcfg.h"
+#include "tdx.h"
 
 static void test_syscall_lazy_load(void)
 {
@@ -106,7 +107,7 @@ int main(int ac, char **av)
 {
     test_syscall_lazy_load();
 
-    if (!no_test_device || !is_intel())
+    if ((!no_test_device || !is_intel()) && !is_tdx_guest())
         test_syscall_tf();
     else
         report_skip("syscall TF handling");
-- 
2.25.1


