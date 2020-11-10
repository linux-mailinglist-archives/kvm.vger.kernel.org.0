Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383E12AD869
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 15:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732299AbgKJON2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 09:13:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:31730 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730880AbgKJON1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 09:13:27 -0500
IronPort-SDR: sDxNWZ6Dcnc2hqF4qrmyvkHo7hcRftbQTh7g6Kl0D5XDSSg4f0sQrCJPt0yMXFeJErtz9Mrbrb
 Czd8Rj0nwlBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="234142628"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="234142628"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 06:13:25 -0800
IronPort-SDR: jTy2oEcYHeqTR/PuPMFNJsuA1QGjArnEfzapc4ZoNFRvHno4UWo8YNp+R+4SMsBonNTOhF4qwE
 4QqFJu17y4OQ==
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="308050541"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 06:13:24 -0800
Date:   Tue, 10 Nov 2020 06:13:23 -0800
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
Message-ID: <20201110141323.GB22336@otc-nc-03>
References: <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de>
 <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z6dik1a.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas,

With all these interrupt message storms ;-), I'm missing how to move towards
an end goal.

On Tue, Nov 10, 2020 at 11:27:29AM +0100, Thomas Gleixner wrote:
> Ashok,
> 
> On Mon, Nov 09 2020 at 21:14, Ashok Raj wrote:
> > On Mon, Nov 09, 2020 at 11:42:29PM +0100, Thomas Gleixner wrote:
> >> On Mon, Nov 09 2020 at 13:30, Jason Gunthorpe wrote:
> > Approach to IMS is more of a phased approach. 
> >
> > #1 Allow physical device to scale beyond limits of PCIe MSIx
> >    Follows current methodology for guest interrupt programming and
> >    evolutionary changes rather than drastic.
> 
> Trapping MSI[X] writes is there because it allows to hand a device to an
> unmodified guest OS and to handle the case where the MSI[X] entries
> storage cannot be mapped exclusively to the guest.
> 
> But aside of this, it's not required if the storage can be mapped
> exclusively, the guest is hypervisor aware and can get a host composed
> message via a hypercall. That works for physical functions and SRIOV,
> but not for SIOV.

It would greatly help if you can put down what you see is blocking 
to move forward in the following areas.

Address Gaps in Spec: 

Specs can accomodate change after review, as the number of ECN's that go on
with PCIe ;-). Please add what you like to see in the spec if you beleive
is a gap today.

Hardware Gaps?
- PASID tagged Interrupts.
- IOMMU Support for PASID based IR.

As i had called out, there are a lot of moving parts, and requires more
attention.

OS Gaps?
- Lack of ability to identify if platform can use IMS.
- Lack of hypercall.

We will always have devices that have more interrupts but their use doesn't
need IMS to be directly manipulated by the guest, or the fact those usages
require more than what is allowed by PCIe in a guest. These devices can 
scale by adding another sub-device and you get another block of 2048 if needed.

This isn't just for idxd, as I mentioned earlier, there are vendors other
than Intel already working on this. In all cases the need for guest direct
manipulation of interrupt store hasn't come up. From the discussion, it
seems like there are devices today or in future that will require direct
manipulation of interrupt store in the guest. This needs additional work
in both the device hardware providing the right plumbing and OS work to
comprehend those.

Cheers,
Ashok
