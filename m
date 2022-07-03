Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EE956497C
	for <lists+kvm@lfdr.de>; Sun,  3 Jul 2022 21:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiGCTQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jul 2022 15:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiGCTQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jul 2022 15:16:47 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF0A617F
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 12:16:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id i15-20020a17090a2a0f00b001ef826b921dso1116071pjd.5
        for <kvm@vger.kernel.org>; Sun, 03 Jul 2022 12:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GSHTLT4m8ohADBBAUekmRLG4su/WuVT4c1OmBkMAma0=;
        b=JMa9NTQE5GV9nNfuInPdv9m5U+Kam3CEQ4y2fZOmRFTqosAeuN4NZXs6qnzv9N/SkI
         wg5+fA9DIX+lcX2HpgOBJC3Fu/jcVglqKt5omo37gKBXf0g3cV+sp0zkA2F+AmW8a3gc
         103Na0C58ts5c97EZUqv3Lk9tKBrmdXLCjLyAAvsCbdtBsalczf11FBhB1T8VKEt3sDy
         sRAaNrkvlGlxJre3dyB1HtWZdW/BGInM4Q/B75ypJuIcKXbFUI4rpzVRUPvFRSw+y4NC
         yi5mMsifFqBRd2f6jignP3aA8s1qNsFuHWK0yjCbfhAvMEZvfMI52ma+sK9yVrhL3j+A
         b9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GSHTLT4m8ohADBBAUekmRLG4su/WuVT4c1OmBkMAma0=;
        b=jGpJ6ZbZc8SOfv9tjuiZIHZqABQHp81n3tZ/2Ocs0llYIijtHYHoirYhXiFspTN1fE
         zVMEjCmWLM5ZG3Fh+33joF8jgZDNQdwpLGlSSH/ElMi8X1V6kKJEzT7Xo0w2CkpAAaFK
         eZwEDgHjJt/tLLmp3SQ6d8jfBs8eUAfHNnE0KqXjM8h9nt/6oyN2AhfmVz4zQXbYE8v1
         sffQZykjF5g0uGW578Y1OXMtaXpB85VpzLhltqO+TbUyX1EVofkEO7h1iommoYmhj3k4
         A/D6EImwbMyz7Ou73Gy4aHDBaW8aKbHG5UEIxruqNx11jDM2CKaB9lgVJa9Cc+0umkwH
         V7ig==
X-Gm-Message-State: AJIora8n9A2xfoq7R7vgxU6KWyzJ/xQp92woYXT9JcBFAeZeOt91ovpw
        NwEVtIIf3ONV5RUv6wScAG+EuQ7pj+U4kxIuOsKBhhCdWycoNmf3asUKj4ij0Uxzat9cf7XNDOE
        Je2qByqRDazb2wFZmQKW1qIXxNAjU24pPmMTYJSwJzqAoPvvdNwhohK8yWXYX2BSq/QIz
X-Google-Smtp-Source: AGRyM1tC1UANe4dpHELWnnWfnHzRWvnf1Q3vwveRdrT7xZgkwHMoCbDRT5V8DiYxpYOPmdX7lAYT2qGMC8Kv6xwi
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP
 id t9-20020a17090a024900b001e0a8a33c6cmr731004pje.0.1656875805223; Sun, 03
 Jul 2022 12:16:45 -0700 (PDT)
Date:   Sun,  3 Jul 2022 19:16:34 +0000
In-Reply-To: <20220703191636.2159067-1-aaronlewis@google.com>
Message-Id: <20220703191636.2159067-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220703191636.2159067-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 1/3] KVM: x86: fix documentation for KVM_X86_SET_MSR_FILTER
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
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

Two copies of KVM_X86_SET_MSR_FILTER somehow managed to make it's way
into the documentation.  Remove one copy and merge the difference from
the removed copy into the copy that's being kept.

Fixes: fd49e8ee70b3 ("Merge branch 'kvm-sev-cgroup' into HEAD")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst | 115 +++------------------------------
 1 file changed, 8 insertions(+), 107 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bafaeedd455c..5c651a4e4e2c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4074,7 +4074,7 @@ Queues an SMI on the thread's vcpu.
 4.97 KVM_X86_SET_MSR_FILTER
 ----------------------------
 
-:Capability: KVM_X86_SET_MSR_FILTER
+:Capability: KVM_CAP_X86_MSR_FILTER
 :Architectures: x86
 :Type: vm ioctl
 :Parameters: struct kvm_msr_filter
@@ -4173,8 +4173,12 @@ If an MSR access is not permitted through the filtering, it generates a
 allows user space to deflect and potentially handle various MSR accesses
 into user space.
 
-If a vCPU is in running state while this ioctl is invoked, the vCPU may
-experience inconsistent filtering behavior on MSR accesses.
+Note, invoking this ioctl while a vCPU is running is inherently racy.  However,
+KVM does guarantee that vCPUs will see either the previous filter or the new
+filter, e.g. MSRs with identical settings in both the old and new filter will
+have deterministic behavior.
+
+
 
 4.98 KVM_CREATE_SPAPR_TCE_64
 ----------------------------
@@ -5287,110 +5291,7 @@ KVM_PV_DUMP
     authentication tag all of which are needed to decrypt the dump at a
     later time.
 
-
-4.126 KVM_X86_SET_MSR_FILTER
-----------------------------
-
-:Capability: KVM_CAP_X86_MSR_FILTER
-:Architectures: x86
-:Type: vm ioctl
-:Parameters: struct kvm_msr_filter
-:Returns: 0 on success, < 0 on error
-
-::
-
-  struct kvm_msr_filter_range {
-  #define KVM_MSR_FILTER_READ  (1 << 0)
-  #define KVM_MSR_FILTER_WRITE (1 << 1)
-	__u32 flags;
-	__u32 nmsrs; /* number of msrs in bitmap */
-	__u32 base;  /* MSR index the bitmap starts at */
-	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
-  };
-
-  #define KVM_MSR_FILTER_MAX_RANGES 16
-  struct kvm_msr_filter {
-  #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
-  #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
-	__u32 flags;
-	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
-  };
-
-flags values for ``struct kvm_msr_filter_range``:
-
-``KVM_MSR_FILTER_READ``
-
-  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
-  indicates that a read should immediately fail, while a 1 indicates that
-  a read for a particular MSR should be handled regardless of the default
-  filter action.
-
-``KVM_MSR_FILTER_WRITE``
-
-  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
-  indicates that a write should immediately fail, while a 1 indicates that
-  a write for a particular MSR should be handled regardless of the default
-  filter action.
-
-``KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE``
-
-  Filter both read and write accesses to MSRs using the given bitmap. A 0
-  in the bitmap indicates that both reads and writes should immediately fail,
-  while a 1 indicates that reads and writes for a particular MSR are not
-  filtered by this range.
-
-flags values for ``struct kvm_msr_filter``:
-
-``KVM_MSR_FILTER_DEFAULT_ALLOW``
-
-  If no filter range matches an MSR index that is getting accessed, KVM will
-  fall back to allowing access to the MSR.
-
-``KVM_MSR_FILTER_DEFAULT_DENY``
-
-  If no filter range matches an MSR index that is getting accessed, KVM will
-  fall back to rejecting access to the MSR. In this mode, all MSRs that should
-  be processed by KVM need to explicitly be marked as allowed in the bitmaps.
-
-This ioctl allows user space to define up to 16 bitmaps of MSR ranges to
-specify whether a certain MSR access should be explicitly filtered for or not.
-
-If this ioctl has never been invoked, MSR accesses are not guarded and the
-default KVM in-kernel emulation behavior is fully preserved.
-
-Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
-filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
-an error.
-
-As soon as the filtering is in place, every MSR access is processed through
-the filtering except for accesses to the x2APIC MSRs (from 0x800 to 0x8ff);
-x2APIC MSRs are always allowed, independent of the ``default_allow`` setting,
-and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
-register.
-
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
-
-Note, invoking this ioctl with a vCPU is running is inherently racy.  However,
-KVM does guarantee that vCPUs will see either the previous filter or the new
-filter, e.g. MSRs with identical settings in both the old and new filter will
-have deterministic behavior.
-
-4.127 KVM_XEN_HVM_SET_ATTR
+4.126 KVM_XEN_HVM_SET_ATTR
 --------------------------
 
 :Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
-- 
2.37.0.rc0.161.g10f37bed90-goog

