Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55D758B814
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 21:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbiHFT5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 15:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbiHFT4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 15:56:30 -0400
Received: from smtp.smtpout.orange.fr (smtp07.smtpout.orange.fr [80.12.242.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C363412AC9
        for <kvm@vger.kernel.org>; Sat,  6 Aug 2022 12:56:16 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id KPuAob2sMGDTnKPuAobw3d; Sat, 06 Aug 2022 21:56:14 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 06 Aug 2022 21:56:14 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kvm@vger.kernel.org
Subject: [PATCH] vfio/fsl-mc: Fix a typo in a comment
Date:   Sat,  6 Aug 2022 21:56:13 +0200
Message-Id: <2b65bf8d2b4d940cafbafcede07c23c35f042f5a.1659815764.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

L and S are swapped/
s/VFIO_FLS_MC/VFIO_FSL_MC/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
All the dev_ logging functions in the file have the "VFIO_FSL_MC: "
prefix.
As they are dev_ function, the driver should already be displayed.

So, does it make sense or could they be all removed?
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 3feff729f3ce..66d01db1d240 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -110,7 +110,7 @@ static void vfio_fsl_mc_close_device(struct vfio_device *core_vdev)
 
 	if (WARN_ON(ret))
 		dev_warn(&mc_cont->dev,
-			 "VFIO_FLS_MC: reset device has failed (%d)\n", ret);
+			 "VFIO_FSL_MC: reset device has failed (%d)\n", ret);
 
 	vfio_fsl_mc_irqs_cleanup(vdev);
 
-- 
2.34.1

