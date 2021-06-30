Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C000C3B7DC9
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 09:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhF3HEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 03:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhF3HEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 03:04:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEC9C061766;
        Wed, 30 Jun 2021 00:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PoknwIAy8Q9q+U6w+2a12vknwq+F35xgmvor8JHbCT0=; b=lhnHlNjmjExRd4kOidxPSUtHCF
        lThr4z+W8p4z9I5Y0rKEDt2xxMBs6nqRsTPYUcwm01rqZGiL6BhwMqG70F9eJyhIh5NUvA1BGqqng
        JVQ4sw5ouU8XKwWoMKDDo/2UQM4xLgLIsJobhS04QOf37hoyxdpTBlTWOa/xRlMM7SvDue9WSLdzw
        dXizTRiFfG3ZU8vVDW6II2yjz1FclnXukf/xHjRSJz4pjnPXinchMsgdHyLWM8lZv6s0EYUqr4/kq
        Uf8NR9mabxA6Qwpt1ElKsJdmFLdqvCWzrLZdJgwPFbYpSkA1aNI8jrMOE1cb4BVyBY4MLZo3/IEZb
        8wWXiC1Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lyUDz-005199-Qi; Wed, 30 Jun 2021 07:01:38 +0000
Date:   Wed, 30 Jun 2021 08:01:31 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YNwWy/j+diR7Y4Iv@infradead.org>
References: <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <MWHPR11MB18861A89FE6620921E7A7CAC8C369@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210609115759.GY1002214@nvidia.com>
 <086ca28f-42e5-a432-8bef-ac47a0a6df45@redhat.com>
 <20210609124742.GB1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609124742.GB1002214@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 09:47:42AM -0300, Jason Gunthorpe wrote:
> I can vaugely understand this rational for vfio, but not at all for
> the platform's iommu driver, sorry.

Agreed.  More importantly the dependency is not for the platform iommu
driver but just for the core iommu code, which is always built in if
enabled.
