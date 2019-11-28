Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A92F10CE3F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 19:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfK1SEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 13:04:38 -0500
Received: from foss.arm.com ([217.140.110.172]:39340 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbfK1SEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 13:04:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FFEA31B;
        Thu, 28 Nov 2019 10:04:37 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6DCF33F6C4;
        Thu, 28 Nov 2019 10:04:36 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 05/18] lib: arm/arm64: Remove unused CPU_OFF parameter
Date:   Thu, 28 Nov 2019 18:04:05 +0000
Message-Id: <20191128180418.6938-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191128180418.6938-1-alexandru.elisei@arm.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
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

