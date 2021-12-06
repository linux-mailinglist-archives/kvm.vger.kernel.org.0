Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3B34690F8
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 08:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbhLFH4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 02:56:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59134 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhLFH4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 02:56:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42EB661175;
        Mon,  6 Dec 2021 07:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F66DC341C2;
        Mon,  6 Dec 2021 07:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638777191;
        bh=soSlk3MBczahgBfafp8U9UAyjF43LWFYVH/GoS2WyFw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iuKpbSmCNPQKVV2uMZmjGsVnK63LAVPXMIdIJN3+kY8zC6vgxKMBkxFLtn1Y7HpLf
         Mlz939JS+5PsrgimZK0D5QTRayqWT2WhDvGym53xEhm3bnULdIi7COix+8/oJwqCh7
         4UORKW6SE516xudv0usYnGOsKn9VKjkqilBTp068=
Date:   Mon, 6 Dec 2021 08:53:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v3 03/18] driver core: platform: Rename
 platform_dma_configure()
Message-ID: <Ya3BYxrgkNK3kbGI@kroah.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-4-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206015903.88687-4-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 09:58:48AM +0800, Lu Baolu wrote:
> The platform_dma_configure() is shared between platform and amba bus
> drivers. Rename the common helper to firmware_dma_configure() so that
> both platform and amba bus drivers could customize their dma_configure
> callbacks.

Please, if you are going to call these functions "firmware_" then move
them to the drivers/firmware/ location, they do not belong in
drivers/base/platform.c anymore, right?

thanks,

greg k-h
