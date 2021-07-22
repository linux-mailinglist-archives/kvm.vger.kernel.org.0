Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D2F3D24AF
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 15:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhGVMyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 08:54:19 -0400
Received: from verein.lst.de ([213.95.11.211]:34355 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232032AbhGVMyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 08:54:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C2E9867373; Thu, 22 Jul 2021 15:34:50 +0200 (CEST)
Date:   Thu, 22 Jul 2021 15:34:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Message-ID: <20210722133450.GA29155@lst.de>
References: <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com> <20210514121925.GI1096940@ziepe.ca> <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com> <20210514133143.GK1096940@ziepe.ca> <YKJf7mphTHZoi7Qr@8bytes.org> <20210517123010.GO1096940@ziepe.ca> <YKJnPGonR+d8rbu/@8bytes.org> <20210517133500.GP1096940@ziepe.ca> <YKKNLrdQ4QjhLrKX@8bytes.org> <BN9PR11MB54331FC6BB31E8CBF11914A48C019@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54331FC6BB31E8CBF11914A48C019@BN9PR11MB5433.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 30, 2021 at 09:08:19AM +0000, Tian, Kevin wrote:
> The iommu layer should maintain above attaching status per device and per
> iommu domain. There is no mdev/subdev concept in the iommu layer. It's
> just about RID or PASID.

Yes, I think that makes sense.

> And a new set of IOMMU-API:
> 
>     - iommu_{un}bind_pgtable(domain, dev, addr);
>     - iommu_{un}bind_pgtable_pasid(domain, dev, addr, pasid);
>     - iommu_cache_invalidate(domain, dev, invalid_info);

What caches is this supposed to "invalidate"?
