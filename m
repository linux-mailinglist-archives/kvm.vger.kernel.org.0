Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5C3332092
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhCIIbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhCIIb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:31:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DB6C06174A;
        Tue,  9 Mar 2021 00:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+OxzKs19Zpvl6S+NVCKz6RNoVaYOhOfTcWyRsNV00AA=; b=Y/pxptCeqZ45KmIt5CKC9nAPYv
        CecKPeJVr7vAfX1vCilis/7CJUb8NDZYNqCvvBl5LSYpbFiQl84PQijzkMd64W14ScdG4lAL0H+eA
        0+6v1WP9Br22XZTPadPL7pYtifkgMr1GUG10GO+UGadRhZIHOUqIWO15STo7dVdtCN73O1aQb8cuB
        8K5VzC3+Z2XIe1s7/Ww8MtwOAiIBuXhhLIPnvPO8U7LF1u9u2q0BE5sTbV4HbFV0ikViBwNN5svD+
        /0zoB4K3r9u0M31WAJFbMP51Zm51N4QMFkf7eItd1r+bgMueEpTeFDwu6A6mb0UuVhFtvxQJPqIbT
        Iui6G0Vg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJXlr-000Ez9-No; Tue, 09 Mar 2021 08:31:16 +0000
Date:   Tue, 9 Mar 2021 08:31:15 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH v1 14/14] vfio: Cleanup use of bare unsigned
Message-ID: <20210309083115.GA55734@infradead.org>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524018910.3480.774661659452044338.stgit@gimli.home>
 <20210309010745.GC2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309010745.GC2356281@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 09:07:45PM -0400, Jason Gunthorpe wrote:
> Indeed, checkpatch has been warning about this too

And checkaptch as so often these days is completely full of shit.
There is ansolutely not objective reason against using bare unsigned
except for a weird anal preference of a checkpatch author.
