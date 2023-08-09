Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8236E776062
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 15:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbjHINQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 09:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjHINQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 09:16:05 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F5AE5F
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 06:16:02 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RLVq93973z1hwd5;
        Wed,  9 Aug 2023 21:13:09 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 9 Aug
 2023 21:15:59 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <diana.craciun@oss.nxp.com>, <alex.williamson@redhat.com>
CC:     <lizetao1@huawei.com>, <kvm@vger.kernel.org>
Subject: [PATCH -next] vfio/fsl-mc: Use module_fsl_mc_driver macro to simplify the code
Date:   Wed, 9 Aug 2023 21:15:36 +0800
Message-ID: <20230809131536.4021639-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the module_fsl_mc_driver macro to simplify the code and
remove redundant initialization owner in vfio_fsl_mc_driver.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 116358a8f1cf..f65d91c01f2e 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -601,23 +601,11 @@ static struct fsl_mc_driver vfio_fsl_mc_driver = {
 	.remove		= vfio_fsl_mc_remove,
 	.driver	= {
 		.name	= "vfio-fsl-mc",
-		.owner	= THIS_MODULE,
 	},
 	.driver_managed_dma = true,
 };
 
-static int __init vfio_fsl_mc_driver_init(void)
-{
-	return fsl_mc_driver_register(&vfio_fsl_mc_driver);
-}
-
-static void __exit vfio_fsl_mc_driver_exit(void)
-{
-	fsl_mc_driver_unregister(&vfio_fsl_mc_driver);
-}
-
-module_init(vfio_fsl_mc_driver_init);
-module_exit(vfio_fsl_mc_driver_exit);
+module_fsl_mc_driver(vfio_fsl_mc_driver);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("VFIO for FSL-MC devices - User Level meta-driver");
-- 
2.34.1

