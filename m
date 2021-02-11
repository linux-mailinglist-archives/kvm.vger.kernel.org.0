Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFC2318AA2
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 13:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhBKMbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 07:31:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhBKM2u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 07:28:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613046439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HMz6zYsvhAUacFy6he/Ff5pa+8L4MB4YjmA0Jw1xjYQ=;
        b=KP78mzwwuZ9KkhDlWCYN57R6TFXWi0OhIWRt2KVnAxClUlO722E1JtJ/JcctxD2v7Az/FR
        wyrCLIfucnAGKBZ+hOEDB95g0ZR7F1ocNFVyS/PhCvGXleFiHaIHv5W6cu5oH4nQfLK+LP
        zab0DPFWfhfHggE+99bZFXtzrR2xjFw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-oCEuO4hxNEyb3tTFLfJdsg-1; Thu, 11 Feb 2021 07:27:18 -0500
X-MC-Unique: oCEuO4hxNEyb3tTFLfJdsg-1
Received: by mail-ed1-f69.google.com with SMTP id q2so4459081edt.16
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 04:27:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HMz6zYsvhAUacFy6he/Ff5pa+8L4MB4YjmA0Jw1xjYQ=;
        b=JxSVz0tp3D16XXH4qqksSDNimYgbXiY4BlEDhgj3mStIwBAZULwIhFb897qWXYKF/A
         wi2M6rri8wFs70Hy2X5vECgbDGnKFeHOrM2k/IhdHvbRUJ5OAU9GlAQQi/pCwkR8uEO4
         74dSrVakIcn/STkWq0ftVH/ERyrFlWgVDNJ/h5K/jktX/y/xcEmxMGuTQl6o5C80i0Iq
         jN790QAET/CX2cKMTeFjC3f+TLVj+1oJ9CTgDneCWAMbpQ2MqDMpi6VJILH5pHofLKlR
         jlFDjc+9URKpZPz986ZrN/argxQZBn+jTxxojd9/L5bvWSZPxBH/9LaBC8vli+YJCpcQ
         kYvg==
X-Gm-Message-State: AOAM5316Fqop/7Ut0/5YYceXUk0dLWmm0VU3ScIlPzmTmSUTmFco9zcs
        fP3kPbH9CboSijrZ/LJLxgmyr7gMzyu2JgVzavuo4DFHm5AyrezbX+QHZhOU0hV0up6/XtqMeiy
        5+MDYg/hAlC9x
X-Received: by 2002:a17:906:2747:: with SMTP id a7mr8529853ejd.250.1613046437362;
        Thu, 11 Feb 2021 04:27:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyk6B6DSr3e6B0w/xlbcUeWXisr2RXOx2YRDpQHkAnrdl/RyyOhCzJ+iUDi0A/EsFUj4H9p5g==
X-Received: by 2002:a17:906:2747:: with SMTP id a7mr8529844ejd.250.1613046437196;
        Thu, 11 Feb 2021 04:27:17 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id bo24sm3698134edb.51.2021.02.11.04.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:27:16 -0800 (PST)
Date:   Thu, 11 Feb 2021 13:27:14 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 07/17] af_vsock: rest of SEQPACKET support
Message-ID: <20210211122714.rqiwg3qp3kuprktb@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151615.805115-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151615.805115-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 07, 2021 at 06:16:12PM +0300, Arseny Krasnov wrote:
>This does rest of SOCK_SEQPACKET support:
>1) Adds socket ops for SEQPACKET type.
>2) Allows to create socket with SEQPACKET type.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 37 ++++++++++++++++++++++++++++++++++++-
> 1 file changed, 36 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index a033d3340ac4..c77998a14018 100644
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
>@@ -459,6 +460,15 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 			new_transport = transport_g2h;
> 		else
> 			new_transport = transport_h2g;
>+
>+		if (sk->sk_type == SOCK_SEQPACKET) {
>+			if (!new_transport ||
>+			    !new_transport->seqpacket_seq_send_len ||
>+			    !new_transport->seqpacket_seq_send_eor ||
>+			    !new_transport->seqpacket_seq_get_len ||
>+			    !new_transport->seqpacket_dequeue)
>+				return -ESOCKTNOSUPPORT;
>+		}

Maybe we should move this check after the try_module_get() call, since 
the memory pointed by 'new_transport' pointer can be deallocated in the 
meantime.

Also, if the socket had a transport before, we should deassign it before 
returning an error.

> 		break;
> 	default:
> 		return -ESOCKTNOSUPPORT;
>@@ -684,6 +694,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
>
> 	switch (sk->sk_socket->type) {
> 	case SOCK_STREAM:
>+	case SOCK_SEQPACKET:
> 		spin_lock_bh(&vsock_table_lock);
> 		retval = __vsock_bind_connectible(vsk, addr);
> 		spin_unlock_bh(&vsock_table_lock);
>@@ -769,7 +780,7 @@ static struct sock *__vsock_create(struct net *net,
>
> static bool sock_type_connectible(u16 type)
> {
>-	return type == SOCK_STREAM;
>+	return (type == SOCK_STREAM) || (type == SOCK_SEQPACKET);
> }
>
> static void __vsock_release(struct sock *sk, int level)
>@@ -2199,6 +2210,27 @@ static const struct proto_ops vsock_stream_ops = {
> 	.sendpage = sock_no_sendpage,
> };
>
>+static const struct proto_ops vsock_seqpacket_ops = {
>+	.family = PF_VSOCK,
>+	.owner = THIS_MODULE,
>+	.release = vsock_release,
>+	.bind = vsock_bind,
>+	.connect = vsock_connect,
>+	.socketpair = sock_no_socketpair,
>+	.accept = vsock_accept,
>+	.getname = vsock_getname,
>+	.poll = vsock_poll,
>+	.ioctl = sock_no_ioctl,
>+	.listen = vsock_listen,
>+	.shutdown = vsock_shutdown,
>+	.setsockopt = vsock_connectible_setsockopt,
>+	.getsockopt = vsock_connectible_getsockopt,
>+	.sendmsg = vsock_connectible_sendmsg,
>+	.recvmsg = vsock_connectible_recvmsg,
>+	.mmap = sock_no_mmap,
>+	.sendpage = sock_no_sendpage,
>+};
>+
> static int vsock_create(struct net *net, struct socket *sock,
> 			int protocol, int kern)
> {
>@@ -2219,6 +2251,9 @@ static int vsock_create(struct net *net, struct socket *sock,
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

