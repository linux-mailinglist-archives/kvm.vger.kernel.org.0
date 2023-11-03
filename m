Return-Path: <kvm+bounces-516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6317E07D4
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:56:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97173B21563
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 17:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D52A6224D0;
	Fri,  3 Nov 2023 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZI6zIzb7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF17521102;
	Fri,  3 Nov 2023 17:55:57 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5416E1BD;
	Fri,  3 Nov 2023 10:55:56 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9c603e235d1so344346966b.3;
        Fri, 03 Nov 2023 10:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699034155; x=1699638955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hea/FOM7sQnJfBnxfbrgw+YUmgcHRKdwu0JrlIBvasA=;
        b=ZI6zIzb7oCZL7zq/Tnlpqh2aSgHgADTQ9MIvs5OJP5v/3o0HUHVHHu52PPY3I76lOr
         v1OA8Y9f+ELFFZrVQfZvD3i9lezN/dWpJQFzOhULDXc31wkONFcr/bABtAqFkbdQRSCx
         UT9emE2x4xmEl6PrtnkZScAs5MFkifT4cztI13y5UtMeMtu7VjdqsKZmgnKp4eS139lG
         ULFk3xoYk6dIR+shXsjnSU0vjwS2AQ4f+5IgSbG5j0AvfsdF1tQBN7J9aaTmQBJRq+gD
         1d0cBaLHUeh55pE3aljZ8d/yhWpAV1Yr+x5n+XgD/7DPgt9aK3IyzadTvu+Krb6m8yzs
         xVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699034155; x=1699638955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hea/FOM7sQnJfBnxfbrgw+YUmgcHRKdwu0JrlIBvasA=;
        b=orwtO+pKcxZSXGQWZqgvw24WbIqfaorhFRI7XfTQHEPnsrto8L3AnvGvktJLbGgIrA
         vYhS/FwwTOxVPsz8FH0IGFxBZWXPRnzEXdDgbY1m26OG/MZDjzrlOBv0SFE7v69ipcLD
         KgaP8o3Z9cCxuorgfTrz3+lx500ZkhqTD6sp6k4DJu2In0j4KlH2ZLbzTJA/j9Rkgmul
         VECnppmReTfmEbBfi5MPlhWTJ2o9w5L+dXufvwhvpyjSHIXZ3FKyn0txG4kNK1r81tIL
         A3IlZP2iA8iP2sBuf0qHyGg+W+GV8SaC3v1iNwQmVNOa2qz5h2yktSKtVbHUnuc9+l2L
         2kBA==
X-Gm-Message-State: AOJu0YxkeUIV9nGSO0d0C4IVLSgSyRpmG4DMx8JR1Ki5zdSSpTAJXbds
	Lk5dskg9mcvkyebW2Bf7o/c=
X-Google-Smtp-Source: AGHT+IEADU2nZsKc7kfsMDqJIYT+yDWS0IsOZHLiDICdhAGbne3xQZBqOzwweMUHvyoKBfTQ82wWPw==
X-Received: by 2002:a17:907:2cc3:b0:9bd:7f40:caa5 with SMTP id hg3-20020a1709072cc300b009bd7f40caa5mr6519534ejc.77.1699034154588;
        Fri, 03 Nov 2023 10:55:54 -0700 (PDT)
Received: from fedora.. (host-62-211-113-16.retail.telecomitalia.it. [62.211.113.16])
        by smtp.gmail.com with ESMTPSA id wj6-20020a170907050600b009ddf1a84379sm80306ejb.51.2023.11.03.10.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 10:55:54 -0700 (PDT)
From: f.storniolo95@gmail.com
To: luigi.leonardi@outlook.com,
	kvm@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	mst@redhat.com,
	imbrenda@linux.vnet.ibm.com,
	kuba@kernel.org,
	asias@redhat.com,
	stefanha@redhat.com,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Filippo Storniolo <f.storniolo95@gmail.com>,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: [PATCH net 1/4] vsock/virtio: remove socket from connected/bound list on shutdown
Date: Fri,  3 Nov 2023 18:55:48 +0100
Message-ID: <20231103175551.41025-2-f.storniolo95@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231103175551.41025-1-f.storniolo95@gmail.com>
References: <20231103175551.41025-1-f.storniolo95@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filippo Storniolo <f.storniolo95@gmail.com>

If the same remote peer, using the same port, tries to connect
to a server on a listening port more than once, the server will
reject the connection, causing a "connection reset by peer"
error on the remote peer. This is due to the presence of a
dangling socket from a previous connection in both the connected
and bound socket lists.
The inconsistency of the above lists only occurs when the remote
peer disconnects and the server remains active.

This bug does not occur when the server socket is closed:
virtio_transport_release() will eventually schedule a call to
virtio_transport_do_close() and the latter will remove the socket
from the bound and connected socket lists and clear the sk_buff.

However, virtio_transport_do_close() will only perform the above
actions if it has been scheduled, and this will not happen
if the server is processing the shutdown message from a remote peer.

To fix this, introduce a call to vsock_remove_sock()
when the server is handling a client disconnect.
This is to remove the socket from the bound and connected socket
lists without clearing the sk_buff.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Reported-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Tested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Filippo Storniolo <f.storniolo95@gmail.com>
---
 net/vmw_vsock/virtio_transport_common.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e22c81435ef7..4c595dd1fd64 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1369,11 +1369,17 @@ virtio_transport_recv_connected(struct sock *sk,
 			vsk->peer_shutdown |= RCV_SHUTDOWN;
 		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
 			vsk->peer_shutdown |= SEND_SHUTDOWN;
-		if (vsk->peer_shutdown == SHUTDOWN_MASK &&
-		    vsock_stream_has_data(vsk) <= 0 &&
-		    !sock_flag(sk, SOCK_DONE)) {
-			(void)virtio_transport_reset(vsk, NULL);
-			virtio_transport_do_close(vsk, true);
+		if (vsk->peer_shutdown == SHUTDOWN_MASK) {
+			if (vsock_stream_has_data(vsk) <= 0 && !sock_flag(sk, SOCK_DONE)) {
+				(void)virtio_transport_reset(vsk, NULL);
+				virtio_transport_do_close(vsk, true);
+			}
+			/* Remove this socket anyway because the remote peer sent
+			 * the shutdown. This way a new connection will succeed
+			 * if the remote peer uses the same source port,
+			 * even if the old socket is still unreleased, but now disconnected.
+			 */
+			vsock_remove_sock(vsk);
 		}
 		if (le32_to_cpu(virtio_vsock_hdr(skb)->flags))
 			sk->sk_state_change(sk);
-- 
2.41.0


