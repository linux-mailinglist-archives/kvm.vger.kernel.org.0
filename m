Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C20D53C1C5
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240644AbiFCA5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240938AbiFCAuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:17 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4AB28E22
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s2-20020a17090302c200b00158ea215fa2so3492312plk.3
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=m+UkKD8zfYyaw5dICDDb4lul7M0XYWsAbXRSSleGEkE=;
        b=bumzTk2U/NhSUJymaQJZo+xCmIR/LVIptbfTbsl1kFJfmPlWlp7+dQ5GyvcMKYU3Qz
         T+DV2OKIUEr/8OwqTDRsXno3SCLcAr2iUw3DUGjnJ2jyBdnLbFbhaQ88wcw2iSHd+ASc
         k6vCk1IE96PkOzRqyE7emFixovrrXIxGIyEQWYwoxF+l+M8XluoExKO25YnuIO/7wYOL
         kp8qG4guk0m5ynNbIQ9D+nJhLoJCCA/fpyycpEUxgYsmrlVtYr+UY0fhjN1yVzX2jJsH
         O4Ex3XkeS2zKDLC2HrJT4LWKhc90HoeKzbRw9Mg25kWo4r4QaRALTmdOH55gA3GrETx7
         y10w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=m+UkKD8zfYyaw5dICDDb4lul7M0XYWsAbXRSSleGEkE=;
        b=CFgMAXeJiesE1o40uqtOCuVJ2cXBXBiX3yyBDyhXYABx6toDhDtm5hblDHLYPb5TkB
         HkGvPEpyg4WpcNsNXzNw0YYfc5U/6p+z3hdC/OcwFJW2FNGn5ukKC0B8N64K7xI66xzQ
         Ftlg6h+LFj+zNJYUrcaIa4DooMANzvXq6kPylBbDhkzUg/5N7EisGpLYjMA8cPCGl1RQ
         MeWCrrVD0gX8QxUvnzyh0DIBKVr0lk9+L+S5d42HkBax9hW9bNzw8C5KZUfPMTL6SqPO
         o97ybjBRbGAOqqHyEn+K6xI5RnvF5XA09CncExOUY3vCW+ABWg7KVaKKvbUWu3VEkhyR
         DY+Q==
X-Gm-Message-State: AOAM530HEp/biYJzUluN3Zikq1xjmCHPVNzEVfRoh1kvVmUi7Nrm1kQI
        OOIJliV9gxU1GeKxYDKs25Ix8Wpv3uI=
X-Google-Smtp-Source: ABdhPJxFcOl4xBRc4T9lcmjMXu/s6E3FEQ2mHK/RyLSUsHMpSoOfiP+5Vf5ElPvR5NPO1rSa0dFf1Xm8BU0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:996:b0:50b:76b8:3bb1 with SMTP id
 u22-20020a056a00099600b0050b76b83bb1mr7870916pfg.9.1654217238479; Thu, 02 Jun
 2022 17:47:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:10 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-124-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 123/144] KVM: selftests: Drop vm_create_default* helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Drop all vm_create_default*() helpers, the "default" naming turned out to
terrible as wasn't extensible (hard to have multiple defaults), was a lie
(half the settings were default, half weren't), and failed to capture
relationships between helpers, e.g. compared with the kernel's standard
underscores pattern.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 23 -------------------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++--------------
 2 files changed, 6 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 9c29b6797ce8..90521c5716b1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -559,29 +559,6 @@ static inline struct kvm_vm *vm_create(uint64_t nr_pages)
 	return __vm_create(VM_MODE_DEFAULT, nr_pages);
 }
 
-/*
- * Create a VM with reasonable defaults
- *
- * Input Args:
- *   vcpuid - The id of the single VCPU to add to the VM.
- *   extra_mem_pages - The number of extra pages to add (this will
- *                     decide how much extra space we will need to
- *                     setup the page tables using memslot 0)
- *   guest_code - The vCPU's entry point
- *
- * Output Args: None
- *
- * Return:
- *   Pointer to opaque structure that describes the created VM.
- */
-struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
-				 void *guest_code);
-
-/* Same as vm_create_default, but can be used for more than one vcpu */
-struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_mem_pages,
-					    uint32_t num_percpu_pages, void *guest_code,
-					    uint32_t vcpuids[]);
-
 /* Like vm_create_default_with_vcpus, but accepts mode and slot0 memory as a parameter */
 struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 				      uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 132a591ba029..03a26ef6a611 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -337,28 +337,17 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 	return vm;
 }
 
-struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_mem_pages,
-					    uint32_t num_percpu_pages, void *guest_code,
-					    uint32_t vcpuids[])
-{
-	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
-				      extra_mem_pages, num_percpu_pages, guest_code, vcpuids, NULL);
-}
-
-struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
-				 void *guest_code)
-{
-	return vm_create_default_with_vcpus(1, extra_mem_pages, 0, guest_code,
-					    (uint32_t []){ vcpuid });
-}
-
 struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 					 uint64_t extra_mem_pages,
 					 void *guest_code)
 {
-	struct kvm_vm *vm = vm_create_default(0, extra_mem_pages, guest_code);
+	struct kvm_vcpu *vcpus[1];
+	struct kvm_vm *vm;
 
-	*vcpu = vcpu_get(vm, 0);
+	vm = __vm_create_with_vcpus(VM_MODE_DEFAULT, 1, DEFAULT_GUEST_PHY_PAGES,
+				    extra_mem_pages, 0, guest_code, NULL, vcpus);
+
+	*vcpu = vcpus[0];
 	return vm;
 }
 
-- 
2.36.1.255.ge46751e96f-goog

