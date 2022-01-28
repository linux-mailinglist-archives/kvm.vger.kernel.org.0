Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAF749F6E7
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 11:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244402AbiA1KMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 05:12:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54252 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244618AbiA1KMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 05:12:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D43F161E3F
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 10:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C7AC340E0;
        Fri, 28 Jan 2022 10:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643364770;
        bh=T5i4/kQaBQydnAWtJs7opQEEBq6cdMWHwVtmuP6KstY=;
        h=From:To:Cc:Subject:Date:From;
        b=kM7yLy8TwVxIh6xqn8sZrqpFr8k0o/hldx+H3eUQW0DWgiEjcdgibkfgor1x/SvmS
         ol0kYJ90x3TtZeOQ6YuyfIwN1ld1HFPzIpIDPh+NM5LwUL523mNJUR3f8eYKXt7RWA
         sjjOQs6ErhCyaB98dR8urr9H1A91sx1ZKJ6uh2hAGJuFXa3JOaHICRQ2C/7mvdbyLk
         ujcW7aGNfdizlliYiGW+YYWtbzWL7WNFkT5XBAO6BhLcWqQ/jcE/lwsVXUG8pSXF66
         XUh6KXN88kgZhk6gyT+Numj5Ez7BDgBR/kM7s2KVCJcYJiblg6pz42iDT5eqPxrkAx
         YAoG9mX5NxD8Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDOFM-003m9Q-6U; Fri, 28 Jan 2022 10:12:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.17, take #1
Date:   Fri, 28 Jan 2022 10:12:45 +0000
Message-Id: <20220128101245.506715-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ardb@kernel.org, tabba@google.com, qperret@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's a small set of fixes for 5.17. Nothing stands out, just the
usual set of bug fixes. There will be another series next week, but
these patches need a bit of soak time.

Please pull,

	M.

The following changes since commit 1c53a1ae36120997a82f936d044c71075852e521:

  Merge branch kvm-arm64/misc-5.17 into kvmarm-master/next (2022-01-04 17:16:15 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-1

for you to fetch changes up to 278583055a237270fac70518275ba877bf9e4013:

  KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on !VHE (2022-01-24 09:39:03 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.17, take #1

- Correctly update the shadow register on exception injection when
  running in nVHE mode

- Correctly use the mm_ops indirection when performing cache invalidation
  from the page-table walker

- Restrict the vgic-v3 workaround for SEIS to the two known broken
  implementations

----------------------------------------------------------------
Marc Zyngier (3):
      KVM: arm64: pkvm: Use the mm_ops indirection for cache maintenance
      KVM: arm64: vgic-v3: Restrict SEIS workaround to known broken systems
      KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on !VHE

 arch/arm64/kvm/hyp/exception.c  |  5 ++++-
 arch/arm64/kvm/hyp/pgtable.c    | 18 ++++++------------
 arch/arm64/kvm/hyp/vgic-v3-sr.c |  3 +++
 arch/arm64/kvm/vgic/vgic-v3.c   | 17 +++++++++++++++--
 4 files changed, 28 insertions(+), 15 deletions(-)
