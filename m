Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1A958625D
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 03:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238924AbiHABor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jul 2022 21:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238774AbiHABoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jul 2022 21:44:46 -0400
X-Greylist: delayed 309 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 31 Jul 2022 18:44:43 PDT
Received: from mtakt52.mailrelay.cn (mtakt52.mailrelay.cn [110.34.168.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7645C65F6
        for <kvm@vger.kernel.org>; Sun, 31 Jul 2022 18:44:43 -0700 (PDT)
Received: from jtjnmail201611.home.langchao.com (unknown [60.208.111.195])
        by smtp.mailrelay.cn (Postfix) with ESMTPS id DCA7941A4FBB;
        Mon,  1 Aug 2022 09:39:20 +0800 (CST)
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201611.home.langchao.com (10.100.2.11) with Microsoft SMTP Server id
 15.1.2507.9; Mon, 1 Aug 2022 09:39:20 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] vfio/pci: fix the wrong word
Date:   Sun, 31 Jul 2022 21:39:18 -0400
Message-ID: <20220801013918.2520-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch fixes a wrong word in comment.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 97e5ade6efb3..442d3ba4122b 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -222,7 +222,7 @@ static int vfio_default_config_write(struct vfio_pci_core_device *vdev, int pos,
 		memcpy(vdev->vconfig + pos, &virt_val, count);
 	}
 
-	/* Non-virtualzed and writable bits go to hardware */
+	/* Non-virtualized and writable bits go to hardware */
 	if (write & ~virt) {
 		struct pci_dev *pdev = vdev->pdev;
 		__le32 phys_val = 0;
-- 
2.27.0
