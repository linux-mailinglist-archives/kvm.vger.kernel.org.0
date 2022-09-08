Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A4D5B1ACF
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 13:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiIHLES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 07:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIHLER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 07:04:17 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93425B276D
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 04:04:16 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d82so3922107pfd.10
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 04:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=8klfUEhKxuahKM34ft6Xk1j8LdCMioEPyO0tU5Xwf4w=;
        b=L62uGedyyDHZFn9ZDdvHYjqOyQFu/sa1s3JsuW8QQYkforLV0LD7/CkAhX8py54ZH0
         eQLOIKyg9l6KZx5B8LhihYjHzjj7w/Zb4Yg6OCP5qq/1xwJkBv6xs3ekoyL4Z1OL84/9
         B7O7/rv3zqafFgTSuVzQrvmkQD3IPkwitjIkPVawgVgsIDwglna2kiPv8Jfz0BiUOiHq
         Q5h2IpeZiDNy8ZjsAEk2Gvx4lk+uSt9SCzdvRMtZnDSh0k2OEsgYgKLkLwx/z0ous1SF
         v7To0RkhKUzdW5yOj4hUuPv9YCQun777LnFrR/69/+PWKptfnY1TXBoOCqIQZq1CO30X
         R/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=8klfUEhKxuahKM34ft6Xk1j8LdCMioEPyO0tU5Xwf4w=;
        b=y05kn2Z+rcem762whNfbJuoa5TESEKpMbKc5vWBkIn7jOi73jKS3Og1costGnys73F
         LGzGjs0ZMfOvHAePTtLeScLidv1aNIHbjIHpHYDMvCeOBHmLnNAFErpTMdg6juFmbqf1
         np3/jviPvDxguVk8st6QGvMWrN4u22q5yiz91EAJJiU5zKAZMr1uKGrEWJuGRe5urxt1
         rCuWsf8vYIG7f+HT+6kqMzKvZ7kcUbhHk1Cs5NZdPQWW9WO2J+JOjpEftgp9hISUu9op
         lJdHDrO8HE6smwqgwSgu6XMcrRe+YUmR1MjS1dindsIEj9t+EzI81gKWVqcghLA1QUcS
         c8gQ==
X-Gm-Message-State: ACgBeo12f+GJq4MnwnM2Z6UoWVjj5Em6B0ky5ocsM2Axbfhz4tnAgu+/
        kK5xKhu0r4RD9aNwQtKMpye1jayALOTpHQ==
X-Google-Smtp-Source: AA6agR7GL343ySe4mtV74WQtqa6mVHGs3p/qeL1HRumHIMOQmDe1zHdI/6Buj2oiQb7CN5bnjikIEQ==
X-Received: by 2002:a05:6a00:b43:b0:52f:59dc:93 with SMTP id p3-20020a056a000b4300b0052f59dc0093mr8749680pfo.26.1662635056033;
        Thu, 08 Sep 2022 04:04:16 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.86.251])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902f64c00b001749e8eee4fsm14175191plg.226.2022.09.08.04.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 04:04:15 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH] RISC-V: KVM: Change the SBI specification version to v1.0
Date:   Thu,  8 Sep 2022 16:34:04 +0530
Message-Id: <20220908110404.186725-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SBI v1.0 specificaiton is functionally same as SBI v0.3
specification except that SBI v1.0 specification went through
the full RISC-V International ratification process.

Let us change the SBI specification version to v1.0.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 26a446a34057..d4e3e600beef 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -11,8 +11,8 @@
 
 #define KVM_SBI_IMPID 3
 
-#define KVM_SBI_VERSION_MAJOR 0
-#define KVM_SBI_VERSION_MINOR 3
+#define KVM_SBI_VERSION_MAJOR 1
+#define KVM_SBI_VERSION_MINOR 0
 
 struct kvm_vcpu_sbi_extension {
 	unsigned long extid_start;
-- 
2.34.1

