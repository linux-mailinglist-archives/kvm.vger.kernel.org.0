Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C5D264B1F
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 19:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgIJRXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 13:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgIJRWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 13:22:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4C9C0617A0
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 10:22:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w7so5022458pfi.4
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 10:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zU37jFchtU7vlJC8tQFJn/8x7ea5aNHeFxkT8TMsXc0=;
        b=rpv+rdHkjsLMVd4Xh6fyfmpLbIjIB4wa/QKC0Owpj35Tm08NP1R0FSUD0nJHahYNXn
         rAKYx3w/afx32n/Hp1o3w8x0T+VYESwieq4/VytLq85lg0kmqbysAWEncJr05y8P4us6
         VLTLB/CKsq9fTd1LPchKuj5aTkRAoL7zIfGlr5gMkgBrZEmaY++D4gx8uC6yKpW3EPv/
         fJ8xm2XihUiuFJCIUBQ4AnerCbpN458+Lz0w58nqtAyOfpOCo0GIPkJqMSgRH/ur6JIg
         91kPSwrehrUcrtVJrHamad7RYMmtgGDPBX85KuXwRZJFoEfrwwl4h4bADygELQK8v3Pu
         4tMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zU37jFchtU7vlJC8tQFJn/8x7ea5aNHeFxkT8TMsXc0=;
        b=CTuL4TlD+Iqce8lSxtMKWmGumsIlMJDdms7i4VPRPnBfO1YKjJtDvbsdL4f6VC6O+G
         xqlwsSTqGPTLsquTEmSAI+le5215E1CbbyM2QYr2bzmCdAtBHrUdPvvuIm59OmVBs9nq
         ETKebd3X200mDIGitxlYdcXb2B+wkfpEsGgdyMRKUwZXsTxkj63u+0R39p05P06x9yG4
         9jRm8GIgZAML2TPYy/JKR9r2zXzPEs32PZ++/lqQ+XTLvjnkweleET8JJZb8JxypTHFu
         GV68dWXxPE9e1zVpkiGidLU2p2Wi2lH/IehoPS/x69FSju8LzmhCr2JViR0KREqQ3kSy
         DZUQ==
X-Gm-Message-State: AOAM531lAd55KSEEvdUL6uY+R2QV2IjnmQDDc9/tOQzy13y37wrkTbab
        Dw56CzIprm1T/hTuPywTYvNJq+k1zp6mJw==
X-Google-Smtp-Source: ABdhPJwFjjcPor5utLkA5yHootdE23pq04sj8VU6I7HFCzBS7wq2XMLETnR5qR1XD8RduqxN+GKH7A==
X-Received: by 2002:a62:5586:0:b029:13e:d13d:a12c with SMTP id j128-20020a6255860000b029013ed13da12cmr6157651pfb.20.1599758534697;
        Thu, 10 Sep 2020 10:22:14 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id i6sm5554971pgl.25.2020.09.10.10.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 10:22:14 -0700 (PDT)
Date:   Thu, 10 Sep 2020 11:22:11 -0600
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
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
Subject: Re: [PATCH v5 4/4] vhost: add an RPMsg API
Message-ID: <20200910172211.GB579940@xps15>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-5-guennadi.liakhovetski@linux.intel.com>
 <20200909223946.GA562265@xps15>
 <20200910083853.GB17698@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910083853.GB17698@ubuntu>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good morning Guennadi,

On Thu, Sep 10, 2020 at 10:38:54AM +0200, Guennadi Liakhovetski wrote:
> Hi Mathieu,
> 
> On Wed, Sep 09, 2020 at 04:39:46PM -0600, Mathieu Poirier wrote:
> > Good afternoon,
> > 
> > On Wed, Aug 26, 2020 at 07:46:36PM +0200, Guennadi Liakhovetski wrote:
> > > Linux supports running the RPMsg protocol over the VirtIO transport
> > > protocol, but currently there is only support for VirtIO clients and
> > > no support for a VirtIO server. This patch adds a vhost-based RPMsg
> > > server implementation.
> > 
> > This changelog is very confusing...  At this time the name service in the
> > remoteproc space runs as a server on the application processor.  But from the
> > above the remoteproc usecase seems to be considered to be a client
> > configuration.
> 
> I agree that this isn't very obvious. But I think it is common to call the 
> host "a server" and guests "clients." E.g. in vhost.c in the top-of-thefile 
> comment:

Ok - that part we agree on.

> 
>  * Generic code for virtio server in host kernel.
> 
> I think the generic concept behind this notation is, that as guests boot, 
> they send their requests to the host, e.g. VirtIO device drivers on guests 
> send requests over VirtQueues to VirtIO servers on the host, which can run 
> either in the user- or in the kernel-space. And I think you can follow that 

I can see that process taking place.  After all virtIO devices on guests are
only stubs that need host support for access to HW.

> logic in case of devices or remote processors too: it's the main CPU(s) 
> that boot(s) and start talking to devices and remote processors, so in that 
> sence devices are servers and the CPUs are their clients.

In the remote processor case, the remoteproc core (application processor) sets up
the name service but does not initiate the communication with a remote
processor.  It simply waits there for a name space request to come in from the
remote processor.

> 
> And yes, the name-space announcement use-case seems confusing to me too - it 
> reverts the relationship in a way: once a guest has booted and established 
> connections to any rpmsg "devices," those send their namespace announcements 
> back. But I think this can be regarded as server identification: you connect 
> to a server and it replies with its identification and capabilities.

Based on the above can I assume vhost_rpmsg_ns_announce() is sent from the
guest?

I saw your V7, something I will look into.  In the mean time I need to bring
your attention to this set [1] from Arnaud.  Please have a look as it will
impact your work.

https://patchwork.kernel.org/project/linux-remoteproc/list/?series=338335

> 
> > And I don't see a server implementation per se...  It is more like a client
> > implementation since vhost_rpmsg_announce() uses the RESPONSE queue, which sends
> > messages from host to guest.
> > 
> > Perhaps it is my lack of familiarity with vhost terminology.
> > 
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > ---
> > >  drivers/vhost/Kconfig       |   7 +
> > >  drivers/vhost/Makefile      |   3 +
> > >  drivers/vhost/rpmsg.c       | 373 ++++++++++++++++++++++++++++++++++++
> > >  drivers/vhost/vhost_rpmsg.h |  74 +++++++
> > >  4 files changed, 457 insertions(+)
> > >  create mode 100644 drivers/vhost/rpmsg.c
> > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > > 
> > > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > > index 587fbae06182..046b948fc411 100644
> > > --- a/drivers/vhost/Kconfig
> > > +++ b/drivers/vhost/Kconfig
> > > @@ -38,6 +38,13 @@ config VHOST_NET
> > >  	  To compile this driver as a module, choose M here: the module will
> > >  	  be called vhost_net.
> > >  
> > > +config VHOST_RPMSG
> > > +	tristate
> > > +	select VHOST
> > > +	help
> > > +	  Vhost RPMsg API allows vhost drivers to communicate with VirtIO
> > > +	  drivers, using the RPMsg over VirtIO protocol.
> > 
> > I had to assume vhost drivers are running on the host and virtIO drivers on the
> > guests.  This may be common knowledge for people familiar with vhosts but
> > certainly obscur for commoners  Having a help section that is clear on what is
> > happening would remove any ambiguity.
> 
> It is the terminology, yes, but you're right, the wording isn't very clear, will 
> improve.
> 
> > > +
> > >  config VHOST_SCSI
> > >  	tristate "VHOST_SCSI TCM fabric driver"
> > >  	depends on TARGET_CORE && EVENTFD
> > > diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> > > index f3e1897cce85..9cf459d59f97 100644
> > > --- a/drivers/vhost/Makefile
> > > +++ b/drivers/vhost/Makefile
> > > @@ -2,6 +2,9 @@
> > >  obj-$(CONFIG_VHOST_NET) += vhost_net.o
> > >  vhost_net-y := net.o
> > >  
> > > +obj-$(CONFIG_VHOST_RPMSG) += vhost_rpmsg.o
> > > +vhost_rpmsg-y := rpmsg.o
> > > +
> > >  obj-$(CONFIG_VHOST_SCSI) += vhost_scsi.o
> > >  vhost_scsi-y := scsi.o
> > >  
> > > diff --git a/drivers/vhost/rpmsg.c b/drivers/vhost/rpmsg.c
> > > new file mode 100644
> > > index 000000000000..c26d7a4afc6d
> > > --- /dev/null
> > > +++ b/drivers/vhost/rpmsg.c
> > > @@ -0,0 +1,373 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> > > + *
> > > + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > + *
> > > + * Vhost RPMsg VirtIO interface. It provides a set of functions to match the
> > > + * guest side RPMsg VirtIO API, provided by drivers/rpmsg/virtio_rpmsg_bus.c
> > 
> > Again, very confusing.  The changelog refers to a server implementation but to
> > me this refers to a client implementation, especially if rpmsg_recv_single() and
> > rpmsg_ns_cb() are used on the other side of the pipe.  
> 
> I think the above is correct. "Vhost" indicates, that this is running on the host. 
> "match the guest side" means, that you can use this API on the host and it is 
> designed to work together with the RPMsg VirtIO drivers running on guests, as 
> implemented *on guests* by virtio_rpmsg_bus.c. Would "to work together" be a better 
> description than "to match?"

Lets forget about this part now and concentrate on the above conversation.
Things will start to make sense at one point.

> 
> > > + * These functions handle creation of 2 virtual queues, handling of endpoint
> > > + * addresses, sending a name-space announcement to the guest as well as any
> > > + * user messages. This API can be used by any vhost driver to handle RPMsg
> > > + * specific processing.
> > > + * Specific vhost drivers, using this API will use their own VirtIO device
> > > + * IDs, that should then also be added to the ID table in virtio_rpmsg_bus.c
> > > + */
> > > +
> > > +#include <linux/compat.h>
> > > +#include <linux/file.h>
> > > +#include <linux/miscdevice.h>
> > > +#include <linux/module.h>
> > > +#include <linux/mutex.h>
> > > +#include <linux/vhost.h>
> > > +#include <linux/virtio_rpmsg.h>
> > > +#include <uapi/linux/rpmsg.h>
> > > +
> > > +#include "vhost.h"
> > > +#include "vhost_rpmsg.h"
> > > +
> > > +/*
> > > + * All virtio-rpmsg virtual queue kicks always come with just one buffer -
> > > + * either input or output, but we can also handle split messages
> > > + */
> > > +static int vhost_rpmsg_get_msg(struct vhost_virtqueue *vq, unsigned int *cnt)
> > > +{
> > > +	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
> > > +	unsigned int out, in;
> > > +	int head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov), &out, &in,
> > > +				     NULL, NULL);
> > > +	if (head < 0) {
> > > +		vq_err(vq, "%s(): error %d getting buffer\n",
> > > +		       __func__, head);
> > > +		return head;
> > > +	}
> > > +
> > > +	/* Nothing new? */
> > > +	if (head == vq->num)
> > > +		return head;
> > > +
> > > +	if (vq == &vr->vq[VIRTIO_RPMSG_RESPONSE]) {
> > > +		if (out) {
> > > +			vq_err(vq, "%s(): invalid %d output in response queue\n",
> > > +			       __func__, out);
> > > +			goto return_buf;
> > > +		}
> > > +
> > > +		*cnt = in;
> > > +	}
> > > +
> > > +	if (vq == &vr->vq[VIRTIO_RPMSG_REQUEST]) {
> > > +		if (in) {
> > > +			vq_err(vq, "%s(): invalid %d input in request queue\n",
> > > +		       __func__, in);
> > > +			goto return_buf;
> > > +		}
> > > +
> > > +		*cnt = out;
> > > +	}
> > > +
> > > +	return head;
> > > +
> > > +return_buf:
> > > +	vhost_add_used(vq, head, 0);
> > > +
> > > +	return -EINVAL;
> > > +}
> > > +
> > > +static const struct vhost_rpmsg_ept *vhost_rpmsg_ept_find(struct vhost_rpmsg *vr, int addr)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	for (i = 0; i < vr->n_epts; i++)
> > > +		if (vr->ept[i].addr == addr)
> > > +			return vr->ept + i;
> > > +
> > > +	return NULL;
> > > +}
> > > +
> > > +/*
> > > + * if len < 0, then for reading a request, the complete virtual queue buffer
> > > + * size is prepared, for sending a response, the length in the iterator is used
> > > + */
> > > +int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> > > +			   unsigned int qid, ssize_t len)
> > > +	__acquires(vq->mutex)
> > > +{
> > > +	struct vhost_virtqueue *vq = vr->vq + qid;
> > > +	unsigned int cnt;
> > > +	ssize_t ret;
> > > +	size_t tmp;
> > > +
> > > +	if (qid >= VIRTIO_RPMSG_NUM_OF_VQS)
> > > +		return -EINVAL;
> > > +
> > > +	iter->vq = vq;
> > > +
> > > +	mutex_lock(&vq->mutex);
> > > +	vhost_disable_notify(&vr->dev, vq);
> > > +
> > > +	iter->head = vhost_rpmsg_get_msg(vq, &cnt);
> > > +	if (iter->head == vq->num)
> > > +		iter->head = -EAGAIN;
> > > +
> > > +	if (iter->head < 0) {
> > > +		ret = iter->head;
> > > +		goto unlock;
> > > +	}
> > > +
> > > +	tmp = iov_length(vq->iov, cnt);
> > > +	if (tmp < sizeof(iter->rhdr)) {
> > > +		vq_err(vq, "%s(): size %zu too small\n", __func__, tmp);
> > > +		ret = -ENOBUFS;
> > > +		goto return_buf;
> > > +	}
> > > +
> > > +	switch (qid) {
> > > +	case VIRTIO_RPMSG_REQUEST:
> > > +		if (len >= 0) {
> > > +			if (tmp < sizeof(iter->rhdr) + len) {
> > > +				ret = -ENOBUFS;
> > > +				goto return_buf;
> > > +			}
> > > +
> > > +			tmp = len + sizeof(iter->rhdr);
> > > +		}
> > > +
> > > +		/* len is now the size of the payload */
> > > +		iov_iter_init(&iter->iov_iter, WRITE, vq->iov, cnt, tmp);
> > > +
> > > +		/* Read the RPMSG header with endpoint addresses */
> > > +		tmp = copy_from_iter(&iter->rhdr, sizeof(iter->rhdr), &iter->iov_iter);
> > > +		if (tmp != sizeof(iter->rhdr)) {
> > > +			vq_err(vq, "%s(): got %zu instead of %zu\n", __func__,
> > > +			       tmp, sizeof(iter->rhdr));
> > > +			ret = -EIO;
> > > +			goto return_buf;
> > > +		}
> > > +
> > > +		iter->ept = vhost_rpmsg_ept_find(vr, vhost32_to_cpu(vq, iter->rhdr.dst));
> > > +		if (!iter->ept) {
> > > +			vq_err(vq, "%s(): no endpoint with address %d\n",
> > > +			       __func__, vhost32_to_cpu(vq, iter->rhdr.dst));
> > > +			ret = -ENOENT;
> > > +			goto return_buf;
> > > +		}
> > > +
> > > +		/* Let the endpoint read the payload */
> > > +		if (iter->ept->read) {
> > > +			ret = iter->ept->read(vr, iter);
> > > +			if (ret < 0)
> > > +				goto return_buf;
> > > +
> > > +			iter->rhdr.len = cpu_to_vhost16(vq, ret);
> > > +		} else {
> > > +			iter->rhdr.len = 0;
> > > +		}
> > > +
> > > +		/* Prepare for the response phase */
> > > +		iter->rhdr.dst = iter->rhdr.src;
> > > +		iter->rhdr.src = cpu_to_vhost32(vq, iter->ept->addr);
> > > +
> > > +		break;
> > > +	case VIRTIO_RPMSG_RESPONSE:
> > > +		if (!iter->ept && iter->rhdr.dst != cpu_to_vhost32(vq, RPMSG_NS_ADDR)) {
> > > +			/*
> > > +			 * Usually the iterator is configured when processing a
> > > +			 * message on the request queue, but it's also possible
> > > +			 * to send a message on the response queue without a
> > > +			 * preceding request, in that case the iterator must
> > > +			 * contain source and destination addresses.
> > > +			 */
> > > +			iter->ept = vhost_rpmsg_ept_find(vr, vhost32_to_cpu(vq, iter->rhdr.src));
> > > +			if (!iter->ept) {
> > > +				ret = -ENOENT;
> > > +				goto return_buf;
> > > +			}
> > > +		}
> > > +
> > > +		if (len >= 0) {
> > > +			if (tmp < sizeof(iter->rhdr) + len) {
> > > +				ret = -ENOBUFS;
> > > +				goto return_buf;
> > > +			}
> > > +
> > > +			iter->rhdr.len = cpu_to_vhost16(vq, len);
> > > +			tmp = len + sizeof(iter->rhdr);
> > > +		}
> > > +
> > > +		/* len is now the size of the payload */
> > > +		iov_iter_init(&iter->iov_iter, READ, vq->iov, cnt, tmp);
> > > +
> > > +		/* Write the RPMSG header with endpoint addresses */
> > > +		tmp = copy_to_iter(&iter->rhdr, sizeof(iter->rhdr), &iter->iov_iter);
> > > +		if (tmp != sizeof(iter->rhdr)) {
> > > +			ret = -EIO;
> > > +			goto return_buf;
> > > +		}
> > > +
> > > +		/* Let the endpoint write the payload */
> > > +		if (iter->ept && iter->ept->write) {
> > > +			ret = iter->ept->write(vr, iter);
> > > +			if (ret < 0)
> > > +				goto return_buf;
> > > +		}
> > > +
> > > +		break;
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +return_buf:
> > > +	vhost_add_used(vq, iter->head, 0);
> > > +unlock:
> > > +	vhost_enable_notify(&vr->dev, vq);
> > > +	mutex_unlock(&vq->mutex);
> > > +
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vhost_rpmsg_start_lock);
> > > +
> > > +size_t vhost_rpmsg_copy(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> > > +			void *data, size_t size)
> > > +{
> > > +	/*
> > > +	 * We could check for excess data, but copy_{to,from}_iter() don't do
> > > +	 * that either
> > > +	 */
> > > +	if (iter->vq == vr->vq + VIRTIO_RPMSG_RESPONSE)
> > > +		return copy_to_iter(data, size, &iter->iov_iter);
> > > +
> > > +	return copy_from_iter(data, size, &iter->iov_iter);
> > > +}
> > > +EXPORT_SYMBOL_GPL(vhost_rpmsg_copy);
> > > +
> > > +int vhost_rpmsg_finish_unlock(struct vhost_rpmsg *vr,
> > > +			      struct vhost_rpmsg_iter *iter)
> > > +	__releases(vq->mutex)
> > > +{
> > > +	if (iter->head >= 0)
> > > +		vhost_add_used_and_signal(iter->vq->dev, iter->vq, iter->head,
> > > +					  vhost16_to_cpu(iter->vq, iter->rhdr.len) +
> > > +					  sizeof(iter->rhdr));
> > > +
> > > +	vhost_enable_notify(&vr->dev, iter->vq);
> > > +	mutex_unlock(&iter->vq->mutex);
> > > +
> > > +	return iter->head;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vhost_rpmsg_finish_unlock);
> > > +
> > > +/*
> > > + * Return false to terminate the external loop only if we fail to obtain either
> > > + * a request or a response buffer
> > > + */
> > > +static bool handle_rpmsg_req_single(struct vhost_rpmsg *vr,
> > > +				    struct vhost_virtqueue *vq)
> > > +{
> > > +	struct vhost_rpmsg_iter iter;
> > > +	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_REQUEST, -EINVAL);
> > > +	if (!ret)
> > > +		ret = vhost_rpmsg_finish_unlock(vr, &iter);
> > > +	if (ret < 0) {
> > > +		if (ret != -EAGAIN)
> > > +			vq_err(vq, "%s(): RPMSG processing failed %d\n",
> > > +			       __func__, ret);
> > > +		return false;
> > > +	}
> > > +
> > > +	if (!iter.ept->write)
> > > +		return true;
> > > +
> > > +	ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE, -EINVAL);
> > > +	if (!ret)
> > > +		ret = vhost_rpmsg_finish_unlock(vr, &iter);
> > > +	if (ret < 0) {
> > > +		vq_err(vq, "%s(): RPMSG finalising failed %d\n", __func__, ret);
> > > +		return false;
> > > +	}
> > > +
> > > +	return true;
> > > +}
> > > +
> > > +static void handle_rpmsg_req_kick(struct vhost_work *work)
> > > +{
> > > +	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> > > +						  poll.work);
> > > +	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
> > > +
> > > +	while (handle_rpmsg_req_single(vr, vq))
> > > +		;
> > > +}
> > > +
> > > +/*
> > > + * initialise two virtqueues with an array of endpoints,
> > > + * request and response callbacks
> > > + */
> > > +void vhost_rpmsg_init(struct vhost_rpmsg *vr, const struct vhost_rpmsg_ept *ept,
> > > +		      unsigned int n_epts)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(vr->vq); i++)
> > > +		vr->vq_p[i] = &vr->vq[i];
> > > +
> > > +	/* vq[0]: host -> guest, vq[1]: host <- guest */
> > > +	vr->vq[VIRTIO_RPMSG_REQUEST].handle_kick = handle_rpmsg_req_kick;
> > > +	vr->vq[VIRTIO_RPMSG_RESPONSE].handle_kick = NULL;
> > > +
> > > +	vr->ept = ept;
> > > +	vr->n_epts = n_epts;
> > > +
> > > +	vhost_dev_init(&vr->dev, vr->vq_p, VIRTIO_RPMSG_NUM_OF_VQS,
> > > +		       UIO_MAXIOV, 0, 0, true, NULL);
> > > +}
> > > +EXPORT_SYMBOL_GPL(vhost_rpmsg_init);
> > > +
> > > +void vhost_rpmsg_destroy(struct vhost_rpmsg *vr)
> > > +{
> > > +	if (vhost_dev_has_owner(&vr->dev))
> > > +		vhost_poll_flush(&vr->vq[VIRTIO_RPMSG_REQUEST].poll);
> > > +
> > > +	vhost_dev_cleanup(&vr->dev);
> > > +}
> > > +EXPORT_SYMBOL_GPL(vhost_rpmsg_destroy);
> > > +
> > > +/* send namespace */
> > > +int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name, unsigned int src)
> > > +{
> > > +	struct vhost_virtqueue *vq = &vr->vq[VIRTIO_RPMSG_RESPONSE];
> > > +	struct vhost_rpmsg_iter iter = {
> > > +		.rhdr = {
> > > +			.src = 0,
> > > +			.dst = cpu_to_vhost32(vq, RPMSG_NS_ADDR),
> > > +			.flags = cpu_to_vhost16(vq, RPMSG_NS_CREATE), /* rpmsg_recv_single() */
> > 
> > Where is the flag used in rpmsg_recv_single()?  It is used for the name space
> > message (as you have below) but not in the header when doing a name space
> > announcement.
> 
> I think you're right, it isn't needed here, will remove.
> 
> > > +		},
> > > +	};
> > > +	struct rpmsg_ns_msg ns = {
> > > +		.addr = cpu_to_vhost32(vq, src),
> > > +		.flags = cpu_to_vhost32(vq, RPMSG_NS_CREATE), /* for rpmsg_ns_cb() */
> > > +	};
> > > +	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE, sizeof(ns));
> > > +
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	strlcpy(ns.name, name, sizeof(ns.name));
> > > +
> > > +	ret = vhost_rpmsg_copy(vr, &iter, &ns, sizeof(ns));
> > > +	if (ret != sizeof(ns))
> > > +		vq_err(iter.vq, "%s(): added %d instead of %zu bytes\n",
> > > +		       __func__, ret, sizeof(ns));
> > > +
> > > +	ret = vhost_rpmsg_finish_unlock(vr, &iter);
> > > +	if (ret < 0)
> > > +		vq_err(iter.vq, "%s(): namespace announcement failed: %d\n",
> > > +		       __func__, ret);
> > > +
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vhost_rpmsg_ns_announce);
> > > +
> > > +MODULE_LICENSE("GPL v2");
> > > +MODULE_AUTHOR("Intel, Inc.");
> > > +MODULE_DESCRIPTION("Vhost RPMsg API");
> > > diff --git a/drivers/vhost/vhost_rpmsg.h b/drivers/vhost/vhost_rpmsg.h
> > > new file mode 100644
> > > index 000000000000..30072cecb8a0
> > > --- /dev/null
> > > +++ b/drivers/vhost/vhost_rpmsg.h
> > > @@ -0,0 +1,74 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> > > + *
> > > + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > + */
> > > +
> > > +#ifndef VHOST_RPMSG_H
> > > +#define VHOST_RPMSG_H
> > > +
> > > +#include <linux/uio.h>
> > > +#include <linux/virtio_rpmsg.h>
> > > +
> > > +#include "vhost.h"
> > > +
> > > +/* RPMsg uses two VirtQueues: one for each direction */
> > > +enum {
> > > +	VIRTIO_RPMSG_RESPONSE,	/* RPMsg response (host->guest) buffers */
> > > +	VIRTIO_RPMSG_REQUEST,	/* RPMsg request (guest->host) buffers */
> > > +	/* Keep last */
> > > +	VIRTIO_RPMSG_NUM_OF_VQS,
> > > +};
> > > +
> > > +struct vhost_rpmsg_ept;
> > > +
> > > +struct vhost_rpmsg_iter {
> > > +	struct iov_iter iov_iter;
> > > +	struct rpmsg_hdr rhdr;
> > > +	struct vhost_virtqueue *vq;
> > > +	const struct vhost_rpmsg_ept *ept;
> > > +	int head;
> > > +	void *priv;
> > 
> > I don't see @priv being used anywhere.
> 
> That's logical: this is a field, private to the API users, so the core shouldn't 
> use it :-) It's used in later patches.

That is where structure documentation is useful.  I will let Michael decide what
he wants to do.

Thanks for the feedback,
Mathieu

> 
> > 
> > > +};
> > > +
> > > +struct vhost_rpmsg {
> > > +	struct vhost_dev dev;
> > > +	struct vhost_virtqueue vq[VIRTIO_RPMSG_NUM_OF_VQS];
> > > +	struct vhost_virtqueue *vq_p[VIRTIO_RPMSG_NUM_OF_VQS];
> > > +	const struct vhost_rpmsg_ept *ept;
> > > +	unsigned int n_epts;
> > > +};
> > > +
> > > +struct vhost_rpmsg_ept {
> > > +	ssize_t (*read)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
> > > +	ssize_t (*write)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
> > > +	int addr;
> > > +};
> > > +
> > > +static inline size_t vhost_rpmsg_iter_len(const struct vhost_rpmsg_iter *iter)
> > > +{
> > > +	return iter->rhdr.len;
> > > +}
> > 
> > Again, I don't see where this is used.
> 
> This is exported API, it's used by users.
>
> > > +
> > > +#define VHOST_RPMSG_ITER(_vq, _src, _dst) {			\
> > > +	.rhdr = {						\
> > > +			.src = cpu_to_vhost32(_vq, _src),	\
> > > +			.dst = cpu_to_vhost32(_vq, _dst),	\
> > > +		},						\
> > > +	}
> > 
> > Same.
> 
> ditto.
> 
> Thanks
> Guennadi
> 
> > Thanks,
> > Mathieu
> > 
> > > +
> > > +void vhost_rpmsg_init(struct vhost_rpmsg *vr, const struct vhost_rpmsg_ept *ept,
> > > +		      unsigned int n_epts);
> > > +void vhost_rpmsg_destroy(struct vhost_rpmsg *vr);
> > > +int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name,
> > > +			    unsigned int src);
> > > +int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr,
> > > +			   struct vhost_rpmsg_iter *iter,
> > > +			   unsigned int qid, ssize_t len);
> > > +size_t vhost_rpmsg_copy(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> > > +			void *data, size_t size);
> > > +int vhost_rpmsg_finish_unlock(struct vhost_rpmsg *vr,
> > > +			      struct vhost_rpmsg_iter *iter);
> > > +
> > > +#endif
> > > -- 
> > > 2.28.0
> > > 
