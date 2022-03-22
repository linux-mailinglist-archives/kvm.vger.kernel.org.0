Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CABD4E3D30
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 12:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiCVLIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 07:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiCVLIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 07:08:49 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE0480212;
        Tue, 22 Mar 2022 04:07:21 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id bg31-20020a05600c3c9f00b00381590dbb33so1275074wmb.3;
        Tue, 22 Mar 2022 04:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PyWMhkHDA8FmVbcGzMZ4aLs+B2iNMXC/LNGOuXbuKpU=;
        b=iQCE9QOgyw6+P9QVFLZAqRW03I/v4JSOqAJWIh5qRkD2sHMeVC9mZS4KjYbYEF+1k6
         o4BGtsO6wS6PzkxrkVjCWSNZ+PELapUEkIDc7I9glm8E9c/4BMMzYwgvegiJxSYQoLts
         0ZwSKqdAHt2KJnQXijV7qw5CGVr3pLOJfPRRqR9oARvw/T2S863WB1W9WvJnX0yOqAdH
         a+QrSbsFSFSmBKfadMrPReHwfNdREk0kDpicDsCzKoteaGZjfs8PgbDGqv+ZAnfn7r4v
         EVNZLySbtOOt6KlMLnInyn36i7sTDJuXQj91OZXjicEZh5lwzdhZ+UHYgP9fVBrUftza
         Gfjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=PyWMhkHDA8FmVbcGzMZ4aLs+B2iNMXC/LNGOuXbuKpU=;
        b=a0gDgNdNUpOKzREEd2W9Kmi8CVXaQ+eCLY0ExTTsXpSnsEOxL/f5HQGdXLZQp9+6g9
         VjEJOXdOyBOUw1flI+hgGG4ABlMUZjFbRcnE6tqGeNhTkv0LdKFY38g+cr9kOHIK7Klw
         XiOkd5oPrpH3Pg19R8yZXSLpwMZGhJ1jAYlHWios+v6e0rsnZQqRG2MtEH6XBFOzI69C
         C0aGc+88jSSgQF+zb04Ode9C77s9/hNNe1k+xvSODZsEabTSjKjYoA1qhl5dVbi9IlUM
         2bYNdjSwTsSZGbXhYjisfrw3OGMXVlM/L4ejP2k7yxaj9my7yEwxtsM+l2xynfmzNjuQ
         98Iw==
X-Gm-Message-State: AOAM532XeVAYxWF3j5DpJgarF0efBihmbRSe6NQF0KNN8qK+L51zGsq9
        7jPbx4iAxtmpDkcxlfsb1jBPi6XsclQ=
X-Google-Smtp-Source: ABdhPJxlFbZVNjAss+JR1DFkgQFHuwfEo2WgGvgMyD3D5ryBmDRfyGcdhKMgU74bUwPECCY3/iGNug==
X-Received: by 2002:a5d:6101:0:b0:204:871e:9912 with SMTP id v1-20020a5d6101000000b00204871e9912mr2504628wrt.60.1647947239442;
        Tue, 22 Mar 2022 04:07:19 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b0038c949ef0d5sm1746379wmq.8.2022.03.22.04.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:07:18 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, jmattson@google.com
Subject: [PATCH 3/3] Documentation: KVM: add API issues section
Date:   Tue, 22 Mar 2022 12:07:12 +0100
Message-Id: <20220322110712.222449-4-pbonzini@redhat.com>
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

Add a section to document all the different ways in which the KVM API sucks.

I am sure there are way more, give people a place to vent so that userspace
authors are aware.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 46 ++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f3172376ec3..8787fcd3b23f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7575,3 +7575,49 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+9. Known KVM API problems
+=========================
+
+In some cases, KVM's API has some inconsistencies or common pitfalls
+that userspace need to be aware of.  This section details some of
+these issues.
+
+Most of them are architecture specific, so the section is split by
+architecture.
+
+9.1. x86
+--------
+
+``KVM_GET_SUPPORTED_CPUID`` issues
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+In general, ``KVM_GET_SUPPORTED_CPUID`` is designed so that it is possible
+to take its result and pass it directly to ``KVM_SET_CPUID2``.  This section
+documents some cases in which that requires some care.
+
+Local APIC features
+~~~~~~~~~~~~~~~~~~~
+
+CPU[EAX=1]:ECX[21] (X2APIC) is reported by ``KVM_GET_SUPPORTED_CPUID``,
+but it can only be enabled if ``KVM_CREATE_IRQCHIP`` or
+``KVM_ENABLE_CAP(KVM_CAP_IRQCHIP_SPLIT)`` are used to enable in-kernel emulation of
+the local APIC.
+
+The same is true for the ``KVM_FEATURE_PV_UNHALT`` paravirtualized feature.
+
+CPU[EAX=1]:ECX[24] (TSC_DEADLINE) is not reported by ``KVM_GET_SUPPORTED_CPUID``.
+It can be enabled if ``KVM_CAP_TSC_DEADLINE_TIMER`` is present and the kernel
+has enabled in-kernel emulation of the local APIC.
+
+Obsolete ioctls and capabilities
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+KVM_CAP_DISABLE_QUIRKS does not let userspace know which quirks are actually
+available.  Use ``KVM_CHECK_EXTENSION(KVM_CAP_DISABLE_QUIRKS2)`` instead if
+available.
+
+Ordering of KVM_GET_*/KVM_SET_* ioctls
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+TBD
-- 
2.35.1

