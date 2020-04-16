Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F6B1ABA88
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 09:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440184AbgDPH5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 03:57:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42036 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2440874AbgDPH5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 03:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587023842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=payC5JiVreqHkU2B+K9UiLU+mY+GY4f5CPsBYBzyoLA=;
        b=GjTJXd4mzA2ISq4r3dZkf15+bwSangu3mJWzkolir83A9Wq72cMeiIvnyYREKkPsth+/zB
        VGA6Z4bgpKsqjibxdoTDcRhaIus0LEFdLJ/lAK7qoJhFimFdfeVRO0mPWGM9c83kdwvulh
        r8Rj76Xce9acMm7CJELrqoOWrKsIRAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-A3DgaoqiOKqhn-19x2antg-1; Thu, 16 Apr 2020 03:57:18 -0400
X-MC-Unique: A3DgaoqiOKqhn-19x2antg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 461FF107ACC9;
        Thu, 16 Apr 2020 07:57:17 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E34AD7E7C0;
        Thu, 16 Apr 2020 07:57:14 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 8/8] tools/virtio: Use tools/include/list.h instead of stubs
Date:   Thu, 16 Apr 2020 09:56:43 +0200
Message-Id: <20200416075643.27330-9-eperezma@redhat.com>
In-Reply-To: <20200416075643.27330-1-eperezma@redhat.com>
References: <20200416075643.27330-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It should not make any significant difference but reduce stub code.

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 tools/virtio/linux/kernel.h | 7 +------
 tools/virtio/linux/virtio.h | 5 ++---
 tools/virtio/virtio_test.c  | 1 +
 tools/virtio/vringh_test.c  | 2 ++
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/tools/virtio/linux/kernel.h b/tools/virtio/linux/kernel.h
index 6683b4a70b05..caab980211a6 100644
--- a/tools/virtio/linux/kernel.h
+++ b/tools/virtio/linux/kernel.h
@@ -11,6 +11,7 @@
=20
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/list.h>
 #include <linux/printk.h>
 #include <linux/bug.h>
 #include <errno.h>
@@ -135,10 +136,4 @@ static inline void free_page(unsigned long addr)
 	(void) (&_min1 =3D=3D &_min2);		\
 	_min1 < _min2 ? _min1 : _min2; })
=20
-/* TODO: empty stubs for now. Broken but enough for virtio_ring.c */
-#define list_add_tail(a, b) do {} while (0)
-#define list_del(a) do {} while (0)
-#define list_for_each_entry(a, b, c) while (0)
-/* end of stubs */
-
 #endif /* KERNEL_H */
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index b751350d4ce8..5d90254ddae4 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -11,12 +11,11 @@ struct device {
 struct virtio_device {
 	struct device dev;
 	u64 features;
+	struct list_head vqs;
 };
=20
 struct virtqueue {
-	/* TODO: commented as list macros are empty stubs for now.
-	 * Broken but enough for virtio_ring.c
-	 * struct list_head list; */
+	struct list_head list;
 	void (*callback)(struct virtqueue *vq);
 	const char *name;
 	struct virtio_device *vdev;
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index dca64d36a882..c0b924b41a1d 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -129,6 +129,7 @@ static void vdev_info_init(struct vdev_info* dev, uns=
igned long long features)
 	int r;
 	memset(dev, 0, sizeof *dev);
 	dev->vdev.features =3D features;
+	INIT_LIST_HEAD(&dev->vdev.vqs);
 	dev->buf_size =3D 1024;
 	dev->buf =3D malloc(dev->buf_size);
 	assert(dev->buf);
diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index 8ee2c9a6ad46..b88b0337fcfd 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -307,6 +307,7 @@ static int parallel_test(u64 features,
 		close(to_host[0]);
=20
 		gvdev.vdev.features =3D features;
+		INIT_LIST_HEAD(&gvdev.vdev.vqs);
 		gvdev.to_host_fd =3D to_host[1];
 		gvdev.notifies =3D 0;
=20
@@ -453,6 +454,7 @@ int main(int argc, char *argv[])
=20
 	getrange =3D getrange_iov;
 	vdev.features =3D 0;
+	INIT_LIST_HEAD(&vdev.vqs);
=20
 	while (argv[1]) {
 		if (strcmp(argv[1], "--indirect") =3D=3D 0)
--=20
2.18.1

