Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FFA39EE9E
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhFHGXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHGXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:23:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC93DC061574;
        Mon,  7 Jun 2021 23:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=hiTxBqbaLttqm4BdURpATNL1iC
        s7aQT+WVGJb0K6aYPAlbuESXc7MqmIBEbRLGnqVxlrXmy2gKTGVG9gVTiVQUOdD0LRNSBuaQKAnsx
        FGavFuB3HAYcEnjm1VwpRLxTTUva4XdTvGosK/Mo6fuYTZsaye1LseKNEUMKilA4j3b7haIIcqhyP
        T0CaX7xL8xUydINIFymNuUXLDxVOooRHFJaHm6va1yEqTKbIEcgWAQMm0yTvN599OsHT00j2v/tEN
        ij1EKhnYWyoafelh6WZq90uUdsFdXvYHixBOMcPBpyeuWXrRJFfX2ly10VRITJz+4R0+cr/HTmq0H
        NrATKsBQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqV6K-00Gcuy-H9; Tue, 08 Jun 2021 06:20:42 +0000
Date:   Tue, 8 Jun 2021 07:20:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 06/10] vfio/mdev: Remove CONFIG_VFIO_MDEV_DEVICE
Message-ID: <YL8MNA0SAt3FQCtU@infradead.org>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <6-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
