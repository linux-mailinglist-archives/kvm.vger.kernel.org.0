Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AA47786A6
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjHKEvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjHKEvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:51:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F642D56
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d20d99c03fbso1735396276.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729497; x=1692334297;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=72O4JjoYZq3iLcv3bAZ3OmpFstwA2kMJRyaM4BuQEBE=;
        b=HddCJ+lp3+jj0ct27zpd1lNr8C4Kzeyb3GiDQVC9OipT4plhEUG6QInYijh173H3ds
         BI05ZFWTfJKE1MKb0GXzQfP5/She9vTxOrKuUYYstIZt8/bEjACjKBi0/oTDTY8t7Jcm
         Ow+WuPnPrdQ4lJKwlEDxpICQU7Bx+Pdi1qQO4UJkw8lUmEurZJImS8W6xBxvYILyhzbm
         Zt/Apvf0YXgwF6mhZPXiO3Hog0Z/bd/jtMVs9sWAPHRKOKVU6kT0sW4BuHoNFvUKx004
         X9FA/gPsfCblAg7uQFIvawvYaaCS5u2ovb7i0ng5dWtYtlCksBlGnHijFp3TN8c3dzJr
         pm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729497; x=1692334297;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=72O4JjoYZq3iLcv3bAZ3OmpFstwA2kMJRyaM4BuQEBE=;
        b=dLfLb9oSo2142c3NiUCGqPLnmAUR4Jt5BRqYzvJ25MI9x9YI9a37EZyPiV83MGiwKn
         wzN2xlv7qBlB+QbnbUsRIutdSZNUNq/4rh4kCzUQ8KkBvWRcHUw02YGNLpcK9BX5jnzP
         R7XIkTW2osRjwYIm7dzrld+XLu/k2GX7uvC6FD90x+TTAxmww7t1+votYZeE++BZQhIQ
         DGmkz/IhbG2dYP0ZaCQ8GM1xxn/u+6Iy4052GGJmrZNRlnapTL8X8NVEevAhGc3cLp2i
         sxJpQUN2kDD71W13rawWbIertjGqD86XSij/2bQnl2heGiMEa1oEsXl+amaibjDomE+I
         ydUQ==
X-Gm-Message-State: AOJu0YzfHiOp4IUBMPJf0/9tPve72qioF8P7xA886e1Z/C9/shLeEEtU
        kG/RcfB+0TyvYVbLhAcChjx0adgmvD6H
X-Google-Smtp-Source: AGHT+IHrE1zqHDQMkwvCDnx4McTAflvKFNeP5WMV4qmwSVl14mBhjosxgpufAzi6g1c9LXTVfiPEOwUlOxgs
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:b190:0:b0:d0e:d67d:6617 with SMTP id
 h16-20020a25b190000000b00d0ed67d6617mr9413ybj.4.1691729496798; Thu, 10 Aug
 2023 21:51:36 -0700 (PDT)
Date:   Fri, 11 Aug 2023 04:51:14 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-2-rananta@google.com>
Subject: [PATCH v9 01/14] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
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
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
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
index 04cedf9f88115..9b0ad8f3bf327 100644
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
index aa5583a7b05be..4b7bc39a41736 100644
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
index 28bd38303d704..a2d3cfc2eb75c 100644
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
index 9d3ac7720da9f..e3f968b38ae97 100644
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
index dfbaafbe3a009..70e5479797ac3 100644
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
2.41.0.640.ga95def55d0-goog

