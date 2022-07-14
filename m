Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F024574655
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 10:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiGNIJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 04:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiGNIJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 04:09:24 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F8BF2B183;
        Thu, 14 Jul 2022 01:09:21 -0700 (PDT)
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 5B98C804CB;
        Thu, 14 Jul 2022 04:09:15 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     kvm@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm-ppc@vger.kernel.org
Subject: [PATCH kernel] vfio/spapr_tce: Fix the comment
Date:   Thu, 14 Jul 2022 18:09:12 +1000
Message-Id: <20220714080912.3713509-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Grepping for "iommu_ops" finds this spot and gives wrong impression
that iommu_ops is used in here, fix the comment.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 708a95e61831..cd7b9c136889 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -1266,7 +1266,7 @@ static int tce_iommu_attach_group(void *iommu_data,
 		goto unlock_exit;
 	}
 
-	/* Check if new group has the same iommu_ops (i.e. compatible) */
+	/* Check if new group has the same iommu_table_group_ops (i.e. compatible) */
 	list_for_each_entry(tcegrp, &container->group_list, next) {
 		struct iommu_table_group *table_group_tmp;
 
-- 
2.30.2

