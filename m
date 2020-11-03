Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A5F2A473B
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 15:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgKCOFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 09:05:02 -0500
Received: from 8bytes.org ([81.169.241.247]:39188 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbgKCODU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 09:03:20 -0500
X-Greylist: delayed 2662 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2020 09:03:20 EST
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id A00FD433; Tue,  3 Nov 2020 15:03:19 +0100 (CET)
Date:   Tue, 3 Nov 2020 15:03:18 +0100
From:   "joro@8bytes.org" <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Message-ID: <20201103140318.GL22888@8bytes.org>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103095208.GA22888@8bytes.org>
 <20201103125643.GN2620339@nvidia.com>
 <20201103131852.GE22888@8bytes.org>
 <20201103132335.GO2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103132335.GO2620339@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 09:23:35AM -0400, Jason Gunthorpe wrote:
> Userspace needs fine grained control over the composition of the page
> table behind the PASID, 1:1 with the mm_struct is only one use case.

VFIO already offers an interface for that. It shouldn't be too
complicated to expand that for PASID-bound page-tables.

> Userspace needs to be able to handle IOMMU faults, apparently

Could be implemented by a fault-fd handed out by VFIO.

> The Intel guys had a bunch of other stuff too, looking through the new
> API they are proposing for vfio gives some flavour what they think is
> needed..

I really don't think that user-space should have to deal with details
like PASIDs or other IOMMU internals, unless absolutly necessary. This
is an OS we work on, and the idea behind an OS is to abstract the
hardware away.

Regards,

	Joerg
