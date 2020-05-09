Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1518F1CBB93
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 02:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgEIAJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 20:09:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:23037 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgEIAJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 20:09:10 -0400
IronPort-SDR: LFPKURXgjl9ZLfZxQXo9dWUEIOIksGaMDp+QfuIiRA8YZxWkA6vO9DkcRQnUeFH5SeX18o3T+z
 ELudsbypXAvw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 17:09:10 -0700
IronPort-SDR: Y8YO7D+f89XLasVgvo7I+tiJRACov1CBSDE68TG8unNse8tI9sEOhqaA1F2mAEV03HJ/7P44Nw
 +Xjcv56Isi6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="250608479"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.25])
  by fmsmga007.fm.intel.com with ESMTP; 08 May 2020 17:09:08 -0700
Date:   Fri, 8 May 2020 17:09:09 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200509000909.GA79981@otc-nc-03>
References: <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com>
 <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com>
 <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8E34AA@SHSMSX104.ccr.corp.intel.com>
 <20200508204710.GA78778@otc-nc-03>
 <20200508231610.GO19158@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508231610.GO19158@mellanox.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason

On Fri, May 08, 2020 at 08:16:10PM -0300, Jason Gunthorpe wrote:
> On Fri, May 08, 2020 at 01:47:10PM -0700, Raj, Ashok wrote:
> 
> > Even when uaccel was under development, one of the options
> > was to use VFIO as the transport, goal was the same i.e to keep
> > the user space have one interface. 
> 
> I feel a bit out of the loop here, uaccel isn't in today's kernel is
> it? I've heard about it for a while, it sounds very similar to RDMA,
> so I hope they took some of my advice...

I think since 5.7 maybe? drivers/misc/uacce. I don't think this is like
RDMA, its just a plain accelerator. There is no connection management,
memory registration or other things.. IB was my first job at Intel,
but saying that i would be giving my age away :)

> 
> > But the needs of generic user space application is significantly
> > different from exporting a more functional device model to guest,
> > which isn't full emulated device. which is why VFIO didn't make
> > sense for native use.
> 
> I'm not sure this is true. We've done these kinds of emulated SIOV
> like things already and there is a huge overlap between what a generic
> user application needs and what the VMM neds. Actually almost a
> perfect subset except for interrupt remapping (which is quite
> trivial).

From a simple user application POV, if we need to do simple compression
or such with a shared WQ, all the application needs do do is
bind_mm() that somehow associates the process address space with the 
IOMMU to create that association and communication channel.

For supporting this with guest user, we need to support the same actions
from a guest OS. i.e a guest OS bind should be serviced and end up with the 
IOMMU plumbing it with the guest cr3, and making sure the guest 2nd level 
is plumed right for the nested walk. 

Now we can certainly go bolt all these things again. When VFIO has already 
done the pluming in a generic way.

> 
> The things vfio focuses on, like groups and managing a real config
> space just don't apply here.
> 
> > And when we move things from VFIO which is already established
> > as a general device model and accepted by multiple VMM's it gives
> > instant footing without a whole redesign. 
> 
> Yes, I understand, but I think you need to get more people to support
> this idea. From my standpoint this is taking secure lean VMMs and

When we decided on VFIO, it was after using the best practices then,
after discussion with Kirti Wankhede and Alex. Kevin had used it for
graphics virtualization. It was even presented at KVM forum and such
dating back to 2017. No one has raised alarms until now :-)


> putting emulation code back into them, except in a more dangerous
> kernel location. This does not seem like a net win to me.

Its not a whole lot of emulation right? mdev are soft partitioned. There is
just a single PF, but we can create a separate partition for the guest using
PASID along with the normal BDF (RID). And exposing a consistent PCI like
interface to user space you get everything else for free.

Yes, its not SRIOV, but giving that interface to user space via VFIO, we get 
all of that functionality without having to reinvent a different way to do it.

vDPA went the other way, IRC, they went and put a HW implementation of what
virtio is in hardware. So they sort of fit the model. Here the instance
looks and feels like real hardware for the setup and control aspect.


> 
> You'd be much better to have some userspace library scheme instead of
> being completely tied to a kernel interface for modularity.

Couldn't agree more :-).. all I'm asking is if we can do a phased approach to 
get to that goodness! If we need to move things to user space for emulation
that's a great goal, but it can be evolutionary.

> 
> > When we move things from VFIO to uaccel to bolt on the functionality
> > like VFIO, I suspect we would be moving code/functionality from VFIO
> > to Uaccel. I don't know what the net gain would be.
> 
> Most of VFIO functionality is already decomposed inside the kernel,
> and you need most of it to do secure user access anyhow.
> 
> > For mdev, would you agree we can keep the current architecture,
> > and investigate moving some emulation code to user space (say even for
> > standard vfio_pci) and then expand scope later.
> 
> I won't hard NAK this, but I think you need more people to support
> this general idea of more emulation code in the kernel to go ahead -
> particularly since this is one of many future drivers along this
> design.
> 
> It would be good to hear from the VMM teams that this is what they
> want (and why), for instance.

IRC Paolo was present I think and we can find other VMM folks to chime in if
that helps.

