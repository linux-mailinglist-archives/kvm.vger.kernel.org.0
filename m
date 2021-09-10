Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86290406B3C
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 14:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhIJMNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 08:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbhIJMNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 08:13:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC946C061574;
        Fri, 10 Sep 2021 05:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wfe0wRNwadGuipT2q3vfuqzKoGJ2bWIK7Uw5w2tgJTc=; b=EGI6r5rOor4TTYVJT2LtMloVb3
        uaAaLVZkg7VF0gnAd+Efe3guV4pPIj/J6pwSyX+4dJNTyeBg1tFkhH8a9EiKTRVrjv7HQQ8x+ojmf
        Qkmw8rk5YO5ZXSjUEmP3XHBloWs2RV0ClS+1YFDNXyIYLYiyvpJq71V6uttxDmeFC6My7NBuwzwRC
        qLHVNIhU//sE3mHPQCPTk36mbmi49QN8W1zM6uAtXW0oHVCGIDbLhQrSMontgY+fEmRtCGJksCRQr
        Ge4EbGvO04IP5g8z0jByUOXvHNoA5qHXSpkvx/n4R1DABL0qvTg70y3HsTi2J4/onsRTgtPZoXPGY
        c2Lzj6TQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mOfMk-00Az2M-HA; Fri, 10 Sep 2021 12:10:58 +0000
Date:   Fri, 10 Sep 2021 13:10:46 +0100
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
Subject: Re: [PATCH v2 5/9] vfio/mdev: Consolidate all the device_api sysfs
 into the core code
Message-ID: <YTtLRmiXq+QtJ+la@infradead.org>
References: <0-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
 <5-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 04:38:45PM -0300, Jason Gunthorpe wrote:
> Every driver just emits a static string, simply feed it through the ops
> and provide a standard sysfs show function.

Looks sensible.  But can you make the attribute optional and add a
comment marking it deprecated?  Because it really is completely useless.
We don't version userspace APIs, userspae has to discover new features
individually by e.g. finding new sysfs files or just trying new ioctls.
