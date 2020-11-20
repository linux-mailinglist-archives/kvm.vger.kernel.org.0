Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CD52BB459
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbgKTSvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:51:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731980AbgKTSvi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:51:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VF68uyWFilZpHj5bABsThH0akvfjRoVBR9ksieJzwHo=;
        b=AaKAOrM3/iaSHqnaOU1KU0SrKPOCueZr/jrwytmWXXexRDqFDpXT6e6cCVMKgx92Jp4OkK
        JpSpY5eJ1T0jkULUERwbAlM7W30vj9NiMncv42CTW+1jBsriH+XfBCzD2NmyX2KEn6hUBJ
        u4fsjXNA593wo0h+qls6XsOrCVMghZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-5oC7RBGnOfe3nRKgW98M6A-1; Fri, 20 Nov 2020 13:51:33 -0500
X-MC-Unique: 5oC7RBGnOfe3nRKgW98M6A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2F0E1842159;
        Fri, 20 Nov 2020 18:51:30 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 440965C1D5;
        Fri, 20 Nov 2020 18:51:23 +0000 (UTC)
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
Subject: [RFC PATCH 01/27] vhost: Add vhost_dev_can_log
Date:   Fri, 20 Nov 2020 19:50:39 +0100
Message-Id: <20201120185105.279030-2-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just syntactic sugar.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 614ccc2bcb..2bd8cdf893 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -61,6 +61,11 @@ bool vhost_has_free_slot(void)
     return slots_limit > used_memslots;
 }
 
+static bool vhost_dev_can_log(const struct vhost_dev *hdev)
+{
+    return hdev->features & (0x1ULL << VHOST_F_LOG_ALL);
+}
+
 static void vhost_dev_sync_region(struct vhost_dev *dev,
                                   MemoryRegionSection *section,
                                   uint64_t mfirst, uint64_t mlast,
@@ -1347,7 +1352,7 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
     };
 
     if (hdev->migration_blocker == NULL) {
-        if (!(hdev->features & (0x1ULL << VHOST_F_LOG_ALL))) {
+        if (!vhost_dev_can_log(hdev)) {
             error_setg(&hdev->migration_blocker,
                        "Migration disabled: vhost lacks VHOST_F_LOG_ALL feature.");
         } else if (vhost_dev_log_is_shared(hdev) && !qemu_memfd_alloc_check()) {
-- 
2.18.4

