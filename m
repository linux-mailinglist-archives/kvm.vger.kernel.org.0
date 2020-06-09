Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627E71F467D
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 20:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgFISnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 14:43:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25168 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728410AbgFISnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 14:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591728186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vf8PHzuNillXcrshKZnMvhUbr01AvkSJx/g1gW7lrxE=;
        b=JAWISYliOeVTgw58ntPi50frCiBf/ZLgguxEVSkz2hbzJFZ60Is1/U6x6/qWnTMqhPYhZo
        lKU6QMDuXzSPKubO3U2wszG7KFfFpwaTb08xGYOTJCIXTgFsPyiG4+IBJpxfkaBXzEdywW
        7hnU9jFZ5c+8bCSoxLPVGWwrpIoOqpo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-6uMK5fPqNHGzGpCjq0y5Kg-1; Tue, 09 Jun 2020 14:43:05 -0400
X-MC-Unique: 6uMK5fPqNHGzGpCjq0y5Kg-1
Received: by mail-wr1-f71.google.com with SMTP id h6so9022111wrx.4
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 11:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vf8PHzuNillXcrshKZnMvhUbr01AvkSJx/g1gW7lrxE=;
        b=tfvHNy1QneZr+f8C3VlCaNOdj4/9+q7Xti9mfdjahxQwMmhRqRWQWCs1fFLbLAGZbI
         2N/EhMgCvLX9kZzY9uZWQvjDuyepiAoI2uEwO0CWpTBN03vE6K1C4RgTjj80v/huwhi6
         lglsgjLqMogKPSmGyQAaBZLouMy9xROKHD4fkdHBsGZxhguv9bemZI3rkvQ0Hu4byMUA
         sXiyWj5lckzlyWXJgtTQuJbHuPtltCSGZLOSXAxUIS2VE+1p5gH03Q5pyTi8GNnGfmjA
         eIuGdHXsdS6z4ScCD8/8Y1NenWYwx+vGRAVQLFIlorczQ02xeBKQkHbuYh2MczKDAbOX
         1UpA==
X-Gm-Message-State: AOAM532uVaI/WXR31fcf+2CiMMhGxuY58vzC+J2T0TgTjbw5MYaitrQK
        A3oywBCs+ZQ8K5ExdKNi+2VxRaOJyCsrkSuxzLIZceyZ6Ce4fI+3tWUxXmDpbU4SXOPbsgeP8qF
        VcCCNrbwn4xov
X-Received: by 2002:a5d:66c3:: with SMTP id k3mr5903846wrw.401.1591728184068;
        Tue, 09 Jun 2020 11:43:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+8yheFLe15jkh/whJhF8IZCGXLwbicq5R++ZbkjoDIltm0r8kDVYyfqOHATH0CeWfo6UFww==
X-Received: by 2002:a5d:66c3:: with SMTP id k3mr5903825wrw.401.1591728183863;
        Tue, 09 Jun 2020 11:43:03 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id v27sm4865849wrv.81.2020.06.09.11.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 11:43:03 -0700 (PDT)
Date:   Tue, 9 Jun 2020 14:42:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Juan Quintela <quintela@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH v3 00/20] virtio-mem: Paravirtualized memory hot(un)plug
Message-ID: <20200609144242-mutt-send-email-mst@kernel.org>
References: <20200603144914.41645-1-david@redhat.com>
 <20200609091034-mutt-send-email-mst@kernel.org>
 <08385823-d98f-fd9d-aa9d-bc1bd6747c29@redhat.com>
 <20200609115814-mutt-send-email-mst@kernel.org>
 <20200609161814.GJ2366737@habkost.net>
 <33021b38-cf60-fbfc-1baa-478ee6eed376@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33021b38-cf60-fbfc-1baa-478ee6eed376@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 09, 2020 at 08:38:15PM +0200, David Hildenbrand wrote:
> On 09.06.20 18:18, Eduardo Habkost wrote:
> > On Tue, Jun 09, 2020 at 11:59:04AM -0400, Michael S. Tsirkin wrote:
> >> On Tue, Jun 09, 2020 at 03:26:08PM +0200, David Hildenbrand wrote:
> >>> On 09.06.20 15:11, Michael S. Tsirkin wrote:
> >>>> On Wed, Jun 03, 2020 at 04:48:54PM +0200, David Hildenbrand wrote:
> >>>>> This is the very basic, initial version of virtio-mem. More info on
> >>>>> virtio-mem in general can be found in the Linux kernel driver v2 posting
> >>>>> [1] and in patch #10. The latest Linux driver v4 can be found at [2].
> >>>>>
> >>>>> This series is based on [3]:
> >>>>>     "[PATCH v1] pc: Support coldplugging of virtio-pmem-pci devices on all
> >>>>>      buses"
> >>>>>
> >>>>> The patches can be found at:
> >>>>>     https://github.com/davidhildenbrand/qemu.git virtio-mem-v3
> >>>>
> >>>> So given we tweaked the config space a bit, this needs a respin.
> >>>
> >>> Yeah, the virtio-mem-v4 branch already contains a fixed-up version. Will
> >>> send during the next days.
> >>
> >> BTW. People don't normally capitalize the letter after ":".
> >> So a better subject is
> >>   virtio-mem: paravirtualized memory hot(un)plug
> > 
> > I'm not sure that's still the rule:
> > 
> > [qemu/(49ee115552...)]$ git log --oneline v4.0.0.. | egrep ': [A-Z]' | wc -l
> > 5261
> > [qemu/(49ee115552...)]$ git log --oneline v4.0.0.. | egrep ': [a-z]' | wc -l
> > 2921
> > 
> 
> Yeah, I switched to this scheme some years ago (I even remember that
> some QEMU maintainer recommended it). I decided to just always
> capitalize. Not that it should really matter ... :)

Don't mind about qemu but you don't want to do that for Linux.

> -- 
> Thanks,
> 
> David / dhildenb

