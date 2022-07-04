Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD1B564BD2
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 04:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiGDChF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jul 2022 22:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiGDChC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jul 2022 22:37:02 -0400
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C476560;
        Sun,  3 Jul 2022 19:36:55 -0700 (PDT)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id YZO00151;
        Mon, 04 Jul 2022 10:36:51 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201607.home.langchao.com (10.100.2.7) with Microsoft SMTP Server id
 15.1.2507.9; Mon, 4 Jul 2022 10:36:52 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] vfio/pci: fix the wrong word
Date:   Sun, 3 Jul 2022 22:36:49 -0400
Message-ID: <20220704023649.3913-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   202270410365109af86c3aca98813d1cd2d554f1f982d
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
index 9343f597182d..97e5ade6efb3 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1728,7 +1728,7 @@ int vfio_config_init(struct vfio_pci_core_device *vdev)
 	/*
 	 * Config space, caps and ecaps are all dword aligned, so we could
 	 * use one byte per dword to record the type.  However, there are
-	 * no requiremenst on the length of a capability, so the gap between
+	 * no requirements on the length of a capability, so the gap between
 	 * capabilities needs byte granularity.
 	 */
 	map = kmalloc(pdev->cfg_size, GFP_KERNEL);
-- 
2.27.0

