Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7819734A42E
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 10:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhCZJTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 05:19:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21405 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231187AbhCZJTJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 05:19:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616750349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BMoaflg1amNLcZ+wtjMJdk+YpktkqgLDvbrbkoNWY9Y=;
        b=Esuqooxq+LFOmqPBnQqKBQ9TjVqMB+dTX4I9LtZhSePz3XWdK1BBmvEbVdWZkUb5EBC1fB
        XONxUX81ZLjQu3MjPbSg9VXyeQfaFXw/XlTKIJ6j8PKFtOPDs7/y+Y2HisHl1k54A+cAl9
        TuIZFWsbJmGmzMUn4UemC3BZztFh51E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-6PS_ZBnrO_i7ptv6pmQGdA-1; Fri, 26 Mar 2021 05:19:06 -0400
X-MC-Unique: 6PS_ZBnrO_i7ptv6pmQGdA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E76AE84B9A2;
        Fri, 26 Mar 2021 09:19:05 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 855F51972B;
        Fri, 26 Mar 2021 09:19:01 +0000 (UTC)
Subject: Re: [PATCH 3/4] vfio/pci: fix a couple of spelling mistakes
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210326083528.1329-1-thunder.leizhen@huawei.com>
 <20210326083528.1329-4-thunder.leizhen@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f2d898cb-77ca-5057-1aff-6c20b0861fa3@redhat.com>
Date:   Fri, 26 Mar 2021 10:18:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326083528.1329-4-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/26/21 9:35 AM, Zhen Lei wrote:
> There are several spelling mistakes, as follows:
> permision ==> permission
> thru ==> through
> presense ==> presence
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/vfio/pci/vfio_pci.c         | 2 +-
>  drivers/vfio/pci/vfio_pci_config.c  | 2 +-
>  drivers/vfio/pci/vfio_pci_nvlink2.c | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 65e7e6b44578c29..d2ab8b5bc8a86fe 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -2409,7 +2409,7 @@ static int __init vfio_pci_init(void)
>  {
>  	int ret;
>  
> -	/* Allocate shared config space permision data used by all devices */
> +	/* Allocate shared config space permission data used by all devices */
>  	ret = vfio_pci_init_perm_bits();
>  	if (ret)
>  		return ret;
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index a402adee8a21558..d57f037f65b85d4 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -101,7 +101,7 @@
>  /*
>   * Read/Write Permission Bits - one bit for each bit in capability
>   * Any field can be read if it exists, but what is read depends on
> - * whether the field is 'virtualized', or just pass thru to the
> + * whether the field is 'virtualized', or just pass through to the
>   * hardware.  Any virtualized field is also virtualized for writes.
>   * Writes are only permitted if they have a 1 bit here.
>   */
> diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
> index 9adcf6a8f888575..f276624fec79f68 100644
> --- a/drivers/vfio/pci/vfio_pci_nvlink2.c
> +++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
> @@ -219,7 +219,7 @@ int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev)
>  	unsigned long events = VFIO_GROUP_NOTIFY_SET_KVM;
>  
>  	/*
> -	 * PCI config space does not tell us about NVLink presense but
> +	 * PCI config space does not tell us about NVLink presence but
>  	 * platform does, use this.
>  	 */
>  	npu_dev = pnv_pci_get_npu_dev(vdev->pdev, 0);
> @@ -402,7 +402,7 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
>  	u32 link_speed = 0xff;
>  
>  	/*
> -	 * PCI config space does not tell us about NVLink presense but
> +	 * PCI config space does not tell us about NVLink presence but
>  	 * platform does, use this.
>  	 */
>  	if (!pnv_pci_get_gpu_dev(vdev->pdev))
> 

