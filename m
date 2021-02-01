Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B8730AC9C
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhBAQ3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:29:45 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19045 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbhBAQ3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 11:29:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60182c4b0000>; Mon, 01 Feb 2021 08:28:59 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 16:28:58 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 16:28:54 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 5/9] vfio-pci/zdev: remove unused vdev argument
Date:   Mon, 1 Feb 2021 16:28:24 +0000
Message-ID: <20210201162828.5938-6-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210201162828.5938-1-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612196939; bh=xMWYa6sn9h/p+q7dA0IMYIs41LxNDoVo2lJcjjfGoS0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=Ixo9pHfLcS2xkpYi/xRrUCDAidVS/9sOiTTgoLnbY6uI6PgPpPQ1HxC1BuwfhyVOB
         EmOv2Hgv7ESeR31aZM/mTxmm2gV18Fyqd2RMBWq3Yo/1D1LEr4n+ydp+0cqu0urWtM
         MVkIKYXrv1RwxyW8p1fBw9/xU6aSud83rG5p8pUHod121vyIjLCGNIXuaEFUos78vv
         pJvZyA2psZkdCBWEh1bgHUkDXs0xVgEN0LaHiz1mcLf6+6mRDyDuc+BQtRDnpU0iQ1
         5De+Jcd4nOSx95ckeLI+H2b5H1WMPqXtjqWTbEjNJhQayLxnh36K8fefJtrsxGsvOn
         G81Pir5Wq94qg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zdev static functions does not use vdev argument. Remove it.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_z=
dev.c
index 7b20b34b1034..175096fcd902 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -24,8 +24,7 @@
 /*
  * Add the Base PCI Function information to the device info region.
  */
-static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_pci_device *vd=
ev,
-			 struct vfio_info_cap *caps)
+static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps=
)
 {
 	struct vfio_device_info_cap_zpci_base cap =3D {
 		.header.id =3D VFIO_DEVICE_INFO_CAP_ZPCI_BASE,
@@ -45,8 +44,7 @@ static int zpci_base_cap(struct zpci_dev *zdev, struct vf=
io_pci_device *vdev,
 /*
  * Add the Base PCI Function Group information to the device info region.
  */
-static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_pci_device *v=
dev,
-			  struct vfio_info_cap *caps)
+static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_info_cap *cap=
s)
 {
 	struct vfio_device_info_cap_zpci_group cap =3D {
 		.header.id =3D VFIO_DEVICE_INFO_CAP_ZPCI_GROUP,
@@ -66,8 +64,7 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct v=
fio_pci_device *vdev,
 /*
  * Add the device utility string to the device info region.
  */
-static int zpci_util_cap(struct zpci_dev *zdev, struct vfio_pci_device *vd=
ev,
-			 struct vfio_info_cap *caps)
+static int zpci_util_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps=
)
 {
 	struct vfio_device_info_cap_zpci_util *cap;
 	int cap_size =3D sizeof(*cap) + CLP_UTIL_STR_LEN;
@@ -90,8 +87,7 @@ static int zpci_util_cap(struct zpci_dev *zdev, struct vf=
io_pci_device *vdev,
 /*
  * Add the function path string to the device info region.
  */
-static int zpci_pfip_cap(struct zpci_dev *zdev, struct vfio_pci_device *vd=
ev,
-			 struct vfio_info_cap *caps)
+static int zpci_pfip_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps=
)
 {
 	struct vfio_device_info_cap_zpci_pfip *cap;
 	int cap_size =3D sizeof(*cap) + CLP_PFIP_NR_SEGMENTS;
@@ -123,21 +119,21 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_devic=
e *vdev,
 	if (!zdev)
 		return -ENODEV;
=20
-	ret =3D zpci_base_cap(zdev, vdev, caps);
+	ret =3D zpci_base_cap(zdev, caps);
 	if (ret)
 		return ret;
=20
-	ret =3D zpci_group_cap(zdev, vdev, caps);
+	ret =3D zpci_group_cap(zdev, caps);
 	if (ret)
 		return ret;
=20
 	if (zdev->util_str_avail) {
-		ret =3D zpci_util_cap(zdev, vdev, caps);
+		ret =3D zpci_util_cap(zdev, caps);
 		if (ret)
 			return ret;
 	}
=20
-	ret =3D zpci_pfip_cap(zdev, vdev, caps);
+	ret =3D zpci_pfip_cap(zdev, caps);
=20
 	return ret;
 }
--=20
2.25.4

