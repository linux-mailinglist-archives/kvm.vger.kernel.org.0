Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7804D67DE
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350863AbiCKRmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350845AbiCKRmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:16 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEF01C57EB
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:12 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id a1-20020a927f01000000b002c76f4191c5so2942896ild.0
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ueuw6G3CB3aC6lh20NpaqUZj77A7koOiFEWMjHH47o0=;
        b=emHdHGZ7VoMCVW+tBvbqRBR3shon8hDPVzTreGlVv0x5af9H5PaJYsRQ6qP1Y1qg93
         w5su+HLqeZpGjfPiHTWt8cz7N9M1xzHGIRqxVGK53Dbo3fXYn09/n3m7dwpP4PStKOFV
         vKmJOfUA3PNgAzQ6nRKcN+/xUMG9aELEDVogerM/pfhhqw0bXSlpdCLTWWSiFroD+1M+
         SCOvQdmhyzJsmCRuid+gZ/AH5d0e2IpfPzImkHJmNA4JqXhT8ezksrnvKA4iDLHWaiOj
         ouxq8jazGhLAgermQ4RF+EoaZcL3nrP4OM06PQwBMBoGqqyfSDChLR0RkOGXRj8e3Nxm
         8+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ueuw6G3CB3aC6lh20NpaqUZj77A7koOiFEWMjHH47o0=;
        b=lBwFvuX1DR2AJNzT1XWxSe+5r92Bu0OXyZ0Sfjd+3+ZJ6koIlMyCyL7+jHrklUDxG5
         8Q1cv860HouC19N7j990t4DOVlK/nTutXmkx9WI/HWgc36GAugF1iDQGvcz8q7LsDqgo
         2w8VUh0WmGxGsY+CxOKrVu7GfofKEsWb5YN/GJ6w1doDHoMdEuHOyPFE3Uxy5uIdIAb7
         Rox7WPSi2q7M5ydHaF88jyukqaCI1gajjithxfRjLUeX7us7w/HrwtDZtw7JxJirRXBA
         N1txZp4dbz8jIDM4Zzis59QQXbZwQ+MhbLJa5CMYIekOvh4T5tcv4SwvGbl1UeIX6yRh
         zR5A==
X-Gm-Message-State: AOAM533q17SRKsse57HQZMKZJaOHB7haxN6jcWazP0FHkO2HbT4g44pU
        vbQeepnpUKl/mqkyIVRvmqBc1B5hs+Y=
X-Google-Smtp-Source: ABdhPJyOYB8mAhfnrE18fEDSYqH98DncrKtJHVGBq0WqibguhNJlqPsHtU7nCGpfqDEzzx7hzv9FxNaDErw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:154b:b0:648:cab0:aa72 with SMTP id
 h11-20020a056602154b00b00648cab0aa72mr1961053iow.33.1647020472189; Fri, 11
 Mar 2022 09:41:12 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:39:57 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-12-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 11/15] selftests: KVM: Rename psci_cpu_on_test to psci_test
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
2.35.1.723.g4982287a31-goog

