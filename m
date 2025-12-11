Return-Path: <kvm+bounces-65728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 17706CB4F30
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC372301C3C8
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3075F2C0260;
	Thu, 11 Dec 2025 06:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="j4D4Y3B3"
X-Original-To: kvm@vger.kernel.org
Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EB02BE7A1;
	Thu, 11 Dec 2025 06:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765436237; cv=none; b=s7U+G19KVVdUhlpKIOYRFjkBZ0XuGXxWa6BII2PTxnShKn7CITlkZCMTJRW+CQ/L//EwdhJ85OEJ5QF6hsLFGn8XwbfiBtTQ2L2NfjRs+LFrNtZN+Ri1SUx4VjsUU2qdkivbkFZDHbM54d0jgS6L+IWMyfruQ/5DuWqrTAhy0ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765436237; c=relaxed/simple;
	bh=0e6USttijmO2horzqXfsOf7139B23IPXLpWfygiqSkY=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=WWRrW5HH35gdnsT/FL/7KWcIDYwkehZ/IhRDjmxVwu/6/oAhgjsUumktDQxkjMejzf4l/Ah3HyHt5P6x4dv/3Hqn6B9rnLkeqsz7uzy8ZXNdIQAWkkd3EIypcnjwgLudB075zXuvwceVjp5+99CzkP2F9fQNOVsXEv0SiT6xbT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=j4D4Y3B3; arc=none smtp.client-ip=203.205.221.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765436232; bh=qym9jNqiA34VWvBCsaKdelhcoyWyxbkXaH8MkVv3VIc=;
	h=From:To:Cc:Subject:Date;
	b=j4D4Y3B3GOKpX++BLFKzmptMUWIALMD5kwkizBTJc6lzaF2+VTb99DAaGTHzGHgOz
	 vNZdadXksi2Kd6Qte3mbRyfp73+gfGMz+VJLQ1SjZa3TDSbxaDQ9W/pKPYBzzuGrPG
	 Beupbv4q7t84dmA9AZlS39FA1bU2CqJVpWrRH6po=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id E479A21A; Thu, 11 Dec 2025 14:57:07 +0800
X-QQ-mid: xmsmtpt1765436227tzkqso0y1
Message-ID: <tencent_D6C4465761B77986C7B36FA368E97E23A805@qq.com>
X-QQ-XMAILINFO: NEuWzguPBXIKkFBhIjI0JCppC3ptFbk1lS7fUYCDHnLMDVAZiSQNyi1Khk2LWl
	 CSu8h7sQXRKu5RTicGmT+1fW434/kXK58/SnFBhZNOD5M2ETOHuot9Lw4u4Gi8QTk3eNVGGtHSwu
	 FakhnYZL0OH+EAGwr1YRMvOk6UY1KNDRDDp01cWJN+8N9o14yNHy1z5HrtgnzO0+SbCK6CZu17vg
	 mcd1M0KFDQL3MFyZhq+ojo1Hj3IJXiKuPiwKM+IO3KzdknT6CqElbYWIWhb3tTw5jfvZOkk85HmC
	 a/TMeuhcs44k5eoRXH3guSDd4RIm1SWMihWM0fG1muWvbiBq2oLjEW7UoLXR3affsVry2AKKyktV
	 yGcNO8rcT7y5dBO9jEfWcH/uAB77On6neRGRK45wnz/AF3LyPKfyCCtwfhf5a59hTCJakPyNi9Ve
	 60DSNfdVM56HC4aweqZfT9H0WnpyI/iZuB8fecumFudoxSG/D/u0CMr2xEDV92kIc8pPWPlTOL40
	 HVjoL8V0m766fNvDQFWHjlSEXA7ftbikSsEYHcqHzS/2zGXGbEmQakd5khum5DhhtkmnhRdDBKzR
	 BGJwPUJdGcX/FdulraopUZO6m3BV9UP33ABDvdJW1raeCJq/Jpn0/FldsSQFhzbTYk6JRHDLeDns
	 UGTaFlwPll/FZEbj+Zp0ZqRei1JJALNuEApD5dAiE3cNvPI2MzwFK2P83+XbbIt1Nt0KzA7/7HvW
	 qmpVCfnndYbsZtCvON5zxxYZgiMN3h9VY6nSQUwRZumM4mgl5tW6WnWTEvfD4pKAzIH5VqZqcIlj
	 ZJRYlVKLDjZ8pUxqt4cYF7J7PMG+Bt+gPeaxgQ7YiYRPe8CrLNj5+kv58ymu+YHQ+ojaYK9e3g9M
	 w7AEz2GIRRRA/u4+VaZgmeNdzQlxsy8Oc8LkV8r153oiq62svKXo+J817DcT8avAIEQh7+LaUWN6
	 4iGGKRE4GBwW5oMHwltCH879+YngKVNRKEiZt9543eYdXeO4C3OG4Cr4/NQznqwH6bmXtNkfoJ0/
	 L3RfYt7DmsNL+7huFmhC9V80Wk8ZWn5D+++grxW80ApCOBsq+MADOaqWLWQkCg9G0ESUKGO6vziE
	 nzFtDL
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
From: Edward Adam Davis <eadavis@qq.com>
To: kuba@kernel.org
Cc: davem@davemloft.net,
	eadavis@qq.com,
	edumazet@google.com,
	eperezma@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com,
	syzbot@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: [PATCH net-next v4] net: restore the iterator to its original state when an error occurs
Date: Thu, 11 Dec 2025 14:57:08 +0800
X-OQ-MSGID: <20251211065707.41148-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
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

Regarding the judgment condition, I aligned it with the condition in
skb_zerocopy_iter_stream().

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
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
v4:
  - add comments for new condition
v3: https://lore.kernel.org/all/tencent_3C86DFD37A0374496263BE24483777D76305@qq.com/
  - fix test tcp_zerocopy_maxfrags timeout
v2: https://lore.kernel.org/all/tencent_BA768766163C533724966E36344AAE754709@qq.com/
  - Remove iov_iter_revert() in skb_zerocopy_iter_stream()
v1: https://lore.kernel.org/all/tencent_387517772566B03DBD365896C036264AA809@qq.com/

 net/core/datagram.c | 9 ++++++++-
 net/core/skbuff.c   | 1 -
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index c285c6465923..c5f2f1b8786b 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -749,8 +749,12 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 			    struct net_devmem_dmabuf_binding *binding)
 {
 	unsigned long orig_size = skb->truesize;
+	struct iov_iter_state state;
 	unsigned long truesize;
-	int ret;
+	int ret, orig_len;
+
+	iov_iter_save_state(from, &state);
+	orig_len = skb->len;
 
 	if (msg && msg->msg_ubuf && msg->sg_from_iter)
 		ret = msg->sg_from_iter(skb, from, length);
@@ -759,6 +763,9 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	else
 		ret = zerocopy_fill_skb_from_iter(skb, from, length);
 
+	if (ret == -EFAULT || (ret == -EMSGSIZE && skb->len == orig_len))
+		iov_iter_restore(from, &state);
+
 	truesize = skb->truesize - orig_size;
 	if (sk && sk->sk_type == SOCK_STREAM) {
 		sk_wmem_queued_add(sk, truesize);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a00808f7be6a..7b8836f668b7 100644
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


