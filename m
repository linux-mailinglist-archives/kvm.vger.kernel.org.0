Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005512581E8
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 21:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgHaTis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 15:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgHaTir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 15:38:47 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A830C061575
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 12:38:47 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id v16so3644097plo.1
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 12:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PqtV4jJ1Yd2Zs8OKt8ffSmlkIU7lVMqU/7u+ylAWRSM=;
        b=MhWxoh5MVr0NorXdUBxYyTr1xTJ5UoljL/DK4ta8CWIBWna3WQEqz+I+doOEo25ajn
         cI03BTipEV4gtp2hFK4DiZzECFd8fMl136ANjDZbShoKUTrTq/vF09r6EtNv1iwXvQpC
         QuLQHqbD78d3ypHx0HwrCvXnPqBK3O48Fqvaz4ajCyBPVwZ2u6kiRUJ5yKjxdodFWCz6
         4t1cFNzl7pFpbOgnuUYV0EKwCj7GHZZxPJpxJh83OAJ4zJ3MZ5EQg81LrQOhwQL0KB6X
         pivjAPf0m+aO9LSTb5rKOpZploNkTLnc1Gt1pdpASRljH7fFOVMLyraHDOm6I4joWpqP
         6zjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PqtV4jJ1Yd2Zs8OKt8ffSmlkIU7lVMqU/7u+ylAWRSM=;
        b=fXghskkgafrB97YRo14XtTd2ayORjmmcOHckQy5I263vfXbDEoOF0VxsJfIhwgTM6n
         P8qv/YUydXZBDKK0IIdVPJxhocLvZ7UeRtpHjzevwv4/JldA0eMRpV+fTWQ6rtPOWaD6
         e1Xo9qgZz/EXakHwdmeKT3S8ZFWLGpnkpVRF2hoMz6mQEPJB2/AO8CvMRuGEsRPWfVXw
         n9sIWgAmMh8gxgjGMMve0zLCwaKhSBeV7fdAcTxYZ2mJg/PK3bI8Nj5mff2vVi2i+TtN
         xS7HeZqFHFx8wkJQn7/Eum5QY1gSO+aImWpPEHHN7+kYoeAAPLTqZ6EcjZmyXSexMNQY
         EWqg==
X-Gm-Message-State: AOAM531SDLzjSC7iMdhdxyDb3n0FiiI2boVdkRGyFi30utiklOgP85y6
        ySy2KtzDmtZYYi0n9ybDSXYyNQf043uaeA==
X-Google-Smtp-Source: ABdhPJwWRF7ASZqnMhrP0ljB7BfyA/F/k3380gqRwoMwSCrELxvCQmPlFs9UbxRV03GAr5bNSif5Xw==
X-Received: by 2002:a17:90a:890b:: with SMTP id u11mr794691pjn.114.1598902726704;
        Mon, 31 Aug 2020 12:38:46 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id y128sm8802745pfy.74.2020.08.31.12.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 12:38:46 -0700 (PDT)
Date:   Mon, 31 Aug 2020 13:38:44 -0600
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
Subject: Re: [PATCH v5 2/4] rpmsg: move common structures and defines to
 headers
Message-ID: <20200831193844.GA119959@xps15>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-3-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826174636.23873-3-guennadi.liakhovetski@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 26, 2020 at 07:46:34PM +0200, Guennadi Liakhovetski wrote:
> virtio_rpmsg_bus.c keeps RPMsg protocol structure declarations and
> common defines like the ones, needed for name-space announcements,
> internal. Move them to common headers instead.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>

https://www.spinics.net/lists/kvm/msg222766.html

> ---
>  drivers/rpmsg/virtio_rpmsg_bus.c | 78 +-----------------------------
>  include/linux/virtio_rpmsg.h     | 83 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/rpmsg.h       |  3 ++
>  3 files changed, 88 insertions(+), 76 deletions(-)
>  create mode 100644 include/linux/virtio_rpmsg.h
> 
> diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> index 9006fc7f73d0..9d5dd3f0a648 100644
> --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> @@ -26,7 +26,9 @@
>  #include <linux/virtio_byteorder.h>
>  #include <linux/virtio_ids.h>
>  #include <linux/virtio_config.h>
> +#include <linux/virtio_rpmsg.h>
>  #include <linux/wait.h>
> +#include <uapi/linux/rpmsg.h>
>  
>  #include "rpmsg_internal.h"
>  
> @@ -70,58 +72,6 @@ struct virtproc_info {
>  	struct rpmsg_endpoint *ns_ept;
>  };
>  
> -/* The feature bitmap for virtio rpmsg */
> -#define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
> -
> -/**
> - * struct rpmsg_hdr - common header for all rpmsg messages
> - * @src: source address
> - * @dst: destination address
> - * @reserved: reserved for future use
> - * @len: length of payload (in bytes)
> - * @flags: message flags
> - * @data: @len bytes of message payload data
> - *
> - * Every message sent(/received) on the rpmsg bus begins with this header.
> - */
> -struct rpmsg_hdr {
> -	__virtio32 src;
> -	__virtio32 dst;
> -	__virtio32 reserved;
> -	__virtio16 len;
> -	__virtio16 flags;
> -	u8 data[];
> -} __packed;
> -
> -/**
> - * struct rpmsg_ns_msg - dynamic name service announcement message
> - * @name: name of remote service that is published
> - * @addr: address of remote service that is published
> - * @flags: indicates whether service is created or destroyed
> - *
> - * This message is sent across to publish a new service, or announce
> - * about its removal. When we receive these messages, an appropriate
> - * rpmsg channel (i.e device) is created/destroyed. In turn, the ->probe()
> - * or ->remove() handler of the appropriate rpmsg driver will be invoked
> - * (if/as-soon-as one is registered).
> - */
> -struct rpmsg_ns_msg {
> -	char name[RPMSG_NAME_SIZE];
> -	__virtio32 addr;
> -	__virtio32 flags;
> -} __packed;
> -
> -/**
> - * enum rpmsg_ns_flags - dynamic name service announcement flags
> - *
> - * @RPMSG_NS_CREATE: a new remote service was just created
> - * @RPMSG_NS_DESTROY: a known remote service was just destroyed
> - */
> -enum rpmsg_ns_flags {
> -	RPMSG_NS_CREATE		= 0,
> -	RPMSG_NS_DESTROY	= 1,
> -};
> -
>  /**
>   * @vrp: the remote processor this channel belongs to
>   */
> @@ -134,27 +84,6 @@ struct virtio_rpmsg_channel {
>  #define to_virtio_rpmsg_channel(_rpdev) \
>  	container_of(_rpdev, struct virtio_rpmsg_channel, rpdev)
>  
> -/*
> - * We're allocating buffers of 512 bytes each for communications. The
> - * number of buffers will be computed from the number of buffers supported
> - * by the vring, upto a maximum of 512 buffers (256 in each direction).
> - *
> - * Each buffer will have 16 bytes for the msg header and 496 bytes for
> - * the payload.
> - *
> - * This will utilize a maximum total space of 256KB for the buffers.
> - *
> - * We might also want to add support for user-provided buffers in time.
> - * This will allow bigger buffer size flexibility, and can also be used
> - * to achieve zero-copy messaging.
> - *
> - * Note that these numbers are purely a decision of this driver - we
> - * can change this without changing anything in the firmware of the remote
> - * processor.
> - */
> -#define MAX_RPMSG_NUM_BUFS	(512)
> -#define MAX_RPMSG_BUF_SIZE	(512)
> -
>  /*
>   * Local addresses are dynamically allocated on-demand.
>   * We do not dynamically assign addresses from the low 1024 range,
> @@ -162,9 +91,6 @@ struct virtio_rpmsg_channel {
>   */
>  #define RPMSG_RESERVED_ADDRESSES	(1024)
>  
> -/* Address 53 is reserved for advertising remote services */
> -#define RPMSG_NS_ADDR			(53)
> -
>  static void virtio_rpmsg_destroy_ept(struct rpmsg_endpoint *ept);
>  static int virtio_rpmsg_send(struct rpmsg_endpoint *ept, void *data, int len);
>  static int virtio_rpmsg_sendto(struct rpmsg_endpoint *ept, void *data, int len,
> diff --git a/include/linux/virtio_rpmsg.h b/include/linux/virtio_rpmsg.h
> new file mode 100644
> index 000000000000..fcb523831e73
> --- /dev/null
> +++ b/include/linux/virtio_rpmsg.h
> @@ -0,0 +1,83 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LINUX_VIRTIO_RPMSG_H
> +#define _LINUX_VIRTIO_RPMSG_H
> +
> +#include <linux/mod_devicetable.h>
> +#include <linux/types.h>
> +#include <linux/virtio_types.h>
> +
> +/**
> + * struct rpmsg_hdr - common header for all rpmsg messages
> + * @src: source address
> + * @dst: destination address
> + * @reserved: reserved for future use
> + * @len: length of payload (in bytes)
> + * @flags: message flags
> + * @data: @len bytes of message payload data
> + *
> + * Every message sent(/received) on the rpmsg bus begins with this header.
> + */
> +struct rpmsg_hdr {
> +	__virtio32 src;
> +	__virtio32 dst;
> +	__virtio32 reserved;
> +	__virtio16 len;
> +	__virtio16 flags;
> +	u8 data[];
> +} __packed;
> +
> +/**
> + * struct rpmsg_ns_msg - dynamic name service announcement message
> + * @name: name of remote service that is published
> + * @addr: address of remote service that is published
> + * @flags: indicates whether service is created or destroyed
> + *
> + * This message is sent across to publish a new service, or announce
> + * about its removal. When we receive these messages, an appropriate
> + * rpmsg channel (i.e device) is created/destroyed. In turn, the ->probe()
> + * or ->remove() handler of the appropriate rpmsg driver will be invoked
> + * (if/as-soon-as one is registered).
> + */
> +struct rpmsg_ns_msg {
> +	char name[RPMSG_NAME_SIZE];
> +	__virtio32 addr;
> +	__virtio32 flags;
> +} __packed;
> +
> +/**
> + * enum rpmsg_ns_flags - dynamic name service announcement flags
> + *
> + * @RPMSG_NS_CREATE: a new remote service was just created
> + * @RPMSG_NS_DESTROY: a known remote service was just destroyed
> + */
> +enum rpmsg_ns_flags {
> +	RPMSG_NS_CREATE		= 0,
> +	RPMSG_NS_DESTROY	= 1,
> +};
> +
> +/*
> + * We're allocating buffers of 512 bytes each for communications. The
> + * number of buffers will be computed from the number of buffers supported
> + * by the vring, upto a maximum of 512 buffers (256 in each direction).
> + *
> + * Each buffer will have 16 bytes for the msg header and 496 bytes for
> + * the payload.
> + *
> + * This will utilize a maximum total space of 256KB for the buffers.
> + *
> + * We might also want to add support for user-provided buffers in time.
> + * This will allow bigger buffer size flexibility, and can also be used
> + * to achieve zero-copy messaging.
> + *
> + * Note that these numbers are purely a decision of this driver - we
> + * can change this without changing anything in the firmware of the remote
> + * processor.
> + */
> +#define MAX_RPMSG_NUM_BUFS	512
> +#define MAX_RPMSG_BUF_SIZE	512
> +
> +/* Address 53 is reserved for advertising remote services */
> +#define RPMSG_NS_ADDR		53
> +
> +#endif
> diff --git a/include/uapi/linux/rpmsg.h b/include/uapi/linux/rpmsg.h
> index e14c6dab4223..d669c04ef289 100644
> --- a/include/uapi/linux/rpmsg.h
> +++ b/include/uapi/linux/rpmsg.h
> @@ -24,4 +24,7 @@ struct rpmsg_endpoint_info {
>  #define RPMSG_CREATE_EPT_IOCTL	_IOW(0xb5, 0x1, struct rpmsg_endpoint_info)
>  #define RPMSG_DESTROY_EPT_IOCTL	_IO(0xb5, 0x2)
>  
> +/* The feature bitmap for virtio rpmsg */
> +#define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
> +
>  #endif
> -- 
> 2.28.0
> 
