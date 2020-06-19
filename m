Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7618020093A
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 15:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732953AbgFSM7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 08:59:55 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7247 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbgFSM7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 08:59:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eecb6910000>; Fri, 19 Jun 2020 05:58:57 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 19 Jun 2020 05:59:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 19 Jun 2020 05:59:48 -0700
Received: from [10.40.102.107] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 19 Jun
 2020 12:59:44 +0000
Subject: Re: [PATCH] vfio/type1: Fix migration info capability ID
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Liu Yi L <yi.l.liu@intel.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
References: <159250751478.22544.8607332732745502185.stgit@gimli.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <8c4f9b33-faee-fbe1-3600-426f199952db@nvidia.com>
Date:   Fri, 19 Jun 2020 18:29:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <159250751478.22544.8607332732745502185.stgit@gimli.home>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1592571537; bh=83f4dRO3Jh6U1CBeTvruBIEwVMlY544CI14CJOLhBu0=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qLJvXce4k7x3vKk84gEWqdcmmdKAM8KjKIeiJuapSHec4ea8FF3MP9Ib5iXfhkHRV
         FUcOQ3cBbaU542Tg15aLbzS235KQJPkav6nDg3cBVJypy+kKkF7xb9i1CAaCW80e2S
         4pG7aneTgcZi7jPKy/n3bug0ZSdAvNur0CSgfUNdUwxpaYhKcMblemKFiW6PBV9qXV
         9oX4YyHGd6ohNITpGHknfHelr+Jh2W4h2gHBn3yJ3xTQ1foFN2KLUfJ9qEOGEt6oPX
         o4MK9PGlMvRd4SH5IeLhno8GBYG58TSgABhixTiOXuNfSBLPJlswZZAtc0LWA+eEDq
         8RNX5I1RjW3JA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/19/2020 12:42 AM, Alex Williamson wrote:
> ID 1 is already used by the IOVA range capability, use ID 2.
> 

Ops.
Thanks for Fixing it.

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

> Reported-by: Liu Yi L <yi.l.liu@intel.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Fixes: ad721705d09c ("vfio iommu: Add migration capability to report supported features")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>   include/uapi/linux/vfio.h |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index eca6692667a3..920470502329 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1030,7 +1030,7 @@ struct vfio_iommu_type1_info_cap_iova_range {
>    * size in bytes that can be used by user applications when getting the dirty
>    * bitmap.
>    */
> -#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
> +#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  2
>   
>   struct vfio_iommu_type1_info_cap_migration {
>   	struct	vfio_info_cap_header header;
> 
