Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089065A80C3
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 16:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiHaO62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 10:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiHaO6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 10:58:09 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195C5D75A7;
        Wed, 31 Aug 2022 07:57:43 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 78so229333pgb.13;
        Wed, 31 Aug 2022 07:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=4kUs7trGJu1KRDHo41riJpe6dxzvJkZn5JHXD+Xl5No=;
        b=OFUS7Qy4/4rnEQMYoYxeKb8BnpwqfleoQO69vE2Y2hcPV7S5ZVl9pj0QM8XhZcEC1B
         0CGnKjqPvc7JXczVKpe4+4nusu7PPxAvsF+AMlIbJtWG4JBqelDredwiHN+DnJtem3Es
         3P/WMEcYKqAinv7ouzxOF4MlilQhGOitGSw+OkxMTMQhGq6QoUpza6TORg8Y9xfZQo0j
         JbBvccNomnNfLWBwWJMM3vfqJN5zptYXso9bJpIZ8jmsgI5Xn267wJ51nxnZnLHAiIS5
         IPlL8E0HSYYSRx6u7UXMFfdvp6qbs6DczWYWP096Mjw/hb+emAkPRiUps7MQMmnNYDQB
         kCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=4kUs7trGJu1KRDHo41riJpe6dxzvJkZn5JHXD+Xl5No=;
        b=G9oK1NzQHmqqpsi14C1dVDb/IiibmRDI4ILcaog5fo1T4n5N/Hu3bAQxI6Bqz8qpwr
         jxkCTCNqdnKPH9odoRk/MTwiZnv3OHuMjHXoBjVflzb20cMacyfTz60zWMDdNkAcnM5V
         ePtxN8qqaO6LSq6A16PyKrUUAm2DQwpsvcEVuFFfuHeS0zuggvV1bSQfqjQujg0spMyx
         /4YMkIu+S5Byc/s6OBki68HVTGupGOqv1NuXodxKK8oiSvuOwxvnzojG/KEfSMzcy5YW
         P3vdQQt0jFPN2mfczEvb2uxzsR7zbppeyU29vhAoTACBq9QjJCSv0Oeoi7VUhrGr/qju
         2zHg==
X-Gm-Message-State: ACgBeo0ir/dnDPUWKrXoEu8AoBK1B4JrZOgBzVSbjZSht619PDd8tERG
        HKhloaA/rVhQpGkHP8PBq/k=
X-Google-Smtp-Source: AA6agR6BxnZAyLbjUVdI2sI4LXY9H9OGqJiHnMq2CG7ueahnQYHGoEUlD6l4SCMEk67k06J4X3ILcg==
X-Received: by 2002:aa7:9739:0:b0:538:4931:f7bb with SMTP id k25-20020aa79739000000b005384931f7bbmr13794039pfg.68.1661957862220;
        Wed, 31 Aug 2022 07:57:42 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a77-20020a621a50000000b0053679effc03sm11734452pfa.149.2022.08.31.07.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 07:57:41 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] KVM: x86/mmu: remove redundant variable r
Date:   Wed, 31 Aug 2022 14:57:36 +0000
Message-Id: <20220831145736.304864-1-cui.jinpeng2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Return value directly from kvm_mmu_unprotect_page()
instead of getting value from redundant variable r.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 arch/x86/kvm/mmu/mmu.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e418ef3ecfcb..23f1ab9e521f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2633,16 +2633,13 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa;
-	int r;
 
 	if (vcpu->arch.mmu->root_role.direct)
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
 
-	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-
-	return r;
+	return kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
 }
 
 static void kvm_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
-- 
2.25.1

