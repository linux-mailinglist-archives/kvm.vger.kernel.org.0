Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A5B56D699
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 09:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiGKHVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 03:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiGKHVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 03:21:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6317FDF48
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 00:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657524062; x=1689060062;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ICJ3l2rWAJ7LKG0yWY8oQ7iLJY5BaZhfz2p9SEQH3Gs=;
  b=iySnBxC9muSnL15kos4XDZ5rCL5IBf64ZAfWf7Te13fViatsIh0DUgrM
   LpQTU4RI4iuXKMlUAmCHUYSDbeDGBCdhFkqt/WwIO7RzHUPugJyPQvEcM
   Pfq8VorxGT14phO/sE2ZOk8d0llVX/5UfqZF34FaPJiY2MN0FOnjRcod7
   R/LnAJ8pXy9FDmSekBsTqTskik3qw2Pb5Uwhsdyqltgs3+sa2LnMbqsQI
   7USuJ7gpXvtWlP9fTUlZ7rVJn3WHYt7UkWkBLBH3SNQ8s8tsXf7Ug19L2
   KF0/jaiz+wOI/btjVd0jEaqpx3qc3SK7cXyXAWOcgOs6q/QYl78jabtQM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="267636827"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="267636827"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:20:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="627392546"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:20:57 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH 0/4] Fixup and cleanup to pmu test applications
Date:   Mon, 11 Jul 2022 00:18:37 -0400
Message-Id: <20220711041841.126648-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I Found a few pmu test failures when ran againt KVM/queue branch with pmu
disabled(enable_pmu=0), and posted a few fixup patches for the issues.
Maintainers reviewed and commented actively, which makes the fixup patches
evolved into this series. Besides two fixup patches, there're another two
cleanup patches included.

patch 1: Cleanup patch. Use report_skip() instead of printf() to make
output logs clean.
patch 2: Cleanup patch. Add helpers to check platform supported pmu
capabilities.
patch 3~4: Fixup patches. Fix test failures seen when pmu_enable=0.


Yang Weijiang (4):
  x86: Use report_skip to print messages when tests are skipped
  x86: Use helpers to fetch supported perf capabilities
  x86: Skip perf related tests when platform cannot support
  x86: Check platform pmu capabilities before run lbr tests

 lib/x86/processor.h |  70 ++++++++++++++++++++++++++++
 x86/pmu.c           |  28 ++++++------
 x86/pmu_lbr.c       |  33 ++++++--------
 x86/vmx_tests.c     | 109 +++++++++++++++++++++++---------------------
 4 files changed, 153 insertions(+), 87 deletions(-)


base-commit: ca85dda2671e88d34acfbca6de48a9ab32b1810d
-- 
2.31.1

