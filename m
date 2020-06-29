Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8B520E39C
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 00:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390517AbgF2VPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 17:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729952AbgF2SzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 14:55:16 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 763CF25590;
        Mon, 29 Jun 2020 16:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593447933;
        bh=b7AT4TcF5146z4sJCRxR4jK16TDrwXxT+lOJTb6Ufpk=;
        h=From:To:Cc:Subject:Date:From;
        b=ppSlbCZD1v6btFHB3RK6H6kCie2cN7nclYGsybfoN/y6I9KItoVALr2CbZyQWsGII
         b2XcIwRt89lPrekX19kMY43+jEVICQV2z3kBm29DtIPUXuaw2GbDfm/dJ5tM7kDTQQ
         Q54rERPkFEYFqwuJiy+PdwgWDfTjqfZ84zlgNgI0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jpwb5-007M5T-RJ; Mon, 29 Jun 2020 17:25:31 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Steven Price <steven.price@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 5.8, take #2
Date:   Mon, 29 Jun 2020 17:25:15 +0100
Message-Id: <20200629162519.825200-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, james.morse@arm.com, steven.price@arm.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's another pull request for a handful of KVM/arm64 fixes. Nothing
absolutely critical (see the tag for the gory details), but I'd rather
get these merged as soon as possible.

Please pull,

	M.

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvmarm-fixes-5.8-2

for you to fetch changes up to a3f574cd65487cd993f79ab235d70229d9302c1e:

  KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell (2020-06-23 11:24:39 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.8, take #2

- Make sure a vcpu becoming non-resident doesn't race against the doorbell delivery
- Only advertise pvtime if accounting is enabled
- Return the correct error code if reset fails with SVE
- Make sure that pseudo-NMI functions are annotated as __always_inline

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: Annotate hyp NMI-related functions as __always_inline

Andrew Jones (1):
      KVM: arm64: pvtime: Ensure task delay accounting is enabled

Marc Zyngier (1):
      KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell

Steven Price (1):
      KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect with SVE

 arch/arm64/include/asm/arch_gicv3.h |  2 +-
 arch/arm64/include/asm/cpufeature.h |  2 +-
 arch/arm64/kvm/pvtime.c             | 15 ++++++++++++---
 arch/arm64/kvm/reset.c              | 10 +++++++---
 arch/arm64/kvm/vgic/vgic-v4.c       |  8 ++++++++
 drivers/irqchip/irq-gic-v3-its.c    |  8 ++++++++
 6 files changed, 37 insertions(+), 8 deletions(-)
