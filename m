Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EAD3BAF44
	for <lists+kvm@lfdr.de>; Sun,  4 Jul 2021 23:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhGDVw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jul 2021 17:52:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbhGDVw6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 4 Jul 2021 17:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625435421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hIGegxYGDRVnY+0B5U65wuNVG6v5O6+ZCTdBoj9f2Yw=;
        b=hhY/IpIBIu6q1p+qrMpKTgq9ZLPwe+p0Zx3+tURkKOxtVWvcdTeJRhIITBkwNcJy3TG9rC
        I/6GB/OFeKdA1+oQKEk2POUvXCgCmYlxU3k2hxFXM19i6+2wOqtGSwYpHxpIwbwSZ+NoDw
        077Q+FlvALzBJY0wCrC1oL4Ac6f8dqo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-33Ei6gt1P-C-kYW-1U8Nfg-1; Sun, 04 Jul 2021 17:50:20 -0400
X-MC-Unique: 33Ei6gt1P-C-kYW-1U8Nfg-1
Received: by mail-wr1-f71.google.com with SMTP id e13-20020a5d530d0000b0290126d989c76eso5754682wrv.18
        for <kvm@vger.kernel.org>; Sun, 04 Jul 2021 14:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hIGegxYGDRVnY+0B5U65wuNVG6v5O6+ZCTdBoj9f2Yw=;
        b=ZQAO+aHwC2as/EeD2iyCpuz44HNvL02MxW5SbWvEFnFdoSAVU8i86wLRzEOB+sE9LH
         JdePfvDP24mKhXPzumjGn5EcItM/kxSX+CAZi0ECb/an8s8Nt5d0OrHSTZr5Ro1r5FBr
         GpeujUEP7l6LXiNFibruxqdWkzwbut8VzWmw2vOK8xYjy4crtxBtduwn5VPn3junVn4n
         13EsoQOl8R+10Hqqv6pRrtPFJRkicKPQtvADkzJkU03FPzcGdITmPCAhv/Z+gxxdcwH0
         tglZwXay3MtQphwakpbwh6YmCJR5W+DwiKuiVaDO9nu7eeG1P1hzx1zjChr81uz6xHb1
         zjqA==
X-Gm-Message-State: AOAM5301At1ySxdQc+trBtS1eIn2ZkaTXjFuk+nvfAAXfVPA0B6Uo2cN
        aIvqoCPjv4R/J7NHF7KkDhfIStqVVzFYSfepJQLaQmYDZKJhxDFNcOyAsB73XBG37T5Tfavmkjy
        GFWQu1dsyFEmR
X-Received: by 2002:a05:600c:3501:: with SMTP id h1mr4478400wmq.157.1625435419082;
        Sun, 04 Jul 2021 14:50:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMAN2Vtw1cK9aE+mZwmlC30rOpcp20CWrNEC04TT9Kpl1piUVWOO3pZq+1QEDhpbR9mFw+gQ==
X-Received: by 2002:a05:600c:3501:: with SMTP id h1mr4478371wmq.157.1625435418721;
        Sun, 04 Jul 2021 14:50:18 -0700 (PDT)
Received: from redhat.com ([2.55.4.39])
        by smtp.gmail.com with ESMTPSA id n13sm2841425wms.4.2021.07.04.14.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 14:50:17 -0700 (PDT)
Date:   Sun, 4 Jul 2021 17:50:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     gautam.dawar@xilinx.com
Cc:     martinh@xilinx.com, hanand@xilinx.com, gdawar@xilinx.com,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] vhost-vdpa: mark vhost device invalid to reflect
 vdpa device unregistration
Message-ID: <20210704174856-mutt-send-email-mst@kernel.org>
References: <20210704205205.6132-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210704205205.6132-1-gdawar@xilinx.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 05, 2021 at 02:22:04AM +0530, gautam.dawar@xilinx.com wrote:
> From: Gautam Dawar <gdawar@xilinx.com>
> 
> As mentioned in Bug 213179, any malicious user-space application can render
> a module registering a vDPA device to hang forever. This will typically
> surface when vdpa_device_unregister() is called from the function
> responsible for module unload, leading rmmod commands to not return.
> 
> This patch unblocks the caller module by continuing with the clean-up
> but after marking the vhost device as unavailable. For future requests
> from user-space application, the vhost device availability is checked
> first and if it has gone unavailable, such requests are denied.
> 
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>


I don't seem mappings handled below. Did I miss it?

> ---
>  drivers/vhost/vdpa.c | 45 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index e4b7d26649d8..623bc7f0c0ca 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -47,6 +47,7 @@ struct vhost_vdpa {
>  	int minor;
>  	struct eventfd_ctx *config_ctx;
>  	int in_batch;
> +	int dev_invalid;
>  	struct vdpa_iova_range range;
>  };
>  
> @@ -61,6 +62,11 @@ static void handle_vq_kick(struct vhost_work *work)
>  	struct vhost_vdpa *v = container_of(vq->dev, struct vhost_vdpa, vdev);
>  	const struct vdpa_config_ops *ops = v->vdpa->config;
>  
> +	if (v->dev_invalid) {
> +		dev_info(&v->dev,
> +			 "%s: vhost_vdpa device unavailable\n", __func__);
> +		return;
> +	}
>  	ops->kick_vq(v->vdpa, vq - v->vqs);
>  }
>  
> @@ -120,6 +126,11 @@ static void vhost_vdpa_reset(struct vhost_vdpa *v)
>  {
>  	struct vdpa_device *vdpa = v->vdpa;
>  
> +	if (v->dev_invalid) {
> +		dev_info(&v->dev,
> +			 "%s: vhost_vdpa device unavailable\n", __func__);
> +		return;
> +	}
>  	vdpa_reset(vdpa);
>  	v->in_batch = 0;
>  }
> @@ -367,6 +378,11 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  	u32 idx;
>  	long r;
>  
> +	if (v->dev_invalid) {
> +		dev_info(&v->dev,
> +			 "%s: vhost_vdpa device unavailable\n", __func__);
> +		return -ENODEV;
> +	}
>  	r = get_user(idx, (u32 __user *)argp);
>  	if (r < 0)
>  		return r;
> @@ -450,6 +466,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  		return 0;
>  	}
>  
> +	if (v->dev_invalid) {
> +		dev_info(&v->dev,
> +			 "%s: vhost_vdpa device unavailable\n", __func__);
> +		return -ENODEV;
> +	}
>  	mutex_lock(&d->mutex);
>  
>  	switch (cmd) {
> @@ -745,8 +766,13 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>  	const struct vdpa_config_ops *ops = vdpa->config;
>  	int r = 0;
>  
> -	mutex_lock(&dev->mutex);
> +	if (v->dev_invalid) {
> +		dev_info(&v->dev,
> +			 "%s: vhost_vdpa device unavailable\n", __func__);
> +		return -ENODEV;
> +	}
>  
> +	mutex_lock(&dev->mutex);
>  	r = vhost_dev_check_owner(dev);
>  	if (r)
>  		goto unlock;
> @@ -949,6 +975,11 @@ static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
>  	struct vm_area_struct *vma = vmf->vma;
>  	u16 index = vma->vm_pgoff;
>  
> +	if (v->dev_invalid) {
> +		dev_info(&v->dev,
> +			 "%s: vhost_vdpa device unavailable\n", __func__);
> +		return VM_FAULT_NOPAGE;
> +	}
>  	notify = ops->get_vq_notification(vdpa, index);
>  
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> @@ -1091,11 +1122,13 @@ static void vhost_vdpa_remove(struct vdpa_device *vdpa)
>  		opened = atomic_cmpxchg(&v->opened, 0, 1);
>  		if (!opened)
>  			break;
> -		wait_for_completion_timeout(&v->completion,
> -					    msecs_to_jiffies(1000));
> -		dev_warn_once(&v->dev,
> -			      "%s waiting for /dev/%s to be closed\n",
> -			      __func__, dev_name(&v->dev));
> +		if (!wait_for_completion_timeout(&v->completion,
> +					    msecs_to_jiffies(1000))) {
> +			dev_warn(&v->dev,
> +				 "%s /dev/%s in use, continue..\n",
> +				 __func__, dev_name(&v->dev));
> +			break;
> +		}

When you have an arbitrary timeout you know something's not entirely
robust ...

>  	} while (1);
>  
>  	put_device(&v->dev);
> +	v->dev_invalid = true;
> -- 
> 2.30.1

