Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235F6341CDD
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 13:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhCSMY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 08:24:59 -0400
Received: from foss.arm.com ([217.140.110.172]:48404 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhCSMYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 08:24:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 413DB101E;
        Fri, 19 Mar 2021 05:24:32 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E13D3F70D;
        Fri, 19 Mar 2021 05:24:31 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, alexandru.elisei@arm.com,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH 1/4] arm/arm64: Avoid calling cpumask_test_cpu for CPUs above nr_cpu
Date:   Fri, 19 Mar 2021 12:24:11 +0000
Message-Id: <20210319122414.129364-2-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210319122414.129364-1-nikos.nikoleris@arm.com>
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/arm/asm/cpumask.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/arm/asm/cpumask.h b/lib/arm/asm/cpumask.h
index 6683bb6..02124de 100644
--- a/lib/arm/asm/cpumask.h
+++ b/lib/arm/asm/cpumask.h
@@ -105,7 +105,7 @@ static inline void cpumask_copy(cpumask_t *dst, const cpumask_t *src)
 
 static inline int cpumask_next(int cpu, const cpumask_t *mask)
 {
-	while (cpu < nr_cpus && !cpumask_test_cpu(++cpu, mask))
+	while (++cpu < nr_cpus && !cpumask_test_cpu(cpu, mask))
 		;
 	return cpu;
 }
-- 
2.25.1

