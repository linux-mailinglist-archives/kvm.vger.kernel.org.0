Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2473B2A4C0
	for <lists+kvm@lfdr.de>; Sat, 25 May 2019 15:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfEYNyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 May 2019 09:54:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17573 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726898AbfEYNyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 May 2019 09:54:21 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DC0AF18DC2E8F554C2AD;
        Sat, 25 May 2019 21:54:18 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Sat, 25 May 2019
 21:54:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kwankhede@nvidia.com>, <alex.williamson@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] sample/mdev/mbochs: remove set but not used variable 'mdev_state'
Date:   Sat, 25 May 2019 21:53:49 +0800
Message-ID: <20190525135349.16488-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

samples/vfio-mdev/mbochs.c: In function mbochs_ioctl:
samples/vfio-mdev/mbochs.c:1188:21: warning: variable mdev_state set but not used [-Wunused-but-set-variable]

It's not used any more since commit 104c7405a64d ("vfio:
add edid support to mbochs sample driver")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 samples/vfio-mdev/mbochs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index b038aa9f5a70..ac5c8c17b1ff 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1185,9 +1185,6 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 {
 	int ret = 0;
 	unsigned long minsz, outsz;
-	struct mdev_state *mdev_state;
-
-	mdev_state = mdev_get_drvdata(mdev);
 
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
-- 
2.17.1


