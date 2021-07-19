Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED8B3CD4EB
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbhGSL7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 07:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236811AbhGSL7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 07:59:00 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 862716113E;
        Mon, 19 Jul 2021 12:39:40 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m5SYc-00ED65-FZ; Mon, 19 Jul 2021 13:39:38 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, kernel-team@android.com
Subject: [PATCH v2 0/4] kvm-arm64: Fix PMU reset values (and more)
Date:   Mon, 19 Jul 2021 13:38:58 +0100
Message-Id: <20210719123902.1493805-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com, drjones@redhat.com, linux@arm.linux.org.uk, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the second version of the series initially posted at [1].

* From v1:
  - Simplified masking in patch #1
  - Added a patch dropping PMSWINC_EL0 as a shadow register, though it
    is still advertised to userspace for the purpose of backward
    compatibility of VM save/restore
  - Collected ABs/RBs, with thanks

[1] https://lore.kernel.org/r/20210713135900.1473057-1-maz@kernel.org

Alexandre Chartre (1):
  KVM: arm64: Disabling disabled PMU counters wastes a lot of time

Marc Zyngier (3):
  KVM: arm64: Narrow PMU sysreg reset values to architectural
    requirements
  KVM: arm64: Drop unnecessary masking of PMU registers
  KVM: arm64: Remove PMSWINC_EL0 shadow register

 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/pmu-emul.c         |  8 ++--
 arch/arm64/kvm/sys_regs.c         | 70 +++++++++++++++++++++++++++----
 3 files changed, 67 insertions(+), 12 deletions(-)

-- 
2.30.2

