Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CF032C609
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbhCDA1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1442243AbhCCMiC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 07:38:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614774995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZ2uBtAotFD6azGKmTAU2NtFm9E5wKJOahnBefhZJM4=;
        b=RqrHw3ZU9Em6P89WfnNt7oyAGNTxmDiXrfZJGMl8v1rxa2PDBDya7GUNR6MW0S/oSMKZnd
        zuBSYBmWSXBsurGryLAm47d2Pg3slT+MY5mLZocM8BHwDbH1ElFc3Lqa8h8/zbaws+eVHu
        rLMU2u05ltNqW9WeX64J+DaEL+zNdQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-i4lPEMLlOZqz5qskpDuytA-1; Wed, 03 Mar 2021 07:36:33 -0500
X-MC-Unique: i4lPEMLlOZqz5qskpDuytA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC5D1800D55;
        Wed,  3 Mar 2021 12:36:32 +0000 (UTC)
Received: from gondolin (ovpn-113-85.ams2.redhat.com [10.36.113.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08E975D730;
        Wed,  3 Mar 2021 12:36:28 +0000 (UTC)
Date:   Wed, 3 Mar 2021 13:36:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     <kvm@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 1/3] vfio: IOMMU_API should be selected
Message-ID: <20210303133626.3598b41b.cohuck@redhat.com>
In-Reply-To: <1-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
References: <0-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
        <1-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Feb 2021 15:17:46 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> As IOMMU_API is a kconfig without a description (eg does not show in the
> menu) the correct operator is select not 'depends on'. Using 'depends on'
> for this kind of symbol means VFIO is not selectable unless some other
> random kconfig has already enabled IOMMU_API for it.
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

I'm wondering whether this should depend on MMU?

