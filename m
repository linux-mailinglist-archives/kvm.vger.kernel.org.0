Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1281F1E82E1
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 18:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgE2QDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 12:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgE2QDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 12:03:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C39207BC;
        Fri, 29 May 2020 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590768201;
        bh=Y4wR35sXpU4HJt4C1cy2OouLyeLPiiNYcixW9HynfuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkPlOWC4RqX+J8MPVbByW5BDkf0WWh1OGCn2RxmLyHqDvOm7FazZ11+hns80g1Tv9
         RjG8knr0QTEj/ON/LVXW/PzmoXuPNReNL21YFRX9m/sSBuAm2jTzKKhGmw5LAanvI4
         G1wR2ivaY8HCV8+U1o6rNVIJrcaYCgVYd4Ik6uko=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jehSP-00GJKc-GO; Fri, 29 May 2020 17:02:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Jiang Yi <giangyi@amazon.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 24/24] KVM: arm64: Drop obsolete comment about sys_reg ordering
Date:   Fri, 29 May 2020 17:01:21 +0100
Message-Id: <20200529160121.899083-25-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com, dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com, zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The general comment about keeping the enum order in sync
with the save/restore code has been obsolete for many years now.

Just drop it.

Note that there are other ordering requirements in the enum,
such as the PtrAuth and PMU registers, which are still valid.

Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 69a338a390a6..59029e90b557 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -115,12 +115,8 @@ struct kvm_vcpu_fault_info {
 	u64 disr_el1;		/* Deferred [SError] Status Register */
 };
 
-/*
- * 0 is reserved as an invalid value.
- * Order should be kept in sync with the save/restore code.
- */
 enum vcpu_sysreg {
-	__INVALID_SYSREG__,
+	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 	MPIDR_EL1,	/* MultiProcessor Affinity Register */
 	CSSELR_EL1,	/* Cache Size Selection Register */
 	SCTLR_EL1,	/* System Control Register */
-- 
2.26.2

