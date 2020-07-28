Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9516823053C
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 10:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgG1IXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 04:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgG1IXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 04:23:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E64A2075D;
        Tue, 28 Jul 2020 08:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595924604;
        bh=s+JcctlNG0hHX2xEwi6C3ENfXMCtVb68JpHdq0Skmw4=;
        h=From:To:Cc:Subject:Date:From;
        b=FhwUUQidy339zU5Wogz7l7ZnPOqzOczutbqIH2gK1BTX5z0NE9l7Ve489HTCVByJR
         5FoMU64OWFU+Dy1nx65lqauBVZMUso+rxZB+85ve4BCguqOnD/Wqy9eerAg2rICaOl
         8x8WSiJjUkToSjV+fWon8nmzf7GyS8B66OyclbPA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k0KtO-00FaXh-S3; Tue, 28 Jul 2020 09:23:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.8, take #4
Date:   Tue, 28 Jul 2020 09:22:53 +0100
Message-Id: <20200728082255.3864378-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, natechancellor@gmail.com, ndesaulniers@google.com, qperret@google.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

This is the last batch of fixes for 5.8. One fixes a long standing MMU
issue, while the other addresses a more recent brekage with out-of-line
helpers in the nVHE code.

Please pull,

	M.

The following changes since commit b9e10d4a6c9f5cbe6369ce2c17ebc67d2e5a4be5:

  KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART (2020-07-06 11:47:02 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-4

for you to fetch changes up to b757b47a2fcba584d4a32fd7ee68faca510ab96f:

  KVM: arm64: Don't inherit exec permission across page-table levels (2020-07-28 09:03:57 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for Linux 5.8, take #3

- Fix a corner case of a new mapping inheriting exec permission without
  and yet bypassing invalidation of the I-cache
- Make sure PtrAuth predicates oinly generate inline code for the
  non-VHE hypervisor code

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL functions

Will Deacon (1):
      KVM: arm64: Don't inherit exec permission across page-table levels

 arch/arm64/include/asm/kvm_host.h | 11 ++++++++---
 arch/arm64/kvm/mmu.c              | 11 ++++++-----
 2 files changed, 14 insertions(+), 8 deletions(-)
