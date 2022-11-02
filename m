Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816BC615F1A
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 10:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiKBJMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 05:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiKBJLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 05:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597EF286FE
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 02:10:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E29C61890
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59FCC433C1;
        Wed,  2 Nov 2022 09:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667380251;
        bh=3NBoQ3ldUa+yOxeyENfnkBM2LyM5YloHDrknbDGq34c=;
        h=From:To:Cc:Subject:Date:From;
        b=sRjh0cGisFS4038BuCp8168oQUNIM6TzP9MDeK+A0wKFoWjwjVx2qpg6D7I8+JyP1
         Nungr/01NBkg9bQ2/wrYS9KsVKk/U/K4phdPtTVG0QfUBI9S6hkvxIYc0qISXh4Uis
         2Hk5bYADdWLGMR1Y3b9i9lDzbWHbSbzPNVRPDm7VpDX+g0QHelLg0YN/TCTAVvmVUF
         PLHc/0axacHTHKo0BLh9V9YdGUVCNYoWS2eyIm3aUtOqC+4Ir+bfQ5htnxgs9vZuun
         V+hLoiGyqYPG1BbzEfTnZgKIPTf3SPxrHVsBwLvVi8brtpVFTA/O1rAMtPBl/dIIFV
         bDkug7413Jmfg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oq9lo-003AWO-FX;
        Wed, 02 Nov 2022 09:10:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Gavin Shan <gshan@redhat.com>, Mark Brown <broonie@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.1, take #3
Date:   Wed,  2 Nov 2022 09:10:36 +0000
Message-Id: <20221102091036.2106882-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com, gshan@redhat.com, broonie@kernel.org, oliver.upton@linux.dev, qperret@google.com, ryan.roberts@arm.com, seanjc@google.com, steven.price@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's another set of fixes for 6.1. Two of them are critical fixes
(MTE support triggering an invalid pointer dereference in nVHE
configurations, SME trapping not enabled in VHE configurations).
Thankfully, these configuration are pretty rare, because hardly anyone
is making us of MTE yet, and that SME HW simply doesn't exist in the
wild.

The rest is a limited set of fixes for relatively harmless bugs and
documentation update.

Please pull,

	M.

The following changes since commit 247f34f7b80357943234f93f247a1ae6b6c3a740:

  Linux 6.1-rc2 (2022-10-23 15:27:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.1-3

for you to fetch changes up to be0ddf5293a7895a8c9096e1a8560930c6a0ab3f:

  arm64: booting: Document our requirements for fine grained traps with SME (2022-11-01 19:30:34 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.1, take #3

- Fix the pKVM stage-1 walker erronously using the stage-2 accessor

- Correctly convert vcpu->kvm to a hyp pointer when generating
  an exception in a nVHE+MTE configuration

- Check that KVM_CAP_DIRTY_LOG_* are valid before enabling them

- Fix SMPRI_EL1/TPIDR2_EL0 trapping on VHE

- Document the boot requirements for FGT when entering the kernel
  at EL1

----------------------------------------------------------------
Gavin Shan (1):
      KVM: Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL} prior to enabling them

Marc Zyngier (1):
      KVM: arm64: Fix SMPRI_EL1/TPIDR2_EL0 trapping on VHE

Mark Brown (1):
      arm64: booting: Document our requirements for fine grained traps with SME

Quentin Perret (1):
      KVM: arm64: Use correct accessor to parse stage-1 PTEs

Ryan Roberts (1):
      KVM: arm64: Fix bad dereference on MTE-enabled systems

 Documentation/arm64/booting.rst         |  8 ++++++++
 arch/arm64/kvm/hyp/exception.c          |  3 ++-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 20 ++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 26 --------------------------
 arch/arm64/kvm/hyp/vhe/switch.c         |  8 --------
 virt/kvm/kvm_main.c                     |  3 +++
 7 files changed, 34 insertions(+), 36 deletions(-)
