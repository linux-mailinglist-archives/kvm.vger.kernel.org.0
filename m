Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E083241E631
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 05:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351662AbhJAD0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 23:26:23 -0400
Received: from verein.lst.de ([213.95.11.211]:33465 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230283AbhJAD0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 23:26:22 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E0CAA67373; Fri,  1 Oct 2021 05:24:34 +0200 (CEST)
Date:   Fri, 1 Oct 2021 05:24:34 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20211001032434.GB16450@lst.de>
References: <20210919063848.1476776-11-yi.l.liu@intel.com> <20210922152407.1bfa6ff7.alex.williamson@redhat.com> <20210922234954.GB964074@nvidia.com> <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com> <YUxTvCt1mYDntO8z@myrica> <20210923112716.GE964074@nvidia.com> <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com> <20210923122220.GL964074@nvidia.com> <BN9PR11MB5433F33CB7CFBCD41BE2F5C68CAA9@BN9PR11MB5433.namprd11.prod.outlook.com> <9a04c421-4a25-f1de-a896-321026b3f0ce@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a04c421-4a25-f1de-a896-321026b3f0ce@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 09:43:58PM +0800, Lu Baolu wrote:
> Here, we are discussing arch_sync_dma_for_cpu() and
> arch_sync_dma_for_device(). The x86 arch has clflush to sync dma buffer
> for device, but I can't see any instruction to sync dma buffer for cpu
> if the device is not cache coherent. Is that the reason why x86 can't
> have an implementation for arch_sync_dma_for_cpu(), hence all devices
> are marked coherent?

arch_sync_dma_for_cpu and arch_sync_dma_for_device are only used if
the device is marked non-coherent, that is if Linux knows the device
can't be part of the cache coherency protocol.  There are no known
x86 systems with entirely not cache coherent devices so these helpers
won't be useful as-is.
