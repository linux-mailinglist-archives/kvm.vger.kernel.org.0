Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C951392C08
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 12:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbhE0Knj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 06:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236224AbhE0Kni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 06:43:38 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A4D613BA;
        Thu, 27 May 2021 10:42:05 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lmDSl-003vFU-67; Thu, 27 May 2021 11:42:03 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Steven Price <steven.price@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.13, take #2
Date:   Thu, 27 May 2021 11:41:31 +0100
Message-Id: <20210527104131.65624-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, mark.rutland@arm.com, steven.price@arm.com, yuzenghui@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the second batch of KVM/arm64 fixes for 5.13. One is a fix for
a long standing bug that allowed the creation of mixed 32/64bit VMs
(which makes zero sense), and yet another bug fix for the state commit
on exit to userspace.

Please pull,

	M.

The following changes since commit cb853ded1d25e5b026ce115dbcde69e3d7e2e831:

  KVM: arm64: Fix debug register indexing (2021-05-15 10:27:59 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.13-2

for you to fetch changes up to 66e94d5cafd4decd4f92d16a022ea587d7f4094f:

  KVM: arm64: Prevent mixed-width VM creation (2021-05-27 10:34:33 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.13, take #2

- Another state update on exit to userspace fix
- Prevent the creation of mixed 32/64 VMs

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Prevent mixed-width VM creation

Zenghui Yu (1):
      KVM: arm64: Resolve all pending PC updates before immediate exit

 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/kvm/arm.c                 |  9 ++++++---
 arch/arm64/kvm/reset.c               | 28 ++++++++++++++++++++++++----
 3 files changed, 35 insertions(+), 7 deletions(-)
