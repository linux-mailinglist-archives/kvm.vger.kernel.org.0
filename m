Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AC751B274
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379318AbiEDWzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379494AbiEDWyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:14 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2432186FF
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:37 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s18-20020a17090aa11200b001d92f7609e8so1087376pjp.3
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ics5fKQO8hYOFNHtV6D8SXzwom3B/0Woppu9zPFokPE=;
        b=n6riCm3IAmq/UZOcFxQGvdC1OcCB6v0Ts/YtqCboYuFN+Fgci6lFBpkgwFHgYF38A4
         SVcyWgFf/F4LGtlz14qoVNsAthZzzQxuJIlFYkSf+VWULBFfSU4ocUOnsMLTs3vBwxMa
         trUhLImFFbO/LIExgLu/adnqKp5YrCisYAqmMMdEJ1GkrmfBe5yv38c9VIx7c4cwOJJ3
         /sl3Cp6Z79bC/G4O2UCG8+NTYqoIGeEEWME8jvPCHb/W+ndri+IWPZ5lBX16Dbknnx1z
         AkTqNlTQcSuZ+7y6aN0Ds0S6l9iUi2gUSLu0pUhslvSY/VxGo2sxYC7lVog4rY1UkR8S
         wprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ics5fKQO8hYOFNHtV6D8SXzwom3B/0Woppu9zPFokPE=;
        b=boEujxdRZE0oUlFTvsamxUxsFQFQaj5fAbE25OCl+yXvhYDJjHqfyXMkLnBFlfvJgn
         z79QDynO6vyHFvtOOf53LnZT5iCqH7DMR6n7Gpw0L++EZ2rDfi1jmX81ZY3v94CyP/Yn
         +of7ghFU4fRSNx51DJMSJ927FEzFXA0t3xOh1kZbZIBzPkUagYCy3K57cAgsqbGG4mIY
         W/bbIDF7lC/Cp5hgeIc2kbrrcfzs9FMSqpgowPYAWixFeMVOKCn7s9Ta1ot4wHPzNsUB
         o5p58J4gon17srwRHDKR0vbaTNboA6YHZhFOW37bHTRA2Bcldj+5X/9LWzB+Vn1m0EFS
         ug0g==
X-Gm-Message-State: AOAM532+F0Y3EjAFXX+n2Inn5JVF3BNqpZvKIzUw0yUeiIXv2AXutqrN
        YLgisOLBeAvjQnKw+fBpAGASNuwJ+oY=
X-Google-Smtp-Source: ABdhPJyq9dcELUdCxvX0YR9FeHkBJppQMhPVNoV10ItN/sA0vbwtuzl0rtZBr+SBbfd3syl2+f5a0udgONE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d48d:b0:15e:c236:4fd3 with SMTP id
 c13-20020a170902d48d00b0015ec2364fd3mr6868487plg.113.1651704637188; Wed, 04
 May 2022 15:50:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:44 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-39-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 038/128] KVM: selftests: Rename xAPIC state test's vcpu struct
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Rename xapic_state_test's kvm_vcpu struct to xapic_vcpu to avoid a
collision when the common 'struct vcpu' is renamed to 'struct kvm_vcpu'
in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/xapic_state_test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index 0792334ba243..9d8393b6ec75 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -11,7 +11,7 @@
 #include "processor.h"
 #include "test_util.h"
 
-struct kvm_vcpu {
+struct xapic_vcpu {
 	uint32_t id;
 	bool is_x2apic;
 };
@@ -47,7 +47,7 @@ static void x2apic_guest_code(void)
 	} while (1);
 }
 
-static void ____test_icr(struct kvm_vm *vm, struct kvm_vcpu *vcpu, uint64_t val)
+static void ____test_icr(struct kvm_vm *vm, struct xapic_vcpu *vcpu, uint64_t val)
 {
 	struct kvm_lapic_state xapic;
 	struct ucall uc;
@@ -75,13 +75,13 @@ static void ____test_icr(struct kvm_vm *vm, struct kvm_vcpu *vcpu, uint64_t val)
 	ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
 }
 
-static void __test_icr(struct kvm_vm *vm, struct kvm_vcpu *vcpu, uint64_t val)
+static void __test_icr(struct kvm_vm *vm, struct xapic_vcpu *vcpu, uint64_t val)
 {
 	____test_icr(vm, vcpu, val | APIC_ICR_BUSY);
 	____test_icr(vm, vcpu, val & ~(u64)APIC_ICR_BUSY);
 }
 
-static void test_icr(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+static void test_icr(struct kvm_vm *vm, struct xapic_vcpu *vcpu)
 {
 	uint64_t icr, i, j;
 
@@ -116,7 +116,7 @@ static void test_icr(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 
 int main(int argc, char *argv[])
 {
-	struct kvm_vcpu vcpu = {
+	struct xapic_vcpu vcpu = {
 		.id = 0,
 		.is_x2apic = true,
 	};
-- 
2.36.0.464.gb9c8b46e94-goog

