Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4B85A7251
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiHaARW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiHaARR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:17:17 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF229BB6F
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:17:14 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l16-20020a170902f69000b00175138bcd25so2411659plg.2
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=W7gWj5xWpB4Nm/5nHsnSYJ2NBkPvoSHoIvPmK8zyBD4=;
        b=apF5W0LbK7aSyoktgfKgInFInnrXWL9VjEodnG0XpZyi3607eiUgzGiRhJL5RM2TL9
         YfsoSbs4PRLUnHxX1xqwhkkjQN4wIqR44jXWqimODSYzoZFu0cD2TrssVikUiQHSLtDD
         vKck8No7qEHWQJrxZuQvcILCXEEuQJbDyGZ4W8dSpeXPyfKn3OO5ijY38+n4upa8E0bb
         cLeZyxI1mHAPNPTzQxKsnIzUs5USDf5oDx33hxvTgZhJe7vYPmuWu4m195TNztfGp5xG
         TkEXQenDtXrRDdlBfCP2DjcomChN7F7dHoH4AMxgqwHR2PwWnd1EOHRs3PGD0VtuoWej
         sq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=W7gWj5xWpB4Nm/5nHsnSYJ2NBkPvoSHoIvPmK8zyBD4=;
        b=KkiW56Ene/XLNzbvOrseqkSfbBpspLawA2QmS6edIvFKvsSuLwnxC0juiEk+NsptAh
         VkqShv45bqBMVMGc6ToQRnY53d3/2E1EsG//UXjBcHJFsE19Cg0/2EzU7JSFCQ33wyMY
         kskR6Slmk2jkIL7gGZ1KLOcZDG6SgBHnZ4CywhMF48xSQL4syQ1MSq780srwXk2xAy/N
         cnhGrLtfU3bX/81ZT2878n0r+qW85tyiDqkMETbUIonYkZnAjWI53RJ45twpeNAm9OPc
         WjuXkLAL49C/HrVU2lke/5i0lf/5ZbQi+yeM1g9VShujjGyLsXBsF8ZbM4ea9a606NQp
         2cag==
X-Gm-Message-State: ACgBeo37kPntw/YC02baG3lbFZrug2PRsKZOTA2r61A8k38zyAzMSuQD
        pHA5DTivsq9Bf0c4WpUSY5KFxTls2xU=
X-Google-Smtp-Source: AA6agR4sgrM+8MSFb94eBPFvXUY852S6/HICOlkjKy3bOT/hEkeGasAZ2SS/kAPgwNIf3Ik/7zxZ9sxDuko=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr22624pje.0.1661905033981; Tue, 30 Aug
 2022 17:17:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:17:06 +0000
In-Reply-To: <20220831001706.4075399-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831001706.4075399-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831001706.4075399-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: x86: Clean up KVM_CAP_X86_USER_SPACE_MSR documentation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>
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

Clean up the KVM_CAP_X86_USER_SPACE_MSR documentation to eliminate
misleading and/or inconsistent verbiage, and to actually document what
accesses are intercepted by which flags.

  - s/will/may since not all #GPs are guaranteed to be intercepted
  - s/deflect/intercept to align with common KVM terminology
  - s/user space/userspace to align with the majority of KVM docs
  - Avoid using "trap" terminology, as KVM exits to userspace _before_
    stepping, i.e. doesn't exhibit trap-like behavior
  - Actually document the flags

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 40 ++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 406d3e7c5a59..32d8fc8dcbb5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6431,29 +6431,29 @@ if it decides to decode and emulate the instruction.
 
 Used on x86 systems. When the VM capability KVM_CAP_X86_USER_SPACE_MSR is
 enabled, MSR accesses to registers that would invoke a #GP by KVM kernel code
-will instead trigger a KVM_EXIT_X86_RDMSR exit for reads and KVM_EXIT_X86_WRMSR
+may instead trigger a KVM_EXIT_X86_RDMSR exit for reads and KVM_EXIT_X86_WRMSR
 exit for writes.
 
-The "reason" field specifies why the MSR trap occurred. User space will only
-receive MSR exit traps when a particular reason was requested during through
+The "reason" field specifies why the MSR interception occurred. Userspace will
+only receive MSR exits when a particular reason was requested during through
 ENABLE_CAP. Currently valid exit reasons are:
 
 	KVM_MSR_EXIT_REASON_UNKNOWN - access to MSR that is unknown to KVM
 	KVM_MSR_EXIT_REASON_INVAL - access to invalid MSRs or reserved bits
 	KVM_MSR_EXIT_REASON_FILTER - access blocked by KVM_X86_SET_MSR_FILTER
 
-For KVM_EXIT_X86_RDMSR, the "index" field tells user space which MSR the guest
-wants to read. To respond to this request with a successful read, user space
+For KVM_EXIT_X86_RDMSR, the "index" field tells userspace which MSR the guest
+wants to read. To respond to this request with a successful read, userspace
 writes the respective data into the "data" field and must continue guest
 execution to ensure the read data is transferred into guest register state.
 
-If the RDMSR request was unsuccessful, user space indicates that with a "1" in
+If the RDMSR request was unsuccessful, userspace indicates that with a "1" in
 the "error" field. This will inject a #GP into the guest when the VCPU is
 executed again.
 
-For KVM_EXIT_X86_WRMSR, the "index" field tells user space which MSR the guest
-wants to write. Once finished processing the event, user space must continue
-vCPU execution. If the MSR write was unsuccessful, user space also sets the
+For KVM_EXIT_X86_WRMSR, the "index" field tells userspace which MSR the guest
+wants to write. Once finished processing the event, userspace must continue
+vCPU execution. If the MSR write was unsuccessful, userspace also sets the
 "error" field to "1".
 
 See KVM_X86_SET_MSR_FILTER for details on the interaction with MSR filtering.
@@ -7223,19 +7223,27 @@ the module parameter for the target VM.
 :Parameters: args[0] contains the mask of KVM_MSR_EXIT_REASON_* events to report
 :Returns: 0 on success; -1 on error
 
-This capability enables trapping of #GP invoking RDMSR and WRMSR instructions
-into user space.
+This capability allows userspace to intercept RDMSR and WRMSR instructions if
+access to an MSR is denied.  By default, KVM injects #GP on denied accesses.
 
 When a guest requests to read or write an MSR, KVM may not implement all MSRs
 that are relevant to a respective system. It also does not differentiate by
 CPU type.
 
-To allow more fine grained control over MSR handling, user space may enable
+To allow more fine grained control over MSR handling, userspace may enable
 this capability. With it enabled, MSR accesses that match the mask specified in
-args[0] and trigger a #GP event inside the guest by KVM will instead trigger
-KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR exit notifications which user space
-can then handle to implement model specific MSR handling and/or user notifications
-to inform a user that an MSR was not handled.
+args[0] and would trigger a #GP inside the guest will instead trigger
+KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR exit notifications.  Userspace
+can then implement model specific MSR handling and/or user notifications
+to inform a user that an MSR was not emulated/virtualized by KVM.
+
+The valid mask flags are:
+
+	KVM_MSR_EXIT_REASON_UNKNOWN - intercept accesses to unknown (to KVM) MSRs
+	KVM_MSR_EXIT_REASON_INVAL   - intercept accesses that are architecturally
+                                invalid according to the vCPU model and/or mode
+	KVM_MSR_EXIT_REASON_FILTER  - intercept accesses that are denied by userspace
+                                via KVM_X86_SET_MSR_FILTER
 
 7.22 KVM_CAP_X86_BUS_LOCK_EXIT
 -------------------------------
-- 
2.37.2.672.g94769d06f0-goog

