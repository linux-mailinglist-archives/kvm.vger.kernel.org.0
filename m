Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46A61B9592
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 05:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgD0DoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 23:44:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37911 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726349AbgD0DoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 23:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587959049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DBEUXWUXNpw/sxGPzp5z9UjnZg0452gbfsNvSnWcap8=;
        b=HmIgmO/klJs2YWFdZW9KCIvQzUmDR4IaaliUi0eOTFGjMkMWbtXyXvzLHQxUbwbMHv2Fcv
        JAe0cP2lx+nnQ91jRov3s0U7uGaiOPWRGP3XLmM3MjK6jXS97XiT8afu3MbRS32Y6q7E2L
        B5xeiOyrDBQsjO2nOPE9VSi5OvnwOjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-pbMyTdOTPh20o3V3rN2nZQ-1; Sun, 26 Apr 2020 23:44:05 -0400
X-MC-Unique: pbMyTdOTPh20o3V3rN2nZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFA021800F97;
        Mon, 27 Apr 2020 03:44:01 +0000 (UTC)
Received: from x1.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B68B319C58;
        Mon, 27 Apr 2020 03:43:55 +0000 (UTC)
Date:   Sun, 26 Apr 2020 21:43:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200426214355.29e19d33@x1.home>
In-Reply-To: <20200426191357.GB13640@mellanox.com>
References: <20200421235442.GO11945@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
        <20200422115017.GQ11945@mellanox.com>
        <20200422211436.GA103345@otc-nc-03>
        <20200423191217.GD13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
        <20200424124444.GJ13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
        <20200424181203.GU13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
        <20200426191357.GB13640@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 26 Apr 2020 16:13:57 -0300
Jason Gunthorpe <jgg@mellanox.com> wrote:

> On Sun, Apr 26, 2020 at 05:18:59AM +0000, Tian, Kevin wrote:
> 
> > > > I think providing an unified abstraction to userspace is also important,
> > > > which is what VFIO provides today. The merit of using one set of VFIO
> > > > API to manage all kinds of mediated devices and VF devices is a major
> > > > gain. Instead, inventing a new vDPA-like interface for every Scalable-IOV
> > > > or equivalent device is just overkill and doesn't scale. Also the actual
> > > > emulation code in idxd driver is actually small, if putting aside the PCI
> > > > config space part for which I already explained most logic could be shared
> > > > between mdev device drivers.  
> > > 
> > > If it was just config space you might have an argument, VFIO already
> > > does some config space mangling, but emulating BAR space is out of
> > > scope of VFIO, IMHO.  
> > 
> > out of scope of vfio-pci, but in scope of vfio-mdev. btw I feel that most
> > of your objections are actually related to the general idea of
> > vfio-mdev.  
> 
> There have been several abusive proposals of vfio-mdev, everything
> from a way to create device drivers to this kind of generic emulation
> framework.
> 
> > Scalable IOV just uses PASID to harden DMA isolation in mediated
> > pass-through usage which vfio-mdev enables. Then are you just opposing
> > the whole vfio-mdev? If not, I'm curious about the criteria in your mind 
> > about when using vfio-mdev is good...  
> 
> It is appropriate when non-PCI standard techniques are needed to do
> raw device assignment, just like VFIO.
> 
> Basically if vfio-pci is already doing it then it seems reasonable
> that vfio-mdev should do the same. This mission creep where vfio-mdev
> gains functionality far beyond VFIO is the problem.

Ehm, vfio-pci emulates BARs too.  We also emulate FLR, power
management, DisINTx, and VPD.  FLR, PM, and VPD all have device
specific quirks in the host kernel, and I've generally taken the stance
that would should take advantage of those quirks, not duplicate them in
userspace and not invent new access mechanisms/ioctls for each of them.
Emulating DisINTx is convenient since we must have a mechanism to mask
INTx, whether it's at the device or the APIC, so we can pretend the
hardware supports it.  BAR emulation is really too trivial to argue
about, the BARs mean nothing to the physical device mapping, they're
simply scratch registers that we mask out the alignment bits on read.
vfio-pci is a mix of things that we decide are too complicated or
irrelevant to emulate in the kernel and things that take advantage of
shared quirks or are just too darn easy to worry about.  BARs fall into
that latter category, any sort of mapping into VM address spaces is
necessarily done in userspace, but scratch registers that are masked on
read, *shrug*, vfio-pci does that.  Thanks,

Alex
 
> > technically Scalable IOV is definitely different from SR-IOV. It's 
> > simpler in hardware. And we're not emulating SR-IOV. The point
> > is just in usage-wise we want to present a consistent user 
> > experience just like passing through a PCI endpoint (PF or VF) device
> > through vfio eco-system, including various userspace VMMs (Qemu,
> > firecracker, rust-vmm, etc.), middleware (Libvirt), and higher level 
> > management stacks.   
> 
> Yes, I understand your desire, but at the same time we have not been
> doing device emulation in the kernel. You should at least be
> forthwright about that major change in the cover letters/etc.
>  
> > > The only thing we get out of this is someone doesn't have to write a
> > > idxd emulation driver in qemu, instead they have to write it in the
> > > kernel. I don't see how that is a win for the ecosystem.  
> > 
> > No. The clear win is on leveraging classic VFIO iommu and its eco-system
> > as explained above.  
> 
> vdpa had no problem implementing iommu support without VFIO. This was
> their original argument too, it turned out to be erroneous.
> 
> Jason
> 

