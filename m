Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10B6406AC1
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 13:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhIJLf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 07:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbhIJLf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 07:35:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA530C061574;
        Fri, 10 Sep 2021 04:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=BSA2D1TnYPLzQN9YUPalhzKaRR
        BOXmsBGXOXmacvnLMW/tRQKn2mi7I7ANjeIl2fbr/6y1ABAsdhWU7lZKHXrtwbWAP3vWsqkXP75IH
        SsK9f6OVPJBA1TZlLhmEWlR4pkKiFQN+a8ZkfARCbE1KD76AgoWNe2jhFtdmvL4mv8lFXvj3WKspF
        86XhzvHC/eWY7ty/2+iLiS79XOgGTicvfYXjv4EQMonnghPvaLTyBmGPF8YxNlWhaUA2K4ay6H5CK
        CatMYntF3tfhIgHvppBvRZN3eV316w+GcLfpeGW6joKClcgw1nWJylPVQkk8Ld8Hl85l9zVqTVbOd
        OQi/tBSg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mOelw-00AxFg-Pd; Fri, 10 Sep 2021 11:33:03 +0000
Date:   Fri, 10 Sep 2021 12:32:44 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/9] vfio/ccw: Pass vfio_ccw_private not mdev_device
 to various functions
Message-ID: <YTtCXHrp605kqyvu@infradead.org>
References: <0-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
 <2-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

