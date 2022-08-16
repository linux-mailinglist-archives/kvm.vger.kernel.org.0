Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80CB595EF3
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 17:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbiHPPZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 11:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236077AbiHPPZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 11:25:00 -0400
Received: from smtp.smtpout.orange.fr (smtp01.smtpout.orange.fr [80.12.242.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8E060E1
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 08:24:49 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id NyQxoTzZrBDYDNyQxoNv3a; Tue, 16 Aug 2022 17:24:48 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 16 Aug 2022 17:24:48 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kvm@vger.kernel.org
Subject: [PATCH v2] vfio/fsl-mc: Fix a typo in a message
Date:   Tue, 16 Aug 2022 17:24:46 +0200
Message-Id: <3d2aa8434393ee8d2aa23a620e59ce1059c9d7ad.1660663440.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

L and S are swapped in the message.
s/VFIO_FLS_MC/VFIO_FSL_MC/

Also use WARN instead of WARN_ON+dev_warn because WARN can already print
the message.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Changes in v2:
  * s/comment/message/ in the subject   [Cornelia Huck <cohuck@redhat.com>]
  * use WARN instead of WARN_ON+dev_warn   [Jason Gunthorpe <jgg@ziepe.ca>]

v1:
  https://lore.kernel.org/all/2b65bf8d2b4d940cafbafcede07c23c35f042f5a.1659815764.git.christophe.jaillet@wanadoo.fr/
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 3feff729f3ce..57774009e0eb 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -108,9 +108,7 @@ static void vfio_fsl_mc_close_device(struct vfio_device *core_vdev)
 	/* reset the device before cleaning up the interrupts */
 	ret = vfio_fsl_mc_reset_device(vdev);
 
-	if (WARN_ON(ret))
-		dev_warn(&mc_cont->dev,
-			 "VFIO_FLS_MC: reset device has failed (%d)\n", ret);
+	WARN(ret, "VFIO_FSL_MC: reset device has failed (%d)\n", ret);
 
 	vfio_fsl_mc_irqs_cleanup(vdev);
 
-- 
2.34.1

