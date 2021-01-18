Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D292FA69B
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 17:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405431AbhARPQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 10:16:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42250 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393288AbhARPNz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 10:13:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610982747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ip/0CN7bVP9geNQa9w3wHloN3wQel8c1e3viv2HRlhk=;
        b=dm94Rm5kRh4ht1/N5WI+xwHPOGqHfWO0UzFB5QOnwl11ZQESqMdvEpYrwlt+I+SqxTKVEC
        LVE1tZZ7xs6xN9ASrhkpTTmOOqMTBIZJMDdY9WZDx3Mfro8mq/z5t6fJ9me5fUhdv3WKUZ
        NKpdv1k+sWmQA4xiP5gSOoBbpGwsRbY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-POdupYGRMuC7hIAsnYc2ng-1; Mon, 18 Jan 2021 10:12:26 -0500
X-MC-Unique: POdupYGRMuC7hIAsnYc2ng-1
Received: by mail-wr1-f69.google.com with SMTP id w8so8424885wrv.18
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 07:12:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ip/0CN7bVP9geNQa9w3wHloN3wQel8c1e3viv2HRlhk=;
        b=myKdJVPzNQ9fOlqasE2QFiu3KqhLeaeOmd0X8+XqHTotu1YQil1bFSdgn7BXsxuo1R
         jK9Z3IXkNo8/ZVqixVFDI9EsQrNW3v89DyPmdb90LbOeQDtz+8Sd8CFqEx4wTdmlOXC4
         a4OtKJjzle1+6lel1KDQW/KwvG+vpjDxmanGDYp2a2sRD+4qJKmqYNXMBsAosbYMWPhc
         Y6fEwbgczlMp3AuP4j4ffH/uxyvsbXt/+/uSDChzFbiuFlJKnZZ2BzgYCLiU1wTsDZZW
         L+bdXQ3B9BeuJ7bMt0ELuTmTWf53DmI1Tue5XJm5vj8xjPec8D/CPt1FhoKXjVsK0/Jr
         d0Bg==
X-Gm-Message-State: AOAM533M1sM5rBnk6SkS8+XywgkvJP0I7zB4Wwy6MsxVK5oP2o/8qS+O
        7BC+dutzYUkP8CxllIUIDDw3qZ46cNwS7Dugi9ts7CSI0f7NPppUck7RwZBJGGPRPv+J8f8EsrG
        Con/u2tA7anTj
X-Received: by 2002:a1c:de09:: with SMTP id v9mr21991541wmg.0.1610982744482;
        Mon, 18 Jan 2021 07:12:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxUhDhMP/7iJtbgaryNvSFGQzOIudg4Ls6FKI86cLVK7ZRr8+EW9AsfqUPUzAGV1gbPkAUn9w==
X-Received: by 2002:a1c:de09:: with SMTP id v9mr21991517wmg.0.1610982744235;
        Mon, 18 Jan 2021 07:12:24 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id 62sm7745621wmd.34.2021.01.18.07.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 07:12:23 -0800 (PST)
Date:   Mon, 18 Jan 2021 16:12:21 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 06/13] af_vsock: general support of SOCK_SEQPACKET
 type.
Message-ID: <20210118151221.65axqgmt34yuqzn7@steredhat>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
 <20210115054247.1456375-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210115054247.1456375-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 08:42:43AM +0300, Arseny Krasnov wrote:
>This adds socket operations for SOCK_SEQPACKET and adds this type of
>socket for conditions where SOCK_STREAM is involved because both type of
>sockets are connect oriented.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 108 +++++++++++++++++++++++++++++++++------
> 1 file changed, 92 insertions(+), 16 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 4a7cdf7756c0..d0ef066e9352 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -452,6 +452,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 		new_transport = transport_dgram;
> 		break;
> 	case SOCK_STREAM:
>+	case SOCK_SEQPACKET:
> 		if (vsock_use_local_transport(remote_cid))
> 			new_transport = transport_local;
> 		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
>@@ -459,6 +460,13 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 			new_transport = transport_g2h;
> 		else
> 			new_transport = transport_h2g;
>+
>+		if (sk->sk_type == SOCK_SEQPACKET) {
>+			if (!new_transport->seqpacket_seq_send_len ||
>+			    !new_transport->seqpacket_seq_get_len ||
>+			    !new_transport->seqpacket_dequeue)
>+				return -ENODEV;
>+		}
> 		break;
> 	default:
> 		return -ESOCKTNOSUPPORT;
>@@ -604,8 +612,8 @@ static void vsock_pending_work(struct work_struct *work)
>
> /**** SOCKET OPERATIONS ****/
>
>-static int __vsock_bind_stream(struct vsock_sock *vsk,
>-			       struct sockaddr_vm *addr)
>+static int __vsock_bind_connectible(struct vsock_sock *vsk,
>+				    struct sockaddr_vm *addr)
> {
> 	static u32 port;
> 	struct sockaddr_vm new_addr;
>@@ -684,8 +692,9 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
>
> 	switch (sk->sk_socket->type) {
> 	case SOCK_STREAM:
>+	case SOCK_SEQPACKET:
> 		spin_lock_bh(&vsock_table_lock);
>-		retval = __vsock_bind_stream(vsk, addr);
>+		retval = __vsock_bind_connectible(vsk, addr);
> 		spin_unlock_bh(&vsock_table_lock);
> 		break;
>
>@@ -767,6 +776,11 @@ static struct sock *__vsock_create(struct net *net,
> 	return sk;
> }
>
>+static bool sock_type_connectible(u16 type)
>+{
>+	return (type == SOCK_STREAM || type == SOCK_SEQPACKET);
>+}
>+
> static void __vsock_release(struct sock *sk, int level)
> {
> 	if (sk) {
>@@ -785,7 +799,7 @@ static void __vsock_release(struct sock *sk, int level)
>
> 		if (vsk->transport)
> 			vsk->transport->release(vsk);
>-		else if (sk->sk_type == SOCK_STREAM)
>+		else if (sock_type_connectible(sk->sk_type))
> 			vsock_remove_sock(vsk);
>
> 		sock_orphan(sk);
>@@ -945,7 +959,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
> 	sk = sock->sk;
> 	if (sock->state == SS_UNCONNECTED) {
> 		err = -ENOTCONN;
>-		if (sk->sk_type == SOCK_STREAM)
>+		if (sock_type_connectible(sk->sk_type))
> 			return err;
> 	} else {
> 		sock->state = SS_DISCONNECTING;
>@@ -960,7 +974,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
> 		sk->sk_state_change(sk);
> 		release_sock(sk);
>
>-		if (sk->sk_type == SOCK_STREAM) {
>+		if (sock_type_connectible(sk->sk_type)) {
> 			sock_reset_flag(sk, SOCK_DONE);
> 			vsock_send_shutdown(sk, mode);
> 		}
>@@ -1013,7 +1027,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 		if (!(sk->sk_shutdown & SEND_SHUTDOWN))
> 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
>
>-	} else if (sock->type == SOCK_STREAM) {
>+	} else if (sock_type_connectible(sk->sk_type)) {
> 		const struct vsock_transport *transport = vsk->transport;
> 		lock_sock(sk);
>
>@@ -1259,8 +1273,8 @@ static void vsock_connect_timeout(struct work_struct *work)
> 	sock_put(sk);
> }
>
>-static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
>-				int addr_len, int flags)
>+static int vsock_connect(struct socket *sock, struct sockaddr *addr,
>+			 int addr_len, int flags)
> {
> 	int err;
> 	struct sock *sk;
>@@ -1410,7 +1424,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
>
> 	lock_sock(listener);
>
>-	if (sock->type != SOCK_STREAM) {
>+	if (!sock_type_connectible(sock->type)) {
> 		err = -EOPNOTSUPP;
> 		goto out;
> 	}
>@@ -1477,6 +1491,18 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
> 	return err;
> }
>
>+static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
>+				int addr_len, int flags)
>+{
>+	return vsock_connect(sock, addr, addr_len, flags);
>+}
>+
>+static int vsock_seqpacket_connect(struct socket *sock, struct sockaddr *addr,
>+				   int addr_len, int flags)
>+{
>+	return vsock_connect(sock, addr, addr_len, flags);
>+}
>+
> static int vsock_listen(struct socket *sock, int backlog)
> {
> 	int err;
>@@ -1487,7 +1513,7 @@ static int vsock_listen(struct socket *sock, int backlog)
>
> 	lock_sock(sk);
>
>-	if (sock->type != SOCK_STREAM) {
>+	if (!sock_type_connectible(sk->sk_type)) {
> 		err = -EOPNOTSUPP;
> 		goto out;
> 	}
>@@ -1531,11 +1557,11 @@ static void vsock_update_buffer_size(struct vsock_sock *vsk,
> 	vsk->buffer_size = val;
> }
>
>-static int vsock_stream_setsockopt(struct socket *sock,
>-				   int level,
>-				   int optname,
>-				   sockptr_t optval,
>-				   unsigned int optlen)
>+static int vsock_setsockopt(struct socket *sock,
>+			    int level,
>+			    int optname,
>+			    sockptr_t optval,
>+			    unsigned int optlen)
> {
> 	int err;
> 	struct sock *sk;
>@@ -1612,6 +1638,24 @@ static int vsock_stream_setsockopt(struct socket *sock,
> 	return err;
> }
>
>+static int vsock_seqpacket_setsockopt(struct socket *sock,
>+				      int level,
>+				      int optname,
>+				      sockptr_t optval,
>+				      unsigned int optlen)
>+{
>+	return vsock_setsockopt(sock, level, optname, optval, optlen);
>+}
>+
>+static int vsock_stream_setsockopt(struct socket *sock,
>+				   int level,
>+				   int optname,
>+				   sockptr_t optval,
>+				   unsigned int optlen)
>+{
>+	return vsock_setsockopt(sock, level, optname, optval, optlen);
>+}
>+
> static int vsock_stream_getsockopt(struct socket *sock,
> 				   int level, int optname,
> 				   char __user *optval,
>@@ -1683,6 +1727,14 @@ static int vsock_stream_getsockopt(struct socket *sock,
> 	return 0;
> }
>
>+static int vsock_seqpacket_getsockopt(struct socket *sock,
>+				      int level, int optname,
>+				      char __user *optval,
>+				      int __user *optlen)
>+{
>+	return vsock_stream_getsockopt(sock, level, optname, optval, optlen);
>+}
>+

Why didn't you do the same thing you did with setsockopt?

Both are fine for me, but I'd like to do the same thing for getsockopt 
and setsockopt.

If you opt to create new functions, maybe it's better to call them 
vsock_connectible_*sockopt()

> static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 				     size_t len)
> {
>@@ -2184,6 +2236,27 @@ static const struct proto_ops vsock_stream_ops = {
> 	.sendpage = sock_no_sendpage,
> };
>
>+static const struct proto_ops vsock_seqpacket_ops = {
>+	.family = PF_VSOCK,
>+	.owner = THIS_MODULE,
>+	.release = vsock_release,
>+	.bind = vsock_bind,
>+	.connect = vsock_seqpacket_connect,
>+	.socketpair = sock_no_socketpair,
>+	.accept = vsock_accept,
>+	.getname = vsock_getname,
>+	.poll = vsock_poll,
>+	.ioctl = sock_no_ioctl,
>+	.listen = vsock_listen,
>+	.shutdown = vsock_shutdown,
>+	.setsockopt = vsock_seqpacket_setsockopt,
>+	.getsockopt = vsock_seqpacket_getsockopt,
>+	.sendmsg = vsock_seqpacket_sendmsg,
>+	.recvmsg = vsock_seqpacket_recvmsg,
>+	.mmap = sock_no_mmap,
>+	.sendpage = sock_no_sendpage,
>+};
>+
> static int vsock_create(struct net *net, struct socket *sock,
> 			int protocol, int kern)
> {
>@@ -2204,6 +2277,9 @@ static int vsock_create(struct net *net, struct socket *sock,
> 	case SOCK_STREAM:
> 		sock->ops = &vsock_stream_ops;
> 		break;
>+	case SOCK_SEQPACKET:
>+		sock->ops = &vsock_seqpacket_ops;
>+		break;
> 	default:
> 		return -ESOCKTNOSUPPORT;
> 	}
>-- 
>2.25.1
>

