Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828A57A66B8
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 16:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbjISObS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 10:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjISObS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 10:31:18 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5516583;
        Tue, 19 Sep 2023 07:31:12 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-403004a96a4so63625325e9.3;
        Tue, 19 Sep 2023 07:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695133871; x=1695738671; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8Rt9ZRjuh0TBv20Cp+ldIRytJvrsd1UIlNU96DDB3sw=;
        b=faeZ7rUNRmE2gnqEigSreVhO83202izahqxSsaXtdTqt5nz3l028siJJyYZ/werKf+
         D0VVtD9FcRvaYdryTHy8KfHlReyl+J1b1oTs77FiZHybrFEhwqoj5uIda52T2P0y4jcf
         2rmYl0Su5M6t42FQ4fDQ2VIdWdWj2qHLNIzdK4LVisf64N/hXHkuTPiQgmyC81mTo+72
         jctKxbUQhRFxCawPvf8yLt0k/tZE6ouD1XyYE7EvbECNMfGy3LMSe7PwhSnb1Ykjlu/X
         P+cgNZNbhuJ7lni58jjwytcBI0yhbDgiJeqP8f0cYK3xKCsYE0ht98bvGyx4D3+w/bY9
         E9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695133871; x=1695738671;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Rt9ZRjuh0TBv20Cp+ldIRytJvrsd1UIlNU96DDB3sw=;
        b=QCb2gK38B1yMKKn15Nxck2ReVeX6dHPg2VDRuCqpZuLhgBVByM8JA293WR0Gs43yiv
         czQBIju6GdOge8pSAuXc+OsYYjebv4XXWnAFXO7lcLFoIgOn57sFoMGz4vM20KkrrYLo
         Ize3mjN3DqRzLRui1kcR3f2L9CvWPidS9oWuRhGITNCwnfWc8de+neV93PeddKZvzIiX
         6rEQe0610WvgtBmzzpfVZ3fzATiiyDJ87PHm1/3E7gch+YsCye4dgTNka3GPyWgCOjM1
         czkyKBpDH/vYeLZFs8scdt4esgBriVAOiQXXmQC4t6+61qcBD8/Wx3YG+lyzwnFEKH61
         dSuA==
X-Gm-Message-State: AOJu0Yxt7hdrGWhtx/j1XWVXvhU+JF7fr3abW5EYin21IUiTbqHAJcba
        iqrBzLt0U9TlxIUECUw7EBiuSuRSnMa1G2HQX68=
X-Google-Smtp-Source: AGHT+IG+nlhQTELmnQrCkzhpxIpV86WGLa0WlEisxadWtwwsRU6NYMkY/ECET26jJJAMdVhrafGvepGxqZWbNO6oJgo=
X-Received: by 2002:adf:d20a:0:b0:320:896:5ea8 with SMTP id
 j10-20020adfd20a000000b0032008965ea8mr6730564wrh.19.1695133870443; Tue, 19
 Sep 2023 07:31:10 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Tue, 19 Sep 2023 22:30:59 +0800
Message-ID: <CAPm50aKVDLhZo_3kkKyC9AUN0BGrYnPTo9hGqRg1M3TsUQQMSw@mail.gmail.com>
Subject: [PATCH] KVM: X86: Use octal for file permission
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

Improve code readability and checkpatch warnings:
  WARNING: Symbolic permissions 'S_IRUGO' are not preferred. Consider
using octal permissions '0444'.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/x86.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3412091505d..8c1190a5d09b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -145,21 +145,21 @@ EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);

 static bool __read_mostly ignore_msrs = 0;
-module_param(ignore_msrs, bool, S_IRUGO | S_IWUSR);
+module_param(ignore_msrs, bool, 0644);

 bool __read_mostly report_ignored_msrs = true;
-module_param(report_ignored_msrs, bool, S_IRUGO | S_IWUSR);
+module_param(report_ignored_msrs, bool, 0644);
 EXPORT_SYMBOL_GPL(report_ignored_msrs);

 unsigned int min_timer_period_us = 200;
-module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
+module_param(min_timer_period_us, uint, 0644);

 static bool __read_mostly kvmclock_periodic_sync = true;
-module_param(kvmclock_periodic_sync, bool, S_IRUGO);
+module_param(kvmclock_periodic_sync, bool, 0444);

 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
 static u32 __read_mostly tsc_tolerance_ppm = 250;
-module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
+module_param(tsc_tolerance_ppm, uint, 0644);

 /*
  * lapic timer advance (tscdeadline mode only) in nanoseconds.  '-1' enables
@@ -168,13 +168,13 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
  * tuning, i.e. allows privileged userspace to set an exact advancement time.
  */
 static int __read_mostly lapic_timer_advance_ns = -1;
-module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
+module_param(lapic_timer_advance_ns, int, 0644);

 static bool __read_mostly vector_hashing = true;
-module_param(vector_hashing, bool, S_IRUGO);
+module_param(vector_hashing, bool, 0444);
 bool __read_mostly enable_vmware_backdoor = false;
-module_param(enable_vmware_backdoor, bool, S_IRUGO);
+module_param(enable_vmware_backdoor, bool, 0444);
 EXPORT_SYMBOL_GPL(enable_vmware_backdoor);

 /*
@@ -186,7 +186,7 @@ static int __read_mostly force_emulation_prefix;
 module_param(force_emulation_prefix, int, 0644);

 int __read_mostly pi_inject_timer = -1;
-module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
+module_param(pi_inject_timer, bint, 0644);

 /* Enable/disable PMU virtualization */
 bool __read_mostly enable_pmu = true;
--
2.31.1
