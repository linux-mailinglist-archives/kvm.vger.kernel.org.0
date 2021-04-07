Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBCD35681C
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 11:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350158AbhDGJdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 05:33:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16009 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbhDGJdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 05:33:49 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FFfJs2YhXzPnwK;
        Wed,  7 Apr 2021 17:30:53 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 17:33:28 +0800
Subject: Re: [PATCH v12 01/13] vfio: VFIO_IOMMU_SET_PASID_TABLE
To:     Eric Auger <eric.auger@redhat.com>
CC:     <eric.auger.pro@gmail.com>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
        <maz@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
        <alex.williamson@redhat.com>, <tn@semihalf.com>,
        <zhukeqian1@huawei.com>, <jacob.jun.pan@linux.intel.com>,
        <yi.l.liu@intel.com>, <wangxingang5@huawei.com>,
        <jiangkunkun@huawei.com>, <jean-philippe@linaro.org>,
        <zhangfei.gao@linaro.org>, <zhangfei.gao@gmail.com>,
        <vivek.gautam@arm.com>, <shameerali.kolothum.thodi@huawei.com>,
        <nicoleotsuka@gmail.com>, <lushenming@huawei.com>,
        <vsethi@nvidia.com>, <wanghaibin.wang@huawei.com>
References: <20210223210625.604517-1-eric.auger@redhat.com>
 <20210223210625.604517-2-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d0f254c3-0b63-e4d3-1f58-8940adc7c0bf@huawei.com>
Date:   Wed, 7 Apr 2021 17:33:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210223210625.604517-2-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2021/2/24 5:06, Eric Auger wrote:
> +/*
> + * VFIO_IOMMU_SET_PASID_TABLE - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
> + *			struct vfio_iommu_type1_set_pasid_table)
> + *
> + * The SET operation passes a PASID table to the host while the
> + * UNSET operation detaches the one currently programmed. Setting
> + * a table while another is already programmed replaces the old table.

It looks to me that this description doesn't match the IOMMU part.

[v14,05/13] iommu/smmuv3: Implement attach/detach_pasid_table

|	case IOMMU_PASID_CONFIG_TRANSLATE:
|		/* we do not support S1 <-> S1 transitions */
|		if (smmu_domain->s1_cfg.set)
|			goto out;

Maybe I've misread something?


Thanks,
Zenghui
