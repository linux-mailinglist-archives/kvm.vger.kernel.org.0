Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D59656EA0
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 21:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiL0U1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 15:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiL0U1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 15:27:11 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55809DE8B
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 12:27:08 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 38-20020a630b26000000b004773803dda1so7079756pgl.17
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 12:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qCzwghH7SV8LHiwiLiTnIa1QnROT5cycS0kH6VtnR0w=;
        b=D3TMtco44ZgZJ7LEUwB2F6kHBiLsaTVvfkAYadL8OZeAJnH4UVRXDLbi2R8Rc67zfV
         L/D57mfL5lGgGCWl9UgBKsSRcJg4rr/RhDsH3pdSvZkjuDMoMbeWpMT06VIleGXxU5YJ
         x1VZ89dQzUxGg1z+rCMDvogjKQiJVLtuuAJ7ETne0Xq25qKV403StNrGWY93r5K0DMzv
         IQJjGvlVUCod5m4LXlUX7x3RHw9SxEyh1en88iFW2azs920QNsu+kjKZMiXsPaPeaetL
         L8mqZNIHhZ2FDxxjDhG4Pj+/fE1B/a/yorxa9sU5+bXRv5F9CnymUKarIkER4aQCmaTH
         tZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qCzwghH7SV8LHiwiLiTnIa1QnROT5cycS0kH6VtnR0w=;
        b=59gsB+vGh2ZU+nfUFZsyze5k58gi6IUkC6v9/IU/fqy+l7AKPssm9MovYtO5kHWRPq
         LVvMEZpYNxe3RofnlbYyrSVgd+iSpwjV45EgPBy6cvLR761DVthEcTKO3DODW4Xf+Xat
         usygnl3p/oVUaOZHH6XtVXvUhHABRJjJKVj+oXJHsTTRzc2Dz/bDHbSIE9L/zJ+J3xKi
         nN2NRRst72iDU/opFz2b7XlASo8V58IKnoMwSyGboXaLLO135RA7Q1+oTyynsfFg3Rq+
         6F6H7HlaUr/J5PgE+pbJStTWxp4WkEloSAu7E56SJtMLd2tz6ziaG04j4nGbCEZswhvX
         jQmw==
X-Gm-Message-State: AFqh2kpRJsXG2egGFJO+NUFWA9eftFExeukGGcqtT5tt20oRwhy9cmOh
        pukCWkbUgp3Jfuku8waNoxGjL+YIH7qBzp9KVaBjViXHha+5+KiSIRQ4sW1fgm90DA63iJHliBv
        4xZ6hkv0Hm9IhL0xnmKuCKDD37OLxhD7LC5CwP+z8a0DX3EjyWxZzQPVRg+PS1om1S1Zb
X-Google-Smtp-Source: AMrXdXteq/h2LU604XQBWwyLTGL5YMYAtKkZmkQ73Vd7ckVLKHt10/UKAbkCFmtd/9MJ5c/pJjIwPYkqHBz5f1Ko
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:9f42:b0:219:5f5a:7192 with SMTP
 id q2-20020a17090a9f4200b002195f5a7192mr1776783pjv.144.1672172827741; Tue, 27
 Dec 2022 12:27:07 -0800 (PST)
Date:   Tue, 27 Dec 2022 20:26:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221227202636.680628-1-aaronlewis@google.com>
Subject: [PATCH] KVM: x86: Remove the second definition of pr_fmt in hyperv.c
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both commit e21d10ee00c5 ("KVM: x86: Unify pr_fmt to use module name
for all KVM modules") and commit 1567037614af ("KVM: VMX: Resurrect
vmcs_conf sanitization for KVM-on-Hyper-V") define pr_fmt.

Remove the pr_fmt that was defined in commit 1567037614af ("KVM: VMX:
Resurrect vmcs_conf sanitization for KVM-on-Hyper-V").

With both defined I get this:

arch/x86/kvm/vmx/hyperv.c:4:9: error: 'pr_fmt' macro redefined [-Werror,-Wmacro-redefined]
        ^
arch/x86/kvm/vmx/hyperv.c:2:9: note: previous definition is here
        ^
  UPD     arch/x86/kvm/kvm-asm-offsets.h
  AS      arch/x86/kvm/vmx/vmenter.o
  AS      arch/x86/kvm/svm/vmenter.o
1 error generated.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/hyperv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index 398240a4327b5..2a26a0f27d489 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define pr_fmt(fmt) "kvm/hyper-v: " fmt
-
 #include <linux/errno.h>
 #include <linux/smp.h>
 
-- 
2.39.0.314.g84b9a713c41-goog

