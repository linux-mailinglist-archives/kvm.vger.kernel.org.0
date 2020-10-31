Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5752A1B4B
	for <lists+kvm@lfdr.de>; Sun,  1 Nov 2020 00:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgJaXyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 19:54:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:24285 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgJaXyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Oct 2020 19:54:02 -0400
IronPort-SDR: 1qD89CwGVGoy76FNv/pGyq4Z9UgxTaXa4brdXExuaQZHifgV8tl8vFEnYQL8xWnJ8BjNt9ftAt
 VKS7Zn6FbRVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9791"; a="186582740"
X-IronPort-AV: E=Sophos;i="5.77,439,1596524400"; 
   d="scan'208";a="186582740"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2020 16:54:02 -0700
IronPort-SDR: Mu8F1bs8J8RO+8ZbS2ewS7J99ydOYOdGlKJyDaXwE4UM3yHF5spmwQtZ6UrpPp8y/q4d8fuA+t
 2d9nj51saCtw==
X-IronPort-AV: E=Sophos;i="5.77,439,1596524400"; 
   d="scan'208";a="319682566"
Received: from araj-mobl1.jf.intel.com ([10.212.149.16])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2020 16:54:01 -0700
Date:   Sat, 31 Oct 2020 16:53:59 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        Megha Dey <megha.dey@linux.intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20201031235359.GA23878@araj-mobl1.jf.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
 <20201030185858.GI2620339@nvidia.com>
 <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
 <20201030191706.GK2620339@nvidia.com>
 <20201030192325.GA105832@otc-nc-03>
 <20201030193045.GM2620339@nvidia.com>
 <20201030204307.GA683@otc-nc-03>
 <87h7qbkt18.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7qbkt18.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On Sat, Oct 31, 2020 at 03:50:43AM +0100, Thomas Gleixner wrote:
> Ashok,
> 
> < skip a lot of non-sensical arguments>

Ouch!.. Didn't mean to awaken you like this :-).. apologies.. profusely! 

> 
> Just because there is historical precendence which does not care about
> the differentiation of subsystems is not an argument at all to make the
> same mistakes which have been made years ago.
> 
> IDXD is just infrastructure which provides the base for a variety of
> different functionalities. Very similar to what multi function devices
> provide. In fact IDXD is pretty much a MFD facility.

I'm only asking this to better understand the thought process. 
I don't intend to be defensive,  I have my hands tied back.. so we will do
what you say best fits per your recommendation.

Not my intend to dig a deeper hole than I have already dug! :-(

IDXD is just a glorified DMA engine, data mover. It also does a few other
things. In that sense its a multi-function facility. But doesn't do  different 
functional pieces like PCIe multi-function device in that sense. i.e
it doesn't do other storage and network in that sense. 

> 
> Sticking all of it into dmaengine is sloppy at best. The dma engine
> related part of IDXD is only a part of the overall functionality.

dmaengine is the basic non-transformational data-mover. Doing other operations
or transformations are just the glorified data-mover part. But fundamentally
not different.

> 
> I'm well aware that it is conveniant to just throw everything into
> drivers/myturf/ but that does neither make it reviewable nor
> maintainable.

That's true, when we add lot of functionality in one place. IDXD doing
mdev support is not offering new functioanlity. SRIOV PF drivers that support
PF/VF mailboxes are part of PF drivers today. IDXD mdev is preciely playing that
exact role. 

If we are doing this just to improve review effectiveness, Now we would need
some parent driver, and these sub-drivers registering seemed like a bit of
over-engineering when these sub-drivers actually are an extension of the
base driver and offer nothing more than extending sub-device partitions 
of IDXD for guest drivers. These look and feel like IDXD, not another device 
interface. In that sense if we move PF/VF mailboxes as
separate drivers i thought it feels a bit odd.

Please don't take it the wrong way. 

Cheers,
Ashok
