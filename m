Return-Path: <kvm+bounces-22677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9DB94140A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 16:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 047471F242A0
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 14:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A159C1A0AF2;
	Tue, 30 Jul 2024 14:13:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F141465A7;
	Tue, 30 Jul 2024 14:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722348804; cv=none; b=hC2qnFDg6Uj649pnfa0D5TPhI3x8d0+wMVnwSzmnItHdGUHVCkw6Q17d3Tw0H4kfEFtX16JjkKSo1VSF/YEoUd9ak7yjG08Blmc6Np2hibtgBw+iM6bebJsTvavZMrUcPpRWG3FdB5lnO0TnmxBvUKxtlpe00msYE2figqh5WAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722348804; c=relaxed/simple;
	bh=sCLGGzDv1gWkhzhSzAWcvEKO+MPuUAl3DO50dmWHWLI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zv45e2je0wlOCJCqEovjTR5zrQn3/HhItJAcOIq8ZjrV4RVBHDM7ffaPnpUvIn8ewKckgQRZOID/Y8cU4sPV85ZeZgeEoXB3J8DXBBF0aB0IhGegBWejHAMRm0NqPq2IuQbmjCk26mVJ20rMVY6m6IUs4pLcoUD0MlxeqDF5VtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WYHH66FzVzncBD;
	Tue, 30 Jul 2024 22:12:18 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 0A71018009F;
	Tue, 30 Jul 2024 22:13:17 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 30 Jul
 2024 22:13:16 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>
Subject: [PATCH -next] vfio/fsl-mc: Remove unused variable 'hwirq'
Date: Tue, 30 Jul 2024 22:11:33 +0800
Message-ID: <20240730141133.525771-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Commit 7447d911af69 ("vfio/fsl-mc: Block calling interrupt handler without trigger")
left this variable unused, so remove it.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
index 82b2afa9b7e3..7e7988c4258f 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -108,10 +108,10 @@ static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
 				       void *data)
 {
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
-	int ret, hwirq;
 	struct vfio_fsl_mc_irq *irq;
 	struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
 	struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
+	int ret;
 
 	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
 		return vfio_set_trigger(vdev, index, -1);
@@ -136,8 +136,6 @@ static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
 		return vfio_set_trigger(vdev, index, fd);
 	}
 
-	hwirq = vdev->mc_dev->irqs[index]->virq;
-
 	irq = &vdev->mc_irqs[index];
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-- 
2.34.1


