Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD84875D90E
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 04:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjGVCXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 22:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjGVCXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 22:23:02 -0400
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C63030F4
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 19:22:58 -0700 (PDT)
Received: by mail-ot1-x349.google.com with SMTP id 46e09a7af769-6b86d2075f0so5670414a34.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 19:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689992577; x=1690597377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ub1b4RkH+SiNL7JMG3rpDZe3A40I4dIIMSmDo0IlQzA=;
        b=mdoy5qzVWH2lXFeq+l8GrcDaZ/AZtpebOXZQbAycbvs9F3gc+FWUF9ZJWPljZ/WTZD
         N7E2CrdeVR5j4hLBJ6lRk+I7mY3w46nxq1+pryXFAKZcAm6ro0anIkD55cC7HYUHEtBl
         +dJrlJdeVINBllBXagJSINAu10sD/s1fUyDdrNYf7y42VzG1fL7GeDIkL7+WYoytIjDy
         GHMZhXrzf4o6R4qf5HOBkK1MFK9gmO6/4OMh2/Y3htnJZzNT+xxMwKlwZX5zfwWUZjjA
         VHLWteESBncMN/9UQw6Di221i0kp5JpanK4qcj2hiL8RK1AhymvQXKdy0Wc1MgLrg4t+
         08/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992577; x=1690597377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ub1b4RkH+SiNL7JMG3rpDZe3A40I4dIIMSmDo0IlQzA=;
        b=XLOcBy9cl+zVzLnFjG+45DbMBXuapxnSbKWSUfWs+aTweBXWYSRPHoJifHhXoFhSF2
         76K1Ms8UAIjwsMGsvdXwU5xqu1wi/wcqJ/NIbvW7RAN+7CjxYY/1t2WAp4TC2Qg30Qk7
         8+oZKzkEz73Tt/zBQXqRJTp461fjLRPhnpIcBXofdNIQX++BRLAEYyjdqXp9NmED7+KY
         wZnNhrDGhL8wFShiBcdorf5h5vNXrAuaALOcDelXCXoNq6+evej9ehdnZFK1YZb3lYoO
         Tr3zD6qZtvh7vkqEqQQ0hQqAXqb/VPvoJ8b2lDo/lFnOPx1jLhyTLzm1T4zeFNiRCi8+
         W52w==
X-Gm-Message-State: ABy/qLaTF6KCTttmGg/PKegxiILWnlsVCTrZ6bRK5hSl4cbV13QMgb8v
        EQW6QsmJgv5tJDgFKhY57EQcG0Zpm/10
X-Google-Smtp-Source: APBJJlFePHecSR1HloqjDSzzI/2i9CNM4+/1NwLnWrMA4yKuyKZVLYbN6w7CAOZHg5mvVOxwFFo83RQaKDLL
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a9d:6d03:0:b0:6b9:cf90:87a6 with SMTP id
 o3-20020a9d6d03000000b006b9cf9087a6mr2197907otp.1.1689992577845; Fri, 21 Jul
 2023 19:22:57 -0700 (PDT)
Date:   Sat, 22 Jul 2023 02:22:42 +0000
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722022251.3446223-4-rananta@google.com>
Subject: [PATCH v7 03/12] KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_arch_flush_remote_tlbs() or CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
are two mechanisms to solve the same problem, allowing
architecture-specific code to provide a non-IPI implementation of
remote TLB flushing.

Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
all architectures on kvm_arch_flush_remote_tlbs() instead of
maintaining two mechanisms.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 virt/kvm/Kconfig    | 3 ---
 virt/kvm/kvm_main.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index b74916de5183..484d0873061c 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -62,9 +62,6 @@ config HAVE_KVM_CPU_RELAX_INTERCEPT
 config KVM_VFIO
        bool
 
-config HAVE_KVM_ARCH_TLB_FLUSH_ALL
-       bool
-
 config HAVE_KVM_INVALID_WAKEUPS
        bool
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70e5479797ac..d6b050786155 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -345,7 +345,6 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 }
 EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
 
-#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
 	++kvm->stat.generic.remote_tlb_flush_requests;
@@ -366,7 +365,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 		++kvm->stat.generic.remote_tlb_flush;
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
-#endif
 
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
-- 
2.41.0.487.g6d72f3e995-goog

