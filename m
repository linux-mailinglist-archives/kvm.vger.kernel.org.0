Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71264387B5
	for <lists+kvm@lfdr.de>; Sun, 24 Oct 2021 10:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhJXIuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Oct 2021 04:50:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229463AbhJXIut (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 24 Oct 2021 04:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635065309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+4gAu5mtq8yjhmzCHpAItde3uglak0uKi9++yZF6x4=;
        b=NU1NhPVjznKa3hVuKbHqSxjVBaLgb/ixjh+DU5Qo2fY8HaZW+up8P2ToX7CZb+wo+f42NO
        Vw0RILSZhiLwkBanbcwrerjZd16tCsa/D3RUsHdrj4SQs8refVfAoDI7FAXywwKe4kG8vv
        7kL+nlY1xMxpNFk0comw84sm4WIEBfs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-gPdOAiy-NJWnBgIDCotQsw-1; Sun, 24 Oct 2021 04:48:27 -0400
X-MC-Unique: gPdOAiy-NJWnBgIDCotQsw-1
Received: by mail-wr1-f71.google.com with SMTP id 10-20020a5d47aa000000b001610cbda93dso2101326wrb.23
        for <kvm@vger.kernel.org>; Sun, 24 Oct 2021 01:48:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=x+4gAu5mtq8yjhmzCHpAItde3uglak0uKi9++yZF6x4=;
        b=OAZlkY0v1f/ICavS+R15EAV9BnftQ4ytonz6WMqG1wna2QYp8O63y/kfY7kpoG8Xri
         uBlYKO/1kN4qNdT5yvk3z5DaVrQBHum/gRU9PJIVWAKAWxVhvToZNKIPEV6ZEJilW0k4
         2JY1iV8r/HkgAUpUMzcAEdlb646dSfVMAjefG8FD0931poY3I6OyGtXhw69iIqjor+Wo
         qcEzDgx1b0XpkLUhpgCyy7/9aZ8M9b6oqR//qky/tKQ+LvxIIQlXi3CSgeHjcT+1jC+s
         VTXT9idHt3/vZNt65fmqVJPygvwnnKSIxTLQC4Tvf1PcMc9mKo5YIcUJtEhCu1zqyZU+
         8Iqw==
X-Gm-Message-State: AOAM532qNQ0gGBUuj23Os+8eo+FCS2KJQUegIwxsd8CdoGJconabylan
        XaC4agY+IHrkZJ5rG76xY2iROyloxJz/lEq8LahHfomPVluLtlOWupYvMtcg0UNx9QX3qX4AY/h
        dOdKx7FjfsmHr
X-Received: by 2002:adf:b353:: with SMTP id k19mr14156387wrd.325.1635065306735;
        Sun, 24 Oct 2021 01:48:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBXZ52beGBzMa+DgbJxq6cALSCJFAJyXJoIIqXck3s+fMgDLCqWgGSxucsWO8K8zFTKcOZdQ==
X-Received: by 2002:adf:b353:: with SMTP id k19mr14156363wrd.325.1635065306517;
        Sun, 24 Oct 2021 01:48:26 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:107e:5d4f:9dc9:1a6d:9b57:401])
        by smtp.gmail.com with ESMTPSA id a2sm12869839wru.82.2021.10.24.01.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 01:48:25 -0700 (PDT)
Date:   Sun, 24 Oct 2021 04:48:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, stefanha@redhat.com, israelr@nvidia.com,
        nitzanc@nvidia.com, oren@nvidia.com, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Message-ID: <20211024044727-mutt-send-email-mst@kernel.org>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <20211022052950-mutt-send-email-mst@kernel.org>
 <19cbe00a-409c-fd4b-4466-6b9fe650229f@nvidia.com>
 <93c7838d-d942-010e-e1b2-bc052365f5b1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93c7838d-d942-010e-e1b2-bc052365f5b1@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 24, 2021 at 11:12:26AM +0300, Max Gurtovoy wrote:
> 
> On 10/24/2021 10:19 AM, Max Gurtovoy wrote:
> > 
> > On 10/22/2021 12:30 PM, Michael S. Tsirkin wrote:
> > > On Thu, Sep 02, 2021 at 11:46:22PM +0300, Max Gurtovoy wrote:
> > > > Sometimes a user would like to control the amount of request queues to
> > > > be created for a block device. For example, for limiting the memory
> > > > footprint of virtio-blk devices.
> > > > 
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > ---
> > > > 
> > > > changes from v2:
> > > >   - renamed num_io_queues to num_request_queues (from Stefan)
> > > >   - added Reviewed-by signatures (from Stefan and Christoph)
> > > > 
> > > > changes from v1:
> > > >   - use param_set_uint_minmax (from Christoph)
> > > >   - added "Should > 0" to module description
> > > > 
> > > > Note: This commit apply on top of Jens's branch for-5.15/drivers
> > > > 
> > > > ---
> > > >   drivers/block/virtio_blk.c | 21 ++++++++++++++++++++-
> > > >   1 file changed, 20 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > > index 4b49df2dfd23..aaa2833a4734 100644
> > > > --- a/drivers/block/virtio_blk.c
> > > > +++ b/drivers/block/virtio_blk.c
> > > > @@ -24,6 +24,23 @@
> > > >   /* The maximum number of sg elements that fit into a virtqueue */
> > > >   #define VIRTIO_BLK_MAX_SG_ELEMS 32768
> > > >   +static int virtblk_queue_count_set(const char *val,
> > > > +        const struct kernel_param *kp)
> > > > +{
> > > > +    return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> > > > +}
> > > > +
> 
> BTW, I've noticed in your new message you allow setting 0 so you might want
> to change the code to
> 
> param_set_uint_minmax(val, kp, 0, nr_cpu_ids);
> 
> to a case a user will load the module with num_request_queues=0.

Oh. So as written the default forces 1 queue?
Send a patch please!

> > > > +static const struct kernel_param_ops queue_count_ops = {
> > > > +    .set = virtblk_queue_count_set,
> > > > +    .get = param_get_uint,
> > > > +};
> > > > +
> > > > +static unsigned int num_request_queues;
> > > > +module_param_cb(num_request_queues, &queue_count_ops,
> > > > &num_request_queues,
> > > > +        0644);
> > > > +MODULE_PARM_DESC(num_request_queues,
> > > > +         "Number of request queues to use for blk device.
> > > > Should > 0");
> > > > +
> > > >   static int major;
> > > >   static DEFINE_IDA(vd_index_ida);
> > > I wasn't happy with the message here so I tweaked it.
> > > 
> > > Please look at it in linux-next and confirm. Thanks!
> > 
> > Looks good.
> > 
> > 
> > > 
> > > 
> > > > @@ -501,7 +518,9 @@ static int init_vq(struct virtio_blk *vblk)
> > > >       if (err)
> > > >           num_vqs = 1;
> > > >   -    num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
> > > > +    num_vqs = min_t(unsigned int,
> > > > +            min_not_zero(num_request_queues, nr_cpu_ids),
> > > > +            num_vqs);
> > > >         vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs),
> > > > GFP_KERNEL);
> > > >       if (!vblk->vqs)
> > > > -- 
> > > > 2.18.1

