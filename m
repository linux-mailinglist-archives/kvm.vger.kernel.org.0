Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA2337F831
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 14:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbhEMMuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 08:50:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233926AbhEMMua (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 08:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620910160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NSrjqlQIJu1uxoxnuhMrvLQLzbH8gXslRcYpELalTPg=;
        b=YCEAV+0y9b985FQWDJn3BRHGW9DAMCv/++GbhFbSfvAKY0skDqaoX2785CaDMHtoE3LVvP
        rhW0lo+m9tRXdZxiPeJHmqFiZtByfnInYkKhNEzjT2gAUdrilv61YcFwvfsu5n4gh83aow
        gBFd1rGkIn6hVGPYXYAYsHvOtCI659M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-hHBU4RdiPW2CWjoksOPWTg-1; Thu, 13 May 2021 08:49:16 -0400
X-MC-Unique: hHBU4RdiPW2CWjoksOPWTg-1
Received: by mail-ed1-f69.google.com with SMTP id y15-20020aa7d50f0000b02903885ee98723so14514745edq.16
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 05:49:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NSrjqlQIJu1uxoxnuhMrvLQLzbH8gXslRcYpELalTPg=;
        b=SctTlcBmwKDA59WmB9t7gJqAgSOG++KV2C4nJT0Rshi16F0CzQ5ATuhGdg+3/FlcrJ
         PUvc//afQiAW1vgFf8IPqKGgF5rmku9P0Gpea4fscFKXoP3ong6BN4wnYH4xH5wVFXCQ
         ABkZJQ3CrcDsQ+f2VYw8Rgty1JZsDsKy2QlsWhBWzKfzq+0gwQ5jPBtB3kGR8M/KVpJ5
         HLCRSoWf3obSkM89VI1v1xoJKDhHBMc77cgw4yaxxrJFEcOLdEHW/p0oCutrc4XRoQaB
         7SvSKMt88GHqvX4jVWdVqlLYSqK0eX1gim/22mmAu2lCe0EDiSLXx/4ihcHiP9ZBbwmc
         6u1Q==
X-Gm-Message-State: AOAM530RkaTl7CY/w6TQqWbs/6rz7J4K/kTFjCu/YiauIZxMFU5B0Dif
        1J1roHBbZZoiipareWRiLtYwaOQztN9Q1D5qxapv6wQg0QzWlNunAkycYA4f9yCzV2mOR54h92P
        E2qOTq1KP/5gE
X-Received: by 2002:a17:906:144d:: with SMTP id q13mr45360839ejc.458.1620910155410;
        Thu, 13 May 2021 05:49:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoWSdvzLm133gY1yGZQzxSLocSHvkGSmNAzGowvENZeAXfZJswxcWVjdFLnXw30TfArShrKw==
X-Received: by 2002:a17:906:144d:: with SMTP id q13mr45360828ejc.458.1620910155258;
        Thu, 13 May 2021 05:49:15 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id j22sm1873651ejt.11.2021.05.13.05.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:49:14 -0700 (PDT)
Date:   Thu, 13 May 2021 14:49:12 +0200
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
Subject: Re: [RFC PATCH v9 14/19] virtio/vsock: enable SEQPACKET for transport
Message-ID: <20210513124912.sw4rea75re7xwjdz@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163617.3432380-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163617.3432380-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 08, 2021 at 07:36:14PM +0300, Arseny Krasnov wrote:
>This adds
>1) SEQPACKET ops for virtio transport and 'seqpacket_allow()' callback.
>2) Handling of SEQPACKET bit: guest tries to negotiate it with vhost.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v8 -> v9:
> 1) Move 'seqpacket_allow' to 'struct virtio_vsock'.
>
> net/vmw_vsock/virtio_transport.c | 25 +++++++++++++++++++++++++
> 1 file changed, 25 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 2700a63ab095..f714c16af65d 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -62,6 +62,7 @@ struct virtio_vsock {
> 	struct virtio_vsock_event event_list[8];
>
> 	u32 guest_cid;
>+	bool seqpacket_allow;
> };
>
> static u32 virtio_transport_get_local_cid(void)
>@@ -443,6 +444,8 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
> 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> }
>
>+static bool virtio_transport_seqpacket_allow(u32 remote_cid);
>+
> static struct virtio_transport virtio_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>@@ -469,6 +472,10 @@ static struct virtio_transport virtio_transport = {
> 		.stream_is_active         = virtio_transport_stream_is_active,
> 		.stream_allow             = virtio_transport_stream_allow,
>
>+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>+		.seqpacket_allow          = virtio_transport_seqpacket_allow,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>@@ -485,6 +492,19 @@ static struct virtio_transport virtio_transport = {
> 	.send_pkt = virtio_transport_send_pkt,
> };
>
>+static bool virtio_transport_seqpacket_allow(u32 remote_cid)
>+{
>+	struct virtio_vsock *vsock;
>+	bool seqpacket_allow;
>+
>+	rcu_read_lock();
>+	vsock = rcu_dereference(the_virtio_vsock);
>+	seqpacket_allow = vsock->seqpacket_allow;
>+	rcu_read_unlock();
>+
>+	return seqpacket_allow;
>+}
>+
> static void virtio_transport_rx_work(struct work_struct *work)
> {
> 	struct virtio_vsock *vsock =
>@@ -612,6 +632,10 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	rcu_assign_pointer(the_virtio_vsock, vsock);
>
> 	mutex_unlock(&the_virtio_vsock_mutex);
>+
>+	if (vdev->features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))

We should use virtio_has_feature() to check the device features.

>+		vsock->seqpacket_allow = true;

When we assign the_virtio_vsock pointer, we should already set all the 
fields, so please move this code before the following block:

	# here

	vdev->priv = vsock;
	rcu_assign_pointer(the_virtio_vsock, vsock);

