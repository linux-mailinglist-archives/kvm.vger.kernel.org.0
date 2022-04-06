Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA534F5AB1
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 12:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbiDFKIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 06:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353593AbiDFKIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 06:08:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FB025C2;
        Tue,  5 Apr 2022 23:37:30 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso1762665pjh.3;
        Tue, 05 Apr 2022 23:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UZeLkKh0aUB6JqoXfJ+RJuRvJk7Nq61/8MlGpbtCQWo=;
        b=Tgsc9Ntr4BZA7ImDsg/TiwDVFtdoAEDnTavUL8t/jenMLIk/W7z+jWG1NJ9gHcCyaf
         cF//24L02nJYZbSfIaBfkO6QY5Xvoirii5XWUpIZcat6JcmxSDn2Wu8iEPWzNvaaSiUz
         NE5ToGY/v2MMoPq6WB+cB3MIzlX91E287XywRpQX5I2E6qIN+wexexYGDan77ptKMXEZ
         l5u2wlZjpq+i9++O551umtspKUHuDIoYM4T9bSFPP+7L5vb8A2V44ZF86l/HgQXR1y7X
         0LRPqz3NWeL5ynp7ZxuN+BWj/OC/aFAI1gmaW/gIcCpaSFMN2/HP1GalyHTGDdkKt/8A
         FTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UZeLkKh0aUB6JqoXfJ+RJuRvJk7Nq61/8MlGpbtCQWo=;
        b=wSEv6xQwjW1HfcNBbE4cj4DE+xgIawtMk2fgznio+M1xbc2ZPqaJoEisyjuZKb8JXf
         TV3Ve8Bg4NadCOA8bzJuNudDGZOfm0pOI6hqUV1DJsCiH90Vy8tvZrzS5N281sykXpEq
         BDZL8Ax7r6nlGeO1rs6WuU+9JALjyQVHs49G1r/oHnLbLFJ2everi9/eaj/QFvRAq6sP
         Mb9QzX57nIOzxm9aR229Qf6atewqBt8FBqln2gCBPSFWlkvzZ8xOCveyQCmZLMJAcUco
         zcE11iR8PYXrJ8L1Xiwh2rGaWrNwMsd6OodplgR31YQ+2D9fsC7O+Gcfk4LG2g99ldT+
         tKTA==
X-Gm-Message-State: AOAM533bShCvoLlfuakcZz8BUOnI9Cpv/3jqD9oWSyYXWTF5j1EJezW8
        JvRigbXzkCw4tcF+kML26AQ=
X-Google-Smtp-Source: ABdhPJwFboUw+VKJ4gTk2U2oPXZLQF0fhBc6cBSW+nDsF4UNTKcZVSq9pd6M9zu5DXQF7SGygNu/7Q==
X-Received: by 2002:a17:902:c94c:b0:154:58e4:6f5a with SMTP id i12-20020a170902c94c00b0015458e46f5amr7410058pla.142.1649227050179;
        Tue, 05 Apr 2022 23:37:30 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id bt18-20020a056a00439200b004faad3ae59esm17286650pfb.95.2022.04.05.23.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 23:37:29 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Documentation: KVM: Add SPDX-License-Identifier tag
Date:   Wed,  6 Apr 2022 14:37:15 +0800
Message-Id: <20220406063715.55625-5-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406063715.55625-1-likexu@tencent.com>
References: <20220406063715.55625-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+new file mode 100644
+WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
+#27: FILE: Documentation/virt/kvm/x86/errata.rst:1:

Opportunistically update all other non-added KVM documents and
remove a new extra blank line at EOF for x86/errata.rst.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 Documentation/virt/kvm/vcpu-requests.rst             | 2 ++
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 2 ++
 Documentation/virt/kvm/x86/errata.rst                | 2 +-
 Documentation/virt/kvm/x86/running-nested-guests.rst | 2 ++
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
index db43ee571f5a..31f62b64e07b 100644
--- a/Documentation/virt/kvm/vcpu-requests.rst
+++ b/Documentation/virt/kvm/vcpu-requests.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 =================
 KVM VCPU Requests
 =================
diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1c6847fff304..2d307811978c 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 ======================================
 Secure Encrypted Virtualization (SEV)
 ======================================
diff --git a/Documentation/virt/kvm/x86/errata.rst b/Documentation/virt/kvm/x86/errata.rst
index 806f049b6975..410e0aa63493 100644
--- a/Documentation/virt/kvm/x86/errata.rst
+++ b/Documentation/virt/kvm/x86/errata.rst
@@ -1,3 +1,4 @@
+.. SPDX-License-Identifier: GPL-2.0
 
 =======================================
 Known limitations of CPU virtualization
@@ -36,4 +37,3 @@ Nested virtualization features
 ------------------------------
 
 TBD
-
diff --git a/Documentation/virt/kvm/x86/running-nested-guests.rst b/Documentation/virt/kvm/x86/running-nested-guests.rst
index bd70c69468ae..a27e6768d900 100644
--- a/Documentation/virt/kvm/x86/running-nested-guests.rst
+++ b/Documentation/virt/kvm/x86/running-nested-guests.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 ==============================
 Running nested guests with KVM
 ==============================
-- 
2.35.1

