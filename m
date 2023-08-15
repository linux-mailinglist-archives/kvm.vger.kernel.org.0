Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41477D540
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238894AbjHOVgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240351AbjHOVgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:36:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BEC1FCA
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:58 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-565aee93236so2952514a12.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135358; x=1692740158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5htqcXlGR48S3bix4KQFlJHZscL9sK8wNsMNCEa/blA=;
        b=Zk+tB7gzteBvpoOVWZ93sOqgDN/4qLNDGkzUSOPo8c/LXzjJ8h85ibn1YLVhAERiz8
         cEEUxZJ1MbfFQUVKhtuCw9/mueNfpYJmEN/qoahPn78RJ5HFmGVZyfkenmqPYndKsFDG
         d//ppkrYcZ2gdlFiTgmJUSZ0MyYKX3saNwgRaZMm4nz8PvzRc6ZGIOgit523gFh+DZgh
         u07AxJDGrhNUg6otI1ZGHL6OzrYzrJijDEJAhtLfxzjue6eU3MirrcJqOBD8sSZgwcwX
         Q32dJUZAxPwNE+ARQ4ubEy0VPVxEO5L64+V75raPf+hF0cUsvxckNki3sphpTLYyXwmi
         12lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135358; x=1692740158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5htqcXlGR48S3bix4KQFlJHZscL9sK8wNsMNCEa/blA=;
        b=KNL1NeHTtNVEJ3a+Akb6+yDWT9//RcfGLB89G6dTdHzvTrg4tfQM3DHEHZ92ltJ4nI
         jAe+Z8CQeHjrdtcCFykY1+AzjStSztzEo9jAMiktmvR1IDI4QSmusnZzGhDDgLbWTwb4
         JAH9a9xEU/eLHUZEndmNiQCgtoIJoM9ZdNdY/LpVSGrEBLswhAlTOgFTFIZ2QQtnJpEt
         ZOMAyZWVkXsizxtUWCk6zkt/9oDXZIO6YT40zKNM4p4yB/jYpa5NDfjkOxt70zi8Z+s+
         SPzsW9EbShPDawtrx5g2xGPB3XVU2kpOYbjBRojZCRrnuk90R6LSSGEoN6dc31skGzgl
         e6vg==
X-Gm-Message-State: AOJu0YyDyDOQbI/tcWmJp7bJIlZeZ0qhY01E7YCJUE/xvVu/2VI5oImo
        ogpYLU0aKugM340zzgcVQxlZh6Jzt48=
X-Google-Smtp-Source: AGHT+IGcI4ph95Gs7JodHbEwJ7O1llYZ+9O4HY1NoWEkoEoV07dwpOKAONjIa8qpQqKt1nWRe0LQ+mQlSlI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:77cc:0:b0:564:1f95:71e5 with SMTP id
 s195-20020a6377cc000000b005641f9571e5mr13554pgc.2.1692135357795; Tue, 15 Aug
 2023 14:35:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 14:35:33 -0700
In-Reply-To: <20230815213533.548732-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815213533.548732-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815213533.548732-11-seanjc@google.com>
Subject: [PATCH 10/10] KVM: SVM: Rename "avic_physical_id_cache" to "avic_physical_id_entry"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the vCPU's pointer to its AVIC Physical ID entry from "cache" to
"entry".  While the field technically caches the result of the pointer
calculation, it's all too easy to misinterpret the name and think that
the field somehow caches the _data_ in the table.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 10 +++++-----
 arch/x86/kvm/svm/svm.h  |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6803e2d7bc22..8d162ff83aa8 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -310,7 +310,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(table[id], new_entry);
 
-	svm->avic_physical_id_cache = &table[id];
+	svm->avic_physical_id_entry = &table[id];
 
 	return 0;
 }
@@ -1028,14 +1028,14 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_vcpu_is_blocking(vcpu))
 		return;
 
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	entry = READ_ONCE(*(svm->avic_physical_id_entry));
 	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
 	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	WRITE_ONCE(*(svm->avic_physical_id_entry), entry);
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 }
 
@@ -1046,7 +1046,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_preemption_disabled();
 
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	entry = READ_ONCE(*(svm->avic_physical_id_entry));
 
 	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
@@ -1055,7 +1055,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	WRITE_ONCE(*(svm->avic_physical_id_entry), entry);
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8b798982e5d0..4362048493d1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -261,7 +261,7 @@ struct vcpu_svm {
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-	u64 *avic_physical_id_cache;
+	u64 *avic_physical_id_entry;
 
 	/*
 	 * Per-vcpu list of struct amd_svm_iommu_ir:
-- 
2.41.0.694.ge786442a9b-goog

