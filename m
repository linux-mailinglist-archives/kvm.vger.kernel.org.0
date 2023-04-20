Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C7F6E93DE
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 14:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbjDTMLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 08:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbjDTMLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 08:11:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56F94C10
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 05:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681992649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vHb8qGSkfOOzR1UvPl9jTJBSrgP0gJxbai8FbuzD3Cc=;
        b=FJh5lnej7rzn5er/FTL/1xJsMwn4kWLv1vEvR0+jXM4QtFVDH3VXFH9hyvHZdZSeHhLf2P
        slDQ4tr5GRGv6PGMIw3OMvqpg8cTALDLqfk0pi5xRxTflE1Muv1M8h1uVCR8K06XOWIH50
        1FKJ+04Sj3Xv+T89eIzkcGWUBLr15Q8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-SM41RbkZMESFzP3lJGc7QQ-1; Thu, 20 Apr 2023 08:10:45 -0400
X-MC-Unique: SM41RbkZMESFzP3lJGc7QQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7489985A5A3;
        Thu, 20 Apr 2023 12:10:44 +0000 (UTC)
Received: from localhost (unknown [10.39.193.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3645492C3E;
        Thu, 20 Apr 2023 12:10:43 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Sam Li <faithilikerun@gmail.com>
Subject: [PULL 19/20] docs/zoned-storage:add zoned emulation use case
Date:   Thu, 20 Apr 2023 08:09:47 -0400
Message-Id: <20230420120948.436661-20-stefanha@redhat.com>
In-Reply-To: <20230420120948.436661-1-stefanha@redhat.com>
References: <20230420120948.436661-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sam Li <faithilikerun@gmail.com>

Add the documentation about the example of using virtio-blk driver
to pass the zoned block devices through to the guest.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Message-id: 20230407082528.18841-6-faithilikerun@gmail.com
[Fix Sphinx indentation error by turning command-lines into
pre-formatted text.
--Stefan]
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 docs/devel/zoned-storage.rst | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/docs/devel/zoned-storage.rst b/docs/devel/zoned-storage.rst
index 6a36133e51..e02500c8a3 100644
--- a/docs/devel/zoned-storage.rst
+++ b/docs/devel/zoned-storage.rst
@@ -38,6 +38,25 @@ When the BlockBackend's BlockLimits model reports a zoned storage device, users
 like the virtio-blk emulation or the qemu-io-cmds.c utility can use block layer
 APIs for zoned storage emulation or testing.
 
-For example, to test zone_report on a null_blk device using qemu-io is:
-$ path/to/qemu-io --image-opts -n driver=host_device,filename=/dev/nullb0
--c "zrp offset nr_zones"
+For example, to test zone_report on a null_blk device using qemu-io is::
+
+  $ path/to/qemu-io --image-opts -n driver=host_device,filename=/dev/nullb0 -c "zrp offset nr_zones"
+
+To expose the host's zoned block device through virtio-blk, the command line
+can be (includes the -device parameter)::
+
+  -blockdev node-name=drive0,driver=host_device,filename=/dev/nullb0,cache.direct=on \
+      -device virtio-blk-pci,drive=drive0
+
+Or only use the -drive parameter::
+
+  -driver driver=host_device,file=/dev/nullb0,if=virtio,cache.direct=on
+
+Additionally, QEMU has several ways of supporting zoned storage, including:
+(1) Using virtio-scsi: --device scsi-block allows for the passing through of
+SCSI ZBC devices, enabling the attachment of ZBC or ZAC HDDs to QEMU.
+(2) PCI device pass-through: While NVMe ZNS emulation is available for testing
+purposes, it cannot yet pass through a zoned device from the host. To pass on
+the NVMe ZNS device to the guest, use VFIO PCI pass the entire NVMe PCI adapter
+through to the guest. Likewise, an HDD HBA can be passed on to QEMU all HDDs
+attached to the HBA.
-- 
2.39.2

