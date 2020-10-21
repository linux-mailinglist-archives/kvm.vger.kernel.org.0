Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C812951CA
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 19:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503743AbgJURvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 13:51:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:30603 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503714AbgJURvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 13:51:48 -0400
IronPort-SDR: EQ6OQwZjuQ4XSbfM8n2RuW6fR+egFpNylE8vnALWa1XDtAg9CpnDPduIRQgyUppU23wmOjkbbI
 Yn3ui4dPqVaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="154362391"
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="154362391"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 10:51:47 -0700
IronPort-SDR: nFaU7IqUVQFKNumGJ/O1yc0Mzip0lJxesUnBPBkk77D+dGCEh3jTfpKDy3QXKu79tSmu7h0pjr
 Y6Np+1E56OMA==
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="359584998"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 10:51:47 -0700
Date:   Wed, 21 Oct 2020 10:51:46 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Message-ID: <20201021175146.GA92867@otc-nc-03>
References: <DM5PR11MB14354A8A126E686A5F20FEC2C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201020140217.GI6219@nvidia.com>
 <20201020162430.GA85321@otc-nc-03>
 <20201020170336.GK6219@nvidia.com>
 <20201020195146.GA86371@otc-nc-03>
 <20201020195557.GO6219@nvidia.com>
 <20201020200844.GC86371@otc-nc-03>
 <20201020201403.GP6219@nvidia.com>
 <20201020202713.GF86371@otc-nc-03>
 <20201021114829.GR6219@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021114829.GR6219@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 08:48:29AM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 20, 2020 at 01:27:13PM -0700, Raj, Ashok wrote:
> > On Tue, Oct 20, 2020 at 05:14:03PM -0300, Jason Gunthorpe wrote:
> > > On Tue, Oct 20, 2020 at 01:08:44PM -0700, Raj, Ashok wrote:
> > > > On Tue, Oct 20, 2020 at 04:55:57PM -0300, Jason Gunthorpe wrote:
> > > > > On Tue, Oct 20, 2020 at 12:51:46PM -0700, Raj, Ashok wrote:
> > > > > > I think we agreed (or agree to disagree and commit) for device types that 
> > > > > > we have for SIOV, VFIO based approach works well without having to re-invent 
> > > > > > another way to do the same things. Not looking for a shortcut by any means, 
> > > > > > but we need to plan around existing hardware though. Looks like vDPA took 
> > > > > > some shortcuts then to not abstract iommu uAPI instead :-)? When all
> > > > > > necessary hardware was available.. This would be a solved puzzle. 
> > > > > 
> > > > > I think it is the opposite, vIOMMU and related has outgrown VFIO as
> > > > > the "home" and needs to stand alone.
> > > > > 
> > > > > Apparently the HW that will need PASID for vDPA is Intel HW, so if
> > > > 
> > > > So just to make this clear, I did check internally if there are any plans
> > > > for vDPA + SVM. There are none at the moment. 
> > > 
> > > Not SVM, SIOV.
> > 
> > ... And that included.. I should have said vDPA + PASID, No current plans. 
> > I have no idea who set expectations with you. Can you please put me in touch 
> > with that person, privately is fine.
> 
> It was the team that aruged VDPA had to be done through VFIO - SIOV
> and PASID was one of their reasons it had to be VFIO, check the list
> archives

Humm... I could search the arhives, but the point is I'm confirming that
there is no forward looking plan!

And who ever did was it was based on probably strawman hypothetical argument that wasn't
grounded in reality. 

> 
> If they didn't plan to use it, bit of a strawman argument, right?

This doesn't need to continue like the debates :-) Pun intended :-)

I don't think it makes any sense to have an abstract strawman argument
design discussion. Yi is looking into for pasid management alone. Rest 
of the IOMMU related topics should wait until we have another 
*real* use requiring consolidation. 

Contrary to your argument, vDPA went with a half blown device only 
iommu user without considering existing abstractions like containers 
and such in VFIO is part of the reason the gap is big at the moment.
And you might not agree, but that's beside the point. 

Rather than pivot ourselves around hypothetical, strawman,
non-intersecting, suggesting architecture without having done a proof of
concept to validate the proposal should stop. We have to ground ourselves
in reality.

The use cases we have so far for SIOV, VFIO and mdev seem to be the right
candidates and addresses them well. Now you might disagree, but as noted we
all agreed to move past this.

