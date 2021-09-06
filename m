Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B429401A82
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 13:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbhIFLWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 07:22:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32004 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240875AbhIFLWA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 07:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630927255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PwCcwobqarvdp7b4ZxKmDRuHy822IrmJf431Zj87HGM=;
        b=c8VndKIXRd3uk4l/vu4ezfYK7J6KNb0Du+QtllfoiroG7oy8SwZ5+hyF2SrGCYDxLuV/Ql
        zcHohVvcsFXhk/2YAsJnKZUrSd9gJBp40zD5ZI72ZIIdNmFrboxR9CZxwYuz8qU/BvdLrI
        4YpWkmsd8VLqyRiDxAjh9InDSaMipyM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-0dkzaYtvN8qyZtRUmaIE9g-1; Mon, 06 Sep 2021 07:20:54 -0400
X-MC-Unique: 0dkzaYtvN8qyZtRUmaIE9g-1
Received: by mail-ej1-f71.google.com with SMTP id yz13-20020a170906dc4d00b005c61ad936f0so2195065ejb.12
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 04:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PwCcwobqarvdp7b4ZxKmDRuHy822IrmJf431Zj87HGM=;
        b=fuQbyCngM1uCKI3kUsQgsyvzBm2eV+5G50qiHB8JQ5I7YU+aeXsmDyal8hQH13j7UT
         NsRJH7AjSyvO4Q+axkzyMQXStlSgj7D1h5Q27s6b2Qnj/uf3hguptmZR8dCyB7Wis/N/
         6TiRaijwnukufR3vnDzFKaPusC8gJXrVE5zYxNz/nVgc2JDfoQH3NRD3LVojrvQVDuU3
         YiE4nsXBRbR2WXRG0o3YlpSMC9dxAH3FFFgWVtiCWRT17GuqhmevdAFIcjbWGQ3/Nk1C
         WUKNwIE00InKAqzW3dRHFFUD53XMKHK7JSldT9pIyjR8zYb7LNPcugo1cymgPg3iti/X
         aOWg==
X-Gm-Message-State: AOAM530KLjc9QCD+CMBpW2xiEScllm5tUSDBDWLaG/I3RZtf1RgOBLWe
        ttoASyOIRd+znB2a8tYE/8j3Xgs+d8AAeuSCCHEpASn+5EFQ6dm5/yYjHQ4HLX5dFnXqh78EQGg
        9KuAa+ZZosyE0
X-Received: by 2002:a50:fb08:: with SMTP id d8mr12725037edq.160.1630927253392;
        Mon, 06 Sep 2021 04:20:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnXiZkAIDU73uVyPn+3O20GkHTxFw7vX6uAGTN6zNHOCvY8p6FyX/5L/Q7XXf2IlUH+ouktQ==
X-Received: by 2002:a50:fb08:: with SMTP id d8mr12725016edq.160.1630927253147;
        Mon, 06 Sep 2021 04:20:53 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id f1sm4406891edq.89.2021.09.06.04.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 04:20:51 -0700 (PDT)
Date:   Mon, 6 Sep 2021 07:20:47 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, hch@infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
Message-ID: <20210906071957-mutt-send-email-mst@kernel.org>
References: <20210831135035.6443-1-mgurtovoy@nvidia.com>
 <YTDVkDIr5WLdlRsK@stefanha-x1.localdomain>
 <20210905120234-mutt-send-email-mst@kernel.org>
 <98309fcd-3abe-1f27-fe52-e8fcc58bec13@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98309fcd-3abe-1f27-fe52-e8fcc58bec13@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
> 
> On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
> > On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
> > > On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
> > > > Sometimes a user would like to control the amount of IO queues to be
> > > > created for a block device. For example, for limiting the memory
> > > > footprint of virtio-blk devices.
> > > > 
> > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > ---
> > > > 
> > > > changes from v1:
> > > >   - use param_set_uint_minmax (from Christoph)
> > > >   - added "Should > 0" to module description
> > > > 
> > > > Note: This commit apply on top of Jens's branch for-5.15/drivers
> > > > ---
> > > >   drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
> > > >   1 file changed, 19 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > > index 4b49df2dfd23..9332fc4e9b31 100644
> > > > --- a/drivers/block/virtio_blk.c
> > > > +++ b/drivers/block/virtio_blk.c
> > > > @@ -24,6 +24,22 @@
> > > >   /* The maximum number of sg elements that fit into a virtqueue */
> > > >   #define VIRTIO_BLK_MAX_SG_ELEMS 32768
> > > > +static int virtblk_queue_count_set(const char *val,
> > > > +		const struct kernel_param *kp)
> > > > +{
> > > > +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> > > > +}


Hmm which tree is this for?

> > > > +
> > > > +static const struct kernel_param_ops queue_count_ops = {
> > > > +	.set = virtblk_queue_count_set,
> > > > +	.get = param_get_uint,
> > > > +};
> > > > +
> > > > +static unsigned int num_io_queues;
> > > > +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
> > > > +MODULE_PARM_DESC(num_io_queues,
> > > > +		 "Number of IO virt queues to use for blk device. Should > 0");



better:

+MODULE_PARM_DESC(num_io_request_queues,
+                "Limit number of IO request virt queues to use for each device. 0 for now limit");


> > > > +
> > > >   static int major;
> > > >   static DEFINE_IDA(vd_index_ida);
> > > > @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
> > > >   	if (err)
> > > >   		num_vqs = 1;
> > > > -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
> > > > +	num_vqs = min_t(unsigned int,
> > > > +			min_not_zero(num_io_queues, nr_cpu_ids),
> > > > +			num_vqs);
> > > If you respin, please consider calling them request queues. That's the
> > > terminology from the VIRTIO spec and it's nice to keep it consistent.
> > > But the purpose of num_io_queues is clear, so:
> > > 
> > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > I did this:
> > +static unsigned int num_io_request_queues;
> > +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
> > +MODULE_PARM_DESC(num_io_request_queues,
> > +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
> 
> The parameter is writable and can be changed and then new devices might be
> probed with new value.
> 
> It can't be zero in the code. we can change param_set_uint_minmax args and
> say that 0 says nr_cpus.
> 
> I'm ok with the renaming but I prefer to stick to the description we gave in
> V3 of this patch (and maybe enable value of 0 as mentioned above).

