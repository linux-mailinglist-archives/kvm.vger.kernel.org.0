Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1529A4C46B3
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 14:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbiBYNim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 08:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241531AbiBYNim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 08:38:42 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B572A1D8AB9
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:38:09 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id i20-20020a05600c051400b00380d5eb51a7so1334152wmc.3
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
        b=RuDcsnt0uDnCOh8so476d0bhJurV/3dHZ5KFaJ1hIMbrrIATRHzrzKZxeVHSbTv/vq
         t+agQU3Mli8ws6rwqEQ96jpewsAYn2uUwyv22c+lxe8k0+3Mu/xzTn8T4l/f5/d7iqPo
         EbdBUI0q3xtxYQ//nRYgONAmsL8l19EhIif/cnK/fPwVnpm9G538XZFalCf1MlkVOt3m
         x+ruq27O45lfgu0sPDZf1OeehkhK7OpY+/BeYRPu7Ln8xqdJtds/S/+zu3SUfwRqhzdV
         yH/WCE2Qn/PYF0ukj/pmuL3oB1adE6Y3+auPbgwanJ5WtGRV8wUpv/s2Zsz0SbgfOabb
         HcPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
        b=3Qh0hL5gJt35hyihupDYNt3XVj2pBp2Pi4kJMSrx2RfKhQKutS3LyGdblClASkZLo5
         FQVkgpHuvuXtjl0S9IINdlTItPVxIDSe01Bh4i6xhcYCsWU5z/9hCdS7ity2YRa2Z1Tj
         V/b1JcDnX+4X4fBWGZbPQs9oluA/LLFK4FEye7+P5U+kpwP8WKqQQAwDfUw+AOmYRIWX
         jlNXGBOFw23BZDvZ8FCo1nxeCbcPlNNnJYefkIAjgUqbYL+iqN5dS0WzwOm+u3JOyoie
         X2Zpna1AKP8Yy65Xsa+rlNVkWwhgU1/HuKijweB+aeKDJfdvjoigfpkC6FWuZlcfgC34
         trvQ==
X-Gm-Message-State: AOAM531w/iLy9UHtzYHmNeb5nVyqIHi+t1uUP+uRVoK0JyUOtLzo29UN
        G4h9lZQV53zS8DCdseQrFZkNQokBGjfgcxljwabYr/O+Wvs7JVmVuIMItRrhg6agI0GOnNUiC/R
        /YkCWWaltZoGbOZ6RnWiHTW3mTRlzgZebRk6SfwGvdXdBrGJKRl0qQhmiPGAzxAN7bFJITrAkmg
        ==
X-Google-Smtp-Source: ABdhPJw/i+j9Y9lT4oP3rSx/EBeqAbXyVKnNIqSLOXDR7vSaDHI/+31HbErczIS6hHQ79O9YPY4Ur0JqAAxCdDnZCVg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:3c98:b0:37f:2f14:7be7 with
 SMTP id bg24-20020a05600c3c9800b0037f2f147be7mr2834952wmb.180.1645796288177;
 Fri, 25 Feb 2022 05:38:08 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:37:43 +0000
In-Reply-To: <20220225133743.41207-1-sebastianene@google.com>
Message-Id: <20220225133743.41207-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220225133743.41207-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v5 1/3] aarch64: Populate the vCPU struct before target->init()
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
2.35.1.574.g5d30c73bfb-goog

