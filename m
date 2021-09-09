Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE55405839
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 15:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbhIINsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 09:48:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355555AbhIINn7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 09:43:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631194966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n9yyglc648zrXRd4AVW4tP74FHofD3/df+6dNncY9Pg=;
        b=CO8vWqg4jxBXqdTdjSJ50KB/h3GlikvsbEYC3bpvdzdV/q9C01hnztEQNm4a5HkzY0w6KO
        nb3oFwG6BUOXu0WESlCH/XgL3989SBe2mtzct2ajLUmCTnJSIG/w5C2qLpJ1YOX8rHJ/yW
        H31BzQ29GN8WOEX69xIZbzsm8Ecbz/8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-g8Tqlj_mPn-oiRQMDxW5bw-1; Thu, 09 Sep 2021 09:42:45 -0400
X-MC-Unique: g8Tqlj_mPn-oiRQMDxW5bw-1
Received: by mail-ej1-f71.google.com with SMTP id jg32-20020a170907972000b005e801aed08aso807220ejc.4
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 06:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n9yyglc648zrXRd4AVW4tP74FHofD3/df+6dNncY9Pg=;
        b=RyLAuP6uuRYWDqggboh7uBui/n07h4eVqHWAMe4qvYpXfFlSVw93ERYhxrbokf5BWF
         Cz2GSvqfoibc8/bS9mzjJU1D/VKPe6761kNaJf+KKCPogHmzkIDQ0yZpFLlGcnGEn9vN
         Ij/PcMTiQAUILpOLKeId/LaDduxyXh1WJ6leKTK1de2zcI8Qp/zAr1RhQqMfLIQ38AV9
         U2scvYegTES1fAk/Af1SgwLcH8UMRhv0LLHxZ+PGmfKjON3sRljuPmiEJHFUo19qzLwz
         Tzt3Dy+Z2cQuSmYGt8hRjWFJRPeKRnfOzWhAtHmyoa5dgh8xKeWT6JX6c54lp2oVHqtf
         34ww==
X-Gm-Message-State: AOAM533ZyLrOnpdqSgcj2+QSI9q+1hLZtKDZLmoX8vSktwHM1hkudd9X
        AEhzDOJ09A5OrsvB289DUQLbXBFqN5Q6+On6lGAMfBo/NxToRyxdKSfRvTQbQRGGICX36NmqNk+
        dYQz7M0+uHnh6
X-Received: by 2002:a17:907:8693:: with SMTP id qa19mr3393408ejc.497.1631194964155;
        Thu, 09 Sep 2021 06:42:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywg/VJhF4XMVecjE+sPO8g/1PS5O4JAqpPXl2kjl3hyVJTihD7bfJVln+dRryMMPsNiUjk1w==
X-Received: by 2002:a17:907:8693:: with SMTP id qa19mr3393389ejc.497.1631194963948;
        Thu, 09 Sep 2021 06:42:43 -0700 (PDT)
Received: from redhat.com ([2.55.145.189])
        by smtp.gmail.com with ESMTPSA id o21sm1078830edc.47.2021.09.09.06.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 06:42:43 -0700 (PDT)
Date:   Thu, 9 Sep 2021 09:42:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, hch@infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
Message-ID: <20210909094001-mutt-send-email-mst@kernel.org>
References: <20210831135035.6443-1-mgurtovoy@nvidia.com>
 <YTDVkDIr5WLdlRsK@stefanha-x1.localdomain>
 <20210905120234-mutt-send-email-mst@kernel.org>
 <98309fcd-3abe-1f27-fe52-e8fcc58bec13@nvidia.com>
 <20210906071957-mutt-send-email-mst@kernel.org>
 <1cbbe6e2-1473-8696-565c-518fc1016a1a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cbbe6e2-1473-8696-565c-518fc1016a1a@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 06, 2021 at 02:59:40PM +0300, Max Gurtovoy wrote:
> 
> On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
> > On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
> > > On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
> > > > On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
> > > > > On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
> > > > > > Sometimes a user would like to control the amount of IO queues to be
> > > > > > created for a block device. For example, for limiting the memory
> > > > > > footprint of virtio-blk devices.
> > > > > > 
> > > > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > > > ---
> > > > > > 
> > > > > > changes from v1:
> > > > > >    - use param_set_uint_minmax (from Christoph)
> > > > > >    - added "Should > 0" to module description
> > > > > > 
> > > > > > Note: This commit apply on top of Jens's branch for-5.15/drivers
> > > > > > ---
> > > > > >    drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
> > > > > >    1 file changed, 19 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > > > > index 4b49df2dfd23..9332fc4e9b31 100644
> > > > > > --- a/drivers/block/virtio_blk.c
> > > > > > +++ b/drivers/block/virtio_blk.c
> > > > > > @@ -24,6 +24,22 @@
> > > > > >    /* The maximum number of sg elements that fit into a virtqueue */
> > > > > >    #define VIRTIO_BLK_MAX_SG_ELEMS 32768
> > > > > > +static int virtblk_queue_count_set(const char *val,
> > > > > > +		const struct kernel_param *kp)
> > > > > > +{
> > > > > > +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> > > > > > +}
> > 
> > Hmm which tree is this for?
> 
> I've mentioned in the note that it apply on branch for-5.15/drivers. But now
> you can apply it on linus/master as well.
> 
> 
> > 
> > > > > > +
> > > > > > +static const struct kernel_param_ops queue_count_ops = {
> > > > > > +	.set = virtblk_queue_count_set,
> > > > > > +	.get = param_get_uint,
> > > > > > +};
> > > > > > +
> > > > > > +static unsigned int num_io_queues;
> > > > > > +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
> > > > > > +MODULE_PARM_DESC(num_io_queues,
> > > > > > +		 "Number of IO virt queues to use for blk device. Should > 0");
> > 
> > 
> > better:
> > 
> > +MODULE_PARM_DESC(num_io_request_queues,
> > +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
> 
> You proposed it and I replied on it bellow.


Can't say I understand 100% what you are saying. Want to send
a description that does make sense to you but
also reflects reality? 0 is the default so
"should > 0" besides being ungrammatical does not seem t"
reflect what it does ...

> 
> > 
> > 
> > > > > > +
> > > > > >    static int major;
> > > > > >    static DEFINE_IDA(vd_index_ida);
> > > > > > @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
> > > > > >    	if (err)
> > > > > >    		num_vqs = 1;
> > > > > > -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
> > > > > > +	num_vqs = min_t(unsigned int,
> > > > > > +			min_not_zero(num_io_queues, nr_cpu_ids),
> > > > > > +			num_vqs);
> > > > > If you respin, please consider calling them request queues. That's the
> > > > > terminology from the VIRTIO spec and it's nice to keep it consistent.
> > > > > But the purpose of num_io_queues is clear, so:
> > > > > 
> > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > I did this:
> > > > +static unsigned int num_io_request_queues;
> > > > +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
> > > > +MODULE_PARM_DESC(num_io_request_queues,
> > > > +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
> > > The parameter is writable and can be changed and then new devices might be
> > > probed with new value.
> > > 
> > > It can't be zero in the code. we can change param_set_uint_minmax args and
> > > say that 0 says nr_cpus.
> > > 
> > > I'm ok with the renaming but I prefer to stick to the description we gave in
> > > V3 of this patch (and maybe enable value of 0 as mentioned above).

