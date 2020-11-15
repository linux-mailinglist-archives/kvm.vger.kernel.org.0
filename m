Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FBD2B38B5
	for <lists+kvm@lfdr.de>; Sun, 15 Nov 2020 20:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgKOTb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Nov 2020 14:31:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:30262 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbgKOTb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Nov 2020 14:31:59 -0500
IronPort-SDR: FgLV4Wth+NUZBN4nIlSzP+82rc3lVD01d75nU1HL616896T18iPYywpzhDraX1DiGM9/iv9yqZ
 5gLJWHabW+MA==
X-IronPort-AV: E=McAfee;i="6000,8403,9806"; a="167162873"
X-IronPort-AV: E=Sophos;i="5.77,480,1596524400"; 
   d="scan'208";a="167162873"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2020 11:31:58 -0800
IronPort-SDR: Qnm5JRmHnQ0SBJ2JYsuLr9hPybwhr3GhMPNdkgfQhAF+zZicp+aGixd2M9IGyK7p7qTGSuNYt/
 s2IRPJXtNqBQ==
X-IronPort-AV: E=Sophos;i="5.77,480,1596524400"; 
   d="scan'208";a="543334348"
Received: from araj-mobl1.jf.intel.com ([10.251.5.100])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2020 11:31:57 -0800
Date:   Sun, 15 Nov 2020 11:31:56 -0800
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
Message-ID: <20201115193156.GB14750@araj-mobl1.jf.intel.com>
References: <87pn4mi23u.fsf@nanos.tec.linutronix.de>
 <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de>
 <20201110141323.GB22336@otc-nc-03>
 <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <20201114103430.GA9810@infradead.org>
 <20201114211837.GB12197@araj-mobl1.jf.intel.com>
 <877dqmamjl.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dqmamjl.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 15, 2020 at 12:26:22PM +0100, Thomas Gleixner wrote:
> On Sat, Nov 14 2020 at 13:18, Ashok Raj wrote:
> > On Sat, Nov 14, 2020 at 10:34:30AM +0000, Christoph Hellwig wrote:
> >> On Thu, Nov 12, 2020 at 11:42:46PM +0100, Thomas Gleixner wrote:
> >> Which is why I really think we need explicit opt-ins for "native"
> >> SIOV handling and for paravirtualized SIOV handling, with the kernel
> >> not offering support at all without either or a manual override on
> >> the command line.
> >
> > opt-in by device or kernel? The way we are planning to support this is:
> >
> > Device support for IMS - Can discover in device specific means
> > Kernel support for IMS. - Supported by IOMMU driver.
> 
> And why exactly do we have to enforce IOMMU support? Please stop looking
> at IMS purely from the IDXD perspective. We are talking about the
> general concept here and not about the restricted Intel universe.

I think you have mentioned it almost every reply :-)..Got that! Point taken
several emails ago!! :-)

I didn't mean just for idxd, I said for *ANY* device driver that wants to
use IMS.

> 
> > each driver can check 
> >
> > if (dev_supports_ims() && iommu_supports_ims()) {
> > 	/* Then IMS is supported in the platform.*/
> > }
> 
> Please forget this 'each driver can check'. That's just wrong.

Ok.

> 
> The only thing the driver has to check is whether the device supports
> IMS or not. Everything else has to be handled by the underlying
> infrastructure.

That's pretty much the same thing.. I guess you wanted to add 
"Does infrastructure support IMS" to be someplace else, instead
of device driver checking it. That's perfectly fine.

Until we support this natively via hypercall or vIOMMU we can use your
varient of finding if you are not on bare_metal to decide support for IMS.

How you highligted below:

https://lore.kernel.org/lkml/877dqrnzr3.fsf@nanos.tec.linutronix.de/

probably_on_bare_metal()
{
        if (CPUID(FEATURE_HYPERVISOR))
        	return false;
       	if (dmi_match_hypervisor_vendor())
        	return false;

        return PROBABLY_RUNNING_ON_BARE_METAL;
}

The above is all we need for now and will work in almost all cases. 
We will move forward with just the above in the next series.

Below is for future consideration.

Even the above isn't fool proof if both HYPERVISOR feature flag isn't set,
and the dmi_string doesn't match, say some new hypervisor. The only way 
we can figure that is

- If no iommu support, or iommu can tell if this is a virtualized iommu.
The presence of caching_mode is one such indication for Intel. 

PS: Other IOMMU's must have something like this to support virtualization.
    I'm not saying this is an Intel only feature just in case you interpret
    it that way! I'm only saying if there is a mechanism to distinguish
    native vs emulated platform.

When vIOMMU supports getting native interrupt handle via a virtual command
interface for Intel IOMMU's. OR some equivalent when other vedors provide
such capability. Even without a hypercall virtualizing IOMMU can provide
the same solution.

If we support hypercall then its more generic so it would fall into the
native all platforms/vendors. Certainly the most scalable long term
solution.


Cheers,
Ashok
