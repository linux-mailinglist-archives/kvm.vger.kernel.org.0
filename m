Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C6044A981
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 09:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbhKIIpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 03:45:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244412AbhKIIpO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 03:45:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636447348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MHGz9qB9KZ6d5aSM8uWpr6oUTvZTjYEMw5MVGjpWcAI=;
        b=f6uzprKxVxJxPrcQ4uKZy3Sxm8rWNcgVCIIhhABufcvOmd+FFh9ePFpVPrUae1XDpwlAfF
        WY/JR/yFisBY6q7Y7E/VntfugdqzVxOCFpf9PCb2AtZY75I6bxXGH6RiO+3tbZ8qXX84ly
        1sQzI55H9m8PLt3lraiwiJvLeA2pSt8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-EHDm_UX8PLOS5jo7O-nmVw-1; Tue, 09 Nov 2021 03:42:27 -0500
X-MC-Unique: EHDm_UX8PLOS5jo7O-nmVw-1
Received: by mail-ed1-f72.google.com with SMTP id o15-20020a056402438f00b003e32b274b24so6765577edc.21
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 00:42:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MHGz9qB9KZ6d5aSM8uWpr6oUTvZTjYEMw5MVGjpWcAI=;
        b=ddV4BRGTSIMmX22Yk06pfN0Nou8p02RAVR/7QMBnKPWCKdVXtTCkvKyzyJoY4iQUHQ
         amuE9Ss0RVBaBFHBwPkdXS57ZyqrVgyYXjYrnCqAdtbnmjl9f+hLk1qecUrLF5TDcyz5
         wPgBVe8a1eq8Xm0NAK+nU8SfDUQ3X608mUm3Lr4Jz/KB3tNyOLfkCFIgGlUXCghx2Aqm
         9G0K6mnYk6XvJ2HgvzxMf1Ny/38p3A5J0XhuZo1Td0dUwNw0BZbeG0Tc5mtlaBxofw2u
         gIL/RNr9RQoqVkf33NPeEDQ1LBQxx1FO3MNfVC5ss4iJqoZrmfdPec1+LviNcy9+9KD2
         712Q==
X-Gm-Message-State: AOAM533G0DQn2rtLxw+K1tRZfen4ht/XyXWe3T9/7fDUiN62yYnun3hk
        yIVPlxyDP+9xS9qW2ySx9nK7uq8UBp5z39eLfirLhuv1GV91Yj6e+rw1AOlNz/dKTgScMeR650+
        DI43Pm871/81v
X-Received: by 2002:a17:907:97c3:: with SMTP id js3mr7450401ejc.240.1636447346535;
        Tue, 09 Nov 2021 00:42:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5kr1i49fwP2cIF+kBQpqsBzqWFlC8eop7E4baN/U3y//HbSwZxN+f2v/sBTdDmWyxulFWWQ==
X-Received: by 2002:a17:907:97c3:: with SMTP id js3mr7450378ejc.240.1636447346303;
        Tue, 09 Nov 2021 00:42:26 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id ho17sm9214038ejc.111.2021.11.09.00.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 00:42:25 -0800 (PST)
Date:   Tue, 9 Nov 2021 09:42:24 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 6/7] s390x: virtio tests setup
Message-ID: <20211109084224.t4yenupsb7z4diqg@gator.home>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-7-git-send-email-pmorel@linux.ibm.com>
 <20211103075636.hgxckmxs62bsdrha@gator.home>
 <c977b200-ba2d-d3eb-eae0-75a17d16496d@redhat.com>
 <4d85f61a-818c-4f72-6488-9ae2b21ad90a@linux.ibm.com>
 <f5aa60d6-6e9b-e64c-9f6a-9e6bdfc21d32@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f5aa60d6-6e9b-e64c-9f6a-9e6bdfc21d32@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 09, 2021 at 08:10:34AM +0100, Thomas Huth wrote:
> On 08/11/2021 14.00, Pierre Morel wrote:
> > 
> > 
> > On 11/3/21 09:14, Thomas Huth wrote:
> > > On 03/11/2021 08.56, Andrew Jones wrote:
> > > > On Fri, Aug 27, 2021 at 12:17:19PM +0200, Pierre Morel wrote:
> > > > > +
> > > > > +#define VIRTIO_ID_PONG         30 /* virtio pong */
> > > > 
> > > > I take it this is a virtio test device that ping-pong's I/O. It sounds
> > > > useful for other VIRTIO transports too. Can it be ported? Hmm, I can't
> > > > find it in QEMU at all?
> > > 
> > > I also wonder whether we could do testing with an existing device
> > > instead? E.g. do a loopback with a virtio-serial device? Or use two
> > > virtio-net devices, connect them to a QEMU hub and send a packet
> > > from one device to the other? ... that would be a little bit more
> > > complicated here, but would not require a PONG device upstream
> > > first, so it could also be used for testing older versions of
> > > QEMU...
> > > 
> > >   Thomas
> > > 
> > > 
> > 
> > Yes having a dedicated device has the drawback that we need it in QEMU.
> > On the other hand using a specific device, serial or network, wouldn't
> > we get trapped with a reduce set of test possibilities?
> > 
> > The idea was to have a dedicated test device, which could be flexible
> > and extended to test all VIRTIO features, even the current
> > implementation is yet far from it.
> 
> Do you have anything in the works that could only be tested with a dedicated
> test device? If not, I'd rather go with the loopback via virtio-net, I think
> (you can peek into the s390-ccw bios sources to see how to send packets via
> virtio-net, shouldn't be too hard to do, I think).
> 
> The pong device could later be added on top for additional tests that are
> not possible with virtio-net. And having some basic tests with virito-net
> has also the advantage that the k-u-t work with QEMU binaries where the pong
> device is not available, e.g. older versions and downstream versions that
> only enable the bare minimum of devices to keep the attack surface small.
>

I'd also like to see the testdev we already have, qemu:chardev/testdev.c,
get more functions, but I'm not sure virtio-serial will allow you to
exercise all the virtio functionality that you'd like to.

Thanks,
drew

