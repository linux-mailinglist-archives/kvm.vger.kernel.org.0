Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE19C3F3DBC
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 06:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhHVEgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 00:36:02 -0400
Received: from mx21.baidu.com ([220.181.3.85]:48974 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229849AbhHVEgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 00:36:00 -0400
Received: from BJHW-Mail-Ex01.internal.baidu.com (unknown [10.127.64.11])
        by Forcepoint Email with ESMTPS id D58E8AD30CEC27B75184;
        Sun, 22 Aug 2021 12:35:17 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex01.internal.baidu.com (10.127.64.11) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sun, 22 Aug 2021 12:35:17 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.62.20) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sun, 22 Aug 2021 12:35:17 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <mjrosato@linux.ibm.com>, <farman@linux.ibm.com>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>
CC:     <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] vfio-pci/zdev: Remove repeated verbose license text
Date:   Sun, 22 Aug 2021 12:35:00 +0800
Message-ID: <20210822043500.561-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.32.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.62.20]
X-ClientProxiedBy: BC-Mail-Ex28.internal.baidu.com (172.31.51.22) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

remove it because SPDX-License-Identifier is already used

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 7b011b62c766..dfd8d826223d 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -5,11 +5,6 @@
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

