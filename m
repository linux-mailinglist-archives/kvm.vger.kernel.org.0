Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C892542229
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiFHA6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 20:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381301AbiFGXjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:39:02 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D8C1EDD2F
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:25 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 78-20020a630051000000b003fe25580679so485609pga.9
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EJfk8nwbrnmO1UuI866I8yMqvfudRDGtQGXb6HNwIrM=;
        b=cn1958um9WkdotZSF69FsUeBfSeTHbq+FyWFm/QqdUOkrDZ20ANQK0PPQrxi/NLkrE
         EOzpX4xgCHfHqrGscVBpazqOyxk3P+phvhtPDrTGhOxUsewtUdzwQHQaIVUg0xhSIXTb
         eMI18H3mg6NDelffkVysacbr4O/KHNry1/qOM9B+ptmEA3jvqd82zUILmyxqj3GOZmTn
         JBd2U/5PRnm/VVZBlu9TSd1gbDdXCDHSkQKJ44gSooijmAJPLmXhMOgOyy2ZbGk8cIV3
         mx2S3mDkwmj8zyAyHIfRq2V6TNIMTeyMzG/0cVYzVOSxBmrwSEEstbIEfIAWeE0sj+/p
         G9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EJfk8nwbrnmO1UuI866I8yMqvfudRDGtQGXb6HNwIrM=;
        b=IsnoXa5lE7OTHeW1vBbKrQNQNPinLylTF2aiwpiKbAp3imHkoXdSjzKloByAKIBQ7H
         skH83rcAweb5rLAEnkqcIPqRamZzvTYJ9VGFBfHLuEiLnde+KIdhdxqEyp5aUeZy/9QE
         vSCllwfwWf1/1Nr5CZ0ao0nZ7upKT/SaTpl+7ab6L16B/fMBOdCAVdEB9ZWYVHtuo2ss
         jMAWgwQ1k0JfBshaQ4B6dVaKJgrterQmtiEXbae1Rg9mmYscKk8S/8udWQvqN6u6013t
         X1fYdwcUg6BhExZrIpTVF4qamla46kvp9cnJsTq4rQrVPMif7lL9Z3a4Sjegdkvdlh/5
         cbbg==
X-Gm-Message-State: AOAM532OBPXXwkNWE9BgtokT/0k3Eq8cESoHd3MfBPpws7ei6X2rPaV4
        HhtE+MnFj0VCPogrtEU7Xxo3bDyRzqQ=
X-Google-Smtp-Source: ABdhPJzHHxYpwDw7PZZ+h5cYuSRuLOiUBVayajr26XmFr4L8q40OPMapzi4SZKc/+lJsQarfzYlXjX9kFLU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:da87:b0:166:423d:f3be with SMTP id
 j7-20020a170902da8700b00166423df3bemr29143461plx.150.1654637784762; Tue, 07
 Jun 2022 14:36:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:53 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 04/15] KVM: nVMX: Rename handle_vm{on,off}() to handle_vmx{on,off}()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
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

Rename the exit handlers for VMXON and VMXOFF to match the instruction
names, the terms "vmon" and "vmoff" are not used anywhere in Intel's
documentation, nor are they used elsehwere in KVM.

Sadly, the exit reasons are exposed to userspace and so cannot be renamed
without breaking userspace. :-(

Fixes: ec378aeef9df ("KVM: nVMX: Implement VMXON and VMXOFF")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9a5b6ef16c1c..00c7b00c017a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4958,7 +4958,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 }
 
 /* Emulate the VMXON instruction. */
-static int handle_vmon(struct kvm_vcpu *vcpu)
+static int handle_vmxon(struct kvm_vcpu *vcpu)
 {
 	int ret;
 	gpa_t vmptr;
@@ -5055,7 +5055,7 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 }
 
 /* Emulate the VMXOFF instruction */
-static int handle_vmoff(struct kvm_vcpu *vcpu)
+static int handle_vmxoff(struct kvm_vcpu *vcpu)
 {
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -6832,8 +6832,8 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 	exit_handlers[EXIT_REASON_VMREAD]	= handle_vmread;
 	exit_handlers[EXIT_REASON_VMRESUME]	= handle_vmresume;
 	exit_handlers[EXIT_REASON_VMWRITE]	= handle_vmwrite;
-	exit_handlers[EXIT_REASON_VMOFF]	= handle_vmoff;
-	exit_handlers[EXIT_REASON_VMON]		= handle_vmon;
+	exit_handlers[EXIT_REASON_VMOFF]	= handle_vmxoff;
+	exit_handlers[EXIT_REASON_VMON]		= handle_vmxon;
 	exit_handlers[EXIT_REASON_INVEPT]	= handle_invept;
 	exit_handlers[EXIT_REASON_INVVPID]	= handle_invvpid;
 	exit_handlers[EXIT_REASON_VMFUNC]	= handle_vmfunc;
-- 
2.36.1.255.ge46751e96f-goog

