Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780553F5420
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 02:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhHXAin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 20:38:43 -0400
Received: from mx21.baidu.com ([220.181.3.85]:38818 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233360AbhHXAim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 20:38:42 -0400
Received: from BC-Mail-Ex21.internal.baidu.com (unknown [172.31.51.15])
        by Forcepoint Email with ESMTPS id 9EA75B756A063C834017;
        Tue, 24 Aug 2021 08:37:56 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex21.internal.baidu.com (172.31.51.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 24 Aug 2021 08:37:56 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 24 Aug 2021 08:37:56 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <mjrosato@linux.ibm.com>, <farman@linux.ibm.com>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>
CC:     <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH v2] vfio-pci/zdev: Remove repeated verbose license text
Date:   Tue, 24 Aug 2021 08:37:49 +0800
Message-ID: <20210824003749.1039-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex15.internal.baidu.com (172.31.51.55) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

remove it because SPDX-License-Identifier is already used
and change "GPL-2.0+" to "GPL-2.0-only"

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
v1->v2: change "GPL-2.0+" to "GPL-2.0-only"

 drivers/vfio/pci/vfio_pci_zdev.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 7b011b62c766..104fcf6658db 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -1,15 +1,10 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * VFIO ZPCI devices support
  *
  * Copyright (C) IBM Corp. 2020.  All rights reserved.
  *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
  *                 Matthew Rosato <mjrosato@linux.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
  */
 #include <linux/io.h>
 #include <linux/pci.h>
-- 
2.25.1

