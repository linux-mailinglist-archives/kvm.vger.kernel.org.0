Return-Path: <kvm+bounces-64937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C123C92260
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 14:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 16537344AF5
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 13:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E80032E686;
	Fri, 28 Nov 2025 13:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="JIj+ErPv"
X-Original-To: kvm@vger.kernel.org
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E433054D4;
	Fri, 28 Nov 2025 13:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764336971; cv=none; b=jPvmr7yEK03XvCyP11NUelI8WLS/yIGrfFyOX03Wi8Axltns4Iv4cYU8MqjIgVtI4SWaAguui8N7RCjK3TSU1/x8yCSvVBDCWi1giM1hI8zmSZCia59Ar+LigEvav/goKcXW7pcA5ljQNgdCh8BroplQuQxUfZ2Pnl25QoC8btg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764336971; c=relaxed/simple;
	bh=0wdbCIc855L4BW9vPRiQBOWRg5Gv82OzeG1iDyCsJzY=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=qOAAk1xW42k7NMKw5sWhzniLwqrXBgpmkGy6csHgw5tB4/L6ARydTp+Gb/josKEfRcR9GeM3yn4iIIN6OP0f3Q4r/cL3YHCp4zt5YmRma8Qu3EQ4r7ypedjy7w0Le4Oz4YOgDFMN/LWQ758ehi388cy++WVmpUawvUVN7GluIMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=JIj+ErPv; arc=none smtp.client-ip=43.163.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1764336962; bh=wPOMlJVMi7elv2tofGeiE7lameaJVv50F8wAp+2Pdbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIj+ErPvZ8hATO83oSAOFyvdkDLW7XuBTiK0qOyrXUs+7qSG3CmccwjU7Rg5APY9v
	 x7WbhomJ+oxpVZxqh+mtBLIDBV170TQobV1sMaBcLdSRMSDW/+/2BuVbwBoKIENJeu
	 s+CWZcxjulFUQklaDcCQV45IVT9nCWTL5NhJ/vg4=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 8F909ECE; Fri, 28 Nov 2025 21:35:57 +0800
X-QQ-mid: xmsmtpt1764336957t7h28wf36
Message-ID: <tencent_BA768766163C533724966E36344AAE754709@qq.com>
X-QQ-XMAILINFO: MZtEYADUG4Ag0E7GGGvsLR0ioWfRhR4FVYxB2sEiKH4ET++04qDfM5x+DELc4k
	 KW+H+dwKYNKShG9lWc3z9ummB+mQLISKmL07LNfXNDGaDYpi/PvFlUcSZEnkVjnbfEfW1Z9hkdy3
	 Qjy0jY7zKZnAYSXRFTcCOM3Y5MhxkxAZXY/zOej4Csl8zAvjeESiNyUPe8MhqAL8xcyeMglBe9MI
	 NAE+NuBFwXx9wOYiBE6Rr1rwbO9eKZmfSiZYBzHd5+RR0cWy5fjNQHkTjMmJI6pyjOcLfgB+yYpN
	 G1ex8nYBXThmgyuRAFL5/QkjSobBaKP78ChEJ4dqkBn/O0tZ/enGZkUu7bbcWtbyb6iwid/N2HAP
	 uPQnuI3bwVJkzqJZhYU3Oc/+CsQ6YReUZZ1oeP+3tVRI+MAUQps2jxQGNuSb9fAxFzzOPbe6Hxp5
	 Q+5snoP94sxpyAt0o6ZIQFMdmyM9DKxBPvnQAU6g9omv4WWj5jIPIfRac/h/KnSNdkMwkuWZx7ZE
	 FeIcvy8S8VYnaZnk/cRGMNGhz8tbKFaUv2lwXf0i6i5q80siOn3BhB51QGxviAHGlomyPq7i2ecF
	 QRYHejfaOhHM/0Ycnz636VSBNFK0cAnpUYKbCjcdLIEuwfPE8auFxVdSTR4oEziWJZoBEBs/VPF+
	 zdkYz+EYUNik7fU1qF3i+WcvVm220ZSm1VjsRlh2DiqhdOKjD86Oubekl3OJg+CyFyssaSNdjePW
	 XomOlpcIm4JHf7qohj4hQ85OQSLOLLuBD9diK1R3RxDbMNHpdkiGVkF9/spdzaHG+TXYkSCx15YQ
	 PLJ7F1+DRl5C6B5WUde3JDweyNojWCnmhN/iiXMC+7Llvl+S2upe/uT4cla5sZPjDDgvbJsHv/gR
	 23+1gEprJmTV28HoY6SkisLHuCcIBiuNTH4zW8ed3eotREsYRsQbNVtMlIm8bkoD+iqNAyAc11g+
	 jeqYR2jDLb7zYzE9rnjvYQVXH5dm/JJ5wjYfruVWtKYRu2asoNAqsCjhplwijU3QzBIlD0/fdBLL
	 PHmtFDHOhKKl7b3y+4eN0wNsqz5kU=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com
Cc: davem@davemloft.net,
	eadavis@qq.com,
	edumazet@google.com,
	eperezma@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	syzbot@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: [PATCH Next V2] net: restore the iterator to its original state when an error occurs
Date: Fri, 28 Nov 2025 21:35:57 +0800
X-OQ-MSGID: <20251128133556.127045-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <69299e25.a70a0220.d98e3.013e.GAE@google.com>
References: <69299e25.a70a0220.d98e3.013e.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In zerocopy_fill_skb_from_iter(), if two copy operations are performed
and the first one succeeds while the second one fails, it returns a
failure but the count in iterator has already been decremented due to
the first successful copy. This ultimately affects the local variable
rest_len in virtio_transport_send_pkt_info(), causing the remaining
count in rest_len to be greater than the actual iterator count. As a
result, packet sending operations continue even when the iterator count
is zero, which further leads to skb->len being 0 and triggers the warning
reported by syzbot [1].

Therefore, if the zerocopy operation fails, we should revert the iterator
to its original state.

The iov_iter_revert() in skb_zerocopy_iter_stream() is no longer needed
and has been removed.

[1]
'send_pkt()' returns 0, but 4096 expected
WARNING: net/vmw_vsock/virtio_transport_common.c:430 at virtio_transport_send_pkt_info+0xd1e/0xef0 net/vmw_vsock/virtio_transport_common.c:428, CPU#1: syz.0.17/5986
Call Trace:
 virtio_transport_stream_enqueue net/vmw_vsock/virtio_transport_common.c:1113 [inline]
 virtio_transport_seqpacket_enqueue+0x143/0x1c0 net/vmw_vsock/virtio_transport_common.c:841
 vsock_connectible_sendmsg+0xabf/0x1040 net/vmw_vsock/af_vsock.c:2158
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:746

Reported-by: syzbot+28e5f3d207b14bae122a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=28e5f3d207b14bae122a
Tested-by: syzbot+28e5f3d207b14bae122a@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
V1 -> V2: Remove iov_iter_revert() in skb_zerocopy_iter_stream()

 net/core/datagram.c | 6 ++++++
 net/core/skbuff.c   | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index c285c6465923..da10465cd8a4 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -748,10 +748,13 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 			    size_t length,
 			    struct net_devmem_dmabuf_binding *binding)
 {
+	struct iov_iter_state state;
 	unsigned long orig_size = skb->truesize;
 	unsigned long truesize;
 	int ret;
 
+	iov_iter_save_state(from, &state);
+
 	if (msg && msg->msg_ubuf && msg->sg_from_iter)
 		ret = msg->sg_from_iter(skb, from, length);
 	else if (binding)
@@ -759,6 +762,9 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	else
 		ret = zerocopy_fill_skb_from_iter(skb, from, length);
 
+	if (ret)
+		iov_iter_restore(from, &state);
+
 	truesize = skb->truesize - orig_size;
 	if (sk && sk->sk_type == SOCK_STREAM) {
 		sk_wmem_queued_add(sk, truesize);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5a1d123e7ef7..77ed045c28ff 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1908,7 +1908,6 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 		struct sock *save_sk = skb->sk;
 
 		/* Streams do not free skb on error. Reset to prev state. */
-		iov_iter_revert(&msg->msg_iter, skb->len - orig_len);
 		skb->sk = sk;
 		___pskb_trim(skb, orig_len);
 		skb->sk = save_sk;
-- 
2.43.0


