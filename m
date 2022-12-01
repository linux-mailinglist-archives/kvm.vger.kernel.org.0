Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AE663FA45
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 23:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiLAWEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 17:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiLAWEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 17:04:42 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DAFC3FE6
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 14:04:36 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-368994f4bc0so29711147b3.14
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 14:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JVxn9kw+WBzYne6KH3XyYEmM6fLGxC56lTuzBBjowFA=;
        b=KfZDcH53erbok0JA1dtKuQVkJT7BNlOqYQTGQdrqDxnoMlXTd+pdrO+yonw7mAU53m
         5b2K9HkdLiE9YNAoWsOM4Dyq5XEZAt+Um1kT3psTjA/dSobSvs7/GCtkJYsqATSH8h6U
         O6Fr34WUYvO431a9v7z60wrU9I5VRNQ4PTfVbS8HAMHTTBz5nlt8MUZZ5gF3dz2aQvQ5
         UqSuj77NByXoDXPc0vPNA7xoubAvmO9BlGYLR0NyYFaDKHC2YZnDtUE8CIRdc0X7uJHu
         VPbRPrkAiCfsG0fv9um05SFL7B+03D1oabDGGR4lEatjuv7iLadzJL1qtn/LdcoLp2tA
         KVeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JVxn9kw+WBzYne6KH3XyYEmM6fLGxC56lTuzBBjowFA=;
        b=HfmH5gYpg36uISQHy65TlUw79DPJi+Jwgo6dmMlcTGi5mu3KqsHy+80SMDJyTmyKFr
         YmxlhgfRWXeIIZjT6I46qNYg8WNaWZYa9rJ4wbY5YmHgpu/4dUIkoYUnSY7/zAuOlOmm
         /dBaNrISLTUR0ebrZvHcLSHT6jlFeeBXjWd7G2BzVCXq8BLAG1Gy8pKeZZFNuL5tnXSd
         tTnWjhiWmGMFydbuSq9+tA+3f+9+rtvv+V6HA32CvQB7unDSMOzXJfeAEnVTcWRkLcnP
         ANtBDuyTBC79g8/bV96D7lotQM2U9+cMrerJA7Jy4/3gxKWu6bZUdmL7LWDGMMNFne9c
         0QAA==
X-Gm-Message-State: ANoB5pm33oIvL2PtASG6pwzdWkDy+zr4UjlmrUnGHP8QzuE6jMjv9vJi
        H80irf97LDj3LM7Em/jqpCQpUyCbl3U=
X-Google-Smtp-Source: AA0mqf6YxLA/aPF1aBMyUNbwEdPG0b9ZwoJzplkUTxhpjIHClmbh4gBE7aLymdRgBeV4fePQD7SoaVhAze0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aae1:0:b0:6e7:39fa:a7be with SMTP id
 t88-20020a25aae1000000b006e739faa7bemr47511614ybi.644.1669932275507; Thu, 01
 Dec 2022 14:04:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 22:04:33 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201220433.31366-1-seanjc@google.com>
Subject: [PATCH] KVM: Remove stale comment about KVM_REQ_UNHALT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove a comment about KVM_REQ_UNHALT being set by kvm_vcpu_check_block()
that was missed when KVM_REQ_UNHALT was dropped.

Fixes: c59fb1275838 ("KVM: remove KVM_REQ_UNHALT")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1782c4555d94..1401dcba2f82 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3518,10 +3518,6 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 		ktime_t stop = ktime_add_ns(start, vcpu->halt_poll_ns);
 
 		do {
-			/*
-			 * This sets KVM_REQ_UNHALT if an interrupt
-			 * arrives.
-			 */
 			if (kvm_vcpu_check_block(vcpu) < 0)
 				goto out;
 			cpu_relax();

base-commit: df0bb47baa95aad133820b149851d5b94cbc6790
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

