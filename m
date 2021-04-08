Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149A13583AE
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhDHMvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:51:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16843 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhDHMvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 08:51:40 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FGLgG63ljz9sLf;
        Thu,  8 Apr 2021 20:49:14 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 20:51:19 +0800
From:   Chen Huang <chenhuang5@huawei.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Chen Huang <chenhuang5@huawei.com>
Subject: [PATCH -next] vfio/fsl-mc: Use module_fsl_mc_driver to simplify the code
Date:   Thu, 8 Apr 2021 12:58:57 +0000
Message-ID: <20210408125857.1158780-1-chenhuang5@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.125]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

module_fsl_mc_driver() makes the code simpler by eliminating
boilerplate code.

Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 980e59551301..b2fcc77a037f 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -701,18 +701,7 @@ static struct fsl_mc_driver vfio_fsl_mc_driver = {
 	},
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
2.17.1

