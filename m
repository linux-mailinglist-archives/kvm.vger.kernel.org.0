Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E8738F16D
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 18:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhEXQYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 12:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbhEXQYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 12:24:11 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47436C061574;
        Mon, 24 May 2021 09:22:41 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id i7so24866428ejc.5;
        Mon, 24 May 2021 09:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fXmhmAWLOA1EFx6H2n4KbIem9DqAwbYipXy2oW2nTdw=;
        b=n38W8umakYVzV6eEOep5K6Sg0G7Ksa96jH0sarBE7Tm+uy7KvlMFT9xZpRtXgDmX0y
         OUM4NAsx3LrHKrRlmyuDsfOgrh9gnCn6XG2QE6hL0kCdYDnugAzctipglkvsPJBIcaEe
         fz8Agjk6lGOKfxM1xQn+0VaczRrZLzgvdpUkhrp2+IuplAb6anPaTBm9QVXbsXDWoa4b
         mfqo4CmCX3zGqLjRuLqPUxZS7x1S1fTuJT0dSiMGR7GrZoJJgJfB9/AU8NLwd+Oivxa5
         kdj+79imNGQ42a2ZpgLI5q89DC5VBPgYIA91KrUEAaQ7hQPPe3u+Y0GA4jTOUYDVlThz
         9HzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=fXmhmAWLOA1EFx6H2n4KbIem9DqAwbYipXy2oW2nTdw=;
        b=VdB+Cf4flVveQmyM7K3yrmF1hYwqnLpMpQfwmLffW59+q5sjCNFrj2w54Uz/jGwGVn
         y5Kl1oa7QJHyxvQAFX+y4r4g0ODkVQI0ZEOwEYZ3/4u93FH1vdHLMrQ9+FMMRrChNanf
         uuXiQv/iFLyqpZd1couPl5qhzrPGAAWdE8cxG84RAtFrqzYN2mQJudZwXO1P+paBdP8H
         LUfIHj27WId6dTqEdt2xxiOZn9A57gw4uedocWsmzwqqyBJk/UHozF5Tm9c1FaVgsjL9
         8f6bEdpGwjd0cPbBSRdCjG3OtOLa7DtW8yWZc/mM+WSJn5Vm3cuH4iSlempUnJ+NqCQl
         x4kw==
X-Gm-Message-State: AOAM531tydynVrJr0CZ97Wpo9ZK2031C84VrLEK86yFhJrUui47Gl4GN
        dd/0fjvdqUS4+FpjlJT+JbTkGCQGvRgMag==
X-Google-Smtp-Source: ABdhPJwCCIzM3sW78mzC4hy/QyXPI0W3q0BOMHELeyQQnGWhOI2hHGEAA0C7ur5U4gWueeCaaDRVbw==
X-Received: by 2002:a17:906:abcc:: with SMTP id kq12mr24542950ejb.97.1621873359905;
        Mon, 24 May 2021 09:22:39 -0700 (PDT)
Received: from avogadro.redhat.com ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ov4sm7792391ejb.42.2021.05.24.09.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 09:22:39 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: SVM: make the avic parameter a bool
Date:   Mon, 24 May 2021 18:22:38 +0200
Message-Id: <20210524162238.380003-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make it consistent with kvm_intel.enable_apicv.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1c1bf911e02b..0e62e6a2438c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -28,8 +28,8 @@
 #include "svm.h"
 
 /* enable / disable AVIC */
-int avic;
-module_param(avic, int, S_IRUGO);
+bool avic;
+module_param(avic, bool, S_IRUGO);
 
 #define SVM_AVIC_DOORBELL	0xc001011b
 
-- 
2.31.1

