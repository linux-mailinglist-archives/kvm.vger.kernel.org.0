Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729AF2B30FA
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 22:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgKNVSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Nov 2020 16:18:42 -0500
Received: from mga04.intel.com ([192.55.52.120]:48977 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgKNVSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Nov 2020 16:18:42 -0500
IronPort-SDR: RpTANA/y6l8jtiUNhPkYq70jfMKBYviL656tSgR8UYwStWT4AZlnH5p0jXbeqgrkuFdXtkmK7r
 /UxlrDu7e+jg==
X-IronPort-AV: E=McAfee;i="6000,8403,9805"; a="168023215"
X-IronPort-AV: E=Sophos;i="5.77,479,1596524400"; 
   d="scan'208";a="168023215"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2020 13:18:40 -0800
IronPort-SDR: ExfAj2ZqQvzsSiNuKMtVo6WieFeeXJ168W7jZs9Qdz4+f3GfpjUoT5EJ2RTRob4+CIraLP6pnb
 PP9+UvpuOieg==
X-IronPort-AV: E=Sophos;i="5.77,479,1596524400"; 
   d="scan'208";a="475070935"
Received: from araj-mobl1.jf.intel.com ([10.251.4.217])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2020 13:18:39 -0800
Date:   Sat, 14 Nov 2020 13:18:37 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20201114211837.GB12197@araj-mobl1.jf.intel.com>
References: <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de>
 <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de>
 <20201110141323.GB22336@otc-nc-03>
 <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <20201114103430.GA9810@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114103430.GA9810@infradead.org>
User-Agent: Mutt/1.9.1 (2017-09-22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 14, 2020 at 10:34:30AM +0000, Christoph Hellwig wrote:
> On Thu, Nov 12, 2020 at 11:42:46PM +0100, Thomas Gleixner wrote:
> > DMI vendor name is pretty good final check when the bit is 0. The
> > strings I'm aware of are:
> > 
> > QEMU, Bochs, KVM, Xen, VMware, VMW, VMware Inc., innotek GmbH, Oracle
> > Corporation, Parallels, BHYVE, Microsoft Corporation
> > 
> > which is not complete but better than nothing ;)
> 
> Which is why I really think we need explicit opt-ins for "native"
> SIOV handling and for paravirtualized SIOV handling, with the kernel
> not offering support at all without either or a manual override on
> the command line.

opt-in by device or kernel? The way we are planning to support this is:

Device support for IMS - Can discover in device specific means
Kernel support for IMS. - Supported by IOMMU driver.

each driver can check 

if (dev_supports_ims() && iommu_supports_ims()) {
	/* Then IMS is supported in the platform.*/
}


until we have vIOMMU support or a hypercall, iommu_supports_ims() will
check if X86_FEATURE_HYPERVISOR in addition to the platform id's Thomas
mentioned. or on intel platform check for cap.caching_mode=1 and return false.

When we add support for getting a native interrupt handle then we will plumb that
appropriately.

Does this match what you wanted?
