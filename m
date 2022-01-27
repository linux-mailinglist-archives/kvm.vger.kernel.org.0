Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86F249EDDB
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 22:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbiA0V4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 16:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237922AbiA0V4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 16:56:01 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966E3C061714
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 13:56:01 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id y14-20020a17090ad70e00b001b4fc2943b3so4992282pju.8
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 13:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1GPO9eogW6Mwfr/+djzW4mOYsFfDu777qdYzBCH2ifk=;
        b=G2A6jcsyS04frh0SvRd/xtKRp10A6bJDzOjTsN75m3ebRSNy+/MqO7Trpc/vdgXMXy
         KciWj5GqZLjzWExSCsi1J5mZ47oD2NorI9+cQhOVM9FKqoR80cQDHUQlPtGeUzckidx7
         g8WhlIFcgXSf1zKNCnfRfRvGmHbXwmnyeP6dKs5YuJhsRcvGPYQ7mIszhoNdcPZpYmy2
         5iwY2cffaTayJ1ik6eb1yGMF9Npbgh0Vk5r2RBd5ibdsB1HXkFPJJPmzL13DtBwx9A6H
         5IV2gNVw1q2PRkq2OVZ9xulSsiIrxBgI1GjxywrgbOydrjCacP+WUlduu/AhQaZUCIFr
         okjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1GPO9eogW6Mwfr/+djzW4mOYsFfDu777qdYzBCH2ifk=;
        b=oJjuXzhcHKK2ukG5JTs5KbPnZNEYIXLrou4G5fNfFqN6IFMPRSMc9NbbKilXYqTKoY
         6lfmKymMxSyWtfe96rSd0DeesdVhMpQVEYPLzkpyhPsHEO8G1/pixngPqnmfpPY33OYM
         45lD+WYideLtM2WwuAOW1SZhtVL+iDK1sDhG4k7TeeAtx9ji1uDq45HKzdKyTzvqfy04
         7/anWGDy0XMyN5lqmnVoz3WGvou8zb14CRAngSFC/08B4OmZA4rqXINlA9jgvqqZ2Lte
         IhPZSy5N60mmzllRSPDQYtxWM4Ewx54zS/pyvgdM8hOF+B0mbuqHyvSBzBtPe2fLmpVr
         vpGw==
X-Gm-Message-State: AOAM530Y5UVh/TeigS6t4HA0FIJkGhHYVvYVRWfoX1fD4uhYDIKG8tf5
        akuCoqIsZUajXtOceX2Fv4tqs31q2NkYbF+gaTNo8ZkikAWQhFfhun3k3G2eYYyNxdBfCDHgFEm
        2QdSxicbY39ObszwV1jDLvACObih3UCPqBx6tZd6MPBnY/PEWtV76qSBPwlrP8Jk=
X-Google-Smtp-Source: ABdhPJyNESizu8VvB2SGBT9gdqNElNNQ6nCWQL4qEppkPY67NOuQrZBbzIBJMMSNducSeZw65tntp2YhrSBVew==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90b:4c8e:: with SMTP id
 my14mr1805719pjb.0.1643320560528; Thu, 27 Jan 2022 13:56:00 -0800 (PST)
Date:   Thu, 27 Jan 2022 13:55:46 -0800
Message-Id: <20220127215548.2016946-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [kvm-unit-tests PATCH 1/3] x86: tsc_adjust: Remove flaky timing test
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>,
        Will Auld <will.auld.intel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The subtest labeled, "MSR_IA32_TSC_ADJUST msr adjustment on tsc
write," sometimes fails. The behavior tested is neither architected
nor guaranteed. Running under qemu/kvm, the 'est_delta_time' has been
observed to be as much as an order of magnitude greater than the
expression that is supposed to be its upper bound.

Remove the flaky subtest, and replace it with some invariants that
actually are architecturally guaranteed (as long as IA32_TSC doesn't
wrap around).

Fixes: 5fecf5d8cad1 ("Added tests for ia32_tsc_adjust funtionality.")
Cc: Will Auld <will.auld.intel@gmail.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/tsc_adjust.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/x86/tsc_adjust.c b/x86/tsc_adjust.c
index 3636b5e082d5..b0d79c499edb 100644
--- a/x86/tsc_adjust.c
+++ b/x86/tsc_adjust.c
@@ -4,7 +4,6 @@
 int main(void)
 {
 	u64 t1, t2, t3, t4, t5;
-	u64 est_delta_time;
 
 	if (this_cpu_has(X86_FEATURE_TSC_ADJUST)) { // MSR_IA32_TSC_ADJUST Feature is enabled?
 		report(rdmsr(MSR_IA32_TSC_ADJUST) == 0x0,
@@ -26,12 +25,9 @@ int main(void)
 		wrtsc(t4);
 		t2 = rdtsc();
 		t5 = rdmsr(MSR_IA32_TSC_ADJUST);
-		// est of time between reading tsc and writing tsc,
-		// (based on MSR_IA32_TSC_ADJUST msr value) should be small
-		est_delta_time = t4 - t5 - t1;
-		// arbitray 2x latency (wrtsc->rdtsc) threshold
-		report(est_delta_time <= (2 * (t2 - t4)),
-		       "MSR_IA32_TSC_ADJUST msr adjustment on tsc write");
+		report(t1 <= t4 - t5,
+		       "Internal TSC advances across write to IA32_TSC");
+		report(t2 >= t4, "IA32_TSC advances after write to IA32_TSC");
 	}
 	else {
 		report_pass("MSR_IA32_TSC_ADJUST feature not enabled");
-- 
2.35.0.rc2.247.g8bbb082509-goog

