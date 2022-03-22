Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AE54E3D2E
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 12:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbiCVLIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 07:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbiCVLIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 07:08:47 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5F480211;
        Tue, 22 Mar 2022 04:07:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id v130-20020a1cac88000000b00389d0a5c511so1633076wme.5;
        Tue, 22 Mar 2022 04:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J4WuZIw1gEze4qEJaV70xo0L6nuByRxRegmX9Sw5Tk8=;
        b=ffp9vlurUn1J8JPD14Wv6UdC6FjgZlW9sebn2ZrQEvSdK+Y8umvguAsoF+EWM/Bl8r
         SGuSSyvPQrIdqDVK3uYAnH0J6es7DT2KnWxLFbSUZT1ohHtvyHGkkorEvnH1j4TRjIvJ
         UOXA9+HHnOgY1gUh+gq0edf0btyobsqxo9PssX9beDi0TEas27Eueov0D/FiR15EqndE
         rfb4+p2MWI6f/pqD2gotwnm7DmP4rIqbHgi2AhzDtp27RhduDGvjTiF+jhdpW+mdTyfY
         3inZjnoqtpEz4X01LX7mR0prJWVcyL9l27arwguAc5QiwtKeOVN/nSAqOKDEK+KNiyT7
         U2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=J4WuZIw1gEze4qEJaV70xo0L6nuByRxRegmX9Sw5Tk8=;
        b=7M+uAomZoKVgNGbmGtvSgsc6ZRliumaoYbTf3q8BtskKkbqQ+P+xeF/PNg5msWzjwt
         B6CuOJrPZJPSgskqbadLoD09RwVaxHFLHV2UCrxF40UUr7vUV7JEwvy4QmTSa1zITzY4
         kMSR2AefDq96zG3J2ldxPE8ntKbRvRZ1FARliz9rsUXvzO7HYoewOteIA1cMka+mkaTh
         fiCq6hcmikIuH03r44Kf8CJVKsn85WVVXbuSXVRyWk8QydudfF7S+Ic6f2Y77GvaqaYK
         TH6QtwWQqsTua8O/bLonUavznKambL6RgoA+wGzDdeSo3+GOiEHlUkdmV2k6YuzYA9qg
         7lVg==
X-Gm-Message-State: AOAM532TrIHBLA2Aaolq0g82AtZXWjcE7YWuhws8Jh2NovJ64QFfdDSE
        feld+9XNhdKh3EnasGh0iURZ3NZO51E=
X-Google-Smtp-Source: ABdhPJz3ElnnHBMGnkHFPKyU6xFn9j6lu5NoN0v3V3H6bv6FoTfdaOqb2EYL31W9Ie9ctRJBR2LZEw==
X-Received: by 2002:a7b:ce92:0:b0:38b:ed80:9e66 with SMTP id q18-20020a7bce92000000b0038bed809e66mr3254732wmj.82.1647947237944;
        Tue, 22 Mar 2022 04:07:17 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b0038c949ef0d5sm1746379wmq.8.2022.03.22.04.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:07:17 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, jmattson@google.com
Subject: [PATCH 2/3] Documentation: KVM: add virtual CPU errata documentation
Date:   Tue, 22 Mar 2022 12:07:11 +0100
Message-Id: <20220322110712.222449-3-pbonzini@redhat.com>
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

Add a file to document all the different ways in which the virtual CPU
emulation is imperfect.  Include an example to show how to document
such errata.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/x86/errata.rst | 39 +++++++++++++++++++++++++++
 Documentation/virt/kvm/x86/index.rst  |  1 +
 2 files changed, 40 insertions(+)
 create mode 100644 Documentation/virt/kvm/x86/errata.rst

diff --git a/Documentation/virt/kvm/x86/errata.rst b/Documentation/virt/kvm/x86/errata.rst
new file mode 100644
index 000000000000..df394d34a836
--- /dev/null
+++ b/Documentation/virt/kvm/x86/errata.rst
@@ -0,0 +1,39 @@
+
+=======================================
+Known limitations of CPU virtualization
+=======================================
+
+Whenever perfect emulation of a CPU feature is impossible or too hard, KVM
+has to choose between not implementing the feature at all or introducing
+behavioral differences between virtual machines and bare metal systems.
+
+This file documents some of the known limitations that KVM has in
+virtualizing CPU features.
+
+x86
+===
+
+``KVM_GET_SUPPORTED_CPUID`` issues
+----------------------------------
+
+x87 features
+~~~~~~~~~~~~
+
+Unlike most other CPUID feature bits, CPUID[EAX=7,ECX=0]:EBX[6]
+(FDP_EXCPTN_ONLY) and CPUID[EAX=7,ECX=0]:EBX]13] (ZERO_FCS_FDS) are
+clear if the features are present and set if the features are not present.
+
+Clearing these bits in CPUID has no effect on the operation of the guest;
+if these bits are set on hardware, the features will not be present on
+any virtual machine that runs on that hardware.
+
+**Workaround:** It is recommended to always set these bits in guest CPUID.
+Note however that any software (e.g ``WIN87EM.DLL``) expecting these features
+to be present likely predates these CPUID feature bits, and therefore
+doesn't know to check for them anyway.
+
+Nested virtualization features
+------------------------------
+
+TBD
+
diff --git a/Documentation/virt/kvm/x86/index.rst b/Documentation/virt/kvm/x86/index.rst
index 55ede8e070b6..7ff588826b9f 100644
--- a/Documentation/virt/kvm/x86/index.rst
+++ b/Documentation/virt/kvm/x86/index.rst
@@ -9,6 +9,7 @@ KVM for x86 systems
 
    amd-memory-encryption
    cpuid
+   errata
    halt-polling
    hypercalls
    mmu
-- 
2.35.1


