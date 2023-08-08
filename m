Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB1D773642
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 04:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjHHCKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 22:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjHHCKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 22:10:06 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B212F1710
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 19:10:04 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RKc4V251GzNmy4;
        Tue,  8 Aug 2023 10:06:34 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 8 Aug
 2023 10:10:02 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <nipun.gupta@amd.com>, <nikhil.agarwal@amd.com>,
        <alex.williamson@redhat.com>
CC:     <lizetao1@huawei.com>, <kvm@vger.kernel.org>
Subject: [PATCH -next] vfio/cdx: Remove redundant initialization owner in vfio_cdx_driver
Date:   Tue, 8 Aug 2023 10:09:37 +0800
Message-ID: <20230808020937.2975196-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cdx_driver_register() will set "THIS_MODULE" to driver.owner when
register a cdx_driver driver, so it is redundant initialization to set
driver.owner in the statement. Remove it for clean code.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 drivers/vfio/cdx/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
index c376a69d2db2..de56686581ae 100644
--- a/drivers/vfio/cdx/main.c
+++ b/drivers/vfio/cdx/main.c
@@ -223,7 +223,6 @@ static struct cdx_driver vfio_cdx_driver = {
 	.match_id_table	= vfio_cdx_table,
 	.driver	= {
 		.name	= "vfio-cdx",
-		.owner	= THIS_MODULE,
 	},
 	.driver_managed_dma = true,
 };
-- 
2.34.1

