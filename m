Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2C4318986
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 12:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhBKLbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 06:31:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhBKL22 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 06:28:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613042821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jsFQLvTrgFrLgJfF0P6gQ1rEY89A4uU+A6tP6gqPGzI=;
        b=P/AWAnsDlkB54rsucYvPDNL5IDsfno8iipUnpQboDUs9Vr8sy8BvV/BrOBKtcb6Y15D0xR
        X8f0Kas2F2CJZS8BC6+Qwx6F84LTElPL+J4TkqkLzUmRh9oraCpHoIpS7xICOPtg2BSbMe
        BO+w7QY8UpIXQjAZeqkOk/GXkpifqUk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-wDuwa_pUP9WKtTJLAP5vyA-1; Thu, 11 Feb 2021 06:24:10 -0500
X-MC-Unique: wDuwa_pUP9WKtTJLAP5vyA-1
Received: by mail-ej1-f71.google.com with SMTP id yd11so4621662ejb.9
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 03:24:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jsFQLvTrgFrLgJfF0P6gQ1rEY89A4uU+A6tP6gqPGzI=;
        b=bEQrd/Ehl/5DosWtIUl2Xl/xtHhdhbKXyu27Rop95e4Iv9vt1f74t+S76K9OkviCAS
         B+TY7kmci9EujHSCQdiK35oJ1NA2r/SMZ1K6H5/G9S4B9Gf8mAxQxZ0Z0emd7+YnSx4r
         KIyrbbxiMLQdh6dEf72mGVOqBQu1rqBgWI7PGCBaEf6kQg857WOrtaFFyLi8Jfpe2hWO
         bqjwjlkOZt5yFNmNgoKt8YlJXehu66onsBwiZO+n79dku5GerQxt9pFNyqW093jTm9Bg
         dxI3mxTqYTNKfgYRpHKsSzHFPM+e/Rvb4y+AoieT1xoibhX02H00JFendFdBGlOesBAZ
         /hmA==
X-Gm-Message-State: AOAM532fJyfcyjSHNNytw5yIxhoqR2JZWF1R4a7TRkV8UQMNhczAUIkg
        T6JeWH9KYHOnPvFvpU03yjQDgp6hlF2a9cEtooTS6HIpKP7l54LJN10U9IZJfBzhw+D/bBIrVb3
        VpGy8nw8Rsnbw
X-Received: by 2002:a17:906:2898:: with SMTP id o24mr7925101ejd.215.1613042649433;
        Thu, 11 Feb 2021 03:24:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1BcH+8XhReWwB41yfcl5jxF05aOvARXZuhUzHPDVsQ+y/97BjHWEuNLhAxUoPtrlmcVmcWQ==
X-Received: by 2002:a17:906:2898:: with SMTP id o24mr7925012ejd.215.1613042648077;
        Thu, 11 Feb 2021 03:24:08 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id u3sm3944113eje.63.2021.02.11.03.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 03:24:07 -0800 (PST)
Date:   Thu, 11 Feb 2021 12:24:04 +0100
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
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 02/17] af_vsock: separate wait data loop
Message-ID: <20210211112404.rwa55a6egstpskj2@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151451.804498-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151451.804498-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 07, 2021 at 06:14:48PM +0300, Arseny Krasnov wrote:
>This moves wait loop for data to dedicated function, because later
>it will be used by SEQPACKET data receive loop.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 158 +++++++++++++++++++++------------------
> 1 file changed, 86 insertions(+), 72 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f4fabec50650..38927695786f 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1833,6 +1833,71 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 	return err;
> }
>
>+static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
>+			   long timeout,
>+			   struct vsock_transport_recv_notify_data *recv_data,
>+			   size_t target)
>+{
>+	const struct vsock_transport *transport;
>+	struct vsock_sock *vsk;
>+	s64 data;
>+	int err;
>+
>+	vsk = vsock_sk(sk);
>+	err = 0;
>+	transport = vsk->transport;
>+	prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
>+
>+	while ((data = vsock_stream_has_data(vsk)) == 0) {
>+		if (sk->sk_err != 0 ||
>+		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>+		    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
>+			goto out;
>+		}
>+
>+		/* Don't wait for non-blocking sockets. */
>+		if (timeout == 0) {
>+			err = -EAGAIN;
>+			goto out;
>+		}
>+
>+		if (recv_data) {
>+			err = transport->notify_recv_pre_block(vsk, target, recv_data);
>+			if (err < 0)
>+				goto out;
>+		}
>+
>+		release_sock(sk);
>+		timeout = schedule_timeout(timeout);
>+		lock_sock(sk);
>+
>+		if (signal_pending(current)) {
>+			err = sock_intr_errno(timeout);
>+			goto out;
>+		} else if (timeout == 0) {
>+			err = -EAGAIN;
>+			goto out;
>+		}
>+	}
>+
>+	finish_wait(sk_sleep(sk), wait);
>+
>+	/* Invalid queue pair content. XXX This should
>+	 * be changed to a connection reset in a later
>+	 * change.
>+	 */
>+	if (data < 0)
>+		return -ENOMEM;
>+
>+	/* Have some data, return. */
>+	if (data)
>+		return data;

IIUC here data must be != 0 so you can simply return data in any case.

Or cleaner, you can do 'break' instead of 'goto out' in the error paths 
and after the while loop you can do something like this:

	finish_wait(sk_sleep(sk), wait);

	if (err)
		return err;

	if (data < 0)
		return -ENOMEM;

	return data;
}

>+
>+out:
>+	finish_wait(sk_sleep(sk), wait);
>+	return err;
>+}
>+
> static int
> vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 			  int flags)
>@@ -1912,85 +1977,34 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>
>
> 	while (1) {
>-		s64 ready;
>+		ssize_t read;
>
>-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
>-		ready = vsock_stream_has_data(vsk);
>-
>-		if (ready == 0) {
>-			if (sk->sk_err != 0 ||
>-			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>-			    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
>-				finish_wait(sk_sleep(sk), &wait);
>-				break;
>-			}
>-			/* Don't wait for non-blocking sockets. */
>-			if (timeout == 0) {
>-				err = -EAGAIN;
>-				finish_wait(sk_sleep(sk), &wait);
>-				break;
>-			}
>-
>-			err = transport->notify_recv_pre_block(
>-					vsk, target, &recv_data);
>-			if (err < 0) {
>-				finish_wait(sk_sleep(sk), &wait);
>-				break;
>-			}
>-			release_sock(sk);
>-			timeout = schedule_timeout(timeout);
>-			lock_sock(sk);
>-
>-			if (signal_pending(current)) {
>-				err = sock_intr_errno(timeout);
>-				finish_wait(sk_sleep(sk), &wait);
>-				break;
>-			} else if (timeout == 0) {
>-				err = -EAGAIN;
>-				finish_wait(sk_sleep(sk), &wait);
>-				break;
>-			}
>-		} else {
>-			ssize_t read;
>+		err = vsock_wait_data(sk, &wait, timeout, &recv_data, target);
>+		if (err <= 0)
>+			break;
>
>-			finish_wait(sk_sleep(sk), &wait);
>-
>-			if (ready < 0) {
>-				/* Invalid queue pair content. XXX This should
>-				* be changed to a connection reset in a later
>-				* change.
>-				*/
>-
>-				err = -ENOMEM;
>-				goto out;
>-			}
>-
>-			err = transport->notify_recv_pre_dequeue(
>-					vsk, target, &recv_data);
>-			if (err < 0)
>-				break;
>+		err = transport->notify_recv_pre_dequeue(vsk, target,
>+							 &recv_data);
>+		if (err < 0)
>+			break;
>
>-			read = transport->stream_dequeue(
>-					vsk, msg,
>-					len - copied, flags);
>-			if (read < 0) {
>-				err = -ENOMEM;
>-				break;
>-			}
>+		read = transport->stream_dequeue(vsk, msg, len - copied, flags);
>+		if (read < 0) {
>+			err = -ENOMEM;
>+			break;
>+		}
>
>-			copied += read;
>+		copied += read;
>
>-			err = transport->notify_recv_post_dequeue(
>-					vsk, target, read,
>-					!(flags & MSG_PEEK), &recv_data);
>-			if (err < 0)
>-				goto out;
>+		err = transport->notify_recv_post_dequeue(vsk, target, read,
>+						!(flags & MSG_PEEK), &recv_data);
>+		if (err < 0)
>+			goto out;
>
>-			if (read >= target || flags & MSG_PEEK)
>-				break;
>+		if (read >= target || flags & MSG_PEEK)
>+			break;
>
>-			target -= read;
>-		}
>+		target -= read;
> 	}

This part looks okay, maybe we could improve the loop a bit and make it 
more readable, but it's out of the scope of this patch.

Thanks,
Stefano

