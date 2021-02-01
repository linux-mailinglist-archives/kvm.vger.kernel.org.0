Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E64130AC94
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhBAQ3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:29:20 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9089 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhBAQ3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 11:29:19 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60182c370000>; Mon, 01 Feb 2021 08:28:39 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 16:28:38 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 16:28:34 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/9] vfio-pci: rename vfio_pci.c to vfio_pci_core.c
Date:   Mon, 1 Feb 2021 16:28:20 +0000
Message-ID: <20210201162828.5938-2-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210201162828.5938-1-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612196919; bh=cD5IrQ+dWwGI6zYP21oJURgsVtNrdqC+pW+2KPZxPk0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=M44nR0TmIGfBbdIaZwHOQ99ZI2fGzJRTBHYvemPa6ms/mWEpvB+NXzJuc+tL/ZbfY
         nwNMJyks+P27xHDfDRWfGejJ30dwEeBUlTt6O5Ngrui5QbZn1kN4FW16n24apMLQ8a
         z9xI7fe5mQ9DpGHMG9lyuDpCE4NUES1KhbGiGGuLdP/KWOSQpj/FbsgDfIW1RBK50k
         P34W4iSSyy4ds9PIugnHYOxWG1DAzThAHGlVHNGXtanJ3ijaHHqi+XfSMnmk/3JHJx
         dPDSd3yFk1A4u4gyZL4DP3c6daXMjyF+iCdWVMP2UnadN+WJyt2M5CMwx+0a7vy204
         HTwHv6F3aOa8Q==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparation patch for separating the vfio_pci driver to a
subsystem driver and a generic pci driver. This patch doesn't change any
logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Makefile                        | 2 +-
 drivers/vfio/pci/{vfio_pci.c =3D> vfio_pci_core.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/vfio/pci/{vfio_pci.c =3D> vfio_pci_core.c} (100%)

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 781e0809d6ee..d5555d350b9b 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
=20
-vfio-pci-y :=3D vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_confi=
g.o
+vfio-pci-y :=3D vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_=
config.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) +=3D vfio_pci_igd.o
 vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) +=3D vfio_pci_nvlink2.o
 vfio-pci-$(CONFIG_VFIO_PCI_ZDEV) +=3D vfio_pci_zdev.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci_core.c
similarity index 100%
rename from drivers/vfio/pci/vfio_pci.c
rename to drivers/vfio/pci/vfio_pci_core.c
--=20
2.25.4

