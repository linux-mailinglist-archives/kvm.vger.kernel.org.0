Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF43A48C720
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 16:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244994AbiALPWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 10:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244662AbiALPV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 10:21:58 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F97C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 07:21:58 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x15-20020a17090a46cf00b001b35ee9643fso7098914pjg.6
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 07:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bKysrhfTy6kWHqwLFxfvARORjI8IUbglOVOGzn5bU8w=;
        b=OAz6OE1lvLg5O8+mkLFMomjkDHU86EBeW3DRlFbIX8rD9SerLZgGYxSSM72K7AUMbA
         wZu41tCU8Kz8yZCC7AxhjcsrnxZ4grxwU2YfDTNYqBnTfxx8x3dc4XiYjZ5IrWpjEZaY
         LenMx8Iy+ZIxUafXik4YyXelKCwBClmItOpVoPdzNPs8d+76yw4+31GzjmKN4wOwiQYo
         vu83nWEnskuzrA+Y/CDJ/0c+8irujlzEXbk3FY440XIbqqOCKTBpcs3iRp+45h+X/I3e
         7jQA+prK9MmgPyox5sWptHL+ds2K4ZDryiAvpWvxa4gwFDyQmy/qtTvQswsnZ+S8reKt
         +Xfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bKysrhfTy6kWHqwLFxfvARORjI8IUbglOVOGzn5bU8w=;
        b=ksaDNggzHo0Nn6n1In5yCIKs0IYiV31jDEZvCVrb0jhGnJoplQrlJ2Gik/GgTB7qrF
         9N4S4Rbtu4ssmAax9Q4SSf/73etnapqmjBNk+MU/q1l5wbgcOkjWjXa1cz3jd6BvAC8q
         DsKOkx92Z7f675Qu2kNeJvYL6uVZYagSmgIlMicfyPXiJChTD9hw1k2JeJlA+t3ZJbwx
         PgfdhDvCgCikZGl/C6LgIxKIhGaZIOl1W8XJThdBWF3ZffoBx6CfPcTz2cRVNZArOkME
         12m/JBX08uqTRXD38aI2kb9/P6wPDpYgVTXrdwBtPQ9gT0C0wsNOl5sBk07C3/M1bZb4
         tHsg==
X-Gm-Message-State: AOAM531wofDwL5TnbLqu6nmcsDUuuGnejKeuRN8BYR0JJcVL5syTOKKq
        wCrnHgf8sJKf7Pxh+zpdQwvwqgfnpbUoph7ndjCzPyUKQJ/2YVVYCKdbHOoydmITibxbVrulshT
        X+Ce3vXCDzpxznr9nVFcmCesxe7FrNZo+dnXswD/01TzWfV35zYCl5YcsiqD/vEA=
X-Google-Smtp-Source: ABdhPJyKO2HCZyV+MbxNEYxnAqVFC+kZ+aZoxQdpp3tIQVqrA/Er6Xg0tp8etPm7oJmP+QVLr/dbSqVjLnfqpw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:10d5:b0:4bc:a0eb:c6a0 with SMTP
 id d21-20020a056a0010d500b004bca0ebc6a0mr9743473pfu.70.1642000918116; Wed, 12
 Jan 2022 07:21:58 -0800 (PST)
Date:   Wed, 12 Jan 2022 07:21:55 -0800
Message-Id: <20220112152155.2600645-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [kvm-unit-tests PATCH v2] arm64: debug: mark test_[bp,wp,ss] as noinline
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
index 54f059d..e9f8056 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -264,7 +264,7 @@ static void do_migrate(void)
 	report_info("Migration complete");
 }
 
-static void test_hw_bp(bool migrate)
+static noinline void test_hw_bp(bool migrate)
 {
 	extern unsigned char hw_bp0;
 	uint32_t bcr;
@@ -310,7 +310,7 @@ static void test_hw_bp(bool migrate)
 
 static volatile char write_data[16];
 
-static void test_wp(bool migrate)
+static noinline void test_wp(bool migrate)
 {
 	uint32_t wcr;
 	uint32_t mdscr;
@@ -353,7 +353,7 @@ static void test_wp(bool migrate)
 	}
 }
 
-static void test_ss(bool migrate)
+static noinline void test_ss(bool migrate)
 {
 	extern unsigned char ss_start;
 	uint32_t mdscr;
-- 
2.34.1.575.g55b058a8bb-goog

