Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0445E360B55
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 16:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhDOOEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 10:04:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16924 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbhDOOEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 10:04:08 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FLgxp6xd9zkjjr;
        Thu, 15 Apr 2021 22:01:50 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 22:03:33 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>
CC:     <wanghaibin.wang@huawei.com>
Subject: [PATCH v4 0/2] kvm/arm64: Try stage2 block mapping for host device MMIO
Date:   Thu, 15 Apr 2021 22:03:26 +0800
Message-ID: <20210415140328.24200-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

We have two pathes to build stage2 mapping for MMIO regions.

Create time's path and stage2 fault path.

Patch#1 removes the creation time's mapping of MMIO regions
Patch#2 tries stage2 block mapping for host device MMIO at fault path

Changelog:

v4:
 - use get_vma_page_shift() handle all cases. (Marc)
 - get rid of force_pte for device mapping. (Marc)

v3:
 - Do not need to check memslot boundary in device_rough_page_shift(). (Marc)

Thanks,
Keqian


Keqian Zhu (2):
  kvm/arm64: Remove the creation time's mapping of MMIO regions
  kvm/arm64: Try stage2 block mapping for host device MMIO

 arch/arm64/kvm/mmu.c | 99 ++++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 45 deletions(-)

-- 
2.19.1

