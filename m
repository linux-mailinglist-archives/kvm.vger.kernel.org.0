Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1092A0BD6
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 17:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgJ3Qzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 12:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbgJ3Qzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 12:55:31 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3808420756;
        Fri, 30 Oct 2020 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076930;
        bh=exFtqjukX2VCvc8Zm33L4Y5eBjgmOnSnxmfGVDjdUQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHB3Qqh35wiuxkxZOouLIN/+Ds3Ypy3GPpDXyit0fTlOmJXA+DNUYEtg/FOoj2nfF
         iRnnqzIM/xNzZdSIcNnMDnrU2tUELVw0JbfVsFtf3LhjGXfv4kjJvkwKSXRjbSfJag
         E8C0K3rO4WDqnf/CnkXLbWxDZyW/XaDb1pE/cWAU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kYXS2-005noK-NH; Fri, 30 Oct 2020 16:40:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>, Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Quentin Perret <qperret@google.com>,
        Santosh Shukla <sashukla@nvidia.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/12] arm64: cpufeature: reorder cpus_have_{const, final}_cap()
Date:   Fri, 30 Oct 2020 16:40:15 +0000
Message-Id: <20201030164017.244287-11-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com, qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

In a subsequent patch we'll modify cpus_have_const_cap() to call
cpus_have_final_cap(), and hence we need to define cpus_have_final_cap()
first.

To make subsequent changes easier to follow, this patch reorders the two
without making any other changes.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201026134931.28246-3-mark.rutland@arm.com
---
 arch/arm64/include/asm/cpufeature.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index fba6700b457b..9f671aa0419b 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -428,35 +428,35 @@ static __always_inline bool __cpus_have_const_cap(int num)
 }
 
 /*
- * Test for a capability, possibly with a runtime check.
+ * Test for a capability without a runtime check.
  *
- * Before capabilities are finalized, this behaves as cpus_have_cap().
+ * Before capabilities are finalized, this will BUG().
  * After capabilities are finalized, this is patched to avoid a runtime check.
  *
  * @num must be a compile-time constant.
  */
-static __always_inline bool cpus_have_const_cap(int num)
+static __always_inline bool cpus_have_final_cap(int num)
 {
 	if (system_capabilities_finalized())
 		return __cpus_have_const_cap(num);
 	else
-		return cpus_have_cap(num);
+		BUG();
 }
 
 /*
- * Test for a capability without a runtime check.
+ * Test for a capability, possibly with a runtime check.
  *
- * Before capabilities are finalized, this will BUG().
+ * Before capabilities are finalized, this behaves as cpus_have_cap().
  * After capabilities are finalized, this is patched to avoid a runtime check.
  *
  * @num must be a compile-time constant.
  */
-static __always_inline bool cpus_have_final_cap(int num)
+static __always_inline bool cpus_have_const_cap(int num)
 {
 	if (system_capabilities_finalized())
 		return __cpus_have_const_cap(num);
 	else
-		BUG();
+		return cpus_have_cap(num);
 }
 
 static inline void cpus_set_cap(unsigned int num)
-- 
2.28.0

