Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5012943D6
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 22:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438460AbgJTU1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 16:27:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:4607 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438446AbgJTU1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 16:27:16 -0400
IronPort-SDR: eyrHxfc7kbGe0q3CKagZivGPZCoDs5zmB7KYXiGX6FGMDmI6QuBblo6EX5HP1s/gD8k1qHw4cN
 B6unkG0nIXkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="167393319"
X-IronPort-AV: E=Sophos;i="5.77,398,1596524400"; 
   d="scan'208";a="167393319"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 13:27:14 -0700
IronPort-SDR: RlAQXE97+ZvriQnDGm42vH0j7gGQn/9XUpFWtTdpJXo+QSN51NPbauR/ZNq9CGcJT0B9UISF7s
 mgNrwzUIQLHQ==
X-IronPort-AV: E=Sophos;i="5.77,398,1596524400"; 
   d="scan'208";a="533211399"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 13:27:14 -0700
Date:   Tue, 20 Oct 2020 13:27:13 -0700
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
Message-ID: <20201020202713.GF86371@otc-nc-03>
References: <DM5PR11MB1435A3AEC0637C4531F2FE92C31E0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201019142526.GJ6219@nvidia.com>
 <DM5PR11MB14354A8A126E686A5F20FEC2C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201020140217.GI6219@nvidia.com>
 <20201020162430.GA85321@otc-nc-03>
 <20201020170336.GK6219@nvidia.com>
 <20201020195146.GA86371@otc-nc-03>
 <20201020195557.GO6219@nvidia.com>
 <20201020200844.GC86371@otc-nc-03>
 <20201020201403.GP6219@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020201403.GP6219@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 05:14:03PM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 20, 2020 at 01:08:44PM -0700, Raj, Ashok wrote:
> > On Tue, Oct 20, 2020 at 04:55:57PM -0300, Jason Gunthorpe wrote:
> > > On Tue, Oct 20, 2020 at 12:51:46PM -0700, Raj, Ashok wrote:
> > > > I think we agreed (or agree to disagree and commit) for device types that 
> > > > we have for SIOV, VFIO based approach works well without having to re-invent 
> > > > another way to do the same things. Not looking for a shortcut by any means, 
> > > > but we need to plan around existing hardware though. Looks like vDPA took 
> > > > some shortcuts then to not abstract iommu uAPI instead :-)? When all
> > > > necessary hardware was available.. This would be a solved puzzle. 
> > > 
> > > I think it is the opposite, vIOMMU and related has outgrown VFIO as
> > > the "home" and needs to stand alone.
> > > 
> > > Apparently the HW that will need PASID for vDPA is Intel HW, so if
> > 
> > So just to make this clear, I did check internally if there are any plans
> > for vDPA + SVM. There are none at the moment. 
> 
> Not SVM, SIOV.

... And that included.. I should have said vDPA + PASID, No current plans. 
I have no idea who set expectations with you. Can you please put me in touch 
with that person, privately is fine.
