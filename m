Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7375A21560E
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 13:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgGFLFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 07:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbgGFLFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 07:05:34 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B4720702;
        Mon,  6 Jul 2020 11:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594033533;
        bh=9kr+e0WqelRZAHC+EjyVK5a1yKFu0am5W9PV61qCJ/M=;
        h=From:To:Cc:Subject:Date:From;
        b=nb5VlpUdrMtbaFj/LREbkP6egDcLJFXP6Sff1ggM3a5LaJ6WtxR3pOoeSivdGX45A
         THNSajLGhpHwtoQpmKVvTmTJG8PrwvUYuOVrU2CjnDVhF+2k6zyWCkPmyhOyRVvk34
         +PVzJu27gPv5R1w3nDuxuNY+DqDC4bLlHIUcMVco=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jsOwF-009Qgb-WF; Mon, 06 Jul 2020 12:05:32 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Scull <ascull@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] KVM/arm64 fixes for 5.8, take #3
Date:   Mon,  6 Jul 2020 12:05:19 +0100
Message-Id: <20200706110521.1615794-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ascull@google.com, amurray@thegoodpenguin.co.uk, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Yet another small batch of fixes for 5.8. One is a long standing
preemption issue that got uncovered by another fix that went in
5.8. The other one is a fix for an issue potentially affecting kexec.

Please pull,

	M.

The following changes since commit a3f574cd65487cd993f79ab235d70229d9302c1e:

  KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell (2020-06-23 11:24:39 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-3

for you to fetch changes up to b9e10d4a6c9f5cbe6369ce2c17ebc67d2e5a4be5:

  KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART (2020-07-06 11:47:02 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.8, take #3

- Disable preemption on context-switching PMU EL0 state happening
  on system register trap
- Don't clobber X0 when tearing down KVM via a soft reset (kexec)

----------------------------------------------------------------
Andrew Scull (1):
      KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART

Marc Zyngier (1):
      KVM: arm64: PMU: Fix per-CPU access in preemptible context

 arch/arm64/kvm/hyp-init.S | 11 +++++++----
 arch/arm64/kvm/pmu.c      |  7 ++++++-
 2 files changed, 13 insertions(+), 5 deletions(-)
