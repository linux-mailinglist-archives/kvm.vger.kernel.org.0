Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C854321580
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 12:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhBVLz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 06:55:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230006AbhBVLzK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 06:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613994819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uwBWTvI52wqLrpQP0Tt3FcCpkL+x02v8vMn3ChAyK8U=;
        b=LNzyHk06RiKCAYINq4QZC6lrPg5PEY6YZpEImEmS0/D8XG3uY5fW7Q/rwksbVthnqfN9Py
        Kqd08wUlhnBn0MDjHfY+HJnmEUZkNXGn0zbzgQYwlV/2Z/M7fBpN/qhtKFjBH2DbCMQ+QM
        cgSxxIyQ5o1XFWiGEeD8gKJS1F/VXoI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-X4x38_pYOySeZy3oRUqFyw-1; Mon, 22 Feb 2021 06:53:37 -0500
X-MC-Unique: X4x38_pYOySeZy3oRUqFyw-1
Received: by mail-wr1-f70.google.com with SMTP id j12so396143wrt.9
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 03:53:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uwBWTvI52wqLrpQP0Tt3FcCpkL+x02v8vMn3ChAyK8U=;
        b=EFJ4/hn2YdENAzqFiCeDjA2ScQanEQSkpCtSv24f9hBUxlhQEg5nwQVvU8hn2jE+9Q
         K9qzzNviXW6xGVez2Tjzv4bM+XWOLH09vs+WO69ne55V4YQTwMgwebP7+V7IWo8aKJ8M
         XXNivenQ0ZZ5IE7yPI0gSbRoAWh38+NvVRkluB4XnkD8/aLaWltAFRkFmhpapZVTZ2mQ
         pWkAgvEhWK3jzLw6Beo2MNjG2YaOX9fwuGukL3u2kiiM7W10bPNgcYE0dgTlhO4p7b8S
         qlBzZeJYdLPDC9a/qp3ML5bf3fsjoY+67QW2oICBQiTynzIpOWDm2TnM9xKeViQZwoVu
         xu2A==
X-Gm-Message-State: AOAM5310s2inLr02rEDkT5j/Bq3Seg6ny68XxAS62Sjp2isuNcbSljsr
        H+QFizyZ30RovQzdgCDaTQyUcaVfcub8Fz7Bm+8WDnSYDOkg7krBqQQiS3jFlZgvNFMvIldrF3S
        Pop3YHhEt3W3Q
X-Received: by 2002:adf:a2c7:: with SMTP id t7mr21259229wra.42.1613994816239;
        Mon, 22 Feb 2021 03:53:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwF3z2re71U2qX2sBvyIA4CC2xz2iu5FyqhwdzeqbDwD5LQo1ZoMCLS2hsoaBHr951kbzi9wg==
X-Received: by 2002:adf:a2c7:: with SMTP id t7mr21259216wra.42.1613994816075;
        Mon, 22 Feb 2021 03:53:36 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id v15sm28906877wra.61.2021.02.22.03.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 03:53:35 -0800 (PST)
Date:   Mon, 22 Feb 2021 12:53:32 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 04/19] af_vsock: implement SEQPACKET receive loop
Message-ID: <20210222115332.bmfwqzbytimk65ta@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053719.1067237-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218053719.1067237-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021 at 08:37:15AM +0300, Arseny Krasnov wrote:
>This adds receive loop for SEQPACKET. It looks like receive loop for
>STREAM, but there is a little bit difference:
>1) It doesn't call notify callbacks.
>2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>   there is no sense for these values in SEQPACKET case.
>3) It waits until whole record is received or error is found during
>   receiving.
>4) It processes and sets 'MSG_TRUNC' flag.
>
>So to avoid extra conditions for two types of socket inside one loop, two
>independent functions were created.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |  5 +++
> net/vmw_vsock/af_vsock.c | 97 +++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 101 insertions(+), 1 deletion(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index b1c717286993..01563338cc03 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -135,6 +135,11 @@ struct vsock_transport {
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>
>+	/* SEQ_PACKET. */
>+	size_t (*seqpacket_seq_get_len)(struct vsock_sock *vsk);
>+	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>+				     int flags, bool *msg_ready);

I think this should be:
	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
				 int flags, bool *msg_ready);

To avoid:
$ ./scripts/checkpatch.pl --strict -g HEAD
CHECK: Alignment should match open parenthesis
#35: FILE: include/net/af_vsock.h:141:
+	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
+				     int flags, bool *msg_ready);

>+
> 	/* Notification. */
> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d277dc1cdbdf..b754927a556a 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1972,6 +1972,98 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
> 	return err;
> }
>
>+static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>+				     size_t len, int flags)
>+{
>+	const struct vsock_transport *transport;
>+	const struct iovec *orig_iov;
>+	unsigned long orig_nr_segs;
>+	bool msg_ready;
>+	struct vsock_sock *vsk;
>+	size_t record_len;
>+	long timeout;
>+	int err = 0;
>+	DEFINE_WAIT(wait);
>+
>+	vsk = vsock_sk(sk);
>+	transport = vsk->transport;
>+
>+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>+	orig_nr_segs = msg->msg_iter.nr_segs;
>+	orig_iov = msg->msg_iter.iov;
>+	msg_ready = false;
>+	record_len = 0;
>+
>+	while (1) {
>+		err = vsock_wait_data(sk, &wait, timeout, NULL, 0);
>+
>+		if (err <= 0) {
>+			/* In case of any loop break(timeout, signal
>+			 * interrupt or shutdown), we report user that
>+			 * nothing was copied.
>+			 */
>+			err = 0;
>+			break;
>+		}
>+
>+		if (record_len == 0) {
>+			record_len =
>+				transport->seqpacket_seq_get_len(vsk);
>+
>+			if (record_len == 0)
>+				continue;
>+		}
>+
>+		err = transport->seqpacket_dequeue(vsk, msg,
>+					flags, &msg_ready);
>+

Sorry, I expressed myself wrong.

Here it's fine to avoid the blank line as in the previous version, by 
single line I meant the seqpacket_dequeue() call, something like this:

		err = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready);
		if (err < 0) {


>+		if (err < 0) {
>+			if (err == -EAGAIN) {
>+				iov_iter_init(&msg->msg_iter, READ,
>+					      orig_iov, orig_nr_segs,
>+					      len);
>+				/* Clear 'MSG_EOR' here, because dequeue
>+				 * callback above set it again if it was
>+				 * set by sender. This 'MSG_EOR' is from
>+				 * dropped record.
>+				 */
>+				msg->msg_flags &= ~MSG_EOR;
>+				record_len = 0;
>+				continue;
>+			}
>+
>+			err = -ENOMEM;
>+			break;
>+		}
>+
>+		if (msg_ready)
>+			break;
>+	}
>+
>+	if (sk->sk_err)
>+		err = -sk->sk_err;
>+	else if (sk->sk_shutdown & RCV_SHUTDOWN)
>+		err = 0;
>+
>+	if (msg_ready) {
>+		/* User sets MSG_TRUNC, so return real length of
>+		 * packet.
>+		 */
>+		if (flags & MSG_TRUNC)
>+			err = record_len;
>+		else
>+			err = len - msg->msg_iter.count;
>+
>+		/* Always set MSG_TRUNC if real length of packet is
>+		 * bigger than user's buffer.
>+		 */
>+		if (record_len > len)
>+			msg->msg_flags |= MSG_TRUNC;
>+	}
>+
>+	return err;
>+}
>+
> static int
> vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 			  int flags)
>@@ -2027,7 +2119,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 		goto out;
> 	}
>
>-	err = __vsock_stream_recvmsg(sk, msg, len, flags);
>+	if (sk->sk_type == SOCK_STREAM)
>+		err = __vsock_stream_recvmsg(sk, msg, len, flags);
>+	else
>+		err = __vsock_seqpacket_recvmsg(sk, msg, len, flags);
>
> out:
> 	release_sock(sk);
>-- 
>2.25.1
>

