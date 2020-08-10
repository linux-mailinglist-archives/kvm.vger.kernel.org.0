Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898D32406F4
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 15:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgHJNr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 09:47:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35571 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726614AbgHJNrZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Aug 2020 09:47:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597067242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z8HxGZRX0ri3hL7o0UjLbQAuAiwO1V2HqhDwK8CAsEc=;
        b=XnWr0M68eOtXwjF90e0/o8teuUjTV80y2kKOnqIh6eC2O0T3l/CNcVJwl4ggzjF66BuhES
        o/3lPf2v1iyh1hxBzpCmvp+9FxB9z/z471NSLFUaXsRdHH1c08jOg3C/I6bJ31ReOAwKUD
        ARWfgWfolRGdHUK5pLVteDF2LDU3ZAI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-0qr5F1juOtKOq7b5_iJRfQ-1; Mon, 10 Aug 2020 09:47:21 -0400
X-MC-Unique: 0qr5F1juOtKOq7b5_iJRfQ-1
Received: by mail-wr1-f70.google.com with SMTP id m7so4237399wrb.20
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 06:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z8HxGZRX0ri3hL7o0UjLbQAuAiwO1V2HqhDwK8CAsEc=;
        b=VJtDjmA9yaVs86e2sSq4St+7duk+gLlkZE9S1/c7DWOj5zevyKZjrsV8T7oNthpD4J
         YeULXsOs1NphukzZ+FlxLkqftoID6aHH5TrCCtRCQhUWHU+JLFhhVd2908TWxpcPkK/a
         afJidtoc6MzIf6vtn9ajOQ9INkwVqqqb0hcYriF9ROMMp6X1OxYjRWSul94uVstAMCZ8
         kGDL+PsOlA8fhJjGoA6VN7s269fHEZZOpOJBQmlniyrKtC1KjO4XqlsHX0FhdAUZkAO+
         Fiv3jVSEw6FKU9XiF35Ib3CpvFhXnt3b28PbUVPcDTUsFMk4pM+V8z3e/CuP08Bsk862
         jEmQ==
X-Gm-Message-State: AOAM533irWpVn8Edrk/ToFkgFzo055iBeUbsz5+ogzvGS/cnSi62WsHa
        5ptKPApWtsDogJL74gnBej6U/o36sDYgR8vbGqF5sYcMp20VXGR3m48IkNfkYVNdbNRD2Bza1Fp
        rtiIC4iDIkHDN
X-Received: by 2002:a1c:1b93:: with SMTP id b141mr25773832wmb.150.1597067239975;
        Mon, 10 Aug 2020 06:47:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiKr4k+daNBgpJsJdAPnBhBio+aWOVADeV99EvpK7df75SgAQYK1b8ZOE3OtN5IXqUpVc1HA==
X-Received: by 2002:a1c:1b93:: with SMTP id b141mr25773815wmb.150.1597067239779;
        Mon, 10 Aug 2020 06:47:19 -0700 (PDT)
Received: from redhat.com ([192.117.173.58])
        by smtp.gmail.com with ESMTPSA id g188sm24329476wma.5.2020.08.10.06.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 06:47:18 -0700 (PDT)
Date:   Mon, 10 Aug 2020 09:47:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 03/20] virtio: Add get_shm_region method
Message-ID: <20200810094548-mutt-send-email-mst@kernel.org>
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

I'm not sure why doesn't b4 pick up reset of this
patchset. where can I find it?


IIUC all this is 5.10 material, right?


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

