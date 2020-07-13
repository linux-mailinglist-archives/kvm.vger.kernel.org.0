Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C4E21D409
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 12:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgGMKyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 06:54:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34773 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729043AbgGMKyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 06:54:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594637689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0NLlKHEztDWyj5cXVFVh6qpf88cHYugGxDnOHI6njCI=;
        b=DB0zPGTa6Wq2+Q7g9DkAy1CqH6pMSftFU6pCGX8nhPGmV18xNPTNI8mPN0nOzXigrx2n2W
        7N8EXVA6u4Qq8J2nGQTekmCngnV155eqMhlNHWbYlkBae9j9THcJKZpuiV0wZJMxiCKWWh
        +9PxlqH8aZa8jg6+aAO72IHgTYpzP08=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-lHWhWgXZP7Gw3wGSvY4oXA-1; Mon, 13 Jul 2020 06:54:47 -0400
X-MC-Unique: lHWhWgXZP7Gw3wGSvY4oXA-1
Received: by mail-wr1-f70.google.com with SMTP id w4so17311273wrm.5
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 03:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0NLlKHEztDWyj5cXVFVh6qpf88cHYugGxDnOHI6njCI=;
        b=gwM0tcIRum0xHw7jpqnCW9QqyR1WJVLzECS9qrprNYR6PLR2y7447YXjS0/dxzVt6g
         gQajFuMEmWBdrkfXUaP9hbI7Z+hWdK5FMWs7/T8vKISXoVJcdQUmmUPyWEdmSl3rshAW
         huqWK3Qg2XKa18vPC8dQqdhpZA8bwrpFRiZYDW3jNYEMEcopiU8Mx00MHcZncCejn85/
         NpXH3GhupXLl6UVdcQ16niKcqADjwi7CXmgqFLlFwwn2xVypa3nci8uffw0r7xB4UTir
         GEtNnXbUWwtxTipovS6n9KHTBwYexAs1ktLejKvEk3gxXmO39bYhiThgUs6kx/Ssqbec
         Jcmw==
X-Gm-Message-State: AOAM531AUATsGQVIAOjv4dNeu3RmUsGFaOBTKdgDs5vTFTy+zp/f/7px
        6WcsiDGLK0wtYjSpFQgBHre3lzIdEtmNlf8oSejmPxVDPDPR2zU25VeMbnol7mZ1hOA1BoNxqCJ
        lZIgIT6pSfMem
X-Received: by 2002:adf:ce85:: with SMTP id r5mr87517231wrn.157.1594637686805;
        Mon, 13 Jul 2020 03:54:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAncOEl2kEHA0hOXAsJ7SmP/xoYe30HIdDfYymthuFQE102T/NGVomRy+ErWMsZJ86/tL52g==
X-Received: by 2002:adf:ce85:: with SMTP id r5mr87517218wrn.157.1594637686635;
        Mon, 13 Jul 2020 03:54:46 -0700 (PDT)
Received: from redhat.com (bzq-79-180-10-140.red.bezeqint.net. [79.180.10.140])
        by smtp.gmail.com with ESMTPSA id 1sm21378309wmf.0.2020.07.13.03.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 03:54:46 -0700 (PDT)
Date:   Mon, 13 Jul 2020 06:54:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     davem@davemloft.net, Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: annotate 'the_virtio_vsock' RCU pointer
Message-ID: <20200713065423-mutt-send-email-mst@kernel.org>
References: <20200710121243.120096-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710121243.120096-1-sgarzare@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 02:12:43PM +0200, Stefano Garzarella wrote:
> Commit 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free
> on the_virtio_vsock") starts to use RCU to protect 'the_virtio_vsock'
> pointer, but we forgot to annotate it.
> 
> This patch adds the annotation to fix the following sparse errors:
> 
>     net/vmw_vsock/virtio_transport.c:73:17: error: incompatible types in comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock [noderef] __rcu *
>     net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock *
>     net/vmw_vsock/virtio_transport.c:171:17: error: incompatible types in comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock [noderef] __rcu *
>     net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock *
>     net/vmw_vsock/virtio_transport.c:207:17: error: incompatible types in comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock [noderef] __rcu *
>     net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock *
>     net/vmw_vsock/virtio_transport.c:561:13: error: incompatible types in comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock [noderef] __rcu *
>     net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock *
>     net/vmw_vsock/virtio_transport.c:612:9: error: incompatible types in comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock [noderef] __rcu *
>     net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock *
>     net/vmw_vsock/virtio_transport.c:631:9: error: incompatible types in comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock [noderef] __rcu *
>     net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock *
> 
> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

who's merging this? Dave?

> ---
>  net/vmw_vsock/virtio_transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index dfbaf6bd8b1c..2700a63ab095 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -22,7 +22,7 @@
>  #include <net/af_vsock.h>
>  
>  static struct workqueue_struct *virtio_vsock_workqueue;
> -static struct virtio_vsock *the_virtio_vsock;
> +static struct virtio_vsock __rcu *the_virtio_vsock;
>  static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
>  
>  struct virtio_vsock {
> -- 
> 2.26.2

