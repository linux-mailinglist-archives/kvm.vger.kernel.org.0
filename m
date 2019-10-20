Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D0DDDF9
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2019 12:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfJTKLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Oct 2019 06:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfJTKLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Oct 2019 06:11:35 -0400
Received: from big-swifty.lan (78.163-31-62.static.virginmediabusiness.co.uk [62.31.163.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89A342190F;
        Sun, 20 Oct 2019 10:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571566294;
        bh=R9nxM6A3Yhddcl9A7C/26LLhq+KqjO+NyOwb1yqAA94=;
        h=From:To:Cc:Subject:Date:From;
        b=wZl1P5TR+YzkoKz8Z0Krfdf4skT5kHoKhxSmiYkJoZu/u3uDDGVRFMn0t4GTos/u9
         +masS9rK4tdB5WNUk7ko/gKMJTmaJTpuqTCTETNz91MjZ+XPLk1mF3T/760PDMMKB5
         cAFy5HjwCjjvImUIHXutqDnA9xTObx4YpNbz5uQk=
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm fixes for 5.4-rc5
Date:   Sun, 20 Oct 2019 11:11:25 +0100
Message-Id: <20191020101129.2612-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

Here's the latest (and hopefully last) set of KVM/arm fixes for
5.4. 4 patches exclusively covering our PMU emulation, which exhibited
several different flavours of brokenness.

Please pull,

	M.

The following changes since commit da0c9ea146cbe92b832f1b0f694840ea8eb33cce:

  Linux 5.4-rc2 (2019-10-06 14:27:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.4-2

for you to fetch changes up to 8c3252c06516eac22c4f8e2506122171abedcc09:

  KVM: arm64: pmu: Reset sample period on overflow handling (2019-10-20 10:47:07 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.4, take #2

Special PMU edition:

- Fix cycle counter truncation
- Fix cycle counter overflow limit on pure 64bit system
- Allow chained events to be actually functional
- Correct sample period after overflow

----------------------------------------------------------------
Marc Zyngier (4):
      KVM: arm64: pmu: Fix cycle counter truncation
      arm64: KVM: Handle PMCR_EL0.LC as RES1 on pure AArch64 systems
      KVM: arm64: pmu: Set the CHAINED attribute before creating the in-kernel event
      KVM: arm64: pmu: Reset sample period on overflow handling

 arch/arm64/kvm/sys_regs.c |  4 ++++
 virt/kvm/arm/pmu.c        | 48 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 39 insertions(+), 13 deletions(-)
