Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C074F99A2
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 17:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbiDHPj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 11:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbiDHPjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 11:39:24 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7B1335E4D;
        Fri,  8 Apr 2022 08:37:20 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 2C05D1E9; Fri,  8 Apr 2022 17:37:18 +0200 (CEST)
Date:   Fri, 8 Apr 2022 17:37:16 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/11] Fix BUG_ON in vfio_iommu_group_notifier()
Message-ID: <YlBWrE7kxX9vraOD@8bytes.org>
References: <20220308054421.847385-1-baolu.lu@linux.intel.com>
 <20220315002125.GU11336@nvidia.com>
 <Yk/q1BGN8pC5HVZp@8bytes.org>
 <1033ebe4-fa92-c9bd-a04b-8b28b21e25ea@linux.intel.com>
 <20220408122352.GW2120790@nvidia.com>
 <YlA//+zdOqgaFkUc@8bytes.org>
 <20220408141747.GZ2120790@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408141747.GZ2120790@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022 at 11:17:47AM -0300, Jason Gunthorpe wrote:
> You might consider using a linear tree instead of the topic branches,
> topics are tricky and I'm not sure it helps a small subsystem so much.
> Conflicts between topics are a PITA for everyone, and it makes
> handling conflicts with rc much harder than it needs to be.

I like the concept of a branch per driver, because with that I can just
exclude that branch from my next-merge when there are issues with it.
Conflicts between branches happen too, but they are quite manageable
when the branches have the same base.

Overall I am thinking of reorganizing the IOMMU tree, but it will likely
not end up to be a single-branch tree, although the number of patches
per cycle _could_ just be carried in a single branch.

> At least I haven't felt a need for topics while running larger trees,
> and would find it stressful to try and squeeze the entire patch flow
> into only 3 weeks out of the 7 week cycle.

Yeah, so it is 4 weeks in an 9 weeks cycle :) The merge window is 2
weeks and not a lot happens. The 2 weeks after are for stabilization and
I usually only pick up fixes. Then come the 4 weeks were new code gets
into the tree. In the last week everything gets testing in linux-next to
be ready for the merge window. I will pickup fixes in that week, of
course.

> In any event, I'd like this on a branch so Alex can pull it too, I
> guess it means Alex has to merge rc3 to VFIO as well?

Sure, I can put these patches in a separate branch for Alex to pull into
the VFIO tree.

Regards,

	Joerg
