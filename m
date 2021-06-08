Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B5039EEA9
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhFHGZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhFHGZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:25:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1685BC061574;
        Mon,  7 Jun 2021 23:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pidZWnJJ6gz2A6wzfnaMu3Ow+RsQIOTqliEJEwy2SBg=; b=Do0OvGKZWFBzesb+EK6thlbam/
        39qr2uMPTGLHOJ4r8FRXwqaw/tjH5l9VECXlVdqSE6MegO65aX+bDbc9MrsDECcxNTFBwkyg9YX4E
        z/HvBFfVysr9lf7mm9hdovnARx1ALwE9w3Up5fxlW/uH2zLt8dtrbOlT23GSk572w8ashbVAqw+Vn
        6ywpabjCbB0DD23E5HeC2RODLI4gAlPmRZJ1FvA1CBGrQ9ZJRNJaWEQRIKFXQLBD49+ymDGYBVQ6g
        QwSZZB6J+JFE3t6YJWH3TJ7I2cZUtYaaaxD7SGemCpz444KyeOl6tSy7VHbXaPyXXrjb5k8Bx1Cd7
        I6rTzT0Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqV8a-00Gd0M-IH; Tue, 08 Jun 2021 06:23:00 +0000
Date:   Tue, 8 Jun 2021 07:22:56 +0100
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/10] Allow mdev drivers to directly create the
 vfio_device
Message-ID: <YL8MwDf2z1KBlqLn@infradead.org>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Btw, you list of CCs is a mess as alsmost no one is CCed on the whole
list can can thus properly review it.
