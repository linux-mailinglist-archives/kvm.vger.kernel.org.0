Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4092F7789F6
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 11:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbjHKJc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 05:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbjHKJcT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 05:32:19 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740DE30D6;
        Fri, 11 Aug 2023 02:32:18 -0700 (PDT)
Received: from dggpemm500019.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RMdlM28QGzCrWH;
        Fri, 11 Aug 2023 17:28:47 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 17:32:16 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 11 Aug
 2023 17:32:16 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <diana.craciun@oss.nxp.com>, <alex.williamson@redhat.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH -next] vfio/fsl-mc: use module_fsl_mc_driver() macro
Date:   Fri, 11 Aug 2023 17:29:11 +0800
Message-ID: <20230811092911.894659-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The driver init/exit() function don't do anything special, it
can use the module_fsl_mc_driver() macro to eliminate boilerplate
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index f2140e94d41e..8053f13c2be5 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -604,19 +604,7 @@ static struct fsl_mc_driver vfio_fsl_mc_driver = {
 	},
 	.driver_managed_dma = true,
 };
-
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
2.25.1

