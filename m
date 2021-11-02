Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4732144371E
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 21:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhKBUSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 16:18:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230060AbhKBUSo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 16:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635884169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xrr7Nswb1zSUeN/enXyBsdfTuUeQZHbFjkSfA/cUnkk=;
        b=KZ3Gp2Q8RzUjiXzTvazlnIwkr/TRkP4OXZceUjLZQ1VzWEfAV2aPE+Ch+ol43gokqlxu6Y
        Vh3CWM218Rz0/uA4a5+faNl/jMgx9eJfb63/hDysaHiViJ/ytpuj11pphREjFyZWM3UhLG
        SVcVjoxJdbYaknb1A3lZ82V6k/GVFTY=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-_bYrVKfNMu6xOxicOqoQqA-1; Tue, 02 Nov 2021 16:15:50 -0400
X-MC-Unique: _bYrVKfNMu6xOxicOqoQqA-1
Received: by mail-ot1-f71.google.com with SMTP id l71-20020a9d1b4d000000b00553d78fb5c3so177816otl.16
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 13:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xrr7Nswb1zSUeN/enXyBsdfTuUeQZHbFjkSfA/cUnkk=;
        b=ucxKLi+MW/TQblg5vbVBdhsIcDeKPtqat974wgYeDPyZXQ8tZYCCvRDDzGb+8XOCMe
         jC1sFnXGkiHGHvjq3hUsRtNbtlamtkDbFlrJIFTKNpj4iCxB2Npi3M16+xaJbGXKQuIF
         4v+9gkN73WAxB4a/LDDbneqEa3Z2puymq66mbRAQzccBwFMyrJITrIb/f/pHpHTKLLhs
         ndNVrI3x6hNZPm9NjEEKSSPbtCcCBru4BqH7CDWropHgGLqzMVhyvjr1+xCdqFK0nbrG
         FKhWCmBvja+rwav9o/qvsITWWwKxbzByNx8OyZxWayaZoHz1/2rqFjfWuXK0d7UVDXns
         9ShQ==
X-Gm-Message-State: AOAM532dqIaGfyKKM4AxFk1g59WmyOJiqyvTbaXjgnpNBon1Wyg858f1
        JsrSZM5G++AOjILPhkt1Epstj8nGBiR8I0OTOwFz4AB2z52m/7b3QgEhZySPhD7SUEvdVN54euj
        eKDZuU4t06AaC
X-Received: by 2002:aca:502:: with SMTP id 2mr6911481oif.121.1635884150177;
        Tue, 02 Nov 2021 13:15:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB1YIom/qnGCnU3mQ5wd7qinnolUIYz9BC2zuiV9Oo21uixIulObHuoTWjbBeBw4sEtvoYGg==
X-Received: by 2002:aca:502:: with SMTP id 2mr6911462oif.121.1635884149950;
        Tue, 02 Nov 2021 13:15:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m16sm1632822oiw.13.2021.11.02.13.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 13:15:49 -0700 (PDT)
Date:   Tue, 2 Nov 2021 14:15:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
In-Reply-To: <20211102163610.GG2744544@nvidia.com>
References: <20211026234300.GA2744544@nvidia.com>
        <20211027130520.33652a49.alex.williamson@redhat.com>
        <20211027192345.GJ2744544@nvidia.com>
        <20211028093035.17ecbc5d.alex.williamson@redhat.com>
        <20211028234750.GP2744544@nvidia.com>
        <20211029160621.46ca7b54.alex.williamson@redhat.com>
        <20211101172506.GC2744544@nvidia.com>
        <20211102085651.28e0203c.alex.williamson@redhat.com>
        <20211102155420.GK2744544@nvidia.com>
        <20211102102236.711dc6b5.alex.williamson@redhat.com>
        <20211102163610.GG2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Nov 2021 13:36:10 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 02, 2021 at 10:22:36AM -0600, Alex Williamson wrote:
> 
> > > > There's no point at which we can do SET_IRQS other than in the
> > > > _RESUMING state.  Generally SET_IRQS ioctls are coordinated with the
> > > > guest driver based on actions to the device, we can't be mucking
> > > > with IRQs while the device is presumed running and already
> > > > generating interrupt conditions.    
> > > 
> > > We need to do it in state 000
> > > 
> > > ie resume should go 
> > > 
> > >   000 -> 100 -> 000 -> 001
> > > 
> > > With SET_IRQS and any other fixing done during the 2nd 000, after the
> > > migration data has been loaded into the device.  
> > 
> > Again, this is not how QEMU works today.  
> 
> I know, I think it is a poor choice to carve out certain changes to
> the device that must be preserved across loading the migration state.
> 
> > > The uAPI comment does not define when to do the SET_IRQS, it seems
> > > this has been missed.
> > > 
> > > We really should fix it, unless you feel strongly that the
> > > experimental API in qemu shouldn't be changed.  
> > 
> > I think the QEMU implementation fills in some details of how the uAPI
> > is expected to work.  
> 
> Well, we already know QEMU has problems, like the P2P thing. Is this a
> bug, or a preferred limitation as designed?
> 
> > MSI/X is expected to be restored while _RESUMING based on the
> > config space of the device, there is no intermediate step between
> > _RESUMING and _RUNNING.  Introducing such a requirement precludes
> > the option of a post-copy implementation of (_RESUMING | _RUNNING).  
> 
> Not precluded, a new state bit would be required to implement some
> future post-copy.
> 
> 0000 -> 1100 -> 1000 -> 1001 -> 0001
> 
> Instead of overloading the meaning of RUNNING.
> 
> I think this is cleaner anyhow.
> 
> (though I don't know how we'd structure the save side to get two
> bitstreams)

The way this is supposed to work is that the device migration stream
contains the device internal state.  QEMU is then responsible for
restoring the external state of the device, including the DMA mappings,
interrupts, and config space.  It's not possible for the migration
driver to reestablish these things.  So there is a necessary division
of device state between QEMU and the migration driver.

If we don't think the uAPI includes the necessary states, doesn't
sufficiently define the states, and we're not following the existing
QEMU implementation as the guide for the intentions of the uAPI spec,
then what exactly is the proposed mlx5 migration driver implementing
and why would we even considering including it at this point?  Thanks,

Alex

