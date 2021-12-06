Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1D1469854
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 15:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343490AbhLFOQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 09:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245673AbhLFOQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 09:16:55 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743B0C0613F8;
        Mon,  6 Dec 2021 06:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mC4snFvmVQItGI2siC8cGfUb3byxoiOnKLgqdbmyMcQ=; b=dm7wjbftIMFsPJba8CxJwPYFy6
        uS4LcWXMZyawxLsDstv//jKrvkkHN+K8djaQ9PmBo+FuSeobcozb4MOeufoogygP0+rlwIkwY2/Lb
        YztWWXYFwjNwhu7BSLU7so/EDmhQJy5DJ4roZQzwr7AF355d551CeeJebeRRvGZYkQuhCs5bDRjFz
        iPECqpnqCnVu4wob3boG1SDiKIKEfKgCdXaDM7Jj/r+naHsJxe/6Kf/dg/9NIs5u7zEj8eQ7TLKDJ
        00rvqUZ+3bx4d5MXtYgjsLNW7Kc4fFN1xevpOCSdinVsUvjOlriMW9vHzk7xfP83Aud2bNDDIOiI8
        qjWDRv6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1muEjl-004ADO-Gv; Mon, 06 Dec 2021 14:13:01 +0000
Date:   Mon, 6 Dec 2021 06:13:01 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <Ya4abbx5M31LYd3N@infradead.org>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-4-baolu.lu@linux.intel.com>
 <Ya3BYxrgkNK3kbGI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya3BYxrgkNK3kbGI@kroah.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 08:53:07AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Dec 06, 2021 at 09:58:48AM +0800, Lu Baolu wrote:
> > The platform_dma_configure() is shared between platform and amba bus
> > drivers. Rename the common helper to firmware_dma_configure() so that
> > both platform and amba bus drivers could customize their dma_configure
> > callbacks.
> 
> Please, if you are going to call these functions "firmware_" then move
> them to the drivers/firmware/ location, they do not belong in
> drivers/base/platform.c anymore, right?

firmware seems rather misnamed anyway, amba doesn't reall have anything
to do with "firmware".
