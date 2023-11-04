Return-Path: <kvm+bounces-586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7894C7E1003
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 16:05:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9DACB20E9E
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 15:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9B21A5B3;
	Sat,  4 Nov 2023 15:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LzRdBNgd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845AA7497
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 15:05:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547CE1BC
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 08:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699110341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i9z4ksAJKoBaMot+I42cegftv20OKEb1WSe8JorPWis=;
	b=LzRdBNgdwHzFiu4aFvzRj+HyKpTMQLvsPl8BrnxdzHAdLaI7D8LoGQ26oU3wDpQ2FLVRs/
	3QNAOj+8xB9ZrHCejqOrL+OXgZng7oeykNSXOVKMVQS9q9E9HZ7uOFrQSQ15m4VSB2NShV
	BHOxCqYZbuLJxGnWTfcZvCNbFmzxs0k=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-Ty5XoRliPRSPOI-tERZbrA-1; Sat, 04 Nov 2023 11:05:40 -0400
X-MC-Unique: Ty5XoRliPRSPOI-tERZbrA-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-573fdb618eeso2337705a12.0
        for <kvm@vger.kernel.org>; Sat, 04 Nov 2023 08:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699110339; x=1699715139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i9z4ksAJKoBaMot+I42cegftv20OKEb1WSe8JorPWis=;
        b=n6ZSNUC1wlXxlxFgIuBxNCrynPHF9YS+I5vlFBnBbrfOyXorJ74Y7YR/V38q5jMITS
         y8Wnldjme83ekVOeBqZOzKSwRmoZcg47RuHgYe0Lhvry4EfL0f5v/rkrwIBQoY71IRVP
         O3yRrKWgjQJ5xG8vsAttjM0rnfEfTjoWOJLpTusogM6saqQ9/ev1z3q/rBPho0wBy6ky
         l8dyAKNIB9R9/PCawdPLCh/mkt2Wi5woOIKi5PzeEr07iGtvQ7+R7d+i+P3ICUXc0i9a
         WoEYeKpzPXOhwZSKmOIAwlMPhdxe8e1uOXKpSmoaJVHhKNTbbidnBYOtnP81ROSZr8Km
         iIog==
X-Gm-Message-State: AOJu0YyALBGOiOfl8zGwB8ZlHchqSBNrFbgoEvHUS9DE010P1WFkXR1O
	huCiIxjkLssBHj6qQlInnopBOhaXGp4AJoKf+ueWhqQEdPQf7uUmFZQlmGffXR/tD1T9x8pDflW
	/qPXKHXbkCCYr
X-Received: by 2002:a17:902:e811:b0:1cc:569b:1df4 with SMTP id u17-20020a170902e81100b001cc569b1df4mr20338648plg.1.1699110338879;
        Sat, 04 Nov 2023 08:05:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVdmZGqn+TlZ02ZFL16cTMGSicZ9LUGUPBMgKZ/dntpJav50rMK+vkrfXHS8Z6F1PWTban/w==
X-Received: by 2002:a17:902:e811:b0:1cc:569b:1df4 with SMTP id u17-20020a170902e81100b001cc569b1df4mr20338619plg.1.1699110338500;
        Sat, 04 Nov 2023 08:05:38 -0700 (PDT)
Received: from kernel-devel.local ([240d:1a:c0d:9f00:245e:16ff:fe87:c960])
        by smtp.gmail.com with ESMTPSA id jf7-20020a170903268700b001ca21c8abf7sm3101797plb.188.2023.11.04.08.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Nov 2023 08:05:38 -0700 (PDT)
From: Shigeru Yoshida <syoshida@redhat.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shigeru Yoshida <syoshida@redhat.com>,
	syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com
Subject: [PATCH net v2] virtio/vsock: Fix uninit-value in virtio_transport_recv_pkt()
Date: Sun,  5 Nov 2023 00:05:31 +0900
Message-ID: <20231104150531.257952-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KMSAN reported the following uninit-value access issue:

=====================================================
BUG: KMSAN: uninit-value in virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
 virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
 vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
 worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
 kthread+0x3cc/0x520 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

Uninit was stored to memory at:
 virtio_transport_space_update net/vmw_vsock/virtio_transport_common.c:1274 [inline]
 virtio_transport_recv_pkt+0x1ee8/0x26a0 net/vmw_vsock/virtio_transport_common.c:1415
 vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
 worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
 kthread+0x3cc/0x520 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

Uninit was created at:
 slab_post_alloc_hook+0x105/0xad0 mm/slab.h:767
 slab_alloc_node mm/slub.c:3478 [inline]
 kmem_cache_alloc_node+0x5a2/0xaf0 mm/slub.c:3523
 kmalloc_reserve+0x13c/0x4a0 net/core/skbuff.c:559
 __alloc_skb+0x2fd/0x770 net/core/skbuff.c:650
 alloc_skb include/linux/skbuff.h:1286 [inline]
 virtio_vsock_alloc_skb include/linux/virtio_vsock.h:66 [inline]
 virtio_transport_alloc_skb+0x90/0x11e0 net/vmw_vsock/virtio_transport_common.c:58
 virtio_transport_reset_no_sock net/vmw_vsock/virtio_transport_common.c:957 [inline]
 virtio_transport_recv_pkt+0x1279/0x26a0 net/vmw_vsock/virtio_transport_common.c:1387
 vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
 worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
 kthread+0x3cc/0x520 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

CPU: 1 PID: 10664 Comm: kworker/1:5 Not tainted 6.6.0-rc3-00146-g9f3ebbef746f #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc38 04/01/2014
Workqueue: vsock-loopback vsock_loopback_work
=====================================================

The following simple reproducer can cause the issue described above:

int main(void)
{
  int sock;
  struct sockaddr_vm addr = {
    .svm_family = AF_VSOCK,
    .svm_cid = VMADDR_CID_ANY,
    .svm_port = 1234,
  };

  sock = socket(AF_VSOCK, SOCK_STREAM, 0);
  connect(sock, (struct sockaddr *)&addr, sizeof(addr));
  return 0;
}

This issue occurs because the `buf_alloc` and `fwd_cnt` fields of the
`struct virtio_vsock_hdr` are not initialized when a new skb is allocated
in `virtio_transport_init_hdr()`. This patch resolves the issue by
initializing these fields during allocation.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Reported-and-tested-by: syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c8ce1da0ac31abbadcd
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
v1->v2:
- Rebase on the latest net tree
https://lore.kernel.org/all/20231026150154.3536433-1-syoshida@redhat.com/
---
 net/vmw_vsock/virtio_transport_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e22c81435ef7..dc65dd4d26df 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -130,6 +130,8 @@ static void virtio_transport_init_hdr(struct sk_buff *skb,
 	hdr->dst_port	= cpu_to_le32(dst_port);
 	hdr->flags	= cpu_to_le32(info->flags);
 	hdr->len	= cpu_to_le32(payload_len);
+	hdr->buf_alloc	= cpu_to_le32(0);
+	hdr->fwd_cnt	= cpu_to_le32(0);
 }
 
 static void virtio_transport_copy_nonlinear_skb(const struct sk_buff *skb,
-- 
2.41.0


