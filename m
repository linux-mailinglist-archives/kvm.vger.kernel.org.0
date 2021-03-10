Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8159833369D
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 08:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhCJHtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 02:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCJHsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 02:48:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DF8C061761;
        Tue,  9 Mar 2021 23:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PPu2UvPAXkyCwFNg4js+GYjpdd291lCCF0Weo8KPpZk=; b=mXP8wHF6IsGSDLqffxgt2JYE83
        qwObZaj/YT82ac4J2iNq7TICkg37FIJdhBZ7rPgqi58NKmIdU0RIT/TWXcKqdwDF4/Vc6EsJTbQXi
        wGv4xwkdQP650Q/vnNOe3QZWME2pPu+NITM8msfTOyCTl4YKEnuhbJth9seQ8/2AtLluZb6EneT23
        JOFXbV6nQ9zi/cJ026K0LxaoRX8WmA2iUcKePObJY/ulzEDlL5wqLiy7t9i7clMsoPorMe0FlFFXk
        d6EVSYvGiuBZBnm75txDqDGomyhYrL0DmqCohpCtFhGQqa3WQUmPiCR9ZY9yJNmBIVzRh7EtWhF1f
        MlCPH/kw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJtaA-002mla-HJ; Wed, 10 Mar 2021 07:48:42 +0000
Date:   Wed, 10 Mar 2021 07:48:38 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Subject: Re: [PATCH v1 02/14] vfio: Update vfio_add_group_dev() API
Message-ID: <20210310074838.GA662265@infradead.org>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524006056.3480.3931750068527641030.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161524006056.3480.3931750068527641030.stgit@gimli.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 02:47:40PM -0700, Alex Williamson wrote:
> Rather than an errno, return a pointer to the opaque vfio_device
> to allow the bus driver to call into vfio-core without additional
> lookups and references.  Note that bus drivers are still required
> to use vfio_del_group_dev() to teardown the vfio_device.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

This looks like it is superseded by the

  vfio: Split creation of a vfio_device into init and register ops

patch from Jason, which provides a much nicer API.
