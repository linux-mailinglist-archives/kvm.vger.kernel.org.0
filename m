Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83255245B1B
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 05:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgHQDiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 23:38:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9743 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgHQDiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 23:38:16 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 45AAB8ECA51EA1AF71C6;
        Mon, 17 Aug 2020 11:38:13 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 11:38:04 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Steven Price <steven.price@arm.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH 0/3] KVM: arm64: Some fixes and code adjustments for pvtime ST
Date:   Mon, 17 Aug 2020 11:37:26 +0800
Message-ID: <20200817033729.10848-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During picking up pvtime LPT support for arm64, I do some trivial fixes for
pvtime ST.

Keqian Zhu (3):
  KVM: arm64: Some fixes of PV-time interface document
  KVM: uapi: Remove KVM_DEV_TYPE_ARM_PV_TIME in kvm_device_type
  KVM: arm64: Use kvm_write_guest_lock when init stolen time

 Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
 arch/arm64/kvm/pvtime.c               | 6 +-----
 include/uapi/linux/kvm.h              | 2 --
 tools/include/uapi/linux/kvm.h        | 2 --
 4 files changed, 4 insertions(+), 12 deletions(-)

-- 
1.8.3.1

