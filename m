Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC20818F7
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 14:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfHEMQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 08:16:17 -0400
Received: from foss.arm.com ([217.140.110.172]:47188 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbfHEMQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 08:16:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 363CC337;
        Mon,  5 Aug 2019 05:16:17 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EE773F706;
        Mon,  5 Aug 2019 05:16:15 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH 0/2] KVM: arm/arm64: Revamp sysreg reset checks
Date:   Mon,  5 Aug 2019 13:15:53 +0100
Message-Id: <20190805121555.130897-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The way we deal with sysreg reset is terrible, as we write junk to
them while other parts of the system may be evaluating these. That's
obviously wrong. Instead, let's switch to a mode where we track which
sysregs have had a reset function applied to them.

The result is less bad, but my gut feeling is that we'd be better of
without any of this. Comments welcome.

Marc Zyngier (2):
  KVM: arm64: Don't write junk to sysregs on reset
  KVM: arm: Don't write junk to CP15 registers on reset

 arch/arm/kvm/coproc.c     | 23 +++++++++++++++--------
 arch/arm64/kvm/sys_regs.c | 32 ++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 22 deletions(-)

-- 
2.20.1

