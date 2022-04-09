Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC794FAA66
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 20:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243138AbiDISsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 14:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243112AbiDISsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 14:48:16 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2D024959
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 11:46:09 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id p10-20020a056e02104a00b002caa828f7b1so78770ilj.7
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 11:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VidXWl4NH6Hry9qZzq5ca2VxcR9Odk6Nar4a4f+oWvU=;
        b=ek/S6WuWIb3shY/gBGZqdK34+t9TRPzxUssPucli2yqNkXS2MmMO6m5wmA2OvUDmOJ
         uTadVD976jZpe7AKO5trQKXOH+R28jTCX5S9Av8CR1TNeqWgYJ6DY5tZ+uQ865GoZEa/
         QIpxybUjAkgF94A4D0vFlesLwG4EIo3M23Q7Z9wugnwDCP8j7aHflpDIsckmCUBg0h15
         Vpz65XqnN9/baOg0f+a4KEF47Ihm5tlXvL58LoMD1igQlrmYJcTwZqmmY7ZsqUZdnDqP
         KEYmBEPxid8Q59tSZKWRMkUmZUVDbQm1B37OGxHL/FrLrqQia3cB4ewnlwKc5/5tuozV
         8CUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VidXWl4NH6Hry9qZzq5ca2VxcR9Odk6Nar4a4f+oWvU=;
        b=Agv8eM3gz7j2incQzTpFvWRJJ2AhM7Vkymm/0F/fj+sYxPxvcZ+guZJGvD0aZMCnVL
         mRMA3OO1CCu7MgIhojW0sX/eGXakq31qhNI4g6rb4UAs1b6KYYCBFYdZQDck4u985uQ1
         58dJIxlFF6w6uPc8QMVjF8t7wDL7QqHqowsG3BMlOg24qXehc3eyKhw7zHjMo8kPAhPc
         QWnqsMrLC2D1Twy8Iu7bxubXclyaq9A25ykiuD9wfkDVC/h93sFtxfl/1GzPY3BcSF50
         yrlc7K41uvBpoMexmeT+929R1788J1niinesaR1teWRldWjrrvYZbyMYPNpSWSCa29Jn
         HBcA==
X-Gm-Message-State: AOAM530itu+8cIyeSV72SvZ5W+HCeiXE+9gnw4u4s/BiKr55EMnf7CIq
        6pVwTLHWSjrY2Z5/Yh5sa5MsU58Bj8Q=
X-Google-Smtp-Source: ABdhPJyOlIPbNXBdcHXns5CIYQoET7JOk9HcIP8HQoCjskl12aloONe/ErTVMDy3hBxqIExT3j5Vo5p8lAo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:13d4:b0:649:934f:e957 with SMTP id
 o20-20020a05660213d400b00649934fe957mr10624778iov.25.1649529968492; Sat, 09
 Apr 2022 11:46:08 -0700 (PDT)
Date:   Sat,  9 Apr 2022 18:45:45 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-10-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 09/13] selftests: KVM: Rename psci_cpu_on_test to psci_test
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
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
index 573d93a1d61f..ee60f3cdc0bb 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -2,7 +2,7 @@
 /aarch64/arch_timer
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
-/aarch64/psci_cpu_on_test
+/aarch64/psci_test
 /aarch64/vcpu_width_config
 /aarch64/vgic_init
 /aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 681b173aa87c..c2cf4d318296 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -105,7 +105,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
rename to tools/testing/selftests/kvm/aarch64/psci_test.c
-- 
2.35.1.1178.g4f1659d476-goog

