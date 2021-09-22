Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0505B414980
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhIVMsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbhIVMsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:48:46 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1545BC061757
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:16 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id l22-20020a05622a175600b0029d63a970f6so8025331qtk.23
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vKd/FRP6xsxd1NyZwlcpU67d7iFrsPIxsqbAVx8bTdw=;
        b=aoIrsXHec9SBUmB+2mcUIKsJUltZUnhZAmwED91yXvPDDH0hn387xceQEQTJMcldNT
         2/Yjz04rygS5eguuM37aCW/UMofNUEYKQKeP2SjXwr08kQ3ncvFkQ5JQeH41ty2yU46R
         rGtvzSwn4DeRWawKnVMIpy436eIkv1KWDE4Y62bEBmV6HAL1e1Kel099zJP8AIObK+d6
         Xi0nagwlCUrhFZ7EW0HgoNJgH32UGaxb+pykycp/hk/wSSAVzoulC84CUgvvOLjgCr4a
         0zSLJuvf+ceTqnNHfqlUoL/CBh9gJXMITqMt58WAlHud/B13nefjnyxrAdFViTNlC9g/
         C8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vKd/FRP6xsxd1NyZwlcpU67d7iFrsPIxsqbAVx8bTdw=;
        b=ljoIK5Qsff58z13uQbjUudXSogGxdJ4RL6KrX6Kd7QAz1pkv5PhoOxRD/GDYAzwAKh
         jmDMdSuwuh1oRNpFw7WJr+YCqzkH3HSxsvWiGLiHeRhrRHHFs35+K7JjkwrpQzb+yYqy
         KSFT9SW/OXr1pZe+vzTWv6omMjP/94r87xWI+39+/IJMM6rDkRESoMtlq7jcvh8Dq0AO
         KsBY4C7NxgrbXkDOQSD4pFVtw/48TGqzKOMilfwbwSthdbE2W8dWTDbuLSpeEF96INLJ
         Mj6sU+yf0paXBTqLCHsxSvphGs4pwu4YQ04wzwhRY9ikHbqJ3aPWOk1AjYnucDAZ0MOv
         rajQ==
X-Gm-Message-State: AOAM533Hxc+osaD6HFGcfLDkQgtiC/ku79JQ05aGxTguDYejGyEifnRd
        MiQAovdJHkXU0wuC/ykB7NHp1EBGEA==
X-Google-Smtp-Source: ABdhPJxK+J/4nEIn+GrBuqd/cPmlWnyMGlRJcdSlgCB8WvLAhxMnGsnFlZ1r4pp0DunJBFb+U7LxVLudDA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:55b3:: with SMTP id f19mr36952746qvx.16.1632314835185;
 Wed, 22 Sep 2021 05:47:15 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:46:56 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-5-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 04/12] KVM: arm64: Add missing FORCE prerequisite in Makefile
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add missing FORCE prerequisite for hyp relocation target.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 5df6193fc430..8d741f71377f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -54,7 +54,7 @@ $(obj)/kvm_nvhe.tmp.o: $(obj)/hyp.lds $(addprefix $(obj)/,$(hyp-obj)) FORCE
 #    runtime. Because the hypervisor is part of the kernel binary, relocations
 #    produce a kernel VA. We enumerate relocations targeting hyp at build time
 #    and convert the kernel VAs at those positions to hyp VAs.
-$(obj)/hyp-reloc.S: $(obj)/kvm_nvhe.tmp.o $(obj)/gen-hyprel
+$(obj)/hyp-reloc.S: $(obj)/kvm_nvhe.tmp.o $(obj)/gen-hyprel FORCE
 	$(call if_changed,hyprel)
 
 # 5) Compile hyp-reloc.S and link it into the existing partially linked object.
-- 
2.33.0.464.g1972c5931b-goog

