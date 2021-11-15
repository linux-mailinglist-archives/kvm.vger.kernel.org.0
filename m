Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C817D450556
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhKON1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhKON0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:26:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBECC061766;
        Mon, 15 Nov 2021 05:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=X1ITeHe+ujLogHoHoBslh2b+KYlgavcC5p3THMJ3Fac=; b=J7e9HUHbL4CLr6zXYZB1KWdrgK
        QJ6bhZlwWp7YziATK7pczR9iPQe0Ak47PaLoL7UnJ8J6H5127j8nPQnJza0LPfx2oxpyraSXAR3+W
        sio+BzJ4VjWlOtOw8HrlPwTKQzIxnqwxtTLGMaQc6W5y9NY9TQtnIMXLoCxhvgRu3+O296eQUNkgY
        kNh/waAURt3KN9jKL8RedrNPBJPg4mkdlZ8cwV5OP37nWnznpw/aQE0khEqlQW+SgHvkvYCa3L602
        mu+yJotuIfojwsZFxdAXIe5imbLWJ9m2+2ksQD3+29iLNft2lK2SAJNfZNSGEEFiu1iBbrGOog/xr
        UrEGg8Ug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmbwo-00FeeB-6C; Mon, 15 Nov 2021 13:22:58 +0000
Date:   Mon, 15 Nov 2021 05:22:58 -0800
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
Subject: Re: [PATCH 05/11] iommu: Add security context management for
 assigned devices
Message-ID: <YZJfMg8O/y4aLf8Q@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-6-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115020552.2378167-6-baolu.lu@linux.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:05:46AM +0800, Lu Baolu wrote:
> +			/*
> +			 * The UNMANAGED domain should be detached before all USER
> +			 * owners have been released.
> +			 */

Please avoid comments spilling over 80 characters.
