Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A5E19C29E
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 15:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388615AbgDBN1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 09:27:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48145 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388311AbgDBN1r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 09:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585834066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/1eX8MBJ9dVspbC5Z01wrbH0AdjiWCbWXslfX6OZ6hs=;
        b=COT6axmsc4/o33shFdrUgxfaUwtGbPopAUs8F85OsJSSnBICRImJfndxWunThUFWWjYwhn
        JwceyHpNoSlAnEsik1XXMOGHDrhMHbD/2gB8DW9gLdDXq9xaHLxjnFHFg1AKOK7m9lL9l8
        8oITaJMGLAZkoBog3oeRIPCxcbrY7B8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-D-LT3oidPPiyIzwEb0sMsA-1; Thu, 02 Apr 2020 09:27:44 -0400
X-MC-Unique: D-LT3oidPPiyIzwEb0sMsA-1
Received: by mail-qt1-f198.google.com with SMTP id w1so3125356qte.6
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 06:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/1eX8MBJ9dVspbC5Z01wrbH0AdjiWCbWXslfX6OZ6hs=;
        b=DbxNifqG2HIulSP+V7wWmspXxpBTxFVNbequcPLsZRJe0d8stuR/F/3nZzukllkGu5
         XEhlJv999jKXiB7n+jZhZfyh6iooLmHg8p2D05mPpz8lcbYfLxBjAFdgItKaO/mKQ/hs
         im35q02cuXpcMFGxAmW/NDzmI4nGza0C422P6Ezm6q8EzGWCb5q/h+oUdyPnIQc/BIWu
         MtslWo/9eQNiUYiMKcpRaxiEmwZfWI/VEDEjJmLITkSwKXwprVtIuvwHR/0lwrTr5Muh
         zc4lxiSe6CoLHQLWg2hgrUjNY6qhPmaLx2WJppmOw0LvP/v6jogiwNSv0ERRJvLfgPLa
         4AhA==
X-Gm-Message-State: AGi0PuZOPYGjsuhYp+cxQkIF6WlXzB9BosZrMn4uXvSRqtZi1J47sdke
        RBXvb8LTsyPmqDoTBnMLuj4s9RTljb6FZZ+pfQ0qBh5VfBMcKtE1FZKnEh8hk4AQolbwYh6EcDe
        SnjxxeP4HeHlN
X-Received: by 2002:a37:7a84:: with SMTP id v126mr3349836qkc.423.1585834063928;
        Thu, 02 Apr 2020 06:27:43 -0700 (PDT)
X-Google-Smtp-Source: APiQypLxHjkaUsVorVDqnHwIHws97AjgXm5AAgFlj0iL+yJ0ouEjkj3oZQka7/SWWzBEH9hp1R5KqA==
X-Received: by 2002:a37:7a84:: with SMTP id v126mr3349804qkc.423.1585834063566;
        Thu, 02 Apr 2020 06:27:43 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id 31sm3619643qta.56.2020.04.02.06.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 06:27:42 -0700 (PDT)
Date:   Thu, 2 Apr 2020 09:27:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v4 7/7] tools/virtio: Make --reset reset ring idx
Message-ID: <20200402092529-mutt-send-email-mst@kernel.org>
References: <20200401183118.8334-1-eperezma@redhat.com>
 <20200401183118.8334-8-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200401183118.8334-8-eperezma@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 01, 2020 at 08:31:18PM +0200, Eugenio Pérez wrote:
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>

I'm still a bit puzzled by this one - could you
explain what the rationale here is?

> ---
>  drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
>  tools/virtio/linux/virtio.h  |  2 ++
>  tools/virtio/virtio_test.c   | 28 +++++++++++++++++++++++++++-
>  3 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 58b96baa8d48..f9153a381f72 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1810,6 +1810,35 @@ int virtqueue_add_inbuf_ctx(struct virtqueue *vq,
>  }
>  EXPORT_SYMBOL_GPL(virtqueue_add_inbuf_ctx);
>  
> +#ifndef __KERNEL__
> +
> +/**
> + * virtqueue_reset_free_head - Reset to 0 the members of split ring.
> + * @vq: Virtqueue to reset.
> + *
> + * At this moment, is only meant for debug the ring index change, do not use
> + * in production.
> + */
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
> +#endif
> +
>  /**
>   * virtqueue_kick_prepare - first half of split virtqueue_kick call.
>   * @_vq: the struct virtqueue
> diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
> index b751350d4ce8..5d33eab6b814 100644
> --- a/tools/virtio/linux/virtio.h
> +++ b/tools/virtio/linux/virtio.h
> @@ -65,4 +65,6 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
>  				      const char *name);
>  void vring_del_virtqueue(struct virtqueue *vq);
>  
> +void virtqueue_reset_free_head(struct virtqueue *vq);
> +
>  #endif
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


Poking at vq descriptors like this seems fragile.
I think this calls for a better API that handles everything
internally.


> +				virtqueue_reset_free_head(vq->vq);
> +
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

