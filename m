Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893C041E630
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 05:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351568AbhJADV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 23:21:56 -0400
Received: from verein.lst.de ([213.95.11.211]:33451 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230283AbhJADV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 23:21:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5C5FA67373; Fri,  1 Oct 2021 05:20:10 +0200 (CEST)
Date:   Fri, 1 Oct 2021 05:20:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Message-ID: <20211001032010.GA16450@lst.de>
References: <20210913071606.2966-1-hch@lst.de> <20210913071606.2966-12-hch@lst.de> <c4ef0d8a-39f4-4834-f8f2-beffd2f2f8ae@nvidia.com> <20210916221854.GT3544071@ziepe.ca> <BN9PR11MB54333BE60F997D3A9183EDD38CDD9@BN9PR11MB5433.namprd11.prod.outlook.com> <20210917050543.GA22003@lst.de> <8a5ff811-3bba-996a-a8e0-faafe619f193@nvidia.com> <20210917125301.GU3544071@ziepe.ca> <20210930104620.56a1d3e9.alex.williamson@redhat.com> <20210930165707.GA69218@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930165707.GA69218@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 01:57:07PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 30, 2021 at 10:46:20AM -0600, Alex Williamson wrote:
> > I'm only aware that the PF driver enables basic SR-IOV configuration of
> > VFs, ie. the number of enabled VFs. 
> 
> This is quite common in the netdev world, for instance you use the PF
> driver to set the MAC addresses, QOS and other details on the VF
> devices.

The NVMe spec also support it using the Virtualization extensions,
although I'm not aware of any device that actually implements it so far.

> 
> > only management of the number of child devices, but the flavor of each
> > child, for example the non-homogeneous slice of resources allocated per
> > child device.
> 
> Since the devices are PCI VFs they should be able to be used, with
> configuration, any place a PCI VF is usable. EG vfio-pci, a Kernel
> driver, etc.
> 
> This is why the PF needs to provide the configuration to support all
> the use cases.

Exactly.
