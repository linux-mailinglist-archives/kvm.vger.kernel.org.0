Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259A22A4C0D
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 17:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgKCQzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 11:55:43 -0500
Received: from 8bytes.org ([81.169.241.247]:39290 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbgKCQzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 11:55:42 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 871D45EA; Tue,  3 Nov 2020 17:55:41 +0100 (CET)
Date:   Tue, 3 Nov 2020 17:55:40 +0100
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
Message-ID: <20201103165539.GN22888@8bytes.org>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103095208.GA22888@8bytes.org>
 <20201103125643.GN2620339@nvidia.com>
 <20201103131852.GE22888@8bytes.org>
 <20201103132335.GO2620339@nvidia.com>
 <20201103140318.GL22888@8bytes.org>
 <20201103140642.GQ2620339@nvidia.com>
 <20201103143532.GM22888@8bytes.org>
 <20201103152223.GR2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103152223.GR2620339@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 11:22:23AM -0400, Jason Gunthorpe wrote:
> This whole thread was brought up by IDXD which has a SVA driver and
> now wants to add a vfio-mdev driver too. SVA devices that want to be
> plugged into VMs are going to be common - this architecture that a SVA
> driver cannot cover the kvm case seems problematic.

Isn't that the same pattern as having separate drivers for VFs and the
parent device in SR-IOV?

Regards,

	Joerg
