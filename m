Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7CC412DA19
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 17:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfLaQKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 11:10:22 -0500
Received: from foss.arm.com ([217.140.110.172]:35492 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbfLaQKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 11:10:21 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 665DB328;
        Tue, 31 Dec 2019 08:10:21 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.8.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 61CD33F68F;
        Tue, 31 Dec 2019 08:10:19 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 05/18] lib: arm/arm64: Remove unused CPU_OFF parameter
Date:   Tue, 31 Dec 2019 16:09:36 +0000
Message-Id: <1577808589-31892-6-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
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
2.7.4

