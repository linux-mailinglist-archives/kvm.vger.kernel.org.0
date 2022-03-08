Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3064D1BC4
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347697AbiCHPeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiCHPeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:34:13 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED5024586
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:33:16 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id x15-20020a5d6b4f000000b001ee6c0aa287so5609287wrw.9
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 07:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oKAagiS3UYpwunP7Sy4zMqHeUF02cL/iWA5aLyx3lIw=;
        b=oew2eeCxmD+IHG2Wq1jU0MzeJ2j7Kpmp2jZx4AsCuT+d0O4sS8mH71HjRccdU1ZMmO
         zb5y1ljaLmbn8AnwVjKd/SX2huyP3mB5I2DUYemKAXw9EmPYb2L6NVHXbVBC5PsVo8aS
         gKE38AIjYtRL6KOVghQMbKCMnzl6Q0YTypU9xrRg9z2oDrCBGooLy7r2c/Ux4supZLlR
         lsvo6GM/qfFk6csqWGil0/on+Vn0yg+27MM3gi1tOHn+p1/RA7LRrITCKXUukm+nltgS
         fUbjZ0D1QAXa/A++50ArDaWDEqcToCGk8YKHNCPfLCyaY9FV3B1KZiUTHzHasOSifyks
         lZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oKAagiS3UYpwunP7Sy4zMqHeUF02cL/iWA5aLyx3lIw=;
        b=3dGsJvw5z+2uAVlZOfRt84UtoKUo9gc79STON5/hAeAB3HRD+TT5N2M6sxD1n6Amep
         M0zqOyc24OkGkHtFdCm/BPKWzeci0Rx2lzni/xWnKAKesix/WxG5nL7eEEn9gtj+Lnk2
         kwBkRvXq1+iWwq0E1rq1Y3OB5DVQ0i+4B6lDlDhqdZdsgafQ1e+6KXYnsbGuygehcLyd
         y7u2ityOwY8cyQwG56x7DXVTdIwlGfRDhAb555Sw2R+u27KW0cNz/uSGjMPw8slDKwcU
         icFv/nTK31c/nSEnH1IH20mzPDpzgpvKzaOEXXMclWgFaQGIFs0RTRDz+3DC1xtNZ2PW
         7iTg==
X-Gm-Message-State: AOAM532x8phLF9jsonDZ8P2YgnFok6BjJ5Jea2vI43AvTH9DKN5kt32r
        macyQEJcgrPrY3hS+LISE0g5b044Yi8LnaOpToL5vNWfmWamBtZHQbyp4aC7lRF8LnxNfITxD4j
        EQqIbH3soOH+K2lEWyjtEeiKc9czF+2lH3W6Gdf16wLPDnBISFQYeG2FXpA+iavbtnVw5Wcna5Q
        ==
X-Google-Smtp-Source: ABdhPJzDSUFsojdtm0TZ1ZFvzxwHmFK3nIFQdM8ndS4gHkA+y8jOIxofGG9cljM8f09tP/1Kh+ew1JX+ttcA8iwABO0=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:252:b0:381:3461:1c64 with
 SMTP id 18-20020a05600c025200b0038134611c64mr4143631wmj.94.1646753594559;
 Tue, 08 Mar 2022 07:33:14 -0800 (PST)
Date:   Tue,  8 Mar 2022 15:32:27 +0000
In-Reply-To: <20220308153227.2238533-1-sebastianene@google.com>
Message-Id: <20220308153227.2238533-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220308153227.2238533-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v9 1/3] aarch64: Populate the vCPU struct before target->init()
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
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

Move the vCPU structure initialisation before the target->init() call to
 keep a reference to the kvm structure during init().
This is required by the pvtime peripheral to reserve a memory region
while the vCPU is beeing initialised.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arm/kvm-cpu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 6a2408c..84ac1e9 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 			die("Unable to find matching target");
 	}
 
+	/* Populate the vcpu structure. */
+	vcpu->kvm		= kvm;
+	vcpu->cpu_id		= cpu_id;
+	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->cpu_compatible	= target->compatible;
+	vcpu->is_running	= true;
+
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
@@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 		vcpu->ring = (void *)vcpu->kvm_run +
 			     (coalesced_offset * PAGE_SIZE);
 
-	/* Populate the vcpu structure. */
-	vcpu->kvm		= kvm;
-	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
-	vcpu->cpu_compatible	= target->compatible;
-	vcpu->is_running	= true;
-
 	if (kvm_cpu__configure_features(vcpu))
 		die("Unable to configure requested vcpu features");
 
-- 
2.35.1.616.g0bdcbb4464-goog

