Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614BC306261
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 18:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344046AbhA0Rny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbhA0Rn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 12:43:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CF6C06174A;
        Wed, 27 Jan 2021 09:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xd+uIcB9boMDv2AI+keRyfyXEtS7DSKuNnB+UiVIp6E=; b=wYIx+FrtwtEd9dbfWzT3RY+FCV
        x6CfTpNoKT+FirsTDPbw8V6iuNR9G+bUTYrJ1cIO4EaB84E+wu+/1SzSeGtuVBb+8qxPx+HjjUMT/
        Bqbt79SQrlIulDCBLow9jY1kzc5LyVgv44chulcZVPnSM9xDSTnVgiaLfx9WgUcNalAlPnoVsUp7d
        dGR4pcZEqv9MDSt9mAGcL5ipW91I/1W+8kJG/T5VwRmxGdC/vua+gtPw0dXpDNyZw9zM3WT8wyjGJ
        /ghuacrfs9tqhEAapZAXuxLrqcazqXG8Nidek+P+mvcAReVOXBdb0wjo0KhQMc/IyMplCVgnDi3xE
        vcVhk/wQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4opj-007Iqm-36; Wed, 27 Jan 2021 17:42:27 +0000
Date:   Wed, 27 Jan 2021 17:42:23 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>, wanghaibin.wang@huawei.com,
        yuzenghui@huawei.com
Subject: Re: [RFC PATCH v1 2/4] vfio: Add a page fault handler
Message-ID: <20210127174223.GB1738577@infradead.org>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210125090402.1429-3-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125090402.1429-3-lushenming@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021 at 05:04:00PM +0800, Shenming Lu wrote:
> +EXPORT_SYMBOL_GPL(vfio_iommu_dev_fault_handler);

This function is only used in vfio.c itself, so it should not be
exported, but rather marked static.
