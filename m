Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3381B196D65
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 14:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgC2MgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 08:36:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:53275 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727938AbgC2MgT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Mar 2020 08:36:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585485378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hwBJNIszh6TC6VU12FXZ4Vd7wn8RSesK/NNxIOU/Few=;
        b=JizUFo5cFKkxzL4LRZrTJcKZhdhom9B/wprXZek6ztCFTHLJBLf3oiAVqYApwdTXvr3XMR
        pCQErbFBu9G295U3KXPz016IbylfFJanPWcEp+JGcBV4bIauOJ7WcI1iF88KBqHSUB6bVS
        Gv5+hxsNRXGtxYnMLdIXdhQ4vD+5SKM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-RlnAh6m1OWmv5cllX8RsJg-1; Sun, 29 Mar 2020 08:36:16 -0400
X-MC-Unique: RlnAh6m1OWmv5cllX8RsJg-1
Received: by mail-wr1-f72.google.com with SMTP id l17so8428725wro.3
        for <kvm@vger.kernel.org>; Sun, 29 Mar 2020 05:36:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hwBJNIszh6TC6VU12FXZ4Vd7wn8RSesK/NNxIOU/Few=;
        b=aC+kLe8znTrjMJcJGQ89gmVS7JjcQHcpsDftUkp3l+lcXGji8hrNbktanG5s4tz1Pu
         OuODsjdFSkrD+aEfuiwn/zIn9fXMxVsWwuXCl+gE3N6V4BiMdFxO0ah04SEvdSBFvhsZ
         rB8kmiFldKMmSaN4cFQwTr6yod0u0T7zI6+/39rIVAuJ0dXKAoXop9u+c17FV63jKNLD
         +N9dWM1J4d9j4DMdoDqthu/auUs+57QzmaWoVZKnw5JgxEtwGAvNzOMS9mqCFrrUoOwW
         6tdjtlJA2E8UgNtGT4+Jj6NDoEzrl+pmpmaD/FZWdffDKV70LrVhe9Qv5E35J1WnrcMy
         fTuA==
X-Gm-Message-State: ANhLgQ286w6G7oF9b5bXul4AoIuYez/MyO15coJD/iDT6y38q2AOsCA1
        XYslvhYRgnIWMKLeTfprz6thIDdVK1dJOKlrGvI8kYx0B3EdzzgkLcABPCr1sA2l/H/bF00hr26
        L+SbZr+Rs4BZp
X-Received: by 2002:a1c:f70a:: with SMTP id v10mr8143935wmh.72.1585485375627;
        Sun, 29 Mar 2020 05:36:15 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuI9saIsl2zcWQGqaeDKgmx/oMIL5wQ54Rlrl1U1iP0jFOdf2pPLW21ixwNKW8n8TFOnKAcZQ==
X-Received: by 2002:a1c:f70a:: with SMTP id v10mr8143921wmh.72.1585485375355;
        Sun, 29 Mar 2020 05:36:15 -0700 (PDT)
Received: from redhat.com (bzq-79-183-139-129.red.bezeqint.net. [79.183.139.129])
        by smtp.gmail.com with ESMTPSA id b187sm17230248wmc.14.2020.03.29.05.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 05:36:14 -0700 (PDT)
Date:   Sun, 29 Mar 2020 08:36:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] tools/virtio: Make --reset reset ring idx
Message-ID: <20200329083047-mutt-send-email-mst@kernel.org>
References: <20200329113359.30960-1-eperezma@redhat.com>
 <20200329113359.30960-5-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200329113359.30960-5-eperezma@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 29, 2020 at 01:33:57PM +0200, Eugenio Pérez wrote:
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
>  drivers/virtio/virtio_ring.c | 18 ++++++++++++++++++
>  include/linux/virtio.h       |  2 ++
>  tools/virtio/linux/virtio.h  |  2 ++
>  tools/virtio/virtio_test.c   | 28 +++++++++++++++++++++++++++-
>  4 files changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 867c7ebd3f10..aba44ac3f0d6 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1810,6 +1810,24 @@ int virtqueue_add_inbuf_ctx(struct virtqueue *vq,
>  }
>  EXPORT_SYMBOL_GPL(virtqueue_add_inbuf_ctx);
>  
> +void virtqueue_reset_free_head(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	// vq->last_used_idx = 0;
> +	vq->num_added = 0;
> +
> +	vq->split.queue_size_in_bytes = 0;
> +	vq->split.avail_flags_shadow = 0;
> +	vq->split.avail_idx_shadow = 0;
> +
> +	memset(vq->split.desc_state, 0, vq->split.vring.num *
> +			sizeof(struct vring_desc_state_split));
> +
> +	vq->free_head = 0;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_reset_free_head);
> +
>  /**
>   * virtqueue_kick_prepare - first half of split virtqueue_kick call.
>   * @_vq: the struct virtqueue

Add documentation please. When should this be called?
If it's just for testing, we can put this within some ifdef
that only triggers when building the test ...


> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 15f906e4a748..286a0048fbeb 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -58,6 +58,8 @@ int virtqueue_add_sgs(struct virtqueue *vq,
>  		      void *data,
>  		      gfp_t gfp);
>  
> +void virtqueue_reset_free_head(struct virtqueue *vq);
> +
>  bool virtqueue_kick(struct virtqueue *vq);
>  
>  bool virtqueue_kick_prepare(struct virtqueue *vq);
> diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
> index b751350d4ce8..cf2e9ccf4de2 100644
> --- a/tools/virtio/linux/virtio.h
> +++ b/tools/virtio/linux/virtio.h
> @@ -43,6 +43,8 @@ int virtqueue_add_inbuf(struct virtqueue *vq,
>  			void *data,
>  			gfp_t gfp);
>  
> +void virtqueue_reset_free_head(struct virtqueue *vq);
> +
>  bool virtqueue_kick(struct virtqueue *vq);
>  
>  void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
> diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> index 93d81cd64ba0..bf21ece30594 100644
> --- a/tools/virtio/virtio_test.c
> +++ b/tools/virtio/virtio_test.c
> @@ -49,6 +49,7 @@ struct vdev_info {
>  
>  static const struct vhost_vring_file no_backend = { .fd = -1 },
>  				     backend = { .fd = 1 };
> +static const struct vhost_vring_state null_state = {};
>  
>  bool vq_notify(struct virtqueue *vq)
>  {
> @@ -218,10 +219,33 @@ static void run_test(struct vdev_info *dev, struct vq_info *vq,
>  			}
>  
>  			if (reset) {
> +				struct vhost_vring_state s = { .index = 0 };
> +				int i;
> +				vq->vring.avail->idx = 0;
> +				vq->vq->num_free = vq->vring.num;
> +
> +				// Put everything in free lists.
> +				for (i = 0; i < vq->vring.num-1; i++)
> +					vq->vring.desc[i].next =
> +						cpu_to_virtio16(&dev->vdev,
> +								i + 1);
> +				vq->vring.desc[vq->vring.num-1].next = 0;
> +				virtqueue_reset_free_head(vq->vq);
> +


Hmm this is poking at internal vq format ...


> +				r = ioctl(dev->control, VHOST_GET_VRING_BASE,
> +					  &s);
> +				assert(!r);
> +
> +				s.num = 0;
> +				r = ioctl(dev->control, VHOST_SET_VRING_BASE,
> +					  &null_state);
> +				assert(!r);
> +
>  				r = ioctl(dev->control, VHOST_TEST_SET_BACKEND,
>  					  &backend);
>  				assert(!r);
>  
> +				started = completed;
>                                  while (completed > next_reset)
>  					next_reset += completed;
>  			}
> @@ -243,7 +267,9 @@ static void run_test(struct vdev_info *dev, struct vq_info *vq,
>  	test = 0;
>  	r = ioctl(dev->control, VHOST_TEST_RUN, &test);
>  	assert(r >= 0);
> -	fprintf(stderr, "spurious wakeups: 0x%llx\n", spurious);
> +	fprintf(stderr,
> +		"spurious wakeups: 0x%llx started=0x%lx completed=0x%lx\n",
> +		spurious, started, completed);
>  }
>  
>  const char optstring[] = "h";
> -- 
> 2.18.1

