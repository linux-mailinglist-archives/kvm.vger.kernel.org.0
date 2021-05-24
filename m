Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC3738E629
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhEXMG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:06:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5758 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbhEXMGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 08:06:23 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FpbQj400Rzmkv0;
        Mon, 24 May 2021 20:01:17 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 20:04:51 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 20:04:51 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH] vhost: Remove the repeated declaration
Date:   Mon, 24 May 2021 20:04:44 +0800
Message-ID: <1621857884-19964-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Function 'vhost_vring_ioctl' is declared twice, remove the repeated
declaration.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/vhost/vhost.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b063324c7669..374f4795cb5a 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -47,7 +47,6 @@ void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
 void vhost_poll_queue(struct vhost_poll *poll);
 void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work);
-long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp);
 
 struct vhost_log {
 	u64 addr;
-- 
2.7.4

