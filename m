Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9A541757B
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345526AbhIXNYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344913AbhIXNYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:48 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16698C061788
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:05 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id v14-20020a05620a0f0e00b0043355ed67d1so32214391qkl.7
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+LaJv4Ut995m+xStn+CJit8kroqDB8BrAul4VeyUpto=;
        b=WJfhJpBhFcx1yU6q2A5dq5o7v7/qoJ76LzW3bnFH/OqCKw8Y4BBx7H1VMcJ4tZ7Q84
         ycy5/fqgEuZ65y0fbocguVBTBdv8nbPd9ycSN1MZ/ZAy6kKPqAOs9K4UgY4nk42W8VDA
         jvZpEP6TxuYQ0tLZJycyC0xa/yoyJRa/NGylRXWjBBIUJSwBl6H90fh73Dket8vr+QbB
         RlBOGE1MBPLxUDMmPF6uPJF2HxT5qdB3y0sJhY2yBAnQRIjroQ1eZj05uFdc4MjgZAGX
         VAbsty9cYie2RSCLZF24ZKZDUxnrL0oCE+b2BWloYYD1AWXMRq+QxF3CHa+gXfriviqy
         qWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+LaJv4Ut995m+xStn+CJit8kroqDB8BrAul4VeyUpto=;
        b=p6rAKzfnfJlJcNXDScsF7QxjIk9DsIB0//4dYr6xmYh6UXyKbiU6sqLZP7T93lYW4P
         VWFbYsSJtxhgj71bpI8wXYT3I4FGoC5FGoqPQ6GjKniUfLU1KkOBLq4Bxj6Z+wr9yLY8
         v0e5dm1fmSzDECun6LKUxQzFKJiIlLczKufA24+BtYGtEoGhDRkAF/Jog78hd54KLJgO
         Xu/wqY0OZ/AJkpKVkzorHWyvR4/GypfbtUBrjPcNi5mW9Jjn3Gc0pcXVrm4ObfeZkx1S
         knkevvEx/C+wwxZJ48IhXRqP3+XhAYL+zuaN8+MP52gePvr2cTVgsslFJUZc6mHVR2C8
         UaGA==
X-Gm-Message-State: AOAM531X4ja/j+6kxOI/4knjCAXAQLcpGBahz2vCwl0OWpKvzc9YMhkf
        oTNiyNg/SfqwXHPpWDyhI4j3IMtHcg==
X-Google-Smtp-Source: ABdhPJz8XJjf9DmrCXNeHJp2ahBQOSArt9tPtY1bK5GAiDObokO9lS6nGswDDTChpYk6XAR7Ybe+AHcL3Q==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1372:: with SMTP id
 c18mr9505426qvw.28.1632488043829; Fri, 24 Sep 2021 05:54:03 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:30 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-2-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 01/30] KVM: arm64: placeholder to check if VM is protected
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

Add a function to check whether a VM is protected (under pKVM).
Since the creation of protected VMs isn't enabled yet, this is a
placeholder that always returns false. The intention is for this
to become a check for protected VMs in the future (see Will's RFC).

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>

Link: https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
---
 arch/arm64/include/asm/kvm_host.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cd7d5c8c4bc..adb21a7f0891 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -763,6 +763,11 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
+static inline bool kvm_vm_is_protected(struct kvm *kvm)
+{
+	return false;
+}
+
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
-- 
2.33.0.685.g46640cef36-goog

