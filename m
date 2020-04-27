Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B52B1BA834
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 17:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgD0Plu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 11:41:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52822 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727022AbgD0Plu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 11:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588002109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tJRLLv8agzDERmbgL8/S6trBj8aDl75vAd6aQQKyE3Q=;
        b=DgrzTzZPAkjOB+bivcRSWQA2pvAIllLZonqRtHT8LQXG/tBMLTnB1KL36jrpAxffX0TFKc
        3m1Vju15aWPnpY645GM1i2YuBhlwdXs564dLDZ5X2uO4F8AqahHRwWuaJftLxBvsuWjaED
        Q9RUDHfSDPdh4UDHZB4wQsisYTlnYM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-dPon0T0jP8e_3iYOFCzrPw-1; Mon, 27 Apr 2020 11:41:45 -0400
X-MC-Unique: dPon0T0jP8e_3iYOFCzrPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 776E145F;
        Mon, 27 Apr 2020 15:41:42 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F6766062E;
        Mon, 27 Apr 2020 15:41:38 +0000 (UTC)
Date:   Mon, 27 Apr 2020 09:41:37 -0600
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
Message-ID: <20200427094137.4801bfb6@w520.home>
In-Reply-To: <20200427142553.GH13640@mellanox.com>
References: <20200424124444.GJ13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
        <20200424181203.GU13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
        <20200426191357.GB13640@mellanox.com>
        <20200426214355.29e19d33@x1.home>
        <20200427115818.GE13640@mellanox.com>
        <20200427071939.06aa300e@x1.home>
        <20200427132218.GG13640@mellanox.com>
        <20200427081841.18c4a994@x1.home>
        <20200427142553.GH13640@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Apr 2020 11:25:53 -0300
Jason Gunthorpe <jgg@mellanox.com> wrote:

> On Mon, Apr 27, 2020 at 08:18:41AM -0600, Alex Williamson wrote:
> > On Mon, 27 Apr 2020 10:22:18 -0300
> > Jason Gunthorpe <jgg@mellanox.com> wrote:
> >   
> > > On Mon, Apr 27, 2020 at 07:19:39AM -0600, Alex Williamson wrote:
> > >   
> > > > > It is not trivial masking. It is a 2000 line patch doing comprehensive
> > > > > emulation.    
> > > > 
> > > > Not sure what you're referring to, I see about 30 lines of code in
> > > > vdcm_vidxd_cfg_write() that specifically handle writes to the 4 BARs in
> > > > config space and maybe a couple hundred lines of code in total handling
> > > > config space emulation.  Thanks,    
> > > 
> > > Look around vidxd_do_command()
> > > 
> > > If I understand this flow properly..  
> > 
> > I've only glanced at it, but that's called in response to a write to
> > MMIO space on the device, so it's implementing a device specific
> > register.  
> 
> It is doing emulation of the secure BAR. The entire 1000 lines of
> vidxd_* functions appear to be focused on this task.

Ok, we/I need a terminology clarification, a BAR is a register in
config space for determining the size, type, and setting the location
of a I/O or memory region of a device.  I've been asserting that the
emulation of the BAR itself is trivial, but are you actually focused on
emulation of the region described by the BAR?  This is what mdev is
for, mediating access to a device and filling in gaps such that we can
use re-use the vfio device APIs.

> > Are you asking that PCI config space be done in userspace
> > or any sort of device emulation?    
> 
> I'm concerned about doing full emulation of registers on a MMIO BAR
> that trigger complex actions in response to MMIO read/write.

Maybe what you're recalling me say about mdev is that its Achilles
heel is that we rely on mediation provider (ie. vendor driver) for
security, we don't necessarily have an piece of known, common hardware
like an IOMMU to protect us when things go wrong.  That's true, but
don't we also trust drivers in the host kernel to correctly manage and
validate their own interactions with hardware, including the APIs
provided through other user interfaces.  Is the assertion then that
device specific, register level API is too difficult to emulate?

> Simple masking and simple config space stuff doesn't seem so
> problematic.
> 
> > The assumption with mdev is that we need emulation in the host
> > kernel because we need a trusted entity to mediate device access and
> > interact with privileged portion of the device control.  Thanks,  
> 
> Sure, but there are all kinds of different levels to this - mdev
> should not be some open ended device emulation framework, IMHO.
> 
> ie other devices need only a small amount of kernel side help and
> don't need complex MMIO BAR emulation.
> 
> Would you be happy if someone proposed an e1000 NIC emulator using
> mdev? Why not move every part of qemu's PCI device emulation into the
> kernel?

Well, in order to mediate a device, we certainly expect there to be a
physical device.  I also expect that there's some performance or at
least compatibility advantage to using the device API directly rather
than masquerading everything behind something like virtio.  So no, I
wouldn't expect someone to create a fully emulated device in mdev, but
also I do expect some degree of device emulation in an mdev driver to
fill the gaps in non-performance path that hardware chose to defer to
software.  Thanks,

Alex

