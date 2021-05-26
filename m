Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C52C391E4B
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 19:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhEZRnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 13:43:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhEZRnU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 13:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622050908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WGVSBOtY2KHNI3yoDOggf3VxaaNeUgOiz/4gLLq2PJQ=;
        b=A3o0vhiKLuMyUe8tCDmlKyPHJprzHhQ21wAX8FXn5kFIOfr7MsKLSfDtVzTqYDFi+jIcjI
        ZvXz82MSnB2BA0ap1k+JtwVYMqT9/3IDPnWwq+auRYf8/13bDw0SKcoSmhaMupUDflEVfE
        VlH3X0Y6l3y3LK0iR86ciKMEC95uURA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-ij_taiC2OemxQP7S4PFvow-1; Wed, 26 May 2021 13:41:45 -0400
X-MC-Unique: ij_taiC2OemxQP7S4PFvow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6678180FD61;
        Wed, 26 May 2021 17:41:43 +0000 (UTC)
Received: from [10.36.112.15] (ovpn-112-15.ams2.redhat.com [10.36.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 16AC636DE;
        Wed, 26 May 2021 17:41:38 +0000 (UTC)
Subject: Re: [PATCH 3/3] vfio/platform: remove unneeded parent_module
 attribute
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, jgg@nvidia.com,
        cohuck@redhat.com, kvm@vger.kernel.org, alex.williamson@redhat.com
Cc:     oren@nvidia.com
References: <20210518192133.59195-1-mgurtovoy@nvidia.com>
 <20210518192133.59195-3-mgurtovoy@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <800ea241-d488-dfc1-e398-b62df6b8d590@redhat.com>
Date:   Wed, 26 May 2021 19:41:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210518192133.59195-3-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Max,

On 5/18/21 9:21 PM, Max Gurtovoy wrote:
> The vfio core driver is now taking refcount on the provider drivers,
> remove redundant parent_module attribute from vfio_platform_device
> structure.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/platform/vfio_amba.c             | 1 -
>  drivers/vfio/platform/vfio_platform.c         | 1 -
>  drivers/vfio/platform/vfio_platform_private.h | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index f970eb2a999f..badfffea14fb 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -59,7 +59,6 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
>  	vdev->flags = VFIO_DEVICE_FLAGS_AMBA;
>  	vdev->get_resource = get_amba_resource;
>  	vdev->get_irq = get_amba_irq;
> -	vdev->parent_module = THIS_MODULE;
>  	vdev->reset_required = false;
>  
>  	ret = vfio_platform_probe_common(vdev, &adev->dev);
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index e4027799a154..68a1c87066d7 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -50,7 +50,6 @@ static int vfio_platform_probe(struct platform_device *pdev)
>  	vdev->flags = VFIO_DEVICE_FLAGS_PLATFORM;
>  	vdev->get_resource = get_platform_resource;
>  	vdev->get_irq = get_platform_irq;
> -	vdev->parent_module = THIS_MODULE;
>  	vdev->reset_required = reset_required;
>  
>  	ret = vfio_platform_probe_common(vdev, &pdev->dev);
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index a5ba82c8cbc3..dfb834c13659 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -50,7 +50,6 @@ struct vfio_platform_device {
>  	u32				num_irqs;
>  	int				refcnt;
>  	struct mutex			igate;
> -	struct module			*parent_module;
>  	const char			*compat;
>  	const char			*acpihid;
>  	struct module			*reset_module;
> 

