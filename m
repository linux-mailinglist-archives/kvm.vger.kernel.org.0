Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D9241918D
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 11:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhI0Jdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 05:33:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233671AbhI0Jds (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 05:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632735127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hha6vL8+kgRFRejoaAGUuH6/XDbDSBp6ZRA9Bz723U8=;
        b=M/hrVJ1vcIU/86RKfuzIanElXmW7zlk+xHPy+4oOYV5lAs83C1NkU8lJeylj8Bu//ZrodE
        aIi5oqvmmnc3icsLxWigeWk4XZIhzvjYIL6yXx8QpekfGNG8U+ZuhAZdBrI/rzmzekRAye
        8sjljUDsLMI5vsG1McEu89uw+Y1Ig64=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-ZYZJdfXCPsyXyMLMk-RLpQ-1; Mon, 27 Sep 2021 05:32:05 -0400
X-MC-Unique: ZYZJdfXCPsyXyMLMk-RLpQ-1
Received: by mail-wr1-f70.google.com with SMTP id r5-20020adfb1c5000000b0015cddb7216fso13827102wra.3
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 02:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hha6vL8+kgRFRejoaAGUuH6/XDbDSBp6ZRA9Bz723U8=;
        b=SzfpfK3eLokdVUiwHo4D1jZTUKj0vgZ4krTYvwPI5RodfC1ETDAtqc6J5zdeMApEbZ
         AaGjLl455ZmWrYsGH3wnxOi+dJeVzb8wOIzjDQt/v6xe6+57cRuq0eBmhsVXuMcMt1OB
         3k4c+/mlKNsL0Wa9WDLZb7iZrfuFfO1QmmzLgKV+rs3mhubYMNk4nYbmEuUw48kHoMkm
         XMyIOJO0jGYeWlALTCIEt90+9aETjSWsEG4Hl1sIvm5ecOtUwxpV3d7bkf6VZvf4YboN
         nVNg1FMQrwY43A7wlovnJJZPJUTZaUWj2ekJtf2ZdmArwoEeui9A9tRai6VTVWlH9TbM
         9/ZQ==
X-Gm-Message-State: AOAM533Rvux7fPhMtZYC9G86soGWG9Y2vMGkk2ShgFjfzm9u7pNyMlqL
        VZHQGl4bjjtQ/UTkOK185XC1EL96QZMVSQznkbAKAMvOxkxyQQ7VZ7UngJfPVrPNpFHSUKCGCXJ
        PLPRyoNQXbHaB
X-Received: by 2002:a1c:149:: with SMTP id 70mr14434828wmb.187.1632735124343;
        Mon, 27 Sep 2021 02:32:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTU4NNTP2HGI7OzM+EzYF7opQVO5IGaLtp4UKJfZpY1HlzX9J5DT46xdOlGweUx96TXH9s/w==
X-Received: by 2002:a1c:149:: with SMTP id 70mr14434800wmb.187.1632735124041;
        Mon, 27 Sep 2021 02:32:04 -0700 (PDT)
Received: from redhat.com ([2.55.16.138])
        by smtp.gmail.com with ESMTPSA id k17sm16160443wrq.7.2021.09.27.02.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 02:32:03 -0700 (PDT)
Date:   Mon, 27 Sep 2021 05:31:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, oren@nvidia.com, nitzanc@nvidia.com,
        israelr@nvidia.com, hch@infradead.org, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH 1/2] virtio: introduce virtio_dev_to_node helper
Message-ID: <20210927053121-mutt-send-email-mst@kernel.org>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926145518.64164-1-mgurtovoy@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 26, 2021 at 05:55:17PM +0300, Max Gurtovoy wrote:
> Also expose numa_node field as a sysfs attribute. Now virtio device
> drivers will be able to allocate memory that is node-local to the
> device. This significantly helps performance and it's oftenly used in
> other drivers such as NVMe, for example.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>

If you have to respin this, it is better to split this in
two patches, one with the helper one adding a sysfs attribute.


> ---
>  drivers/virtio/virtio.c | 10 ++++++++++
>  include/linux/virtio.h  | 13 +++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 588e02fb91d3..bdbd76c5c58c 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -60,12 +60,22 @@ static ssize_t features_show(struct device *_d,
>  }
>  static DEVICE_ATTR_RO(features);
>  
> +static ssize_t numa_node_show(struct device *_d,
> +			      struct device_attribute *attr, char *buf)
> +{
> +	struct virtio_device *vdev = dev_to_virtio(_d);
> +
> +	return sysfs_emit(buf, "%d\n", virtio_dev_to_node(vdev));
> +}
> +static DEVICE_ATTR_RO(numa_node);
> +
>  static struct attribute *virtio_dev_attrs[] = {
>  	&dev_attr_device.attr,
>  	&dev_attr_vendor.attr,
>  	&dev_attr_status.attr,
>  	&dev_attr_modalias.attr,
>  	&dev_attr_features.attr,
> +	&dev_attr_numa_node.attr,
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(virtio_dev);
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 41edbc01ffa4..05b586ac71d1 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -125,6 +125,19 @@ static inline struct virtio_device *dev_to_virtio(struct device *_dev)
>  	return container_of(_dev, struct virtio_device, dev);
>  }
>  
> +/**
> + * virtio_dev_to_node - return the NUMA node for a given virtio device
> + * @vdev:	device to get the NUMA node for.
> + */
> +static inline int virtio_dev_to_node(struct virtio_device *vdev)
> +{
> +	struct device *parent = vdev->dev.parent;
> +
> +	if (!parent)
> +		return NUMA_NO_NODE;
> +	return dev_to_node(parent);
> +}
> +
>  void virtio_add_status(struct virtio_device *dev, unsigned int status);
>  int register_virtio_device(struct virtio_device *dev);
>  void unregister_virtio_device(struct virtio_device *dev);
> -- 
> 2.18.1

