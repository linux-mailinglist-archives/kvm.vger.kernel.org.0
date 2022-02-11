Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6884B2404
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 12:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiBKLLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 06:11:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiBKLLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 06:11:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984D8E38
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:11:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 342A0616F4
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 11:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE00C340E9;
        Fri, 11 Feb 2022 11:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644577894;
        bh=XcXopvQueCV0LSDmB58A44DQ/iBicjp0IvAb57hZnvQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ONspbpiEBIBYIIHqwLaIhxvCBiTEOSvWECoAhAyBJO9ub6Di8pnDcH+NwBjwimWqb
         4uIawp9P78OeMPYKeDVL0Ilsiw/M1EEd+YwxMERcZj/cWKpegmKfs1wTlSvWGNcUh5
         lAd47lzfGbtQodVIj+uqAWJVF3TWHv+my0NMrQfD3Eb3aP87ps5iLP5OhxzVWa+J4r
         +PHY+mqni4tcTVce+4v579ukOcF+kCh08kkKRpDiGhjGr0Zy2pO344xngKquCkeNvr
         TsuDt3jLMvAz+XjEiOhAi3wSwhft0Cnfj417fcS0u3kqwiNVLYkVNnoCcSlAX7TXBd
         8qXHaHJlgui4A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nITps-0079Ec-Hw; Fri, 11 Feb 2022 11:11:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.17, take #3
Date:   Fri, 11 Feb 2022 11:11:29 +0000
Message-Id: <20220211111129.1180161-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ricarkol@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com
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

Here's a single fix for 5.7, addressing a minor defect affecting HW
how the pending state of HW interrupts is reported via the MMIO
interface of the GIC.

Please pull,

	M.

The following changes since commit 1dd498e5e26ad71e3e9130daf72cfb6a693fee03:

  KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata (2022-02-03 09:22:30 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-3

for you to fetch changes up to 5bfa685e62e9ba93c303a9a8db646c7228b9b570:

  KVM: arm64: vgic: Read HW interrupt pending state from the HW (2022-02-11 11:01:12 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.17, take #3

- Fix pending state read of a HW interrupt

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: vgic: Read HW interrupt pending state from the HW

 arch/arm64/kvm/vgic/vgic-mmio.c | 2 ++
 1 file changed, 2 insertions(+)
