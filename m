Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC582AAE53
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 00:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgKHXhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 18:37:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:22852 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbgKHXhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 18:37:02 -0500
IronPort-SDR: cZ/S+B8Ys5Au9VeJwWnNan44+9dBZvDkQyu6pcjQhfD304Uu6fl66EioyGoz3zYnJFoPVx+CN0
 4I5AAAx+EZbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="231363247"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="231363247"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 15:37:01 -0800
IronPort-SDR: FxN8RtMIMMuInYkQifgTBpuGLs0DPi9bCPJXW0oQzPboOaY1UDDmLAeN6+FkXJ9LaGRFc1kjo2
 Gl+nen5Naaog==
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540604292"
Received: from araj-mobl1.jf.intel.com ([10.255.228.179])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 15:37:00 -0800
Date:   Sun, 8 Nov 2020 15:36:59 -0800
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
Message-ID: <20201108233659.GB32074@araj-mobl1.jf.intel.com>
References: <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com>
 <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108232341.GB2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201108232341.GB2620339@nvidia.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Sun, Nov 08, 2020 at 07:23:41PM -0400, Jason Gunthorpe wrote:
> 
> IDXD is worring about case #4, I think, but I didn't follow in that
> whole discussion about the IMS table layout if they PASID tag the IMS
> MemWr or not?? Ashok can you clarify?
> 

The PASID in the interrupt store is for the IDXD to verify the interrupt handle
that came with the ENQCMD. User applications can obtain an interrupt handle and
ask for interrupt to be generated for transactions submitted via ENQCMD.

IDXD will compare the PASID that came with ENQCMD and verify if the PASID matches
the one stored in the Interrupt Table before generating the MemWr.

So MemWr for interrupts remains unchanged for IDXD on the wire. PASID is present in interrupt
store because the value was programmed by user space, and needs OS/hardware to ensure 
the entity asking for interrupts has ownership for the interrupt handle.
