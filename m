Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71402A40B3
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 10:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgKCJwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 04:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgKCJwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 04:52:16 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3488EC0613D1
        for <kvm@vger.kernel.org>; Tue,  3 Nov 2020 01:52:16 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 6BEAF3D9; Tue,  3 Nov 2020 10:52:12 +0100 (CET)
Date:   Tue, 3 Nov 2020 10:52:09 +0100
From:   "joro@8bytes.org" <joro@8bytes.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
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
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Message-ID: <20201103095208.GA22888@8bytes.org>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12, 2020 at 08:38:54AM +0000, Tian, Kevin wrote:
> > From: Jason Wang <jasowang@redhat.com>

> > Jason suggest something like /dev/sva. There will be a lot of other
> > subsystems that could benefit from this (e.g vDPA).

Honestly, I fail to see the benefit of offloading these IOMMU specific
setup tasks to user-space.

The ways PASID and the device partitioning it allows are used are very
device specific. A GPU will be partitioned completly different than a
network card. So the device drivers should use the (v)SVA APIs to setup
the partitioning in a way which makes sense for the device.

And VFIO is of course a user by itself, as it allows assigning device
partitions to guests. Or even allow assigning complete devices and allow
the guests to partition it themselfes.

So having said this, what is the benefit of exposing those SVA internals
to user-space?

Regards,

	Joerg
