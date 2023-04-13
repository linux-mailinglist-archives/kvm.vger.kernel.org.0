Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8376E145D
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjDMSnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjDMSnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:01 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46B68A50
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:39 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q6so3696478wrc.3
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411358; x=1684003358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CA16exKM/MAm93RteWP69jmc/+5rGl2ghMakVcYJgHw=;
        b=n7xipshTGY8EfjYjgwizXbd1mJmZcyNwrXHPLXx8HPiJ9Ya5TDzlxBHLI4JSsxPmyS
         ZjRDFX84p2hfdSeQV2YV/VxCGNNHhRpq+xvJPfp3o81i5I1Dm8ppSdhWoyNzv7tV7BSx
         no9ViUA8xa/2hoSJcWjsGSGsWfUpXXaVb9ABBlCDq9z81ljLBltqWoWlEEm4HTOVvyIG
         XV9RsjFz+4dJxNQkJPt+a8XZaGfM+XO5yBTguX17HFAYgHNbbK3qFYeeyuRvqgRLi2Dd
         5UWKFALL+sSta98maJHuBndUM1nhmtzxNaUXdTX3jU9CPWaavU2qEFQQRdzo1UFoXszm
         BKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411358; x=1684003358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CA16exKM/MAm93RteWP69jmc/+5rGl2ghMakVcYJgHw=;
        b=kaAdPXl2RBDgD9N+kf5p9w9MG8nFQLuOCFPHCOiMOoy4jLV2ZmN31dHVNOiWYldyeV
         xKHXeXnO0NHwEvEP6pjXDMoDNr1aaoAiM8L0lU7kNgtksCvFTpjzwnYcvLStiky6EoSk
         xRgu7F60MHP25FSrzKN1gfbSLkJPCs76JbToKTbwJ2ogFIuR6kCE0xOXAgyXfUgA1v57
         fVCJNBwbbG0+O8RL6OIZKfFmf2LEZ11zjk5dXzcVNvBiYhnc6jgKSs84EsRWI8JQXe1B
         2pcGFHgEPNvmyp6ByjoyQ+MIREg5y/Kw4hVLb34eSkO3zSvfFchpt51eyJvHJTc/VJ2p
         pxBg==
X-Gm-Message-State: AAQBX9fV53n9Z2rleUPY3qdrUnu5F7Jwwp8Cw4TdYXQIvG8ggobzAHD5
        NxrfTNC7oAHB4p5sfD6AH5y92Q==
X-Google-Smtp-Source: AKy350ZIxlcs1dDroEIOREcuPVWbvldHeBsV9f/B8ZsaP38PWbFm0XJVLMB2WgC24AV9l0pVRTAucg==
X-Received: by 2002:adf:f049:0:b0:2f0:21b1:2ad5 with SMTP id t9-20020adff049000000b002f021b12ad5mr2270668wro.66.1681411357956;
        Thu, 13 Apr 2023 11:42:37 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:37 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 03/16] x86: Add vendor specific exception vectors
Date:   Thu, 13 Apr 2023 20:42:06 +0200
Message-Id: <20230413184219.36404-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413184219.36404-1-minipli@grsecurity.net>
References: <20230413184219.36404-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel and AMD have some vendor specific exception vectors, namely:
- Intel only: #VE (20),
- AMD only: #HV (28), #VC (29) and #SX (30).

Also Intel's #XM (19) is called #XF for AMD.

Add definitions for all of these and add comments stating they're vendor
specific.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/processor.h | 5 +++++
 lib/x86/desc.c      | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 5dd7bce024fd..7590c0c44c79 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -37,7 +37,12 @@
 #define AC_VECTOR 17
 #define MC_VECTOR 18
 #define XM_VECTOR 19
+#define XF_VECTOR XM_VECTOR /* AMD */
+#define VE_VECTOR 20 /* Intel only */
 #define CP_VECTOR 21
+#define HV_VECTOR 28 /* AMD only */
+#define VC_VECTOR 29 /* AMD only */
+#define SX_VECTOR 30 /* AMD only */
 
 #define X86_CR0_PE_BIT		(0)
 #define X86_CR0_PE		BIT(X86_CR0_PE_BIT)
diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 9402c0ef59d0..06bb3e3c1e5d 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -129,7 +129,11 @@ const char* exception_mnemonic(int vector)
 	VEC(AC);
 	VEC(MC);
 	VEC(XM);
+	VEC(VE);
 	VEC(CP);
+	VEC(HV);
+	VEC(VC);
+	VEC(SX);
 	default: return "#??";
 #undef VEC
 	}
-- 
2.39.2

