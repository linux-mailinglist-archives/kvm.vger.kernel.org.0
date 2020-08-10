Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6248240736
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 16:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgHJOHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 10:07:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27939 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727010AbgHJOHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 10:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597068419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pi3lxN8psIrNXa8THCHtbbaT+Fbe/njlOIIu353jdbM=;
        b=NkPi1fVHW2dCUL7TC5T17ri3k3IZZYHUZ/BSa2LL/c2O/kCfa099ALAiLwxadgVCNIftI4
        aHIDi9uTktBxu1lJu52hZLVSYsbMfKVwA2dbrwwOIMqur/GIttYPUOrVLJjRij6NGUE7S0
        RIYlUsFbfufBUtv+FIdad4UvuOX+zyk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-nldMTQHIPr-7ZCb5xOZ_Pg-1; Mon, 10 Aug 2020 10:06:57 -0400
X-MC-Unique: nldMTQHIPr-7ZCb5xOZ_Pg-1
Received: by mail-wr1-f72.google.com with SMTP id r29so4272919wrr.10
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 07:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pi3lxN8psIrNXa8THCHtbbaT+Fbe/njlOIIu353jdbM=;
        b=dKitiZYfsj6lFFD9fFr5O3HRX02lt808lZx1+btg9CfjZ2+1RLlr6xuZ/OlXZopG/k
         SAEiKMtE9PoT6jJkvy4Z62LIHjrBNl5/yA9tCYlgo86nMQQD+52BkfYQe3ZSkTLRnu7Y
         vO5jnmUaPH3vRnsIm5DJ734Y9IFl4G4/UTSS1CsOrNCmQsPJPQz6Q/3HQqQzMYrlnGub
         tOqaezXOIALNQO7S+URpmzHVBnun3TkTYB1XtYX5mx6kyo46qbd9P1UrmaI8JUrpddND
         DpYz8OHbjt6aN4Q5dC22PwxgPJjbXtj71Z+XC/GrywpL1E08cmVO4k9E2CHvrG1ln7Wd
         ZsWg==
X-Gm-Message-State: AOAM531X5LIYOvWpAj7By0Ujb4iFZu2x6q2xfrQnAId+FtIxj/o0j+2P
        tI1Nt1/rwgfHIf1aYzdlKC0CP4WrDSYuoR2wN10K+peQ78VhZQk28QuoSo+PRqdJDweKQHR27mv
        yvmcUL4LnPujv
X-Received: by 2002:a1c:2646:: with SMTP id m67mr26930168wmm.137.1597068416436;
        Mon, 10 Aug 2020 07:06:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDOtF9sq0/VeMXAciszixSC7chLA9+Y/luG4FnM99tjGeJ9Oystkk1lZT0wf1NuDad9Z5hsg==
X-Received: by 2002:a1c:2646:: with SMTP id m67mr26930081wmm.137.1597068415258;
        Mon, 10 Aug 2020 07:06:55 -0700 (PDT)
Received: from redhat.com (bzq-109-67-41-16.red.bezeqint.net. [109.67.41.16])
        by smtp.gmail.com with ESMTPSA id x6sm19927572wmx.28.2020.08.10.07.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 07:06:54 -0700 (PDT)
Date:   Mon, 10 Aug 2020 10:06:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 03/20] virtio: Add get_shm_region method
Message-ID: <20200810100529-mutt-send-email-mst@kernel.org>
References: <20200807195526.426056-1-vgoyal@redhat.com>
 <20200807195526.426056-4-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807195526.426056-4-vgoyal@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 07, 2020 at 03:55:09PM -0400, Vivek Goyal wrote:
> From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> 
> Virtio defines 'shared memory regions' that provide a continuously
> shared region between the host and guest.
> 
> Provide a method to find a particular region on a device.
> 
> Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: "Michael S. Tsirkin" <mst@redhat.com>

I don't think I can merge it through my tree for 5.9 at this stage,
but if there's a tree where this can be merged for 5.9,
feel free.

> ---
>  include/linux/virtio_config.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index bb4cc4910750..c859f000a751 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -10,6 +10,11 @@
>  
>  struct irq_affinity;
>  
> +struct virtio_shm_region {
> +       u64 addr;
> +       u64 len;
> +};
> +
>  /**
>   * virtio_config_ops - operations for configuring a virtio device
>   * Note: Do not assume that a transport implements all of the operations
> @@ -65,6 +70,7 @@ struct irq_affinity;
>   *      the caller can then copy.
>   * @set_vq_affinity: set the affinity for a virtqueue (optional).
>   * @get_vq_affinity: get the affinity for a virtqueue (optional).
> + * @get_shm_region: get a shared memory region based on the index.
>   */
>  typedef void vq_callback_t(struct virtqueue *);
>  struct virtio_config_ops {
> @@ -88,6 +94,8 @@ struct virtio_config_ops {
>  			       const struct cpumask *cpu_mask);
>  	const struct cpumask *(*get_vq_affinity)(struct virtio_device *vdev,
>  			int index);
> +	bool (*get_shm_region)(struct virtio_device *vdev,
> +			       struct virtio_shm_region *region, u8 id);
>  };
>  
>  /* If driver didn't advertise the feature, it will never appear. */
> @@ -250,6 +258,15 @@ int virtqueue_set_affinity(struct virtqueue *vq, const struct cpumask *cpu_mask)
>  	return 0;
>  }
>  
> +static inline
> +bool virtio_get_shm_region(struct virtio_device *vdev,
> +                         struct virtio_shm_region *region, u8 id)
> +{
> +	if (!vdev->config->get_shm_region)
> +		return false;
> +	return vdev->config->get_shm_region(vdev, region, id);
> +}
> +
>  static inline bool virtio_is_little_endian(struct virtio_device *vdev)
>  {
>  	return virtio_has_feature(vdev, VIRTIO_F_VERSION_1) ||
> -- 
> 2.25.4
> 

