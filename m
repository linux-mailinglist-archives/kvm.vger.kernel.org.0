Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A7E3D342B
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 07:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhGWFAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 01:00:38 -0400
Received: from verein.lst.de ([213.95.11.211]:36999 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhGWFAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 01:00:36 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E180A67373; Fri, 23 Jul 2021 07:41:06 +0200 (CEST)
Date:   Fri, 23 Jul 2021 07:41:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <20210723054106.GA31771@lst.de>
References: <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com> <20210514133143.GK1096940@ziepe.ca> <YKJf7mphTHZoi7Qr@8bytes.org> <20210517123010.GO1096940@ziepe.ca> <YKJnPGonR+d8rbu/@8bytes.org> <20210517133500.GP1096940@ziepe.ca> <YKKNLrdQ4QjhLrKX@8bytes.org> <BN9PR11MB54331FC6BB31E8CBF11914A48C019@BN9PR11MB5433.namprd11.prod.outlook.com> <20210722133450.GA29155@lst.de> <BN9PR11MB5433440EED4E291C0DCD44BA8CE59@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433440EED4E291C0DCD44BA8CE59@BN9PR11MB5433.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 23, 2021 at 05:36:17AM +0000, Tian, Kevin wrote:
> > > And a new set of IOMMU-API:
> > >
> > >     - iommu_{un}bind_pgtable(domain, dev, addr);
> > >     - iommu_{un}bind_pgtable_pasid(domain, dev, addr, pasid);
> > >     - iommu_cache_invalidate(domain, dev, invalid_info);
> > 
> > What caches is this supposed to "invalidate"?
> 
> pasid cache, iotlb or dev_iotlb entries that are related to the bound 
> pgtable. the actual affected cache type and granularity (device-wide,
> pasid-wide, selected addr-range) are specified by the caller.

Maybe call it pgtable_invalidate or similar?  To avoid confusing it
with the CPUs dcache.
