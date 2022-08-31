Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199A25A724E
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiHaARS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiHaARO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:17:14 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07958E981
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:17:12 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j192-20020a638bc9000000b0042b23090b15so6143671pge.16
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=+UhUav71IHkHVS0l68G2lkMfAPfOIqmgtEZJBpH9AZc=;
        b=HP/0rsFZnflZDXG1R5cx1U0gumyLVjMwxQhQL0A/ZhFrp2Zw8LKPhEh3OXxgjUnjCp
         KPuxSUcv8C6di/MhcgOJrPqBP8uYXcTsf7MirrhkUuKf61uxEB3hLy5JLWRh1W8XLF/z
         t+ymNrNGoaaTnt+JT3xwJ7DmnAFjyo3P+Z5SRXIgffOzL7mcacIXKcuc2Vug6kgAMbvI
         9c/vJ1pilqbhMaEEEGLhMZ4C9s41oz3hDVQdM20PpezgaWKnTiF7oc/IKAChUzw07DU5
         yr/2NuVPp9AdNZRt+ANXxH2y4Y9Zd8QhMLtHZicj5RgedDTOvZk04Btx7fNxhnjD50DG
         YK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=+UhUav71IHkHVS0l68G2lkMfAPfOIqmgtEZJBpH9AZc=;
        b=hnACi2cFD5Dn0MtPuBpmiSWSYiotkzIo2pH4Zn6aHB+//2mxAVEu6sUQ2UYfz2d9Ic
         YNkGyVhRv/40Mu2uvG2YP1xknfyLngVLgx8iNc1ecXVN84Zuk4M0gdVj6bqkPE7xOzYg
         Gh5riSVyY5h1pcnQeTm0slJJ9PV1JHUqQeesJoYoZRu2N4jDyFwrQGJhs9S1hPPui5/E
         OlClEQBnzHS0LtRSwsEN4L4JYDPNXRDmJUk+FKoaDFwwemq7mDazZoi48/53+5GFCL5W
         +kEYwaSTSisSnW4jA0spQA20LP2Y4DJj4emIArBI7nxsCiAujwrYKKTzxHrvwNE5w6Cb
         n5Ng==
X-Gm-Message-State: ACgBeo1QZXSGolLHY/54tRy+beQ9cHdVw5AOVwg5l7KQWVOWeW6vOYTR
        Sv+ntDnIZ4EWvSDJNcb8fPXcU/e0BRg=
X-Google-Smtp-Source: AA6agR5c0EWj2QqmcLPItfuuV4KnwD5L/QzELwz4iIp2j55iFsJguwtY/O7CwMOVry9JM4+hj5Yuw5mRkmo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2341:b0:538:2fca:4759 with SMTP id
 j1-20020a056a00234100b005382fca4759mr12593103pfj.28.1661905032375; Tue, 30
 Aug 2022 17:17:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:17:05 +0000
In-Reply-To: <20220831001706.4075399-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831001706.4075399-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831001706.4075399-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86: Reword MSR filtering docs to more precisely
 define behavior
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

Reword the MSR filtering documentatiion to more precisely define the
behavior of filtering using common virtualization terminology.

  - Explicitly document KVM's behavior when an MSR is denied
  - s/handled/allowed as there is no guarantee KVM will "handle" the
    MSR access
  - Drop the "fall back" terminology, which incorrectly suggests that
    there is existing KVM behavior to fall back to
  - Fix an off-by-one error in the range (the end is exclusive)
  - Call out the interaction between MSR filtering and
    KVM_CAP_X86_USER_SPACE_MSR's KVM_MSR_EXIT_REASON_FILTER
  - Delete the redundant paragraph on what '0' and '1' in the bitmap
    means, it's covered by the sections on KVM_MSR_FILTER_{READ,WRITE}
  - Delete the clause on x2APIC MSR behavior depending on APIC base, this
    is covered by stating that KVM follows architectural behavior when
    emulating/virtualizing MSR accesses

Reported-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 70 +++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5148b431ed13..406d3e7c5a59 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4104,15 +4104,15 @@ flags values for ``struct kvm_msr_filter_range``:
 ``KVM_MSR_FILTER_READ``
 
   Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
-  indicates that a read should immediately fail, while a 1 indicates that
-  a read for a particular MSR should be handled regardless of the default
+  indicates that read accesses should be denied, while a 1 indicates that
+  a read for a particular MSR should be allowed regardless of the default
   filter action.
 
 ``KVM_MSR_FILTER_WRITE``
 
   Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
-  indicates that a write should immediately fail, while a 1 indicates that
-  a write for a particular MSR should be handled regardless of the default
+  indicates that write accesses should be denied, while a 1 indicates that
+  a write for a particular MSR should be allowed regardless of the default
   filter action.
 
 flags values for ``struct kvm_msr_filter``:
@@ -4120,57 +4120,55 @@ flags values for ``struct kvm_msr_filter``:
 ``KVM_MSR_FILTER_DEFAULT_ALLOW``
 
   If no filter range matches an MSR index that is getting accessed, KVM will
-  fall back to allowing access to the MSR.
+  allow accesses to all MSRs by default.
 
 ``KVM_MSR_FILTER_DEFAULT_DENY``
 
   If no filter range matches an MSR index that is getting accessed, KVM will
-  fall back to rejecting access to the MSR. In this mode, all MSRs that should
-  be processed by KVM need to explicitly be marked as allowed in the bitmaps.
+  deny accesses to all MSRs by default.
 
-This ioctl allows user space to define up to 16 bitmaps of MSR ranges to
-specify whether a certain MSR access should be explicitly filtered for or not.
+This ioctl allows userspace to define up to 16 bitmaps of MSR ranges to deny
+guest MSR accesses that would normally be allowed by KVM.  If an MSR is not
+covered by a specific range, the "default" filtering behavior applies.  Each
+bitmap range covers MSRs from [base .. base+nmsrs).
 
-If this ioctl has never been invoked, MSR accesses are not guarded and the
-default KVM in-kernel emulation behavior is fully preserved.
+If an MSR access is denied by userspace, the resulting KVM behavior depends on
+whether or not KVM_CAP_X86_USER_SPACE_MSR's KVM_MSR_EXIT_REASON_FILTER is
+enabled.  If KVM_MSR_EXIT_REASON_FILTER is enabled, KVM will exit to userspace
+on denied accesses, i.e. userspace effectively intercepts the MSR access.  If
+KVM_MSR_EXIT_REASON_FILTER is not enabled, KVM will inject a #GP into the guest
+on denied accesses.
+
+If an MSR access is allowed by userspace, KVM will emulate and/or virtualize
+the access in accordance with the vCPU model.  Note, KVM may still ultimately
+inject a #GP if an access is allowed by userspace, e.g. if KVM doesn't support
+the MSR, or to follow architectural behavior for the MSR.
+
+By default, KVM operates in KVM_MSR_FILTER_DEFAULT_ALLOW mode with no MSR range
+filters.
 
 Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
 filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
 an error.
 
-As soon as the filtering is in place, every MSR access is processed through
-the filtering except for accesses to the x2APIC MSRs (from 0x800 to 0x8ff);
-x2APIC MSRs are always allowed, independent of the ``default_allow`` setting,
-and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
-register.
-
 .. warning::
-   MSR accesses coming from nested vmentry/vmexit are not filtered.
+   MSR accesses as part of nested VM-Enter/VM-Exit are not filtered.
    This includes both writes to individual VMCS fields and reads/writes
    through the MSR lists pointed to by the VMCS.
 
-If a bit is within one of the defined ranges, read and write accesses are
-guarded by the bitmap's value for the MSR index if the kind of access
-is included in the ``struct kvm_msr_filter_range`` flags.  If no range
-cover this particular access, the behavior is determined by the flags
-field in the kvm_msr_filter struct: ``KVM_MSR_FILTER_DEFAULT_ALLOW``
-and ``KVM_MSR_FILTER_DEFAULT_DENY``.
-
-Each bitmap range specifies a range of MSRs to potentially allow access on.
-The range goes from MSR index [base .. base+nmsrs]. The flags field
-indicates whether reads, writes or both reads and writes are filtered
-by setting a 1 bit in the bitmap for the corresponding MSR index.
-
-If an MSR access is not permitted through the filtering, it generates a
-#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
-allows user space to deflect and potentially handle various MSR accesses
-into user space.
+   x2APIC MSR accesses cannot be filtered (KVM silently ignores filters that
+   cover any x2APIC MSRs).
 
 Note, invoking this ioctl while a vCPU is running is inherently racy.  However,
 KVM does guarantee that vCPUs will see either the previous filter or the new
 filter, e.g. MSRs with identical settings in both the old and new filter will
 have deterministic behavior.
 
+Similarly, if userspace wishes to intercept on denied accesses,
+KVM_MSR_EXIT_REASON_FILTER must be enabled before activating any filters, and
+left enabled until after all filters are deactivated.  Failure to do so may
+result in KVM injecting a #GP instead of exiting to userspace.
+
 4.98 KVM_CREATE_SPAPR_TCE_64
 ----------------------------
 
@@ -6458,6 +6456,8 @@ wants to write. Once finished processing the event, user space must continue
 vCPU execution. If the MSR write was unsuccessful, user space also sets the
 "error" field to "1".
 
+See KVM_X86_SET_MSR_FILTER for details on the interaction with MSR filtering.
+
 ::
 
 
@@ -7895,7 +7895,7 @@ KVM_EXIT_X86_WRMSR exit notifications.
 This capability indicates that KVM supports that accesses to user defined MSRs
 may be rejected. With this capability exposed, KVM exports new VM ioctl
 KVM_X86_SET_MSR_FILTER which user space can call to specify bitmaps of MSR
-ranges that KVM should reject access to.
+ranges that KVM should deny access to.
 
 In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space to
 trap and emulate MSRs that are outside of the scope of KVM as well as
-- 
2.37.2.672.g94769d06f0-goog

