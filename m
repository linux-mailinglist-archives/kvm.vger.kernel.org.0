Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFB3251A38
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 15:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHYNxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 09:53:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47449 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726449AbgHYNxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 09:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598363613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=138cvp+YSMgYfNEN+hQF14KPIqzw0MKaD5TwzikQyNY=;
        b=WGKESrTeiOMTzSQKi0RZkynXp8rD2XnFUsLvDPE3/6DcSLUHyd3fUzjmQZSnySl3IsZCtq
        3hG/Df1hREAwVm/+Nyf0PzpzTQcHK1/HD3FFQ4rlLePjJjFTOZvEmc2kYAH1yhRtyLVCV1
        uZ0HBxkWZAoBjNiJbPvOWW7BpI26284=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-30bt5nkdNqu0_C7R68nLbQ-1; Tue, 25 Aug 2020 09:53:31 -0400
X-MC-Unique: 30bt5nkdNqu0_C7R68nLbQ-1
Received: by mail-qt1-f199.google.com with SMTP id w15so9364372qtv.11
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 06:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=138cvp+YSMgYfNEN+hQF14KPIqzw0MKaD5TwzikQyNY=;
        b=HPRFU/rNxXW79fR4+ydvv8TZRdhb5JhOjPhBTUquI5FoAlwlQtwKMWSzA8ukACNx0N
         7B1JsQAT55JmDptRvdWCyQdFj6yk3Jc3giiQd6oiFfjZiX4tzMxir2nd2phcC+l4+LpO
         Ot+RLC4Os60tYLZNMV4l+Aw4D9+LFjN8+uX8QAzuNpjoWaPnfnPDa67qVVT8hzD9MHP7
         GCBoqezUDhc7efiQQny4tQG3juedz/SxZU3pKfQAAne3QyNbmM9to36wC5Tf0kGvrCqg
         GO0If+G74pslaOQOqEbbECHh2l/0JaScPy9XjmpQqULQ6jyIrYeky9DKeI2J6KSbsCdb
         Po1A==
X-Gm-Message-State: AOAM53112Jlpxsgbc2zOsFsci2mgW5exg/p4SXWKbwgiWJsmzCfE5Lnq
        QTVjvtgM7BHDqYzQ6IA3XgTZfqcbjbQxeHIcHZvW19wo8d/lYVEw6sju87orffvFkvQA3/iRoQJ
        p2CX4cUmoAHZo
X-Received: by 2002:ac8:564f:: with SMTP id 15mr9428441qtt.54.1598363610799;
        Tue, 25 Aug 2020 06:53:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPrT+ZhqGX/WxO3DdmtRmLzR6D+VgulQzBW64lie1cdwBxPXFdHdxWQdatgY6vKjfkuFcqew==
X-Received: by 2002:ac8:564f:: with SMTP id 15mr9428417qtt.54.1598363610497;
        Tue, 25 Aug 2020 06:53:30 -0700 (PDT)
Received: from redhat.com (bzq-109-64-136-54.red.bezeqint.net. [109.64.136.54])
        by smtp.gmail.com with ESMTPSA id v24sm1877951qtb.13.2020.08.25.06.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 06:53:29 -0700 (PDT)
Date:   Tue, 25 Aug 2020 09:53:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v4 4/4] vhost: add an RPMsg API
Message-ID: <20200825095148-mutt-send-email-mst@kernel.org>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200722150927.15587-5-guennadi.liakhovetski@linux.intel.com>
 <20200804102132-mutt-send-email-mst@kernel.org>
 <20200804151916.GC19025@ubuntu>
 <20200810094013-mutt-send-email-mst@kernel.org>
 <20200812123243.GA10218@ubuntu>
 <20200825134109.GA9822@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825134109.GA9822@ubuntu>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 25, 2020 at 03:41:10PM +0200, Guennadi Liakhovetski wrote:
> Hi Michael,
> 
> ...back from holidays and still unsure what your preferred solution 
> for the message layout would be:
> 
> On Wed, Aug 12, 2020 at 02:32:43PM +0200, Guennadi Liakhovetski wrote:
> > Hi Michael,
> > 
> > Thanks for a review.
> > 
> > On Mon, Aug 10, 2020 at 09:44:15AM -0400, Michael S. Tsirkin wrote:
> > > On Tue, Aug 04, 2020 at 05:19:17PM +0200, Guennadi Liakhovetski wrote:
> 
> [snip]
> 
> > > > > > +static int vhost_rpmsg_get_single(struct vhost_virtqueue *vq)
> > > > > > +{
> > > > > > +	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
> > > > > > +	unsigned int out, in;
> > > > > > +	int head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov), &out, &in,
> > > > > > +				     NULL, NULL);
> > > > > > +	if (head < 0) {
> > > > > > +		vq_err(vq, "%s(): error %d getting buffer\n",
> > > > > > +		       __func__, head);
> > > > > > +		return head;
> > > > > > +	}
> > > > > > +
> > > > > > +	/* Nothing new? */
> > > > > > +	if (head == vq->num)
> > > > > > +		return head;
> > > > > > +
> > > > > > +	if (vq == &vr->vq[VIRTIO_RPMSG_RESPONSE] && (out || in != 1)) {
> > > > > 
> > > > > This in != 1 looks like a dependency on a specific message layout.
> > > > > virtio spec says to avoid these. Using iov iters it's not too hard to do
> > > > > ...
> > > > 
> > > > This is an RPMsg VirtIO implementation, and it has to match the virtio_rpmsg_bus.c 
> > > > driver, and that one has specific VirtIO queue and message usage patterns.
> > > 
> > > That could be fine for legacy virtio, but now you are claiming support
> > > for virtio 1, so need to fix these assumptions in the device.
> > 
> > I can just deop these checks without changing anything else, that still would work. 
> > I could also make this work with "any" layout - either ignoring any left-over 
> > buffers or maybe even getting them one by one. But I wouldn't even be able to test 
> > those modes without modifying / breaking the current virtio-rpmsg driver. What's 
> > the preferred solution?
> 
> Could you elaborate a bit please?
> 
> Thanks
> Guennadi

I'd prefer it that we make it work with any layout.
For testing, there was a hack for virtio ring which
split up descriptors at a random boundary.
I'll try to locate it and post, sounds like something
we might want upstream for debugging.

-- 
MST

