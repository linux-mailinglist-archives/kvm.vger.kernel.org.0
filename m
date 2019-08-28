Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CBCA035C
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfH1Niw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:38:52 -0400
Received: from foss.arm.com ([217.140.110.172]:59510 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfH1Niv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:38:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70766360;
        Wed, 28 Aug 2019 06:38:51 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 498823F246;
        Wed, 28 Aug 2019 06:38:50 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 01/16] arm: selftest.c: Remove redundant check for Exception Level
Date:   Wed, 28 Aug 2019 14:38:16 +0100
Message-Id: <1566999511-24916-2-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

expected_regs.pstate already has PSR_MODE_EL1h set as the expected
Exception Level.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/selftest.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 28a17f7a7531..176231f32ee1 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -213,10 +213,6 @@ static bool check_regs(struct pt_regs *regs)
 {
 	unsigned i;
 
-	/* exception handlers should always run in EL1 */
-	if (current_level() != CurrentEL_EL1)
-		return false;
-
 	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
 		if (regs->regs[i] != expected_regs.regs[i])
 			return false;
-- 
2.7.4

