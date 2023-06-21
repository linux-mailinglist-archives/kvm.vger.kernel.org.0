Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A744738DA7
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 19:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjFURuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 13:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbjFURue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 13:50:34 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84D51BF1
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 10:50:22 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id ca18e2360f4ac-77da0200928so655647539f.3
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 10:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687369822; x=1689961822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=USXt3yGC1UEnXzlOA0lpUH2cberOhCHcVj/G1UKw8uU=;
        b=htGRA8XsqkJrd7igMfp73ZnJI8ZnXqn5sVSOTVNEVIB4tUa7HjEtsq9K1TNwEWBQsZ
         iDOZEPs3hF4+SE1VlTpHs1e9075DFw2w1NxTW11a6VVlR85nhLPHPmsBM+hgg8Z+rb0v
         II0tNAKY+fHC9iIz/PJJ8ARzdhexhmsBz1G6CqF0pgf5j7kxhGxHA0upZGmk71oKGioD
         OzbKasi88kGaeo6pbuBIVPXGDNqhWuA59ev0wFwRhPndfE97GpTHxkduhySd6cPVassm
         Jct3UqX/i+W/8PKDj4IKUsYC7ZXrvkQQuxbtVHUvV3o1zpBmawLU9LNgOeMOXIwWtk7T
         NZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687369822; x=1689961822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=USXt3yGC1UEnXzlOA0lpUH2cberOhCHcVj/G1UKw8uU=;
        b=ICr31iT/oDIrd6mQJcCW+fL0t4kkvHRWpIEZd3QjzEHroAjdDxRn8aSf2km9cYynRn
         ir0M/nkdzqtO5Id4zS64f+kdEFIa/d/NkXHOlkbRXA9txPUEcqK6oji2E0X6AJN2IjsF
         dBOdKy/LueyiGidVoddWOXd2haaV1FPObq+L6cYEHKXe+8BZp/+uaccOocGdq8VveYHy
         ioNrXMGyx0NTc/uvRT5Q0ZS7NesM6tTBmV98xGdmYmrCkeN7fk0EMCRv4i2ciUrhjlbM
         sG5ZKhQMeNqMbvXnrgSmzSqjtBbPnvoFJ4f0Go7Pwe6os2T/nBpHNgxmjIVFxrfCi6g/
         9JnQ==
X-Gm-Message-State: AC+VfDxsZv5iXiACjtEj9X1DG+ir+p+CCrru1moX+HMvIQBSa4iseUcY
        ZbzVn0b6ZAKflPrT5PBioQKX2Q3SCCAC
X-Google-Smtp-Source: ACHHUZ7UjdRIorpK912qJ80B+WNmvLoEWYcVQQqyYoZ178c0q9AvCI1tPLlFq83IvaiADYrIiHXzSYOljIBZ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:95a3:0:b0:41d:9cf2:f41d with SMTP id
 b32-20020a0295a3000000b0041d9cf2f41dmr5841982jai.0.1687369821976; Wed, 21 Jun
 2023 10:50:21 -0700 (PDT)
Date:   Wed, 21 Jun 2023 17:49:52 +0000
In-Reply-To: <20230621175002.2832640-1-rananta@google.com>
Mime-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230621175002.2832640-2-rananta@google.com>
Subject: [RESEND PATCH v5 01/11] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
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
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
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

From: David Matlack <dmatlack@google.com>

Rename kvm_arch_flush_remote_tlb() and the associated macro
__KVM_HAVE_ARCH_FLUSH_REMOTE_TLB to kvm_arch_flush_remote_tlbs() and
__KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS respectively.

Making the name plural matches kvm_flush_remote_tlbs() and makes it more
clear that this function can affect more than one remote TLB.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 arch/mips/kvm/mips.c             | 2 +-
 arch/x86/include/asm/kvm_host.h  | 4 ++--
 include/linux/kvm_host.h         | 4 ++--
 virt/kvm/kvm_main.c              | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 957121a495f0b..1473cf923ee37 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -896,7 +896,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
-#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-int kvm_arch_flush_remote_tlb(struct kvm *kvm);
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
 #endif /* __MIPS_KVM_HOST_H__ */
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 884be4ef99dc1..6e34bbe244462 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -981,7 +981,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 
 }
 
-int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	kvm_mips_callbacks->prepare_flush_shadow(kvm);
 	return 1;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb9d1f2d6136c..f6e3aa617d8b8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1794,8 +1794,8 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
 #define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
 
-#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	if (kvm_x86_ops.flush_remote_tlbs &&
 	    !static_call(kvm_x86_flush_remote_tlbs)(kvm))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0e571e973bc28..95c3e364f24b4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1477,8 +1477,8 @@ static inline void kvm_arch_free_vm(struct kvm *kvm)
 }
 #endif
 
-#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	return -ENOTSUPP;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb5c13eee1936..a475ff9ef156d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -366,7 +366,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	 * kvm_make_all_cpus_request() reads vcpu->mode. We reuse that
 	 * barrier here.
 	 */
-	if (!kvm_arch_flush_remote_tlb(kvm)
+	if (!kvm_arch_flush_remote_tlbs(kvm)
 	    || kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
 		++kvm->stat.generic.remote_tlb_flush;
 }
-- 
2.41.0.162.gfafddb0af9-goog

