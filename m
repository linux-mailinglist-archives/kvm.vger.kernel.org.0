Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C84D3B7DD7
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 09:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhF3HLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 03:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbhF3HLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 03:11:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C92C061766;
        Wed, 30 Jun 2021 00:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p7u2nhiPZvS5G76wt+ReyJp7BmL9rTijTlM9kJWCQB0=; b=jU5tD1CKWUN2AvCok5TsR6gq5q
        81SLjO6tt7FaxBgRBWbUqVQXYcd+87wzkSA8t5M/0YIYGHDaAwJ4mVWYqS08CyL9xA6xYGazt+zVu
        HrOCne0sUDUViBVSpeOcH9BlQuxUE5WmHnJVoZsMw3FEjm0KkUb8Aq2UrpreawCFSPumgz0hExF8S
        em/wR9b6nST13qoCMk80+oupPxiPawRJp+WiDrdGomoU04Ed39H4EOEgR4+PX08HWhhS+5oSGU4kD
        zqug+xGjvphgGP9lDwW0JcYkroBQHh5Yo7oW/WgF188MFE86PE4qMxwhIKJNTjr1CtqGaHMXS8Mwm
        WKtY+Mxw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lyUK4-0051XX-C6; Wed, 30 Jun 2021 07:07:57 +0000
Date:   Wed, 30 Jun 2021 08:07:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YNwYREuSWElXwiAC@infradead.org>
References: <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
 <6a9426d7-ed55-e006-9c4c-6b7c78142e39@redhat.com>
 <20210603130927.GZ1002214@nvidia.com>
 <65614634-1db4-7119-1a90-64ba5c6e9042@redhat.com>
 <20210604115805.GG1002214@nvidia.com>
 <895671cc-5ef8-bc1a-734c-e9e2fdf03652@redhat.com>
 <20210607141424.GF1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607141424.GF1002214@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 11:14:24AM -0300, Jason Gunthorpe wrote:
> "non-coherent DMA" is some general euphemism that evokes images of
> embedded platforms that don't have coherent DMA at all and have low
> cost ways to regain coherence. This is not at all what we are talking
> about here at all.

It literally is the same way of working.  And not just low-end embedded
platforms use this, but a lot of older server platforms did as well.
