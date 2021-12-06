Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3DD469945
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 15:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344485AbhLFOqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 09:46:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55436 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344473AbhLFOqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 09:46:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8298EB810D5;
        Mon,  6 Dec 2021 14:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B474DC341C1;
        Mon,  6 Dec 2021 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638801795;
        bh=dLZIKQpKdKtxDPgpZFmL25kRZRvrB+ZQ2CAp8/gAQy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yUEWwjcnl1StxRxd+FxRUQpyqMq2luDtTkAZtiqYJUqpdlx0FQ7eXzOmN15vhsrzn
         z1PUVG53jTORW9qdvfrGF9R1RSVWPYfYm66qqVIrxz2gvbsmeCcjTC128yt5TdZ+/Y
         Jt427GiweG8+QQYUhdjCTgcVSi4qFR1iGpnwpYCo=
Date:   Mon, 6 Dec 2021 15:43:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v3 03/18] driver core: platform: Rename
 platform_dma_configure()
Message-ID: <Ya4hgLjQNee+YFRW@kroah.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-4-baolu.lu@linux.intel.com>
 <Ya3BYxrgkNK3kbGI@kroah.com>
 <Ya4abbx5M31LYd3N@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya4abbx5M31LYd3N@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 06:13:01AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 06, 2021 at 08:53:07AM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Dec 06, 2021 at 09:58:48AM +0800, Lu Baolu wrote:
> > > The platform_dma_configure() is shared between platform and amba bus
> > > drivers. Rename the common helper to firmware_dma_configure() so that
> > > both platform and amba bus drivers could customize their dma_configure
> > > callbacks.
> > 
> > Please, if you are going to call these functions "firmware_" then move
> > them to the drivers/firmware/ location, they do not belong in
> > drivers/base/platform.c anymore, right?
> 
> firmware seems rather misnamed anyway, amba doesn't reall have anything
> to do with "firmware".

Then the name is not a good one and should be called something else :)
