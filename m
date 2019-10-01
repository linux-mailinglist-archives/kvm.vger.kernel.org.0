Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6C7C3125
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 12:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbfJAKXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 06:23:39 -0400
Received: from foss.arm.com ([217.140.110.172]:45848 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfJAKXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 06:23:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EC651570;
        Tue,  1 Oct 2019 03:23:39 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 191BD3F739;
        Tue,  1 Oct 2019 03:23:37 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests RFC PATCH v2 01/19] lib: arm/arm64: Remove unused CPU_OFF parameter
Date:   Tue,  1 Oct 2019 11:23:05 +0100
Message-Id: <20191001102323.27628-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first version of PSCI required an argument for CPU_OFF, the power_state
argument, which was removed in version 0.2 of the specification [1].
kvm-unit-tests supports PSCI 0.2, and KVM ignores any CPU_OFF parameters,
so let's remove the PSCI_POWER_STATE_TYPE_POWER_DOWN parameter.

[1] ARM DEN 0022D, section 7.3.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/psci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index c3d399064ae3..936c83948b6a 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -40,11 +40,9 @@ int cpu_psci_cpu_boot(unsigned int cpu)
 	return err;
 }
 
-#define PSCI_POWER_STATE_TYPE_POWER_DOWN (1U << 16)
 void cpu_psci_cpu_die(void)
 {
-	int err = psci_invoke(PSCI_0_2_FN_CPU_OFF,
-			PSCI_POWER_STATE_TYPE_POWER_DOWN, 0, 0);
+	int err = psci_invoke(PSCI_0_2_FN_CPU_OFF, 0, 0, 0);
 	printf("CPU%d unable to power off (error = %d)\n", smp_processor_id(), err);
 }
 
-- 
2.20.1

