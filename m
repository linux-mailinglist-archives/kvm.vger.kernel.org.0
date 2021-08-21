Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A9B3F3A99
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 14:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhHUMeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Aug 2021 08:34:24 -0400
Received: from mx21.baidu.com ([220.181.3.85]:59778 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230042AbhHUMeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Aug 2021 08:34:23 -0400
Received: from BJHW-Mail-Ex12.internal.baidu.com (unknown [10.127.64.35])
        by Forcepoint Email with ESMTPS id 006E2AF749E98B88988C;
        Sat, 21 Aug 2021 20:33:41 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex12.internal.baidu.com (10.127.64.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 21 Aug 2021 20:33:41 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.62.17) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 21 Aug 2021 20:33:34 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <pbonzini@redhat.com>,
        <stefanha@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        "Cai Huoqing" <caihuoqing@baidu.com>
Subject: [PATCH] vhost scsi: Convert to SPDX identifier
Date:   Sat, 21 Aug 2021 20:33:20 +0800
Message-ID: <20210821123320.734-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.32.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.62.17]
X-ClientProxiedBy: BJHW-Mail-Ex11.internal.baidu.com (10.127.64.34) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex12_2021-08-21 20:33:41:971
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

use SPDX-License-Identifier instead of a verbose license text

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/vhost/scsi.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 46f897e41217..532e204f2b1b 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1,24 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*******************************************************************************
  * Vhost kernel TCM fabric driver for virtio SCSI initiators
  *
  * (C) Copyright 2010-2013 Datera, Inc.
  * (C) Copyright 2010-2012 IBM Corp.
  *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
- *
  * Authors: Nicholas A. Bellinger <nab@daterainc.com>
  *          Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  ****************************************************************************/
 
 #include <linux/module.h>
-- 
2.25.1

