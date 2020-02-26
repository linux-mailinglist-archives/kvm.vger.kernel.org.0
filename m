Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8294416FCC9
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 11:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgBZK60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 05:58:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21107 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727785AbgBZK6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 05:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582714703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ao4shkARYBOlBvwWDPYByOMa60o0c7ck0bB41Z0If+w=;
        b=RHotRtlz2HwjcRYuV3KsYRtyzp2Tm3L7DJxRx+CnmYtI1CnR6wlF/ZOp+bGVXtNy5EmfcA
        yQOHo+OD9/HnYdmVt3WABoeVCERCnqbMWD40XCgn7ef72byiRqaUDZECNXk/pXtA45lDk0
        rJyUeKd9eey5XZV9TAg8f4Qx1fubnhM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-WckLKU3WMMmV_tbPePJ6jA-1; Wed, 26 Feb 2020 05:58:22 -0500
X-MC-Unique: WckLKU3WMMmV_tbPePJ6jA-1
Received: by mail-wm1-f71.google.com with SMTP id m4so758413wmi.5
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 02:58:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ao4shkARYBOlBvwWDPYByOMa60o0c7ck0bB41Z0If+w=;
        b=sdhvuj6+f0ZYWGokOKH1cbybi9bOs8uQd70k0L5PX2F6RKDU+8GXaDKYICGA7sAZ2c
         9UOFgAr03AZi+HuxyQzJMouH5kLiHT6dttDRPkTYX/wj1HvwkGabYb39ObzqdsyGpflP
         SWXQddqVXNo2x2g1YcYvnfjtwopdFaQmai61POON1fGtm7+D0lVahAvzp6zcf6ojhAhq
         N/r/93a+2sIXiVlgGvnC0heg0NYcCk9nDFE6Qyrw5Sg/Cz9NinZKFPMu1v7gUBKYFxZP
         DbKO5p7IwmKDVek69ZHuSGx8WCflk9v4QHL8Ltno45QPbJ8CI2S5B8rs6UBXBb4ZLdtg
         EgUg==
X-Gm-Message-State: APjAAAXCIsfV5QF1a0goiPDF3jiZd1kQxSIeb4zx+130+A/Qe6vVDXVG
        zxcPmBOF91P6+h813MFUuSSF8WyOH0Ye6UcJHyJMFwoWnzoEfaEHbK8ZY7sllPU3hbtC5gsK6tg
        8zFcuq8snY5LL
X-Received: by 2002:a5d:526c:: with SMTP id l12mr5137375wrc.117.1582714700516;
        Wed, 26 Feb 2020 02:58:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqyh+hNuja55nNfaQjP9nDbwKYYMHtCqsv8lSLIfOPeY/HkJFiCny/r2KQbRfkc32TKRz7Lunw==
X-Received: by 2002:a5d:526c:: with SMTP id l12mr5137321wrc.117.1582714700113;
        Wed, 26 Feb 2020 02:58:20 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id l132sm2619123wmf.16.2020.02.26.02.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 02:58:19 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Dexuan Cui <decui@microsoft.com>, Hillf Danton <hdanton@sina.com>,
        virtualization@lists.linux-foundation.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, kvm@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [PATCH net] vsock: fix potential deadlock in transport->release()
Date:   Wed, 26 Feb 2020 11:58:18 +0100
Message-Id: <20200226105818.36055-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some transports (hyperv, virtio) acquire the sock lock during the
.release() callback.

In the vsock_stream_connect() we call vsock_assign_transport(); if
the socket was previously assigned to another transport, the
vsk->transport->release() is called, but the sock lock is already
held in the vsock_stream_connect(), causing a deadlock reported by
syzbot:

    INFO: task syz-executor280:9768 blocked for more than 143 seconds.
      Not tainted 5.6.0-rc1-syzkaller #0
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    syz-executor280 D27912  9768   9766 0x00000000
    Call Trace:
     context_switch kernel/sched/core.c:3386 [inline]
     __schedule+0x934/0x1f90 kernel/sched/core.c:4082
     schedule+0xdc/0x2b0 kernel/sched/core.c:4156
     __lock_sock+0x165/0x290 net/core/sock.c:2413
     lock_sock_nested+0xfe/0x120 net/core/sock.c:2938
     virtio_transport_release+0xc4/0xd60 net/vmw_vsock/virtio_transport_common.c:832
     vsock_assign_transport+0xf3/0x3b0 net/vmw_vsock/af_vsock.c:454
     vsock_stream_connect+0x2b3/0xc70 net/vmw_vsock/af_vsock.c:1288
     __sys_connect_file+0x161/0x1c0 net/socket.c:1857
     __sys_connect+0x174/0x1b0 net/socket.c:1874
     __do_sys_connect net/socket.c:1885 [inline]
     __se_sys_connect net/socket.c:1882 [inline]
     __x64_sys_connect+0x73/0xb0 net/socket.c:1882
     do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
     entry_SYSCALL_64_after_hwframe+0x49/0xbe

To avoid this issue, this patch remove the lock acquiring in the
.release() callback of hyperv and virtio transports, and it holds
the lock when we call vsk->transport->release() in the vsock core.

Reported-by: syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com
Fixes: 408624af4c89 ("vsock: use local transport when it is loaded")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c                | 20 ++++++++++++--------
 net/vmw_vsock/hyperv_transport.c        |  3 ---
 net/vmw_vsock/virtio_transport_common.c |  2 --
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9c5b2a91baad..a5f28708e0e7 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -451,6 +451,12 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		if (vsk->transport == new_transport)
 			return 0;
 
+		/* transport->release() must be called with sock lock acquired.
+		 * This path can only be taken during vsock_stream_connect(),
+		 * where we have already held the sock lock.
+		 * In the other cases, this function is called on a new socket
+		 * which is not assigned to any transport.
+		 */
 		vsk->transport->release(vsk);
 		vsock_deassign_transport(vsk);
 	}
@@ -753,20 +759,18 @@ static void __vsock_release(struct sock *sk, int level)
 		vsk = vsock_sk(sk);
 		pending = NULL;	/* Compiler warning. */
 
-		/* The release call is supposed to use lock_sock_nested()
-		 * rather than lock_sock(), if a sock lock should be acquired.
-		 */
-		if (vsk->transport)
-			vsk->transport->release(vsk);
-		else if (sk->sk_type == SOCK_STREAM)
-			vsock_remove_sock(vsk);
-
 		/* When "level" is SINGLE_DEPTH_NESTING, use the nested
 		 * version to avoid the warning "possible recursive locking
 		 * detected". When "level" is 0, lock_sock_nested(sk, level)
 		 * is the same as lock_sock(sk).
 		 */
 		lock_sock_nested(sk, level);
+
+		if (vsk->transport)
+			vsk->transport->release(vsk);
+		else if (sk->sk_type == SOCK_STREAM)
+			vsock_remove_sock(vsk);
+
 		sock_orphan(sk);
 		sk->sk_shutdown = SHUTDOWN_MASK;
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 3492c021925f..630b851f8150 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -526,12 +526,9 @@ static bool hvs_close_lock_held(struct vsock_sock *vsk)
 
 static void hvs_release(struct vsock_sock *vsk)
 {
-	struct sock *sk = sk_vsock(vsk);
 	bool remove_sock;
 
-	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	remove_sock = hvs_close_lock_held(vsk);
-	release_sock(sk);
 	if (remove_sock)
 		vsock_remove_sock(vsk);
 }
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index d9f0c9c5425a..f3c4bab2f737 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -829,7 +829,6 @@ void virtio_transport_release(struct vsock_sock *vsk)
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
-	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	if (sk->sk_type == SOCK_STREAM)
 		remove_sock = virtio_transport_close(vsk);
 
@@ -837,7 +836,6 @@ void virtio_transport_release(struct vsock_sock *vsk)
 		list_del(&pkt->list);
 		virtio_transport_free_pkt(pkt);
 	}
-	release_sock(sk);
 
 	if (remove_sock)
 		vsock_remove_sock(vsk);
-- 
2.24.1

