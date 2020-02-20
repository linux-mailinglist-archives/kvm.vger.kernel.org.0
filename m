Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F93165E36
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgBTNGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26620 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727285AbgBTNGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:06:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582204005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UKC5US0FVl1pIv+lPWy76t1kr1KKdCp1Se8AoBMs7qQ=;
        b=Ciev9NRZ14iDP9dkl3L/g/nmjOnPTyzO5Rmby1k+T8oz9Kvpqxl5v464/vlwKvQMIBGPU6
        qDWgo/4dKz/vt1pIbjE/dNZAfs27egjjrP80oQyu/ppz25e2/dpfjjyeW0389Bn3NRkeIK
        +NMiGOwRX93NKZ1CT3Edv1Fhh1jpabw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-ChMjaRT9MXyUUwWYOGi8Sg-1; Thu, 20 Feb 2020 08:06:44 -0500
X-MC-Unique: ChMjaRT9MXyUUwWYOGi8Sg-1
Received: by mail-wr1-f71.google.com with SMTP id s13so1701531wrb.21
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UKC5US0FVl1pIv+lPWy76t1kr1KKdCp1Se8AoBMs7qQ=;
        b=DbK2kSYm6avx7ULpN0hAOdGjgHyS6lcRH7777Zsrf/JU0gWPhbwOCoIeMcrSH+vND2
         sIpG56Hp7Iwz4a3DhTEaFe1A1SOJ7Uk/t9Nrn6IJPtca7RnYkpirl8ythe87dA7dzu0Y
         aqVi0AUEfbI2FoZggvdStPqXxJfpMPxICWGENO+hxclMli549NCPnTyooGUSSPdT9Pja
         urPI+G6GwqRKOADkksxxmVv7nX7yNXsPnjbSJllFVnswt8ZPpTOs3OfpxrFSPaTweggr
         r6lYOvbprf3Xhn5/FihpuvtRpXAv6wJC8tJVORt5wQxI8h9HeD/SNEp2Y6nn3OTUwIKn
         pT4w==
X-Gm-Message-State: APjAAAXuqYe+BNLVlaCLxXGUzFhYKInqwTI92tSY0dsuNJ52rlTLZ72t
        IMWVCp8CE6wyZzCs/YMpDsCj8wTYvhd9ol6puipMItes4yg1ue3wLNitEIbMwN6kJNhnQCUL+kF
        fV9F/pe656MXb
X-Received: by 2002:a5d:4c84:: with SMTP id z4mr43731108wrs.423.1582204002760;
        Thu, 20 Feb 2020 05:06:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwqHc8xSBLutdUhIzf/cdvh5+i6wOt8LjaLS6C9c63Yasey84Mhi4F8A6DvfBLGaafXEkCiSQ==
X-Received: by 2002:a5d:4c84:: with SMTP id z4mr43731080wrs.423.1582204002528;
        Thu, 20 Feb 2020 05:06:42 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:41 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH v3 13/20] hw/virtio: Let virtqueue_map_iovec() use a boolean 'is_write' argument
Date:   Thu, 20 Feb 2020 14:05:41 +0100
Message-Id: <20200220130548.29974-14-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200220130548.29974-1-philmd@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'is_write' argument is either 0 or 1.
Convert it to a boolean type.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/virtio/virtio.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 2c5410e981..9d06dbe3ef 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1293,7 +1293,7 @@ static void virtqueue_undo_map_desc(unsigned int out_num, unsigned int in_num,
 
 static void virtqueue_map_iovec(VirtIODevice *vdev, struct iovec *sg,
                                 hwaddr *addr, unsigned int num_sg,
-                                int is_write)
+                                bool is_write)
 {
     unsigned int i;
     hwaddr len;
@@ -1317,8 +1317,9 @@ static void virtqueue_map_iovec(VirtIODevice *vdev, struct iovec *sg,
 
 void virtqueue_map(VirtIODevice *vdev, VirtQueueElement *elem)
 {
-    virtqueue_map_iovec(vdev, elem->in_sg, elem->in_addr, elem->in_num, 1);
-    virtqueue_map_iovec(vdev, elem->out_sg, elem->out_addr, elem->out_num, 0);
+    virtqueue_map_iovec(vdev, elem->in_sg, elem->in_addr, elem->in_num, true);
+    virtqueue_map_iovec(vdev, elem->out_sg, elem->out_addr, elem->out_num,
+                                                                        false);
 }
 
 static void *virtqueue_alloc_element(size_t sz, unsigned out_num, unsigned in_num)
-- 
2.21.1

