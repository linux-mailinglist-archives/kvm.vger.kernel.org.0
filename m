Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697702992FD
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 17:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786610AbgJZQxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 12:53:45 -0400
Received: from inva021.nxp.com ([92.121.34.21]:39862 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1786604AbgJZQxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 12:53:45 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E3EA52011CD;
        Mon, 26 Oct 2020 17:53:43 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D7E142010E8;
        Mon, 26 Oct 2020 17:53:43 +0100 (CET)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8F65320308;
        Mon, 26 Oct 2020 17:53:43 +0100 (CET)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, laurentiu.tudor@nxp.com,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH] vfio/fsl-mc: Make vfio_fsl_mc_irqs_allocate static
Date:   Mon, 26 Oct 2020 18:53:36 +0200
Message-Id: <20201026165336.31125-1-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixed compiler warning:
drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c:16:5: warning: no previous
prototype for function 'vfio_fsl_mc_irqs_allocate' [-Wmissing-prototypes]
       ^
drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c:16:1: note: declare 'static'
if the function is not intended to be used outside of this translation unit
int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
index c80dceb46f79..0d9f3002df7f 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -13,7 +13,7 @@
 #include "linux/fsl/mc.h"
 #include "vfio_fsl_mc_private.h"
 
-int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)
+static int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)
 {
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
 	struct vfio_fsl_mc_irq *mc_irq;
-- 
2.17.1

