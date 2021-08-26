Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5063F8430
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240751AbhHZJMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240568AbhHZJL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 05:11:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64513C061757;
        Thu, 26 Aug 2021 02:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Pi6PlqGHDgRTs8czFG5MR0S+ehb7hWYSWmF3atEz+M0=; b=wOVW1CqzXO+eWVrMoDaVqEgysb
        w6IYgKF1Fr8Ck4s/BjuDWfmWnXprUT5mx+j1ADugrqtHnpOTyqww3RbXqcmtz3N7j5DJA7Y8yelTT
        eKrhTbFaKK4HkmmrGB4ViBeSj8lDyQfzpCup4DWoXEzlwRnLt4HGx8zRZpbiBMxMwsAjKMrWYS2+v
        5bulW1tsgFnM+mqy9SK8yOnty7eyO2Le4dcORQfQKO7DCD6cU2rEb3w3ObjrM3UU/wjUkWjpZ3nC7
        yo/Z33XMOrdBgNn/ZTvZ2GCgIu80vS3gpYofNxINW2HnehpFX+al8SEjONqJevLSUHPdf/HYwZcJO
        YDgPumpQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJBOD-00D8N6-Ir; Thu, 26 Aug 2021 09:09:51 +0000
Date:   Thu, 26 Aug 2021 10:09:37 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     bhelgaas@google.com, corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, jgg@nvidia.com, maorg@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH V4 12/13] vfio: Use kconfig if XX/endif blocks instead of
 repeating 'depends on'
Message-ID: <YSdaUblSuL2KH0+H@infradead.org>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-13-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-13-yishaih@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 04:51:38PM +0300, Yishai Hadas wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> This results in less kconfig wordage and a simpler understanding of the
> required "depends on" to create the menu structure.
> 
> The next patch increases the nesting level a lot so this is a nice
> preparatory simplification.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

