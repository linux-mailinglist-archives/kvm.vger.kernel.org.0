Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DF735F545
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 15:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351594AbhDNNop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 09:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351586AbhDNNoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 09:44:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B363A611AD;
        Wed, 14 Apr 2021 13:44:23 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lWfob-007RSZ-Jm; Wed, 14 Apr 2021 14:44:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, nathan@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 0/5] perf: oprofile spring cleanup
Date:   Wed, 14 Apr 2021 14:44:04 +0100
Message-Id: <20210414134409.1266357-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, mark.rutland@arm.com, will@kernel.org, dalias@libc.org, ysato@users.sourceforge.jp, peterz@infradead.org, acme@kernel.org, borntraeger@de.ibm.com, hca@linux.ibm.com, nathan@kernel.org, viresh.kumar@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This small series builds on top of the work that was started with [1].

It recently became apparent that KVM/arm64 is the last bit of the
kernel that still uses perf_num_counters().

As I went ahead to address this, it became obvious that all traces of
oprofile had been eradicated from all architectures but arm64, s390
and sh (plus a bit of cruft in the core perf code). With KVM fixed,
perf_num_counters() and perf_pmu_name() are finally gone.

Thanks,

	M.

[1] https://lore.kernel.org/lkml/20210215050618.hgftdmfmslbdrg3j@vireshk-i7

Marc Zyngier (5):
  KVM: arm64: Divorce the perf code from oprofile helpers
  arm64: Get rid of oprofile leftovers
  s390: Get rid of oprofile leftovers
  sh: Get rid of oprofile leftovers
  perf: Get rid of oprofile leftovers

 arch/arm64/kvm/perf.c         |  7 +------
 arch/arm64/kvm/pmu-emul.c     |  2 +-
 arch/s390/kernel/perf_event.c | 21 ---------------------
 arch/sh/kernel/perf_event.c   | 18 ------------------
 drivers/perf/arm_pmu.c        | 30 ------------------------------
 include/kvm/arm_pmu.h         |  4 ++++
 include/linux/perf_event.h    |  2 --
 kernel/events/core.c          |  5 -----
 8 files changed, 6 insertions(+), 83 deletions(-)

-- 
2.29.2
