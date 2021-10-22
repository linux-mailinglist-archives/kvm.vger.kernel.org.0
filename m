Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FED84374BD
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 11:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhJVJdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 05:33:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232180AbhJVJdD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 05:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634895045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Exmt4jTkemurDoyQgXRU8PvM8wbQD/c3j+4KTnsT5S0=;
        b=bAt344ysr9WBGR1ZcgaripBh7WSBzaoqSOU8kU9PiTHOg+f13A8zotwszOWRV19cnb7PyB
        2VTolI8jrO9WJD9/yO1ny9UBKC5WEhcUYY7F4iyr+tvYpXEXByMqvpKW2M0YbmfnVTJtYP
        YflQCXelIdeksll81EVEQEOOXSFQNxU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-hhv3Ek3BP5SntTO-2B40zQ-1; Fri, 22 Oct 2021 05:30:44 -0400
X-MC-Unique: hhv3Ek3BP5SntTO-2B40zQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5-20020a1c0005000000b0032c9c156acbso731912wma.9
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 02:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Exmt4jTkemurDoyQgXRU8PvM8wbQD/c3j+4KTnsT5S0=;
        b=lJfY1HQ3QJRWvVfYTkjqjKsv+yPLC37o0YEVu1e2RsPob4SxiYGRbCEQK80muhG5y3
         sFrk9OXLT4q0aWurJUEkqNBQrOQxjmxM/yLx71SJ8r+/l3W06jrNKy5461CnddZzjIdt
         yR0yFNH+UVHEjil2iaBS0lLvVaKXxdaMYdo0WV35v3QQqURLTgnm6Rsqf2tNqSLJZMiw
         k7qP8b7w27+8WBsZUPScCm1PUOrkvTr6ITwCwsvUqOI5lD5+M9AaTnQ4Hl5+o/n1Dbyd
         /NTTMa6grSEWigrSmN1U2b+iWVfjwF9RAPazN48R9qUF1zkaAN6zfAX1VABWgWPEoJVV
         610A==
X-Gm-Message-State: AOAM530mtCMSRu16ev3uJrVuWSLqBlqstAowsnJqYJgjJWMidWdDid2U
        qDe+sAhLcGtdlh8q0aJ0En0y4A+TRPtZ1b0WRpOpAbG2xezN0sKQc7VYCBpzINNB1Cle4DsD4p6
        c7xJcH4UrzLDM
X-Received: by 2002:adf:e90b:: with SMTP id f11mr2694856wrm.181.1634895043223;
        Fri, 22 Oct 2021 02:30:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygejYN4wrbg0gCwYPCQWk12aliJB5cOOwmEtPe9Fbvdiu9h0LjGVc51OvnzWH3A2vl4yneaQ==
X-Received: by 2002:adf:e90b:: with SMTP id f11mr2694835wrm.181.1634895043076;
        Fri, 22 Oct 2021 02:30:43 -0700 (PDT)
Received: from redhat.com ([2.55.24.172])
        by smtp.gmail.com with ESMTPSA id l5sm7503858wru.24.2021.10.22.02.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 02:30:42 -0700 (PDT)
Date:   Fri, 22 Oct 2021 05:30:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, stefanha@redhat.com, israelr@nvidia.com,
        nitzanc@nvidia.com, oren@nvidia.com, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Message-ID: <20211022052950-mutt-send-email-mst@kernel.org>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902204622.54354-1-mgurtovoy@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021 at 11:46:22PM +0300, Max Gurtovoy wrote:
> Sometimes a user would like to control the amount of request queues to
> be created for a block device. For example, for limiting the memory
> footprint of virtio-blk devices.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
> 
> changes from v2:
>  - renamed num_io_queues to num_request_queues (from Stefan)
>  - added Reviewed-by signatures (from Stefan and Christoph)
> 
> changes from v1:
>  - use param_set_uint_minmax (from Christoph)
>  - added "Should > 0" to module description
> 
> Note: This commit apply on top of Jens's branch for-5.15/drivers
> 
> ---
>  drivers/block/virtio_blk.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 4b49df2dfd23..aaa2833a4734 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -24,6 +24,23 @@
>  /* The maximum number of sg elements that fit into a virtqueue */
>  #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>  
> +static int virtblk_queue_count_set(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> +}
> +
> +static const struct kernel_param_ops queue_count_ops = {
> +	.set = virtblk_queue_count_set,
> +	.get = param_get_uint,
> +};
> +
> +static unsigned int num_request_queues;
> +module_param_cb(num_request_queues, &queue_count_ops, &num_request_queues,
> +		0644);
> +MODULE_PARM_DESC(num_request_queues,
> +		 "Number of request queues to use for blk device. Should > 0");
> +
>  static int major;
>  static DEFINE_IDA(vd_index_ida);
>  

I wasn't happy with the message here so I tweaked it.

Please look at it in linux-next and confirm. Thanks!


> @@ -501,7 +518,9 @@ static int init_vq(struct virtio_blk *vblk)
>  	if (err)
>  		num_vqs = 1;
>  
> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
> +	num_vqs = min_t(unsigned int,
> +			min_not_zero(num_request_queues, nr_cpu_ids),
> +			num_vqs);
>  
>  	vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs), GFP_KERNEL);
>  	if (!vblk->vqs)
> -- 
> 2.18.1

