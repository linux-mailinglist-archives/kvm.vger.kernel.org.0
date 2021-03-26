Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A407634A340
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 09:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCZIhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 04:37:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14615 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhCZIhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 04:37:08 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6Fdx6Kh0z19JfD;
        Fri, 26 Mar 2021 16:35:01 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.179.202) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 16:36:55 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 4/4] vfio/platform: Fix spelling mistake "registe" -> "register"
Date:   Fri, 26 Mar 2021 16:35:28 +0800
Message-ID: <20210326083528.1329-5-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210326083528.1329-1-thunder.leizhen@huawei.com>
References: <20210326083528.1329-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.202]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a spelling mistake in a comment, fix it.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
index 09a9453b75c5592..63cc7f0b2e4a437 100644
--- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
+++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
@@ -26,7 +26,7 @@
 #define XGMAC_DMA_CONTROL       0x00000f18      /* Ctrl (Operational Mode) */
 #define XGMAC_DMA_INTR_ENA      0x00000f1c      /* Interrupt Enable */
 
-/* DMA Control registe defines */
+/* DMA Control register defines */
 #define DMA_CONTROL_ST          0x00002000      /* Start/Stop Transmission */
 #define DMA_CONTROL_SR          0x00000002      /* Start/Stop Receive */
 
-- 
1.8.3


