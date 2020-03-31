Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2689A1990E0
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 11:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731895AbgCaJPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 05:15:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59502 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730719AbgCaJPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 05:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6OrjNgWSgjsVgH6reFO8z2ixicWhI/e5FNsva6w55pc=; b=jpt/K2zABPB39L9L1UfINWG0kU
        a0UjPT+0UTlvycvxpmjj3Mq1U8yayR5ZBsKUzFqvVDicdd32QYL8er5THUVvNLjGiyRPX6Z0kFicC
        0RtlvWV12hqst+lQ525f5GfHeel9HHwSoCjB3llxC5VE7FRMnUyWYu3qe7XgP9eI0W9hp8Eu2kUpr
        uIGgzewZCfwXyV/L98BrMA9AFZVx/7HoQZSCb1RBkCthBzxi4l54KdNjQIi9AwIge4lH74tkMMEBb
        6yoBbH1EnjdQJDw9b98IH3iFRCgGvJZo/BoFJ3FRlm4BIngrmV638qrHeyqKdgUce/pjZXG2YKzTj
        7sCTm1RA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJCzF-0004Sr-Ij; Tue, 31 Mar 2020 09:15:09 +0000
Date:   Tue, 31 Mar 2020 02:15:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, "Wu, Hao" <hao.wu@intel.com>
Subject: Re: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Message-ID: <20200331091509.GA12040@infradead.org>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
 <20200331075331.GA26583@infradead.org>
 <A2975661238FB949B60364EF0F2C25743A21A9BB@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A21A9ED@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A21A9ED@SHSMSX104.ccr.corp.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 08:36:32AM +0000, Liu, Yi L wrote:
> > From: Liu, Yi L
> > Sent: Tuesday, March 31, 2020 4:33 PM
> > To: 'Christoph Hellwig' <hch@infradead.org>
> > Subject: RE: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
> > 
> > > From: Christoph Hellwig <hch@infradead.org>
> > > Sent: Tuesday, March 31, 2020 3:54 PM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [PATCH v1 1/8] vfio: Add
> > > VFIO_IOMMU_PASID_REQUEST(alloc/free)
> > >
> > > Who is going to use thse exports?  Please submit them together with a
> > > driver actually using them.
> the user of the symbols are already in this patch. sorry for the split answer..

Thanks, sorry for the noise!
