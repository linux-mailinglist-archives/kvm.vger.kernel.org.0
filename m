Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D229417593
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345556AbhIXNZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346122AbhIXNZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:04 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8910C03401C
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:52 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d9-20020ac86149000000b002a6d33107c5so751150qtm.8
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AJoOKnLyUcMeZ4bJL08afGQB1XmHWoCmbvvxsT90R1w=;
        b=TMcksozilNhor18k73HxG4gyzfpGIMQctnpgCoaFfUQvCdISS/VjwUjfT8F/wp9IsG
         PSTiJU2S+0umLVLDZpYsMf1X3pMpaNn1K70khBdD2PsgT9nUFaSWbqDDz8wWIAjd3R4y
         /7Ix41f24yh5cDWqxan5dgEUP+g+Bo06EILO7FWcopUsktqWgXUJKfnWaJu6p5D5A487
         lIeMXBorGqKldcdOiUFmwoM5kyBRg8Qc7dDf/ZIiCMR3KJ7Uus5G7B0UWsPVzQESkXiF
         i4fjNfKyLfq1Hj9F3RZ2SsYLfw6L37gMokU2uTeaiLZVuxDA75sy3iTlTonCGSWvpuEB
         lnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AJoOKnLyUcMeZ4bJL08afGQB1XmHWoCmbvvxsT90R1w=;
        b=bbjtz2RCzMl67Dt0sAT2HeNVft2a0C1pIVRX8B1gUlH5GZNW1HobmHTcc2AWCf/Q82
         +XSvdFubC8WtDjbVfa0dem0kmSmUm9ecIbg498twJAQhJIia1QtTC1VJiiQ9nKxfF2pb
         IDMSWx4/BKCXH0bJLKhhAFr4lQDjgwtyrmPy+LVXV8BBfG+4vXMmhgt4GvYokVmXa2rR
         87zDrUaqd266KzlzPWRR84D2AKMbnxV8utuyr2c9EX1V/2pA0O0cQV5/H2Fz6/256ePG
         TCUE8fNG5VjYtg0jA9RT+HnqJc+SPUEyw9PDGStvjhjaw685BbsOhlm+CnaXfvYyvHjN
         1ndg==
X-Gm-Message-State: AOAM531fiTEFiT29sdv5vfjk/H0Uk7C1/dXEzBFYTryT3pdtWP0v6Dto
        AgyZafmkCTnPyXUIvWex3rnVQhyTeg==
X-Google-Smtp-Source: ABdhPJwRKEEdsILouY64mZAty9UzcrpjyOPrwEYFLAfse6nGd0/Ta0E8nqaALjj/ZCs3Dfp6mLzP+gYXZA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:492:: with SMTP id
 ay18mr9625511qvb.4.1632488091905; Fri, 24 Sep 2021 05:54:51 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:53 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-25-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 24/30] KVM: arm64: remove unused functions
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__vcpu_write_spsr*() functions are not used anymore.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/exception.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index bb0bc1f5568c..fdfc809f61b8 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -67,21 +67,6 @@ static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	__ctxt_write_sys_reg(&vcpu_ctxt(vcpu), val, reg);
 }
 
-static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
-{
-	__ctxt_write_spsr(&vcpu_ctxt(vcpu), val);
-}
-
-static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
-{
-	__ctxt_write_spsr_abt(&vcpu_ctxt(vcpu), val);
-}
-
-static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
-{
-	__ctxt_write_spsr_und(&vcpu_ctxt(vcpu), val);
-}
-
 /*
  * This performs the exception entry at a given EL (@target_mode), stashing PC
  * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
-- 
2.33.0.685.g46640cef36-goog

