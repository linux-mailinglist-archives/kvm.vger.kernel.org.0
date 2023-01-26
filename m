Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A9667D22D
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 17:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbjAZQyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 11:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjAZQyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 11:54:05 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50492CA16
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:54:04 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a62-20020a25ca41000000b0080b838a5199so2448760ybg.6
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bB+klmLMzU6sC10FeFNal2TB7uAaIFG8RIqJADzg1hw=;
        b=defmWuPcSX0rx6PAkaZvSab8Ui3ahIP51HTTVLzdQVcey8LDHaKIKfUhBoogt1PCVh
         RWBvMIKnPWAeRjq2D7aV/VbFTlWIhGzA5Yet/vluKdyZ/4mk+w3gSz/htFfxdwXyDD2/
         Zn0fT6lua5GSiel+06MbcoS70OQbfQtSnrFZKaOM3gcSoSi1qzEACjdxpygGvgVc6zdM
         A5ykqWWeDhD9/cgwQQecJCWyqWpyeKrJqswoa/wVRTc1gROsWNPUDS8Xo9CawxOAZCSH
         a5ux1EAps9cZa5pyK9WaSF0kOyjIkmrD8WSfjE21da5K2GWiedPkWx4PGsuaRm5qxTFe
         n+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bB+klmLMzU6sC10FeFNal2TB7uAaIFG8RIqJADzg1hw=;
        b=dkdjpEyqPTWMMIyYNj26Uj40JoR59jhA+IyTpEvj1zY6N29b2xSkUtVMMkcva6W2t6
         +0R6On5m+oYCxSPM7/n3dIQIf3GpSysXfbVHcSWCjWVLxVeuVWBGSguWSGMAT/Oj3Ded
         iXcW74J/+YsuX+sYZj++bzev33sFdqzvfnJV0FpYeq1xnBC+xpGbhwu9l5llHW4t0q9s
         TdS2tlPHZKZmTP7Z+Phixqevk4z3e4Jev85p7CMwS/faDZuFgV5CSiowD08He473LZxg
         9OIpZnhcfUfCXa45/gE51GrHKDieIdR7VeYm4zFapFjpbGLfNKi9L+lRgwB2zBWncYYK
         gZMA==
X-Gm-Message-State: AO0yUKX8KooRoGTu95d+YO1j5ocGZPGkLQUWlhjPwCB8q5n7aNUNYUaK
        3JGwOD8dNNUvTppCyM5xoFzkT3fKVoi85aeohjGb7wAwegafRJPs+kCuSGRZw8YfnKQEFQp6pOv
        N2W9ZR8ir+d4CfuC1MqeUrGJRu/aTtBASj8HCKkhVAGOvDIAs7hYv8TcdWEp/Gdc=
X-Google-Smtp-Source: AK7set87Kh7//SFpwrnNUjDXgO1zm00dWJo5vzBtlOGAMpaXt8X/NlOOEIDPD+eUpvUdzn2ZvuSsZUl/cLU4qg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9109:0:b0:80b:e21f:2865 with SMTP id
 v9-20020a259109000000b0080be21f2865mr289916ybl.373.1674752043525; Thu, 26 Jan
 2023 08:54:03 -0800 (PST)
Date:   Thu, 26 Jan 2023 16:53:51 +0000
In-Reply-To: <20230126165351.2561582-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230126165351.2561582-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126165351.2561582-7-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v4 6/6] arm: pmu: Fix test_overflow_interrupt()
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

test_overflow_interrupt() (from arm/pmu.c) has a test that passes
because the previous test leaves the state needed to pass: the
overflow status register with the expected bits. The test (that should
fail) does not enable the PMU after mem_access_loop(), which clears
the PMCR, and before writing into the software increment register.

Fix by clearing the previous test state (pmovsclr_el0) and by enabling
the PMU before the sw_incr test.

Fixes: 4f5ef94f3aac ("arm: pmu: Test overflow interrupts")
Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 1e93ea2..f91b5ca 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -914,10 +914,15 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 
 	write_regn_el0(pmevcntr, 0, pre_overflow);
 	write_regn_el0(pmevcntr, 1, pre_overflow);
+	write_sysreg(ALL_SET_32, pmovsclr_el0);
 	write_sysreg(ALL_SET_32, pmintenset_el1);
 	isb();
 
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x3, pmswinc_el0);
 
-- 
2.39.1.456.gfc5497dd1b-goog

