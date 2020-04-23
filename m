Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB5A1B645F
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgDWTSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbgDWTSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:18:03 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519C0C09B043
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 12:18:03 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id s10so5228665edy.9
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 12:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/h4lvV44/Iml02qdfcRqvKqVBnvX1oON2s+bwNOj3Oo=;
        b=YxC+xU+Y09HjuMPpDqSN8CmD+5az8mm18RjCYhdM+XS1opbZIxIdq1ASW+uaksEq8N
         YWVDSquZ2oZHTD3rMx/Fv3LiF9M0sbNrAonePEQmO2tHF47R3Jhw3JWt2x4yariAkye/
         IeehzJLzL1tqzVZEY2W8ZhRc4R7ikPb4Pb1wGUqxsHISy4z/JSxkyRtFkM6xb+oUtO2C
         pthvnMpLyZ9WGuSsoMb92OWHMOTcvKIULmBfQbOrnoKDbj8+UxFk5eI5vWua9URK+L2G
         xRhMUseF/UJd5gRu5uRL7SSGBKYByz6SuJTU22ym9LoQk17TNjwh628AYdpe7Y9tHob+
         9aJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/h4lvV44/Iml02qdfcRqvKqVBnvX1oON2s+bwNOj3Oo=;
        b=gp3boW84Yepcu6BIzsxd2k/qHZ3TKSiwkMOda//G5Syb4YF+QXHrfLyCwN3EwuhfV3
         LxqxNGCA8VRuNjBuPcGLxIKgMTv0hOk/YWJWKoRB0riGZ5OWBwREnps/CyR7bOZR36Lw
         P7+qRAv/Q7VyCQ44UH6JvOypdYzPNz73lkAkd896dBGPeUel9Tshv8yCJLqmf7KftTr/
         nY4lHn31WRTSwbdA1IAPKTILwVXuD6UxqparElSamYMcsf8nqMWmmHT8d1izA8Mlp3GJ
         ZiCxB0gbsIp+3ZugECnElCCWYSbOK8NPTQTsgiTQHDnYlii6x1ZaKf34L1r3GgGblA8t
         LYQQ==
X-Gm-Message-State: AGi0PuZ7JbTfQwSeJKP0tNb922J+lUMjccOgHHfRtOv4X9CdYK15301R
        kqwZ/tb4aLH4E8SKjStk2vxh6XeOAk2zfCZgQUturw==
X-Google-Smtp-Source: APiQypI/4D2YirCYc3DUz0CGmmliPsbx0RRBIxDVM1yWhfW6KgB5BSKeHuQ7eaLSQpFtFnAICO8Y40PFFCmvV+mX2z8=
X-Received: by 2002:a50:c3c2:: with SMTP id i2mr3938739edf.93.1587669481894;
 Thu, 23 Apr 2020 12:18:01 -0700 (PDT)
MIME-Version: 1.0
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com> <CAPcyv4gMYz1wCYjfnujyGXP0jGehpb+dEYV7hJoAAsDsj9+afQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gMYz1wCYjfnujyGXP0jGehpb+dEYV7hJoAAsDsj9+afQ@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 23 Apr 2020 12:17:50 -0700
Message-ID: <CAPcyv4hGX5jCzag8oQVUZ6Eq9GvZYLN_6kmBAgQMbrBbNzJ0yg@mail.gmail.com>
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
        Baolu Lu <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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

On Wed, Apr 22, 2020 at 2:24 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Tue, Apr 21, 2020 at 4:55 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
> >
> > On Tue, Apr 21, 2020 at 04:33:46PM -0700, Dave Jiang wrote:
> > > The actual code is independent of the stage 2 driver code submission that adds
> > > support for SVM, ENQCMD(S), PASID, and shared workqueues. This code series will
> > > support dedicated workqueue on a guest with no vIOMMU.
> > >
> > > A new device type "mdev" is introduced for the idxd driver. This allows the wq
> > > to be dedicated to the usage of a VFIO mediated device (mdev). Once the work
> > > queue (wq) is enabled, an uuid generated by the user can be added to the wq
> > > through the uuid sysfs attribute for the wq.  After the association, a mdev can
> > > be created using this UUID. The mdev driver code will associate the uuid and
> > > setup the mdev on the driver side. When the create operation is successful, the
> > > uuid can be passed to qemu. When the guest boots up, it should discover a DSA
> > > device when doing PCI discovery.
> >
> > I'm feeling really skeptical that adding all this PCI config space and
> > MMIO BAR emulation to the kernel just to cram this into a VFIO
> > interface is a good idea, that kind of stuff is much safer in
> > userspace.
> >
> > Particularly since vfio is not really needed once a driver is using
> > the PASID stuff. We already have general code for drivers to use to
> > attach a PASID to a mm_struct - and using vfio while disabling all the
> > DMA/iommu config really seems like an abuse.
> >
> > A /dev/idxd char dev that mmaps a bar page and links it to a PASID
> > seems a lot simpler and saner kernel wise.
> >
> > > The mdev utilizes Interrupt Message Store or IMS[3] instead of MSIX for
> > > interrupts for the guest. This preserves MSIX for host usages and also allows a
> > > significantly larger number of interrupt vectors for guest usage.
> >
> > I never did get a reply to my earlier remarks on the IMS patches.
> >
> > The concept of a device specific addr/data table format for MSI is not
> > Intel specific. This should be general code. We have a device that can
> > use this kind of kernel capability today.
>
> This has been my concern reviewing the implementation. IMS needs more
> than one in-tree user to validate degrees of freedom in the api. I had
> been missing a second "in-tree user" to validate the scope of the
> flexibility that was needed.

Hey Jason,

Per Megha's follow-up can you send the details about that other device
and help clear a path for a device-specific MSI addr/data table
format. Ever since HMM I've been sensitive, perhaps overly-sensitive,
to claims about future upstream users. The fact that you have an
additional use case is golden for pushing this into a common area and
validating the scope of the proposed API.
