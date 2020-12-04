Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAA92CF3DF
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgLDSUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:20:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729472AbgLDSUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:20:41 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9FF322B4E;
        Fri,  4 Dec 2020 18:20:00 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1klFgU-00G3EZ-ID; Fri, 04 Dec 2020 18:19:58 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Keqian Zhu <zhukeqian1@huawei.com>, Will Deacon <will@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>, kernel-team@android.com,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 5.10, take #5
Date:   Fri,  4 Dec 2020 18:19:11 +0000
Message-Id: <20201204181914.783445-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, zhukeqian1@huawei.com, will@kernel.org, wangyanan55@huawei.com, kernel-team@android.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

A week ago, I was hoping being done with the 5.10 fixes. I should
obviously know better.

Thanks to Yanan's excellent work, we have another set of page table
fixes, all plugging issues introduced with our new page table code.
The problems range from memory leak to TLB conflicts, all of which are
serious enough to be squashed right away.

Are we done yet? Fingers crossed.

Please pull,

	M.

The following changes since commit 23bde34771f1ea92fb5e6682c0d8c04304d34b3b:

  KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace (2020-11-17 18:51:09 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-5

for you to fetch changes up to 7d894834a305568a0168c55d4729216f5f8cb4e6:

  KVM: arm64: Add usage of stage 2 fault lookup level in user_mem_abort() (2020-12-02 09:53:29 +0000)

----------------------------------------------------------------
kvm/arm64 fixes for 5.10, take #5

- Don't leak page tables on PTE update
- Correctly invalidate TLBs on table to block transition
- Only update permissions if the fault level matches the
  expected mapping size

----------------------------------------------------------------
Yanan Wang (3):
      KVM: arm64: Fix memory leak on stage2 update of a valid PTE
      KVM: arm64: Fix handling of merging tables into a block entry
      KVM: arm64: Add usage of stage 2 fault lookup level in user_mem_abort()

 arch/arm64/include/asm/esr.h         |  1 +
 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/kvm/hyp/pgtable.c         | 17 ++++++++++++++++-
 arch/arm64/kvm/mmu.c                 | 11 +++++++++--
 4 files changed, 31 insertions(+), 3 deletions(-)
