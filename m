Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6868C2AACBF
	for <lists+kvm@lfdr.de>; Sun,  8 Nov 2020 19:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgKHSL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 13:11:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:18592 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbgKHSL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 13:11:27 -0500
IronPort-SDR: EfPVu36ysq5Td0Tw1dAV9JFnxGXOFNeaWA6OyyvGcDpXC7CR05Wjt8iZoi4ZlHH/+PAoQnRXLO
 73O9kyxOx6HQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="233885667"
X-IronPort-AV: E=Sophos;i="5.77,461,1596524400"; 
   d="scan'208";a="233885667"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 10:11:26 -0800
IronPort-SDR: snAiSoKHM3lhdxi1hfsMQwzD4qjdTA45HE9GgUWWWz/q17iHgOpfCIVe/1ipo2pqbu4ZCeT06B
 +LY+WfYWpHXQ==
X-IronPort-AV: E=Sophos;i="5.77,461,1596524400"; 
   d="scan'208";a="338134689"
Received: from araj-mobl1.jf.intel.com ([10.255.230.111])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 10:11:25 -0800
Date:   Sun, 8 Nov 2020 10:11:24 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20201108181124.GA28173@araj-mobl1.jf.intel.com>
References: <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com>
 <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201107001207.GA2620339@nvidia.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason

Thanks, its now clear what you had mentioned earlier.

I had couple questions/clarifications below. Thanks for working 
through this.

On Fri, Nov 06, 2020 at 08:12:07PM -0400, Jason Gunthorpe wrote:
> On Fri, Nov 06, 2020 at 03:47:00PM -0800, Dan Williams wrote:
> 
> > Also feel free to straighten me out (Jason or Ashok) if I've botched
> > the understanding of this.
> 
> It is pretty simple when you get down to it.
> 
> We have a new kernel API that Thomas added:
> 
>   pci_subdevice_msi_create_irq_domain()
> 
> This creates an IRQ domain that hands out addr/data pairs that
> trigger interrupts.
> 
> On bare metal the addr/data pairs from the IRQ domain are programmed
> into the HW in some HW specific way by the device driver that calls
> the above function.
> 
> On (kvm) virtualization the addr/data pair the IRQ domain hands out
> doesn't work. It is some fake thing.

Is it really some fake thing? I thought the vCPU and vector are real
for a guest, and VMM ensures when interrupts are delivered they are either.

1. Handled by VMM first and then injected to guest
2. Handled in a Posted Interrupt manner, and injected to guest
   when it resumes. It can be delivered directly if guest was running
   when the interrupt arrived.

> 
> To make this work on normal MSI/MSI-X the VMM implements emulation of
> the standard MSI/MSI-X programming and swaps the fake addr/data pair
> for a real one obtained from the hypervisor IRQ domain.
> 
> To "deal" with this issue the SIOV spec suggests to add a per-device
> PCI Capability that says "IMS works". Which means either:
>  - This is bare metal, so of course it works
>  - The VMM is trapping and emulating whatever the device specific IMS
>    programming is.
> 
> The idea being that a VMM can never advertise the IMS cap flag to the
> guest unles the VMM provides a device specific driver that does device
> specific emulation to capture the addr/data pair. Remeber IMS doesn't
> say how to program the addr/data pair! Every device is unique!
> 
> On something like IDXD this emulation is not so hard, on something
> like mlx5 this is completely unworkable. Further we never do
> emulation on our devices, they always pass native hardware through,
> even for SIOV-like cases.

So is that true for interrupts too? Possibly you have the interrupt
entries sitting in memory resident on the device? Don't we need the 
VMM to ensure they are brokered by VMM in either one of the two ways 
above? What if the guest creates some addr in the 0xfee... range
how do we take care of interrupt remapping and such without any VMM 
assist?

Its probably a gap in my understanding. 

> 
> In the end pci_subdevice_msi_create_irq_domain() is a platform
> function. Either it should work completely on every device with no
> device-specific emulation required in the VMM, or it should not work
> at all and return -EOPNOTSUPP.
> 
> The only sane way to implement this generically is for the VMM to
> provide a hypercall to obtain a real *working* addr/data pair(s) and
> then have the platform hand those out from
> pci_subdevice_msi_create_irq_domain(). 
> 
> All IMS device drivers will work correctly. No VMM device emulation is
> ever needed to translate addr/data pairs.
> 

That's true. Probably this can work the same even for MSIx types too then?

When we do interrupt remapping support in guest which would be required 
if we support x2apic in guest, I think this is something we should look into more 
carefully to make this work.

One criteria that we generally tried to follow is driver that runs in host
and guest are the same, and if needed they need some functionality make it
work around some capability  detection so the alternate path can be plummed in
a generic way. 

I agree with the overall idea and we should certainly take that into consideration
when we need IMS in guest support and in context of interrupt remapping.

Hopefully I understood the overall concept. If I mis-understood any of this
please let me know.

Cheers,
Ashok
