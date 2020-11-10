Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F292ACEDE
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 06:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbgKJFOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 00:14:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:50519 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgKJFOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 00:14:22 -0500
IronPort-SDR: A0Nt0IJCqueT/d5rEN/ttVzKAkgHriI6tbVFEhAs2qfV891QMCABHUyPc6Dhivr759kC5k8TEF
 bHN/5Uvj9fVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="166410249"
X-IronPort-AV: E=Sophos;i="5.77,465,1596524400"; 
   d="scan'208";a="166410249"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 21:14:19 -0800
IronPort-SDR: oLC35wWWu15JI6PyQf8P3zUdEWA8iek1uSCNXBapomLEwjvN6X21M3e8Xs4WEGPPaA6gmpnXXQ
 82I3I/1E1ToA==
X-IronPort-AV: E=Sophos;i="5.77,465,1596524400"; 
   d="scan'208";a="473287046"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 21:14:19 -0800
Date:   Mon, 9 Nov 2020 21:14:12 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20201110051412.GA20147@otc-nc-03>
References: <20201106131415.GT2620339@nvidia.com>
 <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pn4mi23u.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On Mon, Nov 09, 2020 at 11:42:29PM +0100, Thomas Gleixner wrote:
> On Mon, Nov 09 2020 at 13:30, Jason Gunthorpe wrote:
> >
> > The relavance of PASID is this:
> >
> >> Again, trap emulate does not work for IMS when the IMS store is software
> >> managed guest memory and not part of the device. And that's the whole
> >> reason why we are discussing this.
> >
> > With PASID tagged interrupts and a IOMMU interrupt remapping
> > capability that can trigger on PASID, then the platform can provide
> > the same level of security as SRIOV - the above is no problem.
> >
> > The device ensures that all DMAs and all interrupts program by the
> > guest are PASID tagged and the platform provides security by checking
> > the PASID when delivering the interrupt.
> 
> Correct.
> 
> > Intel IOMMU doesn't work this way today, but it makes alot of design
> > sense.

Approach to IMS is more of a phased approach. 

#1 Allow physical device to scale beyond limits of PCIe MSIx
   Follows current methodology for guest interrupt programming and
   evolutionary changes rather than drastic.
#2 Long term we should work together on enabling IMS in guest which
   requires changes in both HW and SW eco-system.

For #1, the immediate need is to find a way to limit guest from using IMS
due to current limitations. We have couple options.

a) CPUID based method to disallow IMS when running in a guest OS. Limiting
   use to existing virtual MSIx to guest devices. (Both you/Jason alluded)
b) We can extend DMAR table to have a flag for opt-out. So in real platform
   this flag is clear and in guest VMM will ensure vDMAR will have this flag
   set. Along the lines as Jason alluded, platform level and via ACPI
   methods. We have similar use for x2apic_optout today.

Think a) is probably more generic.

For #2 Long term goal of allowing IMS in guest for devices that require
them. This requires some extensive eco-system enabling. 

- Extending HW to understand PASID-tagged interrupt messages.
- Appropriate extensions to IOMMU to enforce such PASID based isolation.

From SW improvements:

- Hypercall to retrieve addr/data from host
- Ensure SW can provide guarantee that the interrupt address range will not
  be mapped in process space when SVM is in play. Otherwise its hard to
  distinguish between DMA and Interrupt. OS needs to opt-in to this
  behavior. Today we ensure IOVA space has this 0xFEExxxxx range carve out
  of the IOVA space.


Devices such as idxd that do not have these entries on page-boundaries for
isolation to permit direct programming from GuestOS will continue to use
trap-emulate as used today.

In the end, virtualizing IMS requires eco-system collaboration, and we are
very open to change hw when all the relevant pieces are in place.

Until then, IMS will be restricted to host VMM only, and we can use the
methods above to prevent IMS in guest and continue to use the legacy
virtual MSIx.

> 
> Right.
> 
> > Otherwise the interrupt is effectively delivered to the hypervisor. A
> > secure device can *never* allow a guest to specify an addr/data pair
> > for a non-PASID tagged TLP, so the device cannot offer IMS to the
> > guest.
> 
> Ok. Let me summarize the current state of supported scenarios:
> 
>  1) SRIOV works with any form of IMS storage because it does not require
>     PASID and the VF devices have unique requester ids, which allows the
>     remap unit to sanity check the message.
> 
>  2) SIOV with IMS when the hypervisor can manage the IMS store
>     exclusively.

Today this is true for all interrupt types, MSI/MSIx/IMS.

> 
> So #2 prevents a device which handles IMS storage in queue memory to
> utilize IMS for SIOV in a guest because the hypervisor cannot manage the
> IMS message store and the guest can write arbitrary crap to it which
> violates the isolation principle.
> 
> And here is the relevant part of the SIOV spec:
> 
>  "IMS is managed by host driver software and is not accessible directly
>   from guest or user-mode drivers.
> 
>   Within the device, IMS storage is not accessible from the ADIs. ADIs
>   can request interrupt generation only through the device’s ‘Interrupt
>   Message Generation Logic’, which allows an ADI to only generate
>   interrupt messages that are associated with that specific ADI. These
>   restrictions ensure that the host driver has complete control over
>   which interrupt messages can be generated by each ADI.
> 
>   On Intel 64 architecture platforms, message signaled interrupts are
>   issued as DWORD size untranslated memory writes without a PASID TLP
>   Prefix, to address range 0xFEExxxxx. Since all memory requests
>   generated by ADIs include a PASID TLP Prefix, it is not possible for
>   an ADI to generate a DMA write that would be interpreted by the
>   platform as an interrupt message."
> 
> That's the reductio ad absurdum for this sentence in the first paragraph
> of the preceding chapter describing the concept of IMS:
> 
>   "IMS enables devices to store the interrupt messages for ADIs in a
>    device-specific optimized manner without the scalability restrictions
>    of the PCI Express defined MSI-X capability."
> 
> "Device-specific optimized manner" is either wishful thinking or
> marketing induced verbal diarrhoea.

No comment on the adjectives above :-)

> 
> The current specification puts massive restrictions on IMS storage which
> are _not_ allowing to optimize it in a device specific manner as
> demonstrated in this discussion.

IMS doesn't restrict this optimization, but to allow it requires more OS support as
you had mentioned.

> 
> It also precludes obvious use cases like passing a full device to a
> guest and let the guest manage SIOV subdevices for containers or nested
> guests.
> 
> TBH, to me this is just another hastily cobbled together half thought
> out misfeature cast in silicon. The proposed software support is
> following the exactly same principle.

Current IMS support adds incremental feature capability. Works pretty much
following everything that was created for MSIx, but just adds some device
flexibility. 

Here are some reasons why PASID isn't used today for tagging interrupts.

Interrupt messages (as specified by MSI/MSI-X in PCI specification) are 
currently defined as DWORD DMA writes to a platform/architecture specific 
address (0xFEExxxxx on Intel platforms). Existing root-complexes detect
DWORD writes to 0xFEExxxxx (without a PASID in the transaction) as interrupt 
messages and route them to interrupt-remapping logic (as opposed to other 
DMA requests that are routed to IOMMU's DMA remapping logic). 

There are multiple tools (such as logic analyzers) and OEM test validation 
harnesses that depend on such DWORD sized DMA writes with no PASID as interrupt
messages. One of the feedback we had received in the development of the
specification was to avoid impacting such tools irrespective of MSI-X or IMS 
was used for interrupt message storage (on the wire they follow the same format), 
and also to ensure interoperability of devices supporting IMS across CPU vendors 
(who may not support PASID TLP prefix).  This is one reason that led to interrupts 
from IMS to not use PASID (and match the wire format of MSI/MSI-X generated interrupts). 
The other problem was disambiguation between DMA to SVM v/s interrupts.

> 
> So before we go anywhere with this, I want to see a proper way forward
> to support _all_ sensible use cases and to fulfil the promise of
> "device-specific optimized manner" at the conceptual and specification
> and also at the code level.
> 
> I'm not at all interested to rush in support for a half baken Intel
> centric solution which other people have to clean up after the fact
> (again).

Intel had published the specification almost 2 years back and have
comprehended all the feedback received from the ecosystem 
(both open-source and others), along with offering the specification 
to be implemented by any vendors (both device and CPU vendors). 
There are few device vendors who are implementing to the spec already and 
are being explored for support by other CPU vendors

Cheers,
Ashok
