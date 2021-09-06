Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71295401603
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 07:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbhIFFhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 01:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbhIFFhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 01:37:06 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5FFC061575;
        Sun,  5 Sep 2021 22:36:02 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id a13so7238725iol.5;
        Sun, 05 Sep 2021 22:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SueHKYkxrfnV7M4ec6sVbN4VWy4YIBLTLnDQ1kZYr3w=;
        b=BLhDr5XMVFBQtj2pSsEY10kwQUjdmVv63WfkUbfpCb9PoPRwe6fUD7VTa8g7XDwXj7
         KTmYQkpYobuIaf8BxeHLO0cUTQspfB0m0TisdZRugGrq4n006f8SIW2u8heo2C9YwP7o
         FNLWCvcAe2+Qyvi/kFuMArdetwAUuw3UT8YdeIRQUWgXiTdGG2QY2CHJiE+N9KX+33h5
         ptaeF1wVb6m3zYPWbQre2QDlJsvgbT+i4PyrOb0IxVZA/HqVwAJiAK4idy+hgMlfzXwp
         bsr+sd0PcsJm8Gznc8XxpBhBzIKA9wXkFft8w+O4443BPitt9xTu5JQQBvWgvafz801y
         uAag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SueHKYkxrfnV7M4ec6sVbN4VWy4YIBLTLnDQ1kZYr3w=;
        b=SwY5ulvHN/ygWnPaxLDdj3jJ/QD10QfZt+DfCv1p+zpHkzayDyByj5xgAM9x/+ecvs
         ZByJjvRqSEG9xYG1LqPpEk1NoalBCZNCon9R/+jzRzCYSTGTBaYKDFV72dVulpVD7VSZ
         MJMK4/GHbF1ZzCfampvDa73AMbG1KfD/K12JXnE7qtS0CcM4Zzqh40fhA06RzkjJw7gJ
         6uvH+z/98JMFtqtYNb/4Q7JATH3cqizj1x/3jEMGSit75i4gPK1vzV5h3DNjXj9J1GSM
         zJOPpJLzdsZdFpGmUA0GXVLmS1rjxJOjF9528h+RXzA5q9u/cIzJIc8vFCFH8083/vzo
         X4Ow==
X-Gm-Message-State: AOAM5332jpvr6cVoE2IHP9PWxmgZipzZCQN9PYg8ODE3utDnfa+IW8e4
        hlBMZCampEVybUJB+5zTGmm1OJ9hiqc8j+8u0h+UDWRu3OA=
X-Google-Smtp-Source: ABdhPJwWGsa8Mbr0GhlJTm89mecRNOpmMG9dT703P5euTuQR4V+0TUGa0YzJae1MbtSD8MzrnZtn4SDkgo+gCf2UuYg=
X-Received: by 2002:a6b:3f02:: with SMTP id m2mr7734264ioa.136.1630906561896;
 Sun, 05 Sep 2021 22:36:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210905085717.7427-1-mgurtovoy@nvidia.com>
In-Reply-To: <20210905085717.7427-1-mgurtovoy@nvidia.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Mon, 6 Sep 2021 07:35:51 +0200
Message-ID: <CAM9Jb+ii_YthttHt7Jbs337zzJ-0FRU6LtjXwOUmPzfXGDDKgQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] virtio-blk: remove unneeded "likely" statements
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Usually we use "likely/unlikely" to optimize the fast path. Remove
> redundant "likely/unlikely" statements in the control path to simplify
> the code and make it easier to read.
>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>
> changes from v1:
>  - added "Reviewed-by" (Stefan)
>  - commit description update (Stefan)
>
> ---
>  drivers/block/virtio_blk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index afb37aac09e8..e574fbf5e6df 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -765,7 +765,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>                 goto out_free_vblk;
>
>         /* Default queue sizing is to fill the ring. */
> -       if (likely(!virtblk_queue_depth)) {
> +       if (!virtblk_queue_depth) {
>                 queue_depth = vblk->vqs[0].vq->num_free;
>                 /* ... but without indirect descs, we use 2 descs per req */
>                 if (!virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
> @@ -839,7 +839,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>         else
>                 blk_size = queue_logical_block_size(q);
>
> -       if (unlikely(blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE)) {
> +       if (blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE) {
>                 dev_err(&vdev->dev,
>                         "block size is changed unexpectedly, now is %u\n",
>                         blk_size);
> --


Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
