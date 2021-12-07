Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB97D46BFBE
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbhLGPu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:50:28 -0500
Received: from foss.arm.com ([217.140.110.172]:35232 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238505AbhLGPu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:50:28 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97B0D11D4;
        Tue,  7 Dec 2021 07:46:57 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4E943F5A1;
        Tue,  7 Dec 2021 07:46:56 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 3/4] arm: timer: Test CVAL before interrupt pending state
Date:   Tue,  7 Dec 2021 15:46:40 +0000
Message-Id: <20211207154641.87740-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211207154641.87740-1-alexandru.elisei@arm.com>
References: <20211207154641.87740-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The timer pending test uses CVAL to trigger changes in the timer interrupt
state. Move the CVAL test before the pending test to make sure that writes
to the CVAL register have an effect on the timer internal state before
using the register for other tests.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index 617845c6525d..7b2d82896c74 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -298,8 +298,8 @@ static void test_timer_tval(struct timer_info *info)
 
 static void test_timer(struct timer_info *info)
 {
-	test_timer_pending(info);
 	test_timer_cval(info);
+	test_timer_pending(info);
 	test_timer_tval(info);
 }
 
-- 
2.34.1

