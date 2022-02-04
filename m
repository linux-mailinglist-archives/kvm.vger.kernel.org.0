Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9455B4A9A53
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 14:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359067AbiBDNvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 08:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359070AbiBDNvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 08:51:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C77C061749
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 05:51:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67CF6B83744
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF26C004E1;
        Fri,  4 Feb 2022 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643982688;
        bh=HBeQGeA56RJQC0kVdE6j6svl7AT/tnn/cVac/ZjQWy0=;
        h=From:To:Cc:Subject:Date:From;
        b=KhokMH1VHQQvia2HwWjHR5vlsBLwruWzSopNXvdG4M0qwRrQZ6iTqwy6dzo928gmT
         OCtas90A5XlB+0nZ+3JhtIyVYvF1U535QsO7qWWiSv1PMXQ9/KCoLPn/izeFAlrxMg
         uz4vxEALb4yCcbP0OmEizQoMYgSAexu6mfxpw9zdMokgkZt5clhwlFgeJIDGGB8g8n
         72N4cEdYxPOiCNmiRILjNyASOMOzlcsvx7hggfpkMRhk1mminwKTlhVPPTKgXjaURG
         DOylWpEjZWxCyXFxpXyp6It/RDQ7KjunHuI+IAUXMWOT5BVn/EDfdeih9x2afm6axW
         sbBDPbGOFk+PQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nFyzl-005PIR-N8; Fri, 04 Feb 2022 13:51:25 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Steven Price <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.17, take #2
Date:   Fri,  4 Feb 2022 13:51:20 +0000
Message-Id: <20220204135120.1000894-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, james.morse@arm.com, steven.price@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's a handful of fixes for -rc3, all courtesy of James Morse.

Please pull,

	M.

The following changes since commit 26291c54e111ff6ba87a164d85d4a4e134b7315c:

  Linux 5.17-rc2 (2022-01-30 15:37:07 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-2

for you to fetch changes up to 1dd498e5e26ad71e3e9130daf72cfb6a693fee03:

  KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata (2022-02-03 09:22:30 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.17, take #2

- A couple of fixes when handling an exception while a SError has been
  delivered

- Workaround for Cortex-A510's single-step[ erratum

----------------------------------------------------------------
James Morse (3):
      KVM: arm64: Avoid consuming a stale esr value when SError occur
      KVM: arm64: Stop handle_exit() from handling HVC twice when an SError occurs
      KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata

 Documentation/arm64/silicon-errata.rst  |  2 ++
 arch/arm64/Kconfig                      | 16 ++++++++++++++++
 arch/arm64/kernel/cpu_errata.c          |  8 ++++++++
 arch/arm64/kvm/handle_exit.c            |  8 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++++++++++--
 arch/arm64/tools/cpucaps                |  5 +++--
 6 files changed, 58 insertions(+), 4 deletions(-)
