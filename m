Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA68A460541
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 09:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356997AbhK1IQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 03:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhK1IOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 03:14:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29ABC061574;
        Sun, 28 Nov 2021 00:11:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5514B80935;
        Sun, 28 Nov 2021 08:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F14C004E1;
        Sun, 28 Nov 2021 08:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638087062;
        bh=5mwb19/SHMi03iwE7udtKKydPp4JSsXL3XurwhuFH3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0K2ApgpytQUtBR+gHf0XQ4IVfREvcAcvqrRQCFEkSEh4tyg/4RgsWQPWnCzG8fTEe
         SH/XrehDyc5gpu5nvByHKqYX1D6pMeTw48b05fwQywetPn0B+Oiv4yzdzHaaVFDXoe
         g7AmRL+Ek0wMH4ULJlhFBJB83junJ0MyrsoK//p8=
Date:   Sun, 28 Nov 2021 09:10:58 +0100
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
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/17] Fix BUG_ON in vfio_iommu_group_notifier()
Message-ID: <YaM5ko+VkJUT7ZDs@kroah.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128025051.355578-1-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 28, 2021 at 10:50:34AM +0800, Lu Baolu wrote:
> The original post and intent of this series is here.
> https://lore.kernel.org/linux-iommu/20211115020552.2378167-1-baolu.lu@linux.intel.com/

Please put the intent in the message, dont make us go and dig it up
again.

thanks,

greg k-h
