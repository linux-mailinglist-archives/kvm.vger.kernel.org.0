Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F757450550
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhKONZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbhKONY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:24:56 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D596C061225;
        Mon, 15 Nov 2021 05:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q5vmI1sLQc7WBeWiEcoCC5hdqAXg7eZXSsi4VpfCULU=; b=Td7N6ctXpcs2dVqXN7Qpr7SxrL
        kVXjwXhqusuAFtzaPRBpznWe9j1D+UT0HM42dq8V+VGeYHC6fS83HoqhgyefLhaTLAS7hkFQuzCpC
        /qguR5hUzJohytnQwH/t6UAmPZvSAJ5LYd90wSNtLNyxtg/yrLMa64lk/hunSm1ZcDCDthXvOZcAx
        /8ROJe/cS9Ak5wX+ThA6F4G+417rQhdxaXyVMoNEOlAFOr7T+oFwBH3JqPCpU7dbuk5dQllE2eFgx
        ucr8T4bSRDtLrN6I7ww82K1NvuLNDXgXNhiRcaWT8zIfBTSOuuh6kSCCuh1JD4s4nCyMVzwW5FVij
        rXpuPL3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmbvK-00FeMO-NI; Mon, 15 Nov 2021 13:21:26 +0000
Date:   Mon, 15 Nov 2021 05:21:26 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 03/11] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <YZJe1jquP+osF+Wn@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-4-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115020552.2378167-4-baolu.lu@linux.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:05:44AM +0800, Lu Baolu wrote:
> pci_stub allows the admin to block driver binding on a device and make
> it permanently shared with userspace. Since pci_stub does not do DMA,
> it is safe.

If an IOMMU is setup and dma-iommu or friends are not used nothing is
unsafe anyway, it just is that IOMMU won't work..

> However the admin must understand that using pci_stub allows
> userspace to attack whatever device it was bound to.

I don't understand this sentence at all.
