Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0DB3A5C81
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 07:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhFNFmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 01:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhFNFmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 01:42:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CF1C061574;
        Sun, 13 Jun 2021 22:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D2vwkZHeV1Mmvx+DKepIzag2hqp+Ued0hIaFPq9qKG4=; b=Yakg1J/sCs5ZVsvqSqoWCnxyPW
        ZgFm98pIUEZic5lMz9vZwQkr2beKbrKlZNbvLc1oAP8jtrevc6WW0aZgzqRUFAre4gC6+WcmS+qW+
        V8ZJSl7maD7jHPiSaUVL+6gCroHSIY8NEfKrLiZ7m7WgIHHaFBFXClZroAzTmiGhsZOoQxmtCjUHC
        TJdi+j5BnV8tOcpfK1IUbBePLJCkBm0wzUMX1IYjvMdzpzL5NpTLY+Dnq6WW/YtCcCYC816X8SZNV
        HBBCgHutXpsie256AFhMna/UU25je4laURKmv8zCEdQQpxLWXlJ6tl4iNANsmFZvcZ85HAAyRZJc4
        ujSrgwiw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsfKe-0053jJ-Ml; Mon, 14 Jun 2021 05:40:24 +0000
Date:   Mon, 14 Jun 2021 06:40:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <YMbrxP/5D4vVLE0j@infradead.org>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
 <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
 <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 13, 2021 at 11:19:46AM +0300, Max Gurtovoy wrote:
> what about the following code ?
> 
> @@ -152,12 +152,28 @@ static const struct pci_device_id
> *pci_match_device(struct pci_driver *drv,
> ?????????????? }
> ?????????????? spin_unlock(&drv->dynids.lock);
> 
> -???????????? if (!found_id)
> -???????????????????????????? found_id = pci_match_id(drv->id_table, dev);
> +???????????? if (found_id)
> +???????????????????????????? return found_id;

Something is broken in your mailer because this does not look like code
at all.
