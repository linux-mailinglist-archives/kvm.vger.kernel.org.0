Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE3A717CAD
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 12:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbjEaKDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 06:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbjEaKDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 06:03:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D729E2
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 03:03:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F9AC63860
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 10:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C27C4339B;
        Wed, 31 May 2023 10:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685527390;
        bh=WS4o4Klej8rzYJcvoUDG55X0zikYJGaEFcX+cEYcoDA=;
        h=From:To:Cc:Subject:Date:From;
        b=uqxevRwQVANNAUERxhbxeE2ao5YT+1Ggg6/ZAHtPoN5PdTpZJXzUNoBkYYFO/rqXu
         xEylrFa7pBF72IXIfvyJDrqGEI/fZxO/ryQvcHvon78dvGi8JQmvnXOzz/jToT5N9O
         Y5bltaIwKJLR03TxX0i58xcZzS4QxPJzb3Brqr3B8+cRSlHBBaaGeZaJvUTa9aVun4
         p58e/MJ9yxuyE0IE/aHvLZKBiIgL+wYK8sNLaf8CDaxFZC0qmfBvcujHMmID5qb9Wg
         Vm3FyFRlXeKXl2pwPKoIa7BYFfHcXJwa1R3m1JSKn1e91kpiJE6sj722mUQ00sdrqK
         a56/fOB49RpdQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q4Ifb-001aAe-Vb;
        Wed, 31 May 2023 11:03:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Akihiko Odaki <akihiko.odaki@daynix.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Yu Zhao <yuzhao@google.com>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.4, take #3
Date:   Wed, 31 May 2023 11:03:05 +0100
Message-Id: <20230531100305.430120-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, akihiko.odaki@daynix.com, nathan@kernel.org, oliver.upton@linux.dev, yuzhao@google.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's the third batch of fixes for 6.4: yet another MMU-related fix,
an external debug bug fix and the obligatory PMU fix.

Note that since you don't seem to have pulled kvmarm-fixes-6.4-2[1]
just yet, pulling this will drag both tags.

Please pull,

	M.

[1] https://lore.kernel.org/r/20230524125757.3631091-1-maz@kernel.org

The following changes since commit a9f0e3d5a089d0844abb679a5e99f15010d53e25:

  KVM: arm64: Reload PTE after invoking walker callback on preorder traversal (2023-05-24 13:47:12 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.4-3

for you to fetch changes up to 40e54cad454076172cc3e2bca60aa924650a3e4b:

  KVM: arm64: Document default vPMU behavior on heterogeneous systems (2023-05-31 10:29:56 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.4, take #3

- Fix the reported address of a watchpoint forwarded to userspace

- Fix the freeing of the root of stage-2 page tables

- Stop creating spurious PMU events to perform detection of the
  default PMU and use the existing PMU list instead.

----------------------------------------------------------------
Akihiko Odaki (1):
      KVM: arm64: Populate fault info for watchpoint

Oliver Upton (3):
      KVM: arm64: Drop last page ref in kvm_pgtable_stage2_free_removed()
      KVM: arm64: Iterate arm_pmus list to probe for default PMU
      KVM: arm64: Document default vPMU behavior on heterogeneous systems

 arch/arm64/kvm/hyp/include/hyp/switch.h |  8 +++--
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 ++
 arch/arm64/kvm/hyp/pgtable.c            |  3 ++
 arch/arm64/kvm/hyp/vhe/switch.c         |  1 +
 arch/arm64/kvm/pmu-emul.c               | 58 +++++++++++++--------------------
 5 files changed, 35 insertions(+), 37 deletions(-)
