Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B3A2DD0CF
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 12:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgLQLuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 06:50:40 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2917 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgLQLuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 06:50:40 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CxVdp4VVtz56Gr;
        Thu, 17 Dec 2020 19:49:18 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 17 Dec 2020 19:49:56 +0800
Received: from [10.174.185.137] (10.174.185.137) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 17 Dec 2020 19:49:55 +0800
Subject: Re: [PATCH v11 04/13] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
 type
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <will@kernel.org>, <joro@8bytes.org>, <maz@kernel.org>,
        <robin.murphy@arm.com>, <alex.williamson@redhat.com>
CC:     <jean-philippe@linaro.org>, <jacob.jun.pan@linux.intel.com>,
        <nicoleotsuka@gmail.com>, <vivek.gautam@arm.com>,
        <yi.l.liu@intel.com>, <zhangfei.gao@linaro.org>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>,
        <yuzenghui@huawei.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
 <20201116110030.32335-5-eric.auger@redhat.com>
From:   Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <2b5031d4-fa1a-c893-e7e4-56c68da600e4@huawei.com>
Date:   Thu, 17 Dec 2020 19:49:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116110030.32335-5-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.185.137]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/11/16 19:00, Eric Auger wrote:
> Add a new specific DMA_FAULT region aiming to exposed nested mode
> translation faults. This region only is exposed if the device
> is attached to a nested domain.
>
> The region has a ring buffer that contains the actual fault
> records plus a header allowing to handle it (tail/head indices,
> max capacity, entry size). At the moment the region is dimensionned
> for 512 fault records.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
[...]
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index b352e76cfb71..629dfb38d9e7 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -343,6 +343,9 @@ struct vfio_region_info_cap_type {
>   /* sub-types for VFIO_REGION_TYPE_GFX */
>   #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
>   
> +#define VFIO_REGION_TYPE_NESTED			(2)
> +#define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT	(1)
> +

The macro *define VFIO_REGION_TYPE_NESTED    (2)* is in conflict with

*#define VFIO_REGION_TYPE_CCW    (2)*.


Thanks,

Kunkun Jiang.

