Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DACF3DF29A
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 18:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhHCQeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 12:34:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234065AbhHCQeX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 12:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628008451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZC6fz0wH6LOZCoKtHBlL+gFtJ2XidB4lNAk1d1Zfen0=;
        b=a9ZYgOtjKrdFbjzBEbY7/aTlsTofEj3MnIYL1+KlUM36VqIMYZy5jQcaJsU5Uo3QbuRZH5
        FdU/4vq72qaDwQlcp61VqsELO08bPrkJAKTNxM7y3qgJ3Pup55ILqwSqc8EWDM92S+NFaP
        L4RJ0QnY8H6aXS0RcnH+y//3/r2MIh8=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-JVuOZ60eMIiSKdHaviEWVw-1; Tue, 03 Aug 2021 12:34:10 -0400
X-MC-Unique: JVuOZ60eMIiSKdHaviEWVw-1
Received: by mail-oi1-f200.google.com with SMTP id s17-20020a0568080b11b02901f424a672b7so8846009oij.18
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 09:34:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZC6fz0wH6LOZCoKtHBlL+gFtJ2XidB4lNAk1d1Zfen0=;
        b=IUChB4IHGbZDoBR7U/3cRNvoba9Yff5CxprRj6Rc6D0/quCdcsT98WpBxqDusrFnz3
         RrzC7xL7kPR2qgJGQyJNPQs+MQwx1UhAEsXV/Dlzc3DWOu/suMSbAs/WDvZ83jNxEfcy
         Y4fjNu2JPhgWfrKWysYt1vX2654CzPZvYMwuHBlJu7sDUExBKJslkitcDLujnOO08d7o
         GDvKarFc9wmcj7lskDc+PeNvA4VTXqn96NmE505FxwUKxlzLdKZiyE4BfXdeMLOlXCjv
         PGupV7I9uYeRsrMlA6d6gX47J+gue/V1dnoUNl12pV+A3wDGb1kcn3lQvbtvmXVZ7X1b
         Wwyw==
X-Gm-Message-State: AOAM530wEXVY+TYIVs51WoDYjcA+3U3EbId0y0i8MbUOF63X2pcQCfIP
        3lFiRoTHdAAUhiI7tysbyXrV/M5x+8vr/pIFZ9KDHd7BDDVGwH7gm4/gCEzMIOJrOemgAZ+E/S1
        vhALR1uGjgh6A
X-Received: by 2002:a54:478e:: with SMTP id o14mr3753038oic.173.1628008449663;
        Tue, 03 Aug 2021 09:34:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFwuESI0HnE76c1/AUZG8mHAVE7uoxUNQvCdQAFpY43ILy5oWRZNuayH573kYg7XpB5z/ECQ==
X-Received: by 2002:a54:478e:: with SMTP id o14mr3752987oic.173.1628008449364;
        Tue, 03 Aug 2021 09:34:09 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id h1sm2607585otj.48.2021.08.03.09.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:34:09 -0700 (PDT)
Date:   Tue, 3 Aug 2021 10:34:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v3 09/14] vfio/pci: Change vfio_pci_try_bus_reset() to
 use the dev_set
Message-ID: <20210803103406.5e1be269.alex.williamson@redhat.com>
In-Reply-To: <9-v3-6c9e19cc7d44+15613-vfio_reflck_jgg@nvidia.com>
References: <0-v3-6c9e19cc7d44+15613-vfio_reflck_jgg@nvidia.com>
        <9-v3-6c9e19cc7d44+15613-vfio_reflck_jgg@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Jul 2021 21:49:18 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Keep track of all the vfio_devices that have been added to the device set
> and use this list in vfio_pci_try_bus_reset() instead of trying to work
> backwards from the pci_device.
> 
> The dev_set->lock directly prevents devices from joining/leaving the set,
> which further implies the pci_device cannot change drivers or that the
> vfio_device be freed, eliminating the need for get/put's.
> 
> Completeness of the device set can be directly measured by checking if
> every PCI device in the reset group is also in the device set - which
> proves that VFIO drivers are attached to everything.
> 
> This restructuring corrects a call to pci_dev_driver() without holding the
> device_lock() and removes a hard wiring to &vfio_pci_driver.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 148 +++++++++++++++---------------------
>  1 file changed, 62 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 5d6db93d6c680f..a1ae9a83a38621 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -404,6 +404,9 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
>  	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
>  	int i, bar;
>  
> +	/* For needs_reset */
> +	lockdep_assert_held(&vdev->vdev.dev_set->lock);
> +
>  	/* Stop the device from further DMA */
>  	pci_clear_master(pdev);
>  
> @@ -2145,7 +2148,7 @@ static struct pci_driver vfio_pci_driver = {
>  	.err_handler		= &vfio_err_handlers,
>  };
>  
> -static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
> +static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
>  {
>  	struct vfio_devices *devs = data;
>  	struct vfio_device *device;
> @@ -2165,8 +2168,11 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
>  
>  	vdev = container_of(device, struct vfio_pci_device, vdev);
>  
> -	/* Fault if the device is not unused */
> -	if (device->open_count) {
> +	/*
> +	 * Locking multiple devices is prone to deadlock, runaway and
> +	 * unwind if we hit contention.
> +	 */
> +	if (!vfio_pci_zap_and_vma_lock(vdev, true)) {
>  		vfio_device_put(device);
>  		return -EBUSY;
>  	}
> @@ -2175,112 +2181,82 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
>  	return 0;
>  }
>  
> -static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
> +static int vfio_pci_is_device_in_set(struct pci_dev *pdev, void *data)
>  {
> -	struct vfio_devices *devs = data;
> -	struct vfio_device *device;
> -	struct vfio_pci_device *vdev;
> +	struct vfio_device_set *dev_set = data;
> +	struct vfio_device *cur;
>  
> -	if (devs->cur_index == devs->max_index)
> -		return -ENOSPC;
> +	lockdep_assert_held(&dev_set->lock);
>  
> -	device = vfio_device_get_from_dev(&pdev->dev);
> -	if (!device)
> -		return -EINVAL;
> -
> -	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
> -		vfio_device_put(device);
> -		return -EBUSY;
> -	}
> -
> -	vdev = container_of(device, struct vfio_pci_device, vdev);
> +	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> +		if (cur->dev == &pdev->dev)
> +			return 0;
> +	return -EBUSY;
> +}
>  
> -	/*
> -	 * Locking multiple devices is prone to deadlock, runaway and
> -	 * unwind if we hit contention.
> -	 */
> -	if (!vfio_pci_zap_and_vma_lock(vdev, true)) {
> -		vfio_device_put(device);
> -		return -EBUSY;
> +/*
> + * vfio-core considers a group to be viable and will create a vfio_device even
> + * if some devices are bound to drivers like pci-stub or pcieport.  Here we
> + * require all PCI devices to be inside our dev_set since that ensures they stay
> + * put and that every driver controlling the device can co-ordinate with the
> + * device reset.
> + */
> +static struct pci_dev *vfio_pci_find_reset_target(struct vfio_pci_device *vdev)
> +{
> +	struct vfio_device_set *dev_set = vdev->vdev.dev_set;
> +	struct vfio_pci_device *cur;
> +	bool needs_reset = false;
> +
> +	/* No VFIO device has an open device FD */
> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> +		if (cur->vdev.open_count)
> +			return NULL;
> +		needs_reset |= cur->needs_reset;
>  	}
> +	if (!needs_reset)
> +		return NULL;
>  
> -	devs->devices[devs->cur_index++] = vdev;
> -	return 0;
> +	/* All PCI devices in the group to be reset need to be in our dev_set */
> +	if (vfio_pci_for_each_slot_or_bus(
> +		    vdev->pdev, vfio_pci_is_device_in_set, dev_set,
> +		    !pci_probe_reset_slot(vdev->pdev->slot)))
> +		return NULL;
> +	return cur->pdev;


I don't understand the "reset target" aspect of this, cur->pdev is
simply the last entry in the dev_set->devices_list...

>  }
>  
>  /*
>   * If a bus or slot reset is available for the provided device and:
>   *  - All of the devices affected by that bus or slot reset are unused
> - *    (!refcnt)
>   *  - At least one of the affected devices is marked dirty via
>   *    needs_reset (such as by lack of FLR support)
> - * Then attempt to perform that bus or slot reset.  Callers are required
> - * to hold vdev->dev_set->lock, protecting the bus/slot reset group from
> - * concurrent opens.  A vfio_device reference is acquired for each device
> - * to prevent unbinds during the reset operation.
> - *
> - * NB: vfio-core considers a group to be viable even if some devices are
> - * bound to drivers like pci-stub or pcieport.  Here we require all devices
> - * to be bound to vfio_pci since that's the only way we can be sure they
> - * stay put.
> + * Then attempt to perform that bus or slot reset.
>   */
>  static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
>  {
> -	struct vfio_devices devs = { .cur_index = 0 };
> -	int i = 0, ret = -EINVAL;
> -	bool slot = false;
> -	struct vfio_pci_device *tmp;
> -
> -	if (!pci_probe_reset_slot(vdev->pdev->slot))
> -		slot = true;
> -	else if (pci_probe_reset_bus(vdev->pdev->bus))
> -		return;
> +	struct vfio_device_set *dev_set = vdev->vdev.dev_set;
> +	struct pci_dev *to_reset;
> +	struct vfio_pci_device *cur;
> +	int ret;
>  
> -	if (vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
> -					  &i, slot) || !i)
> -		return;
> +	lockdep_assert_held(&vdev->vdev.dev_set->lock);
>  
> -	devs.max_index = i;
> -	devs.devices = kcalloc(i, sizeof(struct vfio_device *), GFP_KERNEL);
> -	if (!devs.devices)
> +	if (pci_probe_reset_slot(vdev->pdev->slot) &&
> +	    pci_probe_reset_bus(vdev->pdev->bus))
>  		return;
>  
> -	if (vfio_pci_for_each_slot_or_bus(vdev->pdev,
> -					  vfio_pci_get_unused_devs,
> -					  &devs, slot))
> -		goto put_devs;
> -
> -	/* Does at least one need a reset? */
> -	for (i = 0; i < devs.cur_index; i++) {
> -		tmp = devs.devices[i];
> -		if (tmp->needs_reset) {
> -			ret = pci_reset_bus(vdev->pdev);
> -			break;
> -		}
> -	}
> -
> -put_devs:
> -	for (i = 0; i < devs.cur_index; i++) {
> -		tmp = devs.devices[i];
> -
> -		/*
> -		 * If reset was successful, affected devices no longer need
> -		 * a reset and we should return all the collateral devices
> -		 * to low power.  If not successful, we either didn't reset
> -		 * the bus or timed out waiting for it, so let's not touch
> -		 * the power state.
> -		 */
> -		if (!ret) {
> -			tmp->needs_reset = false;
> +	to_reset = vfio_pci_find_reset_target(vdev);
> +	if (!to_reset)
> +		return;
>  
> -			if (tmp != vdev && !disable_idle_d3)
> -				vfio_pci_set_power_state(tmp, PCI_D3hot);
> -		}
> +	ret = pci_reset_bus(to_reset);
> +	if (ret)
> +		return;
>  
> -		vfio_device_put(&tmp->vdev);
> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> +		cur->needs_reset = false;
> +		if (cur->pdev != to_reset && !disable_idle_d3)
> +			vfio_pci_set_power_state(cur, PCI_D3hot);
>  	}

...which means that here, I think we're putting all but whichever
random device was last in the list into D3.  The intention was that all
the devices except for the one we're operating on should already be in
D3, the bus reset will put them back in D0, so we want to force them
back to D3.

I think the vfio_pci_find_reset_target() function needs to be re-worked
to just tell us true/false that it's ok to reset the provided device,
not to anoint an arbitrary target device.  Thanks,

Alex

> -
> -	kfree(devs.devices);
>  }
>  
>  static void __exit vfio_pci_cleanup(void)

