Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864BE3E7B8C
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 17:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242367AbhHJPB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 11:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242012AbhHJPBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 11:01:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84DCC0613C1;
        Tue, 10 Aug 2021 08:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MSp6l2hgXetpjg33UemgY27yhcP0v9LaaxkMtKb3f5g=; b=Zv/C97WdVKRqZf7VzYDYCZojXO
        h6kVeMtrAfAj6ybNnRe0hUeysNo85aa33bbJ67MJmUobmKoqG5mqI1MrZ9YXYEbypd4rup8h2loLM
        krymPd2yEpOIw07ARS0lXOrtgPjPscqIIAs+9r+gg9luATsGHUJQiRRSB39bFhYOCpdJWHEJhWI5i
        equ9J7JM2uiAGHfGBmOw1Andl7TVqKJs4dFUL9qrPAiiUG+oIomqi+i3I2zgFuCdEe+RdCheMwigQ
        V8Gz24Q08SUTxa1TwKbgAfRHYwEI5klrSpQCmrtNzdNjdkGNqmWDDMV6IQQsBlkIcc7cLskM1Xfc3
        bOKL4gsQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDTC5-00CFbI-Jy; Tue, 10 Aug 2021 14:57:49 +0000
Date:   Tue, 10 Aug 2021 15:57:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 1/7] vfio: Create vfio_fs_type with inode per device
Message-ID: <YRKT2UhgjfWBmwuJ@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818322947.1511194.6035266132085405252.stgit@omen>
 <YRI8Mev5yfeAXsrj@infradead.org>
 <20210810085254.51da01d6.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810085254.51da01d6.alex.williamson@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 08:52:54AM -0600, Alex Williamson wrote:
> On Tue, 10 Aug 2021 10:43:29 +0200
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > > + * XXX Adopt the following when available:
> > > + * https://lore.kernel.org/lkml/20210309155348.974875-1-hch@lst.de/  
> > 
> > No need for this link.
> 
> Is that effort dead?  I've used the link several times myself to search
> for progress, so it's been useful to me.  Thanks,

No, but it seems odd to have reference to an old patchset in the kernel
tree.
