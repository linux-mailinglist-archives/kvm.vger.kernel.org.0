Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8944364343
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 10:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfGJIC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 04:02:58 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41574 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbfGJIC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 04:02:56 -0400
Received: by mail-pl1-f194.google.com with SMTP id m9so805630pls.8
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 01:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H5kKSEsUPQOooKEsuhd2GFcYVA9WoMZPCMVChQ4/8BY=;
        b=YsbA8+7dFdry0hQP7HH+odUFoj404DNdnptRG/rCqLgybyI4CtVtiTge2bNPgVyuq4
         5ivBeLPvO+SaRGqGtprr5+kXRBm2/ukZipkLt/Ja1Dg5beX0cyjgeCbz4Piaswcy8Jhb
         M47Mf/QGHjG4mRJo0FblMeQFp2a7wIEzbKt1bqr28vOsrWXDKOOLEpABtoZ/Fagb4ilH
         FOvSeOldWDme1ntKVKCsh91FWtUDsTpHi7YXUQF38yaz3FBy5wE4PljOiDkY2h/5deZH
         IRtOE9Kbmrwt2scqEGm0vrp2AmCL8Z1A/dvKvVO8LPVMIYCNgiG1JasvGBp4K6ImBQc/
         3wSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H5kKSEsUPQOooKEsuhd2GFcYVA9WoMZPCMVChQ4/8BY=;
        b=sAxhpRPubJe94SY7rV7G9RhKIfMThB/XZhzQzJ+9x2q12lNX8Z3I4HyPj7+ryMTgv1
         Vp0Euz43ym/UJIzuDcey9ZlvctmFEF9A0+rPe3xc6vJ/JEYqtyN5JqUM4UlYw+v5V4uW
         9Vj/PbXsBiOFSISaUk+bMDFBY9eCHXtCACn99okJQFzEAsa8SYAiUe+s3Tvi6zIHt/zl
         zOe4ZM8PhJ+s2xjv2cvCbtCjn0XCk1vA67wcxwaVG8zCLMOanahCkImk6HevNUqRZPst
         NgsO5x77SWqhclnLM7u7jwVpO8eFLHJ7I8aY9sMlF/yS6+BNhxKSMc2j/2gh1SPuk4Ru
         s/FA==
X-Gm-Message-State: APjAAAWk9u/jpUiLtuBWw+TWhPgEeG/ELPZ8UsBGuvuVTsJQ80aZmx7N
        DEpjJNx2KWAdr5ytqIdJk70=
X-Google-Smtp-Source: APXvYqyTovXtpx7Ig98M4UFVhZRe6M4Ue5fe4n/V0XhH99l5Hx/ZcHGSFCGYVz/gBYUHg6CUD26Dbw==
X-Received: by 2002:a17:902:6ac6:: with SMTP id i6mr37638348plt.233.1562745776133;
        Wed, 10 Jul 2019 01:02:56 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id g9sm1058551pgs.78.2019.07.10.01.02.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 01:02:55 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH RESEND v2] target-i386: adds PV_SCHED_YIELD CPUID feature bit
Date:   Wed, 10 Jul 2019 16:02:51 +0800
Message-Id: <1562745771-8414-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Adds PV_SCHED_YIELD CPUID feature bit.

Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
Note: kvm part is merged
v1 -> v2:
 * use bit 13 instead of bit 12 since bit 12 has user now

 target/i386/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5f07d68..f4c4b6b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -902,7 +902,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock",
             "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt",
             NULL, "kvm-pv-tlb-flush", NULL, "kvm-pv-ipi",
-            NULL, NULL, NULL, NULL,
+            NULL, "kvm-pv-sched-yield", NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             "kvmclock-stable-bit", NULL, NULL, NULL,
-- 
2.7.4

