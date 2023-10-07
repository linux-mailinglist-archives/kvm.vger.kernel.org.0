Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE1A7BC517
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 08:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343589AbjJGGkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 02:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343561AbjJGGkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 02:40:40 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50746BD;
        Fri,  6 Oct 2023 23:40:39 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 46e09a7af769-6bd04558784so1976186a34.3;
        Fri, 06 Oct 2023 23:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696660838; x=1697265638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rPnJf4ACBTqap66/DGz7muRwHc2NwgeM+41OMr/ru4M=;
        b=bQfkyF7wdqoHllWwFf742p6lmaT/AbwN0xNVCZ8a+dMSgqFsuhKy0LVRzhS/o3bl6k
         8oUFgkCkdEVgggb2yRORnQHMnMRP0/rrLBw2ZJ8pXU2F0Jlc6quP3kC+pEorqiqF7iGx
         TuEFx3DhcTWU7XhC5JGJ9NYoVUBsCQpWWWqPsgScaGwHej+OyJc8QuqRqck/N0WXC5Wj
         jR1E6ureAr03l1ByIhxZ3rc+RBI7Oa/Id74emQ6oZ7SL5KhFMhPtnMG9AauloIjwHxuT
         VBd1r5183VU/xP+J2zGgGaf8BG+6O6XqJ4f1KFusdAnMRDNRlSMtykFs49fauc7qCcnx
         dhdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696660838; x=1697265638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rPnJf4ACBTqap66/DGz7muRwHc2NwgeM+41OMr/ru4M=;
        b=MeilnNx9Tb2Z5ued6p7b4stVjkFqDGi2xCZzfPZfLOSrJ186cywcjQQhp+UhI6O7LK
         XXD/is/uOONJHQUF7ctUEGhAa2zvudfEOQXL4A63DjrTIOvY61KTy0YMw4ii7Mruecm0
         XJyBIYQjnhQnTakrPA3qDN0KO7u3P/E9IaysO8mSxyGPNV4n/F5YAb0CcbNTbC97IneN
         OVkCgEdQQgzKqNM4ZxKMSUqdHpsK2oQmlJOq+1eybTpNieTKx/cxo7lPJVyk1PPKNmvx
         gh8FT6wKI5cWgw6Cv2w4o0frYPl4SmnSEHbDGLqn3aD1rCUrZURS35Ht0NknBOrUPa8/
         KXcQ==
X-Gm-Message-State: AOJu0YzT/R5jnNBBvw8EwmAdDm9Cw5g50ON8eXMVWzN+4Aj16M/wWeMq
        NHgEQS9GcyZcXS7UvCzMV58=
X-Google-Smtp-Source: AGHT+IFbqqKKGaJeO8wWR2EIw0F/jFigVpDehW1sXdmPhHsIc5Bpm7LhgjiNiZUrlSp7LK0B50WOMw==
X-Received: by 2002:a05:6870:9712:b0:1db:71b9:419c with SMTP id n18-20020a056870971200b001db71b9419cmr11905065oaq.58.1696660838560;
        Fri, 06 Oct 2023 23:40:38 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q25-20020a62e119000000b0069370f32688sm2506650pfh.194.2023.10.06.23.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 23:40:37 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/xsave: Remove 'return void' expression for 'void function'
Date:   Sat,  7 Oct 2023 14:40:19 +0800
Message-ID: <20231007064019.17472-1-likexu@tencent.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The requested info will be stored in 'guest_xsave->region' referenced by
the incoming pointer "struct kvm_xsave *guest_xsave", thus there is no need
to explicitly use return void expression for a void function "static void
kvm_vcpu_ioctl_x86_get_xsave(...)". The issue is caught with [-Wpedantic].

Fixes: 2d287ec65e79 ("x86/fpu: Allow caller to constrain xfeatures when copying to uabi buffer")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fdb2b0e61c43..2571466a317f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5503,8 +5503,8 @@ static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
-	return kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
-					     sizeof(guest_xsave->region));
+	kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
+				      sizeof(guest_xsave->region));
 }
 
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,

base-commit: 86701e115030e020a052216baa942e8547e0b487
-- 
2.42.0

