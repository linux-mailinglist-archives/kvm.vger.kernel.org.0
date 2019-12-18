Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286A1124894
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 14:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfLRNmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 08:42:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44298 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726912AbfLRNmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 08:42:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576676525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdHalUnD/LlSuJgEwaYsX1mkBoQV0c3hJtbxl/WylGs=;
        b=GKKe8Wnkk3LSuRhqmWlqMgTtFK2baLIFOAFOa4NLWfAlGqmLc7lhEPAE+gzSsyoVXjPmWC
        i3ceUSy3cIAc0GBhQAp8VYQ1ydGAYF+r1MEU19uerwYrdMbN9EficVTIWl5Un2cikHxkHk
        ZEvBW2j6tJUUbt+lSX0lt+l0+SaM/nE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-0Nj8KE41MFywJg36bkXfQw-1; Wed, 18 Dec 2019 08:42:01 -0500
X-MC-Unique: 0Nj8KE41MFywJg36bkXfQw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEACF88127E;
        Wed, 18 Dec 2019 13:41:59 +0000 (UTC)
Received: from [10.36.116.117] (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C52C15C1B0;
        Wed, 18 Dec 2019 13:41:55 +0000 (UTC)
Subject: Re: [PATCH] vfio: platform: fix __iomem in vfio_platform_amdxgbe.c
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Allison Randal <allison@lohutok.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191218133525.2608583-1-ben.dooks@codethink.co.uk>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <29859d29-dd51-1b27-8606-0e2eb1f6578c@redhat.com>
Date:   Wed, 18 Dec 2019 14:41:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191218133525.2608583-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ben,

On 12/18/19 2:35 PM, Ben Dooks (Codethink) wrote:
> The ioaddr should have __iomem marker on it, so add that to fix
> the following sparse warnings:
> 
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:33:44: warning: incorrect type in argument 2 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:33:44:    expected void volatile [noderef] <asn:2> *addr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:33:44:    got void *
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:34:33: warning: incorrect type in argument 1 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:34:33:    expected void const volatile [noderef] <asn:2> *addr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:34:33:    got void *
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:44:44: warning: incorrect type in argument 2 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:44:44:    expected void volatile [noderef] <asn:2> *addr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:44:44:    got void *
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:45:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:45:33:    expected void volatile [noderef] <asn:2> *addr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:45:33:    got void *
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:69:41: warning: incorrect type in argument 1 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:69:41:    expected void *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:69:41:    got void [noderef] <asn:2> *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:71:30: warning: incorrect type in argument 1 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:71:30:    expected void *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:71:30:    got void [noderef] <asn:2> *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:76:49: warning: incorrect type in argument 1 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:76:49:    expected void *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:76:49:    got void [noderef] <asn:2> *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:85:37: warning: incorrect type in argument 1 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:85:37:    expected void *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:85:37:    got void [noderef] <asn:2> *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:87:30: warning: incorrect type in argument 1 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:87:30:    expected void *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:87:30:    got void [noderef] <asn:2> *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:90:30: warning: incorrect type in argument 1 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:90:30:    expected void *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:90:30:    got void [noderef] <asn:2> *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:93:30: warning: incorrect type in argument 1 (different address spaces)
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:93:30:    expected void *ioaddr
> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:93:30:    got void [noderef] <asn:2> *ioaddr
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
> ---
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Allison Randal <allison@lohutok.net>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/vfio/platform/reset/vfio_platform_amdxgbe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
> index 2d2babe21b2f..ecfc908de30f 100644
> --- a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
> +++ b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
> @@ -24,7 +24,7 @@
>  #define MDIO_AN_INT		0x8002
>  #define MDIO_AN_INTMASK		0x8001
>  
> -static unsigned int xmdio_read(void *ioaddr, unsigned int mmd,
> +static unsigned int xmdio_read(void __iomem *ioaddr, unsigned int mmd,
>  			       unsigned int reg)
>  {
>  	unsigned int mmd_address, value;
> @@ -35,7 +35,7 @@ static unsigned int xmdio_read(void *ioaddr, unsigned int mmd,
>  	return value;
>  }
>  
> -static void xmdio_write(void *ioaddr, unsigned int mmd,
> +static void xmdio_write(void __iomem *ioaddr, unsigned int mmd,
>  			unsigned int reg, unsigned int value)
>  {
>  	unsigned int mmd_address;
> 
Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

