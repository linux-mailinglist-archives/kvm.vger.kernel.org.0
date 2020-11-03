Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5293D2A461C
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 14:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgKCNTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 08:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbgKCNTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 08:19:01 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5546C0613D1
        for <kvm@vger.kernel.org>; Tue,  3 Nov 2020 05:19:00 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B0BA03A5; Tue,  3 Nov 2020 14:18:57 +0100 (CET)
Date:   Tue, 3 Nov 2020 14:18:52 +0100
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
Message-ID: <20201103131852.GE22888@8bytes.org>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103095208.GA22888@8bytes.org>
 <20201103125643.GN2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103125643.GN2620339@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 08:56:43AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 03, 2020 at 10:52:09AM +0100, joro@8bytes.org wrote:
> > So having said this, what is the benefit of exposing those SVA internals
> > to user-space?
> 
> Only the device use of the PASID is device specific, the actual PASID
> and everything on the IOMMU side is generic.
> 
> There is enough API there it doesn't make sense to duplicate it into
> every single SVA driver.

What generic things have to be done by the drivers besides
allocating/deallocating PASIDs and binding an address space to it?

Is there anything which isn't better handled in a kernel-internal
library which drivers just use?

Regards,

	Joerg
