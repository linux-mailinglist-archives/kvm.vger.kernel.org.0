Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323F82CE8A6
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 08:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgLDHdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 02:33:03 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9375 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgLDHdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 02:33:03 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CnPXm0qWLz76lf;
        Fri,  4 Dec 2020 15:31:52 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.37) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Dec 2020 15:32:12 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v3 0/2] clocksource: arm_arch_timer: Some fixes
Date:   Fri, 4 Dec 2020 15:31:24 +0800
Message-ID: <20201204073126.6920-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

change log:

v3:
 - Address Marc's comments.
 - Reform arch_timer_configure_evtstream.

v2:
 - Do not revert commit 0ea415390cd3, fix it instead.
 - Correct the tags of second patch.

Keqian Zhu (2):
  clocksource: arm_arch_timer: Use stable count reader in erratum sne
  clocksource: arm_arch_timer: Correct fault programming of
    CNTKCTL_EL1.EVNTI

 drivers/clocksource/arm_arch_timer.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

-- 
2.23.0

