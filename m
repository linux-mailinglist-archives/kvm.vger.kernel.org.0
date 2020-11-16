Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C022B3AB8
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 01:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgKPAWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Nov 2020 19:22:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:23253 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727701AbgKPAWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Nov 2020 19:22:38 -0500
IronPort-SDR: gm6AEstgj4Q0/ZOPUsBsFpkZwRwNq6nYWNdCjFCSc3T41eKvjQRIJd/inLqZAdcWk6UckaCNyx
 i/qidrFK2D0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9806"; a="157711128"
X-IronPort-AV: E=Sophos;i="5.77,481,1596524400"; 
   d="scan'208";a="157711128"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2020 16:22:37 -0800
IronPort-SDR: PKeX57EzPGiFkket3HnFMlFWqaOFsr9vMVuHtHETuDPonv3uV0Rp1Nu+1QlgotdAcda/SXbjOu
 0eemmdBGIiug==
X-IronPort-AV: E=Sophos;i="5.77,481,1596524400"; 
   d="scan'208";a="543393873"
Received: from araj-mobl1.jf.intel.com ([10.251.19.79])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2020 16:22:34 -0800
Date:   Sun, 15 Nov 2020 16:22:32 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201116002232.GA2440@araj-mobl1.jf.intel.com>
References: <875z6dik1a.fsf@nanos.tec.linutronix.de>
 <20201110141323.GB22336@otc-nc-03>
 <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <20201114103430.GA9810@infradead.org>
 <20201114211837.GB12197@araj-mobl1.jf.intel.com>
 <877dqmamjl.fsf@nanos.tec.linutronix.de>
 <20201115193156.GB14750@araj-mobl1.jf.intel.com>
 <875z665kz4.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z665kz4.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 15, 2020 at 11:11:27PM +0100, Thomas Gleixner wrote:
> On Sun, Nov 15 2020 at 11:31, Ashok Raj wrote:
> > On Sun, Nov 15, 2020 at 12:26:22PM +0100, Thomas Gleixner wrote:
> >> > opt-in by device or kernel? The way we are planning to support this is:
> >> >
> >> > Device support for IMS - Can discover in device specific means
> >> > Kernel support for IMS. - Supported by IOMMU driver.
> >> 
> >> And why exactly do we have to enforce IOMMU support? Please stop looking
> >> at IMS purely from the IDXD perspective. We are talking about the
> >> general concept here and not about the restricted Intel universe.
> >
> > I think you have mentioned it almost every reply :-)..Got that! Point taken
> > several emails ago!! :-)
> 
> You sure? I _try_ to not mention it again then. No promise though. :)

Hey.. anything that's entertaining go for it :-)

> 
> > I didn't mean just for idxd, I said for *ANY* device driver that wants to
> > use IMS.
> 
> Which is wrong. Again:
> 
> A) For PF/VF on bare metal there is absolutely no IOMMU dependency
>    because it does not have a PASID requirement. It's just an
>    alternative solution to MSI[X], which allows optimizations like
>    storing the message in driver manages queue memory or lifting the
>    restriction of 2048 interrupts per device. Nothing else.

You are right.. my eyes were clouded by virtualization.. no dependency for
native absolutely.

> 
> B) For PF/VF in a guest the IOMMU dependency of IMS is a red herring.
>    There is no direct dependency on the IOMMU.
> 
>    The problem is the inability of the VMM to trap the message write to
>    the IMS storage if the storage is in guest driver managed memory.
>    This can be solved with either
> 
>    - a hypercall which translates the guest MSI message
>    or
>    - a vIOMMU which uses a hypercall or whatever to translate the guest
>      MSI message
> 
> C) Subdevices ala mdev are a different story. They require PASID which
>    enforces IOMMU and the IMS part is not managed by the users anyway.

You are right again :)

The subdevices require PASID & IOMMU in native, but inside the guest there is no
need for IOMMU unless you want to build SVM on top. subdevices work without
any vIOMMU or hypercall in the guest. Only because they look like normal
PCI devices we could map interrupts to legacy MSIx.

> 
> So we have a couple of problems to solve:
> 
>   1) Figure out whether the OS runs on bare metal
> 
>      There is no reliable answer to that, so we either:
> 
>       - Use heuristics and assume that failure is unlikely and in case
>         of failure blame the incompetence of VMM authors and/or
>         sysadmins
> 
>      or
>      
>       - Default to IMS disabled and let the sysadmin enable it via
>         command line option.
> 
>         If the kernel detects to run in a VM it yells and disables it
>         unless the OS and the hypervisor agree to provide support for
>         that scenario (see #2).
> 
>         That's fails as well if the sysadmin does so when the OS runs on
>         a VMM which is not identifiable, but at least we can rightfully
>         blame the sysadmin in that case.

cmdline isn't nice, best to have this functional out of box.

> 
>      or
> 
>       - Declare that IMS always depends on IOMMU

As you had mentioned IMS has no real dependency on IOMMU in native.

we just need to make sure if running in guest we have support for it
plumbed.

> 
>         I personaly don't care, but people working on these kind of
>         device already said, that they want to avoid it when possible.
>         
>         If you want to go that route, then please talk to those folks
>         and ask them to agree in public.
> 
>      You also need to take into account that this must work on all
>      architectures which support virtualization because IMS is
>      architecture independent.

What you suggest makes perfect sense. We can certainly get buy in from
iommu list and have this co-ordinated between all existing iommu varients.

> 
>   2) Guest support for PF/VF
> 
>      Again we have several scenarios depending on the IMS storage
>      type.
> 
>       - If the storage type is device memory then it's pretty much the
>         same as MSI[X] just a different location.

True, but still need to have some special handling for trapping those mmio
access. Unlike for MSIx VFIO already traps them and everything is
pre-plummbed. It isn't seamless as its for MSIx.

> 
>       - If the storage is in driver managed memory then this needs
>         #1 plus guest OS and hypervisor support (hypercall/vIOMMU)

Violent agreement here :-)

>         
>   3) Guest support for PF/VF and guest managed subdevice (mdev)
> 
>      Depends on #1 and #2 and is an orthogonal problem if I'm not
>      missing something.
> 
> To move forward we need to make a decision about #1 and #2 now.

Mostly in agreement. Except for mdev (current considered use case) have no
need for IMS in the guest. (Don't get me wrong, I'm not saying some odd
device managing sub-devices would need IMS in addition and that the 2048
MSIx emulation. 
> 
> This needs to be well thought out as changing it after the fact is
> going to be a nightmare.
> 
> /me grudgingly refrains from mentioning the obvious once more.
> 

So this isn't an idxd and Intel only thing :-)... 

Cheers,
Ashok
