Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7082A4FC7
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 20:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgKCTOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 14:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgKCTOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 14:14:35 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FFAC0617A6
        for <kvm@vger.kernel.org>; Tue,  3 Nov 2020 11:14:35 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 3FA455EA; Tue,  3 Nov 2020 20:14:31 +0100 (CET)
Date:   Tue, 3 Nov 2020 20:14:29 +0100
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
Message-ID: <20201103191429.GO22888@8bytes.org>
References: <20201103095208.GA22888@8bytes.org>
 <20201103125643.GN2620339@nvidia.com>
 <20201103131852.GE22888@8bytes.org>
 <20201103132335.GO2620339@nvidia.com>
 <20201103140318.GL22888@8bytes.org>
 <20201103140642.GQ2620339@nvidia.com>
 <20201103143532.GM22888@8bytes.org>
 <20201103152223.GR2620339@nvidia.com>
 <20201103165539.GN22888@8bytes.org>
 <20201103174851.GS2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103174851.GS2620339@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 01:48:51PM -0400, Jason Gunthorpe wrote:
> I think the same PCI driver with a small flag to support the PF or
> VF is not the same as two completely different drivers in different
> subsystems

There are counter-examples: ixgbe vs. ixgbevf.

Note that also a single driver can support both, an SVA device and an
mdev device, sharing code for accessing parts of the device like queues
and handling interrupts.

Regards,

	Joerg
