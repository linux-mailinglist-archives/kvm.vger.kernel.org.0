Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16EA35EDC1
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 08:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349418AbhDNGwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 02:52:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16992 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349379AbhDNGwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 02:52:24 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FKtNz5FMxzNw2w;
        Wed, 14 Apr 2021 14:49:07 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 14:51:53 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>
CC:     <wanghaibin.wang@huawei.com>
Subject: [PATCH v3 0/2] kvm/arm64: Try stage2 block mapping for host device MMIO
Date:   Wed, 14 Apr 2021 14:51:07 +0800
Message-ID: <20210414065109.8616-1-zhukeqian1@huawei.com>
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

v3:
 - Do not need to check memslot boundary in device_rough_page_shift(). (Marc)

Thanks,
Keqian

Keqian Zhu (2):
  kvm/arm64: Remove the creation time's mapping of MMIO regions
  kvm/arm64: Try stage2 block mapping for host device MMIO

 arch/arm64/kvm/mmu.c | 75 +++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 39 deletions(-)

-- 
2.19.1

