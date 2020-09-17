Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9953D26DC30
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 14:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgIQM50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 08:57:26 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37178 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727057AbgIQM5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 08:57:20 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 61C231A20D53158B4E33;
        Thu, 17 Sep 2020 20:09:19 +0800 (CST)
Received: from localhost.localdomain (10.175.104.175) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:09:10 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <drjones@redhat.com>, <zhang.zhanghailiang@huawei.com>,
        <xiexiangyou@huawei.com>, Peng Liang <liangpeng10@huawei.com>
Subject: [RFC v2 0/7] kvm: arm64: emulate ID registers
Date:   Thu, 17 Sep 2020 20:00:54 +0800
Message-ID: <20200917120101.3438389-1-liangpeng10@huawei.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In AArch64, guest will read the same values of the ID regsiters with
host.  Both of them read the values from arm64_ftr_regs.  This patch
series add support to emulate and configure ID registers so that we can
control the value of ID registers that guest read.

v1 -> v2:
 - save the ID registers in sysreg file instead of a new struct
 - apply a checker before setting the value to the register
 - add doc for new KVM_CAP_ARM_CPU_FEATURE

Peng Liang (7):
  arm64: add a helper function to traverse arm64_ftr_regs
  arm64: introduce check_features
  kvm: arm64: save ID registers to sys_regs file
  kvm: arm64: introduce check_user
  kvm: arm64: implement check_user for ID registers
  kvm: arm64: make ID registers configurable
  kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension

 Documentation/virt/kvm/api.rst      |   8 +
 arch/arm64/include/asm/cpufeature.h |   4 +
 arch/arm64/include/asm/kvm_coproc.h |   2 +
 arch/arm64/include/asm/kvm_host.h   |   3 +
 arch/arm64/kernel/cpufeature.c      |  36 +++
 arch/arm64/kvm/arm.c                |   3 +
 arch/arm64/kvm/sys_regs.c           | 481 +++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.h           |   6 +
 include/uapi/linux/kvm.h            |   1 +
 9 files changed, 532 insertions(+), 12 deletions(-)

-- 
2.26.2

