Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D4920550B
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 16:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732928AbgFWOmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 10:42:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51305 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732738AbgFWOmT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 10:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592923337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mPOfZFaF+bdCbm0ydM+kQRFRBQ8scE3A9xTZmb9+eHU=;
        b=PzVCpiCW7oHGx66e6FC7jyw+wmqS5JPPZzX8iCfiyiVGOOnWQGTFtvw/zbUcbTyNvfpOio
        cvag0+rwwDSCoxtbMcUsdCoV6WRrS3i1u4/TFJY5LfMpfj1wtRnMPFJOgZnpFAqR+MOAy7
        e9+c8O2X3Y17WUQyPNHYdlwc0WunMIA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-ZHPOzBYDN9ST43UWBpGNJw-1; Tue, 23 Jun 2020 10:42:12 -0400
X-MC-Unique: ZHPOzBYDN9ST43UWBpGNJw-1
Received: by mail-wm1-f72.google.com with SMTP id h6so4560920wmb.7
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 07:42:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mPOfZFaF+bdCbm0ydM+kQRFRBQ8scE3A9xTZmb9+eHU=;
        b=r+6+KqW0vefcFhDcgeRfanMW36TNP5q6gYxAHz58IIs8xd5JyE7FLpV+zIO5lVt7hl
         gVWy/sMzpOn9eQQgV0oPI5Xsj5MLGzW2nPQ2RPgi+h+BBrFesXm7MThOgI5rKU4PalmJ
         iqNIO3XkZA6xMAdXgi+U4GTDWqU70fJ5SsLAiAAYCfRBoEiDLcTEbD3oKZ19ls+qEfS7
         5Lbxvx0fcTjAURzF7VIXul38krDvGu7GKWtAC2Bo6YBgDPf7w9nAbZafIb+jBVRVEj3J
         OqqEBz1RjoF94HI/wInM+c1H0okz2hdPCF+7cakXw+c5tK1xtm5hVAiXSnxppfBe8sXb
         aicw==
X-Gm-Message-State: AOAM530BDlrvJEOHt1yKdDh+V6WmPkzTEXhFvYc41qYf5TRiwXRtlRFH
        6HdSuzpFf9QyE0Dt/BDn0MQeSqn8QPWipqqUMm29omKNTpDvwBzTOoaSqd4VTr0pdw2DvT4aFJ4
        8bsy0sgdEYYKx
X-Received: by 2002:adf:e285:: with SMTP id v5mr25169179wri.129.1592923330751;
        Tue, 23 Jun 2020 07:42:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmHWDOuDtiB37Ir1bpYYZm3cgpiWQYz+hwCXOOThQnShQNMF77cdnf/6yuMEyCU5MTi1D9bA==
X-Received: by 2002:adf:e285:: with SMTP id v5mr25169152wri.129.1592923330463;
        Tue, 23 Jun 2020 07:42:10 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id n14sm521539wro.81.2020.06.23.07.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 07:42:09 -0700 (PDT)
Date:   Tue, 23 Jun 2020 10:42:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC v9 02/11] vhost: use batched get_vq_desc version
Message-ID: <20200623103746-mutt-send-email-mst@kernel.org>
References: <20200619182302.850-1-eperezma@redhat.com>
 <20200619182302.850-3-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619182302.850-3-eperezma@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 08:22:53PM +0200, Eugenio Pérez wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> 
> As testing shows no performance change, switch to that now.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> Link: https://lore.kernel.org/r/20200401183118.8334-3-eperezma@redhat.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
>  drivers/vhost/test.c  |   2 +-
>  drivers/vhost/vhost.c | 314 ++++++++----------------------------------
>  drivers/vhost/vhost.h |   7 +-
>  3 files changed, 61 insertions(+), 262 deletions(-)
> 
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index a09dedc79f68..650e69261557 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
>  	dev = &n->dev;
>  	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
>  	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
> -	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> +	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
>  		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL);
>  
>  	f->private_data = n;
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 2d784681b0fa..13021d6986eb 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -304,6 +304,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>  {
>  	vq->num = 1;
>  	vq->ndescs = 0;
> +	vq->first_desc = 0;
>  	vq->desc = NULL;
>  	vq->avail = NULL;
>  	vq->used = NULL;
> @@ -372,6 +373,11 @@ static int vhost_worker(void *data)
>  	return 0;
>  }
>  
> +static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
> +{
> +	return vq->max_descs - UIO_MAXIOV;
> +}
> +
>  static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
>  {
>  	kfree(vq->descs);


Batching is enabled if max_descs > UIO_MAXIOV.

So this uses batching for test.

But net is unchanged, so it is still not using the batched version.
Is that right?

I think a better subject would be "vhost/test: use batched get_vq_desc version".

And that explains which testing it refers to: the one executed by vhost test.

I think there was a separate patch to enable that for net separately,
but it got lost - or did I miss it?

-- 
MST

