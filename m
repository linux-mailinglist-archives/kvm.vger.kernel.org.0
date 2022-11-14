Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11706279BD
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbiKNJ6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbiKNJ50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:57:26 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DA71F9E7;
        Mon, 14 Nov 2022 01:56:52 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id j12so9596212plj.5;
        Mon, 14 Nov 2022 01:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHXylZQvPkKg9YRk/My2nXgPbyRXz0efTEnwBB4Zh7E=;
        b=No5nQ8OGpsAJ1HGg3Ujor+9jh7yqxyoSyG7j6rnDLgsxAvrdmx+i8e9RvkulPMVMMM
         fMFVb+8JGj4BJzDdV6y1xwo7Mxjic/feECoCBjwygy7XmJsVUVt0MwGRJgx0k5cI/KE8
         Umi7LVxs4yEWpQxdjQY91uXt6m92sTwncmwZxCMu0VHWaNmcigq5gUkuFBuXlYq7WYXj
         3HwCZ8UpHT7iqdXEQDJ8pNUb93+mkm9x8loazezqOSm+AAV9z+0iYfJ5bQQrHhqav8jz
         k0dtDmPFPjjJ8FflsuvVKQvcJvIcl4faSD8EDxe1JrLT3vFswFmzvf206Pplz8UVlko9
         MugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHXylZQvPkKg9YRk/My2nXgPbyRXz0efTEnwBB4Zh7E=;
        b=mrCSmBIhq3ERY6JwRQbm95+SWoqOYAwUAIS4kfQ41eLa3EcfsXzzAEg4dfHxQnSclt
         SKcGuOEp4JFjwcyRCXIJUABSRi3seDjoNz6Do0SCDu6bJkXGhIk9GWXxUpmh+uHvGIbY
         6VISvmjijJQnadHXYA94f4QXuJD/T3TDuDSOBF9JleOEn6A/CRLMOxQmv8X+M1mRr3Lz
         qTFjRen/0LtwPpy19tJxLGFkHrXl7HXjOF5Heho3ZV5FBlGgoM32mJmj2/mzRd+r+dfE
         SvuLD3X8kHYFqqXyiKDhTboH1GpoUZU7VeedCeIgC8oHiBAtsNy55JGqBDdlZ5KaWXDQ
         CsFA==
X-Gm-Message-State: ANoB5pnaCqx1MzbzbT6ihh8H+LL9ohRl5z39/Xkh50MAx4XZlZtHdPRB
        w9aq2dcEn5g7AMuIy9KLUdk=
X-Google-Smtp-Source: AA0mqf6KzxOQ2r6jOPW1epE/CfEQLV0eVgb8HzJeT1Vf+F+3YgERCy8FCibCxQb8Qba5ItFpDsq6tQ==
X-Received: by 2002:a17:902:ea05:b0:179:fe95:f6d9 with SMTP id s5-20020a170902ea0500b00179fe95f6d9mr12582203plg.51.1668419809926;
        Mon, 14 Nov 2022 01:56:49 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:49 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] KVM: x86: Remove unnecessary export of kvm_vcpu_is_reset_bsp()
Date:   Mon, 14 Nov 2022 17:56:02 +0800
Message-Id: <20221114095606.39785-11-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114095606.39785-1-likexu@tencent.com>
References: <20221114095606.39785-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

Don't export x86's kvm_vcpu_is_reset_bsp(), the helper isn't used by
KVM x86's vendor modules. Move up the code block out of existing
callers' need.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f325710a4f25..f3cb3e02bfa6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11496,6 +11496,11 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return static_call(kvm_x86_vcpu_precreate)(kvm);
 }
 
+bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
+}
+
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct page *page;
@@ -11993,12 +11998,6 @@ int kvm_arch_check_processor_compat(void *opaque)
 	return ops->check_processor_compatibility();
 }
 
-bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
-{
-	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
-}
-EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
-
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
 	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
-- 
2.38.1

