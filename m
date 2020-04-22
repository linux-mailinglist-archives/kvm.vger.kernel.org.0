Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DC81B4F4B
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 23:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDVVYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 17:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgDVVYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 17:24:24 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EFDC03C1AB
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 14:24:24 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id r16so2708555edw.5
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 14:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yRWrSisQQpY8wbjXn0iTmjToXXRth4qPvwTQ6Ad/CXE=;
        b=hRjZLZSP41fQmWqXoFu0uMVGr5+fbRGYYJ7JqVPFOLUI80SYtPgeBODoIP+jTzQE0A
         LvwfljRzDnz0pqQ8XV/j4e65bWWxGRzcX9aqxFcYUyvsohgV9Mseeh1CoXzpmmoMqLm2
         PZkr5FTjKeb2qsVvQ5ZZJ9tk212oX/dPiVnZid1lZ8QYGUa485x/l8p+YzNSfl0cfUCF
         UeksZGJll/cGu9FFxsvnhBJGh9020ED/FIg5bq4nehIIxxUZrzvqFOc4x6/cDEaKq2uo
         +eh7FmdGU69lMG24JYdqoMzep30dL/8nqK0gRu/ucI4iEQH2ICs8GXLYOaI5YdWaMtKV
         G0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yRWrSisQQpY8wbjXn0iTmjToXXRth4qPvwTQ6Ad/CXE=;
        b=bs5JTUxcf5FjI+zPicSRGbpk7BmHjsgMSKggwGdHoJloOn4/TWA6N4pNiATVYnA5qS
         ZdV6EawpXxHhgU3VGxO4tdRGevF1CTwm4CjvpXY2k1kfjIuqhwQ5Jatb5dNwRvhs+KEQ
         C1wYD0yZO2ZbOPCwXUur1Agvit28TBo9ttOhF3cMuQgLujnsjuGMBineuC0K9Gifh7/e
         w/sNLJxEEssCmhUsD96ZtYOgA3Sk/GQYJSgsWhcrNL1BQ72ii42p/Otdp04xq9gx132D
         2S6d62MZ9OFqVhmHQzgHyCK++anboLDT+FI3bv190V+NccEsl9krdpCb1omRFskBHR+q
         A6HQ==
X-Gm-Message-State: AGi0PuaQR07VXgJqbwa6/aoRKmxmDU+25KG9b8QPIabfXTkAY74TcftR
        qlBJzyK+A5I0WzDv2ARU2sLt1XbP8Gh4DnERQZVJcQ==
X-Google-Smtp-Source: APiQypLVYeI+Z6fHZ231GXhNbP4EWDKpwlzMUtpHq46K+PNczHL9Qp9bLLshWMcSOuHvG1MKEBrYyZ6kugSSMSxZ3ko=
X-Received: by 2002:a50:ee86:: with SMTP id f6mr498361edr.123.1587590662775;
 Wed, 22 Apr 2020 14:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
In-Reply-To: <20200421235442.GO11945@mellanox.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 22 Apr 2020 14:24:11 -0700
Message-ID: <CAPcyv4gMYz1wCYjfnujyGXP0jGehpb+dEYV7hJoAAsDsj9+afQ@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>,
        Megha Dey <megha.dey@linux.intel.com>, maz@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Yi L Liu <yi.l.liu@intel.com>,
        baolu.lu@intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jing Lin <jing.lin@intel.com>,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, linux-pci@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 4:55 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Tue, Apr 21, 2020 at 04:33:46PM -0700, Dave Jiang wrote:
> > The actual code is independent of the stage 2 driver code submission that adds
> > support for SVM, ENQCMD(S), PASID, and shared workqueues. This code series will
> > support dedicated workqueue on a guest with no vIOMMU.
> >
> > A new device type "mdev" is introduced for the idxd driver. This allows the wq
> > to be dedicated to the usage of a VFIO mediated device (mdev). Once the work
> > queue (wq) is enabled, an uuid generated by the user can be added to the wq
> > through the uuid sysfs attribute for the wq.  After the association, a mdev can
> > be created using this UUID. The mdev driver code will associate the uuid and
> > setup the mdev on the driver side. When the create operation is successful, the
> > uuid can be passed to qemu. When the guest boots up, it should discover a DSA
> > device when doing PCI discovery.
>
> I'm feeling really skeptical that adding all this PCI config space and
> MMIO BAR emulation to the kernel just to cram this into a VFIO
> interface is a good idea, that kind of stuff is much safer in
> userspace.
>
> Particularly since vfio is not really needed once a driver is using
> the PASID stuff. We already have general code for drivers to use to
> attach a PASID to a mm_struct - and using vfio while disabling all the
> DMA/iommu config really seems like an abuse.
>
> A /dev/idxd char dev that mmaps a bar page and links it to a PASID
> seems a lot simpler and saner kernel wise.
>
> > The mdev utilizes Interrupt Message Store or IMS[3] instead of MSIX for
> > interrupts for the guest. This preserves MSIX for host usages and also allows a
> > significantly larger number of interrupt vectors for guest usage.
>
> I never did get a reply to my earlier remarks on the IMS patches.
>
> The concept of a device specific addr/data table format for MSI is not
> Intel specific. This should be general code. We have a device that can
> use this kind of kernel capability today.

This has been my concern reviewing the implementation. IMS needs more
than one in-tree user to validate degrees of freedom in the api. I had
been missing a second "in-tree user" to validate the scope of the
flexibility that was needed.
