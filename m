Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E97ED19201B
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 05:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgCYE0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 00:26:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgCYE0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 00:26:42 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EBDB983B08E26A5DEBB8;
        Wed, 25 Mar 2020 12:26:38 +0800 (CST)
Received: from linux-kDCJWP.huawei.com (10.175.104.212) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 25 Mar 2020 12:26:28 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jay Zhou <jianjay.zhou@huawei.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH 0/3] KVM: arm64: Some optimizations about enabling dirty log
Date:   Wed, 25 Mar 2020 12:24:20 +0800
Message-ID: <20200325042423.12181-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.212]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is for "queue" branch of [1] and based on patches[2].
It brings obvious time decreasement for migration with different page
size.

The QEMU counterpart will be sent out later, thanks.

[1] git://git.kernel.org/pub/scm/virt/kvm/kvm.git
[2] https://lore.kernel.org/kvm/20200227013227.1401-1-jianjay.zhou@huawei.com/

Keqian Zhu (3):
  KVM/memslot: Move the initial set of dirty bitmap to arch
  KVM/arm64: Support enabling dirty log graually in small chunks
  KVM/arm64: Only set bits of dirty bitmap with valid translation
    entries

 Documentation/virt/kvm/api.rst    |   2 +-
 arch/arm/include/asm/kvm_host.h   |   2 -
 arch/arm64/include/asm/kvm_host.h |   5 +-
 arch/x86/kvm/x86.c                |   3 +
 virt/kvm/arm/mmu.c                | 175 +++++++++++++++++++++++++-----
 virt/kvm/kvm_main.c               |   3 -
 6 files changed, 157 insertions(+), 33 deletions(-)

-- 
2.19.1

