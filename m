Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295A71F576A
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 17:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgFJPOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 11:14:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40279 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730069AbgFJPN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 11:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591802037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCaS5B0zDLBWnfrEXUqdrW0d6LJpY2CfoA/LuwizqL4=;
        b=ZMtz6rcP1BH2V2oQ7DxQ1qHmxqleA5BP4laxIstoQkbYO94gjJAHwWjB2o+D1i4CdEBj3i
        Khcu5PIwE0QhAncaKqTwaRLAOh3z4s91ezND1YFvk0rxd8cJ9BOED5QI8x4kMQHomdqZxw
        6iA1NfR3JHDWN9gVYmz/C2eTWIXyJ/I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-VLXHFvIgO2Ogl59V62vIhg-1; Wed, 10 Jun 2020 11:13:53 -0400
X-MC-Unique: VLXHFvIgO2Ogl59V62vIhg-1
Received: by mail-wr1-f71.google.com with SMTP id e1so1224978wrm.3
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 08:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UCaS5B0zDLBWnfrEXUqdrW0d6LJpY2CfoA/LuwizqL4=;
        b=eKqDX9TguDksXJ1n77eJjgqBeBdhyeJuo3GS0lmea5W8A1S7gyKAv8AA4m4ojQ7WZk
         aelkUp+ILqMZHgnGJiB9BeNZ9CZXEpV/gsg+3M3MCdQFUBgkS4Ete4krz3kDZRgWmLge
         l1y+h+L/F7wyJCAuBM6LQVmi5X/zG+RP4UrKMzo5CiLGwJMsV41zRVzsnQvOBpLYrmVD
         P5kbt/xxFtJOjNtaVGqx5M+AvB92+HMNgySKrfvc1/myk2cEvNIXDEhhk//twkRGKcxd
         t3gBlV4ZqmK3LOxqvyK/rhlVFuQkdVkApUbExh/EeqY9izRYt2RC1HURTcAYX1HaYe5u
         KCsg==
X-Gm-Message-State: AOAM5300nv1EFIM2sfx4XETB+3ioGy0ET422sllwRC/6YzQcuTla45L0
        3MUO5PWgUHsy7P97QK5lbNyRzmKV8OyX1vemlbTWCEc0ht3RTw/pLgDmYXHeD4F1tOoTUEZesQn
        Z3+81GX9UFiq0
X-Received: by 2002:adf:e285:: with SMTP id v5mr4183932wri.129.1591802031334;
        Wed, 10 Jun 2020 08:13:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5S2qkrPk2gAmC4EmpHPkNmzHg3zetZnJqn/ot/vPFPTwl3usyYGmWEmhMX3VrjvnwAgO0OQ==
X-Received: by 2002:adf:e285:: with SMTP id v5mr4183909wri.129.1591802031104;
        Wed, 10 Jun 2020 08:13:51 -0700 (PDT)
Received: from eperezma.remote.csb (109.141.78.188.dynamic.jazztel.es. [188.78.141.109])
        by smtp.gmail.com with ESMTPSA id u12sm102944wrq.90.2020.06.10.08.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 08:13:50 -0700 (PDT)
Message-ID: <f2e20055215fcfb63eb4839644c1578b21aeded9.camel@redhat.com>
Subject: Re: [PATCH RFC v7 04/14] vhost/net: pass net specific struct pointer
From:   Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Date:   Wed, 10 Jun 2020 17:13:48 +0200
In-Reply-To: <20200610113515.1497099-5-mst@redhat.com>
References: <20200610113515.1497099-1-mst@redhat.com>
         <20200610113515.1497099-5-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-06-10 at 07:36 -0400, Michael S. Tsirkin wrote:
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
>  	 */
>  	atomic_t refcount;
>  	wait_queue_head_t wait;
> -	struct vhost_virtqueue *vq;
> +	struct vhost_net_virtqueue *nvq;
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
>  	struct vhost_net_ubuf_ref *ubufs;
>  	/* No zero copy backend? Nothing to count. */
> @@ -242,7 +242,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>  		return ERR_PTR(-ENOMEM);
>  	atomic_set(&ubufs->refcount, 1);
>  	init_waitqueue_head(&ubufs->wait);
> -	ubufs->vq = vq;
> +	ubufs->nvq = nvq;
>  	return ubufs;
>  }
>  
> @@ -384,13 +384,13 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
>  static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>  {
>  	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
> -	struct vhost_virtqueue *vq = ubufs->vq;
> +	struct vhost_net_virtqueue *nvq = ubufs->nvq;
>  	int cnt;
>  
>  	rcu_read_lock_bh();
>  
>  	/* set len to mark this desc buffers done DMA */
> -	vq->heads[ubuf->desc].len = success ?
> +	nvq->vq.heads[ubuf->desc].in_len = success ?

Not like this matter a lot, because it will be override in next patches of the series, but `.len` has been replaced by
`.in_len`, making compiler complain. This fixes it:

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index ff594eec8ae3..fdecf39c9ac9 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -390,7 +390,7 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
        rcu_read_lock_bh();
 
        /* set len to mark this desc buffers done DMA */
-       nvq->vq.heads[ubuf->desc].in_len = success ?
+       nvq->vq.heads[ubuf->desc].len = success ?
                VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
        cnt = vhost_net_ubuf_put(ubufs);

>  		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
>  	cnt = vhost_net_ubuf_put(ubufs);
>  
> @@ -402,7 +402,7 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>  	 * less than 10% of times).
>  	 */
>  	if (cnt <= 1 || !(cnt % 16))
> -		vhost_poll_queue(&vq->poll);
> +		vhost_poll_queue(&nvq->vq.poll);
>  
>  	rcu_read_unlock_bh();
>  }
> @@ -1525,7 +1525,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  	/* start polling new socket */
>  	oldsock = vhost_vq_get_backend(vq);
>  	if (sock != oldsock) {
> -		ubufs = vhost_net_ubuf_alloc(vq,
> +		ubufs = vhost_net_ubuf_alloc(nvq,
>  					     sock && vhost_sock_zcopy(sock));
>  		if (IS_ERR(ubufs)) {
>  			r = PTR_ERR(ubufs);

