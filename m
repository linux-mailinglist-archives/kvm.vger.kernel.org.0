Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB79459856A
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 16:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245660AbiHROJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 10:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245665AbiHROJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 10:09:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405306E893
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 07:08:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB731B821BC
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 14:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886A8C433D6;
        Thu, 18 Aug 2022 14:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660831735;
        bh=X1Q1sXj76atg/ztMAloIPiEyVV7Q9AK3llXhBBs0MmA=;
        h=From:To:Cc:Subject:Date:From;
        b=bo6wLDFENY/dx4DUWVormN+6hJ5A9pYQFMzpjuywKvF4lhCF+9O4x3tMACBV/BR3m
         e5TiY1hNZgAXb0IE1gePs0l4oShBGznPAUEDn/47qxNSqBAGSnbQ4LApjarbeeCC+4
         UuzzNcQAeNuJdPt5EV+Q+ztevu97V6mtbz6PlBfjaoT+3uxr5htsyLqoFRX9iyb7oe
         LfKQwU47K+rMc5ZHoN/GSKYZpcZqsO++RO34SjYhRaupsqeu5J5tJwA3aRS3kZvsWa
         VU2npwUtwjPxFtW+KFfVL3Z+HZrWQFuHisn+pCtqx27bmugcKoY9kS1B1kr8jzEGo+
         z7rAGjyS04eRA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oOgCb-0040U4-HY;
        Thu, 18 Aug 2022 15:08:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Yang Yingliang <yangyingliang@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 6.0, take #1
Date:   Thu, 18 Aug 2022 15:08:44 +0100
Message-Id: <20220818140844.2312534-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oliver.upton@linux.dev, yangyingliang@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
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

Paolo,

Here's a small set of KVM/arm64 fixes for 6.0, the most visible thing
being a better handling of systems with asymmetric AArch32 support.

Please pull,

	M.

The following changes since commit 0982c8d859f8f7022b9fd44d421c7ec721bb41f9:

  Merge branch kvm-arm64/nvhe-stacktrace into kvmarm-master/next (2022-07-27 18:33:27 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.0-1

for you to fetch changes up to b10d86fb8e46cc812171728bcd326df2f34e9ed5:

  KVM: arm64: Reject 32bit user PSTATE on asymmetric systems (2022-08-17 10:29:07 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.0, take #1

- Fix unexpected sign extension of KVM_ARM_DEVICE_ID_MASK

- Tidy-up handling of AArch32 on asymmetric systems

----------------------------------------------------------------
Oliver Upton (2):
      KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
      KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

Yang Yingliang (1):
      KVM: arm64: Fix compile error due to sign extension

 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/include/uapi/asm/kvm.h | 6 ++++--
 arch/arm64/kvm/arm.c              | 3 +--
 arch/arm64/kvm/guest.c            | 2 +-
 arch/arm64/kvm/sys_regs.c         | 4 ++--
 5 files changed, 12 insertions(+), 7 deletions(-)
