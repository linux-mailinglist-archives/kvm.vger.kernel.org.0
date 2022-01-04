Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05972484219
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 14:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiADNIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 08:08:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49696 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiADNIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 08:08:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 625E96135E;
        Tue,  4 Jan 2022 13:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130B1C36AEF;
        Tue,  4 Jan 2022 13:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641301692;
        bh=mT5t79gxCgRdT1vNcMcGQnrvh/Z6pQHv2BwjqHfeFy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fKRY9zkTPp3BP+ryztGtFWSEw0kyX0BM2Uf2v3VZK6GCUVOr6rnw3hzih2LhKe2Wi
         YdL6yux9ihG5mBuIvYPn9TY2ER/O//0iHoOJ+kRPUZTH/pvUQr+jz5IqdmRogD9e9I
         zMvA2mLwuJ2ds7EvjPMoNPox+9VGjjtx5nfvN100=
Date:   Tue, 4 Jan 2022 14:04:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
Subject: Re: [PATCH v5 02/14] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <YdRFyXWay/bdSSem@kroah.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-3-baolu.lu@linux.intel.com>
 <YdQcpHrV7NwUv+qc@infradead.org>
 <20220104123911.GE2328285@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104123911.GE2328285@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 08:39:11AM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 04, 2022 at 02:08:36AM -0800, Christoph Hellwig wrote:
> > All these bus callouts still looks horrible and just create tons of
> > boilerplate code.
> 
> Yes, Lu - Greg asked questions then didn't respond to their answers
> meaning he accepts them, you should stick with the v4 version.

Trying to catch up on emails from the break, that was way down my list
of things to get back to as it's messy and non-obvious.  I'll revisit it
again after 5.17-rc1 is out, this is too late for that merge window
anyway.

thanks,

greg k-h
