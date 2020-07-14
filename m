Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E5621EB3B
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 10:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgGNIZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 04:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgGNIZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 04:25:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3F8C061755;
        Tue, 14 Jul 2020 01:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NEZwXm7zIVwhexgTBK1mEJLmzgEMI2bgToX51xgqmB0=; b=qnPEx8f4QgxTMq/2KZsUkeDNlG
        lZfLmt7MLBU63aX/MGMi+nxcE1QmuHryMIyjOczvhvnFS2J/cvl3KN3OmqTbIpeFbsYS1m6vjNQhq
        KbFw214YQziN+ILm/P83k8PuU46L9xdltVo4jheS3j5Q/kf1Yv/4RyUh03ezKx5wAYRaR4E4FRbmx
        7C6WoeDC6sflqomvZ0IF9pum3PatfKWKCaOToAiEtg37L9MJiZZabBYb+Rh/J0xvENC+uFmi/562u
        tHd/YE9sQs3rul9Hj+lm8f6624cznt1/ZH9P7/Qo8KVTpr4xRS6Ks5E2gSrLRDQSWET7Jr3s6+CL+
        na47ColA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvGFW-00084s-HT; Tue, 14 Jul 2020 08:25:14 +0000
Date:   Tue, 14 Jul 2020 09:25:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group() APIs
Message-ID: <20200714082514.GA30622@infradead.org>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
 <20200714055703.5510-5-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714055703.5510-5-baolu.lu@linux.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 01:57:03PM +0800, Lu Baolu wrote:
> Replace iommu_aux_at(de)tach_device() with iommu_aux_at(de)tach_group().
> It also saves the IOMMU_DEV_FEAT_AUX-capable physcail device in the
> vfio_group data structure so that it could be reused in other places.

This removes the last user of iommu_aux_attach_device and
iommu_aux_detach_device, which can be removed now.
