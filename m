Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4305BD381
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 19:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiISRTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 13:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiISRTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 13:19:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31783AE4F
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 10:19:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3DAA61A78
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 17:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C937C433D6;
        Mon, 19 Sep 2022 17:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663607951;
        bh=/6Dpa36lpQvVkyg4qWX2MshLEYQ4S8uTcS2pu3wX/cU=;
        h=From:To:Cc:Subject:Date:From;
        b=e7CBgrh8bngeE5AEml19WKF239x2wfE7bJdgY62sxaMbCf8BkJmR6nprIe8MUcY3Y
         ba9SGg4iNSfzAfcZQfzDKPR7lvlTqTwLvdJYGItQb/NtS5fYECO8ua3WzXuLfY6CfY
         Kq2qwWz78K0+10IOOFLrs6IGVYrMP5ZG9wZxLLFg06YhLeiFWKdTUpbLH7U0nnwW2H
         SY0Hka/otgNTlS8Xjp1nHcT1mthAMiOjXuhZSH4GlL3m6JvKDJkeEx7QAArCTzlwSU
         Q0MTtcQvY8Awcuz7llWPALnTqoSQ7Sx0f2GS7tkrrmT+XiQeBDgfS63Tl3J9PcDM11
         Gq2MTo2l4DgVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oaKQG-00BAdf-Pb;
        Mon, 19 Sep 2022 18:19:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.0, take #2
Date:   Mon, 19 Sep 2022 18:18:43 +0100
Message-Id: <20220919171843.2605597-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's the last KVM/arm64 pull request for this cycle, with
a small fix for pKVM and kmemleak.

Please pull,

        M.

The following changes since commit 1c23f9e627a7b412978b4e852793c5e3c3efc555:

  Linux 6.0-rc2 (2022-08-21 17:32:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.0-2

for you to fetch changes up to 522c9a64c7049f50c7b1299741c13fac3f231cd4:

  KVM: arm64: Use kmemleak_free_part_phys() to unregister hyp_mem_base (2022-09-19 17:59:48 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.0, take #2

- Fix kmemleak usage in Protected KVM (again)

----------------------------------------------------------------
Zenghui Yu (1):
      KVM: arm64: Use kmemleak_free_part_phys() to unregister hyp_mem_base

 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
