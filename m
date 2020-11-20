Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167AC2BB4A0
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732142AbgKTSzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:55:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729254AbgKTSzU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:55:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2NtO6niIGV95EKH2ITwzudVB3tBfrLrd6tahFyFqPtU=;
        b=GnZ2byei8yZGFTNDfXV8zKrshp2qWCOuoIHek9UKcD8+xxSaEZqfz6eEjSIjzxvm06TIAg
        pV1nuAANZuCkVfKok68AgA8VIjnj6VnBN9CooiqqV5ZzPrwSRZDwfNOPK7nWwXWpcSF/sJ
        io5CXLrHNVaGpv8izTMJ2XZpn9nZY64=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-zR19Dr3RMGSdd3PWouysKg-1; Fri, 20 Nov 2020 13:55:14 -0500
X-MC-Unique: zR19Dr3RMGSdd3PWouysKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE8D25B375;
        Fri, 20 Nov 2020 18:55:11 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0B3E5C1D5;
        Fri, 20 Nov 2020 18:54:58 +0000 (UTC)
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
Subject: [RFC PATCH 16/27] virtio: Expose virtqueue_alloc_element
Date:   Fri, 20 Nov 2020 19:50:54 +0100
Message-Id: <20201120185105.279030-17-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Specify VirtQueueElement * as return type makes no harm at this moment.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 include/hw/virtio/virtio.h | 2 ++
 hw/virtio/virtio.c         | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 79212141a6..ee8fe96f32 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -196,6 +196,8 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueElement *elem,
                     unsigned int len, unsigned int idx);
 
 void virtqueue_map(VirtIODevice *vdev, VirtQueueElement *elem);
+VirtQueueElement *virtqueue_alloc_element(size_t sz, unsigned out_num,
+                                          unsigned in_num);
 void *virtqueue_pop(VirtQueue *vq, size_t sz);
 unsigned int virtqueue_drop_all(VirtQueue *vq);
 void *qemu_get_virtqueue_element(VirtIODevice *vdev, QEMUFile *f, size_t sz);
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index ad9dc5dfa7..a89525f067 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1400,7 +1400,8 @@ void virtqueue_map(VirtIODevice *vdev, VirtQueueElement *elem)
                                                                         false);
 }
 
-static void *virtqueue_alloc_element(size_t sz, unsigned out_num, unsigned in_num)
+VirtQueueElement *virtqueue_alloc_element(size_t sz, unsigned out_num,
+                                          unsigned in_num)
 {
     VirtQueueElement *elem;
     size_t in_addr_ofs = QEMU_ALIGN_UP(sz, __alignof__(elem->in_addr[0]));
-- 
2.18.4

