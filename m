Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2532AC8BD
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgKIWku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:40:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:3676 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgKIWkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:40:49 -0500
IronPort-SDR: RSulfA1agBDOXZEhDSwRm7C7IriKNIW048m0e4s28XXJ0mfGecLMpDT9b6F83CCiYDZNEGb93O
 ySb6yVjI0yrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="170035060"
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="170035060"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 14:40:49 -0800
IronPort-SDR: Cv8lyot3eC1rIUslcTCTK2JUHpBULMi6Ojq14stslcyguMCY+Lg2b+Dvp8U0InQlTdaiUB9t4N
 aBmxu3yh4dug==
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="530939080"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 14:40:47 -0800
Date:   Mon, 9 Nov 2020 14:40:46 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20201109224046.GA18348@otc-nc-03>
References: <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com>
 <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109173034.GG2620339@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09, 2020 at 01:30:34PM -0400, Jason Gunthorpe wrote:
> 
> > Again, trap emulate does not work for IMS when the IMS store is software
> > managed guest memory and not part of the device. And that's the whole
> > reason why we are discussing this.
> 
> With PASID tagged interrupts and a IOMMU interrupt remapping
> capability that can trigger on PASID, then the platform can provide
> the same level of security as SRIOV - the above is no problem.

You mean even if its stored in memory, as long as the MemWr comes with
PASID, and the hypercall has provisioned the IRTE properly?

that seems like a possiblity.

> 
> The device ensures that all DMAs and all interrupts program by the
> guest are PASID tagged and the platform provides security by checking
> the PASID when delivering the interrupt. Intel IOMMU doesn't work this
> way today, but it makes alot of design sense.
> 
> Otherwise the interrupt is effectively delivered to the hypervisor. A
> secure device can *never* allow a guest to specify an addr/data pair
> for a non-PASID tagged TLP, so the device cannot offer IMS to the
> guest.

Right, it seems like that's a limitation today. 
