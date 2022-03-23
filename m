Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EFB4E4EA7
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242957AbiCWIvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242925AbiCWIvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:51:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34B49710EE
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648025409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2tskzl0i4fBaGQ2SA9UFWp+uERMa68xRFlfoMwtqOtQ=;
        b=Zbp8kpDdjaNxqZi1Ay1Lkf9KDWQ2lHvcHPcpS6GqhaIlZEwXtjSZ+4NU3fhEq4MGkRi8m9
        raZeFLG4GnImxL1ncqr3LgMkHSL1ilLtdx1laXTVql2mpLrZcgCIIYnGq1hhy8NSmwMTrT
        SCNWj8pMFLt0PdaSsh9tv8mKCd16oTE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-MkfE6rOANYW04Pw-BXuWGA-1; Wed, 23 Mar 2022 04:50:08 -0400
X-MC-Unique: MkfE6rOANYW04Pw-BXuWGA-1
Received: by mail-qk1-f200.google.com with SMTP id b133-20020a37678b000000b0067d24942b91so553662qkc.12
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:50:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2tskzl0i4fBaGQ2SA9UFWp+uERMa68xRFlfoMwtqOtQ=;
        b=l8xdba2HWXeehXDsSwB1DZBbNadrtmXurpHShe3CUU5Fgab/AdGsmbuO3aeuEni4nR
         NY7J7CTuLE3Qn6o3LjTd2Y0fAmF4SGMg6DhYaIgyUFrU9yMUvUli4GND9I8HCk8hcn/a
         9+b12JfIjjlEflG3Zj5jFobtpYLfDVocTIEa51AhGiMfz8YGPdwyY4Zm9RrmKw6rxXLw
         hxIei4YAmdqkUiTiOIYeyCcU2oS8njKLi/uRjfAX5b9nI8zO2lSdZ4hIDDLMxOAzj143
         phU5fWee7NHOfJluk3mCGzVmN5IHM3Wy/2B7mRHZ7wK5MvB7GWLOKa9WNS1/wrTRkmqa
         +C0g==
X-Gm-Message-State: AOAM530pECgSwsSuCG9+/M9EoKz2rhNlb1MHqTZ7Qf0StEuiv1AyRu3K
        B0bEwL9qJiDuUVweH8xa5oWLCcbqbMxPkwhr4Giea/KhXjW8FRYfzhyQKrdSTIADoZdPICmldAQ
        DT935b3YLWgoP
X-Received: by 2002:a05:620a:24cd:b0:67d:5f50:ef41 with SMTP id m13-20020a05620a24cd00b0067d5f50ef41mr18012806qkn.568.1648025407750;
        Wed, 23 Mar 2022 01:50:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwKKClidIuo6B0OT0d5+9jRGkHIXrwcI73KaPwBD6CWDKidHKCMTHM2A18yH6e8LMQdxDzAg==
X-Received: by 2002:a05:620a:24cd:b0:67d:5f50:ef41 with SMTP id m13-20020a05620a24cd00b0067d5f50ef41mr18012795qkn.568.1648025407541;
        Wed, 23 Mar 2022 01:50:07 -0700 (PDT)
Received: from step1.redhat.com (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id j188-20020a3755c5000000b0067d1c76a09fsm10640609qkb.74.2022.03.23.01.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 01:50:06 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 2/3] vsock/virtio: initialize vdev->priv before using VQs
Date:   Wed, 23 Mar 2022 09:49:53 +0100
Message-Id: <20220323084954.11769-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323084954.11769-1-sgarzare@redhat.com>
References: <20220323084954.11769-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we fill VQs with empty buffers and kick the host, it may send
an interrupt. `vdev->priv` must be initialized before this since it
is used in the virtqueue callback.

Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index b1962f8cd502..fff67ad39087 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -622,6 +622,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 
+	vdev->priv = vsock;
 	virtio_device_ready(vdev);
 
 	mutex_lock(&vsock->tx_lock);
@@ -641,7 +642,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
 		vsock->seqpacket_allow = true;
 
-	vdev->priv = vsock;
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.35.1

