Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBF94D76B3
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 17:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiCMQWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 12:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiCMQV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 12:21:59 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E4B81890
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 09:20:52 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id a26-20020a7bc1da000000b003857205ec7cso5785296wmj.2
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 09:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SeD4Qzgh/sHfvC8bjBiziK/e63h3+qRRDuOCSxAtRyU=;
        b=PnyhGUpo0WrgazIr8uDW4N3gs0xJHwKFIZiYrlq9Hc3T9feIf7NQrM/a9nuc+gKFw8
         vGUCw9bNsPCrfwJ2Y/+raF+mJG09gugnXcsuaQhyZXTCFkafMYfayL3qAzE+mOHgwyHj
         xc8PaChyGJw/RcwtolTaPvj4B4zCSr6RMKJQk/h2Rde/lHmlqa4RwaqYhn5j58orluzG
         KKPnHCQ9fIUiePG7+gOM7IwXZ7/BrHygGdtC0fFabVvdWO+hlRRhFeuSgwF2aMzxtJqs
         TgSOG14klT1oE8Q4NDLZUK/j4qEsOkWS8BzKBJzMoL1b0jEhOoB/uLqCP7LrKk+K3pzK
         dyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SeD4Qzgh/sHfvC8bjBiziK/e63h3+qRRDuOCSxAtRyU=;
        b=s0dR00H0BKuTXYxDGFUrMTMJLnSiiFw9MpInJfQdoQ1PIggmaoHfoXO/0LX8nxu+IV
         eUWWSvc6BbAbZpYHNj9QlwnqmOtvoIxnwfAMTseZsObGWK/ZPUEcnzXgddLU6ZPPE2a3
         q2s7IDkReP5VbaNH79GyemeIUhGN/5MogGN/UM2Cv2AoPnEK1hy4TzG6MYvblw3G/RTA
         Y5vLHynnpY0as0rsinBwvUW6RFhgK8lVSQfAkEWQGLvF+GU0ubU2RJBk9iF0uyIrcwPh
         n6bf3izjYNMUhIcq/jfBa22YPKWd7RQZUkmKNPjFBNBoMCiDzAINzvO+e5AwkJiYNqm5
         Wtcg==
X-Gm-Message-State: AOAM5317PoY1jHlbNpL08BS1jiMb/zae+DMqZIeppxsa2uQOsIUNnqaz
        PjkU/ESrXUoa7J2o04qA2AD3SHVZck558T3z1MleLNQzplZgn7BWW+IAwOu7t+8lYKHdLyVQi0N
        HDuEJlmPKxjjHoFBdSCk+D8vRZKVRuWsUfFsD/MKhZWAJHy3duh0KKZmIgUmupSFTk6k0h7cfsQ
        ==
X-Google-Smtp-Source: ABdhPJzqcbVtACj62ep3LZlqhTo9GesJQnwZ8D/9dKWe+MvvBQWPqLqZQ6BD33SYazsTGRfTx+fE62r7Mddnm08si14=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:ac5:b0:389:a170:c34 with
 SMTP id c5-20020a05600c0ac500b00389a1700c34mr22917340wmr.100.1647188450683;
 Sun, 13 Mar 2022 09:20:50 -0700 (PDT)
Date:   Sun, 13 Mar 2022 16:19:48 +0000
In-Reply-To: <20220313161949.3565171-1-sebastianene@google.com>
Message-Id: <20220313161949.3565171-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220313161949.3565171-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH kvmtool v11 1/3] aarch64: Populate the vCPU struct before target->init()
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
2.35.1.723.g4982287a31-goog

