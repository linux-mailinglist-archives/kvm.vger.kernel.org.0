Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB70E263943
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 00:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgIIWj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 18:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIIWju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 18:39:50 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF23C061573
        for <kvm@vger.kernel.org>; Wed,  9 Sep 2020 15:39:49 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v196so3566120pfc.1
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 15:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SxrN2h4hbatDtl7CB37a+09MPGjNtZAeGg20vPpUzYQ=;
        b=pPxYyOLf6lTcXFhZT90ZszABcrueUhYwquCNaPfFfYYSRfdNh190a0uqaJbsHxCYR1
         wN7WTDBU6AjO3SF5oTB0FnXGrDUV7+Fvy41+hewr4WKf0Bk9jDAQBAUckrvPcDhq+RRk
         cJ2JvDeHNK78EYQ/WvfvYxN+R/B3Ii9CqpZc+G/NjHKosSBmEPqOiF1rVBylCAaw02N6
         pYwLT6lZ/IE7BREWzeJf5RU8nim6S7ueFHY4E3voWIZtm/Hhe3JsSb1HoaUkCzup2wef
         cQwNGel9wNoBRvDPOLSaHInpjCzncoOLHMmkeq6DbS991QFPWR9Wf1YeGk9cS/ir96qL
         NdBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SxrN2h4hbatDtl7CB37a+09MPGjNtZAeGg20vPpUzYQ=;
        b=VBl//GjRT5Ft+mJQhK8BOsgnrNahXcBeclUwpnDSXcUCTkWoPvTeyRm422eYvINem3
         SnZVsQbUMCSOajM1dV/a+RMG2l3vHVuarer4yASLbMy7Wwv9OI3nZeoWK4/RnmZHyvxH
         j525GpYFPFH2rOpkg/NoIp+713EQFcgBuQeZgZC2RMT3aIdBbEbRI50NgfG0oHaaZKc2
         C1axD6JiBw2rgbMkPfWD0biTcwakerWuepDGt5TOVfjh0csI16JPez5kZhSv7qu8bT3R
         NcIoXMjL8oTn9dkyFxo4XPb+zEI69Hbzm4pvIQJpM6ZHAGTFI/wAet6lkU+JD23Ze59u
         r1Gg==
X-Gm-Message-State: AOAM531+GU4Nfaz/taFbeVcbdJDeo90h5sv0t1JwxBvmF0+JC7d6ENIH
        dlAFAeYa/dXxJfu1kQoD9iEmjQ==
X-Google-Smtp-Source: ABdhPJx+IhV71DRkPb8XMiSEQeWKrzE6YwlaVNp7PkwlZ++7tq7Dy5dPxNOWzcytC0UzCXsnT5mM5g==
X-Received: by 2002:a63:3247:: with SMTP id y68mr2103490pgy.224.1599691188927;
        Wed, 09 Sep 2020 15:39:48 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id 138sm3796117pfu.180.2020.09.09.15.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 15:39:48 -0700 (PDT)
Date:   Wed, 9 Sep 2020 16:39:46 -0600
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
Message-ID: <20200909223946.GA562265@xps15>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-5-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826174636.23873-5-guennadi.liakhovetski@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good afternoon,

On Wed, Aug 26, 2020 at 07:46:36PM +0200, Guennadi Liakhovetski wrote:
> Linux supports running the RPMsg protocol over the VirtIO transport
> protocol, but currently there is only support for VirtIO clients and
> no support for a VirtIO server. This patch adds a vhost-based RPMsg
> server implementation.

This changelog is very confusing...  At this time the name service in the
remoteproc space runs as a server on the application processor.  But from the
above the remoteproc usecase seems to be considered to be a client
configuration.

And I don't see a server implementation per se...  It is more like a client
implementation since vhost_rpmsg_announce() uses the RESPONSE queue, which sends
messages from host to guest.

Perhaps it is my lack of familiarity with vhost terminology.

> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> ---
>  drivers/vhost/Kconfig       |   7 +
>  drivers/vhost/Makefile      |   3 +
>  drivers/vhost/rpmsg.c       | 373 ++++++++++++++++++++++++++++++++++++
>  drivers/vhost/vhost_rpmsg.h |  74 +++++++
>  4 files changed, 457 insertions(+)
>  create mode 100644 drivers/vhost/rpmsg.c
>  create mode 100644 drivers/vhost/vhost_rpmsg.h
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 587fbae06182..046b948fc411 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -38,6 +38,13 @@ config VHOST_NET
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called vhost_net.
>  
> +config VHOST_RPMSG
> +	tristate
> +	select VHOST
> +	help
> +	  Vhost RPMsg API allows vhost drivers to communicate with VirtIO
> +	  drivers, using the RPMsg over VirtIO protocol.

I had to assume vhost drivers are running on the host and virtIO drivers on the
guests.  This may be common knowledge for people familiar with vhosts but
certainly obscur for commoners  Having a help section that is clear on what is
happening would remove any ambiguity.

> +
>  config VHOST_SCSI
>  	tristate "VHOST_SCSI TCM fabric driver"
>  	depends on TARGET_CORE && EVENTFD
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index f3e1897cce85..9cf459d59f97 100644
> --- a/drivers/vhost/Makefile
> +++ b/drivers/vhost/Makefile
> @@ -2,6 +2,9 @@
>  obj-$(CONFIG_VHOST_NET) += vhost_net.o
>  vhost_net-y := net.o
>  
> +obj-$(CONFIG_VHOST_RPMSG) += vhost_rpmsg.o
> +vhost_rpmsg-y := rpmsg.o
> +
>  obj-$(CONFIG_VHOST_SCSI) += vhost_scsi.o
>  vhost_scsi-y := scsi.o
>  
> diff --git a/drivers/vhost/rpmsg.c b/drivers/vhost/rpmsg.c
> new file mode 100644
> index 000000000000..c26d7a4afc6d
> --- /dev/null
> +++ b/drivers/vhost/rpmsg.c
> @@ -0,0 +1,373 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> + *
> + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> + *
> + * Vhost RPMsg VirtIO interface. It provides a set of functions to match the
> + * guest side RPMsg VirtIO API, provided by drivers/rpmsg/virtio_rpmsg_bus.c

Again, very confusing.  The changelog refers to a server implementation but to
me this refers to a client implementation, especially if rpmsg_recv_single() and
rpmsg_ns_cb() are used on the other side of the pipe.  

> + * These functions handle creation of 2 virtual queues, handling of endpoint
> + * addresses, sending a name-space announcement to the guest as well as any
> + * user messages. This API can be used by any vhost driver to handle RPMsg
> + * specific processing.
> + * Specific vhost drivers, using this API will use their own VirtIO device
> + * IDs, that should then also be added to the ID table in virtio_rpmsg_bus.c
> + */
> +
> +#include <linux/compat.h>
> +#include <linux/file.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/vhost.h>
> +#include <linux/virtio_rpmsg.h>
> +#include <uapi/linux/rpmsg.h>
> +
> +#include "vhost.h"
> +#include "vhost_rpmsg.h"
> +
> +/*
> + * All virtio-rpmsg virtual queue kicks always come with just one buffer -
> + * either input or output, but we can also handle split messages
> + */
> +static int vhost_rpmsg_get_msg(struct vhost_virtqueue *vq, unsigned int *cnt)
> +{
> +	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
> +	unsigned int out, in;
> +	int head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov), &out, &in,
> +				     NULL, NULL);
> +	if (head < 0) {
> +		vq_err(vq, "%s(): error %d getting buffer\n",
> +		       __func__, head);
> +		return head;
> +	}
> +
> +	/* Nothing new? */
> +	if (head == vq->num)
> +		return head;
> +
> +	if (vq == &vr->vq[VIRTIO_RPMSG_RESPONSE]) {
> +		if (out) {
> +			vq_err(vq, "%s(): invalid %d output in response queue\n",
> +			       __func__, out);
> +			goto return_buf;
> +		}
> +
> +		*cnt = in;
> +	}
> +
> +	if (vq == &vr->vq[VIRTIO_RPMSG_REQUEST]) {
> +		if (in) {
> +			vq_err(vq, "%s(): invalid %d input in request queue\n",
> +		       __func__, in);
> +			goto return_buf;
> +		}
> +
> +		*cnt = out;
> +	}
> +
> +	return head;
> +
> +return_buf:
> +	vhost_add_used(vq, head, 0);
> +
> +	return -EINVAL;
> +}
> +
> +static const struct vhost_rpmsg_ept *vhost_rpmsg_ept_find(struct vhost_rpmsg *vr, int addr)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < vr->n_epts; i++)
> +		if (vr->ept[i].addr == addr)
> +			return vr->ept + i;
> +
> +	return NULL;
> +}
> +
> +/*
> + * if len < 0, then for reading a request, the complete virtual queue buffer
> + * size is prepared, for sending a response, the length in the iterator is used
> + */
> +int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> +			   unsigned int qid, ssize_t len)
> +	__acquires(vq->mutex)
> +{
> +	struct vhost_virtqueue *vq = vr->vq + qid;
> +	unsigned int cnt;
> +	ssize_t ret;
> +	size_t tmp;
> +
> +	if (qid >= VIRTIO_RPMSG_NUM_OF_VQS)
> +		return -EINVAL;
> +
> +	iter->vq = vq;
> +
> +	mutex_lock(&vq->mutex);
> +	vhost_disable_notify(&vr->dev, vq);
> +
> +	iter->head = vhost_rpmsg_get_msg(vq, &cnt);
> +	if (iter->head == vq->num)
> +		iter->head = -EAGAIN;
> +
> +	if (iter->head < 0) {
> +		ret = iter->head;
> +		goto unlock;
> +	}
> +
> +	tmp = iov_length(vq->iov, cnt);
> +	if (tmp < sizeof(iter->rhdr)) {
> +		vq_err(vq, "%s(): size %zu too small\n", __func__, tmp);
> +		ret = -ENOBUFS;
> +		goto return_buf;
> +	}
> +
> +	switch (qid) {
> +	case VIRTIO_RPMSG_REQUEST:
> +		if (len >= 0) {
> +			if (tmp < sizeof(iter->rhdr) + len) {
> +				ret = -ENOBUFS;
> +				goto return_buf;
> +			}
> +
> +			tmp = len + sizeof(iter->rhdr);
> +		}
> +
> +		/* len is now the size of the payload */
> +		iov_iter_init(&iter->iov_iter, WRITE, vq->iov, cnt, tmp);
> +
> +		/* Read the RPMSG header with endpoint addresses */
> +		tmp = copy_from_iter(&iter->rhdr, sizeof(iter->rhdr), &iter->iov_iter);
> +		if (tmp != sizeof(iter->rhdr)) {
> +			vq_err(vq, "%s(): got %zu instead of %zu\n", __func__,
> +			       tmp, sizeof(iter->rhdr));
> +			ret = -EIO;
> +			goto return_buf;
> +		}
> +
> +		iter->ept = vhost_rpmsg_ept_find(vr, vhost32_to_cpu(vq, iter->rhdr.dst));
> +		if (!iter->ept) {
> +			vq_err(vq, "%s(): no endpoint with address %d\n",
> +			       __func__, vhost32_to_cpu(vq, iter->rhdr.dst));
> +			ret = -ENOENT;
> +			goto return_buf;
> +		}
> +
> +		/* Let the endpoint read the payload */
> +		if (iter->ept->read) {
> +			ret = iter->ept->read(vr, iter);
> +			if (ret < 0)
> +				goto return_buf;
> +
> +			iter->rhdr.len = cpu_to_vhost16(vq, ret);
> +		} else {
> +			iter->rhdr.len = 0;
> +		}
> +
> +		/* Prepare for the response phase */
> +		iter->rhdr.dst = iter->rhdr.src;
> +		iter->rhdr.src = cpu_to_vhost32(vq, iter->ept->addr);
> +
> +		break;
> +	case VIRTIO_RPMSG_RESPONSE:
> +		if (!iter->ept && iter->rhdr.dst != cpu_to_vhost32(vq, RPMSG_NS_ADDR)) {
> +			/*
> +			 * Usually the iterator is configured when processing a
> +			 * message on the request queue, but it's also possible
> +			 * to send a message on the response queue without a
> +			 * preceding request, in that case the iterator must
> +			 * contain source and destination addresses.
> +			 */
> +			iter->ept = vhost_rpmsg_ept_find(vr, vhost32_to_cpu(vq, iter->rhdr.src));
> +			if (!iter->ept) {
> +				ret = -ENOENT;
> +				goto return_buf;
> +			}
> +		}
> +
> +		if (len >= 0) {
> +			if (tmp < sizeof(iter->rhdr) + len) {
> +				ret = -ENOBUFS;
> +				goto return_buf;
> +			}
> +
> +			iter->rhdr.len = cpu_to_vhost16(vq, len);
> +			tmp = len + sizeof(iter->rhdr);
> +		}
> +
> +		/* len is now the size of the payload */
> +		iov_iter_init(&iter->iov_iter, READ, vq->iov, cnt, tmp);
> +
> +		/* Write the RPMSG header with endpoint addresses */
> +		tmp = copy_to_iter(&iter->rhdr, sizeof(iter->rhdr), &iter->iov_iter);
> +		if (tmp != sizeof(iter->rhdr)) {
> +			ret = -EIO;
> +			goto return_buf;
> +		}
> +
> +		/* Let the endpoint write the payload */
> +		if (iter->ept && iter->ept->write) {
> +			ret = iter->ept->write(vr, iter);
> +			if (ret < 0)
> +				goto return_buf;
> +		}
> +
> +		break;
> +	}
> +
> +	return 0;
> +
> +return_buf:
> +	vhost_add_used(vq, iter->head, 0);
> +unlock:
> +	vhost_enable_notify(&vr->dev, vq);
> +	mutex_unlock(&vq->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vhost_rpmsg_start_lock);
> +
> +size_t vhost_rpmsg_copy(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> +			void *data, size_t size)
> +{
> +	/*
> +	 * We could check for excess data, but copy_{to,from}_iter() don't do
> +	 * that either
> +	 */
> +	if (iter->vq == vr->vq + VIRTIO_RPMSG_RESPONSE)
> +		return copy_to_iter(data, size, &iter->iov_iter);
> +
> +	return copy_from_iter(data, size, &iter->iov_iter);
> +}
> +EXPORT_SYMBOL_GPL(vhost_rpmsg_copy);
> +
> +int vhost_rpmsg_finish_unlock(struct vhost_rpmsg *vr,
> +			      struct vhost_rpmsg_iter *iter)
> +	__releases(vq->mutex)
> +{
> +	if (iter->head >= 0)
> +		vhost_add_used_and_signal(iter->vq->dev, iter->vq, iter->head,
> +					  vhost16_to_cpu(iter->vq, iter->rhdr.len) +
> +					  sizeof(iter->rhdr));
> +
> +	vhost_enable_notify(&vr->dev, iter->vq);
> +	mutex_unlock(&iter->vq->mutex);
> +
> +	return iter->head;
> +}
> +EXPORT_SYMBOL_GPL(vhost_rpmsg_finish_unlock);
> +
> +/*
> + * Return false to terminate the external loop only if we fail to obtain either
> + * a request or a response buffer
> + */
> +static bool handle_rpmsg_req_single(struct vhost_rpmsg *vr,
> +				    struct vhost_virtqueue *vq)
> +{
> +	struct vhost_rpmsg_iter iter;
> +	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_REQUEST, -EINVAL);
> +	if (!ret)
> +		ret = vhost_rpmsg_finish_unlock(vr, &iter);
> +	if (ret < 0) {
> +		if (ret != -EAGAIN)
> +			vq_err(vq, "%s(): RPMSG processing failed %d\n",
> +			       __func__, ret);
> +		return false;
> +	}
> +
> +	if (!iter.ept->write)
> +		return true;
> +
> +	ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE, -EINVAL);
> +	if (!ret)
> +		ret = vhost_rpmsg_finish_unlock(vr, &iter);
> +	if (ret < 0) {
> +		vq_err(vq, "%s(): RPMSG finalising failed %d\n", __func__, ret);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void handle_rpmsg_req_kick(struct vhost_work *work)
> +{
> +	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> +						  poll.work);
> +	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
> +
> +	while (handle_rpmsg_req_single(vr, vq))
> +		;
> +}
> +
> +/*
> + * initialise two virtqueues with an array of endpoints,
> + * request and response callbacks
> + */
> +void vhost_rpmsg_init(struct vhost_rpmsg *vr, const struct vhost_rpmsg_ept *ept,
> +		      unsigned int n_epts)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(vr->vq); i++)
> +		vr->vq_p[i] = &vr->vq[i];
> +
> +	/* vq[0]: host -> guest, vq[1]: host <- guest */
> +	vr->vq[VIRTIO_RPMSG_REQUEST].handle_kick = handle_rpmsg_req_kick;
> +	vr->vq[VIRTIO_RPMSG_RESPONSE].handle_kick = NULL;
> +
> +	vr->ept = ept;
> +	vr->n_epts = n_epts;
> +
> +	vhost_dev_init(&vr->dev, vr->vq_p, VIRTIO_RPMSG_NUM_OF_VQS,
> +		       UIO_MAXIOV, 0, 0, true, NULL);
> +}
> +EXPORT_SYMBOL_GPL(vhost_rpmsg_init);
> +
> +void vhost_rpmsg_destroy(struct vhost_rpmsg *vr)
> +{
> +	if (vhost_dev_has_owner(&vr->dev))
> +		vhost_poll_flush(&vr->vq[VIRTIO_RPMSG_REQUEST].poll);
> +
> +	vhost_dev_cleanup(&vr->dev);
> +}
> +EXPORT_SYMBOL_GPL(vhost_rpmsg_destroy);
> +
> +/* send namespace */
> +int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name, unsigned int src)
> +{
> +	struct vhost_virtqueue *vq = &vr->vq[VIRTIO_RPMSG_RESPONSE];
> +	struct vhost_rpmsg_iter iter = {
> +		.rhdr = {
> +			.src = 0,
> +			.dst = cpu_to_vhost32(vq, RPMSG_NS_ADDR),
> +			.flags = cpu_to_vhost16(vq, RPMSG_NS_CREATE), /* rpmsg_recv_single() */

Where is the flag used in rpmsg_recv_single()?  It is used for the name space
message (as you have below) but not in the header when doing a name space
announcement.

> +		},
> +	};
> +	struct rpmsg_ns_msg ns = {
> +		.addr = cpu_to_vhost32(vq, src),
> +		.flags = cpu_to_vhost32(vq, RPMSG_NS_CREATE), /* for rpmsg_ns_cb() */
> +	};
> +	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE, sizeof(ns));
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	strlcpy(ns.name, name, sizeof(ns.name));
> +
> +	ret = vhost_rpmsg_copy(vr, &iter, &ns, sizeof(ns));
> +	if (ret != sizeof(ns))
> +		vq_err(iter.vq, "%s(): added %d instead of %zu bytes\n",
> +		       __func__, ret, sizeof(ns));
> +
> +	ret = vhost_rpmsg_finish_unlock(vr, &iter);
> +	if (ret < 0)
> +		vq_err(iter.vq, "%s(): namespace announcement failed: %d\n",
> +		       __func__, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vhost_rpmsg_ns_announce);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Intel, Inc.");
> +MODULE_DESCRIPTION("Vhost RPMsg API");
> diff --git a/drivers/vhost/vhost_rpmsg.h b/drivers/vhost/vhost_rpmsg.h
> new file mode 100644
> index 000000000000..30072cecb8a0
> --- /dev/null
> +++ b/drivers/vhost/vhost_rpmsg.h
> @@ -0,0 +1,74 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> + *
> + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> + */
> +
> +#ifndef VHOST_RPMSG_H
> +#define VHOST_RPMSG_H
> +
> +#include <linux/uio.h>
> +#include <linux/virtio_rpmsg.h>
> +
> +#include "vhost.h"
> +
> +/* RPMsg uses two VirtQueues: one for each direction */
> +enum {
> +	VIRTIO_RPMSG_RESPONSE,	/* RPMsg response (host->guest) buffers */
> +	VIRTIO_RPMSG_REQUEST,	/* RPMsg request (guest->host) buffers */
> +	/* Keep last */
> +	VIRTIO_RPMSG_NUM_OF_VQS,
> +};
> +
> +struct vhost_rpmsg_ept;
> +
> +struct vhost_rpmsg_iter {
> +	struct iov_iter iov_iter;
> +	struct rpmsg_hdr rhdr;
> +	struct vhost_virtqueue *vq;
> +	const struct vhost_rpmsg_ept *ept;
> +	int head;
> +	void *priv;

I don't see @priv being used anywhere.

> +};
> +
> +struct vhost_rpmsg {
> +	struct vhost_dev dev;
> +	struct vhost_virtqueue vq[VIRTIO_RPMSG_NUM_OF_VQS];
> +	struct vhost_virtqueue *vq_p[VIRTIO_RPMSG_NUM_OF_VQS];
> +	const struct vhost_rpmsg_ept *ept;
> +	unsigned int n_epts;
> +};
> +
> +struct vhost_rpmsg_ept {
> +	ssize_t (*read)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
> +	ssize_t (*write)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
> +	int addr;
> +};
> +
> +static inline size_t vhost_rpmsg_iter_len(const struct vhost_rpmsg_iter *iter)
> +{
> +	return iter->rhdr.len;
> +}

Again, I don't see where this is used.

> +
> +#define VHOST_RPMSG_ITER(_vq, _src, _dst) {			\
> +	.rhdr = {						\
> +			.src = cpu_to_vhost32(_vq, _src),	\
> +			.dst = cpu_to_vhost32(_vq, _dst),	\
> +		},						\
> +	}

Same.

Thanks,
Mathieu

> +
> +void vhost_rpmsg_init(struct vhost_rpmsg *vr, const struct vhost_rpmsg_ept *ept,
> +		      unsigned int n_epts);
> +void vhost_rpmsg_destroy(struct vhost_rpmsg *vr);
> +int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name,
> +			    unsigned int src);
> +int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr,
> +			   struct vhost_rpmsg_iter *iter,
> +			   unsigned int qid, ssize_t len);
> +size_t vhost_rpmsg_copy(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> +			void *data, size_t size);
> +int vhost_rpmsg_finish_unlock(struct vhost_rpmsg *vr,
> +			      struct vhost_rpmsg_iter *iter);
> +
> +#endif
> -- 
> 2.28.0
> 
