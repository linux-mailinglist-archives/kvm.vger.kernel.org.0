Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2582BB490
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbgKTSyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:54:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731664AbgKTSyB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:54:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYiokrtmxVGaxHYQFYtHrYcyj4QArcgChV2OGqAzahY=;
        b=Hc3ctVPSgydSURZY66CjMLPs0tM+la9i9XB0tRnsg+tZd0LGxS2DJ8bseaWfMCGmMtbasA
        qqB2jXefNJIIAJwlkoW1TWAn2VA22dpwYOPmnAiye3z+wB+0xhoitpJqj5fYywyeQrE2Ml
        HMSpUrJX2XCxIvKkraO3+Go1ub0Xsrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-Q2QN0RgLOE-Z4tC5OIvHtg-1; Fri, 20 Nov 2020 13:53:58 -0500
X-MC-Unique: Q2QN0RgLOE-Z4tC5OIvHtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4232100C605;
        Fri, 20 Nov 2020 18:53:54 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 721AB5C1D5;
        Fri, 20 Nov 2020 18:53:36 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: [RFC PATCH 11/27] virtio: const-ify all virtio_tswap* functions
Date:   Fri, 20 Nov 2020 19:50:49 +0100
Message-Id: <20201120185105.279030-12-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

They do not modify vdev, so these should be const as qemu coding style
guideline.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 include/hw/virtio/virtio-access.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/hw/virtio/virtio-access.h b/include/hw/virtio/virtio-access.h
index 6818a23a2d..7474f89b5f 100644
--- a/include/hw/virtio/virtio-access.h
+++ b/include/hw/virtio/virtio-access.h
@@ -24,7 +24,7 @@
 #define LEGACY_VIRTIO_IS_BIENDIAN 1
 #endif
 
-static inline bool virtio_access_is_big_endian(VirtIODevice *vdev)
+static inline bool virtio_access_is_big_endian(const VirtIODevice *vdev)
 {
 #if defined(LEGACY_VIRTIO_IS_BIENDIAN)
     return virtio_is_big_endian(vdev);
@@ -147,7 +147,7 @@ static inline uint64_t virtio_ldq_p(VirtIODevice *vdev, const void *ptr)
     }
 }
 
-static inline uint16_t virtio_tswap16(VirtIODevice *vdev, uint16_t s)
+static inline uint16_t virtio_tswap16(const VirtIODevice *vdev, uint16_t s)
 {
 #ifdef HOST_WORDS_BIGENDIAN
     return virtio_access_is_big_endian(vdev) ? s : bswap16(s);
@@ -213,7 +213,7 @@ static inline void virtio_tswap16s(VirtIODevice *vdev, uint16_t *s)
     *s = virtio_tswap16(vdev, *s);
 }
 
-static inline uint32_t virtio_tswap32(VirtIODevice *vdev, uint32_t s)
+static inline uint32_t virtio_tswap32(const VirtIODevice *vdev, uint32_t s)
 {
 #ifdef HOST_WORDS_BIGENDIAN
     return virtio_access_is_big_endian(vdev) ? s : bswap32(s);
@@ -227,7 +227,7 @@ static inline void virtio_tswap32s(VirtIODevice *vdev, uint32_t *s)
     *s = virtio_tswap32(vdev, *s);
 }
 
-static inline uint64_t virtio_tswap64(VirtIODevice *vdev, uint64_t s)
+static inline uint64_t virtio_tswap64(const VirtIODevice *vdev, uint64_t s)
 {
 #ifdef HOST_WORDS_BIGENDIAN
     return virtio_access_is_big_endian(vdev) ? s : bswap64(s);
-- 
2.18.4

