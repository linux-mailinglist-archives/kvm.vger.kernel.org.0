Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5633E246646
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 14:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgHQMYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 08:24:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9750 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbgHQMYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 08:24:36 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9E07146F75F97D4A4037;
        Mon, 17 Aug 2020 20:24:25 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 20:24:18 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
        "Andrew Jones" <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <will@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH 0/2] clocksource: arm_arch_timer: Some fixes and code adjustment
Date:   Mon, 17 Aug 2020 20:24:13 +0800
Message-ID: <20200817122415.6568-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During picking up pvtime LPT support for arm64, I found some trivial bugs for
arm arch_timer driver.

Keqian Zhu (2):
  clocksource: arm_arch_timer: Simplify and fix count reader code logic
  clocksource: arm_arch_timer: Correct fault programming of
    CNTKCTL_EL1.EVNTI

 arch/arm/include/asm/arch_timer.h    | 14 ++--------
 arch/arm64/include/asm/arch_timer.h  | 24 ++--------------
 drivers/clocksource/arm_arch_timer.c | 53 ++++++------------------------------
 3 files changed, 13 insertions(+), 78 deletions(-)

-- 
1.8.3.1

