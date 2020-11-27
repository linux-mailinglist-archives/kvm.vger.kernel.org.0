Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F108C2C63D3
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 12:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgK0LVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 06:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729265AbgK0LVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 06:21:22 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DF2420B80;
        Fri, 27 Nov 2020 11:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606476081;
        bh=fS6mF1IDPaTZHP4+FiQm7nj4O1emt6KtMrKo/Vv9QOc=;
        h=From:To:Cc:Subject:Date:From;
        b=kCn5yoOc6ucB2MaxXimiA11mtBW5b7w5jKlVWS+s12qCYG6LSHjmiqy+k2ejZBkv3
         XElrP4//E0eXdoRXTavH98gI/PnZRvEgzpQ4Y/ln8xpg4QBUKyoGXnql/wf9OLMk/+
         zBphLzrdbtGS3HJvO13T9ICBUY2NsoWmCV/Fr1Ro=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kiboU-00E2fR-Nq; Fri, 27 Nov 2020 11:21:18 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jamie Iles <jamie@nuviainc.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 5.10, take #4
Date:   Fri, 27 Nov 2020 11:20:59 +0000
Message-Id: <20201127112101.658224-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, eric.auger@redhat.com, jamie@nuviainc.com, zhukeqian1@huawei.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

This is hopefully the last set of fixes for 5.10. We have a linker
script fix addressing the alignment requirement for the way we now
build the EL2 code, and a fix for a long standing bug affecting
userspace access to the GICR_TYPER registers.

Please pull,

	M.

The following changes since commit ed4ffaf49bf9ce1002b516d8c6aa04937b7950bc:

  KVM: arm64: Handle SCXTNUM_ELx traps (2020-11-12 21:22:46 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-4

for you to fetch changes up to 23bde34771f1ea92fb5e6682c0d8c04304d34b3b:

  KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace (2020-11-17 18:51:09 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for v5.10, take #4

- Fix alignment of the new HYP sections
- Fix GICR_TYPER access from userspace

----------------------------------------------------------------
Jamie Iles (1):
      KVM: arm64: Correctly align nVHE percpu data

Zenghui Yu (1):
      KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace

 arch/arm64/kvm/hyp/nvhe/hyp.lds.S  |  5 +++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 22 ++++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)
