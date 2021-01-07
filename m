Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FA02EC989
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 05:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbhAGEpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 23:45:16 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9966 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbhAGEpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 23:45:16 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DBDC84vtmzj2Xl;
        Thu,  7 Jan 2021 12:43:48 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Thu, 7 Jan 2021 12:44:25 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, "Marc Zyngier" <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: [PATCH 0/6] vfio/iommu_type1: Some optimizations about dirty tracking
Date:   Thu, 7 Jan 2021 12:43:55 +0800
Message-ID: <20210107044401.19828-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

In patch series[1], I put forward some fixes and optimizations for
vfio_iommu_type1. This extracts and improves the optimization part
of it.

[1] https://lore.kernel.org/linux-iommu/20201210073425.25960-1-zhukeqian1@huawei.com/T/#t

Thanks,
Keqian


Keqian Zhu (6):
  vfio/iommu_type1: Make an explicit "promote" semantic
  vfio/iommu_type1: Ignore external domain when promote pinned_scope
  vfio/iommu_type1: Initially set the pinned_page_dirty_scope
  vfio/iommu_type1: Drop parameter "pgsize" of vfio_dma_bitmap_alloc_all
  vfio/iommu_type1: Drop parameter "pgsize" of vfio_iova_dirty_bitmap
  vfio/iommu_type1: Drop parameter "pgsize" of update_user_bitmap

 drivers/vfio/vfio_iommu_type1.c | 67 +++++++++++++--------------------
 1 file changed, 26 insertions(+), 41 deletions(-)

-- 
2.19.1

