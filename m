Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360DC606D5D
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 04:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiJUCBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 22:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJUCBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 22:01:41 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA10158D6B;
        Thu, 20 Oct 2022 19:01:30 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1322fa1cf6fso1848684fac.6;
        Thu, 20 Oct 2022 19:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YdzOJOMp3iuApr/okaLbQxJBg60Ua+Xs/gbUXlPqpGM=;
        b=njo16UXgO+1o9eUppTiFe2BLKC+zVAt1yBR9ecka9vPXB6NWtIhBKdFbOn9Hu8az/s
         2sNTmPKqbkj+ozLbFLXVL8k3Nn2GUj+V48Q6/IaJv5qYrLAXyb/dCwmL68WyFLlaMckH
         OKu+jiX9nWwhplCgTcS8YljV5FX0yuPAIBDbL8oF5s6iU/9/voetgBQ1u7584+CESaPl
         XBlWoAMY+Fml4RmGVAj8+tCLkbEVHEEd6gxZY2oyfYXVwqCeI2R3a0Q1WkEvqHjeLHS4
         5hsJX+odYPuXhTYuXiyuLn5C69NE0y4+EQh1Yg1o638Ti/52ZygcDDfU0oHxjHrrtKIK
         Expw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YdzOJOMp3iuApr/okaLbQxJBg60Ua+Xs/gbUXlPqpGM=;
        b=UUc3Vvemi7+HbAE4TYFiedPaFgpX4Y7xgIG5aoYgRbr0Bp8Y7kzmtli2/FQLxeGZ/e
         icsoBMnzM90TRHIBe3nRVrVCrVrzuhsaBF/9Hd/mZoyNmulUjXH+WPt8m7yBG3l01Yhx
         TmoFnZfXj6hHKyZYx9/Yv0VuhLam0tSE71LYZCtkzEXvbTlL01PWcHuEE6vQ/qjrcA4r
         tPw0EiMdx/nQ8SKqTbsjbkWgY+5+xQj6OKb4iE2VDbgrwMPLkg45y9t4ISbTVkrn49Yl
         u4VrWH8stK9JxvafuomKqtXYJcKX2LgtS+lL0OR73xwE4VoZvMaV+tmbdasZFjnBdO1f
         aFXg==
X-Gm-Message-State: ACrzQf0kKMhPGukmVbFhVIjSAWZPbL8P1faXeHpG4V4fb0bxakriQ/TT
        FCIB7RTtdefjdUEnZZSI431IJnuBn4cjoA==
X-Google-Smtp-Source: AMsMyM7gGYC1s2XsPs52Fsql7pLOSY5ZVdPs6ExthQPTuSV6oAIgivKix4z3NQ7n9NerKQcdbCLKCA==
X-Received: by 2002:a05:6870:e74b:b0:133:1f1d:d7be with SMTP id t11-20020a056870e74b00b001331f1dd7bemr10988823oak.121.1666317689374;
        Thu, 20 Oct 2022 19:01:29 -0700 (PDT)
Received: from macondo.. ([2804:431:e7cc:1855:fc19:f361:478a:f673])
        by smtp.gmail.com with ESMTPSA id s187-20020aca45c4000000b003436fa2c23bsm641681oia.7.2022.10.20.19.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 19:01:28 -0700 (PDT)
From:   Rafael Mendonca <rafaelmendsr@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Rafael Mendonca <rafaelmendsr@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/kvm: Remove unused virt to phys translation in kvm_guest_cpu_init()
Date:   Thu, 20 Oct 2022 23:01:13 -0300
Message-Id: <20221021020113.922027-1-rafaelmendsr@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Presumably, this was introduced due to a conflict resolution with
commit ef68017eb570 ("x86/kvm: Handle async page faults directly through
do_page_fault()"), given that the last posted version [1] of the blamed
commit was not based on the aforementioned commit.

[1] https://lore.kernel.org/kvm/20200525144125.143875-9-vkuznets@redhat.com/

Fixes: b1d405751cd5 ("KVM: x86: Switch KVM guest to using interrupts for page ready APF delivery")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
---
 arch/x86/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d4e48b4a438b..cf886f86038a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -349,7 +349,7 @@ static notrace void kvm_guest_apic_eoi_write(u32 reg, u32 val)
 static void kvm_guest_cpu_init(void)
 {
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
-		u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
+		u64 pa;
 
 		WARN_ON_ONCE(!static_branch_likely(&kvm_async_pf_enabled));
 
-- 
2.34.1

