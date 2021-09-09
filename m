Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A84405AED
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhIIQdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:33:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhIIQdA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 12:33:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631205110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kbWrdHL+fdDQU8XR6jLdk3HO8KdzpLz8n5o6kPIv+0s=;
        b=fGocEdq219QXIdWPOyNNn4VL6YwJ1PagX9XZHOcAR/WILoQoOe/lMlMv5kBOqLl8+83HQ+
        NNRjBv55cB8hR0+WX85l9X+Mc2lUf7RTvKoL5s1ptOMHGkfiyVJQOR0LKdmSASHOqokICd
        jqjC+zMtpCUSgvBr3YjBQad30w1bSc4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-LtVGzT-DMdSfQESViZVPWA-1; Thu, 09 Sep 2021 12:31:49 -0400
X-MC-Unique: LtVGzT-DMdSfQESViZVPWA-1
Received: by mail-wr1-f72.google.com with SMTP id i16-20020adfded0000000b001572ebd528eso697488wrn.19
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 09:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kbWrdHL+fdDQU8XR6jLdk3HO8KdzpLz8n5o6kPIv+0s=;
        b=iDPTZ9FBsdZ2+HDp1sysGOeyTFwoOYl8/gbdwENEFhO6/Tu+kTnDuXFS7dF9cXEJqr
         qB9hmud+TZzA1TJQtESrhoA7s7ECKHiJb/EVaS6AIqICG45Yew64nveaj3Z50KQEnIkq
         V9zpIoOIduf5xJBZugRWk+oQ7Uj96nl6cyioLIBuXMtLdmoipqEEzGT1NMRTxSE23NJm
         BYVL8E+40urlrD5oZoL7A/oZNQa/ee/CZvbfCT5jM5zZ6Ts3hR/LDS+13OOqtuglHd7a
         ZWt2zq5G4Hkte5Oq5X0+b9r6SRrmF0lbYwgSfO3og47KNTVisA94IL2i9eoOMAegLZRd
         FGww==
X-Gm-Message-State: AOAM530DAKL0IehIDLWzEPcvkV4qHlcbj/WXYfkoAENrkf7SpwKUiuOI
        st1ZFL58/vlpjWW+TDxJfojjUu/R64zNYqffufnkSUqqi1CQhV6/TaUoTtloZK/A0FJqwRNAXSU
        paB0P0kPYgvYO
X-Received: by 2002:adf:914e:: with SMTP id j72mr4702973wrj.428.1631205107927;
        Thu, 09 Sep 2021 09:31:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxp7upXiPwUXg299EvKs1hS+EOTStEfwVLBh4g5I/i4ZUQHiWFs0OTx8Avoo+tEPTJYsi97LQ==
X-Received: by 2002:adf:914e:: with SMTP id j72mr4702945wrj.428.1631205107708;
        Thu, 09 Sep 2021 09:31:47 -0700 (PDT)
Received: from redhat.com ([2.55.145.189])
        by smtp.gmail.com with ESMTPSA id w15sm1948863wmi.4.2021.09.09.09.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 09:31:45 -0700 (PDT)
Date:   Thu, 9 Sep 2021 12:31:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, hch@infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
Message-ID: <20210909123035-mutt-send-email-mst@kernel.org>
References: <20210831135035.6443-1-mgurtovoy@nvidia.com>
 <YTDVkDIr5WLdlRsK@stefanha-x1.localdomain>
 <20210905120234-mutt-send-email-mst@kernel.org>
 <98309fcd-3abe-1f27-fe52-e8fcc58bec13@nvidia.com>
 <20210906071957-mutt-send-email-mst@kernel.org>
 <1cbbe6e2-1473-8696-565c-518fc1016a1a@nvidia.com>
 <20210909094001-mutt-send-email-mst@kernel.org>
 <456e1704-67e9-aac9-a82a-44fed65dd153@nvidia.com>
 <20210909114029-mutt-send-email-mst@kernel.org>
 <da61fec0-e90f-0020-c836-c2e58d32be27@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da61fec0-e90f-0020-c836-c2e58d32be27@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 06:51:56PM +0300, Max Gurtovoy wrote:
> 
> On 9/9/2021 6:40 PM, Michael S. Tsirkin wrote:
> > On Thu, Sep 09, 2021 at 06:37:37PM +0300, Max Gurtovoy wrote:
> > > On 9/9/2021 4:42 PM, Michael S. Tsirkin wrote:
> > > > On Mon, Sep 06, 2021 at 02:59:40PM +0300, Max Gurtovoy wrote:
> > > > > On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
> > > > > > On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
> > > > > > > On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
> > > > > > > > On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
> > > > > > > > > On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
> > > > > > > > > > Sometimes a user would like to control the amount of IO queues to be
> > > > > > > > > > created for a block device. For example, for limiting the memory
> > > > > > > > > > footprint of virtio-blk devices.
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > > > > > > > ---
> > > > > > > > > > 
> > > > > > > > > > changes from v1:
> > > > > > > > > >      - use param_set_uint_minmax (from Christoph)
> > > > > > > > > >      - added "Should > 0" to module description
> > > > > > > > > > 
> > > > > > > > > > Note: This commit apply on top of Jens's branch for-5.15/drivers
> > > > > > > > > > ---
> > > > > > > > > >      drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
> > > > > > > > > >      1 file changed, 19 insertions(+), 1 deletion(-)
> > > > > > > > > > 
> > > > > > > > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > > > > > > > > index 4b49df2dfd23..9332fc4e9b31 100644
> > > > > > > > > > --- a/drivers/block/virtio_blk.c
> > > > > > > > > > +++ b/drivers/block/virtio_blk.c
> > > > > > > > > > @@ -24,6 +24,22 @@
> > > > > > > > > >      /* The maximum number of sg elements that fit into a virtqueue */
> > > > > > > > > >      #define VIRTIO_BLK_MAX_SG_ELEMS 32768
> > > > > > > > > > +static int virtblk_queue_count_set(const char *val,
> > > > > > > > > > +		const struct kernel_param *kp)
> > > > > > > > > > +{
> > > > > > > > > > +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> > > > > > > > > > +}
> > > > > > Hmm which tree is this for?
> > > > > I've mentioned in the note that it apply on branch for-5.15/drivers. But now
> > > > > you can apply it on linus/master as well.
> > > > > 
> > > > > 
> > > > > > > > > > +
> > > > > > > > > > +static const struct kernel_param_ops queue_count_ops = {
> > > > > > > > > > +	.set = virtblk_queue_count_set,
> > > > > > > > > > +	.get = param_get_uint,
> > > > > > > > > > +};
> > > > > > > > > > +
> > > > > > > > > > +static unsigned int num_io_queues;
> > > > > > > > > > +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
> > > > > > > > > > +MODULE_PARM_DESC(num_io_queues,
> > > > > > > > > > +		 "Number of IO virt queues to use for blk device. Should > 0");
> > > > > > better:
> > > > > > 
> > > > > > +MODULE_PARM_DESC(num_io_request_queues,
> > > > > > +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
> > > > > You proposed it and I replied on it bellow.
> > > > Can't say I understand 100% what you are saying. Want to send
> > > > a description that does make sense to you but
> > > > also reflects reality? 0 is the default so
> > > > "should > 0" besides being ungrammatical does not seem t"
> > > > reflect what it does ...
> > > if you "modprobe virtio_blk" the previous behavior will happen.
> > > 
> > > You can't "modprobe virtio_blk num_io_request_queues=0" since the minimal
> > > value is 1.
> > > 
> > > So your description is not reflecting the code.
> > > 
> > > We can do:
> > > 
> > > MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. Minimum value is 1 queue");
> > What's the default value? We should document that.
> 
> default value for static global variables is 0.
> 
> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to
> use for blk device. Minimum value is 1 queue. Default and Maximum value is
> equal to the total number of CPUs");

So it says it's the # of cpus but yoiu inspect it with
sysfs and it's actually 0. Let's say that's confusing
at the least. why not just let users set it to 0
and document that?


> 
> > 
> > > > > > > > > > +
> > > > > > > > > >      static int major;
> > > > > > > > > >      static DEFINE_IDA(vd_index_ida);
> > > > > > > > > > @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
> > > > > > > > > >      	if (err)
> > > > > > > > > >      		num_vqs = 1;
> > > > > > > > > > -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
> > > > > > > > > > +	num_vqs = min_t(unsigned int,
> > > > > > > > > > +			min_not_zero(num_io_queues, nr_cpu_ids),
> > > > > > > > > > +			num_vqs);
> > > > > > > > > If you respin, please consider calling them request queues. That's the
> > > > > > > > > terminology from the VIRTIO spec and it's nice to keep it consistent.
> > > > > > > > > But the purpose of num_io_queues is clear, so:
> > > > > > > > > 
> > > > > > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > > > I did this:
> > > > > > > > +static unsigned int num_io_request_queues;
> > > > > > > > +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
> > > > > > > > +MODULE_PARM_DESC(num_io_request_queues,
> > > > > > > > +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
> > > > > > > The parameter is writable and can be changed and then new devices might be
> > > > > > > probed with new value.
> > > > > > > 
> > > > > > > It can't be zero in the code. we can change param_set_uint_minmax args and
> > > > > > > say that 0 says nr_cpus.
> > > > > > > 
> > > > > > > I'm ok with the renaming but I prefer to stick to the description we gave in
> > > > > > > V3 of this patch (and maybe enable value of 0 as mentioned above).

