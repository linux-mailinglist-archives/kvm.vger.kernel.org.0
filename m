Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7EB56C6AD
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiGIEVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiGIEVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:20 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E054E62D;
        Fri,  8 Jul 2022 21:21:18 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id bf13so502424pgb.11;
        Fri, 08 Jul 2022 21:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/tviZ2LRFnFmh3Cs62ruUhDOZv+z4gBr/FE1h1tyxLU=;
        b=mOxcJUxnainQ5bKetB7G+ZJ6+yIcH8PCSKOG7/pJRAT2G3Ow5x3deGS0MPZF+0hWZR
         jclwFl0XjL98iS6PbKJT/okl683m2Ik1SeV1L72lXI7TvaF10IDxSAfkM96Zvkoh0bdw
         6p5mtSs0n9tjePKexVMclXVAhHf3Iy2eHIvdhGtEPRWEBdr9FdDCHHDiZXTyYsz9t7Am
         40Y2HzF8vRjeboVTU8IiV2SpGMxFEDQgga+AgKgp+Nw8n0a9VP3qy22BsanFR9soY5BT
         9pVoUHQD8ICrQM7dIerO44Ms3ZO31PdU7vc25gez6/+trOcT+6ASZlbCpjU2NyYFsslg
         LuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/tviZ2LRFnFmh3Cs62ruUhDOZv+z4gBr/FE1h1tyxLU=;
        b=TrLOsU9CGtHYU4Fy/q8FRHBqHlB0dBIWRliiOU8gWjmW2Ixm/AOp27goVP/+AO+DGc
         NN0R2+VJfJgS2qEYYzGKTUu+NxhsYeJMJmlIOBKSa7ONRpc4DV+KZEzj3LeXK5U/EYrX
         W87O/5du/Yw/6y7kdbQspXaCFBJ/ABlWj9nrg8Y33FVlPj2ZOt0uKhUicvihq1ebSUc7
         Y88p7mIBViLMsK2HqL2sDWnZ5bKNV/WzcAs7H63nLmq4qxQz1Z1FMmiuqj481hXAosKU
         YRUM8aWSVgZWWFySHwq+r3NrUZC9SKVkhQFsFfOe1aURvOp+cXC4sc8ZlhMuhHJzWcVp
         qIdg==
X-Gm-Message-State: AJIora+hoxR6J7D8CaDuD9r3bwlaq4p6sWMXVeZ8AFJ6MMNQCgHte70K
        R3yxdH4GLcU0up+JVqmns6M=
X-Google-Smtp-Source: AGRyM1vTTVe4PNr9mzzGhFXCNTP1sr972UzfMOiMjPjlkQxhWgVC7KrxtdGf1V+0K3oJfU0UeS1kvQ==
X-Received: by 2002:a05:6a00:1349:b0:527:f7a2:b3e9 with SMTP id k9-20020a056a00134900b00527f7a2b3e9mr6995272pfu.45.1657340478069;
        Fri, 08 Jul 2022 21:21:18 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id gl19-20020a17090b121300b001f0097c2fb2sm244073pjb.28.2022.07.08.21.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 3E2D410394E; Sat,  9 Jul 2022 11:21:10 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 01/12] Documentation: kvm: Pad bullet lists with blank line
Date:   Sat,  9 Jul 2022 11:20:27 +0700
Message-Id: <20220709042037.21903-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220709042037.21903-1-bagasdotme@gmail.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are many "unexpected indentation" warnings due to missing blank line
padding surrounding bullet lists.

One of these are reported by kernel test robot:

Documentation/virt/kvm/intel-tdx.rst:181: WARNING: Enumerated list ends without a blank line; unexpected unindent.

Add the paddings. While at it, align TDX control flow list.

Link: https://lore.kernel.org/linux-doc/202207050428.5xG5lJOv-lkp@intel.com/
Fixes: 9e54fa1ac03df3 ("Documentation/virtual/kvm: Document on Trust Domain Extensions(TDX)")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/intel-tdx.rst | 75 ++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx.rst b/Documentation/virt/kvm/intel-tdx.rst
index 3fae2cf9e5341d..46ad32f3248e40 100644
--- a/Documentation/virt/kvm/intel-tdx.rst
+++ b/Documentation/virt/kvm/intel-tdx.rst
@@ -178,26 +178,30 @@ In addition to KVM normal flow, new TDX ioctls need to be called.  The control f
 looks like as follows.
 
 #. system wide capability check
-  * KVM_CAP_VM_TYPES: check if VM type is supported and if TDX_VM_TYPE is
-    supported.
+
+   * KVM_CAP_VM_TYPES: check if VM type is supported and if TDX_VM_TYPE is
+     supported.
 
 #. creating VM
-  * KVM_CREATE_VM
-  * KVM_TDX_CAPABILITIES: query if TDX is supported on the platform.
-  * KVM_TDX_INIT_VM: pass TDX specific VM parameters.
+
+   * KVM_CREATE_VM
+   * KVM_TDX_CAPABILITIES: query if TDX is supported on the platform.
+   * KVM_TDX_INIT_VM: pass TDX specific VM parameters.
 
 #. creating VCPU
-  * KVM_CREATE_VCPU
-  * KVM_TDX_INIT_VCPU: pass TDX specific VCPU parameters.
+
+   * KVM_CREATE_VCPU
+   * KVM_TDX_INIT_VCPU: pass TDX specific VCPU parameters.
 
 #. initializing guest memory
-  * allocate guest memory and initialize page same to normal KVM case
-    In TDX case, parse and load TDVF into guest memory in addition.
-  * KVM_TDX_INIT_MEM_REGION to add and measure guest pages.
-    If the pages has contents above, those pages need to be added.
-    Otherwise the contents will be lost and guest sees zero pages.
-  * KVM_TDX_FINALIAZE_VM: Finalize VM and measurement
-    This must be after KVM_TDX_INIT_MEM_REGION.
+
+   * allocate guest memory and initialize page same to normal KVM case
+     In TDX case, parse and load TDVF into guest memory in addition.
+   * KVM_TDX_INIT_MEM_REGION to add and measure guest pages.
+     If the pages has contents above, those pages need to be added.
+     Otherwise the contents will be lost and guest sees zero pages.
+   * KVM_TDX_FINALIAZE_VM: Finalize VM and measurement
+     This must be after KVM_TDX_INIT_MEM_REGION.
 
 #. run vcpu
 
@@ -225,41 +229,58 @@ Several points to be considered.
     a centralized file is acceptable.
 
 - Wrapping kvm x86_ops: The current choice
+
   Introduce dedicated file for arch/x86/kvm/vmx/main.c (the name,
   main.c, is just chosen to show main entry points for callbacks.) and
   wrapper functions around all the callbacks with
   "if (is-tdx) tdx-callback() else vmx-callback()".
 
   Pros:
+
   - No major change in common x86 KVM code. The change is (mostly)
     contained under arch/x86/kvm/vmx/.
   - When TDX is disabled(CONFIG_INTEL_TDX_HOST=n), the overhead is
     optimized out.
   - Micro optimization by avoiding function pointer.
+
   Cons:
+
   - Many boiler plates in arch/x86/kvm/vmx/main.c.
 
 Alternative:
+
 - Introduce another callback layer under arch/x86/kvm/vmx.
+
   Pros:
+
   - No major change in common x86 KVM code. The change is (mostly)
     contained under arch/x86/kvm/vmx/.
   - clear separation on callbacks.
+
   Cons:
+
   - overhead in VMX even when TDX is disabled(CONFIG_INTEL_TDX_HOST=n).
 
 - Allow per-VM kvm_x86_ops callbacks instead of global kvm_x86_ops
+
   Pros:
+
   - clear separation on callbacks.
+
   Cons:
+
   - Big change in common x86 code.
   - overhead in common code even when TDX is
     disabled(CONFIG_INTEL_TDX_HOST=n).
 
 - Introduce new directory arch/x86/kvm/tdx
+
   Pros:
+
   - It clarifies that TDX is different from VMX.
+
   Cons:
+
   - Given the level of code sharing, it complicates code sharing.
 
 KVM MMU Changes
@@ -291,26 +312,38 @@ with host(if set to 1) or private to TD(if cleared to 0).
     = 51 or 47 bit set for TDX case.
 
   Pros:
+
   - Large code reuse with minimal new hooks.
   - Execution path is same.
+
   Cons:
+
   - Complicates the existing code.
   - Repurpose kvm_mmu_page as shadow of Secure-EPT can be confusing.
 
 Alternative:
+
 - Replace direct read/write on EPT entry with TDX-SEAM call by
   introducing callbacks on EPT entry.
+
   Pros:
+
   - Straightforward.
+
   Cons:
+
   - Too many touching point.
   - Too slow due to TDX-SEAM call.
   - Overhead even when TDX is disabled(CONFIG_INTEL_TDX_HOST=n).
 
 - Sprinkle "if (is-tdx)" for TDX special case
+
   Pros:
+
   - Straightforward.
+
   Cons:
+
   - The result is non-generic and ugly.
   - Put TDX specific logic into common KVM MMU code.
 
@@ -320,20 +353,30 @@ Additional KVM API are needed to control TD VMs. The operations on TD
 VMs are specific to TDX.
 
 - Piggyback and repurpose KVM_MEMORY_ENCRYPT_OP
+
   Although not all operation isn't memory encryption, repupose to get
   TDX specific ioctls.
+
   Pros:
+
   - No major change in common x86 KVM code.
+
   Cons:
+
   - The operations aren't actually memory encryption, but operations
     on TD VMs.
 
 Alternative:
+
 - Introduce new ioctl for guest protection like
   KVM_GUEST_PROTECTION_OP and introduce subcommand for TDX.
+
   Pros:
+
   - Clean name.
+
   Cons:
+
   - One more new ioctl for guest protection.
   - Confusion with KVM_MEMORY_ENCRYPT_OP with KVM_GUEST_PROTECTION_OP.
 
@@ -341,9 +384,13 @@ Alternative:
   KVM_MEMORY_ENCRYPT_OP as same value for user API for compatibility.
   "#define KVM_MEMORY_ENCRYPT_OP KVM_GUEST_PROTECTION_OP" for uapi
   compatibility.
+
   Pros:
+
   - No new ioctl with more suitable name.
+
   Cons:
+
   - May cause confusion to the existing user program.
 
 
-- 
An old man doll... just what I always wanted! - Clara

