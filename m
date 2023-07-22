Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAFA75D8F8
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 04:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjGVCXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 22:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbjGVCXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 22:23:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C6D1FFE
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 19:22:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so2487114276.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 19:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689992576; x=1690597376;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UVLGuKEjQProJqaPfm81PXZA82sh3ahc82iDRViuago=;
        b=DaLEp3aJ4g6CjdnA0OVj9WkB7kkXMt625ketI1mIwG+OhRkvRKCPCtKyHBL2UCAqYY
         6BncKNylF6VcSIGB7t2n3Dn5CSP5pExm4CWXgG/7FBXwJBN/sfbQoQJkNHBRmm7ty36B
         MUq7scacSqWfqYq+g6x5myBi0MtQ00UJ8FS4/ZD3t5CVrpw1PJguOOGojtWyaSDCq8CR
         wxIhR/Ia0t1mcVqGNVHspJivlXBaENEiQmQfnWiNVUDMkH86T6m391vIAog4sIm8/2iB
         pyqjcZ0+mz+4rKI9vVwdSw+mUeLYWB0SqtgAVPENuunzVlpmitoCGeYAkoQ9ERKGNqdJ
         aPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992576; x=1690597376;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UVLGuKEjQProJqaPfm81PXZA82sh3ahc82iDRViuago=;
        b=MloYyvgbIfV+fTbfim9GFggjRb9E4KQT/+XcUEnqj59HVztsvNaEH6yZWHrr51QE87
         jKYJFWmCq5G+QcQ3Y2k/gvc0yjicrzgjZCdOPa11KtnqyHpN+nigEo93MvHioU50h2wn
         mYx1ZmvJSSrSQ6yULCl6djyUuhESccrlGi1Vl+8gPCbCRW5toIyqBPHNDGPdTkOwp0lN
         2X3Tpjg9TME4JBh8VVeAkUhK/+w0HwzOE6IO7DkT7xtaE5F1pHRJWnxMn9Vpzv/4EqWT
         CYTXAVb4bH+lqp+f1UNRkjHodmeHRHgPv7l95AfDqECHVB0RgLFNkKvKOgkS8NEWvBvz
         QerQ==
X-Gm-Message-State: ABy/qLZ0LVUVitpjnixnCVkkAXdz/ARp5acs6Fx3LHBBy+bFKkqesDg/
        j2t+T/P7iF1FZVH1qjUIk7To5CFNrwGb
X-Google-Smtp-Source: APBJJlHQe7Y3wSceME6OjPlLqlGW70YZjKObimLmg37ClQQ8eARD2Nzbb/mjJTiI0hLe3HTUEbMa1eTVRYUZ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6902:10cd:b0:c1c:df23:44ee with SMTP
 id w13-20020a05690210cd00b00c1cdf2344eemr27095ybu.0.1689992576195; Fri, 21
 Jul 2023 19:22:56 -0700 (PDT)
Date:   Sat, 22 Jul 2023 02:22:40 +0000
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722022251.3446223-2-rananta@google.com>
Subject: [PATCH v7 01/12] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
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
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 arch/mips/kvm/mips.c             | 2 +-
 arch/x86/include/asm/kvm_host.h  | 4 ++--
 include/linux/kvm_host.h         | 4 ++--
 virt/kvm/kvm_main.c              | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_h=
ost.h
index 04cedf9f8811..9b0ad8f3bf32 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -896,7 +896,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *v=
cpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
=20
-#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-int kvm_arch_flush_remote_tlb(struct kvm *kvm);
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
=20
 #endif /* __MIPS_KVM_HOST_H__ */
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index aa5583a7b05b..4b7bc39a4173 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -981,7 +981,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kv=
m_memory_slot *memslot)
=20
 }
=20
-int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	kvm_mips_callbacks->prepare_flush_shadow(kvm);
 	return 1;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 28bd38303d70..a2d3cfc2eb75 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1794,8 +1794,8 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
 #define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
=20
-#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	if (kvm_x86_ops.flush_remote_tlbs &&
 	    !static_call(kvm_x86_flush_remote_tlbs)(kvm))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d3ac7720da9..e3f968b38ae9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1479,8 +1479,8 @@ static inline void kvm_arch_free_vm(struct kvm *kvm)
 }
 #endif
=20
-#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	return -ENOTSUPP;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dfbaafbe3a00..70e5479797ac 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -361,7 +361,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	 * kvm_make_all_cpus_request() reads vcpu->mode. We reuse that
 	 * barrier here.
 	 */
-	if (!kvm_arch_flush_remote_tlb(kvm)
+	if (!kvm_arch_flush_remote_tlbs(kvm)
 	    || kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
 		++kvm->stat.generic.remote_tlb_flush;
 }
--=20
2.41.0.487.g6d72f3e995-goog

