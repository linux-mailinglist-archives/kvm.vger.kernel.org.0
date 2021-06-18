Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EF63ACC8F
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 15:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbhFRNql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 09:46:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231855AbhFRNqk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 09:46:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624023871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TeeOPx856RlPCCZLEcV71KwWexsoQ+3mbRzQGTsGO84=;
        b=Dk85mKqzUt1Uq7PV+32/LtUr5kqanoPDbILxtmBkbHwsyRqbfoOLOf2Y4kENbEHFfGMsdm
        i5T+eW0tZ/qB9E6CLztmnJE9cOJy3SnZMysMPKexAJDpKwWVi13iso4D6Y+SPVoVSvUy7x
        5nk95FrETVZWdUCGDQtc7wuqqSo82AE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-MwIUvShqMD-0hafmqchL0Q-1; Fri, 18 Jun 2021 09:44:30 -0400
X-MC-Unique: MwIUvShqMD-0hafmqchL0Q-1
Received: by mail-ed1-f70.google.com with SMTP id p23-20020aa7cc970000b02903948bc39fd5so1569081edt.13
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 06:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TeeOPx856RlPCCZLEcV71KwWexsoQ+3mbRzQGTsGO84=;
        b=NA22ger0r7XT4a1r5JVRKNLeNaOp6HfhNMZ6YESlyYZCWqrJNYpVZKv2+ImxxCOdVp
         /GOB3hSHYP6XQkwG34c3XvdyNYzDsHmbXBAf/SnSTCCjGsrLobKevdiq6kowaow2AqoW
         dENnRlZAa6uz5kzBuxrEc59FMRhI4mASnlpIxB2gY4BkAYt83PKsA7VsaROU9IZMV26q
         48wmEvX9Pp7vuOwOpFwQCOugoglrDeC+3dOfrulL91Yd91sSEwR6B5ifX1JECB4uNNvW
         qYrPY/lNXJP/wymI6MLmLvTt5S7lkinxQYnMiVP35knys8yWVvOyNvZKyo+0ZsuMwwcb
         ALeA==
X-Gm-Message-State: AOAM531nJ3iKklvySp50P4WYnBWskpJ1E8DFtC60f2ZikEizTOdanvAY
        dZyEN3mEsqqtUbfgQIZ0iMChauU9FmVagcnLVQfUCJeASBQxbEZ7e1UbYhjYOrZzFj1n5ZtCB0v
        3zGliPKRkQq69
X-Received: by 2002:a50:f9ca:: with SMTP id a10mr4968352edq.97.1624023869087;
        Fri, 18 Jun 2021 06:44:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxed23QNl/805EiXhmOAG6oexUgIRvZQQb5iyy1GRaDuHzCwPRNJIeHvrbdksWmSIWzP5h7iQ==
X-Received: by 2002:a50:f9ca:: with SMTP id a10mr4968330edq.97.1624023868927;
        Fri, 18 Jun 2021 06:44:28 -0700 (PDT)
Received: from steredhat.lan ([5.170.130.11])
        by smtp.gmail.com with ESMTPSA id da28sm1414842edb.0.2021.06.18.06.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 06:44:28 -0700 (PDT)
Date:   Fri, 18 Jun 2021 15:44:23 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
Subject: Re: [PATCH v11 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Arseny,
the series looks great, I have just a question below about 
seqpacket_dequeue.

I also sent a couple a simple fixes, it would be great if you can review 
them: 
https://lore.kernel.org/netdev/20210618133526.300347-1-sgarzare@redhat.com/


On Fri, Jun 11, 2021 at 02:12:38PM +0300, Arseny Krasnov wrote:
>Callback fetches RW packets from rx queue of socket until whole record
>is copied(if user's buffer is full, user is not woken up). This is done
>to not stall sender, because if we wake up user and it leaves syscall,
>nobody will send credit update for rest of record, and sender will wait
>for next enter of read syscall at receiver's side. So if user buffer is
>full, we just send credit update and drop data.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v10 -> v11:
> 1) 'msg_count' field added to count current number of EORs.
> 2) 'msg_ready' argument removed from callback.
> 3) If 'memcpy_to_msg()' failed during copy loop, there will be
>    no next attempts to copy data, rest of record will be freed.
>
> include/linux/virtio_vsock.h            |  5 ++
> net/vmw_vsock/virtio_transport_common.c | 84 +++++++++++++++++++++++++
> 2 files changed, 89 insertions(+)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index dc636b727179..1d9a302cb91d 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -36,6 +36,7 @@ struct virtio_vsock_sock {
> 	u32 rx_bytes;
> 	u32 buf_alloc;
> 	struct list_head rx_queue;
>+	u32 msg_count;
> };
>
> struct virtio_vsock_pkt {
>@@ -80,6 +81,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+ssize_t
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags);
> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index ad0d34d41444..1e1df19ec164 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -393,6 +393,78 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>+						 struct msghdr *msg,
>+						 int flags)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct virtio_vsock_pkt *pkt;
>+	int dequeued_len = 0;
>+	size_t user_buf_len = msg_data_left(msg);
>+	bool copy_failed = false;
>+	bool msg_ready = false;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	if (vvs->msg_count == 0) {
>+		spin_unlock_bh(&vvs->rx_lock);
>+		return 0;
>+	}
>+
>+	while (!msg_ready) {
>+		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>+
>+		if (!copy_failed) {
>+			size_t pkt_len;
>+			size_t bytes_to_copy;
>+
>+			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>+			bytes_to_copy = min(user_buf_len, pkt_len);
>+
>+			if (bytes_to_copy) {
>+				int err;
>+
>+				/* sk_lock is held by caller so no one else can dequeue.
>+				 * Unlock rx_lock since memcpy_to_msg() may sleep.
>+				 */
>+				spin_unlock_bh(&vvs->rx_lock);
>+
>+				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
>+				if (err) {
>+					/* Copy of message failed, set flag to skip
>+					 * copy path for rest of fragments. Rest of
>+					 * fragments will be freed without copy.
>+					 */
>+					copy_failed = true;
>+					dequeued_len = err;

If we fail to copy the message we will discard the entire packet.
Is it acceptable for the user point of view, or we should leave the 
packet in the queue and the user can retry, maybe with a different 
buffer?

Then we can remove the packets only when we successfully copied all the 
fragments.

I'm not sure make sense, maybe better to check also other 
implementations :-)

Thanks,
Stefano

>+				} else {
>+					user_buf_len -= bytes_to_copy;
>+				}
>+
>+				spin_lock_bh(&vvs->rx_lock);
>+			}
>+
>+			if (dequeued_len >= 0)
>+				dequeued_len += pkt_len;
>+		}
>+
>+		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
>+			msg_ready = true;
>+			vvs->msg_count--;
>+		}
>+
>+		virtio_transport_dec_rx_pkt(vvs, pkt);
>+		list_del(&pkt->list);
>+		virtio_transport_free_pkt(pkt);
>+	}
>+
>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	virtio_transport_send_credit_update(vsk);
>+
>+	return dequeued_len;
>+}
>+
> ssize_t
> virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> 				struct msghdr *msg,
>@@ -405,6 +477,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> }
> EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
>
>+ssize_t
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags)
>+{
>+	if (flags & MSG_PEEK)
>+		return -EOPNOTSUPP;
>+
>+	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>+
> int
> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
>-- 
>2.25.1
>

