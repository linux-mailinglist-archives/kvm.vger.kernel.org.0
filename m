Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82E44465D5
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 16:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhKEPed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 11:34:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233491AbhKEPeb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 11:34:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636126311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2q9UM1dsA5qC0O1FuuqgkXUxTdQPegLyYQWeu0X9Bo=;
        b=gqxzl5jsOX7mvwHRzbhLV86zhFLfyxaU8muOuc7yp10yojmpVFTLgz++DpfdhSCWs7FRae
        8BuwgOz32teiSKeKKQcG9bQ/pve6PxWKySCA0a2rU/iHfxvRNz2PRJUG44hG6XXkUceoCu
        SIHiQ5siHiXe/EmOP/ucF9bqoDsZNSE=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-4yPyaKnxP7yATYioVyilNw-1; Fri, 05 Nov 2021 11:31:50 -0400
X-MC-Unique: 4yPyaKnxP7yATYioVyilNw-1
Received: by mail-oi1-f199.google.com with SMTP id t185-20020aca5fc2000000b0029a210e5f5fso5599137oib.4
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 08:31:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=p2q9UM1dsA5qC0O1FuuqgkXUxTdQPegLyYQWeu0X9Bo=;
        b=czBOJ9EJOUtNS1pJ6DmFiTClq8Hm3axyAoXafT7cZWzYBs+YMAHnOZYqYyZjAkCmJ8
         J6RX7wWKxWXic8PSxLd3plDyC6LV1aaCiE9BZp5/0njeMv5hvIq+J4AyIaa1aU+Q82iQ
         VzzH0XLz3xfqRCH9gdPlMOZY0v32zj0/+dVANH5XeQMkj5cK2pIQNe5uBvFIxxy3BBe1
         8Y8MdxyIVhjWr3ZnsLPGqep/E66Di8fhpPK8jyiAvCqh5eiMlbWT26NEYUZWv9o3AUr7
         WOvyH39q5x5r0E42S/BElGV1SdhON/qhOKhlwEujRwiVgqEYUO4KYOiw89uCfBnjQ8zS
         fP1A==
X-Gm-Message-State: AOAM532r/foGqiL+WzoOy/X/lrOuSWfIAZj9DOdyeKu+ji3HpN29os4C
        RT+OvaiSGRhG+rRK09Ae3MJeC0xUkB0mNjFXzGmxF0baiMls+pbTJ6QXOHdiCXKVJHMvOG6tsyX
        dLoxaquUYvYwY
X-Received: by 2002:a4a:e292:: with SMTP id k18mr9139842oot.80.1636126308397;
        Fri, 05 Nov 2021 08:31:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVEInbc75Y3LCubkblFBRMORDE/ivxtJ5MuMKJkZQtmvnKRCCXkf8ANzvXtI/oswj20vkxWg==
X-Received: by 2002:a4a:e292:: with SMTP id k18mr9139807oot.80.1636126308113;
        Fri, 05 Nov 2021 08:31:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r10sm422381otv.3.2021.11.05.08.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:31:47 -0700 (PDT)
Date:   Fri, 5 Nov 2021 09:31:45 -0600
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
Message-ID: <20211105093145.386d0e89.alex.williamson@redhat.com>
In-Reply-To: <20211105132404.GB2744544@nvidia.com>
References: <20211101172506.GC2744544@nvidia.com>
        <20211102085651.28e0203c.alex.williamson@redhat.com>
        <20211102155420.GK2744544@nvidia.com>
        <20211102102236.711dc6b5.alex.williamson@redhat.com>
        <20211102163610.GG2744544@nvidia.com>
        <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
        <20211103120955.GK2744544@nvidia.com>
        <20211103094409.3ea180ab.alex.williamson@redhat.com>
        <20211103161019.GR2744544@nvidia.com>
        <20211103120411.3a470501.alex.williamson@redhat.com>
        <20211105132404.GB2744544@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Nov 2021 10:24:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Nov 03, 2021 at 12:04:11PM -0600, Alex Williamson wrote:
> 
> > We agreed that it's easier to add a feature than a restriction in a
> > uAPI, so how do we resolve that some future device may require a new
> > state in order to apply the SET_IRQS configuration?  
> 
> I would say don't support those devices. If there is even a hint that
> they could maybe exist then we should fix it now. Once the uapi is set
> and documented we should expect device makers to consider it when
> building their devices.
> 
> As for SET_IRQs, I have been looking at making documentation and I
> don't like the way the documentation has to be wrriten because of
> this.
> 
> What I see as an understandable, clear, documentation is:
> 
>  - SAVING set - no device touches allowed beyond migration operations
>    and reset via XX

I'd suggest defining reset via ioctl only.

>    Must be set with !RUNNING

Not sure what this means.  Pre-copy requires SAVING and RUNNING
together, is this only suggesting that to get the final device state we
need to do so in a !RUNNING state?

>  - RESUMING set - same as SAVING

I take it then that we're defining a new protocol if we can't do
SET_IRQS here.

>  - RUNNING cleared - limited device touches in this list: SET_IRQs, XX
>    config, XX.
>    Device may assume no touches outside the above. (ie no MMIO)
>    Implies NDMA

SET_IRQS is MMIO, is the distinction userspace vs kernel?

>  - NDMA set - full device touches
>    Device may not issue DMA or interrupts (??)
>    Device may not dirty pages

Is this achievable?  We can't bound the time where incoming DMA is
possible, devices don't have infinite buffers.

>  - RUNNING set - full functionality
>  * In no state may a device generate an error TLP, device
>    hang/integrity failure or kernel intergity failure, no matter
>    what userspace does.
>    The device is permitted to corrupt the migration/VM or SEGV
>    userspace if userspace doesn't follow the rules.
> 
> (we are trying to figure out what the XX's are right now, would
> appreciate any help)
> 
> This is something I think we could expect a HW engineering team to
> follow and implement in devices. It doesn't complicate things.
> 
> Overall, at this moment, I would prioritize documentation clarity over
> strict compatability with qemu, because people have to follow this
> documentation and make their devices long into the future. If the
> documentation is convoluted for compatibility reasons HW people are
> more likely to get it wrong. When HW people get it wrong they are more
> likely to ask for "quirks" in the uAPI to fix their mistakes.

I might still suggest a v2 migration sub-type, we'll just immediately
deprecate the original as we have no users and QEMU would modify all
support to find only the new sub-type as code is updated.  "v1" never
really materialized, but we can avoid future confusion if it's never
produced by in-tree drivers and never consume by mainstream userspace.

> The pending_bytes P2P idea is also quite complicated to document as
> now we have to describe an HW state not in terms of a NDMA control
> bit, but in terms of a bunch of implicit operations in a protocol. Not
> so nice.
> 
> So, here is what I propose. Let us work on some documentation and come
> up with the sort of HW centric docs like above and we can then decide
> if we want to make the qemu changes it will imply, or not. We'll
> include the P2P stuff, as we see it, so it shows a whole picture.
> 
> I think that will help everyone participate fully in the discussion.

Good plan.

> > If we're going to move forward with the existing uAPI, then we're going
> > to need to start factoring compatibility into our discussions of
> > missing states and protocols.  For example, requiring that the device
> > is "quiesced" when the _RUNNING bit is cleared and "frozen" when
> > pending_bytes is read has certain compatibility advantages versus
> > defining a new state bit.   
> 
> Not entirely, to support P2P going from RESUMING directly to RUNNING
> is not possible. There must be an in between state that all devices
> reach before they go to RUNNING. It seems P2P cannot be bolted into
> the existing qmeu flow with a kernel only change?

Perhaps, yes.

> > clarifications were trying for within the existing uAPI rather than
> > toss out new device states and protocols at every turn for the sake of
> > API purity.  The rate at which we're proposing new states and required
> > transitions without a plan for the uAPI is not where I want to be for
> > adding the driver that could lock us in to a supported uAPI.  Thanks,  
> 
> Well, to be fair, the other cases I suggested new stats was when you
> asked about features we don't have at all today (like post-copy). I
> think adding new states is a very reasonable way to approach adding
> new features. As long as new features can be supported with new states
> we have a forward compatability story.

That has a viable upgrade path, I'm onboard with that.  A device that
imposes it can't do SET_IRQS while RESUMING when we have no required
state in between RESUMING and RUNNING are the sorts of issues that I'm
going to get hung up on.  I take it from the above that you're building
that state transition requirement into the uAPI now.  Thanks,

Alex

