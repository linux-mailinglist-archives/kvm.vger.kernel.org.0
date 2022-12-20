Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C86E652285
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiLTO1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiLTO0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:26:54 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B95A31C137
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:26:48 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA35A2F4;
        Tue, 20 Dec 2022 06:27:28 -0800 (PST)
Received: from e126514.cambridge.arm.com (e126514.arm.com [10.1.36.32])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 49AD03F703;
        Tue, 20 Dec 2022 06:26:46 -0800 (PST)
From:   Nikita Venkatesh <Nikita.Venkatesh@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, nd@arm.com,
        Nikita Venkatesh <Nikita.Venkatesh@arm.com>
Subject: [kvm-unit-tests PATCH v3] arm: Add PSCI CPU_OFF test
Date:   Tue, 20 Dec 2022 14:31:54 +0000
Message-Id: <20221220143156.208143-1-Nikita.Venkatesh@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The series adds a new test called CPU_OFF under the PSCI tests. The test
itself is a part of patch #2, "[PATCH 2/2] arm/psci: Add PSCI_CPU_OFF
testscase to arm/psci testsuite". Patch #1, "[PATCH 1/2] arm/psci: Test
that CPU 1 has been successfully brought online" is a preparatory patch
to make CPU_OFF test run after the CPU_ON test. Executing the CPU_OFF
test after the CPU_ON test makes the most sense, since CPU_OFF requires
all the CPUs to be brought online before the test can execute.

changelog
v1 -> v2:
- Modify PSCI CPU_ON test to ensure CPU 1 remains online after the execution of the test.
- Addition of PSCI CPU_OFF test and calling it after PSCI CPU_ON test has been executed.

v2 -> v3
- Add timeout so that test does not hang if CPU1 fails to come online
- Remove unnecessary call of on_cpus() in the condition where target CPU is not online.

Alexandru Elisei (1):
  arm/psci: Test that CPU 1 has been successfully brought online

Nikita Venkatesh (1):
  arm/psci: Add PSCI_CPU_OFF testscase to arm/psci testsuite

 arm/psci.c        | 120 ++++++++++++++++++++++++++++++++++++++++------
 lib/arm/asm/smp.h |   1 +
 lib/arm/smp.c     |  12 +++--
 3 files changed, 115 insertions(+), 18 deletions(-)

-- 
2.25.1

