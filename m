Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C03B3239EC
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 10:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhBXJw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 04:52:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234673AbhBXJwK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 04:52:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614160243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oW5qRtjn1KtbV3yxRcz75I4TrYBTAoxWUoc3Z0zJLdw=;
        b=erFGHQoUEfk9gq6H+IVSffgwPyLNnp5e8b1oDLPF5HHMZDAcwvm2Lei1wEq/AK07FLlmwb
        FWQjvUfNXkpjMq7ZIGmXfQuNo0tPMgg4MEBn5OvfUKa93EnsTSY5c2uwaBAuREtvuZ1aJY
        qxk2FUt0Wu9jpENFRyem+d80mxtR4nY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-K5bwYX5eOdqY6GU5JsMPew-1; Wed, 24 Feb 2021 04:50:40 -0500
X-MC-Unique: K5bwYX5eOdqY6GU5JsMPew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E97F9814308;
        Wed, 24 Feb 2021 09:50:39 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA2B319C46;
        Wed, 24 Feb 2021 09:50:35 +0000 (UTC)
Subject: Re: [PATCH 1/3] vfio: IOMMU_API should be selected
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>
References: <1-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d30e90a6-209b-e7e2-e7ae-593744470a60@redhat.com>
Date:   Wed, 24 Feb 2021 10:50:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
On 2/23/21 8:17 PM, Jason Gunthorpe wrote:
> As IOMMU_API is a kconfig without a description (eg does not show in the
> menu) the correct operator is select not 'depends on'. Using 'depends on'
> for this kind of symbol means VFIO is not selectable unless some other
> random kconfig has already enabled IOMMU_API for it.

looks sensible to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> 
> Fixes: cba3345cc494 ("vfio: VFIO core")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 5533df91b257d6..90c0525b1e0cf4 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -21,7 +21,7 @@ config VFIO_VIRQFD
>  
>  menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
> -	depends on IOMMU_API
> +	select IOMMU_API
>  	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
> 

