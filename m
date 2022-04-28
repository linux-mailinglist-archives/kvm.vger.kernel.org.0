Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5218512F22
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 10:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344833AbiD1I7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 04:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344815AbiD1I7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 04:59:51 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DEE4A902
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 01:56:36 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B34812FB; Thu, 28 Apr 2022 10:56:34 +0200 (CEST)
Date:   Thu, 28 Apr 2022 10:56:33 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 0/4] Make the iommu driver no-snoop block feature
 consistent
Message-ID: <YmpWwbcrl5OntB+g@8bytes.org>
References: <0-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022 at 12:16:04PM -0300, Jason Gunthorpe wrote:
> Jason Gunthorpe (4):
>   iommu: Introduce the domain op enforce_cache_coherency()
>   vfio: Move the Intel no-snoop control off of IOMMU_CACHE
>   iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the cap flag for
>     IOMMU_CACHE
>   vfio: Require that devices support DMA cache coherence
> 
>  drivers/iommu/amd/iommu.c       |  7 +++++++
>  drivers/iommu/intel/iommu.c     | 17 +++++++++++++----
>  drivers/vfio/vfio.c             |  7 +++++++
>  drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++-----------
>  include/linux/intel-iommu.h     |  2 +-
>  include/linux/iommu.h           |  7 +++++--
>  6 files changed, 52 insertions(+), 18 deletions(-)

Applied to core branch, thanks everyone.
