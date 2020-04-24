Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C68D1B72AB
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgDXLIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgDXLIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:08:05 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D019CC09B045;
        Fri, 24 Apr 2020 04:08:05 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id h11so3603188plr.11;
        Fri, 24 Apr 2020 04:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Apq9sucfBmwOGXvj0V67gdzCLVL91nlJK5leKBoTGWw=;
        b=DPlNjwBC/2Hg8ifwjXtL0aRTaYR30jpp536Zy0zkEhSjbHn2yiNsO1haYnE6CCbkXy
         bobGSZnil5VbFBQgE6lJqFtvp2zjRh98DnVpY2J/l7uGwqPX3wJLCv+8xrsLFWyR2OEq
         H66RAnuPMjNOBg8riiKJ48ugG7I7tfcNSsUjgLElrhNRGidz6DAW1b3FEcrlkugtnIJD
         XY5xJjWTBJL/m54eMqEwb+HhW2PNmNOxiguMlUfi3TCSjHtmPZ4Ge2EwWFRpuZZAHx9h
         eEK0WvdcD2rasnOorTHVUTxxVCqJSr05fwawWhj+mdsE+d0SCd9n51AAQJdz3rXuSKzF
         TxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Apq9sucfBmwOGXvj0V67gdzCLVL91nlJK5leKBoTGWw=;
        b=B4rSDKi4b5Sl6grPuy78C+wxq4xaimHgBfsOCiGyGEURHMzjv7FWCcgXbyWuYiVOd/
         g5Bc7bXNYbX3Zh1/XCT5UQuACqM8khlSvxkxu3J4p1kwrdHxNGatmtY10Sb3BV1RDUyT
         CT0YWac31KwwOzem7qcj61hjqu5cS3BVbmt7t6nah0GIO9xbd3LAVC/QdIB32YCMjPDk
         Q0nCxOKphhrTfkCLzAjdil5E5i0mJV0Wy0vRL2g843VN62mz/l4360toxcjszD326tiR
         1+0GAN00wC9Y9XrbN4BnBsrXx3VN0D6w6jX3AbfGlvsdit83Efit7udlT63BruHfUrsR
         ohig==
X-Gm-Message-State: AGi0PuY3gEff44CFj6GyyT2MrVTGnlQ9d+cLO9wSd9djNnEeOJg/HsSZ
        9WstMFS+NSrqG6ZNSSmJrd8=
X-Google-Smtp-Source: APiQypIAD3ehZub+RwyxVW9kCT3Z78tQo5EfASIt5EHeQ8zghM0DHayoX8gy71GcuQNaWpjveDEg1w==
X-Received: by 2002:a17:90a:2ac2:: with SMTP id i2mr5567560pjg.91.1587726485250;
        Fri, 24 Apr 2020 04:08:05 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id y10sm5470110pfb.53.2020.04.24.04.08.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:08:04 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 03/14] KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
Date:   Fri, 24 Apr 2020 19:15:22 +0800
Message-Id: <1587726933-31757-4-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 based machines can have as many as 16 CPUs, and so does
memory slots, so increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index caa2b936..a7758c0 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -78,8 +78,8 @@
 #define KVM_REG_MIPS_CP0_KSCRATCH6	MIPS_CP0_64(31, 7)
 
 
-#define KVM_MAX_VCPUS		8
-#define KVM_USER_MEM_SLOTS	8
+#define KVM_MAX_VCPUS		16
+#define KVM_USER_MEM_SLOTS	16
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS	0
 
-- 
2.7.0

