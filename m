Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE3B341CDB
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 13:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhCSMY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 08:24:58 -0400
Received: from foss.arm.com ([217.140.110.172]:48424 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhCSMYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 08:24:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B77D1063;
        Fri, 19 Mar 2021 05:24:35 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51BF03F70D;
        Fri, 19 Mar 2021 05:24:34 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, alexandru.elisei@arm.com,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH 4/4] arm/arm64: Add sanity checks to the cpumask API
Date:   Fri, 19 Mar 2021 12:24:14 +0000
Message-Id: <20210319122414.129364-5-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210319122414.129364-1-nikos.nikoleris@arm.com>
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make sure that any calls to the cpumask API target a valid CPU. The
CPU is identified by an int in the range [0, nr_cpus), where nr_cpus
is set based on information in the DT.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/arm/asm/cpumask.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/arm/asm/cpumask.h b/lib/arm/asm/cpumask.h
index 02124de..3fa57bf 100644
--- a/lib/arm/asm/cpumask.h
+++ b/lib/arm/asm/cpumask.h
@@ -20,26 +20,31 @@ typedef struct cpumask {
 
 static inline void cpumask_set_cpu(int cpu, cpumask_t *mask)
 {
+	assert(cpu >= 0 && cpu < nr_cpus);
 	set_bit(cpu, cpumask_bits(mask));
 }
 
 static inline void cpumask_clear_cpu(int cpu, cpumask_t *mask)
 {
+	assert(cpu >= 0 && cpu < nr_cpus);
 	clear_bit(cpu, cpumask_bits(mask));
 }
 
 static inline int cpumask_test_cpu(int cpu, const cpumask_t *mask)
 {
+	assert(cpu >= 0 && cpu < nr_cpus);
 	return test_bit(cpu, cpumask_bits(mask));
 }
 
 static inline int cpumask_test_and_set_cpu(int cpu, cpumask_t *mask)
 {
+	assert(cpu >= 0 && cpu < nr_cpus);
 	return test_and_set_bit(cpu, cpumask_bits(mask));
 }
 
 static inline int cpumask_test_and_clear_cpu(int cpu, cpumask_t *mask)
 {
+	assert(cpu >= 0 && cpu < nr_cpus);
 	return test_and_clear_bit(cpu, cpumask_bits(mask));
 }
 
-- 
2.25.1

