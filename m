Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B2A1E3046
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 22:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390927AbgEZUun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 16:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391353AbgEZUun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 16:50:43 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130C9C03E96D
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 13:50:43 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x18so8071554pll.6
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 13:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ysgzlNrq6xyh0m8gRfSL9l8co2M7HS8UR6EOiUHNEJs=;
        b=IlrISywLFC2Ir9pAx9i5tf2gu7AgWVW0vri3MmVIPuTLkhh7IN6C4aV+laIzW+EceH
         gdnm4nGKF6Culjf7zsrVyUeRB9vTu+UBdOTaqlBThESzCNPtlW/RroDTcAuUpwR/3K5b
         eeDPs1EgY8jh/IFKyF8rGbghNT4k7a41ufy+wOn9hIishXq4bnZsAxGdGx9n5CfbG559
         oSEcW/YsBqQiQ7mQZcDjJmWaSvGHr4pZdcOWB0WNGNI30eavN6YGfKmdFZVxxwK1sZ5b
         Bt4ET8gM3bxwdCFw1WWDJ4Zh6jeaa+11ptu1v2sdptWxqGCYkofcRSBmdaPh2q3rVLm2
         VVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ysgzlNrq6xyh0m8gRfSL9l8co2M7HS8UR6EOiUHNEJs=;
        b=OpUSPvb2jbIzrmFfH9VFGYaZOu0Gp8BmhHS0qsLGNHn3ht0/ec1rTalZrNWRlcU4/G
         TcWjdo1wB95CwTQE2elMgMzpW82yU61h29sTfGNKtV9m14KTQ6chuerIJzVl0JTcmEtP
         1v2UaAIcS0rWdcasMEiXWk8lF5zdvDcVUUU3uuzA20wMZoLb1/DWw7GS0yFiN1Tmr73T
         XvJRshmpsmTzHXX/pKhB+hLBylwZYQH7yjrlN4I5RDpKfhmcw82FDlJ2y+78oNefqauM
         PZRZO0tUqCuDJwRwT6cn2vwL113yI0OOPL2TRSXzCLS0aBFvAeI9B0QYU/tXGfAPRf72
         Bddg==
X-Gm-Message-State: AOAM53253f6SUu/n5YFVlLQwcRZPoVyLuRq87hwJnRunw9sJHv1rD6Dw
        0p0j4XSo5A/dMqskWi/qR6G7OiH0WsQ=
X-Google-Smtp-Source: ABdhPJzCFuqo6zI90b3sU91b/dkGP7BV3cpAbD5RlU5XVBBtzxylJ6p5mrPU87O7dousjKGS2Vxo2A==
X-Received: by 2002:a17:90a:b111:: with SMTP id z17mr1119631pjq.106.1590526242161;
        Tue, 26 May 2020 13:50:42 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id np5sm384900pjb.43.2020.05.26.13.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 13:50:41 -0700 (PDT)
Date:   Tue, 26 May 2020 14:50:39 -0600
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
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH v2 5/5] vhost: add an RPMsg API
Message-ID: <20200526205039.GA20104@xps15>
References: <20200525144458.8413-1-guennadi.liakhovetski@linux.intel.com>
 <20200525144458.8413-6-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525144458.8413-6-guennadi.liakhovetski@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Guennadi,

On Mon, May 25, 2020 at 04:44:58PM +0200, Guennadi Liakhovetski wrote:
> Linux supports running the RPMsg protocol over the VirtIO transport
> protocol, but currently there is only support for VirtIO clients and
> no support for a VirtIO server. This patch adds a vhost-based RPMsg
> server implementation.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> ---
>  drivers/vhost/Kconfig       |   7 +
>  drivers/vhost/Makefile      |   3 +
>  drivers/vhost/rpmsg.c       | 372 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/vhost/vhost_rpmsg.h |  74 +++++++++
>  4 files changed, 456 insertions(+)
>  create mode 100644 drivers/vhost/rpmsg.c
>  create mode 100644 drivers/vhost/vhost_rpmsg.h
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 2c75d16..c2113db 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -38,6 +38,13 @@ config VHOST_NET
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called vhost_net.
>  
> +config VHOST_RPMSG
> +	tristate
> +	depends on VHOST
> +	---help---
> +	  Vhost RPMsg API allows vhost drivers to communicate with VirtIO
> +	  drivers, using the RPMsg over VirtIO protocol.
> +
>  config VHOST_SCSI
>  	tristate "VHOST_SCSI TCM fabric driver"
>  	depends on TARGET_CORE && EVENTFD
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index f3e1897..9cf459d 100644
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
> index 00000000..609b9cf
> --- /dev/null
> +++ b/drivers/vhost/rpmsg.c
> @@ -0,0 +1,372 @@
> +/* SPDX-License-Identifier: (GPL-2.0-only) */
> +/*
> + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> + *
> + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> + *
> + * vhost-RPMsg VirtIO interface
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
> + * either input or output
> + */
> +static int vhost_rpmsg_get_single(struct vhost_virtqueue *vq)
> +{
> +	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
> +	unsigned int out, in;
> +	int head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
> +				     &out, &in, NULL, NULL);
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
> +	if (vq == &vr->vq[VIRTIO_RPMSG_RESPONSE] && (out || in != 1)) {
> +		vq_err(vq,
> +		       "%s(): invalid %d input and %d output in response queue\n",
> +		       __func__, in, out);
> +		goto return_buf;
> +	}
> +
> +	if (vq == &vr->vq[VIRTIO_RPMSG_REQUEST] && (in || out != 1)) {
> +		vq_err(vq,
> +		       "%s(): invalid %d input and %d output in request queue\n",
> +		       __func__, in, out);
> +		goto return_buf;
> +	}
> +
> +	return head;
> +
> +return_buf:
> +	/*
> +	 * FIXME: might need to return the buffer using vhost_add_used()
> +	 * or vhost_discard_vq_desc(). vhost_discard_vq_desc() is
> +	 * described as "being useful for error handling," but it makes
> +	 * the thus discarded buffers "unseen," so next time we look we
> +	 * retrieve them again?
> +	 */
> +	return -EINVAL;
> +}
> +
> +static const struct vhost_rpmsg_ept *vhost_rpmsg_ept_find(struct vhost_rpmsg *vr,
> +							  int addr)
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
> +int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr,
> +			   struct vhost_rpmsg_iter *iter,
> +			   unsigned int qid, ssize_t len)
> +	__acquires(vq->mutex)
> +{
> +	struct vhost_virtqueue *vq = vr->vq + qid;
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
> +	iter->head = vhost_rpmsg_get_single(vq);
> +	if (iter->head == vq->num)
> +		iter->head = -EAGAIN;
> +
> +	if (iter->head < 0)
> +		goto unlock;
> +
> +	tmp = vq->iov[0].iov_len;
> +	if (tmp < sizeof(iter->rhdr)) {
> +		vq_err(vq, "%s(): size %zu too small\n", __func__, tmp);
> +		iter->head = -ENOBUFS;
> +		goto return_buf;
> +	}
> +
> +	switch (qid) {
> +	case VIRTIO_RPMSG_REQUEST:
> +		if (len < 0) {
> +			len = tmp - sizeof(iter->rhdr);
> +		} else if (tmp < sizeof(iter->rhdr) + len) {
> +			iter->head = -ENOBUFS;
> +			goto return_buf;
> +		}
> +
> +		/* len is now the size of the payload */
> +		iov_iter_init(&iter->iov_iter, WRITE,
> +			      vq->iov, 1, sizeof(iter->rhdr) + len);
> +
> +		/* Read the RPMSG header with endpoint addresses */
> +		tmp = copy_from_iter(&iter->rhdr, sizeof(iter->rhdr),
> +				     &iter->iov_iter);
> +		if (tmp != sizeof(iter->rhdr)) {
> +			vq_err(vq, "%s(): got %zu instead of %zu\n", __func__,
> +			       tmp, sizeof(iter->rhdr));
> +			iter->head = -EIO;
> +			goto return_buf;
> +		}
> +
> +		iter->ept = vhost_rpmsg_ept_find(vr, iter->rhdr.dst);
> +		if (!iter->ept) {
> +			vq_err(vq, "%s(): no endpoint with address %d\n",
> +			       __func__, iter->rhdr.dst);
> +			iter->head = -ENOENT;
> +			goto return_buf;
> +		}
> +
> +		/* Let the endpoint read the payload */
> +		if (iter->ept->read) {
> +			ssize_t ret = iter->ept->read(vr, iter);
> +			if (ret < 0) {
> +				iter->head = ret;
> +				goto return_buf;
> +			}
> +
> +			iter->rhdr.len = ret;
> +		} else {
> +			iter->rhdr.len = 0;
> +		}
> +
> +		/* Prepare for the response phase */
> +		iter->rhdr.dst = iter->rhdr.src;
> +		iter->rhdr.src = iter->ept->addr;
> +
> +		break;
> +	case VIRTIO_RPMSG_RESPONSE:
> +		if (!iter->ept && iter->rhdr.dst != RPMSG_NS_ADDR) {
> +			/*
> +			 * Usually the iterator is configured when processing a
> +			 * message on the request queue, but it's also possible
> +			 * to send a message on the response queue without a
> +			 * preceding request, in that case the iterator must
> +			 * contain source and destination addresses.
> +			 */
> +			iter->ept = vhost_rpmsg_ept_find(vr, iter->rhdr.src);
> +			if (!iter->ept) {
> +				iter->head = -ENOENT;
> +				goto return_buf;
> +			}
> +		}
> +
> +		if (len < 0) {
> +			len = tmp - sizeof(iter->rhdr);
> +		} else if (tmp < sizeof(iter->rhdr) + len) {
> +			iter->head = -ENOBUFS;
> +			goto return_buf;
> +		} else {
> +			iter->rhdr.len = len;
> +		}
> +
> +		/* len is now the size of the payload */
> +		iov_iter_init(&iter->iov_iter, READ,
> +			      vq->iov, 1, sizeof(iter->rhdr) + len);
> +
> +		/* Write the RPMSG header with endpoint addresses */
> +		tmp = copy_to_iter(&iter->rhdr, sizeof(iter->rhdr),
> +				   &iter->iov_iter);
> +		if (tmp != sizeof(iter->rhdr)) {
> +			iter->head = -EIO;
> +			goto return_buf;
> +		}
> +
> +		/* Let the endpoint write the payload */
> +		if (iter->ept && iter->ept->write) {
> +			ssize_t ret = iter->ept->write(vr, iter);
> +			if (ret < 0) {
> +				iter->head = ret;
> +				goto return_buf;
> +			}
> +		}
> +
> +		break;
> +	}
> +
> +	return 0;
> +
> +return_buf:
> +	/*
> +	 * FIXME: vhost_discard_vq_desc() or vhost_add_used(), see comment in
> +	 * vhost_rpmsg_get_single()
> +	 */
> +unlock:
> +	vhost_enable_notify(&vr->dev, vq);
> +	mutex_unlock(&vq->mutex);
> +
> +	return iter->head;
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
> +					  iter->rhdr.len + sizeof(iter->rhdr));
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
> +	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_REQUEST,
> +					 -EINVAL);
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
> +	ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE,
> +				     -EINVAL);
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
> +
> +	vr->ept = ept;
> +	vr->n_epts = n_epts;
> +
> +	vhost_dev_init(&vr->dev, vr->vq_p, VIRTIO_RPMSG_NUM_OF_VQS,
> +		       UIO_MAXIOV, 0, 0, NULL);
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
> +int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name,
> +			    unsigned int src)
> +{
> +	struct vhost_rpmsg_iter iter = {
> +		.rhdr = {
> +			.src = 0,
> +			.dst = RPMSG_NS_ADDR,
> +			.flags = RPMSG_NS_CREATE, /* rpmsg_recv_single() */
> +		},
> +	};
> +	struct rpmsg_ns_msg ns = {
> +		.addr = src,
> +		.flags = RPMSG_NS_CREATE, /* for rpmsg_ns_cb() */
> +	};

I think it would be worth mentioning that someone on the guest side needs to
call register_virtio_device() with a vdev->id->device == VIRTIO_ID_RPMSG,
something that will match that device to the virtio_ipc_driver.  Otherwise the
connection between them is very difficult to establish.

Aside from the checkpatch warning I already pointed out, I don't have much else.

Thanks,
Mathieu

> +	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE,
> +					 sizeof(ns));
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
> index 00000000..5248ac9
> --- /dev/null
> +++ b/drivers/vhost/vhost_rpmsg.h
> @@ -0,0 +1,74 @@
> +/* SPDX-License-Identifier: (GPL-2.0) */
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
> +
> +#define VHOST_RPMSG_ITER(_src, _dst) {	\
> +	.rhdr = {			\
> +			.src = _src,	\
> +			.dst = _dst,	\
> +		},			\
> +	}
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
> 1.9.3
> 
