Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD354E3D2B
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 12:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiCVLIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 07:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbiCVLIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 07:08:45 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2998A80211;
        Tue, 22 Mar 2022 04:07:18 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id r190-20020a1c2bc7000000b0038a1013241dso1280309wmr.1;
        Tue, 22 Mar 2022 04:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qSUlhzlA1s0q6/uoUd3jdsktSfPe0Uq9dHq53cc4Gxg=;
        b=XA5jZz1m1fVkCv5KbXNRwidDsuCEqJojKTKiXtRcF1KsBPZ35mI1Q5etGXwyot4QYY
         zz6jtCy+SkoH91ciK+DPJi/vNajDBnGKBxMCBXl6so9uvwulI0uLsyzTYDnjxfPEhw+k
         3N/41iPSEEIC8DYAHOlvvHhACLCRpd4Q7veAK24AEE9jH+8dXd7ZaoYsFfLPXZ2g2grU
         xkVIKK/Y9jo4ZEOxuvvbnYf29+zp+3G2lnAVqWQHH1q9aZ86NkNmHEzzmN9HRUVAyTPM
         nmwa8DROBpAa+wlTUGMtMaekvqRS8SEmb6VzluOA4sN5mteRVNx6/hndxpbz5R5ADwRY
         pEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=qSUlhzlA1s0q6/uoUd3jdsktSfPe0Uq9dHq53cc4Gxg=;
        b=dqoQA8w4OWJPNDVqCfnIeyf6xDDXLE+9VaNBd4OvpkGMM06vwmK+RFYyjG7sDdZho0
         DsFcXcXYDSFSc9T9/0AfpW/0t9148c2P54rG+j6SVRLCmdLs0hgdDhhmpeR3rrytgZ12
         udzhr2jfXYMdTetrSbvWwSI3ut7/0ZxieCzfRRFEnyVJsfAo/TcCuOVK+nQV1klKTkFB
         ejZL8XMQG3cvPO7pQA8kwO+V/Ck4G04An8GVy6upFYclZnxqxxw8FQ6h5dJspVFHxnOf
         FkpGF35kYTL1pXwuxRXB7zEXl/23UqK0t7DCe1E3mbRpQ3mnlSsuRaBI2UctUBqwz3bz
         771A==
X-Gm-Message-State: AOAM532Gen4gta0rQ2iN2bN+Ang08DPpmAKAtlyCytGKcP7v7fJZXHLv
        29SINH5RpLfv2VGh3oJOzfx/HLsmbBE=
X-Google-Smtp-Source: ABdhPJwaj6eNRUFaM56E9G8HghIEbHssoHxrDMcjFvbAA1Skt9pig7VM8osSqap4IDWGBhTzsCJH9A==
X-Received: by 2002:a7b:c0ca:0:b0:38c:b9a9:a64d with SMTP id s10-20020a7bc0ca000000b0038cb9a9a64dmr2114497wmh.195.1647947236585;
        Tue, 22 Mar 2022 04:07:16 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b0038c949ef0d5sm1746379wmq.8.2022.03.22.04.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:07:16 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, jmattson@google.com
Subject: [PATCH 1/3] Documentation: KVM: add separate directories for architecture-specific documentation
Date:   Tue, 22 Mar 2022 12:07:10 +0100
Message-Id: <20220322110712.222449-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220322110712.222449-1-pbonzini@redhat.com>
References: <20220322110712.222449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARM already has an arm/ subdirectory, but s390 and x86 do not even though
they have a relatively large number of files specific to them.  Create
new directories in Documentation/virt/kvm for these two architectures
as well.

While at it, group the API documentation and the developer documentation
in the table of contents.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/index.rst              | 28 ++++++-------------
 Documentation/virt/kvm/s390/index.rst         | 12 ++++++++
 .../virt/kvm/{ => s390}/s390-diag.rst         |  0
 .../virt/kvm/{ => s390}/s390-pv-boot.rst      |  0
 Documentation/virt/kvm/{ => s390}/s390-pv.rst |  0
 .../kvm/{ => x86}/amd-memory-encryption.rst   |  0
 Documentation/virt/kvm/{ => x86}/cpuid.rst    |  0
 .../virt/kvm/{ => x86}/halt-polling.rst       |  0
 .../virt/kvm/{ => x86}/hypercalls.rst         |  0
 Documentation/virt/kvm/x86/index.rst          | 18 ++++++++++++
 Documentation/virt/kvm/{ => x86}/mmu.rst      |  0
 Documentation/virt/kvm/{ => x86}/msr.rst      |  0
 .../virt/kvm/{ => x86}/nested-vmx.rst         |  0
 .../kvm/{ => x86}/running-nested-guests.rst   |  0
 .../virt/kvm/{ => x86}/timekeeping.rst        |  0
 15 files changed, 38 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390/index.rst
 rename Documentation/virt/kvm/{ => s390}/s390-diag.rst (100%)
 rename Documentation/virt/kvm/{ => s390}/s390-pv-boot.rst (100%)
 rename Documentation/virt/kvm/{ => s390}/s390-pv.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/amd-memory-encryption.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/cpuid.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/halt-polling.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/hypercalls.rst (100%)
 create mode 100644 Documentation/virt/kvm/x86/index.rst
 rename Documentation/virt/kvm/{ => x86}/mmu.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/msr.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/nested-vmx.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/running-nested-guests.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/timekeeping.rst (100%)

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index b6833c7bb474..e0a2c74e1043 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -8,25 +8,13 @@ KVM
    :maxdepth: 2
 
    api
-   amd-memory-encryption
-   cpuid
-   halt-polling
-   hypercalls
-   locking
-   mmu
-   msr
-   nested-vmx
-   ppc-pv
-   s390-diag
-   s390-pv
-   s390-pv-boot
-   timekeeping
-   vcpu-requests
-
-   review-checklist
-
-   arm/index
-
    devices/index
 
-   running-nested-guests
+   arm/index
+   s390/index
+   ppc-pv
+   x86/index
+
+   locking
+   vcpu-requests
+   review-checklist
diff --git a/Documentation/virt/kvm/s390/index.rst b/Documentation/virt/kvm/s390/index.rst
new file mode 100644
index 000000000000..605f488f0cc5
--- /dev/null
+++ b/Documentation/virt/kvm/s390/index.rst
@@ -0,0 +1,12 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+KVM for s390 systems
+====================
+
+.. toctree::
+   :maxdepth: 2
+
+   s390-diag
+   s390-pv
+   s390-pv-boot
diff --git a/Documentation/virt/kvm/s390-diag.rst b/Documentation/virt/kvm/s390/s390-diag.rst
similarity index 100%
rename from Documentation/virt/kvm/s390-diag.rst
rename to Documentation/virt/kvm/s390/s390-diag.rst
diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390/s390-pv-boot.rst
similarity index 100%
rename from Documentation/virt/kvm/s390-pv-boot.rst
rename to Documentation/virt/kvm/s390/s390-pv-boot.rst
diff --git a/Documentation/virt/kvm/s390-pv.rst b/Documentation/virt/kvm/s390/s390-pv.rst
similarity index 100%
rename from Documentation/virt/kvm/s390-pv.rst
rename to Documentation/virt/kvm/s390/s390-pv.rst
diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
similarity index 100%
rename from Documentation/virt/kvm/amd-memory-encryption.rst
rename to Documentation/virt/kvm/x86/amd-memory-encryption.rst
diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/x86/cpuid.rst
similarity index 100%
rename from Documentation/virt/kvm/cpuid.rst
rename to Documentation/virt/kvm/x86/cpuid.rst
diff --git a/Documentation/virt/kvm/halt-polling.rst b/Documentation/virt/kvm/x86/halt-polling.rst
similarity index 100%
rename from Documentation/virt/kvm/halt-polling.rst
rename to Documentation/virt/kvm/x86/halt-polling.rst
diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/x86/hypercalls.rst
similarity index 100%
rename from Documentation/virt/kvm/hypercalls.rst
rename to Documentation/virt/kvm/x86/hypercalls.rst
diff --git a/Documentation/virt/kvm/x86/index.rst b/Documentation/virt/kvm/x86/index.rst
new file mode 100644
index 000000000000..55ede8e070b6
--- /dev/null
+++ b/Documentation/virt/kvm/x86/index.rst
@@ -0,0 +1,18 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+KVM for x86 systems
+===================
+
+.. toctree::
+   :maxdepth: 2
+
+   amd-memory-encryption
+   cpuid
+   halt-polling
+   hypercalls
+   mmu
+   msr
+   nested-vmx
+   running-nested-guests
+   timekeeping
diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
similarity index 100%
rename from Documentation/virt/kvm/mmu.rst
rename to Documentation/virt/kvm/x86/mmu.rst
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/x86/msr.rst
similarity index 100%
rename from Documentation/virt/kvm/msr.rst
rename to Documentation/virt/kvm/x86/msr.rst
diff --git a/Documentation/virt/kvm/nested-vmx.rst b/Documentation/virt/kvm/x86/nested-vmx.rst
similarity index 100%
rename from Documentation/virt/kvm/nested-vmx.rst
rename to Documentation/virt/kvm/x86/nested-vmx.rst
diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Documentation/virt/kvm/x86/running-nested-guests.rst
similarity index 100%
rename from Documentation/virt/kvm/running-nested-guests.rst
rename to Documentation/virt/kvm/x86/running-nested-guests.rst
diff --git a/Documentation/virt/kvm/timekeeping.rst b/Documentation/virt/kvm/x86/timekeeping.rst
similarity index 100%
rename from Documentation/virt/kvm/timekeeping.rst
rename to Documentation/virt/kvm/x86/timekeeping.rst
-- 
2.35.1


