Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75220307D41
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhA1SAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhA1R7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 12:59:23 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4C464E0E;
        Thu, 28 Jan 2021 17:58:43 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l5BZ2-00AfSI-Va; Thu, 28 Jan 2021 17:58:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Scull <ascull@google.com>,
        David Brazdil <dbrazdil@google.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.11, take #3
Date:   Thu, 28 Jan 2021 17:58:30 +0000
Message-Id: <20210128175830.3035035-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ascull@google.com, dbrazdil@google.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Hopefully this is the last KVM/arm64 fix for 5.11, addressing a
register corruption at boot time, which got unnoticed until Andrew had
a closer look at it. Thankfully, this is only in 5.11, so it was
caught in time.

Please pull,

	M.

The following changes since commit 139bc8a6146d92822c866cf2fd410159c56b3648:

  KVM: Forbid the use of tagged userspace addresses for memslots (2021-01-21 14:17:36 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.11-3

for you to fetch changes up to e500b805c39daff2670494fff94909d7e3d094d9:

  KVM: arm64: Don't clobber x4 in __do_hyp_init (2021-01-25 15:50:35 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.11, take #3

- Avoid clobbering extra registers on initialisation

----------------------------------------------------------------
Andrew Scull (1):
      KVM: arm64: Don't clobber x4 in __do_hyp_init

 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)
