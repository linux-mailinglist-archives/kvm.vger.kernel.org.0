Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A27349123
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 12:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhCYLpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 07:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhCYLov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 07:44:51 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB1BE6191D;
        Thu, 25 Mar 2021 11:44:50 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lPOPw-003jQY-B6; Thu, 25 Mar 2021 11:44:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.12, take #3
Date:   Thu, 25 Mar 2021 11:44:30 +0000
Message-Id: <20210325114430.940449-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com, mark.rutland@arm.com, shameerali.kolothum.thodi@huawei.com, suzuki.poulose@arm.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's another set of fixes for KVM/arm64 in 5.12.

One patch fixes a GICv3 MMIO regression introduced when working around
a firmware bug. The last two patches prevent the guest from messing
with the ARMv8.4 tracing, a new feature that was introduced in 5.12.

Please pull,

	M.

The following changes since commit 1e28eed17697bcf343c6743f0028cc3b5dd88bf0:

  Linux 5.12-rc3 (2021-03-14 14:41:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.12-3

for you to fetch changes up to af22df997d71c32304d6835a8b690281063b8010:

  KVM: arm64: Fix CPU interface MMIO compatibility detection (2021-03-24 17:26:38 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.12, take #3

- Fix GICv3 MMIO compatibility probing
- Prevent guests from using the ARMv8.4 self-hosted tracing extension

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Fix CPU interface MMIO compatibility detection

Suzuki K Poulose (2):
      KVM: arm64: Hide system instruction access to Trace registers
      KVM: arm64: Disable guest access to trace filter controls

 arch/arm64/include/asm/kvm_arm.h | 1 +
 arch/arm64/kernel/cpufeature.c   | 1 -
 arch/arm64/kvm/debug.c           | 2 ++
 arch/arm64/kvm/hyp/vgic-v3-sr.c  | 9 +++++++++
 4 files changed, 12 insertions(+), 1 deletion(-)
