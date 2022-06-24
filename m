Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76855A379
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiFXVa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiFXVaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:30:55 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD86869FA0
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:30:54 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id g34-20020a635662000000b0040d1da6ada4so1558935pgm.1
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=aVL8GM5UlCYwkYpjstIne4ze+uj4PFzbjfg18IJWQlI=;
        b=MNWyh9kWGEe9f3b2ZEyrpQTABz+TEx0AgE7yK61YYChhZL7DpPrgNJw4jZlShrPH/T
         6yxzaoxZaBvuHcdqqjG151wMMqI9GWvT+vTYyU8+pqY1vAmC0Vby0UZt58enP6mxuhOz
         hwgvzRX3qsiRUe9uezVcYWRZwbNL4DurMF99wwND4yZ9krO96vGb41YJMkO76M3cDHEM
         metf14q/h4Gfwimqb6G6rfwRVgJxjeupcvFyno3QqtZq/vLSk66tFvf5CNz38R+j3yxN
         bFAYk1w781QG4K555lmuC80JPNPT6FcRFRaYpj2+WrdQ5XXODK5MFTqSBdkf10lJvPo+
         bHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=aVL8GM5UlCYwkYpjstIne4ze+uj4PFzbjfg18IJWQlI=;
        b=q6Mzlx0rTel3DDujvJJ+wUaSyopGLxpV8p3BiHkv2EtPAQvIx+7oELNLlAIHqs7v8q
         3EHVrweyJsYbWf/33u0oXXG+L2sRf5I6sLmn5xn0VOseX68FQcJkfE5yxvELfULyv2fl
         6lQonNJD2gGzZZzeP6y/b9HYvFOkUNn7gFRSVXVAGSRX2w7I5WM98sbMSO10waM2NFyw
         W7U9FfLAv2PD0e017NmARgwuBQvukRIiE76DdDAWAy3lPiRVFGqJz+U/N6lLb/qoEsiN
         vb6xb9iJBv4dNgoMqa8cMDdVKyTTx105tkwidLeycP5dcIdn1LgekqcT3cX6E+34ipaT
         BkPA==
X-Gm-Message-State: AJIora/LYNw5zKurbX2trylnsR54XXaS65KB/+ruEM1bhYBNCH3B6ze1
        DL8cK+B0hERwK6Nz+sncS1FG11q3XGc=
X-Google-Smtp-Source: AGRyM1sMeT4iPH4Z55LvwsYjBdCB6PioE05w9SsEBuG3UpD3DTmlohwidwuec0jKYnkeFNx6hlYHlWLKjBQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e809:b0:16a:22dc:d23a with SMTP id
 u9-20020a170902e80900b0016a22dcd23amr1098100plg.119.1656106254367; Fri, 24
 Jun 2022 14:30:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 21:30:37 +0000
In-Reply-To: <20220624213039.2872507-1-seanjc@google.com>
Message-Id: <20220624213039.2872507-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220624213039.2872507-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v2 2/4] KVM: x86/mmu: Expand quadrant comment for PG_LEVEL_4K
 shadow pages
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tweak the comment above the computation of the quadrant for PG_LEVEL_4K
shadow pages to explicitly call out how and why KVM uses role.quadrant to
consume gPTE bits.

Opportunistically wrap an unnecessarily long line.

No functional change intended.

Link: https://lore.kernel.org/all/YqvWvBv27fYzOFdE@google.com
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b04e9ce2469a..83ca71361acd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2166,7 +2166,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
 }
 
-static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsigned int access)
+static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
+						  unsigned int access)
 {
 	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
 	union kvm_mmu_page_role role;
@@ -2193,9 +2194,15 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsig
 	 * uses 2 PAE page tables, each mapping a 2MiB region. For these,
 	 * @role.quadrant encodes which half of the region they map.
 	 *
-	 * Note, the 4 PAE page directories are pre-allocated and the quadrant
-	 * assigned in mmu_alloc_root(). So only page tables need to be handled
-	 * here.
+	 * Concretely, a 4-byte PDE consumes bits 31:22, while an 8-byte PDE
+	 * consumes bits 29:21.  To consume bits 31:30, KVM's uses 4 shadow
+	 * PDPTEs; those 4 PAE page directories are pre-allocated and their
+	 * quadrant is assigned in mmu_alloc_root().   A 4-byte PTE consumes
+	 * bits 21:12, while an 8-byte PTE consumes bits 20:12.  To consume
+	 * bit 21 in the PTE (the child here), KVM propagates that bit to the
+	 * quadrant, i.e. sets quadrant to '0' or '1'.  The parent 8-byte PDE
+	 * covers bit 21 (see above), thus the quadrant is calculated from the
+	 * _least_ significant bit of the PDE index.
 	 */
 	if (role.has_4_byte_gpte) {
 		WARN_ON_ONCE(role.level != PG_LEVEL_4K);
-- 
2.37.0.rc0.161.g10f37bed90-goog

