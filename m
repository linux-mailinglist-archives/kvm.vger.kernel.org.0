Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A886A2459
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjBXWhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjBXWhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:37:08 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764336F42B
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:07 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id fa3-20020a17090af0c300b002377eefb6acso144533pjb.3
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G4UV7DWOQlYve4HyAdnVWF3PbtUTr/TT861HIpwxpQE=;
        b=jtmVotXbFj/LbxfLYiIM4VYmb+ZcqFLJ0yf3lwLBE0eOxtEauPeD3PXOr31zoAaYSU
         QufYDYAvmoHL+GE6QKkSQcPDHNB3EQxyc2RYh4wteVr0RsVov+uxosmKmaqXIEFfAKZZ
         VBXUVoatCSD8q//cRt4YxUPc/GeuRCCbzLq4gT4Ri+rn/Pn/1Wi4SnaRiuAqhOSrgUl6
         QOHg9hcnsgtbjLSAqlV5EAD6mQi4ZqJqroi7zZQEIJ01ppF08Kxz7STXvbWGq7qR+xeL
         9GHNNwyWfjQIG8wguAEB3Qx2IV/UHw6MP3fbCVBktEPYzlcV/yohQxVDioKPjgTYLDiP
         N+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G4UV7DWOQlYve4HyAdnVWF3PbtUTr/TT861HIpwxpQE=;
        b=on8Ux6JVLD93VLIUwYJsjt50N+6nj8mTpNZtD3DLHjoLAyB6G2h/RpgM2+yVDx2UMY
         EDcyZ+Vi1iCurI8YpOdsS6cuYe1mY/aJ1OdJRcWWHKiMAFozhYl2INGt2igeBoLSkx7m
         2YeVKMqIcoRbzltm+tGYon2K5q16mb43xjLQZYdk/tMb5mxJkKYnSfYYtsGziwbH/0HD
         7UBsFqy02m39NkP0m1Hp4e1dr28HePnOwQrNHKF3Tws6X1SYoTrmanoqsISh9M2+OUoP
         bYnAdy+cAyyQOi5Q8JR/PvU6X8Oach4u4VSE7VWcagwWxiorHbojjkzA7hbM0R8Ryd4C
         3fPg==
X-Gm-Message-State: AO0yUKV4Tsz+qJcVKGpX5Mxa4z63oqIWCgxnvt8AgyLvE2eZq+NE3bgZ
        6Ia8K18AZuK07LJa2Y49K0enOR5WvKI4ocQBV7CQK4gwS9jNds0dOGBjfoNOh/Vh1DeJgGoQXQg
        60ocQRCiH1vxTSf34HZIgn4YR7mi/SQvDiwwhyIJCSY/vcBlSmJJVSiAYWH41S7HRpPNm
X-Google-Smtp-Source: AK7set/HjDmLwnfI/pb2B6neofTLG2Tregi71la+5NyZ7IwVK0giDCjqjM86iUKt7V4r6+TtltlSlydjff6zRy9X
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:9c2:b0:233:caec:5710 with SMTP
 id 60-20020a17090a09c200b00233caec5710mr2203143pjo.3.1677278226813; Fri, 24
 Feb 2023 14:37:06 -0800 (PST)
Date:   Fri, 24 Feb 2023 22:36:03 +0000
In-Reply-To: <20230224223607.1580880-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230224223607.1580880-5-aaronlewis@google.com>
Subject: [PATCH v3 4/8] KVM: x86: Clear AVX-512 xfeatures if SSE or AVX is clear
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        mizhang@google.com, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A requirement for setting AVX-512 is to have both SSE and AVX enabled.
Add these masks to ensure AVX-512 gets cleared if either SSE or AVX
are clear.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 76379a51a16d..1eff76f836a2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -68,7 +68,7 @@ static u64 sanitize_xcr0(u64 xcr0)
 	if ((xcr0 & mask) != mask)
 		xcr0 &= ~mask;
 
-	mask = XFEATURE_MASK_AVX512;
+	mask = XFEATURE_MASK_AVX512 | XFEATURE_MASK_SSE | XFEATURE_MASK_YMM;
 	if ((xcr0 & mask) != mask)
 		xcr0 &= ~XFEATURE_MASK_AVX512;
 
-- 
2.39.2.637.g21b0678d19-goog

