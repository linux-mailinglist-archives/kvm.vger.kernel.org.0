Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB884C0AFF
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbiBWEU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238041AbiBWEUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:20:21 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF043B57E
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:55 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id r16-20020a92ac10000000b002c1ec9fa8edso7303067ilh.23
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K05fvQicaJYGcAIRS+q3c6MkmVYlSOGtWB1E2Xpx9MY=;
        b=cOV3DkQSHq8C48kNwXLpNqrxnZk9U+32V6P3HSyML9YbmrhB9wp81h7jhwVl/BpCqp
         h2aaSCvunxnq2XwAtZ1NtbqBwAOrxpRa+eHfEcVwNrXoQNJbkv8NgvkZil8RZcCW8nhk
         LDHAd5hcLqQYYbTCQdwRCV8uOMAmmEvFy+HLNuti+JebtBhqTOXz1s5fXEXSzHMaCgiX
         QUlt5e2OX2lRDdyqZzb78bOqCS0ytqCucVdJQDSHaY4t/Zcdwnj/oVMNGNPD/rISo5Px
         McJaaBVKTXD6blSeU+rgmYUaKgXlnL9XpuREraZ4zPtR/EIt8cDCs6QfzazCuila0Qoy
         +BgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K05fvQicaJYGcAIRS+q3c6MkmVYlSOGtWB1E2Xpx9MY=;
        b=KgvSANnlc8/nDFIHicD1kjk/5ScHsS0ePv4gXCfpd6E3t3uJnTKyjLR0XZZSlAKTTl
         JBGzanSwOwyVPnznsFyvEsQhLNv2vktBY39DdQu1yD8te87Pag94/HvTnQlADe4jXHXM
         B8Clpy8y7NICJMdmT+e23EVDPtQ1oRBYMJQmnl5hAtjDmiqfGM5Pvu/MomkQue6wb986
         tGkGrHvXMBgzcz9+bgr4M27MpElBUUUODCelayjNKls+98nE/WYEU1FeZo87hOBLXGQ+
         QFuc5AhN7y4ZyloqJFUfktuXIIHpSGjpEFQdFoKg7iKFngAISTbt9wVhzPhAMN+horbY
         k5Lg==
X-Gm-Message-State: AOAM532NqXBo7xOlypplFJHIzKZv4E7/vgKsXBmIx0UA2kb6u8mc20Ss
        6HhercTrKXMtmjrmsQ3ugGiVnmPJqLY=
X-Google-Smtp-Source: ABdhPJx9EK42sxEH+BG+6tOThbTFf2MQuU87W3tqJAj/WLPK9D04S/Ht5IzLgrLm9XmGiETk6n0T50MIUic=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:9406:0:b0:2be:6ace:7510 with SMTP id
 c6-20020a929406000000b002be6ace7510mr22283790ili.291.1645589994488; Tue, 22
 Feb 2022 20:19:54 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:40 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-16-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 15/19] selftests: KVM: Rename psci_cpu_on_test to psci_test
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>,
        Andrew Jones <drjones@redhat.com>
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

There are other interactions with PSCI worth testing; rename the PSCI
test to make it more generic.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore                          | 2 +-
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c}   | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/testing/selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..ac69108d9ffd 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -2,7 +2,7 @@
 /aarch64/arch_timer
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
-/aarch64/psci_cpu_on_test
+/aarch64/psci_test
 /aarch64/vgic_init
 /aarch64/vgic_irq
 /s390x/memop
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0e4926bc9a58..61e11e372366 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -103,7 +103,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
rename to tools/testing/selftests/kvm/aarch64/psci_test.c
-- 
2.35.1.473.g83b2b277ed-goog

