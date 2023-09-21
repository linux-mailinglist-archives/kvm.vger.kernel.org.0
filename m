Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E1C7A9707
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjIURLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbjIURKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:10:04 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13984422C;
        Thu, 21 Sep 2023 10:05:23 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-5029ace4a28so2809471e87.1;
        Thu, 21 Sep 2023 10:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695315877; x=1695920677; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DbpJd4TlttID0l3bQ6gXNygoHh+Zdpn8YAWj7L1EOlo=;
        b=Vj3m0EK/Ep2N6DY3rDrQ29AYnbDuzj2R7fTZqosBoSvqCPPllEVaCvUrJIDV0hlnqZ
         O23drNHfgD30NRm8ZpzVwNeQ8Shgw441L1exN1jJQKkUm4rPcwK0No4kOkeR1JfGH/cn
         JdDsmdH6aJWscQq6ZNxYjZDZ3VDEXQsZBQNZdKTg/vOAt0LENXzVsI2/U8X+h0tDey2y
         I8OKOkIS7s+O/XxCevvzInKemj1XqJcjwcuxUuYcyiMx1EgP1c+4u8eEFdSWNCr8F7J7
         MzX3303eQUA+tbmq3LH0yRLGKEuEW5aBDadW+fmeErWmZQ9enHd4n2MOlQBOhkjihtyA
         etYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695315877; x=1695920677;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DbpJd4TlttID0l3bQ6gXNygoHh+Zdpn8YAWj7L1EOlo=;
        b=BYg9GVpBwzpZR6FB/bH5SXynbkwRnXSfI88QNwExTLw33760NKpRDdAhqh+RYBQskk
         /dpAFnw+PfDhE1zgt9C4LZUNVn4sWg9fn1rgjQsve/96eIje+/KfhtcDBPAX+imXagRD
         T+KYzxBQ1FyBnRkgZ4Cn3vOrwe4/TjofMcaQIofvSClLRjSBSBFkjwKwSNsfAYDDploZ
         FodN6wqCnyDIAL9YunbxGEEPJ7MhcQbd1yudK6GwTSBKZgHbOqFu6cQDIYRlPOSOxHob
         AvYLGsnBQzDDQZNymJ9F4If3fXkW11QLUWZYGc+4ciDppj0FNbZ4RCPbuuIc3WLxk6ts
         BtHA==
X-Gm-Message-State: AOJu0YyXJwNjM6X6j2GLiFmiZITNUJgjZnVbsgZQg3II3hVcyK+9GraE
        t6C3C0C32zM8oCmICHH5fEll5j4ocbfD4BP/dzdwA7EeCJyOkQ==
X-Google-Smtp-Source: AGHT+IE1KOxnoJ8Dtiuq6fGQ8Gz6dgvRl31PPpM1LU0cBGpeJzEJQRYPmrKH0hixzkxaFTqGaWwzDvHY5pgwL992Nts=
X-Received: by 2002:adf:edc2:0:b0:313:e391:e492 with SMTP id
 v2-20020adfedc2000000b00313e391e492mr4706951wro.17.1695305672878; Thu, 21 Sep
 2023 07:14:32 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Thu, 21 Sep 2023 22:14:21 +0800
Message-ID: <CAPm50aK-aODN8gbaxazqsNXwEciU1WdRom33h3zOnQLTBEKu1Q@mail.gmail.com>
Subject: [PATCH v2] KVM: x86: Use octal for file permission
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

Improve code readability and checkpatch warnings:
  WARNING: Symbolic permissions 'S_IRUGO' are not preferred. Consider
using octal permissions '0444'.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++----------
 arch/x86/kvm/x86.c     | 18 +++++++++---------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f283eb47f6ac..ee6542e8837a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -199,7 +199,7 @@ module_param_named(npt, npt_enabled, bool, 0444);

 /* allow nested virtualization in KVM/SVM */
 static int nested = true;
-module_param(nested, int, S_IRUGO);
+module_param(nested, int, 0444);

 /* enable/disable Next RIP Save */
 int nrips = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index af73d5d54ec8..c1e2d80377e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -82,28 +82,28 @@ bool __read_mostly enable_vpid = 1;
 module_param_named(vpid, enable_vpid, bool, 0444);

 static bool __read_mostly enable_vnmi = 1;
-module_param_named(vnmi, enable_vnmi, bool, S_IRUGO);
+module_param_named(vnmi, enable_vnmi, bool, 0444);

 bool __read_mostly flexpriority_enabled = 1;
-module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
+module_param_named(flexpriority, flexpriority_enabled, bool, 0444);

 bool __read_mostly enable_ept = 1;
-module_param_named(ept, enable_ept, bool, S_IRUGO);
+module_param_named(ept, enable_ept, bool, 0444);

 bool __read_mostly enable_unrestricted_guest = 1;
 module_param_named(unrestricted_guest,
-                       enable_unrestricted_guest, bool, S_IRUGO);
+                       enable_unrestricted_guest, bool, 0444);

 bool __read_mostly enable_ept_ad_bits = 1;
-module_param_named(eptad, enable_ept_ad_bits, bool, S_IRUGO);
+module_param_named(eptad, enable_ept_ad_bits, bool, 0444);

 static bool __read_mostly emulate_invalid_guest_state = true;
-module_param(emulate_invalid_guest_state, bool, S_IRUGO);
+module_param(emulate_invalid_guest_state, bool, 0444);

 static bool __read_mostly fasteoi = 1;
-module_param(fasteoi, bool, S_IRUGO);
+module_param(fasteoi, bool, 0444);

-module_param(enable_apicv, bool, S_IRUGO);
+module_param(enable_apicv, bool, 0444);

 bool __read_mostly enable_ipiv = true;
 module_param(enable_ipiv, bool, 0444);
@@ -114,10 +114,10 @@ module_param(enable_ipiv, bool, 0444);
  * use VMX instructions.
  */
 static bool __read_mostly nested = 1;
-module_param(nested, bool, S_IRUGO);
+module_param(nested, bool, 0444);

 bool __read_mostly enable_pml = 1;
-module_param_named(pml, enable_pml, bool, S_IRUGO);
+module_param_named(pml, enable_pml, bool, 0444);

 static bool __read_mostly error_on_inconsistent_vmcs_config = true;
 module_param(error_on_inconsistent_vmcs_config, bool, 0444);
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
