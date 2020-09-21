Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BD8271AD0
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 08:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIUGXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 02:23:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:12786 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbgIUGXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 02:23:07 -0400
IronPort-SDR: +Dc4TAoDwkfA2FOkEwKv+4dkxEUoGYDuVpB69LTQsgnkD+ZrZCqZs/pp7DfrswqVp9vUoRL/Ui
 iAy6AYZ0UCRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9750"; a="148070034"
X-IronPort-AV: E=Sophos;i="5.77,285,1596524400"; 
   d="scan'208";a="148070034"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2020 23:23:04 -0700
IronPort-SDR: USb2UDAwyWhLJQWxChZgxFvSXc5aD8EZKTgGEeQPUMLqRDIxK9gy3tRuyDpL1OOMSR9aEqeLGv
 UdRLeyUYUhDg==
X-IronPort-AV: E=Sophos;i="5.77,285,1596524400"; 
   d="scan'208";a="485292430"
Received: from fjanoscz-mobl1.ger.corp.intel.com (HELO ubuntu) ([10.249.45.119])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2020 23:23:01 -0700
Date:   Mon, 21 Sep 2020 08:22:52 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v7 3/3] vhost: add an RPMsg API
Message-ID: <20200921062251.GA27773@ubuntu>
References: <20200910111351.20526-1-guennadi.liakhovetski@linux.intel.com>
 <20200910111351.20526-4-guennadi.liakhovetski@linux.intel.com>
 <20200917220138.GA97950@xps15>
 <20200918090229.GC19246@ubuntu>
 <20200918155249.GA200851@xps15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918155249.GA200851@xps15>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mathieu,

On Fri, Sep 18, 2020 at 09:52:49AM -0600, Mathieu Poirier wrote:
> Good morning,
> 
> On Fri, Sep 18, 2020 at 11:02:29AM +0200, Guennadi Liakhovetski wrote:
> > Hi Mathieu,
> > 
> > On Thu, Sep 17, 2020 at 04:01:38PM -0600, Mathieu Poirier wrote:
> > > On Thu, Sep 10, 2020 at 01:13:51PM +0200, Guennadi Liakhovetski wrote:
> > > > Linux supports running the RPMsg protocol over the VirtIO transport
> > > > protocol, but currently there is only support for VirtIO clients and
> > > > no support for VirtIO servers. This patch adds a vhost-based RPMsg
> > > > server implementation, which makes it possible to use RPMsg over
> > > > VirtIO between guest VMs and the host.
> > > 
> > > I now get the client/server concept you are describing above but that happened
> > > only after a lot of mental gymnastics.  If you drop the whole client/server
> > > concept and concentrate on what this patch does, things will go better.  I would
> > > personally go with what you have in the Kconfig: 
> > > 
> > > > +	  Vhost RPMsg API allows vhost drivers to communicate with VirtIO
> > > > +	  drivers on guest VMs, using the RPMsg over VirtIO protocol.
> > > 
> > > It is concise but describes exactly what this patch provide.
> > 
> > Ok, thanks, will try to improve.
> > 
> > > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > ---
> > > >  drivers/vhost/Kconfig       |   7 +
> > > >  drivers/vhost/Makefile      |   3 +
> > > >  drivers/vhost/rpmsg.c       | 370 ++++++++++++++++++++++++++++++++++++
> > > >  drivers/vhost/vhost_rpmsg.h |  74 ++++++++
> > > >  4 files changed, 454 insertions(+)
> > > >  create mode 100644 drivers/vhost/rpmsg.c
> > > >  create mode 100644 drivers/vhost/vhost_rpmsg.h

[snip]

> > > > diff --git a/drivers/vhost/rpmsg.c b/drivers/vhost/rpmsg.c
> > > > new file mode 100644
> > > > index 000000000000..0ddee5b5f017
> > > > --- /dev/null
> > > > +++ b/drivers/vhost/rpmsg.c
> > > > @@ -0,0 +1,370 @@

[snip]

> > > > +/*
> > > > + * Return false to terminate the external loop only if we fail to obtain either
> > > > + * a request or a response buffer
> > > > + */
> > > > +static bool handle_rpmsg_req_single(struct vhost_rpmsg *vr,
> > > > +				    struct vhost_virtqueue *vq)
> > > > +{
> > > > +	struct vhost_rpmsg_iter iter;
> > > > +	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_REQUEST, -EINVAL);
> > > > +	if (!ret)
> > > > +		ret = vhost_rpmsg_finish_unlock(vr, &iter);
> > > > +	if (ret < 0) {
> > > > +		if (ret != -EAGAIN)
> > > > +			vq_err(vq, "%s(): RPMSG processing failed %d\n",
> > > > +			       __func__, ret);
> > > > +		return false;
> > > > +	}
> > > > +
> > > > +	if (!iter.ept->write)
> > > > +		return true;
> > > > +
> > > > +	ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE, -EINVAL);
> > > > +	if (!ret)
> > > > +		ret = vhost_rpmsg_finish_unlock(vr, &iter);
> > > > +	if (ret < 0) {
> > > > +		vq_err(vq, "%s(): RPMSG finalising failed %d\n", __func__, ret);
> > > > +		return false;
> > > > +	}
> > > 
> > > As I said before dealing with the "response" queue here seems to be introducing
> > > coupling with vhost_rpmsg_start_lock()...  Endpoints should be doing that.
> > 
> > Sorry, could you elaborate a bit, what do you mean by coupling?
> 
> In function vhost_rpmsg_start_lock() the rpmsg header is prepared for a response
> at the end of the processing associated with the reception of a
> VIRTIO_RPMSG_REQUEST.  I assumed (perhaps wrongly) that such as response was
> sent here.  In that case preparing the response and sending the response should
> be done at the same place.

This will change in the next version, in it I'll remove response preparation from 
request handling.

> But my assumption may be completely wrong... A better question should probably
> be why is the VIRTIO_RPMSG_RESPONSE probed in handle_rpmsg_req_single()?
> Shouldn't this be solely concerned with handling requests from the guest?  If
> I'm wondering what is going on I expect other people will also do the same,
> something that could be alleviated with more comments.

My RPMsg implementation supports two modes for sending data from the host (in 
VM terms) to guests: as responses to their requests and as asynchronous 
messages. If there isn't a strict request-response pattern on a certain endpont, 
you leave the .write callback NULL and then you send your messages as you please 
independent of requests. But you can also specify a .write pointer in which case 
after each request to generate a response.

In principle this response handling could be removed, but then drivers, that do 
need to respond to requests would have to schedule an asynchronous action in 
their .read callbacks to be triggered after request processing has completed.

Thanks
Guennadi
