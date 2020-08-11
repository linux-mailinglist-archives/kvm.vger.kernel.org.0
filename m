Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64F524198E
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 12:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgHKKTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 06:19:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34346 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728456AbgHKKTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 06:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597141154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=09X4aaxeRy7786K3aAn8lJF+mFrpfZwelgc9Rj/h/cA=;
        b=TwOdQGiXLSb4+oIAcExRyiwB4IcCfCoDH4jsZSfk+ryJjqv8GR/VhXrbrmaNpP8a1u6mfD
        voukCYIj7YvzsUpGU+zx3hFpKyoSYGFd0Pmu/PSHcxxeN12E4Tn77yUCEAA25tzod6XNhK
        9PbaXKGnNYNXBkZZdD1qtKO29V38kBw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-zrUdDVx1PLa-5c6kohp1Kg-1; Tue, 11 Aug 2020 06:19:12 -0400
X-MC-Unique: zrUdDVx1PLa-5c6kohp1Kg-1
Received: by mail-wm1-f69.google.com with SMTP id z10so679856wmi.8
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 03:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=09X4aaxeRy7786K3aAn8lJF+mFrpfZwelgc9Rj/h/cA=;
        b=L4TvY2ClJNQ/Hpw1KTZuME2/g6ncuk/HpFcD4j12gNOHjHrAJmfaOEAWTkjtDJKOZY
         zuRkGUD5L2Fn7Efbycfi8qW3qsAS8b97D057uKKS31RjiI5yz/EDbnW8057VUlt5+R2B
         s6UUWYKFmCX0fB2Jqa2KqdT692wR4tkpDYw8AN5La9ztN8zQYLw1yju5ENRda54OMPr0
         LsOuySre9jKV2Sg/TPuBNlwfyyT6pn4eoHfZ2c4qvL3XpoJaoLCZQq3zKFMFqghaxme3
         rZ/apgQTAR0I/PJ1/4k1c+0UYeuTKk3b7rCVypSeJYk8x63lFIHtUnI1kNl7IqJmKZO9
         w01w==
X-Gm-Message-State: AOAM530fHk8yeOl0MfAiJmuikkM+68vGVuV50CEGVJAbP+bUb48/Wev+
        cjojPbPCS4sdAafLFT0Af+3otYyGQJK6Hl2URe6I/2VpVD3Fo5cnufIahbW23in3uKPHOi8y28g
        5L+qoO3ifvWA3
X-Received: by 2002:a5d:5588:: with SMTP id i8mr28830875wrv.177.1597141151442;
        Tue, 11 Aug 2020 03:19:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpVw0KHTkWj9zAvvQ6fy1E+bZP88HTv291tUDUPRHDJbOscx/iYuJW4Tswm9/demRPo6L7cQ==
X-Received: by 2002:a5d:5588:: with SMTP id i8mr28830856wrv.177.1597141151241;
        Tue, 11 Aug 2020 03:19:11 -0700 (PDT)
Received: from redhat.com (bzq-79-180-0-181.red.bezeqint.net. [79.180.0.181])
        by smtp.gmail.com with ESMTPSA id b11sm17091195wrq.32.2020.08.11.03.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 03:19:10 -0700 (PDT)
Date:   Tue, 11 Aug 2020 06:19:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eli@mellanox.com, lulu@redhat.com
Subject: Re: [PATCH] vhost: vdpa: remove per device feature whitelist
Message-ID: <20200811061840-mutt-send-email-mst@kernel.org>
References: <20200720085043.16485-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720085043.16485-1-jasowang@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 20, 2020 at 04:50:43PM +0800, Jason Wang wrote:
> We used to have a per device feature whitelist to filter out the
> unsupported virtio features. But this seems unnecessary since:
> 
> - the main idea behind feature whitelist is to block control vq
>   feature until we finalize the control virtqueue API. But the current
>   vhost-vDPA uAPI is sufficient to support control virtqueue. For
>   device that has hardware control virtqueue, the vDPA device driver
>   can just setup the hardware virtqueue and let userspace to use
>   hardware virtqueue directly. For device that doesn't have a control
>   virtqueue, the vDPA device driver need to use e.g vringh to emulate
>   a software control virtqueue.
> - we don't do it in virtio-vDPA driver
> 
> So remove this limitation.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>


Thinking about it, should we block some bits?
E.g. access_platform?
they depend on qemu not vdpa ...

> ---
>  drivers/vhost/vdpa.c | 37 -------------------------------------
>  1 file changed, 37 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 77a0c9fb6cc3..f7f6ddd681ce 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -26,35 +26,6 @@
>  
>  #include "vhost.h"
>  
> -enum {
> -	VHOST_VDPA_FEATURES =
> -		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> -		(1ULL << VIRTIO_F_ANY_LAYOUT) |
> -		(1ULL << VIRTIO_F_VERSION_1) |
> -		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
> -		(1ULL << VIRTIO_F_RING_PACKED) |
> -		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
> -		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> -		(1ULL << VIRTIO_RING_F_EVENT_IDX),
> -
> -	VHOST_VDPA_NET_FEATURES = VHOST_VDPA_FEATURES |
> -		(1ULL << VIRTIO_NET_F_CSUM) |
> -		(1ULL << VIRTIO_NET_F_GUEST_CSUM) |
> -		(1ULL << VIRTIO_NET_F_MTU) |
> -		(1ULL << VIRTIO_NET_F_MAC) |
> -		(1ULL << VIRTIO_NET_F_GUEST_TSO4) |
> -		(1ULL << VIRTIO_NET_F_GUEST_TSO6) |
> -		(1ULL << VIRTIO_NET_F_GUEST_ECN) |
> -		(1ULL << VIRTIO_NET_F_GUEST_UFO) |
> -		(1ULL << VIRTIO_NET_F_HOST_TSO4) |
> -		(1ULL << VIRTIO_NET_F_HOST_TSO6) |
> -		(1ULL << VIRTIO_NET_F_HOST_ECN) |
> -		(1ULL << VIRTIO_NET_F_HOST_UFO) |
> -		(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> -		(1ULL << VIRTIO_NET_F_STATUS) |
> -		(1ULL << VIRTIO_NET_F_SPEED_DUPLEX),
> -};
> -
>  /* Currently, only network backend w/o multiqueue is supported. */
>  #define VHOST_VDPA_VQ_MAX	2
>  
> @@ -79,10 +50,6 @@ static DEFINE_IDA(vhost_vdpa_ida);
>  
>  static dev_t vhost_vdpa_major;
>  
> -static const u64 vhost_vdpa_features[] = {
> -	[VIRTIO_ID_NET] = VHOST_VDPA_NET_FEATURES,
> -};
> -
>  static void handle_vq_kick(struct vhost_work *work)
>  {
>  	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> @@ -255,7 +222,6 @@ static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
>  	u64 features;
>  
>  	features = ops->get_features(vdpa);
> -	features &= vhost_vdpa_features[v->virtio_id];
>  
>  	if (copy_to_user(featurep, &features, sizeof(features)))
>  		return -EFAULT;
> @@ -279,9 +245,6 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
>  	if (copy_from_user(&features, featurep, sizeof(features)))
>  		return -EFAULT;
>  
> -	if (features & ~vhost_vdpa_features[v->virtio_id])
> -		return -EINVAL;
> -
>  	if (ops->set_features(vdpa, features))
>  		return -EINVAL;
>  
> -- 
> 2.20.1

