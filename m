Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AA0A62C6
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 09:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbfICHiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 03:38:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfICHiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 03:38:22 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAD4285362
        for <kvm@vger.kernel.org>; Tue,  3 Sep 2019 07:38:21 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id n135so18069057qke.23
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 00:38:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=a2jRYEYJXw6y2ArAic1WZqLdnynYivPxAhcNn14RG7c=;
        b=T2X0G2SvhVM7zRv1rgqMazsOGRiOL+z4nAqomaX/ce2DvQxEp/uhkNcdEerWx0zCn4
         F4MILgitg6E7L+ijgsR3AJYvPXbuVU1JmbE7Y6kPyq/SXe42cksRwBuiqhDe+GarRTUW
         +8MjKjlekusYhw2tdAokPCCT7U4gj1sdeRRROi/SZ5pZFo8fJ+zaVSR+/p8t8S7d5v+W
         FGSU6ImgvyZo9xdA2rAbrOnRKckTtqjZW8QIZ2jKzDI9bBCEli9/5htqyq+Xah1zaHHz
         48MU7T3cZOQbe+J1ruZ/HT9X77Ca6BtVSMQ5N+KTsUwqWncSHOAWpLARS7KmNb0aI1vc
         lKWQ==
X-Gm-Message-State: APjAAAXqQWLMjssXSFY8eysX/+pnp9dyZdJq3+ib3qvqPzcjMAVkfOZs
        DB2PpTF4LWBj+aj2ne5/OqT5UT1CpQvcQ59Cm+L0yfxEKTi0X32tLyru1FsdWfj8jsIM48Ynjns
        oexpRIPCbTuZj
X-Received: by 2002:a37:916:: with SMTP id 22mr14382510qkj.45.1567496301060;
        Tue, 03 Sep 2019 00:38:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxEnVPgjH8NbtZ+KbyL7PJmWdEblMSRWxEsCgtDKuaFkqs5CZdV4JoHPHabqe6W7wY2j8VAvw==
X-Received: by 2002:a37:916:: with SMTP id 22mr14382497qkj.45.1567496300910;
        Tue, 03 Sep 2019 00:38:20 -0700 (PDT)
Received: from redhat.com (bzq-79-180-62-110.red.bezeqint.net. [79.180.62.110])
        by smtp.gmail.com with ESMTPSA id 1sm8725515qko.73.2019.09.03.00.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 00:38:19 -0700 (PDT)
Date:   Tue, 3 Sep 2019 03:38:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH net-next] vsock/virtio: a better comment on credit update
Message-ID: <20190903073748.25214-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The comment we have is just repeating what the code does.
Include the *reason* for the condition instead.

Cc: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 94cc0fa3e848..5bb70c692b1e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -307,8 +307,13 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 
 	spin_unlock_bh(&vvs->rx_lock);
 
-	/* We send a credit update only when the space available seen
-	 * by the transmitter is less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE
+	/* To reduce the number of credit update messages,
+	 * don't update credits as long as lots of space is available.
+	 * Note: the limit chosen here is arbitrary. Setting the limit
+	 * too high causes extra messages. Too low causes transmitter
+	 * stalls. As stalls are in theory more expensive than extra
+	 * messages, we set the limit to a high value. TODO: experiment
+	 * with different values.
 	 */
 	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
 		virtio_transport_send_credit_update(vsk,
-- 
MST
