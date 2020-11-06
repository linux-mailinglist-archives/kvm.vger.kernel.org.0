Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4322A99D2
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 17:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgKFQsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 11:48:53 -0500
Received: from mga12.intel.com ([192.55.52.136]:25696 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgKFQsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 11:48:52 -0500
IronPort-SDR: /y4p+dqCDj282iZCsJvvA6ICQBsHsQ+HUgVSSwtVZiesckMzn4/tEjHWbm8VTBYUHrYadlmgo+
 n1LRdkFuaK+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9797"; a="148848426"
X-IronPort-AV: E=Sophos;i="5.77,457,1596524400"; 
   d="scan'208";a="148848426"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 08:48:52 -0800
IronPort-SDR: 142GO92Vb+KLu0rbvEYCKskGFKEK8ve/xYgrfu3PQd+4h7o0L3YSVU/i/sS+JIPGNqpvg1W0BY
 T7ImiiDSixQQ==
X-IronPort-AV: E=Sophos;i="5.77,457,1596524400"; 
   d="scan'208";a="364225272"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 08:48:51 -0800
Date:   Fri, 6 Nov 2020 08:48:50 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Message-ID: <20201106164850.GA85879@otc-nc-03>
References: <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
 <20201102132158.GA3352700@nvidia.com>
 <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103124351.GM2620339@nvidia.com>
 <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106131415.GT2620339@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason

On Fri, Nov 06, 2020 at 09:14:15AM -0400, Jason Gunthorpe wrote:
> On Fri, Nov 06, 2020 at 09:48:34AM +0000, Tian, Kevin wrote:
> > > The interrupt controller is responsible to create an addr/data pair
> > > for an interrupt message. It sets the message format and ensures it
> > > routes to the proper CPU interrupt handler. Everything about the
> > > addr/data pair is owned by the platform interrupt controller.
> > > 
> > > Devices do not create interrupts. They only trigger the addr/data pair
> > > the platform gives them.
> > 
> > I guess that we may just view it from different angles. On x86 platform,
> > a MSI/IMS capable device directly composes interrupt messages, with 
> > addr/data pair filled by OS.
> 
> Yes, all platforms work like that. The addr/data pair is *opaque* to
> the device. Only the platform interrupt controller component
> understands how to form those values.

True, the addr/data pair is opaque. IMS doesn't dictate what the contents
of addr/data pair is made of. That is still a platform attribute. IMS simply 
controls where the pair is physically stored. Which only the device dictates.

> 
> > If there is no IOMMU remapping enabled in the middle, the message
> > just hits the CPU. Your description possibly is from software side,
> > e.g. describing the hierarchical IRQ domain concept?
> 
> I suppose you could say that. Technically the APIC doesn't form any
> addr/data pairs, but the configuration of the APIC, IOMMU and other
> platform components define what addr/data pairs are acceptable.
> 
> The IRQ domain stuff broadly puts responsibilty to form these values
> in the IRQ layer which abstracts all the platform detatils. In Linux
> we expect the platform to provide the IRQ Domain tha can specify
> working addr/data pairs.
> 
> > I agree with this point, just as how pci-hyperv.c works. In concept Linux
> > guest driver should be able to use IMS when running on Hyper-v. There
> > is no such thing for KVM, but possibly one day we will need similar stuff.
> > Before that happens the guest could choose to simply disallow devmsi
> > by default in the platform code (inventing a hypercall just for 'disable' 
> > doesn't make sense) and ignore the IMS cap. One small open is whether
> > this can be done in one central-place. The detection of running as guest
> > is done in arch-specific code. Do we need disabling devmsi for every arch?
> >
> > But when talking about virtualization it's not good to assume the guest
> > behavior. It's perfectly sane to run a guest OS which doesn't implement 
> > any PV stuff (thus don't know running in a VM) but do support IMS. In 
> > such scenario the IMS cap allows the hypervisor to educate the guest 
> > driver to use MSI instead of IMS, as long as the driver follows the device 
> > spec. In this regard I don't think that the IMS cap will be a short-term 
> > thing, although Linux may choose to not use it.
> 
> The IMS flag belongs in the platform not in the devices.

This support is mostly a SW thing right? we don't need to muck with
platform/ACPI for that matter. 

> 
> For instance you could put a "disable IMS" flag in the ACPI tables, in
> the config space of the emuulated root port, or any other areas that
> clearly belong to the platform.

Maybe there is a different interpretation for IMS that I'm missing. Devices
that need more interrupt support than supported by PCIe standards, and how
device has grouped the storage needs for the addr/data pair is a device
attribute.

I missed why ACPI tables should carry such information. If kernel doesn't
want to support those devices its within kernel control. Which means kernel
will only use the available MSIx interfaces. This is legacy support.

> 
> The OS logic would be
>  - If no IMS information found then use IMS (Bare metal)
>  - If the IMS disable flag is found then
>    - If (future) hypercall available and the OS knows how to use it
>      then use IMS
>    - If no hypercall found, or no OS knowledge, fail IMS
> 
> Our devices can use IMS even in a pure no-emulation

This is true for IMS as well. But probably not implemented in the kernel as
such. From a HW point of view (take idxd for instance) the facility is
available to native OS as well. The early RFC supported this for native.

Native devices can have both MSIx and IMS capability. But as I understand this
isn't how we have partitioned things in SW today. We left IMS only for
mdev's. And I agree this would be very useful.

In cases where we want to support interrupt handles for user space
notification (when application specifies that in the descriptor). Those
could be IMS. The device HW has support for it.

Remember the "Why PASID in IMS entry" discussion?

https://lore.kernel.org/lkml/20201008233210.GH4734@nvidia.com/

Cheers,
Ashok
