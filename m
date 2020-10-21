Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D27295558
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 01:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507305AbgJUXxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 19:53:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:9389 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2507273AbgJUXxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 19:53:42 -0400
IronPort-SDR: r+hZL+w7Nsy5BOpskIA+fPcnNtq/b+SQzSJuPP7M2xMxA4lkB2IrV+3Jo+KNYCnOzchDJL54z1
 kcMyi/zie2oQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="231641073"
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="231641073"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 16:53:39 -0700
IronPort-SDR: ObbF/eIukKYf8wd0y+n2SPil81q7XGLu+jM7yTht640fpYB3J427wVe0k0g1j0DQJJBMRVce9E
 PbPOloQyNZrw==
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="359060275"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 16:53:38 -0700
Date:   Wed, 21 Oct 2020 16:53:36 -0700
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
Message-ID: <20201021235336.GB94504@otc-nc-03>
References: <20201020195146.GA86371@otc-nc-03>
 <20201020195557.GO6219@nvidia.com>
 <20201020200844.GC86371@otc-nc-03>
 <20201020201403.GP6219@nvidia.com>
 <20201020202713.GF86371@otc-nc-03>
 <20201021114829.GR6219@nvidia.com>
 <20201021175146.GA92867@otc-nc-03>
 <20201021182442.GU6219@nvidia.com>
 <20201021200315.GA93724@otc-nc-03>
 <20201021233218.GV6219@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021233218.GV6219@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 08:32:18PM -0300, Jason Gunthorpe wrote:
> On Wed, Oct 21, 2020 at 01:03:15PM -0700, Raj, Ashok wrote:
> 
> > I'm not sure why you tie in IDXD and VDPA here. How IDXD uses native
> > SVM is orthogonal to how we achieve mdev passthrough to guest and
> > vSVM.
> 
> Everyone assumes that vIOMMU and SIOV aka PASID is going to be needed
> on the VDPA side as well, I think that is why JasonW brought this up
> in the first place.

True, to that effect we are working on trying to move PASID allocation
outside of VFIO, so both agents VFIO and vDPA with PASID, when that comes
available can support one way to allocate and manage PASID's from user
space.

Since the IOASID is almost standalone, this is possible.
