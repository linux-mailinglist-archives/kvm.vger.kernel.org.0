Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258431F9C9F
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 18:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgFOQJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 12:09:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30666 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729280AbgFOQJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 12:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592237347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dD7tNXdGDRCEoYSmAc4X5T9NYduNoAow0i5S91tnK3o=;
        b=JdDIjnL635FoKGQqJ5ufsOKJ50SupFRGd5cXrq8GcHzYcLYoAIBPNhEMS7v5fC8d2OpxhJ
        NPYJntNnBYFWFhCWN0cwyD7M8skt0YHv70LoorEPrS7QHNzLa/wfR+Hn5SMhfmm331bEkQ
        OFux4B+uKaHs/qUTp3Tbr+nse3VkBUM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-Et1m2IniN1G53yalE6rpuQ-1; Mon, 15 Jun 2020 12:09:05 -0400
X-MC-Unique: Et1m2IniN1G53yalE6rpuQ-1
Received: by mail-qt1-f198.google.com with SMTP id y25so14365161qtb.6
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 09:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dD7tNXdGDRCEoYSmAc4X5T9NYduNoAow0i5S91tnK3o=;
        b=c+s56zgmoYDy14n5natDyT0AdIsvdBf9jGZab7arwHyq2d7FDwoaQOkxuQHXwYX0we
         CK/lm5R80agzuK3ZfRyZMbvjpQXF+/rQi+7NZQqdUsbb+550H+afWGWpseUuCaPBsptD
         XbaLaJKI0nEoZtUF1dIoY54FjKbkqxPLDunikh7qot+s9tY9JEre1OpiuBgbAkt32XQi
         5VYtmmJZMmg+o9Tm4ryDdG03DiGSAtqv+wEnmjfzgq1MQtxJXHuci/i/F6b1dKABig9L
         vUGeJ4hFMs/DWwhA2Hlh+i7HPLMzp8jhm51Lb6MNXc84nqTsbRfBVK/ehzm3Lj5ACRMz
         /mXA==
X-Gm-Message-State: AOAM533uPIiR3uyRVZIXBN2Jw7erTW9kLhoP6F3BOpdU4Oey3gOKPaCi
        AfQNuS2vjv0ygO5nhslolivjvJSJ8Dk5TnJhaEi8FPVrBRxbYAhIdpa2o7RcgP9Gxkln8D/uaDE
        +eH3YorjHUW/pSd9I1Dbpc+6srjLz
X-Received: by 2002:ac8:3f14:: with SMTP id c20mr16738147qtk.22.1592237344854;
        Mon, 15 Jun 2020 09:09:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpS1Kdurf9uTEpkOBlos6NoVuaASp8bWDmXIL5rXLq0vAjOs1nz+Kwx2KgvqKmP4AbnV8lx1ddDhVxBf3Hd1I=
X-Received: by 2002:ac8:3f14:: with SMTP id c20mr16738019qtk.22.1592237343340;
 Mon, 15 Jun 2020 09:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-4-mst@redhat.com>
In-Reply-To: <20200611113404.17810-4-mst@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 15 Jun 2020 18:08:27 +0200
Message-ID: <CAJaqyWfytTY7OvBdQNNPVDccvxbX4j-wmgUobU+OEYsOi77Mig@mail.gmail.com>
Subject: Re: [PATCH RFC v8 03/11] vhost/net: pass net specific struct pointer
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 1:34 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> In preparation for further cleanup, pass net specific pointer
> to ubuf callbacks so we can move net specific fields
> out to net structures.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/net.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index bf5e1d81ae25..ff594eec8ae3 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -94,7 +94,7 @@ struct vhost_net_ubuf_ref {
>          */
>         atomic_t refcount;
>         wait_queue_head_t wait;
> -       struct vhost_virtqueue *vq;
> +       struct vhost_net_virtqueue *nvq;
>  };
>
>  #define VHOST_NET_BATCH 64
> @@ -231,7 +231,7 @@ static void vhost_net_enable_zcopy(int vq)
>  }
>
>  static struct vhost_net_ubuf_ref *
> -vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
> +vhost_net_ubuf_alloc(struct vhost_net_virtqueue *nvq, bool zcopy)
>  {
>         struct vhost_net_ubuf_ref *ubufs;
>         /* No zero copy backend? Nothing to count. */
> @@ -242,7 +242,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>                 return ERR_PTR(-ENOMEM);
>         atomic_set(&ubufs->refcount, 1);
>         init_waitqueue_head(&ubufs->wait);
> -       ubufs->vq = vq;
> +       ubufs->nvq = nvq;
>         return ubufs;
>  }
>
> @@ -384,13 +384,13 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
>  static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>  {
>         struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
> -       struct vhost_virtqueue *vq = ubufs->vq;
> +       struct vhost_net_virtqueue *nvq = ubufs->nvq;
>         int cnt;
>
>         rcu_read_lock_bh();
>
>         /* set len to mark this desc buffers done DMA */
> -       vq->heads[ubuf->desc].len = success ?
> +       nvq->vq.heads[ubuf->desc].in_len = success ?

This change should access .len, not .in_len, until patch 6 (net:
convert to new API) in this series. Not very important, but make
easier to debug these intermediate commits.

Thanks!

>                 VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
>         cnt = vhost_net_ubuf_put(ubufs);
>
> @@ -402,7 +402,7 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>          * less than 10% of times).
>          */
>         if (cnt <= 1 || !(cnt % 16))
> -               vhost_poll_queue(&vq->poll);
> +               vhost_poll_queue(&nvq->vq.poll);
>
>         rcu_read_unlock_bh();
>  }
> @@ -1525,7 +1525,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>         /* start polling new socket */
>         oldsock = vhost_vq_get_backend(vq);
>         if (sock != oldsock) {
> -               ubufs = vhost_net_ubuf_alloc(vq,
> +               ubufs = vhost_net_ubuf_alloc(nvq,
>                                              sock && vhost_sock_zcopy(sock));
>                 if (IS_ERR(ubufs)) {
>                         r = PTR_ERR(ubufs);
> --
> MST
>

