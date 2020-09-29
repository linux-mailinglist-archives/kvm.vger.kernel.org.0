Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE28827C0D8
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgI2JRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:17:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14707 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727691AbgI2JRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 05:17:54 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 545B0E38F9F3F29BB102;
        Tue, 29 Sep 2020 17:17:52 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.69) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:17:45 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <will@kernel.org>, <catalin.marinas@arm.com>, <maz@kernel.org>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>,
        <yezengruan@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <fanhenglong@huawei.com>, <wangjingyi11@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: [RFC PATCH 0/4] Add support for ARMv8.6 TWED feature
Date:   Tue, 29 Sep 2020 17:17:23 +0800
Message-ID: <20200929091727.8692-1-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TWE Delay is an optional feature in ARMv8.6 Extentions. There is a
performance benefit in waiting for a period of time for an event to
arrive before taking the trap as it is common that event will arrive
“quite soon” after executing the WFE instruction.

This series adds support for TWED feature and implements TWE delay
value dynamic adjustment.

Thanks for Shameer's advice on this series. The function of this patch
has been tested on TWED supported hardware and the performance of it is
still on test, any advice will be welcomed.

Jingyi Wang (2):
  KVM: arm64: Make use of TWED feature
  KVM: arm64: Use dynamic TWE Delay value

Zengruan Ye (2):
  arm64: cpufeature: TWED support detection
  KVM: arm64: Add trace for TWED update

 arch/arm64/Kconfig                   | 10 +++++
 arch/arm64/include/asm/cpucaps.h     |  3 +-
 arch/arm64/include/asm/kvm_arm.h     |  5 +++
 arch/arm64/include/asm/kvm_emulate.h | 38 ++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h    | 19 ++++++++-
 arch/arm64/include/asm/virt.h        |  8 ++++
 arch/arm64/kernel/cpufeature.c       | 12 ++++++
 arch/arm64/kvm/arm.c                 | 58 ++++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c         |  2 +
 arch/arm64/kvm/trace_arm.h           | 21 ++++++++++
 10 files changed, 174 insertions(+), 2 deletions(-)

-- 
2.19.1

