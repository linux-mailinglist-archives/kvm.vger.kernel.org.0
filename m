Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED803B68C0
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 20:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhF1S6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 14:58:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233789AbhF1S6d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 14:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624906567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ECyZepa63nlv7FQfDjXLVtw4C+haeQFo0Jc6XzQeZsE=;
        b=dXUulOkOm/OOlyPp3gCcoPMPFSEWiP3s/jqIvQFNbAJ0PYQDpNe0pn/FlikZ3raF7WG+3e
        gCdBAQtP/LdxaNRzlNiexbMG6PV+L/jywtCMiTXlBaH2+8xPxGK7xkrO+MvhjZaowKrfNJ
        JhjewBVVyDYA1uP3ROUUqxWftdWMeQk=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-xU4g7A82Np2K7TsjBOmg1w-1; Mon, 28 Jun 2021 14:56:05 -0400
X-MC-Unique: xU4g7A82Np2K7TsjBOmg1w-1
Received: by mail-oi1-f197.google.com with SMTP id b18-20020acafd120000b029023d714b710fso6009154oii.4
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 11:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ECyZepa63nlv7FQfDjXLVtw4C+haeQFo0Jc6XzQeZsE=;
        b=gcLuDV+lyTLDEcpivw2iZx9e6ZvBnVEFRaXWRNI+6S0JctatNdB9mqDhbheT6RP/ti
         dF8lHJlvBaJ3AZ6Lh7a2OJ0j2Rrgy1EIyOOThBv8Mc0fJCylDk/rGS264AZJGZQdX4Lx
         XKOftiTLxUM6x8o7usOj3O/n/zHEkDeekg2/XWNQqwsvrttwh2wKRfiwXdMS1vYaeL/F
         BbFgpNdt5g1/nRCaM6qaTNyQevQtMh4qqcytcq+ZpHibbsJSDD834GU2+dR31E9pC5ul
         Ng6NA6VbioneK2e1JSI1/y/eCVhx/XFGOvk1EaYWtH0w+hW415SM2XNdsTYajR+Sy/Kq
         3+ng==
X-Gm-Message-State: AOAM532aJ6eZ616eG9WgsuTgGmJ9c9hheHjJdsibM28oHElZySfP2/Lv
        0T8Z+BfaY1Edw5E9kgeHdEOp3llr/Hfv6iXl5gWdBTBlO8erRlrWYBsz7TeED84tE4alowrH0Ka
        0BPUy63S+Z7MB
X-Received: by 2002:a4a:9644:: with SMTP id r4mr745809ooi.52.1624906564641;
        Mon, 28 Jun 2021 11:56:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+tWMyISY1yeEpZ9LNbIsGyIkCItlWIyGFb4Yoh05L8iUj6egVfko/ubXmKIYKG3lf81/DXQ==
X-Received: by 2002:a4a:9644:: with SMTP id r4mr745775ooi.52.1624906564120;
        Mon, 28 Jun 2021 11:56:04 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id u10sm3756394otj.75.2021.06.28.11.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 11:56:03 -0700 (PDT)
Date:   Mon, 28 Jun 2021 12:56:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>
Subject: Re: [PATCH] vfio/mtty: Enforce available_instances
Message-ID: <20210628125602.5b07388e.alex.williamson@redhat.com>
In-Reply-To: <ee949a98-6998-2032-eb17-00ef8b8d911c@nvidia.com>
References: <162465624894.3338367.12935940647049917981.stgit@omen>
        <ee949a98-6998-2032-eb17-00ef8b8d911c@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Jun 2021 23:19:54 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 6/26/2021 2:56 AM, Alex Williamson wrote:
> > The sample mtty mdev driver doesn't actually enforce the number of
> > device instances it claims are available.  Implement this properly.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> > Applies to vfio next branch + Jason's atomic conversion
> >   
> 
> 
> Does this need to be on top of Jason's patch?

Yes, see immediately above.

> Patch to use mdev_used_ports is reverted here, can it be changed from 
> mdev_devices_list to mdev_avail_ports atomic variable?

It doesn't revert Jason's change, it builds on it.  The patches could
we squashed, but there's no bug in Jason's patch that we're trying to
avoid exposing, so I don't see why we'd do that.

> Change here to use atomic variable looks good to me.
> 
> Reviewed by: Kirti Wankhede <kwankhede@nvidia.com>

Thanks!  It was Jason's patch[1] that converted to use an atomic
though, so I'm slightly confused if this R-b is for the patch below,
Jason's patch, or both.  Thanks,

Alex

[1]https://lore.kernel.org/kvm/0-v1-0bc56b362ca7+62-mtty_used_ports_jgg@nvidia.com/

> >   samples/vfio-mdev/mtty.c |   22 ++++++++++++++++------
> >   1 file changed, 16 insertions(+), 6 deletions(-)
> > 
> > diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> > index ffbaf07a17ea..8b26fecc4afe 100644
> > --- a/samples/vfio-mdev/mtty.c
> > +++ b/samples/vfio-mdev/mtty.c
> > @@ -144,7 +144,7 @@ struct mdev_state {
> >   	int nr_ports;
> >   };
> >   
> > -static atomic_t mdev_used_ports;
> > +static atomic_t mdev_avail_ports = ATOMIC_INIT(MAX_MTTYS);
> >   
> >   static const struct file_operations vd_fops = {
> >   	.owner          = THIS_MODULE,
> > @@ -707,11 +707,20 @@ static int mtty_probe(struct mdev_device *mdev)
> >   {
> >   	struct mdev_state *mdev_state;
> >   	int nr_ports = mdev_get_type_group_id(mdev) + 1;
> > +	int avail_ports = atomic_read(&mdev_avail_ports);
> >   	int ret;
> >   
> > +	do {
> > +		if (avail_ports < nr_ports)
> > +			return -ENOSPC;
> > +	} while (!atomic_try_cmpxchg(&mdev_avail_ports,
> > +				     &avail_ports, avail_ports - nr_ports));
> > +
> >   	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
> > -	if (mdev_state == NULL)
> > +	if (mdev_state == NULL) {
> > +		atomic_add(nr_ports, &mdev_avail_ports);
> >   		return -ENOMEM;
> > +	}
> >   
> >   	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mtty_dev_ops);
> >   
> > @@ -724,6 +733,7 @@ static int mtty_probe(struct mdev_device *mdev)
> >   
> >   	if (mdev_state->vconfig == NULL) {
> >   		kfree(mdev_state);
> > +		atomic_add(nr_ports, &mdev_avail_ports);
> >   		return -ENOMEM;
> >   	}
> >   
> > @@ -735,9 +745,9 @@ static int mtty_probe(struct mdev_device *mdev)
> >   	ret = vfio_register_group_dev(&mdev_state->vdev);
> >   	if (ret) {
> >   		kfree(mdev_state);
> > +		atomic_add(nr_ports, &mdev_avail_ports);
> >   		return ret;
> >   	}
> > -	atomic_add(mdev_state->nr_ports, &mdev_used_ports);
> >   
> >   	dev_set_drvdata(&mdev->dev, mdev_state);
> >   	return 0;
> > @@ -746,12 +756,13 @@ static int mtty_probe(struct mdev_device *mdev)
> >   static void mtty_remove(struct mdev_device *mdev)
> >   {
> >   	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
> > +	int nr_ports = mdev_state->nr_ports;
> >   
> > -	atomic_sub(mdev_state->nr_ports, &mdev_used_ports);
> >   	vfio_unregister_group_dev(&mdev_state->vdev);
> >   
> >   	kfree(mdev_state->vconfig);
> >   	kfree(mdev_state);
> > +	atomic_add(nr_ports, &mdev_avail_ports);
> >   }
> >   
> >   static int mtty_reset(struct mdev_state *mdev_state)
> > @@ -1271,8 +1282,7 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
> >   {
> >   	unsigned int ports = mtype_get_type_group_id(mtype) + 1;
> >   
> > -	return sprintf(buf, "%d\n",
> > -		       (MAX_MTTYS - atomic_read(&mdev_used_ports)) / ports);
> > +	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) / ports);
> >   }
> >   
> >   static MDEV_TYPE_ATTR_RO(available_instances);
> > 
> >   
> 

