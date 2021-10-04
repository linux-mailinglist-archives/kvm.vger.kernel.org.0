Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AC44219F6
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 00:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhJDW13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:27:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233722AbhJDW12 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 18:27:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633386338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yvKv1egwmpu/+1EP5OZpb8Q8WN93a/8Rfv1bb3rpQqE=;
        b=fGEvaWX4uCsNao1WsX7pngV81JsgRxuj7pn3DGy5Z/pej+tRfoYwyG+febsVIbn4PcZKZ4
        7rjmjhp3ekb/1k6pka9NMIMVgRKx6HxW6R4JHEgixTVg+F4kyCPYcK8UeTG4jmt+BiO1G2
        IgKIcknwLIvBV0o3lmC9x43sj0AOTuA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-a1tnlv8_NS6E3_Wy_V_Tag-1; Mon, 04 Oct 2021 18:25:37 -0400
X-MC-Unique: a1tnlv8_NS6E3_Wy_V_Tag-1
Received: by mail-io1-f70.google.com with SMTP id m19-20020a6bea13000000b005d751644a6eso17403355ioc.15
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 15:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yvKv1egwmpu/+1EP5OZpb8Q8WN93a/8Rfv1bb3rpQqE=;
        b=7JSO3fgGYyK9PKNwoVQX5s1G1nhNsdztLeb4gk1u9yEB6ePOutrzt0HNUG2MrgcpFM
         yuCBwxIDqBybDuUezgGHD5QAg9VKfylgsypsB2YPT2EMqBqcKQYhrdllCh9HBMZOZYRY
         Y5LnYjeBsFpSWQwezIr85/Aq+hd3i4YjDhokUfCv0cJc0dRgywLXDKysPD96us1TXx1n
         KR0qR6a7f0fK47IPHGdhQodylNg4EQvyDglDQxNpkvN5aG/m4VNGjHfBg08VfK4wmo/V
         fH34MxSydiKop4CvCbQb5s2664s2H8flBj6JjIXPgQu8PyOT1tXJJ7fbVIu7gO9vsIzX
         siiw==
X-Gm-Message-State: AOAM531xAp8ZflV/VBdcuX2QObWUC8w5qwoIBz50yWoswxIJGD4hQ8Mj
        Hdn2ZhaHgYCtQuAvzkaOhKh8PbHxxSDDmLnVQxus24o9EcX9uHoPXmHSurHMSo+axak8YTTupPK
        RBA0ESRH4gw+6
X-Received: by 2002:a05:6e02:893:: with SMTP id z19mr415045ils.224.1633386336259;
        Mon, 04 Oct 2021 15:25:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb11uJuV9OY8NSXRgXb0Uc+pwT2QLSL8RW5StCVV3tEmlwsicoq8wJ9+dzXHMduQg1Uw7dQA==
X-Received: by 2002:a05:6e02:893:: with SMTP id z19mr415026ils.224.1633386335886;
        Mon, 04 Oct 2021 15:25:35 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id a5sm10614017ilf.27.2021.10.04.15.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 15:25:35 -0700 (PDT)
Date:   Mon, 4 Oct 2021 16:25:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH 1/5] vfio: Delete vfio_get/put_group from
 vfio_iommu_group_notifier()
Message-ID: <20211004162532.3b59ed06.alex.williamson@redhat.com>
In-Reply-To: <1-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
        <1-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  1 Oct 2021 20:22:20 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> iommu_group_register_notifier()/iommu_group_unregister_notifier() are
> built using a blocking_notifier_chain which integrates a rwsem. The
> notifier function cannot be running outside its registration.
> 
> When considering how the notifier function interacts with create/destroy
> of the group there are two fringe cases, the notifier starts before
> list_add(&vfio.group_list) and the notifier runs after the kref
> becomes 0.
> 
> Prior to vfio_create_group() unlocking and returning we have
>    container_users == 0
>    device_list == empty
> And this cannot change until the mutex is unlocked.
> 
> After the kref goes to zero we must also have
>    container_users == 0
>    device_list == empty
> 
> Both are required because they are balanced operations and a 0 kref means
> some caller became unbalanced. Add the missing assertion that
> container_users must be zero as well.
> 
> These two facts are important because when checking each operation we see:
> 
> - IOMMU_GROUP_NOTIFY_ADD_DEVICE
>    Empty device_list avoids the WARN_ON in vfio_group_nb_add_dev()
>    0 container_users ends the call
> - IOMMU_GROUP_NOTIFY_BOUND_DRIVER
>    0 container_users ends the call
> 
> Finally, we have IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER, which only deletes
> items from the unbound list. During creation this list is empty, during
> kref == 0 nothing can read this list, and it will be freed soon.
> 
> Since the vfio_group_release() doesn't hold the appropriate lock to
> manipulate the unbound_list and could race with the notifier, move the
> cleanup to directly before the kfree.
> 
> This allows deleting all of the deferred group put code.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 89 +++++----------------------------------------
>  1 file changed, 9 insertions(+), 80 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 08b27b64f0f935..32a53cb3598524 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -324,12 +324,20 @@ static void vfio_container_put(struct vfio_container *container)
>  
>  static void vfio_group_unlock_and_free(struct vfio_group *group)
>  {
> +	struct vfio_unbound_dev *unbound, *tmp;
> +
>  	mutex_unlock(&vfio.group_lock);
>  	/*
>  	 * Unregister outside of lock.  A spurious callback is harmless now
>  	 * that the group is no longer in vfio.group_list.
>  	 */

This comment is indirectly referencing the vfio_group_try_get() in the
notifier callback, but as you describe in the commit log, it's actually
the container_users value that prevents this from racing group release
now.  Otherwise, tricky but looks good.  Thanks,

Alex


>  	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
> +
> +	list_for_each_entry_safe(unbound, tmp,
> +				 &group->unbound_list, unbound_next) {
> +		list_del(&unbound->unbound_next);
> +		kfree(unbound);
> +	}
>  	kfree(group);
>  }
>  
> @@ -361,13 +369,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  
>  	group->nb.notifier_call = vfio_iommu_group_notifier;
>  
> -	/*
> -	 * blocking notifiers acquire a rwsem around registering and hold
> -	 * it around callback.  Therefore, need to register outside of
> -	 * vfio.group_lock to avoid A-B/B-A contention.  Our callback won't
> -	 * do anything unless it can find the group in vfio.group_list, so
> -	 * no harm in registering early.
> -	 */
>  	ret = iommu_group_register_notifier(iommu_group, &group->nb);
>  	if (ret) {
>  		kfree(group);
> @@ -415,18 +416,12 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  static void vfio_group_release(struct kref *kref)
>  {
>  	struct vfio_group *group = container_of(kref, struct vfio_group, kref);
> -	struct vfio_unbound_dev *unbound, *tmp;
>  	struct iommu_group *iommu_group = group->iommu_group;
>  
>  	WARN_ON(!list_empty(&group->device_list));
> +	WARN_ON(atomic_read(&group->container_users));
>  	WARN_ON(group->notifier.head);
>  
> -	list_for_each_entry_safe(unbound, tmp,
> -				 &group->unbound_list, unbound_next) {
> -		list_del(&unbound->unbound_next);
> -		kfree(unbound);
> -	}
> -
>  	device_destroy(vfio.class, MKDEV(MAJOR(vfio.group_devt), group->minor));
>  	list_del(&group->vfio_next);
>  	vfio_free_group_minor(group->minor);
> @@ -439,61 +434,12 @@ static void vfio_group_put(struct vfio_group *group)
>  	kref_put_mutex(&group->kref, vfio_group_release, &vfio.group_lock);
>  }
>  
> -struct vfio_group_put_work {
> -	struct work_struct work;
> -	struct vfio_group *group;
> -};
> -
> -static void vfio_group_put_bg(struct work_struct *work)
> -{
> -	struct vfio_group_put_work *do_work;
> -
> -	do_work = container_of(work, struct vfio_group_put_work, work);
> -
> -	vfio_group_put(do_work->group);
> -	kfree(do_work);
> -}
> -
> -static void vfio_group_schedule_put(struct vfio_group *group)
> -{
> -	struct vfio_group_put_work *do_work;
> -
> -	do_work = kmalloc(sizeof(*do_work), GFP_KERNEL);
> -	if (WARN_ON(!do_work))
> -		return;
> -
> -	INIT_WORK(&do_work->work, vfio_group_put_bg);
> -	do_work->group = group;
> -	schedule_work(&do_work->work);
> -}
> -
>  /* Assume group_lock or group reference is held */
>  static void vfio_group_get(struct vfio_group *group)
>  {
>  	kref_get(&group->kref);
>  }
>  
> -/*
> - * Not really a try as we will sleep for mutex, but we need to make
> - * sure the group pointer is valid under lock and get a reference.
> - */
> -static struct vfio_group *vfio_group_try_get(struct vfio_group *group)
> -{
> -	struct vfio_group *target = group;
> -
> -	mutex_lock(&vfio.group_lock);
> -	list_for_each_entry(group, &vfio.group_list, vfio_next) {
> -		if (group == target) {
> -			vfio_group_get(group);
> -			mutex_unlock(&vfio.group_lock);
> -			return group;
> -		}
> -	}
> -	mutex_unlock(&vfio.group_lock);
> -
> -	return NULL;
> -}
> -
>  static
>  struct vfio_group *vfio_group_get_from_iommu(struct iommu_group *iommu_group)
>  {
> @@ -691,14 +637,6 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
>  	struct device *dev = data;
>  	struct vfio_unbound_dev *unbound;
>  
> -	/*
> -	 * Need to go through a group_lock lookup to get a reference or we
> -	 * risk racing a group being removed.  Ignore spurious notifies.
> -	 */
> -	group = vfio_group_try_get(group);
> -	if (!group)
> -		return NOTIFY_OK;
> -
>  	switch (action) {
>  	case IOMMU_GROUP_NOTIFY_ADD_DEVICE:
>  		vfio_group_nb_add_dev(group, dev);
> @@ -749,15 +687,6 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
>  		mutex_unlock(&group->unbound_lock);
>  		break;
>  	}
> -
> -	/*
> -	 * If we're the last reference to the group, the group will be
> -	 * released, which includes unregistering the iommu group notifier.
> -	 * We hold a read-lock on that notifier list, unregistering needs
> -	 * a write-lock... deadlock.  Release our reference asynchronously
> -	 * to avoid that situation.
> -	 */
> -	vfio_group_schedule_put(group);
>  	return NOTIFY_OK;
>  }
>  

