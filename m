Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBFB2DF87A
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 06:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgLUE7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 23:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbgLUE7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Dec 2020 23:59:46 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C23C0613D3;
        Sun, 20 Dec 2020 20:59:05 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id o17so20669524lfg.4;
        Sun, 20 Dec 2020 20:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=unRCK19RnOG0K4e4ojB7ZknF1FS3owpYWw6LZSCZWKM=;
        b=WXimt9ZqQazhrazL7tdbYTQFjznffVFqe9v10asT7fAHc9stiDhAo0JOcNAJ644swH
         a41teTOxfrp762Km4Q1ABOzLzddsuveuEi6wYRXI8QjGze7ybB90frSIZxaMwueLnXKw
         mSLccJwArtVeqmW8OSPFFwDpmuIpwA/DnwiTL4CYgpzMrNx0dlrfTmgRQN/4KwVssqXb
         0VcSwvkNWRUwM4tFkkqVoE1scVslKEJ2gqGttLe2EDyDbvCQWkTFhWeLdUo4/iyDYdUs
         F3nCcwRxfZPy2by2sxFXQeeHOJ3Hodfcko5QPvF1fNSgRPCP+wQUdvS/C2FywEO6z5kA
         AmhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=unRCK19RnOG0K4e4ojB7ZknF1FS3owpYWw6LZSCZWKM=;
        b=B8cNcTX7lNU0cCpmcyT/ZtHAcg+Vfta9j7Kv5tPEEC4SKIOTKos/NkCai4AGqTa1IT
         zdvBKEyU1/BZIqoDkCo4wfjDa9nX2eGm6Hb2Ik+nr61x38P7ZBCn37SMTrxT6k4TJxOi
         aUq39V69Oh9eqnvM8/zO6gJa3BKnwPr5n5dF0/dXvGouRula529m4jnNz8iJwAY7BFdN
         Yf9FLr4H86/LiV/wQ+kULvSE+xCvUek89Igkb4mlhFgBedvoJaxLFts6rNdoQDRBe6YI
         uQm8Z6xQnsLBzi8hqHqGe96LJJitVgA4k5J8yelLxzCwJ4vjEBjIblXpgQblF1/aiEyG
         vzLQ==
X-Gm-Message-State: AOAM53391WCUvZJAs0qj63koOynyX/V4M3p1iqhG9fuGY+yUIEAMRsWp
        CY/Q7i/Fi+1uvfg0cZDuazhuSj/T0AzgTA==
X-Google-Smtp-Source: ABdhPJwJijRrmDQgz/jVqwAQgA4C383ztgJSybF0QPfUVcKKmFCkqxj9Zfu7IU2I1NcZ1CtNNZx7Gw==
X-Received: by 2002:a50:ac86:: with SMTP id x6mr13296986edc.197.1608494626131;
        Sun, 20 Dec 2020 12:03:46 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id n8sm8279380eju.33.2020.12.20.12.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 12:03:45 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM/SVM: Remove leftover __svm_vcpu_run prototype from svm.c
Date:   Sun, 20 Dec 2020 21:03:39 +0100
Message-Id: <20201220200339.65115-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 16809ecdc1e8a moved __svm_vcpu_run the prototype to svm.h,
but forgot to remove the original from svm.c.

Fixes: 16809ecdc1e8a ("KVM: SVM: Provide an updated VMRUN invocation for SEV-ES guests")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/svm/svm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 941e5251e13f..2fa9726564af 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3675,8 +3675,6 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
-void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
-
 static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_svm *svm)
 {
-- 
2.26.2

