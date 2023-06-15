Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52ECD7311B2
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 10:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjFOIFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 04:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjFOIFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 04:05:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C220135
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 01:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686816332; x=1718352332;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L+he4Z+5cLuC40aQHUxZXyH5MUxV/r3z5GvtllcRDFQ=;
  b=LYLYo/e4qeiNkU9SLBRlcXUt5Zumo/1HGo9lEh5e0AyQ2WuGWUxPPLfT
   6FkB7SsfH3G8nQ6YKM4ZU/0+J5YQBxzq6wZK1QlhDWCwx5YsyMWKwS9KZ
   ySw5sF9Hq1t5slKnzGKdU7eEARmpRCGdLfW69ktrh0ChpbAUgmHmiI1yf
   TP6ltP+vX1mKZ5PJpKnuICPOZPgEtRJybyhZWT1zjExJFPX8J73l2idsl
   UzruFRZOprt33PT1qjUl4BCqpEMWtSLvalRQfYu26qEfHO4wrd0c4zYsa
   HiOcrfOv520XfmrUE1Czh/9SVq7NpCnKs+UShAMAU55PdbciVfDCjCAs1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="358839419"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="358839419"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 01:05:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="1042550990"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="1042550990"
Received: from ubuntu.bj.intel.com ([10.238.156.105])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jun 2023 01:05:29 -0700
From:   Jun Miao <jun.miao@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, jun.miao@intel.com
Subject: [PATCH] KVM: x86: Update the version number of SDM in comments
Date:   Thu, 15 Jun 2023 16:06:24 +0800
Message-Id: <20230615080624.725551-1-jun.miao@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A little optimized update version number of SDM and corresponding
public date, making it more accurate to retrieve.

Signed-off-by: Jun Miao <jun.miao@intel.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7639d126e6c..4c5493e08d2e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2260,7 +2260,7 @@ static int apic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 	/*
 	 * APIC register must be aligned on 128-bits boundary.
 	 * 32/64/128 bits registers must be accessed thru 32 bits.
-	 * Refer SDM 8.4.1
+	 * Refer SDM 11.4.1 (March 2023).
 	 */
 	if (len != 4 || (offset & 0xf))
 		return 0;
-- 
2.32.0

