Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26773421D17
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 06:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhJEEDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 00:03:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhJEEDt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 00:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633406516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rAlBxwIUNGacBEXdDV9GXGeuPCJIcVqETjMpaX52Dew=;
        b=TtdrWXAgaYSnE4AvfjwJU1pEe80+a0wPFLnWo+R9UIZkTJotRDtgUabMxLk7dJAZzdTlSw
        kNeD7R1iv3wJj6XMeXnXy1/rfSagUMN6RAFCrDwsVAdOdOqYnpHb+D24SjDQbOrE7+Q0uf
        W90bLLbFR7LiePtO9xSIxP8hf4mCevo=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-jOheKkC8Ns-gQ_h95Ys9yg-1; Tue, 05 Oct 2021 00:01:55 -0400
X-MC-Unique: jOheKkC8Ns-gQ_h95Ys9yg-1
Received: by mail-oi1-f197.google.com with SMTP id l3-20020aca1903000000b002765b39fad3so9712258oii.3
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 21:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rAlBxwIUNGacBEXdDV9GXGeuPCJIcVqETjMpaX52Dew=;
        b=lq2RJWKvVrMxpvtX0zpmEpiQBK2jVCvVBUwOEUgtgJ7M6ExBKW06S4CP1TyLvoNK7T
         hjrHWbyPazDVuaiU6mvNuZ5XeZ8iY3QtIVzG2WFpAtwNVz0Qo8mfroCVFeddNldSs8x2
         Io5mfKAMej7pCeYW9hpn3u+ahjreB40xMJ4wcbdL7Jl0AdeqF/ttn3lrqlK7IAKZNnZB
         sujwsETTICCThA2n7cL6Q5/tyJL0VWcErHjPPUfnJKMzgfsrrYO8fff7RHUn5f6GitSm
         Ono8WNGq+8lUPkGLESCJfv29EdL5y2DWLFFrqT6b+QvMVK21JTdOzwreZGz58hSxSHTE
         eMdg==
X-Gm-Message-State: AOAM530wAXZI/5az+ilDKsB6kOyZ+lMPijnMZPiyEJPx1FmGs3uqdhid
        IFZYy+HxEDSqxThW9ISYnL8n/Xyc8l6fMGU10pEQO+SzB8GwE26BT2ZchZbjaW7fsLJIUSkjdd7
        PvgxQWV5Lj3r0
X-Received: by 2002:a05:6830:24a3:: with SMTP id v3mr12966906ots.74.1633406514349;
        Mon, 04 Oct 2021 21:01:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3IL2w2Op7aF1DEP5Onl25iIYT7CgqJ7HTmxCGC+tuFNpmlLKrPPa232h/HH2bKwiB8hmv4Q==
X-Received: by 2002:a05:6830:24a3:: with SMTP id v3mr12966889ots.74.1633406514107;
        Mon, 04 Oct 2021 21:01:54 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id bj33sm3351380oib.31.2021.10.04.21.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 21:01:53 -0700 (PDT)
Date:   Mon, 4 Oct 2021 22:01:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH 1/5] vfio: Delete vfio_get/put_group from
 vfio_iommu_group_notifier()
Message-ID: <20211004220152.306c73d2.alex.williamson@redhat.com>
In-Reply-To: <20211004223431.GN964074@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
        <1-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
        <20211004162532.3b59ed06.alex.williamson@redhat.com>
        <20211004223431.GN964074@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 Oct 2021 19:34:31 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Oct 04, 2021 at 04:25:32PM -0600, Alex Williamson wrote:
> > On Fri,  1 Oct 2021 20:22:20 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > iommu_group_register_notifier()/iommu_group_unregister_notifier() are
> > > built using a blocking_notifier_chain which integrates a rwsem. The
> > > notifier function cannot be running outside its registration.
> > > 
> > > When considering how the notifier function interacts with create/destroy
> > > of the group there are two fringe cases, the notifier starts before
> > > list_add(&vfio.group_list) and the notifier runs after the kref
> > > becomes 0.
> > > 
> > > Prior to vfio_create_group() unlocking and returning we have
> > >    container_users == 0
> > >    device_list == empty
> > > And this cannot change until the mutex is unlocked.
> > > 
> > > After the kref goes to zero we must also have
> > >    container_users == 0
> > >    device_list == empty
> > > 
> > > Both are required because they are balanced operations and a 0 kref means
> > > some caller became unbalanced. Add the missing assertion that
> > > container_users must be zero as well.
> > > 
> > > These two facts are important because when checking each operation we see:
> > > 
> > > - IOMMU_GROUP_NOTIFY_ADD_DEVICE
> > >    Empty device_list avoids the WARN_ON in vfio_group_nb_add_dev()
> > >    0 container_users ends the call
> > > - IOMMU_GROUP_NOTIFY_BOUND_DRIVER
> > >    0 container_users ends the call
> > > 
> > > Finally, we have IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER, which only deletes
> > > items from the unbound list. During creation this list is empty, during
> > > kref == 0 nothing can read this list, and it will be freed soon.
> > > 
> > > Since the vfio_group_release() doesn't hold the appropriate lock to
> > > manipulate the unbound_list and could race with the notifier, move the
> > > cleanup to directly before the kfree.
> > > 
> > > This allows deleting all of the deferred group put code.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >  drivers/vfio/vfio.c | 89 +++++----------------------------------------
> > >  1 file changed, 9 insertions(+), 80 deletions(-)
> > > 
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index 08b27b64f0f935..32a53cb3598524 100644
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -324,12 +324,20 @@ static void vfio_container_put(struct vfio_container *container)
> > >  
> > >  static void vfio_group_unlock_and_free(struct vfio_group *group)
> > >  {
> > > +	struct vfio_unbound_dev *unbound, *tmp;
> > > +
> > >  	mutex_unlock(&vfio.group_lock);
> > >  	/*
> > >  	 * Unregister outside of lock.  A spurious callback is harmless now
> > >  	 * that the group is no longer in vfio.group_list.
> > >  	 */  
> > 
> > This comment is indirectly referencing the vfio_group_try_get() in the
> > notifier callback, but as you describe in the commit log, it's actually
> > the container_users value that prevents this from racing group release
> > now.  Otherwise, tricky but looks good.  Thanks,  
> 
> Do you think the comment should be deleted in this commit? I think I
> got it later on..

I think the commit log argument is that notifies racing the group
release are harmless so long as the container is unused, and releasing
a group with active container users would be unbalanced, which
justifies the WARN_ON added here.  This comment does get removed in the
final patch, but maybe that logic can be noted in a comment by the new
sanity test.  Thanks,

Alex

