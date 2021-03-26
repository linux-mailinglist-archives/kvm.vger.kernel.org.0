Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C24634A422
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 10:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhCZJSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 05:18:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231179AbhCZJSD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 05:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616750283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t8H47LgEUN9z28TfEZJHV3uN23snCmuICmig34OVLYk=;
        b=MGS+p60aX5T5LK/jpnwnwaCFzxXxVJtILSjQXQopNBL5TKbrdn16xig9J2dRcnl60Saztw
        iu0wCOA44Ow+jzl9Mc0CL2KOmos6dvLWSgmi1D9uvIO1jJRU+lWByeI7TITLpbW6kHDKuT
        wokmjZ3Qn2snff3lBaeJnftTOPBqsQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-Oiqz7IC8OZGSpTO0PVGvUQ-1; Fri, 26 Mar 2021 05:17:58 -0400
X-MC-Unique: Oiqz7IC8OZGSpTO0PVGvUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E28C6414D;
        Fri, 26 Mar 2021 09:17:57 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DBAE77E21;
        Fri, 26 Mar 2021 09:17:52 +0000 (UTC)
Subject: Re: [PATCH 4/4] vfio/platform: Fix spelling mistake "registe" ->
 "register"
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210326083528.1329-1-thunder.leizhen@huawei.com>
 <20210326083528.1329-5-thunder.leizhen@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ca929ef5-0dbc-c711-0af4-03fb9edf0945@redhat.com>
Date:   Fri, 26 Mar 2021 10:17:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326083528.1329-5-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/26/21 9:35 AM, Zhen Lei wrote:
> There is a spelling mistake in a comment, fix it.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> index 09a9453b75c5592..63cc7f0b2e4a437 100644
> --- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> +++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> @@ -26,7 +26,7 @@
>  #define XGMAC_DMA_CONTROL       0x00000f18      /* Ctrl (Operational Mode) */
>  #define XGMAC_DMA_INTR_ENA      0x00000f1c      /* Interrupt Enable */
>  
> -/* DMA Control registe defines */
> +/* DMA Control register defines */
>  #define DMA_CONTROL_ST          0x00002000      /* Start/Stop Transmission */
>  #define DMA_CONTROL_SR          0x00000002      /* Start/Stop Receive */
>  
> 

