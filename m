Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90ED13680CE
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 14:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhDVMtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 08:49:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236438AbhDVMtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 08:49:06 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 911A4613FB;
        Thu, 22 Apr 2021 12:48:31 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lZYku-008tBg-Vz; Thu, 22 Apr 2021 13:48:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-sh@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com,
        James Morse <james.morse@arm.com>, nathan@kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rich Felker <dalias@libc.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH 0/5] perf: oprofile spring cleanup
Date:   Thu, 22 Apr 2021 13:48:03 +0100
Message-Id: <161909565607.1722628.9529859651633898388.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210414134409.1266357-1-maz@kernel.org>
References: <20210414134409.1266357-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-sh@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, hca@linux.ibm.com, acme@kernel.org, borntraeger@de.ibm.com, mark.rutland@arm.com, kernel-team@android.com, james.morse@arm.com, nathan@kernel.org, alexandru.elisei@arm.com, will@kernel.org, suzuki.poulose@arm.com, viresh.kumar@linaro.org, dalias@libc.org, peterz@infradead.org, ysato@users.sourceforge.jp
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Apr 2021 14:44:04 +0100, Marc Zyngier wrote:
> This small series builds on top of the work that was started with [1].
> 
> It recently became apparent that KVM/arm64 is the last bit of the
> kernel that still uses perf_num_counters().
> 
> As I went ahead to address this, it became obvious that all traces of
> oprofile had been eradicated from all architectures but arm64, s390
> and sh (plus a bit of cruft in the core perf code). With KVM fixed,
> perf_num_counters() and perf_pmu_name() are finally gone.
> 
> [...]

Applied to kvm-arm64/kill_oprofile_dependency, thanks!

[1/5] KVM: arm64: Divorce the perf code from oprofile helpers
      commit: 5421db1be3b11c5e469cce3760d5c8a013a90f2c
[2/5] arm64: Get rid of oprofile leftovers
      commit: e9c74a686a45e54b2e1c4586b14c84f3ee2f2014
[3/5] s390: Get rid of oprofile leftovers
      commit: 8c3f7913a106aa8b94d331cb59709c84a9a1d55b
[4/5] sh: Get rid of oprofile leftovers
      commit: ac21ecf5ad32b89909bee2b50161ce93d6462b7d
[5/5] perf: Get rid of oprofile leftovers
      commit: 7f318847a0f37b96d8927e8d30ae7b8f149b11f1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


