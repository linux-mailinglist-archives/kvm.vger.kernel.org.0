Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC71F348E41
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 11:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCYKmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 06:42:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31911 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhCYKmM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 06:42:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616668931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aQDI6ul2y7LDTOrys0NWj2wyx1hXa7tSyglML0bhC18=;
        b=KchhdeGfkta7UjzBaNgoi/j/pZtgG3NjgR/rt4JDX9XQs3yTi5JPYx9IM09ZgE6hAVSQtg
        KgxiMfUZcsPp5Af0VB0rF/git+pGcnFQFcGXJSuKkcBA8CVMXYbAz4yTelCXDq90YbK1Yx
        DtZbxLoa/WeTwt0nEJknzAbmRZiWBj0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-v38UAsDMOhCBLF6Gsm3-Pw-1; Thu, 25 Mar 2021 06:42:09 -0400
X-MC-Unique: v38UAsDMOhCBLF6Gsm3-Pw-1
Received: by mail-wr1-f70.google.com with SMTP id p12so2441860wrn.18
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 03:42:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aQDI6ul2y7LDTOrys0NWj2wyx1hXa7tSyglML0bhC18=;
        b=StEcKGQIgtBJ8qX6JDhQ8utJeTGzmVmKQLmhMvw2gKJxitpZKUsIFCacTVjvuwGTJj
         zjQpLvUjOfPJfG+ELa5fKZpby1DfZaR5UaaeAHfBD8NWTh2/tvsELrqnS1X29MM1YMlp
         42x4ycc6n86nRXeijIq+wajBxWA1n1aJGpy1TZdPcPnrLMyh7NPKC/l8iBAw4clIoxLc
         R1AJrRmb80x4SBxwz21+fvXRnZOYAY3d4u989UKaObszJJu7mjCPTcL23J4p5hDCfoWM
         IAvRBSkwG1dCFZc6q+F0P21kf/RMagg3pVrcH1hNR8bm+WcvaXrVZOyvvPy7WnO9/bU5
         XYWw==
X-Gm-Message-State: AOAM531uzMldIPJWjfhUdefYQm9Mv19YS3o4kw7w50NygVLA/st5cDNQ
        CW0pmJ1+zozOX4eXoiNbzO0uFM55es72wxmYuWqIlGHoHVNji7x0ApcxAbKlfHVuf1zevVhG871
        dT1ZH285pawQl
X-Received: by 2002:a05:600c:3506:: with SMTP id h6mr7332004wmq.168.1616668928292;
        Thu, 25 Mar 2021 03:42:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzG/dVJd/zV/tTUYY28Q+C/IDwYWmzMmVdSbdEw8RE1Cc5u1xVljyOZijxgygq5uU0DSr+VGA==
X-Received: by 2002:a05:600c:3506:: with SMTP id h6mr7331961wmq.168.1616668927966;
        Thu, 25 Mar 2021 03:42:07 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id p18sm6580970wrs.68.2021.03.25.03.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 03:42:07 -0700 (PDT)
Date:   Thu, 25 Mar 2021 11:42:05 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v7 17/22] vhost/vsock: setup SEQPACKET ops for
 transport
Message-ID: <20210325104205.y5z6qjv5g2kzvj3m@steredhat>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131421.2461760-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210323131421.2461760-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 04:14:18PM +0300, Arseny Krasnov wrote:
>This also removes ignore of non-stream type of packets and adds
>'seqpacket_allow()' callback.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> drivers/vhost/vsock.c | 15 +++++++++++++--
> 1 file changed, 13 insertions(+), 2 deletions(-)

Same thing for this transporter too, maybe we can merge with the patch 
"vhost/vsock: SEQPACKET feature bit support".

Stefano

>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 5e78fb719602..5af141772068 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -354,8 +354,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> 		return NULL;
> 	}
>
>-	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
>-		pkt->len = le32_to_cpu(pkt->hdr.len);
>+	pkt->len = le32_to_cpu(pkt->hdr.len);
>
> 	/* No payload */
> 	if (!pkt->len)
>@@ -398,6 +397,8 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
> 	return val < vq->num;
> }
>
>+static bool vhost_transport_seqpacket_allow(void);
>+
> static struct virtio_transport vhost_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>@@ -424,6 +425,10 @@ static struct virtio_transport vhost_transport = {
> 		.stream_is_active         = virtio_transport_stream_is_active,
> 		.stream_allow             = virtio_transport_stream_allow,
>
>+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>+		.seqpacket_allow          = vhost_transport_seqpacket_allow,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>@@ -439,8 +444,14 @@ static struct virtio_transport vhost_transport = {
> 	},
>
> 	.send_pkt = vhost_transport_send_pkt,
>+	.seqpacket_allow = false
> };
>
>+static bool vhost_transport_seqpacket_allow(void)
>+{
>+	return vhost_transport.seqpacket_allow;
>+}
>+
> static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> {
> 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
>-- 
>2.25.1
>

