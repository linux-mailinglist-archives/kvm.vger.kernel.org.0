Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB31A4C459B
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 14:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241029AbiBYNNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 08:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239043AbiBYNNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 08:13:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91461B7605
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:13:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1145B61C54
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 13:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E594C340E7;
        Fri, 25 Feb 2022 13:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645794789;
        bh=4OBpMBBHbqfE56ZBzZuNT14cSYoLBRUNEKj3d9XwRKg=;
        h=From:To:Cc:Subject:Date:From;
        b=axHqA1NTSELIxujgopmdO7bncVhWMLiNBuyj43f35EQ8KGzPa/h0POOZjeTqrBUcy
         fPdHZHZU3+yzm58hkNeCRL1yq3mK5KqV6/1CK7jyxRu6L9Tl6kcvOIvNkASr8gV+6U
         t/IYR+ADu8JunosPGA7HzbCUOu+7YR1nq6vPZtJkMoPVRHMO5ZabYw0D6YwsHA7tvx
         zkdm2HSnjSu6xEq6a4/rDPIKlKBO1tbMA119S5b4djhcLxP9ljGvvt1g2ztXUUP3vQ
         7S0CJstba87RQIY8sJbxpih4Kq6tkBnS4VjBSCylvXN2RBQU9kAaWTLVYn1tN87vA/
         HpRVzbh3/wvWA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nNaPC-00AWbe-Tx; Fri, 25 Feb 2022 13:13:07 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.17, take #4
Date:   Fri, 25 Feb 2022 13:13:02 +0000
Message-Id: <20220225131302.107215-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, drjones@redhat.com, broonie@kernel.org, oupton@google.com, ricarkol@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Only a couple of fixes this time around: one for the long standing
PSCI CPU_SUSPEND issue, and a selftest fix for systems that don't have
a GICv3.

Please pull,

	M.

The following changes since commit 5bfa685e62e9ba93c303a9a8db646c7228b9b570:

  KVM: arm64: vgic: Read HW interrupt pending state from the HW (2022-02-11 11:01:12 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-4

for you to fetch changes up to 456f89e0928ab938122a40e9f094a6524cc158b4:

  KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3 (2022-02-25 13:02:28 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.17, take #4

- Correctly synchronise PMR and co on PSCI CPU_SUSPEND

- Skip tests that depend on GICv3 when the HW isn't available

----------------------------------------------------------------
Mark Brown (1):
      KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3

Oliver Upton (1):
      KVM: arm64: Don't miss pending interrupts for suspended vCPU

 arch/arm64/kvm/psci.c                            | 3 +--
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 7 ++++++-
 tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 4 ++++
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   | 4 +++-
 4 files changed, 14 insertions(+), 4 deletions(-)
