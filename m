Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278E82AFD53
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgKLBbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:31:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:5849 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbgKKXDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 18:03:30 -0500
IronPort-SDR: dS8j9radFcvvHx9OSXdJkQaTYCizEfZiy+jjRSib2g6lnDSTtKEfVeYUrR91MYSv8Im0vqwote
 W+1bR2N2qjeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="170397424"
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="170397424"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 15:03:25 -0800
IronPort-SDR: 9vu89CvyJXkUEk06TLcFmU+GckpICnGsnpD4GxW6EfoVk0xaYkiNp0FqmfcJlBW5QryeyHr12+
 C/SzsWljaXFA==
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="308638506"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 15:03:23 -0800
Date:   Wed, 11 Nov 2020 15:03:21 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
        "jing.lin@intel.com" <jing.lin@intel.com>,
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
Message-ID: <20201111230321.GC83266@otc-nc-03>
References: <20201106131415.GT2620339@nvidia.com>
 <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <d69953378bd1fdcdda54a2fbe285f6c0b1484e8a.camel@infradead.org>
 <20201111154159.GA24059@infradead.org>
 <20201111160922.GA83266@otc-nc-03>
 <87k0uro7fz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0uro7fz.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 11:27:28PM +0100, Thomas Gleixner wrote:
> On Wed, Nov 11 2020 at 08:09, Ashok Raj wrote:
> >> > We'd also need a way for an OS running on bare metal to *know* that
> >> > it's on bare metal and can just compose MSI messages for itself. Since
> >> > we do expect bare metal to have an IOMMU, perhaps that is just a
> >> > feature flag on the IOMMU?
> >> 
> >> Have the platform firmware advertise if it needs native or virtualized
> >> IMS handling.  If it advertises neither don't support IMS?
> >
> > The platform hint can be easily accomplished via DMAR table flags. We could
> > have an IMS_OPTOUT(similart to x2apic optout flag) flag, when 0 its native 
> > and IMS is supported.
> >
> > When vIOMMU is presented to guest, virtual DMAR table will have this flag
> > set to 1. Indicates to GuestOS, native IMS isn't supported.
> 
> These opt-out bits suck by definition. It comes all back to the fact
> that the whole virt thing didn't have a hardware defined way to tell
> that the OS runs in a VM and not on bare metal. It wouldn't have been
> rocket science to do so.

I'm sure everybody dislikes (hate being a strong word :-)). 
DVSEC capability. Real hardware always sets it to 1 for the IMS capability.

By default the DVSEC is not presented to guest even when the full PF is
presented to guest. I believe VFIO only builds and presents known standard
capabilities and specific extended capabilities. I'm a bit weak but maybe
@AlexWilliamson can confirm if I'm off track.

This tells the driver in guest that IMS is not available and will not
create those new dev_msi calls. 

Only if the VMM has build support to expose IMS for this device, guest SW
can even see DVSEC.SIOV.IMS=1. This also means the required plumbing, say
vIOMMU, or a hypercall has been provisioned, and adminstrator knows the
guest is compatible for these options. 

There maybe better ways to do this. If this has to be done differently
we certainly can and will do. 

> 
> And because that does not exist, we need magic opt-out bits for every
> other piece of functionality which gets added. Can we please stop this
> and provide a well defined way to tell the OS whether it runs on bare
> metal or not?
> 
> The point is that you really want opt-in bits so that decisions come
> down to

How would we opt-in when the feature is not available? You need someway to
tell the capability is available in the guest?, but then there is no reason
to opt-in though.. its ready for use isn't it?

> 
>      if (!virt || virt->supports_X)

The only closest thing that comes to mind is the CPUID bits, you had
mentioned they aren't reliable if the VMM didn't set those in an earlier
mail. If you want a platform level generic support.

- DMAR table optout's you had mentioned that's ugly
- We could use caching mode, but its not a platform level thing, and vendor
  specific. I'm not sure if other vendors have a similar feature. If there
  is a generic capabilty, we could expose via the iommu api's if we are in
  virt or real platform.
> 
> which is the obvious sane and safe logic. But sure, why am I asking for
> sane and safe in the context of virtualization?

We can pick how to solve this, and just waiting for you to tell, what
mechanism you prefer that's less painful and architecturally acceptible for
virtualization and linux. We are all ears!

Cheers,
Ashok
