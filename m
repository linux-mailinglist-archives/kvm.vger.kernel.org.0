Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DE5270306
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 19:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgIRRRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 13:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgIRRRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 13:17:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A805421707;
        Fri, 18 Sep 2020 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600449443;
        bh=dT/SIIBfk6PdNJR5wifdnUhvj/zHp9ljO8pxvLb8ouI=;
        h=From:To:Cc:Subject:Date:From;
        b=sScf8brvcJJZ1OIxlPXSE1vyOhRAJ5bWUdN6HZa64ks2ni7AZwUMHOnkWSDlqXw4e
         xtXYTKivF9Gu6fe7f3g/dWxh721wKq0KoLRgqv36d8C5Tyt/J9fwZajTktVbkzsjGR
         POg34ttD0fKp8lZK5OLvELOcV3sNsBevkCMuyI44=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kJK0f-00D4ZN-PC; Fri, 18 Sep 2020 18:17:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Will Deacon <will@kernel.org>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.9, take #2
Date:   Fri, 18 Sep 2020 18:16:49 +0100
Message-Id: <20200918171651.1340445-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, will@kernel.org, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the latest set of fixes for 5.9. The first patch is pretty
nasty, as a guest hitting this bug will have its vcpu stuck on a
fault, without any hope of it being resolved. Embarrassing, and
definitely a stable candidate. The second patch is only a cleanup
after the first one.

Please pull,

	M.

The following changes since commit 7b75cd5128421c673153efb1236705696a1a9812:

  KVM: arm64: Update page shift if stage 2 block mapping not supported (2020-09-04 10:53:48 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.9-2

for you to fetch changes up to 620cf45f7a516bf5fe9e5dce675a652e935c8bde:

  KVM: arm64: Remove S1PTW check from kvm_vcpu_dabt_iswrite() (2020-09-18 18:01:48 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.9, take #2

- Fix handling of S1 Page Table Walk permission fault at S2
  on instruction fetch
- Cleanup kvm_vcpu_dabt_iswrite()

----------------------------------------------------------------
Marc Zyngier (2):
      KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch
      KVM: arm64: Remove S1PTW check from kvm_vcpu_dabt_iswrite()

 arch/arm64/include/asm/kvm_emulate.h    | 14 +++++++++++---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/mmu.c                    |  4 ++--
 3 files changed, 14 insertions(+), 6 deletions(-)
