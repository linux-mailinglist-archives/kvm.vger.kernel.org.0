Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4EB3FFA1E
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 08:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbhICGII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 02:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbhICGIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 02:08:07 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ABBC061575;
        Thu,  2 Sep 2021 23:07:07 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id u7so4194656ilk.7;
        Thu, 02 Sep 2021 23:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g0tm4GeYA/JaE1+KeZPU+sovvSIMGM2e/oeyivqXSxQ=;
        b=E+uZm9nLOn4PWLG8KOzSMxZJZQ/rMpsJS87CO2+bYbxXHkw/yzhkT8WUeWdxNCpH+D
         pa04b52QOs2WJjeAATcLNLVr1kkYT4ewaX/6N3Ng2YOD/amCspYsLXlKkJqEHctvfob+
         RFTOkXGDmoa35WOz/i0mM5BVR1ITG1Rd9PHvj8lZjgrtTE20naxuXljRUUBwB93c4Sq4
         2yoxiYUPlG3iPVXicFlRVtbO0BQAa1T8VzUVVjlKSQxjKeSBxzCKO7+0xmWaIRxy3tHR
         gzD1UUNvqsBc9QgrZvz7Yy7V87nq7Ps96rLmYcdvGD54dV+x+GN8V/Fo5eiTdWggBwPj
         I51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g0tm4GeYA/JaE1+KeZPU+sovvSIMGM2e/oeyivqXSxQ=;
        b=GkDb3leY+UCmdis/Pe5F2DlM9bUAlOc4K0sZDnfaXI53km2/jiKgVYeO/H4MpPQ4DL
         xyMfBjSjlo7MaUyaNtrcHEE6quNWQoGaZ/1SXfgwat9kZTJ+P9Pr8pNS4hSeuiGvIbJW
         1dqbFstKUVVoOjG49t3buY5Ji6ux6TAa9YY/MvAmfbRjGKsKugOr8uTrV8s/9ehpq74j
         UxXVkvXSQLpA0Z1hQBjIohhohb18JXWauh6lVu39JyRogDk4CP+FFX57vF2vssIJEXMD
         O8vQ8ZyH9JsIsP6q81fzjxsXVr8hyUEzznFNi5zsqb/1jorp3+ehLSzzACVjpa6sbnzV
         9Q8A==
X-Gm-Message-State: AOAM530cW+FmruVBd4BVyGWanxE1Z/Kndm3PuqsT1Mxf+Xou4adBf9E1
        TU4SF0WIhnxmYXh2HGFqcFS52NM9971p3rnFVCQ=
X-Google-Smtp-Source: ABdhPJwPs5QxPZOJoXaUhH8grjGdFAJjoHrBeR2WGgRBQMFdhIgs0J42J6OdPrwyr1L+17L5FS9y9c6fCbiW1CjWQuM=
X-Received: by 2002:a92:de4b:: with SMTP id e11mr1413991ilr.22.1630649226872;
 Thu, 02 Sep 2021 23:07:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
In-Reply-To: <20210902204622.54354-1-mgurtovoy@nvidia.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Fri, 3 Sep 2021 08:06:55 +0200
Message-ID: <CAM9Jb+gX9nRpXWjyxusEsmJKOVdY7zdhtWkDpu2raQXkN5Af_Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module parameter
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, "Michael S . Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, israelr@nvidia.com,
        nitzanc@nvidia.com, oren@nvidia.com, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
> +               const struct kernel_param *kp)
> +{
> +       return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> +}
> +
> +static const struct kernel_param_ops queue_count_ops = {
> +       .set = virtblk_queue_count_set,
> +       .get = param_get_uint,
> +};
> +
> +static unsigned int num_request_queues;
> +module_param_cb(num_request_queues, &queue_count_ops, &num_request_queues,
> +               0644);
> +MODULE_PARM_DESC(num_request_queues,
> +                "Number of request queues to use for blk device. Should > 0");
> +
>  static int major;
>  static DEFINE_IDA(vd_index_ida);
>
> @@ -501,7 +518,9 @@ static int init_vq(struct virtio_blk *vblk)
>         if (err)
>                 num_vqs = 1;
>
> -       num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
> +       num_vqs = min_t(unsigned int,
> +                       min_not_zero(num_request_queues, nr_cpu_ids),
> +                       num_vqs);
>
>         vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs), GFP_KERNEL);
>         if (!vblk->vqs)
> --

Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
