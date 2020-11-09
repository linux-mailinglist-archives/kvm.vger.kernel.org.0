Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222482AAE79
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 01:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgKIAFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 19:05:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:42925 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbgKIAFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 19:05:54 -0500
IronPort-SDR: 1PNKp56QX7RR0CChtw+IQvOeSdMGsp3PNdkPWD/g5+BkJIpowLaD+kGHSrShBl6uQQpKpHSk9O
 fMhoO2+GysMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="166223084"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="166223084"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 16:05:54 -0800
IronPort-SDR: URKh91De8z8i9pU2NLA5haELAPH1gMBPE2wkq+dJOcFLNi2+xpsHt4aZiWgjHUNdthDm2aS59n
 kSvgbnkNGRKw==
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="530506850"
Received: from araj-mobl1.jf.intel.com ([10.255.228.179])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 16:05:52 -0800
Date:   Sun, 8 Nov 2020 16:05:50 -0800
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
Message-ID: <20201109000550.GD32074@araj-mobl1.jf.intel.com>
References: <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com>
 <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <20201108181124.GA28173@araj-mobl1.jf.intel.com>
 <20201108234142.GD2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201108234142.GD2620339@nvidia.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason

On Sun, Nov 08, 2020 at 07:41:42PM -0400, Jason Gunthorpe wrote:
> On Sun, Nov 08, 2020 at 10:11:24AM -0800, Raj, Ashok wrote:
> 
> > > On (kvm) virtualization the addr/data pair the IRQ domain hands out
> > > doesn't work. It is some fake thing.
> > 
> > Is it really some fake thing? I thought the vCPU and vector are real
> > for a guest, and VMM ensures when interrupts are delivered they are either.
> 
> It is fake in the sense it is programmed into no hardware.
>  
> It is real in the sense it is an ABI contract with the VMM.

Ah.. its clear now. That clears up my question below as well.

> 
> Yes, no matter what the VMM has to know the guest wants an interrupt
> routed in and setup the VMM part of the equation. With SRIOV this is
> all done with the MSI trapping.
> 
> > What if the guest creates some addr in the 0xfee... range how do we
> > take care of interrupt remapping and such without any VMM assist?
> 
> Not sure I understand this?
> 

My question was based on mis-conception that interrupt entries are directly
written by guest OS for mlx*. My concern was about security isolation if guest OS
has full control of device interrupt store. 

I think you clarified it, that interrupts still are marshalled by the VMM
and not in direct control of guest OS. That makes my question moot.

Cheers,
Ashok
