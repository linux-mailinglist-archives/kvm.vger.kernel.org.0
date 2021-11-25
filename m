Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A0445D2CB
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353643AbhKYCFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353453AbhKYCDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:03:00 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85B4C0619E9
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:55 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id l10-20020a17090a4d4a00b001a6f817f57eso2319562pjh.3
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=LltHy45Y9GbPOdoaEaS4NxqOcEhenr2ZriQ1G+zWjEc=;
        b=pt+SHLXVf4xyD9WsAj19O3MnZV/2n7m5gkiz/Fg4BYgZa+3SYQm91CYtrNdzxIe6oU
         xtMCDTW/BFID1dkh8XLcx7LczYg8I7ulP2H0WO4+j7hcDoByN/NYxHAyGLbXQHGG6hat
         msBo2cpofRtmtCrlnZrhTAuEa0ObEpY470gCM52AuSdOXUqCeUdi4Jf8IePDo0FDZ6Ua
         ZvPgHuZg7wd7i1GPpSFPz4AYxkD77Ngp5SYh358RbH3xrRDz5kk2cEy1hkum5TyY7FFU
         7+5ztUnvWPusrTiilzvkF7uEe6uNlV40gplvmaJyyjrPpt0IxDfX3puTfkySbk1iWWZl
         9cJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=LltHy45Y9GbPOdoaEaS4NxqOcEhenr2ZriQ1G+zWjEc=;
        b=Ge65A9zmRctmIDC1cA76M4C6Gi40aQZLwQ0O+/GpUrTWz4j8UP6Dk0RHk+t39phSY3
         CvitgGs3VhlD/gq6k8n2+hHMUG4Jf2mybnXhphbAKGRogquKgh5jMmbfB+/FMzZEn5hm
         FCb60zxv6oYAeOipQ7Z61EnACq1rBaWrdykXyo0lQresdDzJdMD8sQXVClZKw8RS+3Ns
         CIazaylaCGyBue4RxgBIPh9UaYzztbQJ+SsV9oYJBDcLaDZGtdSpAZB8ekBA/rSedw6e
         VZhD0x78MYzpl+gbSEKYb/9xQ0omqqP2D053cyR84qXkwWRX1wYqUl2beroPYCXVxCro
         vExA==
X-Gm-Message-State: AOAM5331Yp252sbz9bejPJcQ/+VaF+u/SSBUpjZ8MkTAtivkz6O8lZYZ
        AJvhCRFfk+837zKi+0I/9qMCnNYzeo8=
X-Google-Smtp-Source: ABdhPJz6n0Pkb7u/qC+Gsdy0lOLjjBtz6HhokMr+Wwy6tux2Ad1pHPRKE17+vRYhvqCksWxIPNFHdEJkhpU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7d96:b0:142:87dc:7dd3 with SMTP id
 a22-20020a1709027d9600b0014287dc7dd3mr24071983plm.11.1637803795277; Wed, 24
 Nov 2021 17:29:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:52 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-35-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 34/39] nVMX: Fix name of macro defining EPT
 execute only capability
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename EPT_CAP_WT to EPT_CAP_EXEC_ONLY.  In x86, "WT" generally refers to
write-through memtype, and is especially confusing considering that EPT
capabilities also report UC and WB memtypes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 2 +-
 x86/vmx.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index e499704..6dc9a55 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1606,7 +1606,7 @@ static void test_vmx_caps(void)
 	       "MSR_IA32_VMX_VMCS_ENUM");
 
 	fixed0 = -1ull;
-	fixed0 &= ~(EPT_CAP_WT |
+	fixed0 &= ~(EPT_CAP_EXEC_ONLY |
 		    EPT_CAP_PWL4 |
 		    EPT_CAP_PWL5 |
 		    EPT_CAP_UC |
diff --git a/x86/vmx.h b/x86/vmx.h
index e6126e4..d3e95f5 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -697,7 +697,7 @@ enum vm_entry_failure_code {
 #define EPT_IGNORE_PAT		(1ul << 6)
 #define EPT_SUPPRESS_VE		(1ull << 63)
 
-#define EPT_CAP_WT		1ull
+#define EPT_CAP_EXEC_ONLY	(1ull << 0)
 #define EPT_CAP_PWL4		(1ull << 6)
 #define EPT_CAP_PWL5		(1ull << 7)
 #define EPT_CAP_UC		(1ull << 8)
@@ -807,7 +807,7 @@ static inline bool ept_huge_pages_supported(int level)
 
 static inline bool ept_execute_only_supported(void)
 {
-	return ept_vpid.val & EPT_CAP_WT;
+	return ept_vpid.val & EPT_CAP_EXEC_ONLY;
 }
 
 static inline bool ept_ad_bits_supported(void)
-- 
2.34.0.rc2.393.gf8c9666880-goog

