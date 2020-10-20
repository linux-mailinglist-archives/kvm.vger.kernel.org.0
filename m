Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205C12901FA
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 11:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405990AbgJPJdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 05:33:17 -0400
Received: from inva021.nxp.com ([92.121.34.21]:33668 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394926AbgJPJdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Oct 2020 05:33:16 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 375B2200A16;
        Fri, 16 Oct 2020 11:33:15 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2B014200A0D;
        Fri, 16 Oct 2020 11:33:15 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CD09D20341;
        Fri, 16 Oct 2020 11:33:14 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, laurentiu.tudor@nxp.com,
        colin.king@canonical.com, Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH v2] vfio/fsl-mc: fix the return of the uninitialized variable ret
Date:   Fri, 16 Oct 2020 12:32:32 +0300
Message-Id: <20201016093232.12774-1-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_fsl_mc_reflck_attach function may return, on success path,
an uninitialized variable. Fix the problem by initializing the return
variable to 0.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation for interrupt handling")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 80fc7f4ed343..0113a980f974 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -58,7 +58,7 @@ static struct vfio_fsl_mc_reflck *vfio_fsl_mc_reflck_alloc(void)
 
 static int vfio_fsl_mc_reflck_attach(struct vfio_fsl_mc_device *vdev)
 {
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&reflck_lock);
 	if (is_fsl_mc_bus_dprc(vdev->mc_dev)) {
-- 
2.17.1

