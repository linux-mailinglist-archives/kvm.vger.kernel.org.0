Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F802772CD
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 15:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgIXNmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 09:42:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14274 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727749AbgIXNmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 09:42:21 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id ABEC7382033A6CEF029B;
        Thu, 24 Sep 2020 21:42:18 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 24 Sep 2020 21:42:10 +0800
Subject: Re: [PATCH v10 11/11] vfio: Document nested stage control
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <joro@8bytes.org>, <alex.williamson@redhat.com>,
        <jacob.jun.pan@linux.intel.com>, <yi.l.liu@intel.com>,
        <robin.murphy@arm.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-12-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <26a85a63-6cc1-0348-e703-cb31ddd75339@huawei.com>
Date:   Thu, 24 Sep 2020 21:42:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200320161911.27494-12-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/3/21 0:19, Eric Auger wrote:
> The VFIO API was enhanced to support nested stage control: a bunch of
> new iotcls, one DMA FAULT region and an associated specific IRQ.
> 
> Let's document the process to follow to set up nested mode.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

[...]

> +The userspace must be prepared to receive faults. The VFIO-PCI device
> +exposes one dedicated DMA FAULT region: it contains a ring buffer and
> +its header that allows to manage the head/tail indices. The region is
> +identified by the following index/subindex:
> +- VFIO_REGION_TYPE_NESTED/VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT
> +
> +The DMA FAULT region exposes a VFIO_REGION_INFO_CAP_PRODUCER_FAULT
> +region capability that allows the userspace to retrieve the ABI version
> +of the fault records filled by the host.

Nit: I don't see this capability in the code.


Thanks,
Zenghui
