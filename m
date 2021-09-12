Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF45D407C8B
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 11:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhILJIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 05:08:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60762 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231970AbhILJIa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 05:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631437635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l12vL/VKzgR/djsTuONg86Gvt7zQZ+tzhcbHZ15clCg=;
        b=gykUI1tbQqZQUgBzh4cCs2RUgOmL3dFGSA2hk6Xb5vVY97hLujsJ2gkKYdNHJ4SV4EAuU/
        OZAG8wnL3QwDK0uZpYQTt0roSJqQUu7lGiQSrceQ/9M26xQTjZPdNl/OrZyKtPeYENch1C
        j0DhbT4KOQW/8gaFFwO4rKnK/uGd/eM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-7jBCY-KPPreC419Y0Hvksg-1; Sun, 12 Sep 2021 05:07:14 -0400
X-MC-Unique: 7jBCY-KPPreC419Y0Hvksg-1
Received: by mail-wm1-f70.google.com with SMTP id a144-20020a1c7f96000000b002fee1aceb6dso3392083wmd.0
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 02:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l12vL/VKzgR/djsTuONg86Gvt7zQZ+tzhcbHZ15clCg=;
        b=kMMAW9DwzyJCOk147dknpyrwa7c6opNuhCVcTUSPTJR2lVfpg5bSQwepf5b2n8bECK
         ieaxqWt3W/pJ/GmLxHBZqdFPVqKjfMjDfVb9f4poLKMApQFNXzeGOqwfqb8fB0lttZKe
         hWe0Oi5LKuf0c9M1GBtuYu8hIgBPcu17sqwLqb1sNK87UO8e1C6sOTGpc+gYkxJRFF2/
         8I5XH6v2jrOH71poBb0qkG2m4UiPu1IrR436Bs1FwhuwJJfBUIkIc4gdPmqQhiRcIkc6
         WCi5LbPnyDgso18SVAEDJGsOrDeXC8frT9/Fhe14D+Ocf3J3XmflZ5R92/qDnfLV8npQ
         ViAg==
X-Gm-Message-State: AOAM53221aOdWsAhY1p9ekfTEnGZt7N3QtnhPBiTfvmnIdYwTck5D+7s
        yYnpFKwNdvd3OBGkoSUcVzYDFaK76poWATVaT+Q5qPHNhylygvearlepN6VxQ3d0pN+mBBiqiqz
        /ngMBeO/D/wsD
X-Received: by 2002:a1c:21c3:: with SMTP id h186mr6025334wmh.18.1631437633539;
        Sun, 12 Sep 2021 02:07:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyksgGKu1JHZ/Bk9BSbOgpbFQ2UGfY2aMUP2WBqJnMX3Emu+T8sSJLW3dT/cjiUe/WT9WXMFA==
X-Received: by 2002:a1c:21c3:: with SMTP id h186mr6025313wmh.18.1631437633261;
        Sun, 12 Sep 2021 02:07:13 -0700 (PDT)
Received: from redhat.com ([2.55.27.174])
        by smtp.gmail.com with ESMTPSA id m5sm3660162wmi.1.2021.09.12.02.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 02:07:12 -0700 (PDT)
Date:   Sun, 12 Sep 2021 05:07:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, hch@infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
Message-ID: <20210912050531-mutt-send-email-mst@kernel.org>
References: <20210906071957-mutt-send-email-mst@kernel.org>
 <1cbbe6e2-1473-8696-565c-518fc1016a1a@nvidia.com>
 <20210909094001-mutt-send-email-mst@kernel.org>
 <456e1704-67e9-aac9-a82a-44fed65dd153@nvidia.com>
 <20210909114029-mutt-send-email-mst@kernel.org>
 <da61fec0-e90f-0020-c836-c2e58d32be27@nvidia.com>
 <20210909123035-mutt-send-email-mst@kernel.org>
 <0cd4ab50-1bb2-3baf-fc00-b2045e8f8eb1@nvidia.com>
 <20210909185525-mutt-send-email-mst@kernel.org>
 <9de9a43a-2d3a-493b-516e-4601778b9237@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9de9a43a-2d3a-493b-516e-4601778b9237@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 11, 2021 at 03:56:45PM +0300, Max Gurtovoy wrote:
> 
> On 9/10/2021 1:57 AM, Michael S. Tsirkin wrote:
> > On Thu, Sep 09, 2021 at 07:45:42PM +0300, Max Gurtovoy wrote:
> > > On 9/9/2021 7:31 PM, Michael S. Tsirkin wrote:
> > > > On Thu, Sep 09, 2021 at 06:51:56PM +0300, Max Gurtovoy wrote:
> > > > > On 9/9/2021 6:40 PM, Michael S. Tsirkin wrote:
> > > > > > On Thu, Sep 09, 2021 at 06:37:37PM +0300, Max Gurtovoy wrote:
> > > > > > > On 9/9/2021 4:42 PM, Michael S. Tsirkin wrote:
> > > > > > > > On Mon, Sep 06, 2021 at 02:59:40PM +0300, Max Gurtovoy wrote:
> > > > > > > > > On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
> > > > > > > > > > On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
> > > > > > > > > > > On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
> > > > > > > > > > > > On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
> > > > > > > > > > > > > On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
> > > > > > > > > > > > > > Sometimes a user would like to control the amount of IO queues to be
> > > > > > > > > > > > > > created for a block device. For example, for limiting the memory
> > > > > > > > > > > > > > footprint of virtio-blk devices.
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > > > > > > > > > > > ---
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > changes from v1:
> > > > > > > > > > > > > >        - use param_set_uint_minmax (from Christoph)
> > > > > > > > > > > > > >        - added "Should > 0" to module description
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > Note: This commit apply on top of Jens's branch for-5.15/drivers
> > > > > > > > > > > > > > ---
> > > > > > > > > > > > > >        drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
> > > > > > > > > > > > > >        1 file changed, 19 insertions(+), 1 deletion(-)
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > > > > > > > > > > > > index 4b49df2dfd23..9332fc4e9b31 100644
> > > > > > > > > > > > > > --- a/drivers/block/virtio_blk.c
> > > > > > > > > > > > > > +++ b/drivers/block/virtio_blk.c
> > > > > > > > > > > > > > @@ -24,6 +24,22 @@
> > > > > > > > > > > > > >        /* The maximum number of sg elements that fit into a virtqueue */
> > > > > > > > > > > > > >        #define VIRTIO_BLK_MAX_SG_ELEMS 32768
> > > > > > > > > > > > > > +static int virtblk_queue_count_set(const char *val,
> > > > > > > > > > > > > > +		const struct kernel_param *kp)
> > > > > > > > > > > > > > +{
> > > > > > > > > > > > > > +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> > > > > > > > > > > > > > +}
> > > > > > > > > > Hmm which tree is this for?
> > > > > > > > > I've mentioned in the note that it apply on branch for-5.15/drivers. But now
> > > > > > > > > you can apply it on linus/master as well.
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > > +static const struct kernel_param_ops queue_count_ops = {
> > > > > > > > > > > > > > +	.set = virtblk_queue_count_set,
> > > > > > > > > > > > > > +	.get = param_get_uint,
> > > > > > > > > > > > > > +};
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > > +static unsigned int num_io_queues;
> > > > > > > > > > > > > > +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
> > > > > > > > > > > > > > +MODULE_PARM_DESC(num_io_queues,
> > > > > > > > > > > > > > +		 "Number of IO virt queues to use for blk device. Should > 0");
> > > > > > > > > > better:
> > > > > > > > > > 
> > > > > > > > > > +MODULE_PARM_DESC(num_io_request_queues,
> > > > > > > > > > +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
> > > > > > > > > You proposed it and I replied on it bellow.
> > > > > > > > Can't say I understand 100% what you are saying. Want to send
> > > > > > > > a description that does make sense to you but
> > > > > > > > also reflects reality? 0 is the default so
> > > > > > > > "should > 0" besides being ungrammatical does not seem t"
> > > > > > > > reflect what it does ...
> > > > > > > if you "modprobe virtio_blk" the previous behavior will happen.
> > > > > > > 
> > > > > > > You can't "modprobe virtio_blk num_io_request_queues=0" since the minimal
> > > > > > > value is 1.
> > > > > > > 
> > > > > > > So your description is not reflecting the code.
> > > > > > > 
> > > > > > > We can do:
> > > > > > > 
> > > > > > > MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. Minimum value is 1 queue");
> > > > > > What's the default value? We should document that.
> > > > > default value for static global variables is 0.
> > > > > 
> > > > > MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to
> > > > > use for blk device. Minimum value is 1 queue. Default and Maximum value is
> > > > > equal to the total number of CPUs");
> > > > So it says it's the # of cpus but yoiu inspect it with
> > > > sysfs and it's actually 0. Let's say that's confusing
> > > > at the least. why not just let users set it to 0
> > > > and document that?
> > > > 
> > > Setting it by the user to 0 makes no sense.
> > > 
> > > We can say "if not set, the value equals to the total number of CPUs".
> > the value is 0. it seems to mean "no limit". the actual # of queues is
> > then te smaller between # of cpus and # of hardware queues.
> > I see no reason not to allow user to set that especially if
> > it was originally the value then user changed it
> > and is trying to change it back.
> 
> I fine with that.
> 
> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. 0 value means no limitation");
> 

OK and the second distinction is that it's a limit on the
number, not the actual number. It's never more than what's provided
by the hypervisor.

> > 
> > > The actual value of the created queues can be seen in /sys/block/vda/mq/ as
> > > done today.
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > >        static int major;
> > > > > > > > > > > > > >        static DEFINE_IDA(vd_index_ida);
> > > > > > > > > > > > > > @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
> > > > > > > > > > > > > >        	if (err)
> > > > > > > > > > > > > >        		num_vqs = 1;
> > > > > > > > > > > > > > -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
> > > > > > > > > > > > > > +	num_vqs = min_t(unsigned int,
> > > > > > > > > > > > > > +			min_not_zero(num_io_queues, nr_cpu_ids),
> > > > > > > > > > > > > > +			num_vqs);
> > > > > > > > > > > > > If you respin, please consider calling them request queues. That's the
> > > > > > > > > > > > > terminology from the VIRTIO spec and it's nice to keep it consistent.
> > > > > > > > > > > > > But the purpose of num_io_queues is clear, so:
> > > > > > > > > > > > > 
> > > > > > > > > > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > > > > > > > I did this:
> > > > > > > > > > > > +static unsigned int num_io_request_queues;
> > > > > > > > > > > > +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
> > > > > > > > > > > > +MODULE_PARM_DESC(num_io_request_queues,
> > > > > > > > > > > > +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
> > > > > > > > > > > The parameter is writable and can be changed and then new devices might be
> > > > > > > > > > > probed with new value.
> > > > > > > > > > > 
> > > > > > > > > > > It can't be zero in the code. we can change param_set_uint_minmax args and
> > > > > > > > > > > say that 0 says nr_cpus.
> > > > > > > > > > > 
> > > > > > > > > > > I'm ok with the renaming but I prefer to stick to the description we gave in
> > > > > > > > > > > V3 of this patch (and maybe enable value of 0 as mentioned above).

