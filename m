Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8CB67478A
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjASXws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjASXwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:52:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1489F394
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674172322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4R9MpU1qGlLDfX/V36djUL2kxqeKk6GpcFMsyNmyNA=;
        b=JhS89CIAqzvavEvWoK1aO6jHgVC0senfTf9M1nnt+5tFAhC31Coo4vAGMkOnPvAOpDQALy
        25PTKktZTUGAkv9Bm/MU1+HzmWzhzkfPWfULb9m8Ovel+e7I++E3hGiLXNUyRj/aV9Wh0f
        W4hj34HQN79AOQfrAB1yuj193IdW/q0=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-spdDCOU4Pz2UuEh__d8LKg-1; Thu, 19 Jan 2023 18:52:00 -0500
X-MC-Unique: spdDCOU4Pz2UuEh__d8LKg-1
Received: by mail-io1-f69.google.com with SMTP id d189-20020a6bb4c6000000b00704ce012109so2039494iof.1
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:52:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A4R9MpU1qGlLDfX/V36djUL2kxqeKk6GpcFMsyNmyNA=;
        b=JYP38FdwoPZRyTqSVlIS24cJYv8ZMdavaqmGDztHlDciYWSSfdxaW17rUCQbO0KSb3
         RPMlle7E4tDFH1uMBxXmbO1OqXlfNNuuqe5g1rBSXUhJohvYmEmmfWUPiuDZNiSBWmQg
         WJn6I/8wjtBHF6D/3zYDn3V4ahKU5UXTOusEbDD8wQ+ZnCFtpPmPOH+mF7XYrzjuyNUD
         JpDfqJA1MZHCBhTn6STOrPuCIfH3CzO8z8IH3IMBqiImTCyx5GB14lUcY83blTYUvk3F
         s/NYtw9LWjvYn/I2QPxkqjCO4LLGOfCkX41WClWax7ohCgSjfdzMOd2mn2mTYM5/cmC5
         DNyQ==
X-Gm-Message-State: AFqh2kq2CLKAUCYW1X1AWZmeiEBWJONU5bA0BxdZgD1g7kcdjaekWKqK
        7LO/UVMhknOpkuUbpAscYarzkRWWNZ5gDjE66WGouPXGto+CzfsQKuaggIF64W5RrtPitwVDsqa
        lJUR+mpBTd3M8
X-Received: by 2002:a6b:c9cc:0:b0:707:7d90:60da with SMTP id z195-20020a6bc9cc000000b007077d9060damr1825424iof.18.1674172319954;
        Thu, 19 Jan 2023 15:51:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtdHq21bowAOl0hVFkr6kMGmobOCvHimmhIJpwF+zjRwEiauDhactER/FsurC5m1DbXVKJMvw==
X-Received: by 2002:a6b:c9cc:0:b0:707:7d90:60da with SMTP id z195-20020a6bc9cc000000b007077d9060damr1825408iof.18.1674172319652;
        Thu, 19 Jan 2023 15:51:59 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l206-20020a6b3ed7000000b00704c45c795dsm3312593ioa.33.2023.01.19.15.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 15:51:59 -0800 (PST)
Date:   Thu, 19 Jan 2023 16:51:57 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: Re: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Message-ID: <20230119165157.5de95216.alex.williamson@redhat.com>
In-Reply-To: <20230117134942.101112-11-yi.l.liu@intel.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
        <20230117134942.101112-11-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Jan 2023 05:49:39 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> VFIO group has historically allowed multi-open of the device FD. This
> was made secure because the "open" was executed via an ioctl to the
> group FD which is itself only single open.
> 
> No know use of multiple device FDs is known. It is kind of a strange
  ^^ ^^^^                               ^^^^^

> thing to do because new device FDs can naturally be created via dup().
> 
> When we implement the new device uAPI there is no natural way to allow
> the device itself from being multi-opened in a secure manner. Without
> the group FD we cannot prove the security context of the opener.
> 
> Thus, when moving to the new uAPI we block the ability to multi-open
> the device. This also makes the cdev path exclusive with group path.
> 
> The main logic is in the vfio_device_open(). It needs to sustain both
> the legacy behavior i.e. multi-open in the group path and the new
> behavior i.e. single-open in the cdev path. This mixture leads to the
> introduction of a new single_open flag stored both in struct vfio_device
> and vfio_device_file. vfio_device_file::single_open is set per the
> vfio_device_file allocation. Its value is propagated to struct vfio_device
> after device is opened successfully.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     |  2 +-
>  drivers/vfio/vfio.h      |  6 +++++-
>  drivers/vfio/vfio_main.c | 25 ++++++++++++++++++++++---
>  include/linux/vfio.h     |  1 +
>  4 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 9484bb1c54a9..57ebe5e1a7e6 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -216,7 +216,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  	struct file *filep;
>  	int ret;
>  
> -	df = vfio_allocate_device_file(device);
> +	df = vfio_allocate_device_file(device, false);
>  	if (IS_ERR(df)) {
>  		ret = PTR_ERR(df);
>  		goto err_out;
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index fe0fcfa78710..bdcf9762521d 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -17,7 +17,11 @@ struct vfio_device;
>  struct vfio_container;
>  
>  struct vfio_device_file {
> +	/* static fields, init per allocation */
>  	struct vfio_device *device;
> +	bool single_open;
> +
> +	/* fields set after allocation */
>  	struct kvm *kvm;
>  	struct iommufd_ctx *iommufd;
>  	bool access_granted;
> @@ -30,7 +34,7 @@ int vfio_device_open(struct vfio_device_file *df,
>  void vfio_device_close(struct vfio_device_file *device);
>  
>  struct vfio_device_file *
> -vfio_allocate_device_file(struct vfio_device *device);
> +vfio_allocate_device_file(struct vfio_device *device, bool single_open);
>  
>  extern const struct file_operations vfio_device_fops;
>  
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 90174a9015c4..78725c28b933 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -345,7 +345,7 @@ static bool vfio_assert_device_open(struct vfio_device *device)
>  }
>  
>  struct vfio_device_file *
> -vfio_allocate_device_file(struct vfio_device *device)
> +vfio_allocate_device_file(struct vfio_device *device, bool single_open)
>  {
>  	struct vfio_device_file *df;
>  
> @@ -354,6 +354,7 @@ vfio_allocate_device_file(struct vfio_device *device)
>  		return ERR_PTR(-ENOMEM);
>  
>  	df->device = device;
> +	df->single_open = single_open;

It doesn't make sense to me to convolute the definition of this
function with an unmemorable bool arg when the one caller that sets the
value true could simply open code it.

>  
>  	return df;
>  }
> @@ -421,6 +422,16 @@ int vfio_device_open(struct vfio_device_file *df,
>  
>  	lockdep_assert_held(&device->dev_set->lock);
>  
> +	/*
> +	 * Device cdev path cannot support multiple device open since
> +	 * it doesn't have a secure way for it. So a second device
> +	 * open attempt should be failed if the caller is from a cdev
> +	 * path or the device has already been opened by a cdev path.
> +	 */
> +	if (device->open_count != 0 &&
> +	    (df->single_open || device->single_open))
> +		return -EINVAL;

IIUC, the reason this exists is that we let the user open the device
cdev arbitrarily, but only one instance can call
ioctl(VFIO_DEVICE_BIND_IOMMUFD).  Why do we bother to let the user
create those other file instances?  What expectations are we setting
for the user by allowing them to open the device but not use it?

Clearly we're thinking about a case here where the device has been
opened via the group path and the user is now attempting to bind the
same device via the cdev path.  That seems wrong to even allow and I'm
surprised it gets this far.  In fact, where do we block a user from
opening one device in a group via cdev and another via the group?


> +
>  	device->open_count++;
>  	if (device->open_count == 1) {
>  		int ret;
> @@ -430,6 +441,7 @@ int vfio_device_open(struct vfio_device_file *df,
>  			device->open_count--;
>  			return ret;
>  		}
> +		device->single_open = df->single_open;
>  	}
>  
>  	/*
> @@ -446,8 +458,10 @@ void vfio_device_close(struct vfio_device_file *df)
>  
>  	mutex_lock(&device->dev_set->lock);
>  	vfio_assert_device_open(device);
> -	if (device->open_count == 1)
> +	if (device->open_count == 1) {
>  		vfio_device_last_close(df);
> +		device->single_open = false;
> +	}
>  	device->open_count--;
>  	mutex_unlock(&device->dev_set->lock);
>  }
> @@ -493,7 +507,12 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> -	vfio_device_group_close(df);
> +	/*
> +	 * group path supports multiple device open, while cdev doesn't.
> +	 * So use vfio_device_group_close() for !singel_open case.
> +	 */
> +	if (!df->single_open)
> +		vfio_device_group_close(df);

If we're going to use this to differentiate group vs cdev use cases,
then let's name it something to reflect that rather than pretending it
only limits the number of opens, ex. is_cdev_device.  Thanks,

Alex


>  
>  	vfio_device_put_registration(device);
>  
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 46edd6e6c0ba..300318f0d448 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -63,6 +63,7 @@ struct vfio_device {
>  	struct iommufd_ctx *iommufd_ictx;
>  	bool iommufd_attached;
>  #endif
> +	bool single_open;
>  };
>  
>  /**

