Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CA91CB92A
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 22:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgEHUrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 16:47:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:15188 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgEHUrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 16:47:12 -0400
IronPort-SDR: DuKItoW6HSsPJmI6EKlOM9RKO+Kz3gxu7ArplrGslXFAMo/Iqwse1lpMyHjc9Ogy09IVVIB44U
 BimMnZV9PeWQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 13:47:11 -0700
IronPort-SDR: Ws67Aagq7YgG2snBGVk1C1ZIy3paurbwnrKJK/rpqD2iq5oG5Lx0moxzX7x1HOFOuxtYO7W/k8
 GGimup1grgVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="296258718"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.25])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2020 13:47:10 -0700
Date:   Fri, 8 May 2020 13:47:10 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200508204710.GA78778@otc-nc-03>
References: <20200424124444.GJ13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com>
 <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com>
 <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8E34AA@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D8E34AA@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason

In general your idea of moving pure emulation code to user space 
is a good strategy.


On Wed, Apr 29, 2020 at 02:42:20AM -0700, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@mellanox.com>
> > Sent: Monday, April 27, 2020 9:22 PM
> > 
> > On Mon, Apr 27, 2020 at 07:19:39AM -0600, Alex Williamson wrote:
> > 
> > > > It is not trivial masking. It is a 2000 line patch doing comprehensive
> > > > emulation.
> > >
> > > Not sure what you're referring to, I see about 30 lines of code in
> > > vdcm_vidxd_cfg_write() that specifically handle writes to the 4 BARs in
> > > config space and maybe a couple hundred lines of code in total handling
> > > config space emulation.  Thanks,
> > 
> > Look around vidxd_do_command()
> > 
> > If I understand this flow properly..
> > 
> 
> Hi, Jason,
> 
> I guess the 2000 lines mostly refer to the changes in mdev.c and vdev.c. 
> We did a break-down among them:
> 
> 1) ~150 LOC for vdev initialization
> 2) ~150 LOC for cfg space emulation
> 3) ~230 LOC for mmio r/w emulation
> 4) ~500 LOC for controlling the work queue (vidxd_do_command), 
> triggered by write emulation of IDXD_CMD_OFFSET register
> 5) the remaining lines are all about vfio-mdev registration/callbacks,
> for reporting mmio/irq resource, eventfd, mmap, etc.
> 
> 1/2/3) are pure device emulation, which counts for ~500 LOC. 
> 
> 4) needs be in the kernel regardless of which uAPI is used, because it
> talks to the physical work queue (enable, disable, drain, abort, reset, etc.)
> 
> Then if just talking about ~500 LOC emulation code left in the kernel, 
> is it still a big concern to you? 😊

Even when uaccel was under development, one of the options
was to use VFIO as the transport, goal was the same i.e to keep
the user space have one interface. But the needs of generic 
user space application is significantly different from exporting
a more functional device model to guest, which isn't full emulated
device. which is why VFIO didn't make sense for native use.

And when we move things from VFIO which is already established
as a general device model and accepted by multiple VMM's it gives
instant footing without a whole redesign. When we move things from 
VFIO to uaccel to bolt on the functionality like VFIO, I suspect we 
would be moving code/functionality from VFIO to Uaccel. I don't know
what the net gain would be.

IMS is being reworked based on your feedback. And for mdev
since the code is minimal for emulation, and rest are control paths
that need kernel code to deal with.

For mdev, would you agree we can keep the current architecture,
and investigate moving some emulation code to user space (say even for
standard vfio_pci) and then expand scope later.

Cheers
Ashok
