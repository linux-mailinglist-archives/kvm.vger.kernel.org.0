Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA0B3F842B
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240849AbhHZJJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240851AbhHZJJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 05:09:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F11AC061757;
        Thu, 26 Aug 2021 02:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4LUj3j8BI5d4S9PFKOxGmecEJ4ejeijS/lzS+aOOpsI=; b=fobxWMQbCCKyUNXv9YcHXIxWSR
        WLN/4/MoDAxNlvVxdh40fr5qXvTX2N96/8JZNsBZ2s9i97p7aVA+G0AAGb3KojhsVTihgsoPvc+Da
        suey6MxWm7/J4tv6zVHiBFahSUmdKLN5Dqg4Wdi/WJnAIIBYyuaAPbihfErlBHpL9/WIOugtGkRmR
        fO8YiF9qxwyKgCMXoeL6+B2NXT9BrlZVH9P0C8FQAL3gZ+sQj++J5N6y/14DEtciM4ogulrYfwgb/
        96lGzKhniqeRXbXx0N1rN6uw9AnE45OnDnNp2zFiEa0dZhBkKknC/pXWQ+6SriwaoLRW1OOPxgNTs
        lLJiBaAw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJBLL-00D8Dw-0Z; Thu, 26 Aug 2021 09:06:51 +0000
Date:   Thu, 26 Aug 2021 10:06:39 +0100
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
Subject: Re: [PATCH V4 11/13] vfio: Use select for eventfd
Message-ID: <YSdZnzyFqJ/ctc2c@infradead.org>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-12-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-12-yishaih@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 04:51:37PM +0300, Yishai Hadas wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> If VFIO_VIRQFD is required then turn on eventfd automatically.
> The majority of kconfig users of the EVENTFD use select not depends on.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

>  config VFIO_VIRQFD
>  	tristate
> -	depends on VFIO && EVENTFD
> +	depends on VFIO
> +	select EVENTFD
>  	default n

Nit: the 'default n' is not actually needed.
