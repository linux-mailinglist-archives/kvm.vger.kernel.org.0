Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D64729406F
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394518AbgJTQYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 12:24:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:59118 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732856AbgJTQYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 12:24:36 -0400
IronPort-SDR: icufJgk+Z5fHaVUEaab+3CyiXqOLkjPLyBV4qh2vswaVhegG7UAmbkM7xdkC711EVC2eysemio
 XaVauxLslrKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="251934189"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="251934189"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 09:24:32 -0700
IronPort-SDR: oda8hAo5a9VQqhRY8ItcDzIAtlE/gO5mKPSCZCmtYzcbQt6F8YkS26PnyAYH71o8gew6wz0MbC
 y4Bfx19+glSQ==
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="533127391"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 09:24:31 -0700
Date:   Tue, 20 Oct 2020 09:24:30 -0700
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
Message-ID: <20201020162430.GA85321@otc-nc-03>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <MWHPR11MB1645AE971BD8DAF72CE3E1198C050@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201016153632.GM6219@nvidia.com>
 <DM5PR11MB1435A3AEC0637C4531F2FE92C31E0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201019142526.GJ6219@nvidia.com>
 <DM5PR11MB14354A8A126E686A5F20FEC2C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201020140217.GI6219@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020140217.GI6219@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,


On Tue, Oct 20, 2020 at 11:02:17AM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 20, 2020 at 10:21:41AM +0000, Liu, Yi L wrote:
> 
> > > I'm sure there will be some
> > > weird overlaps because we can't delete any of the existing VFIO APIs, but
> > > that
> > > should not be a blocker.
> > 
> > but the weird thing is what we should consider. And it perhaps not just
> > overlap, it may be a re-definition of VFIO container. As I mentioned, VFIO
> > container is IOMMU context from the day it was defined. It could be the
> > blocker. :-(
> 
> So maybe you have to broaden the VFIO container to be usable by other
> subsystems. The discussion here is about what the uAPI should look
> like in a fairly abstract way. When we say 'dev/sva' it just some
> placeholder for a shared cdev that provides the necessary
> dis-aggregated functionality 
> 
> It could be an existing cdev with broader functionaltiy, it could
> really be /dev/iommu, etc. This is up to the folks building it to
> decide.
> 
> > I'm not expert on vDPA for now, but I saw you three open source
> > veterans have a similar idea for a place to cover IOMMU handling,
> > I think it may be a valuable thing to do. I said "may be" as I'm not
> > sure about Alex's opinion on such idea. But the sure thing is this
> > idea may introduce weird overlap even re-definition of existing
> > thing as I replied above. We need to evaluate the impact and mature
> > the idea step by step. 
> 
> This has happened before, uAPIs do get obsoleted and replaced with
> more general/better versions. It is often too hard to create a uAPI
> that lasts for decades when the HW landscape is constantly changing
> and sometime a reset is needed. 

I'm throwing this out with a lot of hesitation, but I'm going to :-)

So we have been disussing this for months now, with some high level vision
trying to get the uAPI's solidified with a vDPA hardware that might
potentially have SIOV/SVM like extensions in hardware which actualy doesn't
exist today. Understood people have plans. 

Given that vDPA today has diverged already with duplicating use of IOMMU
api's without making an effort to gravitate to /dev/iommu as how you are
proposing.

I think we all understand creating a permanent uAPI is hard, and they can
evolve in future. 

Maybe  we should start work on how to converge on generalizing the IOMMU
story first with what we have today (vDPA + VFIO) convergence and let it evolve 
with real hardware and new features like SVM/SIOV in mind. This is going 
to take time and we can start with what we have today for pulling vDPA and 
VFIO pieces first.

The question is should we hold hostage the current vSVM/vIOMMU efforts
without even having made an effort for current vDPA/VFIO convergence. 

> 
> The jump to shared PASID based IOMMU feels like one of those moments here.

As we have all noted, even without PASID we have divergence today?


> 
> > > Whoever provides the vIOMMU emulation and relays the page fault to the guest
> > > has to translate the RID -
> > 
> > that's the point. But the device info (especially the sub-device info) is
> > within the passthru framework (e.g. VFIO). So page fault reporting needs
> > to go through passthru framework.
> >
> > > what does that have to do with VFIO?
> > > 
> > > How will VPDA provide the vIOMMU emulation?
> > 
> > a pardon here. I believe vIOMMU emulation should be based on IOMMU vendor
> > specification, right? you may correct me if I'm missing anything.
> 
> I'm asking how will VDPA translate the RID when VDPA triggers a page
> fault that has to be relayed to the guest. VDPA also has virtual PCI
> devices it creates.
> 
> We can't rely on VFIO to be the place that the vIOMMU lives because it
> excludes/complicates everything that is not VFIO from using that
> stuff.
> 
> Jason
