Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106D94E4E91
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242927AbiCWIvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242907AbiCWIvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:51:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DED4073072
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648025405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VkoZGCDazaob935cf0K6/xqwp1grV8y7vA1EUagsdw8=;
        b=E2BLsoaRp7bqL5g54mC9rJgYyG8Oreov6JgY9i+5FDTRrV+kHKiIcDKJ8ZJyPagL61l0D1
        1xArt7LRazHcNe9GEXeMdblW98ye7B4P08ek/rNVNy0WmeShhXdbC573wSRc6MGJrPvdCE
        +9+j9S6w/mWpmmOn7rFPIum5tl+4ZYE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-Ar_OCb_XM3exiIlU4yy1JA-1; Wed, 23 Mar 2022 04:50:05 -0400
X-MC-Unique: Ar_OCb_XM3exiIlU4yy1JA-1
Received: by mail-qk1-f200.google.com with SMTP id q5-20020a05620a0d8500b004738c1b48beso561330qkl.7
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VkoZGCDazaob935cf0K6/xqwp1grV8y7vA1EUagsdw8=;
        b=52tIPf2fTHpWU5y59CQewrBvXaiKDF0S5hGJjx9JTSsTR4C84B48b5NZ5BN/y0g4jS
         k4nuxmif3Nr4hdie2z6xkVZUwt9pJGIGFpQwBosCcx89Ix0wBY+gZe1KW9iWJOdnKsZG
         KNyyv7i4b+OU7eSAySE/2t3/TXJ055qsPhqgMeXN6x15rlnhTgzmUioYvjcb7SOYaWN3
         0gQWwC28S/4zRxrYIFI0WTVqIoZMZfavE7KIAmkAA/1mT4vBszP0r7aNOmR2VhizWDfr
         /RNUr7SlU5uCorkqpeAGBt9Dr2HWLP13LugeEKcLGHMmgcMRr92yL4r2qHlW/6F4o4ZH
         JSvQ==
X-Gm-Message-State: AOAM532zCv9xXdJybQq/AZKMDhH5u77hM7qBJg2LXm7jGB4kUQdqdOVW
        HMU4ZlHGPL/5mmX3uBpCQ+0D0o+AhWdmU//Z7+jr/nxtqAA/acFs8HME9DnzHIHp7/EyXQ/OPz5
        Jq0yF2HpCMA/+
X-Received: by 2002:a05:620a:1a92:b0:67d:b2c2:8311 with SMTP id bl18-20020a05620a1a9200b0067db2c28311mr17908326qkb.594.1648025404183;
        Wed, 23 Mar 2022 01:50:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylURIbsHFC5CVM0PxCcg9Ie4RCz+seln0B3QhsU0NKbzEwgOSb1+E5im+z84ivzzgUFUDiHg==
X-Received: by 2002:a05:620a:1a92:b0:67d:b2c2:8311 with SMTP id bl18-20020a05620a1a9200b0067db2c28311mr17908319qkb.594.1648025404003;
        Wed, 23 Mar 2022 01:50:04 -0700 (PDT)
Received: from step1.redhat.com (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id j188-20020a3755c5000000b0067d1c76a09fsm10640609qkb.74.2022.03.23.01.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 01:50:03 -0700 (PDT)
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
Subject: [PATCH net v2 1/3] vsock/virtio: enable VQs early on probe
Date:   Wed, 23 Mar 2022 09:49:52 +0100
Message-Id: <20220323084954.11769-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323084954.11769-1-sgarzare@redhat.com>
References: <20220323084954.11769-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

virtio spec requires drivers to set DRIVER_OK before using VQs.
This is set automatically after probe returns, but virtio-vsock
driver uses VQs in the probe function to fill rx and event VQs
with new buffers.

Let's fix this, calling virtio_device_ready() before using VQs
in the probe function.

Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 5afc194a58bb..b1962f8cd502 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -622,6 +622,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 
+	virtio_device_ready(vdev);
+
 	mutex_lock(&vsock->tx_lock);
 	vsock->tx_run = true;
 	mutex_unlock(&vsock->tx_lock);
-- 
2.35.1

