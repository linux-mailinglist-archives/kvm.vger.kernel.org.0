Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162F8CBCDB
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 16:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388625AbfJDOSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 10:18:42 -0400
Received: from foss.arm.com ([217.140.110.172]:46242 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388874AbfJDOSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 10:18:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8628315BE;
        Fri,  4 Oct 2019 07:18:41 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9A3A3F68E;
        Fri,  4 Oct 2019 07:18:40 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 3/6] arm: timer: Split variable output data from test name
Date:   Fri,  4 Oct 2019 15:18:26 +0100
Message-Id: <20191004141829.87135-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191004141829.87135-1-andre.przywara@arm.com>
References: <20191004141829.87135-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For some tests we mix variable diagnostic output with the test name,
which leads to variable test line, confusing some higher level
frameworks.

Split the output to always use the same test name for a certain test,
and put diagnostic output on a separate line using the INFO: tag.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index f2f6019..0b808d5 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -249,7 +249,8 @@ static void test_timer(struct timer_info *info)
 	local_irq_enable();
 	left = info->read_tval();
 	report("interrupt received after TVAL/WFI", info->irq_received);
-	report("timer has expired (%d)", left < 0, left);
+	report("timer has expired", left < 0);
+	report_info("TVAL is %d ticks", left);
 }
 
 static void test_vtimer(void)
-- 
2.17.1

