Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180CE3239CB
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 10:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhBXJqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 04:46:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234798AbhBXJoN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 04:44:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614159766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wo1xY52qHv+0VsKDtP7jiIIuJ2RXoJo39UirKWPDe8M=;
        b=GQ1aqfAibZFcLWFrFnpqd0O6Q8wMfu4tJzCZh9yL6pX1Dp3jdIKNCT4NHWw2tmcVEb0HUm
        5LYPWXqrd0lu0/fdC1fVpdiRKbeFTY6ibetib09r+2YFw0PHQ1WDLtmBO0GwsjAG4zGcWK
        bWS6p2A7KPKwmUNm2J/NfXYXofKwZ/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-qSbBfuXCOgu88Sb44_jgBg-1; Wed, 24 Feb 2021 04:42:42 -0500
X-MC-Unique: qSbBfuXCOgu88Sb44_jgBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6DD084A61F;
        Wed, 24 Feb 2021 09:42:15 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C0AF60C4D;
        Wed, 24 Feb 2021 09:42:11 +0000 (UTC)
Subject: Re: [PATCH 2/3] vfio-platform: Add COMPILE_TEST to VFIO_PLATFORM
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <2-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <8b7dad1c-6597-49a5-15ba-715fcb3e478b@redhat.com>
Date:   Wed, 24 Feb 2021 10:42:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,
On 2/23/21 8:17 PM, Jason Gunthorpe wrote:
> x86 can build platform bus code too, so vfio-platform and all the platform
> reset implementations compile successfully on x86.

A similar patch was sent recently, see
[PATCH v1] vfio: platform: enable compile test
https://www.spinics.net/lists/kvm/msg230677.html

Thanks

Eric


> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/platform/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index dc1a3c44f2c62b..233efde219cc10 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config VFIO_PLATFORM
>  	tristate "VFIO support for platform devices"
> -	depends on VFIO && EVENTFD && (ARM || ARM64)
> +	depends on VFIO && EVENTFD && (ARM || ARM64 || COMPILE_TEST)
>  	select VFIO_VIRQFD
>  	help
>  	  Support for platform devices with VFIO. This is required to make
> 

