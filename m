Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8A52B22A9
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 18:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKMRis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 12:38:48 -0500
Received: from mga05.intel.com ([192.55.52.43]:3880 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgKMRir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 12:38:47 -0500
IronPort-SDR: Uj9oh9jS+PtkILYfAkOvBcRkoF8QhkfQtqf7BCFMhLW0klZ1FgXLUoAw2/E1aPRXxOyXreCZ85
 xOMre2FPSftQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="255216823"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="255216823"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 09:38:47 -0800
IronPort-SDR: 8YZt70b5Kok964sqPXYAd2YuJ8I69VgCBCLM9LupaRtam992OkvRrHqLdrX5WeFkzZ3qtU7ymG
 bCYIE6b55efw==
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="328941426"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 09:38:46 -0800
Date:   Fri, 13 Nov 2020 09:38:45 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
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
        Ashok Raj <ashok.raj@intel.com>, andrew.cooper3@citrix.com
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201113173845.GA53733@otc-nc-03>
References: <87pn4mi23u.fsf@nanos.tec.linutronix.de>
 <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de>
 <20201110141323.GB22336@otc-nc-03>
 <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <MWHPR11MB1645F27808F1F5E79646A3A88CE60@MWHPR11MB1645.namprd11.prod.outlook.com>
 <874kltmlfr.fsf@nanos.tec.linutronix.de>
 <30928722afe64104b5abba09de4f74dd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30928722afe64104b5abba09de4f74dd@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 13, 2020 at 08:12:39AM -0800, Luck, Tony wrote:
> > Of course is this not only an x86 problem. Every architecture which
> > supports virtualization has the same issue. ARM(64) has no way to tell
> > for sure whether the machine runs bare metal either. No idea about the
> > other architectures.
> 
> Sounds like a hypervisor problem. If the VMM provides perfect emulation
> of every weird quirk of h/w, then it is OK to let the guest believe that it is
> running on bare metal.

That's true, which is why there isn't an immutable bit in cpuid or
otherwise telling you are running under a hypervisor. Providing something
like that would make certain features not virtualizable. Apparently before we
had faulting cpuid, what you had in guest was the real raw cpuid. 

Waiver: I'm not saying this is perfect, I'm just replaying the reason
behind it. Not trying to defend it... flames > /dev/null
> 
> If it isn't perfect, then it should make sure the guest knows *for sure*, so that
> the guest can take appropriate actions to avoid the sharp edges.
> 

There are indeed 2 problems to solve.

1. How does device driver know if device is IMS capable.

   IMS is a device attribute. Each vendor can provide its own method to
   provide that indication. One such mechanism is the DVSEC.SIOV.IMS
   property. Some might believe this is for use only by Intel. For DVSEC I
   don't believe there is such a connection as in device vendor id in
   standard header. TBH, there are other device vendors using the exact
   same method to indicate SIOV and IMS propeties. What a DVSEC vendor ID
   states is "As defined by Vendor X". 

   Why we choose a config vs something in device specific mmio is because
   today VFIO being that one common mechanism, it only exposes known
   standard and some extended headers to guest. When we expose a full PF,
   the guest doens't see the DVSEC, so drivers know this isn't available.

   This is our mechanism to stop drivers from calling
   pci_ims_array_create_msi_irq_domain(). It may not be perfect for all
   devices, it is a device specific mechanism. For devices under
   consideration following the SIOV spec it meets the sprit of the
   requirement even without #2 below. When devices have no way to detect
   this, #2 is required as a second way to block IMS.

2. How does platform component (IOMMU) inform if they can support all forms
   of IMS. (On device, or in memory). 
   
   On device would require some form trap/emulate. Legacy MSIx already has
   that solved, but for device specific store you need some additional
   work.

   When its system memory (say IMS is in GPA space), you need some form of
   hypercall. There is no way around it since we can't intercept. Yes, you
   can maybe map those as RO and trap, but its not pretty.

   To solve this rather than a generic platform capability, maybe we should
   flip this to IOMMU instead, because that's the one that offers this
   capability today.

   iommu_ims_supported() 
   	When platform has no IOMMU or no hypervisor calls, it returns
	false. So device driver can tell, even if it supports IMS
	capability deduction, does the platform support IMS.
   
        On platforms where iommu supports capability.

	Either there is a vIOMMU with a Virtual Command Register that can
	provide a way to get the interrupt handle similar to what you would
	get from an hypercall for instance. Or there is a real hypercall
	that supports giving the guest OS the physical IRTE handle. 


-- 
Cheers,
Ashok

[Forgiveness is the attribute of the STRONG - Gandhi]
