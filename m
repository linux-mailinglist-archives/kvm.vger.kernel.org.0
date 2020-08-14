Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1593624469B
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 10:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgHNIuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 04:50:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:32760 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgHNIum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 04:50:42 -0400
IronPort-SDR: ZrmwDM0x1YUoyA+oS8g3O98vmf61/4WbDf4LAmISkIambYIycgHYFWydAH8RdB1wD5SLjCk+VB
 J2jnqB0+nNmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9712"; a="142219152"
X-IronPort-AV: E=Sophos;i="5.76,311,1592895600"; 
   d="scan'208";a="142219152"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 01:50:41 -0700
IronPort-SDR: QHqsEadkij4rUx+vVLKSKNbuW+hYqcDrheml63a9BCMd2RBbmBzM2yS26FtgkaDLsE8U7CszFe
 TxPJc6ijUbwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,311,1592895600"; 
   d="scan'208";a="277073969"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 14 Aug 2020 01:50:40 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests] pmu: make llc misses test to pass on more cpu types
Date:   Fri, 14 Aug 2020 16:48:10 +0800
Message-Id: <20200814084810.20960-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expand boundary of llc misses test since it was observed that
on some Atom Tremont cpus results do not fit.

1 >= 1002014 <= 1000000
FAIL: llc misses-0
1 >= 1002014 <= 1000000
FAIL: llc misses-1
1 >= 1002003 <= 1000000
FAIL: llc misses-2
1 >= 1002014 <= 1000000
FAIL: llc misses-3

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 5a3d55b..f8cf48b 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -82,7 +82,7 @@ struct pmu_event {
 	{"instructions", 0x00c0, 10*N, 10.2*N},
 	{"ref cycles", 0x013c, 0.1*N, 30*N},
 	{"llc refference", 0x4f2e, 1, 2*N},
-	{"llc misses", 0x412e, 1, 1*N},
+	{"llc misses", 0x412e, 1, 1.1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
 	{"branch misses", 0x00c5, 0, 0.1*N},
 }, fixed_events[] = {
-- 
2.21.3

