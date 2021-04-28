Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9624936E005
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 21:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbhD1T7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 15:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhD1T7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 15:59:18 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1B2C061573
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:58:32 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id zg3so14817146ejb.8
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9AJYrARs9Sl87oKiIos6pzM55eu+L/9r0eoBPgHxqno=;
        b=KqP/zwr7kxOhbcAUPFn4IGSRB7c8f1/7FpyVUVi/SyqAIXYBmmOYbG3O1CG92RqW5A
         JyMYZfQi81ZjjGIHdt6wCumbEOMxM9StFed2hfgrFuEh/c/GwbasvgRjTnocMs4qEWG6
         Cb8wcfU3yUiwjfgM0aJu0bdIMxj/j25aySSq6Urk+ZAgcRdJN6JoyRwar4rZGxpPWAg5
         6uv6MqtEpM5EkT/y8X6WahrYdSTvKzjt0NYF9N7vl52WwQd90P5uhA5mpC3o6KtauD+5
         oHdoDES7e+8N/GwCs7Jcn1hZuqQ3P5UFaogmEEC+3C7M2LJy+JgX+R9Q5wcKI1ffJQwE
         p5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9AJYrARs9Sl87oKiIos6pzM55eu+L/9r0eoBPgHxqno=;
        b=iVPicQaj+HNH2pBphzpBqN0hER2C6su7U/BwbxmAOeVS/9KH9yBClPpHai7Pt7GOHa
         a9kk5GR3pKo0ILsTKabD0H2jWd/u/ZKx3Kyj2QsgK7Zt+5GY9xhoDvdxJFZrmBt1DdDl
         RN+tdtKX3PZTkBTaeaxjoCXt4o5MFRKo60937zK96eP6Lpj44tH7Jk4ZCICezNRJahBf
         6s2bZ7VdErIZ79QaF9YEwk/Es1hc5jDwpF2j5ILTk75Cdut8d2uCKdit7v3zPqa/OddQ
         OerJ6m8CpkXobWKljP9K9X3GKrrV0DUYs0LGf95R1J/I9idHyIFJ/Dxz8Yzq2qxGIo3y
         GT+A==
X-Gm-Message-State: AOAM532qtJBruSzS1NVjBFGeaWR7Wkzg72gYuH5sC7yFyE98D2fNOI69
        ZF+OT7zURXvTr2cjB5pSOnnlOgutD51mXcnLiw6iSA==
X-Google-Smtp-Source: ABdhPJwCC8HKO7BKBHVwmRwPwmHI6ZPLSZn8rM+pMH1C5BsvN2R864anttzIniVjaaFm5fQ9jbQQj6VgPC5LmpWRu2I=
X-Received: by 2002:a17:907:1183:: with SMTP id uz3mr12921910ejb.264.1619639911456;
 Wed, 28 Apr 2021 12:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060300.GA4092@lst.de> <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
 <20210428124153.GA28566@lst.de> <20210428140005.GS1370958@nvidia.com>
In-Reply-To: <20210428140005.GS1370958@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 28 Apr 2021 12:58:29 -0700
Message-ID: <CAPcyv4hnjX-HtoG08dPbPxJPeJyvnO-WaJosoY1aSRqm5oo14Q@mail.gmail.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>, dave.jiang@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 7:00 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Apr 28, 2021 at 02:41:53PM +0200, Christoph Hellwig wrote:
> > On Wed, Apr 28, 2021 at 12:56:21AM -0700, Dan Williams wrote:
> > > > I still think this going the wrong way.  Why can't we enhance the core
> > > > driver code with a version of device_bind_driver() that does call into
> > > > ->probe?  That probably seems like a better model for those existing
> > > > direct users of device_bind_driver or device_attach with a pre-set
> > > > ->drv anyway.
> > >
> > > Wouldn't that just be "export device_driver_attach()" so that drivers
> > > can implement their own custom bind implementation?
> >
> > That looks like it might be all that is needed.
>
> I thought about doing it like that, it is generally a good idea,
> however, if I add new API surface to the driver core I really want to
> get rid of device_bind_driver(), or at least most of its users.

I might be missing where you are going with this comment, but
device_driver_attach() isn't a drop-in replacement for
device_bind_driver(). So while I agree with you that it's a
significant escalation of the driver core API surface, I don't see why
it would be necessarily predicated on removing device_bind_driver()?

If this export prevented a new device_bind_driver() user, I think
that's a net positive, because device_bind_driver() seems an odd way
to implement bus code to me.

> I'm pretty sure Greg will ask for it too.

I think it's worth asking.

I have an ulterior motive / additional use case in mind here which is
the work-in-progress cleanup of the DSA driver. It uses the driver
model to assign an engine to different use cases via driver binding.
However, it currently has a custom bind implementation that does not
operate like a typical /sys/bus/$bus/drivers interface. If
device_driver_attach() was exported then some DSA compat code could
model the current way while also allowing a transition path to the
right way. As is I was telling Dave that the compat code would need to
be built-in because I don't think fixing a DSA device-model problem is
enough justification on its own to ask for a device_driver_attach()
export.

> So, I need a way to sequence that which doesn't mean I have to shelf
> the mdev stuff for ages while I try to get acks from lots of places.

Lets see if it can stand alone.
