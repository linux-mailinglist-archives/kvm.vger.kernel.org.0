Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4A3321556
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 12:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBVLpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 06:45:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229902AbhBVLp0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 06:45:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613994239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jMggRyrmt7rUz3sFUZulBpW7f6YfWViL3qR4aD0gP18=;
        b=Orbl4EtsY1JZOUmXtxtIA3MU2nsI0t+UwdKBj8T0RwI0v8lS2F1IeF2zt22XBuH4wG1pP7
        8Qb/qSS2UI4Si8Qi2ziGllF30tN4EonvzXtL39uzfw8hATKb/o6QaKBxzKz9IiPVCP6Tmt
        9j18fIv+E3nQbP/ubj3AvCfgRG9N5Qw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-JbnF2jhTPwSAOx9uHdS9GQ-1; Mon, 22 Feb 2021 06:43:57 -0500
X-MC-Unique: JbnF2jhTPwSAOx9uHdS9GQ-1
Received: by mail-wr1-f69.google.com with SMTP id u15so5948734wrn.3
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 03:43:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jMggRyrmt7rUz3sFUZulBpW7f6YfWViL3qR4aD0gP18=;
        b=VmczX3lTUwuEPMB8IHmEnKYCe9StHIrqm1/NtFcGG3hOwZ73R3IKq9jEUXtnxiMEgx
         mA3p2ySm9lBz8gRAy6OL8EvLiel3B6hl8LyNg9o0phieWqBLSrMeidoOTUOjpH+DjwmU
         shd9+VnjluIemiK0aXMJ/EvIQ5y6JI89PEl4Bn2eyUa1BUGreLQEioooKHvSwr/5BD4s
         xn3jbxNXKmElEWRLymzkuv8WGxco4lCLWQgmxLOAUelAkej0AqjORFPNi2aimVh4/hQN
         3qBq628Zsy3cWXGXBuAvCZLq3U3XmlMnxUg08lpn6nJFrnzjql44jGK/wrGuL3ZufCXu
         10rQ==
X-Gm-Message-State: AOAM530UXbNw+i5WF7d86u/SgLXTlDjuSe9+XH9jTPsw0aEkxjh6V4ZS
        jVGYoC/6whYAXMtcZ1UYwRXSetxm0T1faHnulyVTtI5DtjrU6jervigw3BQbt24CdRCZWuU312J
        sD2Qn2oxeEiWE
X-Received: by 2002:adf:a2c7:: with SMTP id t7mr21223398wra.42.1613994235725;
        Mon, 22 Feb 2021 03:43:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxh4bkeSBk/Aof8/0ud063mP9B8es8pjQc7OR5fltHgLTpr3ahl7wR4tuzSs4XfoCBOiy7e3A==
X-Received: by 2002:adf:a2c7:: with SMTP id t7mr21223379wra.42.1613994235557;
        Mon, 22 Feb 2021 03:43:55 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id h17sm20352349wrw.74.2021.02.22.03.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 03:43:55 -0800 (PST)
Date:   Mon, 22 Feb 2021 12:43:52 +0100
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
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 03/19] af_vsock: separate receive data loop
Message-ID: <20210222114352.u5byc3lbndwtorjo@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053653.1067086-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218053653.1067086-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021 at 08:36:50AM +0300, Arseny Krasnov wrote:
>This moves STREAM specific data receive logic to dedicated function:
>'__vsock_stream_recvmsg()', while checks that will be same for both
>types of socket are in shared function: 'vsock_connectible_recvmsg()'.

I'm not a native speaker, but I would rewrite this message like this:

Move STREAM specific data receive logic to '__vsock_stream_recvmsg()'
dedicated function, while checks, that will be same for both STREAM
and SEQPACKET sockets, stays in 'vsock_connectible_recvmsg()' shared
functions.

Anyway the patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 116 ++++++++++++++++++++++-----------------
> 1 file changed, 67 insertions(+), 49 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 6cf7bb977aa1..d277dc1cdbdf 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1894,65 +1894,22 @@ static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
> 	return data;
> }
>
>-static int
>-vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>-			  int flags)
>+static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>+				  size_t len, int flags)
> {
>-	struct sock *sk;
>-	struct vsock_sock *vsk;
>+	struct vsock_transport_recv_notify_data recv_data;
> 	const struct vsock_transport *transport;
>-	int err;
>-	size_t target;
>+	struct vsock_sock *vsk;
> 	ssize_t copied;
>+	size_t target;
> 	long timeout;
>-	struct vsock_transport_recv_notify_data recv_data;
>+	int err;
>
> 	DEFINE_WAIT(wait);
>
>-	sk = sock->sk;
> 	vsk = vsock_sk(sk);
>-	err = 0;
>-
>-	lock_sock(sk);
>-
> 	transport = vsk->transport;
>
>-	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
>-		/* Recvmsg is supposed to return 0 if a peer performs an
>-		 * orderly shutdown. Differentiate between that case and when a
>-		 * peer has not connected or a local shutdown occured 
>with the
>-		 * SOCK_DONE flag.
>-		 */
>-		if (sock_flag(sk, SOCK_DONE))
>-			err = 0;
>-		else
>-			err = -ENOTCONN;
>-
>-		goto out;
>-	}
>-
>-	if (flags & MSG_OOB) {
>-		err = -EOPNOTSUPP;
>-		goto out;
>-	}
>-
>-	/* We don't check peer_shutdown flag here since peer may actually shut
>-	 * down, but there can be data in the queue that a local socket can
>-	 * receive.
>-	 */
>-	if (sk->sk_shutdown & RCV_SHUTDOWN) {
>-		err = 0;
>-		goto out;
>-	}
>-
>-	/* It is valid on Linux to pass in a zero-length receive buffer.  This
>-	 * is not an error.  We may as well bail out now.
>-	 */
>-	if (!len) {
>-		err = 0;
>-		goto out;
>-	}
>-
> 	/* We must not copy less than target bytes into the user's buffer
> 	 * before returning successfully, so we wait for the consume queue to
> 	 * have that much data to consume before dequeueing.  Note that this
>@@ -2011,6 +1968,67 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	if (copied > 0)
> 		err = copied;
>
>+out:
>+	return err;
>+}
>+
>+static int
>+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>+			  int flags)
>+{
>+	struct sock *sk;
>+	struct vsock_sock *vsk;
>+	const struct vsock_transport *transport;
>+	int err;
>+
>+	DEFINE_WAIT(wait);
>+
>+	sk = sock->sk;
>+	vsk = vsock_sk(sk);
>+	err = 0;
>+
>+	lock_sock(sk);
>+
>+	transport = vsk->transport;
>+
>+	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
>+		/* Recvmsg is supposed to return 0 if a peer performs an
>+		 * orderly shutdown. Differentiate between that case and 
>when a
>+		 * peer has not connected or a local shutdown occurred with the
>+		 * SOCK_DONE flag.
>+		 */
>+		if (sock_flag(sk, SOCK_DONE))
>+			err = 0;
>+		else
>+			err = -ENOTCONN;
>+
>+		goto out;
>+	}
>+
>+	if (flags & MSG_OOB) {
>+		err = -EOPNOTSUPP;
>+		goto out;
>+	}
>+
>+	/* We don't check peer_shutdown flag here since peer may actually shut
>+	 * down, but there can be data in the queue that a local socket can
>+	 * receive.
>+	 */
>+	if (sk->sk_shutdown & RCV_SHUTDOWN) {
>+		err = 0;
>+		goto out;
>+	}
>+
>+	/* It is valid on Linux to pass in a zero-length receive buffer.  This
>+	 * is not an error.  We may as well bail out now.
>+	 */
>+	if (!len) {
>+		err = 0;
>+		goto out;
>+	}
>+
>+	err = __vsock_stream_recvmsg(sk, msg, len, flags);
>+
> out:
> 	release_sock(sk);
> 	return err;
>-- 
>2.25.1
>

