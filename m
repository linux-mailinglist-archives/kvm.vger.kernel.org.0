Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A566D337119
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 12:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhCKLYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 06:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbhCKLY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 06:24:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78742C061574;
        Thu, 11 Mar 2021 03:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VgJkfd1f0uwuzg/HHQ3CmI2XI77w+uDa0yfpBIMBGxo=; b=GQq0JuW5kKrnclgA/eW32hQPWJ
        9ivjeAiJABIY6QV8HWgHfBUAhJzW+DUoNz1Pf1Wc+yPPHDZgS+OylvYHZqFpgca0SNIu1JLoT/6GZ
        oMblex8Ezo126S6+MJh1W07zuol33oHVfDoNcE43I9fCsedn/yELZJg7VEtWa8rNfdy/tEagF68S+
        Uj3GbcZlIthteVywvokgViIQYx+RfKuoyC4myWRpWb/MwBKvfDMUJAi2oAWTFH0OzVJa0XeCaEv7L
        Mz9cBkq/4M24yxZT8IkGkBNqghPB3/FqR96EN93vojTTXSqi6Jk0uKI8lDqP5fw3iDD5RFCfhyu6N
        7MHsHiDg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKJQ5-007F5x-Hl; Thu, 11 Mar 2021 11:24:02 +0000
Date:   Thu, 11 Mar 2021 11:23:57 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH v1 02/14] vfio: Update vfio_add_group_dev() API
Message-ID: <20210311112357.GA1725994@infradead.org>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524006056.3480.3931750068527641030.stgit@gimli.home>
 <20210310074838.GA662265@infradead.org>
 <20210310121913.GR2356281@nvidia.com>
 <20210310082805.29813cad@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310082805.29813cad@omen.home.shazbot.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 08:28:05AM -0700, Alex Williamson wrote:
> > Yes, that series puts vfio_device everywhere so APIs like Alex needs
> > to build here become trivial.
> > 
> > The fact we both converged on this same requirement is good
> 
> You're ahead of me in catching up with reviews Christoph, but
> considering stable backports and the motivations for each series, I'd
> expect to initially make the minimal API change and build from there.

Given how many exploitable bugs the work from Jason has found/fixed
I'd rather do it properly.  As most of this will have to be backported
for anyone who cares.
