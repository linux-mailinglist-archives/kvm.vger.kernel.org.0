Return-Path: <kvm+bounces-65649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A00CB29FE
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 11:03:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD43F30C588E
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 10:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D663090FA;
	Wed, 10 Dec 2025 10:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="w/stcOv+"
X-Original-To: kvm@vger.kernel.org
Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3531019D081;
	Wed, 10 Dec 2025 10:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361010; cv=none; b=hDzlOAY4DsU4gkTG5dy2HCyxamtm7XcKanvGEdJVdaDCaKcGqgb3xpZf2f9GspR3hU3QoPAJR+SEtJU73/GzCI+PMVbd1B1AsMSNdCedseNEBN27VpbtvhfEcjXUGlz2fitdgMjP2AzSskMrRUEAoBNcJIT0zmrapU5zZk43itc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361010; c=relaxed/simple;
	bh=hHOb0pHbFva4I+x4uijiSBLjhyKbHSkdIbKpygCjPME=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=FiOQxL3H4XsQ7/ocljFcudpKeRIi8pN9kH9KT/0JRkQYBGULN1VzcZhhiOkCzFmCUaHqv7Ra6K3WK28LZMSCbb74XqZ3W6asDFksXAQGcTRlqmNfCIyEIipHJD8AQb3km0uDCSaWGbXUfThmtsOQZuY4KdZBV4LI6V2D0daMKE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=w/stcOv+; arc=none smtp.client-ip=203.205.221.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765360999; bh=LCRtxAYuGByxDxvJWLaU+fHIdMnrtqotoYo1riQtsVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/stcOv+VCZFf0VoGyvbE4xfFHIbVoSiBb3jpRZvI2Jl1EC4w7/FCDLza/JsW+AGg
	 cxDG31FOHpf5PgQSYANXo+QJPKMOePnyuwFhQYEdMsd7MGhW33NrPs1l71wweS4r8k
	 fPUQtExAnIHoqNTb3gjZYWP4Q4NYxfO5PIb4TWzg=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id CE284EB; Wed, 10 Dec 2025 18:03:14 +0800
X-QQ-mid: xmsmtpt1765360994tuh3ingl1
Message-ID: <tencent_000364896CA3A544481764D76486C0336005@qq.com>
X-QQ-XMAILINFO: NG7xP+P+sy64CnCglhF8tEcniZRxm7yXDuURLY0ray/GevzC90bYklIf9MmRup
	 BLdRdJc6yKh36B1G2hH/bHie7vYrQFzuGGknaFfDhvQRah0bsy/13BD7KlTx5vMHUAp+Iav32BLi
	 xqR1t+q+9SKJwyqhGLxLlccpnG9UrpHF62cskwzppKj2z2iM8GJdvunHg03HD+kIH3Zklw0Gmpre
	 G9gd0gEdE21bKcpK/UJG6IOtuYUKdxpUPEHgTkYmjWg2aLcrI2uGtwv1M9tqYyjxzyOpdkFrpaPR
	 CGPHnjbxyW+002Ap9x+j4w5IWrElDTEJSC1OzUv6vLERvzpgUdgniZdRP6OX82ijSBe6UllvAfzs
	 YbjvCz0cVF6OFP2WiAlFWk9Hbxlokh+wswdG3hHTKvj+qXQUth6Vv6QyhVIAiQ+3DeGdS1UfmLlC
	 j5M/QO9ixMkMbC0GPNzhnxRn/W0/yEg5gXf/TeywWx13YjQLJNQS3lY3kgdOXd5dE2d/g8KDEK7G
	 bJ5Bv2MqScnyLPojGcbQ1UAxZR6Rvfb/MmLKkmzJZ3E1Jl+sYf5f9uyZrsTA1JLIjliuxWIzRW6M
	 DWaRA6tOBaPk+djoW+rwG9R/AHkLKgNFp55psSUb6Ujqijijix6tPaNQ/Se6myuklUvsV9WNYtOj
	 F59LIDwGqKMNDJxhb5mAIGJhxn+bIpNkE3eC4ifGoKu2xOTnKA6qWhav9Hd2+0qqzZL6XSUkueoN
	 b6WPpkZ+OCB3Ioez++tiAhgJV6AEaNiWv+YN9miqXFILwBORD99fCTQF9LiOSR+yjSpkvLvVwe7e
	 MXHF/bDMy50svkjeS1baGbOP893XxmRaqd1qShZBqTMLkhvmhgfC0J8Q3OW3q666xVVu6ji3LfCI
	 WJJ9yBclTRzfTH4DvrWTssN/E6CH/jFQmiz93PHGRr5glboEbo7G3pG9jg53IBXkSGIlLWJf15d5
	 ZuG2ALFCmwZxp5E3QvRU72LHPu6pLpHIoQJU2JkOG0aqgyDqYoIVgMiFxJ9lSM7ZY/3X/I/PDyOx
	 iOXwLmB1oq8Y/gGVsUFe/ggRFAiPfhKFEn4yu1kBUnhQUuNfw7MZ7+h9HGiTOMH33pFBsIz2aQoP
	 pNWnIc27aLaVm0VWY=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
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
Subject: Re: [PATCH net-next V3] net: restore the iterator to its original state when an error occurs
Date: Wed, 10 Dec 2025 18:03:14 +0800
X-OQ-MSGID: <20251210100313.12457-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251210173125.281dc808@kernel.org>
References: <20251210173125.281dc808@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 10 Dec 2025 17:31:25 +0900, Jakub Kicinski wrote:
> > In zerocopy_fill_skb_from_iter(), if two copy operations are performed
> > and the first one succeeds while the second one fails, it returns a
> > failure but the count in iterator has already been decremented due to
> > the first successful copy. This ultimately affects the local variable
> > rest_len in virtio_transport_send_pkt_info(), causing the remaining
> > count in rest_len to be greater than the actual iterator count. As a
> > result, packet sending operations continue even when the iterator count
> > is zero, which further leads to skb->len being 0 and triggers the warning
> > reported by syzbot [1].
> >
> > Therefore, if the zerocopy operation fails, we should revert the iterator
> > to its original state.
> >
> > The iov_iter_revert() in skb_zerocopy_iter_stream() is no longer needed
> > and has been removed.
> >
> > [1]
> > 'send_pkt()' returns 0, but 4096 expected
> > WARNING: net/vmw_vsock/virtio_transport_common.c:430 at virtio_transport_send_pkt_info+0xd1e/0xef0 net/vmw_vsock/virtio_transport_common.c:428, CPU#1: syz.0.17/5986
> > Call Trace:
> >  virtio_transport_stream_enqueue net/vmw_vsock/virtio_transport_common.c:1113 [inline]
> >  virtio_transport_seqpacket_enqueue+0x143/0x1c0 net/vmw_vsock/virtio_transport_common.c:841
> >  vsock_connectible_sendmsg+0xabf/0x1040 net/vmw_vsock/af_vsock.c:2158
> >  sock_sendmsg_nosec net/socket.c:727 [inline]
> >  __sock_sendmsg+0x21c/0x270 net/socket.c:746
> >
> > Reported-by: syzbot+28e5f3d207b14bae122a@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=28e5f3d207b14bae122a
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > ---
> > v3:
> >   - fix test tcp_zerocopy_maxfrags timeout
> > v2: https://lore.kernel.org/all/tencent_BA768766163C533724966E36344AAE754709@qq.com/
> >   - Remove iov_iter_revert() in skb_zerocopy_iter_stream()
> > v1: https://lore.kernel.org/all/tencent_387517772566B03DBD365896C036264AA809@qq.com/
> 
> Have you investigated the other callers? Given problems with previous
> version of this patch I'm worried you have not. If you did please extend
> the commit message with the appropriate explanation.
Are you asking if I investigated other zerocopy tests? NO.
The test results [T2] for this version of the patch do not show any
failures related to zerocopy.

[T2] https://patchwork.kernel.org/project/netdevbpf/patch/tencent_3C86DFD37A0374496263BE24483777D76305@qq.com
> 
> Alternative would be to add a _full() flavor of this API, but not sure
> if other callers actually care.
> 
> > diff --git a/net/core/datagram.c b/net/core/datagram.c
> > index c285c6465923..3a612ebbbe80 100644
> > --- a/net/core/datagram.c
> > +++ b/net/core/datagram.c
> > @@ -748,9 +748,13 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
> >  			    size_t length,
> >  			    struct net_devmem_dmabuf_binding *binding)
> >  {
> > +	struct iov_iter_state state;
> 
> nit: if you respin move this one line down
OK.
> 
> >  	unsigned long orig_size = skb->truesize;
> >  	unsigned long truesize;
> > -	int ret;
> > +	int ret, orig_len;
> > +
> > +	iov_iter_save_state(from, &state);
> > +	orig_len = skb->len;
> >
> >  	if (msg && msg->msg_ubuf && msg->sg_from_iter)
> >  		ret = msg->sg_from_iter(skb, from, length);
> > @@ -759,6 +763,9 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
> >  	else
> >  		ret = zerocopy_fill_skb_from_iter(skb, from, length);
> >
> > +	if (ret == -EFAULT || (ret == -EMSGSIZE && skb->len == orig_len))
> 
> I'd think that for the purpose of reverting iter the second part of
> this condition is completely moot. If skb len didn't change there should
> be nothing to revert?
Regarding the second judgment condition, I aligned it with the condition
in skb_zerocopy_iter_stream(). During my testing, I only encountered
-EFAULT failures, not -EMSGSIZE.
> 
> > +		iov_iter_restore(from, &state);
> > +
> >  	truesize = skb->truesize - orig_size;
> >  	if (sk && sk->sk_type == SOCK_STREAM) {
> >  		sk_wmem_queued_add(sk, truesize);
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index a00808f7be6a..7b8836f668b7 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -1908,7 +1908,6 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
> >  		struct sock *save_sk = skb->sk;
> >
> >  		/* Streams do not free skb on error. Reset to prev state. */
> > -		iov_iter_revert(&msg->msg_iter, skb->len - orig_len);
> >  		skb->sk = sk;
> >  		___pskb_trim(skb, orig_len);
> >  		skb->sk = save_sk;


