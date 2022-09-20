Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC185BEED8
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 23:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiITU7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 16:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiITU7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 16:59:50 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DD913D2C
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 13:59:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id o1-20020a170902d4c100b00177f59a9889so2431101plg.13
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 13:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=T7irDTPCqBENrbeucQrYstnxpwB8T+SjVIp8vtvhQwA=;
        b=VOU9LUxkejXMgsKC43w3F00oNRXpU12tfxO+lnX/U+JXWDYnV6Mf8Ps2Md4/hpVXy3
         uKHoU+Rz72CPGUnuLqc0Vfi3Oi9UR504DzkAnSRahHsEFSogtFS4smGgwDKuH8IDSEZJ
         eq2sObUzPCwTb3WRfBfc0hKPqQguUvj8gf5P6XJi9d2uhveh4t1/KyUOroyEmqvIV6J+
         OiHCbGIz9kfO/VQPQhlWecmCnXai61HqvvAgSnHZo/E7GCwxod14VUN2/SYQbbPbtzkx
         4PoqFvULFTxTOm4UCG0knNHa6IhTeUDHLpRsQS8vSGN6JqtrevqEZzO98rb5+ZqDGeAM
         7SzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=T7irDTPCqBENrbeucQrYstnxpwB8T+SjVIp8vtvhQwA=;
        b=yvoIXXDiqg4gS47+ciwJykLT7G9Yk5u55kcJtN6jDcfRConCiP2chmLEBDDST9oA4g
         MYgfLHGBlKmwl57fYOEnsEUPt9F6P5vIUdnIs8BAgxF5JvBA12yfIaasrd7BGXI4ag19
         UYio2To2HNsK9iXgOOuPJO8a8y3cs+Qr+jp1tpztkGLBnJBezCDEmHpUKztvKDkiqzwI
         5WIfBceTZtWMWDj6sg6Ermy1Z7KHOv06N91Pkhwbav5AL2ucJu4dwapo14Z+bJXk2+hy
         6pX731oUv4v3e/VL2jf8whLqv9E6WCfnO/IhtJYUB+UZ2o8kJF8Qhh76L1Xby356gKo9
         vttA==
X-Gm-Message-State: ACrzQf1GDAr/3T1ffKQnDv3nG4wisg8QhvfSQpxL3LRAXLyq7nVh0kIj
        xj1vjq2LFFN2W2tnEGTFHE5/lvN/EHZ05w==
X-Google-Smtp-Source: AMsMyM6JGqhEZn7j2eVRprmFD1uxxR2nVMfJ20xP/bVTPX+0A2/eAwy7d6kp2HO3A0anYKUHYmULd8y56ccYog==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a62:17d1:0:b0:54d:87d5:249e with SMTP id
 200-20020a6217d1000000b0054d87d5249emr15326219pfx.14.1663707584214; Tue, 20
 Sep 2022 13:59:44 -0700 (PDT)
Date:   Tue, 20 Sep 2022 13:59:20 -0700
In-Reply-To: <20220920205922.1564814-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220920205922.1564814-1-jmattson@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920205922.1564814-2-jmattson@google.com>
Subject: [PATCH v2 1/3] Revert "KVM: SVM: Allow EFER.LMSLE to be set with
 nested svm"
From:   Jim Mattson <jmattson@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert the hack that allowed a guest to set EFER.LMSLE, since no
attempt was ever made to properly virtualize the feature.

Now that AMD has deprecated the feature, the ROI for properly
virtualizing it is vanishingly small.

This reverts commit eec4b140c924b4c650e9a89e01d223266490e325.

Fixes: eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be set with nested svm")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/msr-index.h | 2 --
 arch/x86/kvm/svm/svm.c           | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 6674bdb096f3..0a0426f284a3 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -28,7 +28,6 @@
 #define _EFER_LMA		10 /* Long mode active (read-only) */
 #define _EFER_NX		11 /* No execute enable */
 #define _EFER_SVME		12 /* Enable virtualization */
-#define _EFER_LMSLE		13 /* Long Mode Segment Limit Enable */
 #define _EFER_FFXSR		14 /* Enable Fast FXSAVE/FXRSTOR */
 
 #define EFER_SCE		(1<<_EFER_SCE)
@@ -36,7 +35,6 @@
 #define EFER_LMA		(1<<_EFER_LMA)
 #define EFER_NX			(1<<_EFER_NX)
 #define EFER_SVME		(1<<_EFER_SVME)
-#define EFER_LMSLE		(1<<_EFER_LMSLE)
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 
 /* Intel MSRs. Some also available on other CPUs */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3813dbacb9f..3af360fe21e6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5012,7 +5012,7 @@ static __init int svm_hardware_setup(void)
 
 	if (nested) {
 		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
-		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
+		kvm_enable_efer_bits(EFER_SVME);
 	}
 
 	/*
-- 
2.37.3.968.ga6b4b080e4-goog

