Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B4026D160
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 05:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgIQDBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 23:01:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41532 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbgIQDBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 23:01:08 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2924B8737466F9CFAE96;
        Thu, 17 Sep 2020 11:01:06 +0800 (CST)
Received: from localhost (10.174.185.104) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 17 Sep 2020
 11:00:56 +0800
From:   Ying Fang <fangying1@huawei.com>
To:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <drjones@redhat.com>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>,
        <zhang.zhanghailiang@huawei.com>, <alex.chen@huawei.com>,
        Ying Fang <fangying1@huawei.com>
Subject: [RFC PATCH 0/2] KVM: arm64: Add support for setting MPIDR
Date:   Thu, 17 Sep 2020 11:00:51 +0800
Message-ID: <20200917030053.1747-1-fangying1@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.104]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MPIDR is used to show multiprocessor affinity on arm platform. It is
also used to provide an additional processor identification mechanism
for scheduling purposes. To add support for setting MPIDR from usersapce
an vcpu ioctl KVM_CAP_ARM_MP_AFFINITY is introduced. This patch series is
needed to help qemu to build the accurate cpu topology for arm.

Ying Fang (2):
  KVM: arm64: add KVM_CAP_ARM_MP_AFFINITY extension
  kvm/arm: Add mp_affinity for arm vcpu

 Documentation/virt/kvm/api.rst    |  8 ++++++++
 arch/arm64/include/asm/kvm_host.h |  5 +++++
 arch/arm64/kvm/arm.c              |  9 +++++++++
 arch/arm64/kvm/reset.c            | 11 +++++++++++
 arch/arm64/kvm/sys_regs.c         | 30 +++++++++++++++++++-----------
 include/uapi/linux/kvm.h          |  3 +++
 6 files changed, 55 insertions(+), 11 deletions(-)

-- 
2.23.0

