Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CBF707C89
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 11:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjERJN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 05:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjERJN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 05:13:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3F92119
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 02:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684401227; x=1715937227;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=01jGKo92XpUcST3U5voHLk83zefoHPKE0hNVgwqQhcw=;
  b=SDVrkaYhvb5YQilQzlgO1UjtWpixPNkrccVIcH6JxWEFvzrOWrcm23Q1
   H2neo6HO4XPheJD0kYDhHMxysn1g/Uj0kROTbDQj7jyJMKoATP1vCYL06
   9JW99n3Hu6jcpZMSEFYmbQ1U/4LJIrRSeeb+JGR37v5P8DCgCzucy5DW8
   CJRjfbJaklDboESk4J/erT1WOJpHxbIqphaNHr0l0vTzwvYOtb3QDoTYU
   3QwUkOt/r939gpQDNGir0GUE9tKxU/pBx5si8L3UN7UTs23gadi7s2s6l
   UjE0xMrOGhsXSf+7fn7+7EYnb/PfHJojmV3X6ZNvDsqRrE6s1L3KvTWPJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="332383010"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="332383010"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:13:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="735006642"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="735006642"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.208.101])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:13:46 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, binbin.wu@linux.intel.com
Subject: [PATCH v2 2/3] KVM: x86: Fix comments that refer to the out-dated msrs_to_save_all
Date:   Thu, 18 May 2023 17:13:38 +0800
Message-Id: <20230518091339.1102-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230518091339.1102-1-binbin.wu@linux.intel.com>
References: <20230518091339.1102-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

msrs_to_save_all is out-dated after commit 2374b7310b66
(KVM: x86/pmu: Use separate array for defining "PMU MSRs to save").

Update the comments to msrs_to_save_base.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceb7c5e9cf9e..ca7cff5252ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1432,7 +1432,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
  *
  * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
  * extract the supported MSRs from the related const lists.
- * msrs_to_save is selected from the msrs_to_save_all to reflect the
+ * msrs_to_save is selected from the msrs_to_save_base to reflect the
  * capabilities of the host cpu. This capabilities test skips MSRs that are
  * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
  * may depend on host virtualization features rather than host cpu features.
@@ -1535,7 +1535,7 @@ static const u32 emulated_msrs_all[] = {
 	 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
 	 * We always support the "true" VMX control MSRs, even if the host
 	 * processor does not, so I am putting these registers here rather
-	 * than in msrs_to_save_all.
+	 * than in msrs_to_save_base.
 	 */
 	MSR_IA32_VMX_BASIC,
 	MSR_IA32_VMX_TRUE_PINBASED_CTLS,
-- 
2.25.1

