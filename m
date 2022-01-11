Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3599948A6B5
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 05:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347466AbiAKELM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 23:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbiAKELL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 23:11:11 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A546FC06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 20:11:11 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id k93-20020a17090a3ee600b001b32ec86e10so13562043pjc.3
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 20:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vuys1FOVQgJkQm3U23Wnkdvvz8kMB7ON0dRulHlLdEE=;
        b=DMOs9ZfuIX/E8E0XOSnK/jEt42wVxalj2BjYlkjVxBiiLVtCW8IfoafUUEyv6afof2
         kU+X4V61/uPmHSqdWMLxLTsPH8SRE7MD8xTmo+4mnsrn73gHo0lUmU8fsx0RGRimmHxh
         BbeIVLhYBzcEuwxNd+EvfQNxk15SOD3U5wEAato04jXIRYvbtrcmiaWXa2aCYAzvBJeh
         2wSJoZDojPBHmjNWMZ66K3vYJmPkxt6OyaUuVqx15Z7u5Ns71Ak7sN8UgkqNJs9mogx+
         l5118bYPCDAPg8AKCVTviTiAiY7J241SVVTMBM/xXlq0FcsYSPcF8XuAd01hQhMxGr2n
         z2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vuys1FOVQgJkQm3U23Wnkdvvz8kMB7ON0dRulHlLdEE=;
        b=DSNK/LYx5crbyfKeMfCSERIw/9/o0/qgpcOOp2KGwHPUDJHIxH/YFKbX5jWyUk19es
         wN4hwKfOJeDatv0EtgsNfuc9SKie91880rP7pSS6AAhWflO/+8Iw9/y7W3l5l9hPXGOJ
         bkeA7L5jJerK5IjlDssOWmaG8D05pVxJEUBbI98uRXMlI2OaNIWEk/WTZ/UIE6mFjvhC
         Gsq/70l+kZFzbYzHiOBAeuLJDtu+Yv9VVFMotbg+5va5l8XODNFYtkWwNV5bgC2IyLKq
         9HmJZXrnqSQJgRgfY2YJvpBtJ86Vj/ZOUAOs5rt/O97NY+at6OULuQhElz0KF1j+1ily
         Varw==
X-Gm-Message-State: AOAM532qWRy/drPexu73osNvHzIgTI8SC1R9+7Fb5BC+9hlx2MyUClqy
        TVFAr4y+7tiaU1vLl9NH12LcvqXgmesFxNllarDa470h17xlKdiiWyZysg9r3yU60mzzqgH6iIW
        rZWCht+Y/6BKFlIP5OHuAKubsOljVqjDzhXQsh8ZY4U6yBXxGreyFpApZcEAFihM=
X-Google-Smtp-Source: ABdhPJxVtWdGmFRZAURDuDsj5vwVOqytm2YwefpIzsPSUT1dplrnA1BH+TP83+kWDfXruoOlCGzM4mllxvS5TA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7793:b0:149:c4ad:ecc3 with SMTP
 id o19-20020a170902779300b00149c4adecc3mr2585026pll.171.1641874271051; Mon,
 10 Jan 2022 20:11:11 -0800 (PST)
Date:   Mon, 10 Jan 2022 20:11:03 -0800
Message-Id: <20220111041103.2199594-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [kvm-unit-tests PATCH] arm64: debug: mark test_[bp,wp,ss] as noinline
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maz@kernel.org, oupton@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang inlines some functions (like test_ss) which define global labels
in inline assembly (e.g., ss_start). This results in:

    arm/debug.c:382:15: error: invalid symbol redefinition
            asm volatile("ss_start:\n"
                         ^
    <inline asm>:1:2: note: instantiated into assembly here
            ss_start:
            ^
    1 error generated.

Fix these functions by marking them as "noinline".

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
This applies on top of: "[kvm-unit-tests PATCH 0/3] arm64: debug: add migration tests for debug state"
which is in https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue.

 arm/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/debug.c b/arm/debug.c
index 54f059d..6c5b683 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -264,7 +264,7 @@ static void do_migrate(void)
 	report_info("Migration complete");
 }
 
-static void test_hw_bp(bool migrate)
+static __attribute__((noinline)) void test_hw_bp(bool migrate)
 {
 	extern unsigned char hw_bp0;
 	uint32_t bcr;
@@ -310,7 +310,7 @@ static void test_hw_bp(bool migrate)
 
 static volatile char write_data[16];
 
-static void test_wp(bool migrate)
+static __attribute__((noinline)) void test_wp(bool migrate)
 {
 	uint32_t wcr;
 	uint32_t mdscr;
@@ -353,7 +353,7 @@ static void test_wp(bool migrate)
 	}
 }
 
-static void test_ss(bool migrate)
+static __attribute__((noinline)) void test_ss(bool migrate)
 {
 	extern unsigned char ss_start;
 	uint32_t mdscr;
-- 
2.34.1.575.g55b058a8bb-goog

