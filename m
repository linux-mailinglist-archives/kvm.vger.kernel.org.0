Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819EC659A80
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 17:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbiL3QZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 11:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiL3QZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 11:25:06 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8883963FC
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:04 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id s6-20020a259006000000b00706c8bfd130so22647868ybl.11
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t9euw23AvLOKmgxif0QMlhmbR+VDi8SZe//P9Qi80Hw=;
        b=d2EqC9LsNWNcP1sJ1zEpANiizSEGI4Soyly6dW15XDDbSn+Z8uHXx1bA2Ljf+AOxSn
         6ljD4moSJ7uDcrnRG7pmkLWr5MqO5PCl/7CXp/ER3h1ouRN6C6x5I0k6yc4jwzDuCFNn
         AV5mElrZQFJT6xYB4xO4VnhypQ12BnIJF44cZtVlpVo75/lY8+kffKMg7svzC3fM3OA1
         D/mDUoXlNuaHcwnPIPFnvxBJf2cdFuqjq1P/TXi7xNbqrtKJjw3OTc5DVLnDXqCraNAj
         OciA73njrZHCmrEN4DZudu6JfLTdoFyl1GfwZXd1V/L1ITqkmvD1VFyfWQ/nCzDpsEm/
         v7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t9euw23AvLOKmgxif0QMlhmbR+VDi8SZe//P9Qi80Hw=;
        b=ZOHZBQhR/xq3OGlUZnIWbCxl7XzPO/Xo1g5qPnvse5oup8Kq+rSE53nZeX0GKHgNzX
         cznh3y8ErEtMOMdGp9NmOMZZmk6lCbGXpxm1gnK5vx0P1zkko3S6m/SYG632xwGrayN3
         YImOQ8cdfRz9mEz0jpT9eNzu90jFKF3+/tEH2ALBbIwUhjmHkF1uxStAjynmzNUaVaZF
         LnE0vZBRBl2uAJk6eFq7gby4hwJu78a7hzvv2xkudVHwNTV89sxlgQkgg9TzXKPwN1V3
         oZxXJCruCFBmx4MeXREDOGmm/wcG72CRRj1TW+FYoTG/kpJlZ9BPP00Ad03WQ6ktOL4A
         +RIQ==
X-Gm-Message-State: AFqh2kp0zRNsohqv0XKnvO1Wl9VUa/5R9zsEcJ06nvcbnRsfx7waNFmo
        NgeH8kI+OMD+IVVMnrFt/ujs31QDsaTZifrZxpCGQukTwNqIfnOtpfhtSUctht5LZFb0VyMXeJW
        rj2pSwX1XmO3aG4Fiw+p9tgRppFrhgFhZCpVsWiQyuOUbIKl+4Dn8ZSQxY6Lrp3DwirBh
X-Google-Smtp-Source: AMrXdXv9GeTC2Zs9RvS4SDhRuExvf1F6fCw4NpOW/najOkACnnljgkmHZwI6pqCyIIu9sHF3HBsLslPOVjA892aA
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a81:7103:0:b0:478:831e:4a63 with SMTP
 id m3-20020a817103000000b00478831e4a63mr1531932ywc.425.1672417503715; Fri, 30
 Dec 2022 08:25:03 -0800 (PST)
Date:   Fri, 30 Dec 2022 16:24:39 +0000
In-Reply-To: <20221230162442.3781098-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230162442.3781098-4-aaronlewis@google.com>
Subject: [PATCH v2 3/6] KVM: x86: Clear all supported AMX xfeatures if they
 are not all set
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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
index 89ad8cd865173..bdccc4ddb45b1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -866,6 +866,9 @@ static u64 sanitize_xcr0(u64 xcr0) {
 	if ((xcr0 & mask) != mask)
 		xcr0 &= ~XFEATURE_MASK_AVX512;
 
+	if ((xcr0 & XFEATURE_MASK_XTILE) != XFEATURE_MASK_XTILE)
+		xcr0 &= ~XFEATURE_MASK_XTILE;
+
 	return xcr0;
 }
 
-- 
2.39.0.314.g84b9a713c41-goog

