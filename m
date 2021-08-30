Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69873FBE82
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 23:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbhH3Vtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 17:49:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237167AbhH3Vte (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 17:49:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630360120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AmK5AK//VpDNOflKYrie75fU9H15kJEGNG5tiW/9pzA=;
        b=Ho+GBME+yHClCYJ3m0T2Y/0bkYJFI3GlrvfJOOwz8oYtUMVT48vonlNg+O32ay1vcRfU5n
        vp3RZpn3NczNYXvG4Fx/cDW8greCIEnKIBrqXfDKtnVewCFy9VSgODjaJH6tHHyQmkBT2N
        nRpzvzddI1EXrZb09Ok6wQAyPfC/a6Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-y5xMnO8mPbSUxhWv1_smLw-1; Mon, 30 Aug 2021 17:48:37 -0400
X-MC-Unique: y5xMnO8mPbSUxhWv1_smLw-1
Received: by mail-wm1-f69.google.com with SMTP id o20-20020a05600c379400b002e755735eedso514537wmr.0
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 14:48:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AmK5AK//VpDNOflKYrie75fU9H15kJEGNG5tiW/9pzA=;
        b=bMUpLtSl0+nBDsajgCdjcMUmx6ysVKcAHDLs0jQ8XncjoGOWdqlv5biYQqZMPCyyV4
         27lUYinEsnZ/t3L/LQLaKKyn8P4tF3G8m+5MMhAG2VW8S4uVvgfkpguOVRKUAsaCL9rz
         A27LbCprO9JdinahEEvPAgSc+UPB3K8zRwb0fdEoC7O4EfJN5dDFHlWTTD34UgdJsw/N
         FuQ83zBAHK6qkTsTIjMKuk2sO3o6jcEu67BxtSju8OTwPZugH1yjrpzEnNFyXs4fMop9
         y76HxgJjdnXASzJ8nI16ADN6Ia/tuxkzmFjP1sD4QEvbQYBWAZU9KCm62BOvlvY3lt3H
         t87w==
X-Gm-Message-State: AOAM530S8nhmaXgfnfWL5fm4/eeAMrZqEJIIr/1xbTQYGg9hhrt2JizU
        H+hHFeZrOfrMl67Oxictda0/G3ePRdMPoGJ0MZu7SNM7BHxqoIrMYkHSCVqbov6mJdpeJr4RmOW
        Y5+Cvx4eFfzvp
X-Received: by 2002:a1c:35c9:: with SMTP id c192mr967733wma.121.1630360115920;
        Mon, 30 Aug 2021 14:48:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5fhrlu0kEOzo1cvWkb9o9z8Fn1FmpxfqvNOtZoj6358rRlPDpe9fYiRVrse76ReP25wmvgw==
X-Received: by 2002:a1c:35c9:: with SMTP id c192mr967723wma.121.1630360115695;
        Mon, 30 Aug 2021 14:48:35 -0700 (PDT)
Received: from redhat.com ([2.55.138.60])
        by smtp.gmail.com with ESMTPSA id v62sm68440wme.21.2021.08.30.14.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 14:48:35 -0700 (PDT)
Date:   Mon, 30 Aug 2021 17:48:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, oren@nvidia.com, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH 1/1] virtio-blk: add num_io_queues module parameter
Message-ID: <20210830174345-mutt-send-email-mst@kernel.org>
References: <20210830120023.22202-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830120023.22202-1-mgurtovoy@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 30, 2021 at 03:00:23PM +0300, Max Gurtovoy wrote:
> Sometimes a user would like to control the amount of IO queues to be
> created for a block device. For example, for limiting the memory
> footprint of virtio-blk devices.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>


Hmm. It's already limited by # of CPUs... Why not just limit
from the hypervisor side? What's the actual use-case here?

> ---
>  drivers/block/virtio_blk.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index e574fbf5e6df..77e8468e8593 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -24,6 +24,28 @@
>  /* The maximum number of sg elements that fit into a virtqueue */
>  #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>  
> +static int virtblk_queue_count_set(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	unsigned int n;
> +	int ret;
> +
> +	ret = kstrtouint(val, 10, &n);
> +	if (ret != 0 || n > nr_cpu_ids)
> +		return -EINVAL;
> +	return param_set_uint(val, kp);
> +}
> +
> +static const struct kernel_param_ops queue_count_ops = {
> +	.set = virtblk_queue_count_set,
> +	.get = param_get_uint,
> +};
> +
> +static unsigned int num_io_queues;
> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
> +MODULE_PARM_DESC(num_io_queues,
> +		 "Number of IO virt queues to use for blk device.");
> +
>  static int major;
>  static DEFINE_IDA(vd_index_ida);
>  
> @@ -501,7 +523,9 @@ static int init_vq(struct virtio_blk *vblk)
>  	if (err)
>  		num_vqs = 1;
>  
> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
> +	num_vqs = min_t(unsigned int,
> +			min_not_zero(num_io_queues, nr_cpu_ids),
> +			num_vqs);
>  
>  	vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs), GFP_KERNEL);
>  	if (!vblk->vqs)
> -- 
> 2.18.1

