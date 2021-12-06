Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AF046996A
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 15:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344574AbhLFOvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 09:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344085AbhLFOvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 09:51:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA57C061746;
        Mon,  6 Dec 2021 06:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TXFSmUvaU3cs7so6I58UjRnLfUrT8rfsvaCveH+MJuc=; b=ZiRLfAaJDzSkoPKw079EiQGN/7
        bxEKFwuhOQvYYSgZXv1b+xWvyFVzNDvrcTUJ8CrugUQ1MZGfwXs4qs+kRH5Pgd6FfqQeopylxTXM2
        KEihaEizzovXtpeHFOOrAAnufrDT2x88N8hCB8B/qerE1deCagPlmiZhGv8gWSZOaaFqyN/ErO9kq
        GsGzIMiW8kOtePhuvpDQsLXK5nzB8G8Gqt4vffNqzXweCO4qGKi2Iq1jBOxSkvZhESpY+FT0gTciQ
        YB7vf/L0oA6Kb6YnYNYmKh6qsr6h3cHGfoDvoYiah/Se/KBF6+VNPV1c9HXR9N0xVBgtLWK/Udv+u
        WSiZvg1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1muFHN-004GnQ-TB; Mon, 06 Dec 2021 14:47:45 +0000
Date:   Mon, 6 Dec 2021 06:47:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Stuart Yoder <stuyoder@gmail.com>, rafael@kernel.org,
        David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 03/18] driver core: platform: Rename
 platform_dma_configure()
Message-ID: <Ya4ikRpenoQPXfML@infradead.org>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-4-baolu.lu@linux.intel.com>
 <Ya3BYxrgkNK3kbGI@kroah.com>
 <Ya4abbx5M31LYd3N@infradead.org>
 <20211206144535.GB4670@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206144535.GB4670@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 10:45:35AM -0400, Jason Gunthorpe via iommu wrote:
> IIRC the only thing this function does is touch ACPI and OF stuff?
> Isn't that firmware?
> 
> AFAICT amba uses this because AMBA devices might be linked to DT
> descriptions?

But DT descriptions aren't firmware.  They are usually either passed onb
the bootloader or in some deeply embedded setups embedded into the
kernel image.
