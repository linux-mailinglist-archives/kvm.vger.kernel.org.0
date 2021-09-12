Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF526407D15
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 13:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhILLrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 07:47:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhILLrR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 07:47:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631447163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2w6P0+qJqIqn2oiEb43xpIz2t91vGIQGpoY+hx464sg=;
        b=WR1RtWprDIrbv95VnKj3Q4fQBq9tw7v/vV4EZI18oFrjqu4V34UfdJs+LB13C66XPZFONz
        2pSD0Cmw627OHcmOkxkPFmoRpXwwHpssNDK9Bstvp9bE2qyv5BQnNSvMbkoTZ9dmlRROk9
        gdKzFO1SGF/PK5rfTVAGYji68qnGVhc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-7Q1iHCYTPRKmXNHH4RhKQQ-1; Sun, 12 Sep 2021 07:46:02 -0400
X-MC-Unique: 7Q1iHCYTPRKmXNHH4RhKQQ-1
Received: by mail-wr1-f70.google.com with SMTP id i16-20020adfded0000000b001572ebd528eso1796114wrn.19
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 04:46:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2w6P0+qJqIqn2oiEb43xpIz2t91vGIQGpoY+hx464sg=;
        b=1/Nfu6fvwLdYfo6hZJkOxP9JrgWKHk7xTm4wHmqGjJcdId+1pNG5TxAdLBaCAQ3LYg
         knp7br1dJnAwSxyI9OTNC6HGmolU4zfWLOtI6Yk+toSoASraEUpq+KZLeKARJRK+bRia
         GWVc7frcMjqXniQZ2TcyUloQTk8YnpXaxFHndbAJ/ji+dM5eCOmFd964uIspJ6Wt3v12
         qjST4qbnjsJAQq/RaTFzN0833vzxhWn1qyJfWYq0VZUORS5IzMyM9UFO5F4C+zOxQIY6
         PfcqVFUZZI7daAF9e99X40nlcs3Dcnz3Af+duwlXDZis0pVAs7CkcJKvtfUTGeQJi6xF
         hw5g==
X-Gm-Message-State: AOAM5325NAZfcHQTvgdeGpL5mujLNj9y7ht4q6aXJCVt/4W5d1kWyj2L
        +CaCunwx2aAEDJo0HsP9N4/bJsvLcjSKgGwJ2y3LVJIWuhHbrI2ACiSMyjJR7gCNKlat9EbA4bf
        UFvZMiE0V3c2c
X-Received: by 2002:a5d:530c:: with SMTP id e12mr7269105wrv.81.1631447160666;
        Sun, 12 Sep 2021 04:46:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhUjgCMAnGYGrbpzgxtHHYuSfveqwGzajauA4sHdyXGigncu1+dSH127F1yaBqipVA7eIjRw==
X-Received: by 2002:a5d:530c:: with SMTP id e12mr7269091wrv.81.1631447160421;
        Sun, 12 Sep 2021 04:46:00 -0700 (PDT)
Received: from redhat.com ([2.55.27.174])
        by smtp.gmail.com with ESMTPSA id y18sm4339175wrq.6.2021.09.12.04.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 04:45:59 -0700 (PDT)
Date:   Sun, 12 Sep 2021 07:45:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, hch@infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
Message-ID: <20210912074308-mutt-send-email-mst@kernel.org>
References: <20210909114029-mutt-send-email-mst@kernel.org>
 <da61fec0-e90f-0020-c836-c2e58d32be27@nvidia.com>
 <20210909123035-mutt-send-email-mst@kernel.org>
 <0cd4ab50-1bb2-3baf-fc00-b2045e8f8eb1@nvidia.com>
 <20210909185525-mutt-send-email-mst@kernel.org>
 <9de9a43a-2d3a-493b-516e-4601778b9237@nvidia.com>
 <20210912050531-mutt-send-email-mst@kernel.org>
 <f58f955e-ef27-fba1-7417-8d37a175e872@nvidia.com>
 <20210912054959-mutt-send-email-mst@kernel.org>
 <eb7c3e87-d71e-9f86-c5c6-6a8b9474f78a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb7c3e87-d71e-9f86-c5c6-6a8b9474f78a@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 12, 2021 at 01:33:13PM +0300, Max Gurtovoy wrote:
> 
> On 9/12/2021 12:50 PM, Michael S. Tsirkin wrote:
> > On Sun, Sep 12, 2021 at 12:37:26PM +0300, Max Gurtovoy wrote:
> > > On 9/12/2021 12:07 PM, Michael S. Tsirkin wrote:
> > > > On Sat, Sep 11, 2021 at 03:56:45PM +0300, Max Gurtovoy wrote:
> > > > > On 9/10/2021 1:57 AM, Michael S. Tsirkin wrote:
> > > > > > On Thu, Sep 09, 2021 at 07:45:42PM +0300, Max Gurtovoy wrote:
> > > > > > > On 9/9/2021 7:31 PM, Michael S. Tsirkin wrote:
> > > > > > > > On Thu, Sep 09, 2021 at 06:51:56PM +0300, Max Gurtovoy wrote:
> > > > > > > > > On 9/9/2021 6:40 PM, Michael S. Tsirkin wrote:
> > > > > > > > > > On Thu, Sep 09, 2021 at 06:37:37PM +0300, Max Gurtovoy wrote:
> > > > > > > > > > > On 9/9/2021 4:42 PM, Michael S. Tsirkin wrote:
> > > > > > > > > > > > On Mon, Sep 06, 2021 at 02:59:40PM +0300, Max Gurtovoy wrote:
> > > > > > > > > > > > > On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
> > > > > > > > > > > > > > On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
> > > > > > > > > > > > > > > On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
> > > > > > > > > > > > > > > > On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
> > > > > > > > > > > > > > > > > On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
> > > > > > > > > > > > > > > > > > Sometimes a user would like to control the amount of IO queues to be
> > > > > > > > > > > > > > > > > > created for a block device. For example, for limiting the memory
> > > > > > > > > > > > > > > > > > footprint of virtio-blk devices.
> > > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > > > > > > > > > > > > > > > ---
> > > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > changes from v1:
> > > > > > > > > > > > > > > > > >          - use param_set_uint_minmax (from Christoph)
> > > > > > > > > > > > > > > > > >          - added "Should > 0" to module description
> > > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > Note: This commit apply on top of Jens's branch for-5.15/drivers
> > > > > > > > > > > > > > > > > > ---
> > > > > > > > > > > > > > > > > >          drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
> > > > > > > > > > > > > > > > > >          1 file changed, 19 insertions(+), 1 deletion(-)
> > > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > > > > > > > > > > > > > > > > index 4b49df2dfd23..9332fc4e9b31 100644
> > > > > > > > > > > > > > > > > > --- a/drivers/block/virtio_blk.c
> > > > > > > > > > > > > > > > > > +++ b/drivers/block/virtio_blk.c
> > > > > > > > > > > > > > > > > > @@ -24,6 +24,22 @@
> > > > > > > > > > > > > > > > > >          /* The maximum number of sg elements that fit into a virtqueue */
> > > > > > > > > > > > > > > > > >          #define VIRTIO_BLK_MAX_SG_ELEMS 32768
> > > > > > > > > > > > > > > > > > +static int virtblk_queue_count_set(const char *val,
> > > > > > > > > > > > > > > > > > +		const struct kernel_param *kp)
> > > > > > > > > > > > > > > > > > +{
> > > > > > > > > > > > > > > > > > +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> > > > > > > > > > > > > > > > > > +}
> > > > > > > > > > > > > > Hmm which tree is this for?
> > > > > > > > > > > > > I've mentioned in the note that it apply on branch for-5.15/drivers. But now
> > > > > > > > > > > > > you can apply it on linus/master as well.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > > > > +static const struct kernel_param_ops queue_count_ops = {
> > > > > > > > > > > > > > > > > > +	.set = virtblk_queue_count_set,
> > > > > > > > > > > > > > > > > > +	.get = param_get_uint,
> > > > > > > > > > > > > > > > > > +};
> > > > > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > > > > +static unsigned int num_io_queues;
> > > > > > > > > > > > > > > > > > +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
> > > > > > > > > > > > > > > > > > +MODULE_PARM_DESC(num_io_queues,
> > > > > > > > > > > > > > > > > > +		 "Number of IO virt queues to use for blk device. Should > 0");
> > > > > > > > > > > > > > better:
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > +MODULE_PARM_DESC(num_io_request_queues,
> > > > > > > > > > > > > > +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
> > > > > > > > > > > > > You proposed it and I replied on it bellow.
> > > > > > > > > > > > Can't say I understand 100% what you are saying. Want to send
> > > > > > > > > > > > a description that does make sense to you but
> > > > > > > > > > > > also reflects reality? 0 is the default so
> > > > > > > > > > > > "should > 0" besides being ungrammatical does not seem t"
> > > > > > > > > > > > reflect what it does ...
> > > > > > > > > > > if you "modprobe virtio_blk" the previous behavior will happen.
> > > > > > > > > > > 
> > > > > > > > > > > You can't "modprobe virtio_blk num_io_request_queues=0" since the minimal
> > > > > > > > > > > value is 1.
> > > > > > > > > > > 
> > > > > > > > > > > So your description is not reflecting the code.
> > > > > > > > > > > 
> > > > > > > > > > > We can do:
> > > > > > > > > > > 
> > > > > > > > > > > MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. Minimum value is 1 queue");
> > > > > > > > > > What's the default value? We should document that.
> > > > > > > > > default value for static global variables is 0.
> > > > > > > > > 
> > > > > > > > > MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to
> > > > > > > > > use for blk device. Minimum value is 1 queue. Default and Maximum value is
> > > > > > > > > equal to the total number of CPUs");
> > > > > > > > So it says it's the # of cpus but yoiu inspect it with
> > > > > > > > sysfs and it's actually 0. Let's say that's confusing
> > > > > > > > at the least. why not just let users set it to 0
> > > > > > > > and document that?
> > > > > > > > 
> > > > > > > Setting it by the user to 0 makes no sense.
> > > > > > > 
> > > > > > > We can say "if not set, the value equals to the total number of CPUs".
> > > > > > the value is 0. it seems to mean "no limit". the actual # of queues is
> > > > > > then te smaller between # of cpus and # of hardware queues.
> > > > > > I see no reason not to allow user to set that especially if
> > > > > > it was originally the value then user changed it
> > > > > > and is trying to change it back.
> > > > > I fine with that.
> > > > > 
> > > > > MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. 0 value means no limitation");
> > > > > 
> > > > OK and the second distinction is that it's a limit on the
> > > > number, not the actual number. It's never more than what's provided
> > > > by the hypervisor.
> > > MODULE_PARM_DESC(num_io_request_queues, "Maximal number of request virt queues to use for blk device. 0 value means no limitation");
> > > 
> > > is that ok ?
> > 
> > Looks ok. And then do we need to limit this to nr_cpu_ids?
> > Setting a value that's too high seems harmless ...
> 
> why would you want that ?

So one can write a script that keeps working even when hypervisor
changes the # of CPU IDs.

It's also consistent with other parameters, e.g.:

        clocksource.verify_n_cpus= [KNL]
                        Limit the number of CPUs checked for clocksources
                        marked with CLOCK_SOURCE_VERIFY_PERCPU that
                        are marked unstable due to excessive skew.
                        A negative value says to check all CPUs, while
                        zero says not to check any.  Values larger than
                        nr_cpu_ids are silently truncated to nr_cpu_ids.

			^^^^^^^^^^^^

                        The actual CPUs are chosen randomly, with
                        no replacement if the same CPU is chosen twice.


> 
> > 
> > > > > > > The actual value of the created queues can be seen in /sys/block/vda/mq/ as
> > > > > > > done today.
> > > > > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > > > >          static int major;
> > > > > > > > > > > > > > > > > >          static DEFINE_IDA(vd_index_ida);
> > > > > > > > > > > > > > > > > > @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
> > > > > > > > > > > > > > > > > >          	if (err)
> > > > > > > > > > > > > > > > > >          		num_vqs = 1;
> > > > > > > > > > > > > > > > > > -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
> > > > > > > > > > > > > > > > > > +	num_vqs = min_t(unsigned int,
> > > > > > > > > > > > > > > > > > +			min_not_zero(num_io_queues, nr_cpu_ids),
> > > > > > > > > > > > > > > > > > +			num_vqs);
> > > > > > > > > > > > > > > > > If you respin, please consider calling them request queues. That's the
> > > > > > > > > > > > > > > > > terminology from the VIRTIO spec and it's nice to keep it consistent.
> > > > > > > > > > > > > > > > > But the purpose of num_io_queues is clear, so:
> > > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > > > > > > > > > > > I did this:
> > > > > > > > > > > > > > > > +static unsigned int num_io_request_queues;
> > > > > > > > > > > > > > > > +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
> > > > > > > > > > > > > > > > +MODULE_PARM_DESC(num_io_request_queues,
> > > > > > > > > > > > > > > > +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
> > > > > > > > > > > > > > > The parameter is writable and can be changed and then new devices might be
> > > > > > > > > > > > > > > probed with new value.
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > It can't be zero in the code. we can change param_set_uint_minmax args and
> > > > > > > > > > > > > > > say that 0 says nr_cpus.
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > I'm ok with the renaming but I prefer to stick to the description we gave in
> > > > > > > > > > > > > > > V3 of this patch (and maybe enable value of 0 as mentioned above).

