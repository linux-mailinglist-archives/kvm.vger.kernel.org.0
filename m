Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C023EA02F
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 10:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbhHLIE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 04:04:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235159AbhHLIEV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 04:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628755417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VNcc4FKKgeh1x9olC7E03PuQx1nzor6Qv2O5Zs+wmJk=;
        b=Sf6Yikze2SB5zWc7S+RxoPEJejWvB6o+cAOzpKrwXSxN5aGpJr6evPRps168OBX5iSMU/4
        O+D62emJdqBKyer12IieSCYam4iSTsAoDWTPMj8PV92ZFkF8z2pFiS7/LZ/n/yR7vvs7mB
        Kxz56V2Zfipxnawki/74wTxTgCYcCFo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-11n09IlkPuOiieathTmCNA-1; Thu, 12 Aug 2021 04:03:36 -0400
X-MC-Unique: 11n09IlkPuOiieathTmCNA-1
Received: by mail-ed1-f71.google.com with SMTP id g3-20020a0564024243b02903be33db5ae6so2666537edb.18
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 01:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VNcc4FKKgeh1x9olC7E03PuQx1nzor6Qv2O5Zs+wmJk=;
        b=NmSdsF9RoyYzRWDv+Qxa8NOCWHiqPrqcGr75VfsX+4ZlxJUC7Pi59IHwN+Cd1Idi2V
         Z+gi+bWojo20tWVb/BCIxI+VggRj0AIF0EOKPSLPowCCjSdShjR6SUnkMNi/H+2gWJh/
         mc63iKTuH1KxGvNqP3PKfMaAvPyd+Fec3wfVvoJ0h1TrjGOwEOlUwK/zK6ruvdT6Wc1G
         dI4B3aPCJF4pSi9aHga8ITOtN5mCIwSQGzsPnRhDwJJ8VpvaEebRzzZ9YdpKHD5DfXxW
         E0Yd6twAdy+BvKNuqyexPpWJK9K1BuxaaK1OVyxfexH20Q5IPF3dKRgzHkJFioS+/FQX
         z1Kw==
X-Gm-Message-State: AOAM5324qsS9Cgw97x/qTB0g6MkGrWv1MK+OY0TNdeDf4IJx8gDhq3BP
        0fnlNQP98uSUCXt/RVZp4QioYu/bPbTMk5CLHrIxt6U1wiuAcDL3zVliSBkDUEaZjqqJFPcuEMF
        fLX/HAzr7X83X
X-Received: by 2002:a17:906:4750:: with SMTP id j16mr2439927ejs.26.1628755414887;
        Thu, 12 Aug 2021 01:03:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxU2tcTx6Y7xB9zzU+HQALuAB5KSTmssapC5dM7OHV8xYFOQBEDoFPmmXvbwzdWXnsrrWl5+w==
X-Received: by 2002:a17:906:4750:: with SMTP id j16mr2439913ejs.26.1628755414694;
        Thu, 12 Aug 2021 01:03:34 -0700 (PDT)
Received: from steredhat (host-79-36-51-142.retail.telecomitalia.it. [79.36.51.142])
        by smtp.gmail.com with ESMTPSA id k18sm752908edo.62.2021.08.12.01.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:03:34 -0700 (PDT)
Date:   Thu, 12 Aug 2021 10:03:32 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, arei.gonglei@huawei.com,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH resend] vsock/virtio: avoid potential deadlock when vsock
 device remove
Message-ID: <20210812080332.o4vxw72gn5uuqtik@steredhat>
References: <20210812053056.1699-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210812053056.1699-1-longpeng2@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12, 2021 at 01:30:56PM +0800, Longpeng(Mike) wrote:
>There's a potential deadlock case when remove the vsock device or
>process the RESET event:
>
>  vsock_for_each_connected_socket:
>      spin_lock_bh(&vsock_table_lock) ----------- (1)
>      ...
>          virtio_vsock_reset_sock:
>              lock_sock(sk) --------------------- (2)
>      ...
>      spin_unlock_bh(&vsock_table_lock)
>
>lock_sock() may do initiative schedule when the 'sk' is owned by
>other thread at the same time, we would receivce a warning message
>that "scheduling while atomic".
>
>Even worse, if the next task (selected by the scheduler) try to
>release a 'sk', it need to request vsock_table_lock and the deadlock
>occur, cause the system into softlockup state.
>  Call trace:
>   queued_spin_lock_slowpath
>   vsock_remove_bound
>   vsock_remove_sock
>   virtio_transport_release
>   __vsock_release
>   vsock_release
>   __sock_release
>   sock_close
>   __fput
>   ____fput
>
>So we should not require sk_lock in this case, just like the behavior
>in vhost_vsock or vmci.

The difference with vhost_vsock is that here we call it also when we 
receive an event in the event queue (for example because we are 
migrating the VM).

I think the idea of this lock was to prevent concurrency with RX loop, 
but actually if a socket is connected, it can only change state to 
TCP_CLOSING/TCP_CLOSE.

I don't think there is any problem not to take the lock, at most we 
could take the rx_lock in virtio_vsock_event_handle(), but I'm not sure 
it's necessary.

>
>Cc: Stefan Hajnoczi <stefanha@redhat.com>
>Cc: Stefano Garzarella <sgarzare@redhat.com>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>

We should add:
Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
>Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
>---
> net/vmw_vsock/virtio_transport.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index e0c2c99..4f7c99d 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -357,11 +357,14 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
>
> static void virtio_vsock_reset_sock(struct sock *sk)
> {
>-	lock_sock(sk);
>+	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
>+	 * under vsock_table_lock so the sock cannot disappear while 
>we're
>+	 * executing.
>+	 */
>+
> 	sk->sk_state = TCP_CLOSE;
> 	sk->sk_err = ECONNRESET;
> 	sk_error_report(sk);
>-	release_sock(sk);
> }
>
> static void virtio_vsock_update_guest_cid(struct virtio_vsock *vsock)
>-- 
>1.8.3.1
>

With the Fixes tag added:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

