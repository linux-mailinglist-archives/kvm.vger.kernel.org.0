Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11CA6A245A
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjBXWhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjBXWhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:37:10 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715CE6F431
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:09 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id h19-20020a63f913000000b00502f20ab936so193790pgi.20
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T1p1Y6h/HupBXyncuWcOBrNuyTtKtABtkd2Kj481URk=;
        b=eArPrQQmBXLUycZWg/jDRTdvHlTGr/jgz6tDYQiVVS5gG/GK2qBX6CSPxfZWqBiA21
         JFUH8y1SprL5r+5Gb1aSnj3oFuzy4gdUX+KX2GLYftfShtUdyNLMfG+4/j7q4m4vvWdy
         9B0E9IbnNPvpwjQpFKdv4NVm6aLrx6TDIKGVtufbn6sYSI1F6M4hOdH4b2fpIHnhGtD+
         8Z4qC7ekTqvqBBMhRGb/w4InCaYbqmdICljtBEc4ROUKy0cOfDiw+gs5JnqxY7JzL7M3
         Y/at9y78ZWKJNi5Ny4xWsdbMIqGi4UR/9T1Vn+M2IUzv93z/S62xvOWPXnrd9DZKnHh2
         nBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T1p1Y6h/HupBXyncuWcOBrNuyTtKtABtkd2Kj481URk=;
        b=3dNgDbMvGBRLl5N+XYoDBMDR8JolFlXkZMt0t4xheP8zARhPLCO41X5o+N7QBf/rLQ
         C5E14nYXmtVmprAqGdTrwFsDIADl3V2vbcN5KdxiO5N3Of2bIX/uMX1RSTBOsqstsIIs
         PN64qqXAj47n7cNMkbdCyB+nN9Nc/mdLJEtit/KKtcEyCN6lX261f1Dn3JS2B1yIUa7Y
         IgA1sFs0MHXrTmZkoMEhhGjo8vot1hhY6KZi8rsVThI4GtO8wO+ZIhsqXQILxdhVXkRG
         7Zn9IzqwzZZ8S6Ko+KXjz/xmz+RKWTSrHWD0U5w7R8BdFionNCM9o4to3kgaYgJhycwf
         MmrQ==
X-Gm-Message-State: AO0yUKU/EFla3/d+yDIgpCLozfdZ4UErSBWrEroCpn+VNE8cIBlLPskH
        EuIr5sx538fqYyEQwJwwIDMjoGsLGgGbsqKC8/hKi3X35gpMd2b+hFvBVMbx5YOFQDblLY/ze9L
        rLa6L2pprWzvUQhiuqc8dA3MVOv/vzORN2fdtKqkkGi/z3Z7mEi7cpZdaE5QZ+he64+AG
X-Google-Smtp-Source: AK7set9V/hDb9K5AjlgiI9PN0jVBt5G+jniyPbHrkdQOsDX55jLJt1SNUC7MDXEMHDkDdngN/rVbxBKGNcP4R4bL
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:2946:b0:237:9ca5:4d5d with SMTP
 id x6-20020a17090a294600b002379ca54d5dmr1126291pjf.6.1677278228756; Fri, 24
 Feb 2023 14:37:08 -0800 (PST)
Date:   Fri, 24 Feb 2023 22:36:04 +0000
In-Reply-To: <20230224223607.1580880-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230224223607.1580880-6-aaronlewis@google.com>
Subject: [PATCH v3 5/8] KVM: x86: Clear all supported AMX xfeatures if they
 are not all set
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

Be a good citizen and don't allow any of the supported AMX xfeatures[1]
to be set if they can't all be set.  That way userspace or a guest
doesn't fail if it attempts to set them in XCR0.

[1] CPUID.(EAX=0DH,ECX=0):EAX.XTILE_CFG[bit-17]
    CPUID.(EAX=0DH,ECX=0):EAX.XTILE_DATA[bit-18]

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1eff76f836a2..ac0423508b28 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -72,6 +72,9 @@ static u64 sanitize_xcr0(u64 xcr0)
 	if ((xcr0 & mask) != mask)
 		xcr0 &= ~XFEATURE_MASK_AVX512;
 
+	if ((xcr0 & XFEATURE_MASK_XTILE) != XFEATURE_MASK_XTILE)
+		xcr0 &= ~XFEATURE_MASK_XTILE;
+
 	return xcr0;
 }
 
-- 
2.39.2.637.g21b0678d19-goog

