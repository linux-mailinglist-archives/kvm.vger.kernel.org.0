Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC31318682
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 09:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhBKIvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 03:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhBKIuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 03:50:03 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D89C061794;
        Thu, 11 Feb 2021 00:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l1+6e7rFpYlfyI8qoKpQ1E+YQ+7nwVtVLJAshVxQsM4=; b=QjYCwsPezJFcO3wkwsOvb2OFQZ
        RzgZt9SoyEBB5JqsSM4lzOp18K/rVaX7Ts4/MTNqtvfKIHhpThPfTVRQy/763W3sUO5RuaRW00Xrn
        P3icq5lXGXuYprfgkv3BuPf0QBtQOIuitlZaipXM9lCMWIVu+HXfxcWup39gAn9hCl52ragiRCQL5
        xu+894XZTeL9za3Dc8GkhXbn1yAnmJ12S6r4lYSutVVN4oqvvuq/Svs51ESQAGAGYkwl/adOq+8qN
        BjetPsE6Km2ZyfecembkjmEX1zCLBsvLy7denBtWppbYmssjioqfFLIKgC8O/JW0spvNM1Figvo60
        BjnXhGbg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lA7g5-009zly-Hn; Thu, 11 Feb 2021 08:50:22 +0000
Date:   Thu, 11 Feb 2021 08:50:21 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, gmataev@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210211085021.GD2378134@infradead.org>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <806c138e-685c-0955-7c15-93cb1d4fe0d9@ozlabs.ru>
 <6c96f41a-0daa-12d4-528e-6db44df1a5a6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c96f41a-0daa-12d4-528e-6db44df1a5a6@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021 at 11:12:49AM +0200, Max Gurtovoy wrote:
> But the PCI function (the bounded BDF) is GPU function or NVLINK function ?
> 
> If it's NVLINK function then we should fail probing in the host vfio-pci
> driver.
> 
> if its a GPU function so it shouldn't been called nvlink2 vfio-pci driver.
> Its just an extension in the GPU vfio-pci driver.

I suspect the trivial and correct answer is that we should just drop the
driver entirely.  It is for obsolete hardware that never had upstream
support for even using it in the guest.  It also is the reason for
keeping cruft in the always built-in powernv platform code alive that
is otherwise dead wood.
