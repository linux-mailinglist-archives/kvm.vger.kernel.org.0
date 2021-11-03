Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DEE443DD5
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhKCHyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:54:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230046AbhKCHyN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 03:54:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635925896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MQYcpSLYl/L8fCHyaW/oJA2kKY80+E8YAyZQVJ3eeDQ=;
        b=fkO33P6Lri4Ccu/f72cKIFFG4gGXQ1ecOEWu+OBmIEdE3WL/TmWmO7tTWdlSySSf91ehW7
        GhBAU6LbRBxcOWk/9vw960LFcCIJxSJm196DVPpPA56VJbLjEMMx/9a+bOtdZOfm+ELp+D
        uCAkYZLLIiVf+hGr0h7ytmOGEcjMp9E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-wQwubtqYMDmApFv6wYCtwg-1; Wed, 03 Nov 2021 03:51:34 -0400
X-MC-Unique: wQwubtqYMDmApFv6wYCtwg-1
Received: by mail-ed1-f70.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so1633690edj.21
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 00:51:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MQYcpSLYl/L8fCHyaW/oJA2kKY80+E8YAyZQVJ3eeDQ=;
        b=AFZGcg3vmK9VWWEFfP/pI+xpOmdM3FNx/On+Hs5b5vcrESW1nysx9V78NQKdH+G0im
         pQPRJIty0ctUcEkSiy3a2FPtUjPGfsxjvVXaIbLoISNc2F9AZigcse1sgvdlkVzh1QLA
         ClaKFZnanZ+is9jo/AYyaZwBDwTAxGCqP29p1A4sNwexNI3g2PqNhfeKnb1qmF/Y4PY5
         PnIe7GYZUrTRBf9XIed/VNGW3jGFS87miHRg06KHEuVgxU21t9BqsJhkkoG0Vck62tDL
         0Cu5JCmE7dev8kX79IubKe4YO12BD1m/ZkGFp46jnUFK5tgal+NLAdjlRo9x0S3FDtwF
         ZnSA==
X-Gm-Message-State: AOAM530L5M45Rncy0zKIVio1VZIx0hUi/hsKBBdposLlLVuvj91x22b7
        0uJ4VGE3MZG1gi76IAuM1rlBBItgchXNfN4i8b+T3siNdu2h2/wQ83opyZXrVigCGg8VwHBaSE+
        +W0qhc+bCom/G
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr59241122edt.177.1635925893708;
        Wed, 03 Nov 2021 00:51:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybvc9IpzVj/HY1JPWn1plkJqxVT+7kp08NozGqfvvrM/pJwLmhn9CuIRwh0g+9ZALKaUFfBg==
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr59241099edt.177.1635925893529;
        Wed, 03 Nov 2021 00:51:33 -0700 (PDT)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id o9sm698325ejy.8.2021.11.03.00.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 00:51:33 -0700 (PDT)
Date:   Wed, 3 Nov 2021 08:51:31 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 5/7] virtio: implement the
 virtio_add_inbuf routine
Message-ID: <20211103075131.xgnysvcfbal2r6z4@gator.home>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-6-git-send-email-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1630059440-15586-6-git-send-email-pmorel@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 12:17:18PM +0200, Pierre Morel wrote:
> To communicate in both directions with a VIRTIO device we need
> to add the incoming communication to the VIRTIO level.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/virtio.c | 32 ++++++++++++++++++++++++++++++++
>  lib/virtio.h |  2 ++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/lib/virtio.c b/lib/virtio.c
> index e10153b9..b84bc680 100644
> --- a/lib/virtio.c
> +++ b/lib/virtio.c
> @@ -47,6 +47,38 @@ void vring_init_virtqueue(struct vring_virtqueue *vq, unsigned index,
>  	vq->data[i] = NULL;
>  }
>  
> +int virtqueue_add_inbuf(struct virtqueue *_vq, char *buf, unsigned int len)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +	unsigned int avail;
> +	int head;
> +
> +	assert(buf);
> +	assert(len);
> +
> +	if (!vq->vq.num_free)
> +		return -1;
> +
> +	--vq->vq.num_free;
> +
> +	head = vq->free_head;
> +
> +	vq->vring.desc[head].flags = 0;
> +	vq->vring.desc[head].addr = virt_to_phys(buf);
> +	vq->vring.desc[head].len = len;
> +
> +	vq->free_head = vq->vring.desc[head].next;
> +
> +	vq->data[head] = buf;
> +
> +	avail = (vq->vring.avail->idx & (vq->vring.num - 1));
> +	vq->vring.avail->ring[avail] = head;
> +	wmb();	/* be sure to update the ring before updating the idx */
> +	vq->vring.avail->idx++;
> +	vq->num_added++;
> +
> +	return 0;
> +}
>  int virtqueue_add_outbuf(struct virtqueue *_vq, char *buf, unsigned int len)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
> diff --git a/lib/virtio.h b/lib/virtio.h
> index 2c31fdc7..44b727f8 100644
> --- a/lib/virtio.h
> +++ b/lib/virtio.h
> @@ -141,6 +141,8 @@ extern void vring_init_virtqueue(struct vring_virtqueue *vq, unsigned index,
>  				 const char *name);
>  extern int virtqueue_add_outbuf(struct virtqueue *vq, char *buf,
>  				unsigned int len);
> +extern int virtqueue_add_inbuf(struct virtqueue *vq, char *buf,
> +			       unsigned int len);
>  extern bool virtqueue_kick(struct virtqueue *vq);
>  extern void detach_buf(struct vring_virtqueue *vq, unsigned head);
>  extern void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len);
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

