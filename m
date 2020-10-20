Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2861428D07E
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 16:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbgJMOmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 10:42:23 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47262 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJMOmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 10:42:22 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DE4221A01CC;
        Tue, 13 Oct 2020 16:42:20 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D0DB31A0119;
        Tue, 13 Oct 2020 16:42:20 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8B6692037B;
        Tue, 13 Oct 2020 16:42:20 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, laurentiu.tudor@nxp.com,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH] Fixed vfio-fsl-mc driver compilation on 32 bit
Date:   Tue, 13 Oct 2020 17:42:07 +0300
Message-Id: <20201013144207.2599-1-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The FSL_MC_BUS on which the VFIO-FSL-MC driver is dependent on
can be compiled on other architectures as well (not only ARM64)
including 32 bit architectures.
Include linux/io-64-nonatomic-hi-lo.h to make writeq/readq used
in the driver available on 32bit platforms.

Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index d009f873578c..80fc7f4ed343 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -13,6 +13,7 @@
 #include <linux/vfio.h>
 #include <linux/fsl/mc.h>
 #include <linux/delay.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
 
 #include "vfio_fsl_mc_private.h"
 
-- 
2.17.1

