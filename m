Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A9F3F52B8
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 23:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhHWVUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 17:20:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232834AbhHWVUs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 17:20:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629753605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lbEqjMJoQt3yLrlY+GFqpGqyp8tEIHBCyDKiHKEv/pY=;
        b=aL/uDhgq/+rvvrZVktrT1q1t4EOnPJstI74WlbX/VCv5LljRMUxiHrHgii+FwCI5nex7db
        gwnBWdHlF7tPrjbZSmM5xWUHTkm3DxIoqmMsnadOJMHDNVwPZJUeOuHfMcLVq/vTOqaJc8
        Pab/dRTjyXhBynlHBWtzweqgSmmL2JY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-jcXEcHIpMvuQZOfNt33EQg-1; Mon, 23 Aug 2021 17:20:03 -0400
X-MC-Unique: jcXEcHIpMvuQZOfNt33EQg-1
Received: by mail-ej1-f71.google.com with SMTP id k12-20020a170906680cb02905aeccdbd1efso6194349ejr.9
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 14:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lbEqjMJoQt3yLrlY+GFqpGqyp8tEIHBCyDKiHKEv/pY=;
        b=rjmzacZWmyUqq2nWFPzDudI95IjgL7NmsR+o/odOJPI02e2e0eZ8482+cEoECiIjmL
         59ph6MLA2bOLD+04Y+esxoVO3xwWRteeHkr68WEyTn5ruiviTJGeISC7Rk8OfL4V0vBm
         F7pZxzgYoOAfXqcKVWkHxAzQn9BBSoG2MHE04PH/DPSL2OghXQUc/XqJPup7a0d00Wz8
         7kL1Mcokgmyy13etjoLOVagbl0Gh9LYvGgK/fCsudya6NzjC0wSXoF6ke3xWQsbcqYBP
         y/+SNvkS7z3Bh5PXvi9Sxew8/ZvP2wf56IhKvUCpDg9syjm0QnRxVcc3MBmpkIXJA+Uc
         WEgQ==
X-Gm-Message-State: AOAM532OYgppTYRhEXw7o5H/DW5KCTEEipG0Okm3f+QStfrbQdyIQ54a
        HLuwk691BKvZtSmYx+3jZ7Qr6y3OPLqgGKl49wtoIYUpnD3pOpJGzgh1GBp7wZ0ZiTE7d8Casks
        Vm7/B1SMWsgFw
X-Received: by 2002:a17:906:3e59:: with SMTP id t25mr37538275eji.24.1629753601626;
        Mon, 23 Aug 2021 14:20:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzIHZ0Z0HNuaN8AoD24ulxJU892EPBBSYFsufMqZCOer/+b6UyS89yQ4kH2OcGDMz/lsPACw==
X-Received: by 2002:a17:906:3e59:: with SMTP id t25mr37538256eji.24.1629753601471;
        Mon, 23 Aug 2021 14:20:01 -0700 (PDT)
Received: from redhat.com ([2.55.137.225])
        by smtp.gmail.com with ESMTPSA id t1sm5488155edq.31.2021.08.23.14.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 14:20:00 -0700 (PDT)
Date:   Mon, 23 Aug 2021 17:19:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     Jason Wang <jasowang@redhat.com>, kernel@axis.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: add support for mandatory barriers
Message-ID: <20210823171609-mutt-send-email-mst@kernel.org>
References: <20210823081437.14274-1-vincent.whitchurch@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823081437.14274-1-vincent.whitchurch@axis.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 23, 2021 at 10:14:37AM +0200, Vincent Whitchurch wrote:
> vhost always uses SMP-conditional barriers, but these may not be
> sufficient when vhost is used to communicate between heterogeneous
> processors in an AMP configuration, especially since they're NOPs on
> !SMP builds.
> 
> To solve this, use the virtio_*() barrier functions and ask them for
> non-weak barriers if requested by userspace.
> 
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>

I am inclined to say let's (ab)use VIRTIO_F_ORDER_PLATFORM for this.
Jason what do you think?

Also is the use of DMA variants really the intended thing here? Could
you point me at some examples please?


> ---
>  drivers/vhost/vhost.c      | 23 ++++++++++++++---------
>  drivers/vhost/vhost.h      |  2 ++
>  include/uapi/linux/vhost.h |  2 ++
>  3 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b9e853e6094d..f7172e1bc395 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -500,6 +500,7 @@ void vhost_dev_init(struct vhost_dev *dev,
>  		vq->indirect = NULL;
>  		vq->heads = NULL;
>  		vq->dev = dev;
> +		vq->weak_barriers = true;
>  		mutex_init(&vq->mutex);
>  		vhost_vq_reset(dev, vq);
>  		if (vq->handle_kick)
> @@ -1801,6 +1802,10 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
>  		if (ctx)
>  			eventfd_ctx_put(ctx);
>  		break;
> +	case VHOST_SET_STRONG_BARRIERS:
> +		for (i = 0; i < d->nvqs; ++i)
> +			d->vqs[i]->weak_barriers = false;
> +		break;
>  	default:
>  		r = -ENOIOCTLCMD;
>  		break;
> @@ -1927,7 +1932,7 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
>  	int i, r;
>  
>  	/* Make sure data written is seen before log. */
> -	smp_wmb();
> +	virtio_wmb(vq->weak_barriers);
>  
>  	if (vq->iotlb) {
>  		for (i = 0; i < count; i++) {
> @@ -1964,7 +1969,7 @@ static int vhost_update_used_flags(struct vhost_virtqueue *vq)
>  		return -EFAULT;
>  	if (unlikely(vq->log_used)) {
>  		/* Make sure the flag is seen before log. */
> -		smp_wmb();
> +		virtio_wmb(vq->weak_barriers);
>  		/* Log used flag write. */
>  		used = &vq->used->flags;
>  		log_used(vq, (used - (void __user *)vq->used),
> @@ -1982,7 +1987,7 @@ static int vhost_update_avail_event(struct vhost_virtqueue *vq, u16 avail_event)
>  	if (unlikely(vq->log_used)) {
>  		void __user *used;
>  		/* Make sure the event is seen before log. */
> -		smp_wmb();
> +		virtio_wmb(vq->weak_barriers);
>  		/* Log avail event write */
>  		used = vhost_avail_event(vq);
>  		log_used(vq, (used - (void __user *)vq->used),
> @@ -2228,7 +2233,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>  		/* Only get avail ring entries after they have been
>  		 * exposed by guest.
>  		 */
> -		smp_rmb();
> +		virtio_rmb(vq->weak_barriers);
>  	}
>  
>  	/* Grab the next descriptor number they're advertising, and increment
> @@ -2367,7 +2372,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>  	}
>  	if (unlikely(vq->log_used)) {
>  		/* Make sure data is seen before log. */
> -		smp_wmb();
> +		virtio_wmb(vq->weak_barriers);
>  		/* Log used ring entry write. */
>  		log_used(vq, ((void __user *)used - (void __user *)vq->used),
>  			 count * sizeof *used);
> @@ -2402,14 +2407,14 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
>  	r = __vhost_add_used_n(vq, heads, count);
>  
>  	/* Make sure buffer is written before we update index. */
> -	smp_wmb();
> +	virtio_wmb(vq->weak_barriers);
>  	if (vhost_put_used_idx(vq)) {
>  		vq_err(vq, "Failed to increment used idx");
>  		return -EFAULT;
>  	}
>  	if (unlikely(vq->log_used)) {
>  		/* Make sure used idx is seen before log. */
> -		smp_wmb();
> +		virtio_wmb(vq->weak_barriers);
>  		/* Log used index update. */
>  		log_used(vq, offsetof(struct vring_used, idx),
>  			 sizeof vq->used->idx);
> @@ -2428,7 +2433,7 @@ static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>  	/* Flush out used index updates. This is paired
>  	 * with the barrier that the Guest executes when enabling
>  	 * interrupts. */
> -	smp_mb();
> +	virtio_mb(vq->weak_barriers);
>  
>  	if (vhost_has_feature(vq, VIRTIO_F_NOTIFY_ON_EMPTY) &&
>  	    unlikely(vq->avail_idx == vq->last_avail_idx))
> @@ -2530,7 +2535,7 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>  	}
>  	/* They could have slipped one in as we were doing that: make
>  	 * sure it's written, then check again. */
> -	smp_mb();
> +	virtio_mb(vq->weak_barriers);
>  	r = vhost_get_avail_idx(vq, &avail_idx);
>  	if (r) {
>  		vq_err(vq, "Failed to check avail idx at %p: %d\n",
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 638bb640d6b4..5bd20d0db457 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -108,6 +108,8 @@ struct vhost_virtqueue {
>  	bool log_used;
>  	u64 log_addr;
>  
> +	bool weak_barriers;
> +
>  	struct iovec iov[UIO_MAXIOV];
>  	struct iovec iotlb_iov[64];
>  	struct iovec *indirect;
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index c998860d7bbc..4b8656307f51 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -97,6 +97,8 @@
>  #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
>  #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
>  
> +#define VHOST_SET_STRONG_BARRIERS _IO(VHOST_VIRTIO, 0x27)
> +
>  /* VHOST_NET specific defines */
>  
>  /* Attach virtio net ring to a raw socket, or tap device.
> -- 
> 2.28.0

