Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979E7FFE5C
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 07:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKRGTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 01:19:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56651 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726669AbfKRGTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 01:19:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574057983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2AW/iLbcogwLyTTIbQmc5eL4wtCuBt/lwz33kIgX8ws=;
        b=HWVJcs0MxqEakiqadW9B58vDjFR/R1nl5hNSXGQWv1Yq2DTE1soVS+WLcEHdDquk9+L1JM
        yEjRIhCFVUmkVH+f8HddjkNVIArTIUTzhwb2HdcW0a6OrDsBFAdW0xzFwYimg9MqHhdsqp
        +Tv/HvsT80RtrIToNtZ7aC0DqDDCVI0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-waHKW_xQM_eRXxIVjTJADg-1; Mon, 18 Nov 2019 01:19:37 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81F401005514;
        Mon, 18 Nov 2019 06:19:32 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-215.pek2.redhat.com [10.72.12.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D37D360BF4;
        Mon, 18 Nov 2019 06:19:05 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        gregkh@linuxfoundation.org, jgg@mellanox.com,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH V12 3/6] mdev: move to drivers/
Date:   Mon, 18 Nov 2019 14:17:00 +0800
Message-Id: <20191118061703.8669-4-jasowang@redhat.com>
In-Reply-To: <20191118061703.8669-1-jasowang@redhat.com>
References: <20191118061703.8669-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: waHKW_xQM_eRXxIVjTJADg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mdev now is nothing VFIO specific, let's move it to upper
directory.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 MAINTAINERS                                   |  7 +++++--
 drivers/Kconfig                               |  2 ++
 drivers/Makefile                              |  1 +
 drivers/mdev/Kconfig                          | 19 ++++++++++++++++++
 drivers/mdev/Makefile                         |  5 +++++
 drivers/{vfio =3D> }/mdev/mdev_core.c           |  0
 drivers/{vfio =3D> }/mdev/mdev_driver.c         |  0
 drivers/{vfio =3D> }/mdev/mdev_private.h        |  0
 drivers/{vfio =3D> }/mdev/mdev_sysfs.c          |  0
 .../{vfio/mdev/mdev_vfio.c =3D> mdev/vfio.c}    |  0
 drivers/vfio/mdev/Kconfig                     | 20 -------------------
 drivers/vfio/mdev/Makefile                    |  4 ----
 drivers/vfio/mdev/vfio_mdev.c                 |  2 --
 13 files changed, 32 insertions(+), 28 deletions(-)
 create mode 100644 drivers/mdev/Kconfig
 create mode 100644 drivers/mdev/Makefile
 rename drivers/{vfio =3D> }/mdev/mdev_core.c (100%)
 rename drivers/{vfio =3D> }/mdev/mdev_driver.c (100%)
 rename drivers/{vfio =3D> }/mdev/mdev_private.h (100%)
 rename drivers/{vfio =3D> }/mdev/mdev_sysfs.c (100%)
 rename drivers/{vfio/mdev/mdev_vfio.c =3D> mdev/vfio.c} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index d335949240dc..829428d8a9f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17111,15 +17111,18 @@ T:=09git git://github.com/awilliam/linux-vfio.git
 S:=09Maintained
 F:=09Documentation/driver-api/vfio.rst
 F:=09drivers/vfio/
+F:=09drivers/mdev/vfio.c
 F:=09include/linux/vfio.h
 F:=09include/uapi/linux/vfio.h
=20
-VFIO MEDIATED DEVICE DRIVERS
+MEDIATED DEVICE DRIVERS
+M:=09Alex Williamson <alex.williamson@redhat.com>
 M:=09Kirti Wankhede <kwankhede@nvidia.com>
+R:=09Cornelia Huck <cohuck@redhat.com>
 L:=09kvm@vger.kernel.org
 S:=09Maintained
 F:=09Documentation/driver-api/vfio-mediated-device.rst
-F:=09drivers/vfio/mdev/
+F:=09drivers/mdev
 F:=09include/linux/mdev.h
 F:=09include/linux/mdev_vfio.h
 F:=09samples/vfio-mdev/
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 8befa53f43be..3e2839048fe6 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -228,4 +228,6 @@ source "drivers/interconnect/Kconfig"
=20
 source "drivers/counter/Kconfig"
=20
+source "drivers/mdev/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index aaef17cc6512..592e23f2e629 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -186,3 +186,4 @@ obj-$(CONFIG_SIOX)=09=09+=3D siox/
 obj-$(CONFIG_GNSS)=09=09+=3D gnss/
 obj-$(CONFIG_INTERCONNECT)=09+=3D interconnect/
 obj-$(CONFIG_COUNTER)=09=09+=3D counter/
+obj-$(CONFIG_MDEV)=09=09+=3D mdev/
diff --git a/drivers/mdev/Kconfig b/drivers/mdev/Kconfig
new file mode 100644
index 000000000000..4561f2d4178f
--- /dev/null
+++ b/drivers/mdev/Kconfig
@@ -0,0 +1,19 @@
+
+config MDEV
+=09tristate "Mediated device driver framework"
+=09default n
+=09help
+=09  Provides a framework to virtualize devices.
+
+=09  If you don't know what do here, say N.
+
+config VFIO_MDEV
+=09tristate "VFIO Mediated device driver"
+        depends on VFIO && MDEV
+        default n
+=09help
+=09  Proivdes a mediated BUS for userspace driver through VFIO
+=09  framework. See Documentation/vfio-mediated-device.txt for
+=09  more details.
+
+=09  If you don't know what do here, say N.
diff --git a/drivers/mdev/Makefile b/drivers/mdev/Makefile
new file mode 100644
index 000000000000..0b749e7f8ff4
--- /dev/null
+++ b/drivers/mdev/Makefile
@@ -0,0 +1,5 @@
+
+mdev-y :=3D mdev_core.o mdev_sysfs.o mdev_driver.o
+mdev_vfio-y :=3D vfio.o
+obj-$(CONFIG_MDEV) +=3D mdev.o
+obj-$(CONFIG_VFIO_MDEV) +=3D mdev_vfio.o
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/mdev/mdev_core.c
similarity index 100%
rename from drivers/vfio/mdev/mdev_core.c
rename to drivers/mdev/mdev_core.c
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/mdev/mdev_driver.c
similarity index 100%
rename from drivers/vfio/mdev/mdev_driver.c
rename to drivers/mdev/mdev_driver.c
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/mdev/mdev_private.h
similarity index 100%
rename from drivers/vfio/mdev/mdev_private.h
rename to drivers/mdev/mdev_private.h
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/mdev/mdev_sysfs.c
similarity index 100%
rename from drivers/vfio/mdev/mdev_sysfs.c
rename to drivers/mdev/mdev_sysfs.c
diff --git a/drivers/vfio/mdev/mdev_vfio.c b/drivers/mdev/vfio.c
similarity index 100%
rename from drivers/vfio/mdev/mdev_vfio.c
rename to drivers/mdev/vfio.c
diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index 2e07ca915a96..9a9234c3e00e 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -1,24 +1,4 @@
=20
-config MDEV
-=09tristate "Mediated device driver framework"
-=09default n
-=09help
-=09  Provides a framework to virtualize devices.
-
-=09  If you don't know what do here, say N.
-
-config VFIO_MDEV
-=09tristate "VFIO Mediated device driver"
-        depends on VFIO && MDEV
-        default n
-=09help
-=09  Proivdes a mediated BUS for userspace driver through VFIO
-=09  framework. See Documentation/vfio-mediated-device.txt for
-=09  more details.
-
-=09  If you don't know what do here, say N.
-
-
 config VFIO_MDEV_DEVICE
 =09tristate "VFIO driver for Mediated devices"
 =09depends on VFIO && VFIO_MDEV
diff --git a/drivers/vfio/mdev/Makefile b/drivers/vfio/mdev/Makefile
index e9675501271a..e2a92df3089e 100644
--- a/drivers/vfio/mdev/Makefile
+++ b/drivers/vfio/mdev/Makefile
@@ -1,6 +1,2 @@
=20
-mdev-y :=3D mdev_core.o mdev_sysfs.o mdev_driver.o
-
-obj-$(CONFIG_MDEV) +=3D mdev.o
-obj-$(CONFIG_VFIO_MDEV) +=3D mdev_vfio.o
 obj-$(CONFIG_VFIO_MDEV_DEVICE) +=3D vfio_mdev.o
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 8b42a4b3f161..4eada31e9287 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -15,8 +15,6 @@
 #include <linux/vfio.h>
 #include <linux/mdev_vfio.h>
=20
-#include "mdev_private.h"
-
 #define DRIVER_VERSION  "0.1"
 #define DRIVER_AUTHOR   "NVIDIA Corporation"
 #define DRIVER_DESC     "VFIO based driver for Mediated device"
--=20
2.19.1

