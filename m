Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC41176A700
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 04:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjHACcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 22:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjHACcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 22:32:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6923AE65
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 19:32:00 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RFJxt2XSdz1GDPx;
        Tue,  1 Aug 2023 10:30:58 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 1 Aug
 2023 10:31:58 +0800
From:   Ruan Jinjie <ruanjinjie@huawei.com>
To:     <alex.williamson@redhat.com>, <jgg@ziepe.ca>,
        <kevin.tian@intel.com>, <reinette.chatre@intel.com>,
        <tglx@linutronix.de>, <ruanjinjie@huawei.com>,
        <abhsahu@nvidia.com>, <kvm@vger.kernel.org>
Subject: [PATCH -next] vfio/pci: Remove an unnecessary ternary operator
Date:   Tue, 1 Aug 2023 10:31:22 +0800
Message-ID: <20230801023122.3354175-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The true or false judgement of the ternary operator is unnecessary
in C language semantics. So remove it to clean Code.

Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index cbb4bcbfbf83..2fd018e9b039 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -652,7 +652,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 {
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
-	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
+	bool msix = index == VFIO_PCI_MSIX_IRQ_INDEX;
 
 	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_msi_disable(vdev, msix);
-- 
2.34.1

