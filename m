Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF490493AE8
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 14:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354703AbiASNNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 08:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354629AbiASNNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 08:13:50 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F2BC061574;
        Wed, 19 Jan 2022 05:13:49 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id d12-20020a17090a628c00b001b4f47e2f51so3258271pjj.3;
        Wed, 19 Jan 2022 05:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TR4jSRL7SEnB/R3Dx9qH1BJYTaEVN5Jzxkl0ydpL64I=;
        b=D4i6lLFGQ+uOF7l63BJ0hdDGwkBjQjJVGhqNA6+c+WEOk8PoMzDdjD9XnHmpDBLEmA
         uA3KDte6t87VCY2D3exzZHtbOKO2rM1PJ41Jry3qaYw0gEn/anPH6gbBJcgmERZzXfWT
         ZCL4ezDzNCQ0vKVAFu1UyERl7W/YQAoi3yWi6W2S1KjoGdXdgaaRX12q04K7cFAUkJsE
         dxf6ACiTIcinozxhuJzex2o5EJTZEZT8iX3iaWeHsSPR9HnwOntp7j8OBRWCW9Ba4p8c
         axMoOKoq9yEuaevBilugpUNeYW117UujtXhKNlEBiY0vDnCB1U3XBn9D2s2iqHDF12Bn
         nvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TR4jSRL7SEnB/R3Dx9qH1BJYTaEVN5Jzxkl0ydpL64I=;
        b=Du0WmywoYgkp7qk21yYfM3g53J8aLDC3w1BkquIli9ysoV7Uygt8PvXgpEND1yqd7B
         7kls/EN+pD73jljxKdGV7PUobL4vfhx6N/GM1aoQvj4asv9z68g/DiRCibQD9pp4cwtk
         ZfhSO3KDeQ9EaJ7x/QdE4OBwp6gFsj0iZpneCk+cVm25QuDoOidAxKgDLZcQlJmK5tx5
         ovm4FaGh69zxMXk7+YvXesspuTgB7IWg4dl1XFAuRKt9fM92IAAF1wl1ISW8PxaR7iUY
         AuvG1TWSRrX7zuiZM0NuFA1oEPtDFcsW5+1lT+kl/cTFUoTboU8vYad0tEKZIB2eEpNG
         38VA==
X-Gm-Message-State: AOAM532GKNAauk9KkqXio8gk1G2C8nK4iOTL5VNGz1EkpBcPgbxKK7SF
        4Sd5Qh7o35bo7feDBhEMkF8=
X-Google-Smtp-Source: ABdhPJwyfxSAp/GmLauMRvaCLfYbXzMR1B/09Q3MoxFgZI1Y4qVZVnzds5p5NaVDsAdCDFggCMEenw==
X-Received: by 2002:a17:903:249:b0:149:dbf7:2753 with SMTP id j9-20020a170903024900b00149dbf72753mr32569509plh.101.1642598029387;
        Wed, 19 Jan 2022 05:13:49 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q9sm2285299pjm.20.2022.01.19.05.13.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jan 2022 05:13:49 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix spelling mistake "Unfortuately" -> "Unfortunately"
Date:   Wed, 19 Jan 2022 21:13:39 +0800
Message-Id: <20220119131339.53054-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

There is a typo in code comment. Fix it by replacing "Unfortuately"
with "Unfortunately".

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6d31d357a83b..0207bd385a76 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1913,7 +1913,7 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 
 	/*
 	 * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU to put
-	 * the VMCB in a known good state.  Unfortuately, KVM doesn't have
+	 * the VMCB in a known good state.  Unfortunately, KVM doesn't have
 	 * KVM_MP_STATE_SHUTDOWN and can't add it without potentially breaking
 	 * userspace.  At a platform view, INIT is acceptable behavior as
 	 * there exist bare metal platforms that automatically INIT the CPU
-- 
2.27.0

