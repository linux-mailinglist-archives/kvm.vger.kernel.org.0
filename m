Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4460744DCEA
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 22:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhKKVPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 16:15:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232666AbhKKVPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 16:15:07 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C8A6108B;
        Thu, 11 Nov 2021 21:12:17 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mlHMm-004tjr-14; Thu, 11 Nov 2021 21:12:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 2/4] KVM: arm64: nvhe: Fix a non-kernel-doc comment
Date:   Thu, 11 Nov 2021 21:11:33 +0000
Message-Id: <20211111211135.3991240-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211111211135.3991240-1-maz@kernel.org>
References: <20211111211135.3991240-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, tabba@google.com, james.morse@arm.com, mark.rutland@arm.com, qperret@google.com, rdunlap@infradead.org, suzuki.poulose@arm.com, will@kernel.org, yuehaibing@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, lkp@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Do not use kernel-doc "/**" notation when the comment is not in
kernel-doc format.

Fixes this docs build warning:

arch/arm64/kvm/hyp/nvhe/sys_regs.c:478: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Handler for protected VM restricted exceptions.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211106032529.15057-1-rdunlap@infradead.org
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 3787ee6fb1a2..792cf6e6ac92 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -474,7 +474,7 @@ bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
-/**
+/*
  * Handler for protected VM restricted exceptions.
  *
  * Inject an undefined exception into the guest and return true to indicate that
-- 
2.30.2

