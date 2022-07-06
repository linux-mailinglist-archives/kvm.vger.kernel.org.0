Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AC2567F0A
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 08:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiGFG4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 02:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiGFG4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 02:56:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3653F1CB0A;
        Tue,  5 Jul 2022 23:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/m24PsaB4Cz1aJpY2Cyju0n6At9XHWz5aCK5PGbqU1o=; b=X7/FBvhB9T2/CRNeMUuvEypKFb
        mD4tslMhbVmzWVE7SzYN0fXxNPgmANxnjxT2D6qxg2jDjE0bROkrGdpPBFAyPSO8FHnKUCIG/tgPV
        CMNagu0OUPgBs64PQS7P4nXbZgGlxj5VjAJ6nM6zqV7hQjSC6sKfZLLO0RJ0VL4NobI37zolQJAUN
        cAgI2u0JmXW32Dyx1G0/S+Yv9wxomqBEfcd4FRBh8980GD/IG+cC0BSRiZbJJO4/EubgDPvK8J0WA
        zOJSX/xDYsjpPpiNWA8VsEiOYtCIsjsjimpF4ualAySYR/TX0H9EHbt+3pK55aWBcTupeb+etyics
        m5+ajWhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8yxV-006rmp-Lm; Wed, 06 Jul 2022 06:56:25 +0000
Date:   Tue, 5 Jul 2022 23:56:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     kwankhede@nvidia.com, corbet@lwn.net, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, jchrist@linux.ibm.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFT][PATCH v2 4/9] vfio: Pass in starting IOVA to
 vfio_pin/unpin_pages API
Message-ID: <YsUyGS7kct2BbiS8@infradead.org>
References: <20220706062759.24946-1-nicolinc@nvidia.com>
 <20220706062759.24946-5-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706062759.24946-5-nicolinc@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -		vfio_unpin_pages(&q->matrix_mdev->vdev, &q->saved_pfn, 1);
> +		vfio_unpin_pages(&q->matrix_mdev->vdev, q->saved_pfn << PAGE_SHIFT, 1);

Overly long line here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
