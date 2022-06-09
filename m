Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FB0544E8C
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 16:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239258AbiFIORy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 10:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiFIORx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 10:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321FF14B2CD
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 07:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2A6F61DC5
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 14:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A53C34114;
        Thu,  9 Jun 2022 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654784271;
        bh=kJkLKSYMhSBwA9NtLKwJ+0pfq4+7mhggk7YAmP0J9Mc=;
        h=From:To:Cc:Subject:Date:From;
        b=Wf7AUsBWT3hqYpXrvTnOKNI6Qub1Ehc3Yd0iwDD/j0zOm2blaHob+b5Uakqs1rBHp
         LtmkXZQ6ObaXZ/VQGfTi4JjCdMob/VU892p7oZEtOPveP+Lkq7RVxK1IfhStH0C/oC
         +E5j6Xd12e1Lj02VmYmsdN37h9Y5dmoUoqWuEIFXIOEXowQGYRjaBjrnWlGK9XffL0
         5J2mrN+KlZHPets+bNCklX1kAWL3KkmlPaNL4GR/VvBbFRL0w5aOcJqSXMRGWql07r
         tNXeQ2P1k/E06+WTQnl6YSBOuR++3FMQHYfjo5MFqIrkio/5EhZpq2Ps0vGKn0PfBc
         MK7XdgSLB4ZlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzIyq-00Gtbd-Lw; Thu, 09 Jun 2022 15:17:48 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        sunliming <sunliming@kylinos.cn>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oupton@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.19, take #1
Date:   Thu,  9 Jun 2022 15:17:31 +0100
Message-Id: <20220609141731.1197304-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, dbrazdil@google.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, sunliming@kylinos.cn, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oupton@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the first set of fixes for 5.19. Nothing major (one fix for the
GICv2 emulation, one for the embryonic protected VM support), the rest
being a bunch of small scale cleanup that I have decided to take now
rather than leaving them for later.

Please pull,

	M.

The following changes since commit f2906aa863381afb0015a9eb7fefad885d4e5a56:

  Linux 5.19-rc1 (2022-06-05 17:18:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.19-1

for you to fetch changes up to bcbfb588cf323929ac46767dd14e392016bbce04:

  KVM: arm64: Drop stale comment (2022-06-09 13:24:02 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.19, take #1

- Properly reset the SVE/SME flags on vcpu load

- Fix a vgic-v2 regression regarding accessing the pending
  state of a HW interrupt from userspace (and make the code
  common with vgic-v3)

- Fix access to the idreg range for protected guests

- Ignore 'kvm-arm.mode=protected' when using VHE

- Return an error from kvm_arch_init_vm() on allocation failure

- A bunch of small cleanups (comments, annotations, indentation)

----------------------------------------------------------------
Marc Zyngier (7):
      KVM: arm64: Always start with clearing SVE flag on load
      KVM: arm64: Always start with clearing SME flag on load
      KVM: arm64: Don't read a HW interrupt pending state in user context
      KVM: arm64: Replace vgic_v3_uaccess_read_pending with vgic_uaccess_read_pending
      KVM: arm64: Warn if accessing timer pending state outside of vcpu context
      KVM: arm64: Handle all ID registers trapped for a protected VM
      KVM: arm64: Drop stale comment

Will Deacon (4):
      KVM: arm64: Return error from kvm_arch_init_vm() on allocation failure
      KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
      KVM: arm64: Extend comment in has_vhe()
      KVM: arm64: Remove redundant hyp_assert_lock_held() assertions

sunliming (1):
      KVM: arm64: Fix inconsistent indenting

 Documentation/admin-guide/kernel-parameters.txt |  1 -
 arch/arm64/include/asm/kvm_host.h               |  5 ---
 arch/arm64/include/asm/virt.h                   |  3 ++
 arch/arm64/kernel/cpufeature.c                  | 10 +-----
 arch/arm64/kvm/arch_timer.c                     |  3 ++
 arch/arm64/kvm/arm.c                            | 10 ++++--
 arch/arm64/kvm/fpsimd.c                         |  2 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c           |  4 ---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c              | 42 ++++++++++++++++++++-----
 arch/arm64/kvm/vgic/vgic-mmio-v2.c              |  4 +--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c              | 40 ++---------------------
 arch/arm64/kvm/vgic/vgic-mmio.c                 | 40 ++++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic-mmio.h                 |  3 ++
 arch/arm64/kvm/vmid.c                           |  2 +-
 14 files changed, 95 insertions(+), 74 deletions(-)
