Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59F330CAAF
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbhBBS5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239051AbhBBS4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:56:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7811BC061786;
        Tue,  2 Feb 2021 10:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e1zVoQg1UhBO6rVR4/m5uorCM3XbTBOXLDJFdXea4To=; b=vkf3Pr3HHQAzpmHFsq5sgfiNRT
        M5rwlRJDk0dvNqcOeNr+P5StleKu91I20bg5U91cAtkC+X7arf1N7ibf21cSrVhh0KgnC6iofY/et
        0Zkt9gVoBhekGve4fd2YtGoIyaKF8YpVD3Kz6MKrChdsg1QiUWeZLMqE6frOnkOHKwjURIMVN0E0o
        UcYZZSwKwmBru7pGja9U4bE2VIzI+D3b8BX7dMz8Wr7jQ+Pm2up6PaM1zS7f0E5bmVB+gMLE2w5T2
        PM6WWish3BxWTNw2I5tp22jlMl4BAUSXAuWnPXKLKQMw7aT6DOAwfjyFPa8E6MimWVLDWh3k7kM9b
        iWT3E56A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l70pa-00FcxD-H7; Tue, 02 Feb 2021 18:55:18 +0000
Date:   Tue, 2 Feb 2021 18:55:18 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, gmataev@nvidia.com,
        cjia@nvidia.com, yishaih@nvidia.com, aik@ozlabs.ru
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202185518.GA3723843@infradead.org>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <20210202105455.5a358980@omen.home.shazbot.org>
 <20210202185017.GZ4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202185017.GZ4247@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 02:50:17PM -0400, Jason Gunthorpe wrote:
> For uAPI compatability vfio_pci.ko would need some
> request_module()/symbol_get() trick to pass control over to the device
> specific module.

Err, don't go there.

Please do the DRIVER_EXPLICIT_BIND_ONLY thing first, which avoids the
need for such hacks.
