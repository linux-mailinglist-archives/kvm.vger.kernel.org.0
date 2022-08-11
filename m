Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8B35906C0
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 21:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiHKSwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 14:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbiHKSwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 14:52:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0D19DB7C
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:52:17 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r14-20020a17090a1bce00b001f53b234980so8966641pjr.5
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=VZiPxkBQBE7PnfHpNUttSx1eXhEoYlew1lZUmeEavmw=;
        b=XiiMXev2mWnjZyJYsibr8sQlQJcMRMTmnaXi/1K05NUYChLByxpjhValTyUKyLy2s/
         HS+KFJnE2JRfVwiuQHTgW1F3H5IdUnUzDZPlS/8C8ZnYl6thZW+rkRca30ezT8IENouI
         SGMkFj3IWDOLEenfWosAdwGFjjY6maHLu/FdcPhgjZTFaV01LkGTUAhJc5ko9pZiDqnY
         TG5z4BdfOIIb0fjzMBA1sByI2W+qstPHTV67UymdF/nQ98SDmNb7sTOoDajD1xeCgg7+
         2WiVIRg9sBwFBvyAkH+vmb4EGMj0MQJ1cYxfrC5Gdn/CUdybvN9dXjVJxvCKu6mq79he
         0Vxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=VZiPxkBQBE7PnfHpNUttSx1eXhEoYlew1lZUmeEavmw=;
        b=A0qglbAPmqTedduwrPaGl4vnmO0NsBrea45vHcB5AyD8UAOH+s5yHZwk0jBlkULJrC
         FGZwG9nwc3Xs2Frh59Wmq8qlRReSuGOIiXAaQpLGaXQPx6M586z3UFpsnbDMYfiYhkB1
         yGc0A4M4f59xeIZHjwtJfsIcFPi0jjPoYvFeZlpT/D+eOVoOwASHGXDpYBgCHlFWmCiW
         RFjOSh0SjRDTknslBxgBXIvaLwWMpKV1CSJO8LajU0mZ5qOHSZ65nLqqVDalEAioqrAj
         VlUxrh4z/HNmQ1lQltNyU2InhFIA4e/C1CQ6VAS78CTcc0Fl7zCxkmPynnx1o1qf8OOP
         BtNQ==
X-Gm-Message-State: ACgBeo03LoQePj9frnhroMEY8q7A96aYQTkP+PkyB+FXsCPiyjkn9mux
        vhVnP7gR1VHD85SzEIMxyk6QVBRl9Voea7JEzJ5ec2ftITKiGa0PvXrrgp/UDZYDNOICFUv/KGY
        RmdGkK8AH36t6T6ddxWp0SvlbbbyPAWD58CwxXAdQuKKufcAZyieyG0ADesd+IgQ=
X-Google-Smtp-Source: AA6agR6AaunjtKLPe1/K8oUl3wed1uUaUWeB0b0zinTqn0KSL7mGjfcIEvGAQtVzVLGVgIq6vknLFRHHLnLirg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:1943:b0:1f7:b63e:60db with SMTP
 id nk3-20020a17090b194300b001f7b63e60dbmr9988947pjb.241.1660243937397; Thu,
 11 Aug 2022 11:52:17 -0700 (PDT)
Date:   Thu, 11 Aug 2022 11:52:08 -0700
In-Reply-To: <20220811185210.234711-1-ricarkol@google.com>
Message-Id: <20220811185210.234711-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220811185210.234711-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v4 2/4] arm: pmu: Add reset_pmu() for 32-bit arm
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a 32-bit arm version of reset_pmu(). Add all the necessary register
definitions as well.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 4c601b05..a5260178 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -93,7 +93,10 @@ static struct pmu pmu;
 #define PMSELR       __ACCESS_CP15(c9, 0, c12, 5)
 #define PMXEVTYPER   __ACCESS_CP15(c9, 0, c13, 1)
 #define PMCNTENSET   __ACCESS_CP15(c9, 0, c12, 1)
+#define PMCNTENCLR   __ACCESS_CP15(c9, 0, c12, 2)
+#define PMOVSR       __ACCESS_CP15(c9, 0, c12, 3)
 #define PMCCNTR32    __ACCESS_CP15(c9, 0, c13, 0)
+#define PMINTENCLR   __ACCESS_CP15(c9, 0, c14, 2)
 #define PMCCNTR64    __ACCESS_CP15_64(0, c9)
 
 static inline uint32_t get_id_dfr0(void) { return read_sysreg(ID_DFR0); }
@@ -145,6 +148,19 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 	: "cc");
 }
 
+static void pmu_reset(void)
+{
+	/* reset all counters, counting disabled at PMCR level*/
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
+	/* Disable all counters */
+	write_sysreg(ALL_SET, PMCNTENCLR);
+	/* clear overflow reg */
+	write_sysreg(ALL_SET, PMOVSR);
+	/* disable overflow interrupts on all counters */
+	write_sysreg(ALL_SET, PMINTENCLR);
+	isb();
+}
+
 /* event counter tests only implemented for aarch64 */
 static void test_event_introspection(void) {}
 static void test_event_counter_config(void) {}
-- 
2.37.1.559.g78731f0fdb-goog

