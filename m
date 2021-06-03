Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD39639A419
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 17:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhFCPQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 11:16:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49831 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231639AbhFCPQ3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 11:16:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622733284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/TbnjPejbYwVan9HkOykuBL+tAV4BzyESSrfqanFgRE=;
        b=G8G+/20/tkQbMnXpvX8HFRinXvufLQ3bNOoduXVp/EJc1DCTRGJnyB7LDuEcpXEMI1LZiM
        Ph0PSJrX/4dorCOqQDsjK/IDHS5jlsRxoZqIvyeBtzMf75BffYVhHmvzus8cmPdzkBtgEZ
        GFXLUyaiBKMOk6hkz9A2eDues5yEudE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-l0wTPX26MvOi9eoKSvbS-w-1; Thu, 03 Jun 2021 11:14:43 -0400
X-MC-Unique: l0wTPX26MvOi9eoKSvbS-w-1
Received: by mail-ed1-f71.google.com with SMTP id c13-20020a50f60d0000b02903900105f127so3406196edn.22
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 08:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/TbnjPejbYwVan9HkOykuBL+tAV4BzyESSrfqanFgRE=;
        b=Ml5Su4P4LrrbME6n0G4RpV6fJFXWZhwBeTur39XpTAUThTqrr64rDIXDtnFkaQdYxp
         JVXMFJfNibqByOCj6uuG2bPpChm84knk/l7THJD5uG9+b6lNUjjA64h3Xkv/QphACnv7
         EO4Cb+5jKcWl0rdTqAwC0EzWciLJzGa5SdFEibxR2ZM7HYQ3tEWOu6B0Bx44rZ/TRd3k
         lhxDhJExnhckGYzq8KvqvEfKu5IqY/Md/b/gk0bq/o2ZBudhfOfvj0/LefhXyRZIw94w
         cWlapJxF8xYXhg1023wIkZilrrkLd8SBccCWMalJEmwzp/DHixVp372Sk16Vsq9tZiXp
         vCBg==
X-Gm-Message-State: AOAM5338YGE2457HcS8zBHBdrSVZyaGW4nQZRRE81eW8CWE9lU6yL2cb
        FRAjvMrjPZHecMynKYdwxE7+624ht5jSFlKQPEP05lDbvEs9evnTsD7uvtsahFOVICfuhSHyXOY
        prbE1zoY6Qj8C
X-Received: by 2002:a17:906:15c2:: with SMTP id l2mr102917ejd.348.1622733281808;
        Thu, 03 Jun 2021 08:14:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0x5W1f0mRcMdebhikIGS3xszHMVLQeFtJfQT5T5MgWSrP7f8pNxRu7aXb5Lg9wKUHaELxKA==
X-Received: by 2002:a17:906:15c2:: with SMTP id l2mr102880ejd.348.1622733281491;
        Thu, 03 Jun 2021 08:14:41 -0700 (PDT)
Received: from steredhat ([5.170.129.82])
        by smtp.gmail.com with ESMTPSA id v21sm1894572edt.48.2021.06.03.08.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 08:14:40 -0700 (PDT)
Date:   Thu, 3 Jun 2021 17:14:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 13/18] virtio/vsock: rest of SOCK_SEQPACKET support
Message-ID: <20210603151433.3tbiibmcfacpcjt2@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191840.1272290-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191840.1272290-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 10:18:37PM +0300, Arseny Krasnov wrote:
>Small updates to make SOCK_SEQPACKET work:
>1) Send SHUTDOWN on socket close for SEQPACKET type.
>2) Set SEQPACKET packet type during send.
>3) Set 'VIRTIO_VSOCK_SEQ_EOR' bit in flags for last
>   packet of message.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v9 -> v10:
> 1) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
> 2) Commit message updated.
> 3) Add check for socket type when setting SEQ_EOR bit.
>
> include/linux/virtio_vsock.h            |  4 ++++
> net/vmw_vsock/virtio_transport_common.c | 18 ++++++++++++++++--
> 2 files changed, 20 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 02acf6e9ae04..7360ab7ea0af 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -80,6 +80,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+int
>+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   size_t len);
> ssize_t
> virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> 				   struct msghdr *msg,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index a6f8b0f39775..f7a3281b3eab 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -74,6 +74,11 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
> 		err = memcpy_from_msg(pkt->buf, info->msg, len);
> 		if (err)
> 			goto out;
>+
>+		if (msg_data_left(info->msg) == 0 &&
>+		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET)
>+			pkt->hdr.flags = cpu_to_le32(info->flags |
>+						VIRTIO_VSOCK_SEQ_EOR);

`pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR)` should be enough, 
no?

Stefano

> 	}
>
> 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
>@@ -187,7 +192,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	struct virtio_vsock_pkt *pkt;
> 	u32 pkt_len = info->pkt_len;
>
>-	info->type = VIRTIO_VSOCK_TYPE_STREAM;
>+	info->type = virtio_transport_get_type(sk_vsock(vsk));
>
> 	t_ops = virtio_transport_get_ops(vsk);
> 	if (unlikely(!t_ops))
>@@ -478,6 +483,15 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> }
> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>
>+int
>+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   size_t len)
>+{
>+	return virtio_transport_stream_enqueue(vsk, msg, len);
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
>+
> int
> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
>@@ -912,7 +926,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
> 	struct sock *sk = &vsk->sk;
> 	bool remove_sock = true;
>
>-	if (sk->sk_type == SOCK_STREAM)
>+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
> 		remove_sock = virtio_transport_close(vsk);
>
> 	if (remove_sock) {
>-- 
>2.25.1
>

