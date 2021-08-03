Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714C13DF352
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 18:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhHCQwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 12:52:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237578AbhHCQwl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 12:52:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628009550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sKtEVRvHNGT42iZNHToUtsFsYwSj6OAOl6LkhSWUXzQ=;
        b=HLV1Uxh/gQiv/X+OpQ5B69XeaYIxGDambTtmAWr5ZJH2dj7N4Z4L/z7Yj1gnzZXn3i9R2B
        lG9R4VggXRkMLPa9N8Q+o0v1TrFDrBkrrRBzYDyC9aUjDb8L1xpFEdVO8QbrLGotDuWGEm
        O4cGC8S+awZQszOe82cNu04N+KI6Jbw=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-y1vEE1QhPTyqJualZCL6Gw-1; Tue, 03 Aug 2021 12:52:28 -0400
X-MC-Unique: y1vEE1QhPTyqJualZCL6Gw-1
Received: by mail-oi1-f199.google.com with SMTP id i16-20020a0568080310b029025cd3c0e2bdso8923915oie.1
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 09:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sKtEVRvHNGT42iZNHToUtsFsYwSj6OAOl6LkhSWUXzQ=;
        b=LnXfogOc+d3opM/JXWLPp22SsZ4zgeCtu48Bz6nspPixCbLHSKpSSps7qYhqkIqENL
         RbbwKzpufeLE8UkD3553HNG83S/ews28tC//FU0flj7Ym8uzMlCT8RXSqLx/9eWfRK4K
         sI/fkPtq1kwkUIJ7+SAI1XOUz5DbUuOVaYi5PlKnOauuyTVhppnh9g1T8F0eYJyQQK+Q
         ldgIF0WugfhCYae28s301SmXr9EtN1nnBarIFRhCJj3AaWxGaqFPcGnJYa8iROGTDft9
         emcq0ydi0yT3QVBzT9OC9wcnmi+A7MKHuBPLtRftvmqR6Z/xhsOEUJXKh8YQgx/AK3cG
         ucLg==
X-Gm-Message-State: AOAM532fnUl1RCYs79c/QGICAo3jwieAnGXGAZiEHMTVp8OFQLTH5x0+
        vFw0yq1aFLywu96830N0AFLVSn0kRl+woQCXb0O6aK0PELI/4WjAvKeD4NsF13MCj3mdM7wLLrP
        PqH2FqhzrUwFb
X-Received: by 2002:a9d:62d4:: with SMTP id z20mr16205603otk.305.1628009548259;
        Tue, 03 Aug 2021 09:52:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvKOEKD8L0w37wO357XcF+/U3bT3CXb+wzZAe9sXlApc1eVkv2cU2JtkoR7Kvj984JI4QXhg==
X-Received: by 2002:a9d:62d4:: with SMTP id z20mr16205581otk.305.1628009548040;
        Tue, 03 Aug 2021 09:52:28 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id bd20sm2365330oib.1.2021.08.03.09.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:52:27 -0700 (PDT)
Date:   Tue, 3 Aug 2021 10:52:25 -0600
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
Message-ID: <20210803105225.2ee7dac2.alex.williamson@redhat.com>
In-Reply-To: <20210803164152.GC1721383@nvidia.com>
References: <0-v3-6c9e19cc7d44+15613-vfio_reflck_jgg@nvidia.com>
        <9-v3-6c9e19cc7d44+15613-vfio_reflck_jgg@nvidia.com>
        <20210803103406.5e1be269.alex.williamson@redhat.com>
        <20210803164152.GC1721383@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 3 Aug 2021 13:41:52 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> On Tue, Aug 03, 2021 at 10:34:06AM -0600, Alex Williamson wrote:
> > I think the vfio_pci_find_reset_target() function needs to be re-worked
> > to just tell us true/false that it's ok to reset the provided device,
> > not to anoint an arbitrary target device.  Thanks,  
> 
> Yes, though this logic is confusing, why do we need to check if any
> device needs a reset at this point? If we are being asked to reset
> vdev shouldn't vdev needs_reset?
> 
> Or is the function more of a 'synchronize pending reset' kind of
> thing?

Yes, the latter.  For instance think about a multi-function PCI device
such as a GPU.  The functions have dramatically different capabilities,
some might have function level reset abilities and others not.  We want
to be able to trigger a bus reset as the last device of the set is
released, no matter the order they're released and no matter the
capabilities of the device we're currently processing.  Thanks,

Alex

