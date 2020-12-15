Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F272DA9C7
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 10:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgLOJJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 04:09:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728031AbgLOJIK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Dec 2020 04:08:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608023199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YQomKHlVlNItvSGSzwETQvD/gC3PBnGm7xOcOg1U30w=;
        b=Co1GaSUDVi23JSgIfBmAR8aIUZ9HyOC8Dcip+/6vYNRpBudRbPrDuWPEo+jgmHOCqnK5gN
        mNPLivuG86y27K/ziPvID8LJPpXP1hnQSDBs8v6H7VeUx2FDIzIAIdmzIeeN9iUMjc0FEj
        hZC6LB+vddYiSyMhwYWD517wbcGveSQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-UCHd1aSjOhiiYpfi-pouig-1; Tue, 15 Dec 2020 04:06:37 -0500
X-MC-Unique: UCHd1aSjOhiiYpfi-pouig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 468B91800D42;
        Tue, 15 Dec 2020 09:06:36 +0000 (UTC)
Received: from [10.36.116.173] (ovpn-116-173.ams2.redhat.com [10.36.116.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CE6C70497;
        Tue, 15 Dec 2020 09:06:31 +0000 (UTC)
Subject: Re: [PATCH v1] vfio: platform: enable compile test
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
References: <20201209202908.61658-1-andriy.shevchenko@linux.intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e32f5fb1-e1a5-5440-d965-7e931d6ac4ad@redhat.com>
Date:   Tue, 15 Dec 2020 10:06:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201209202908.61658-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andy,

On 12/9/20 9:29 PM, Andy Shevchenko wrote:
> Enable compile test of the VFIO platform code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/vfio/platform/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index dc1a3c44f2c6..d19051b68952 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -1,7 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config VFIO_PLATFORM
>  	tristate "VFIO support for platform devices"
> -	depends on VFIO && EVENTFD && (ARM || ARM64)
> +	depends on (ARM || ARM64) || COMPILE_TEST
> +	depends on VFIO && EVENTFD
>  	select VFIO_VIRQFD
>  	help
>  	  Support for platform devices with VFIO. This is required to make
> 
Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

