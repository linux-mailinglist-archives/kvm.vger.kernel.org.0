Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAF14BF64B
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 11:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiBVKmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 05:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBVKmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 05:42:13 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E767E6C3C;
        Tue, 22 Feb 2022 02:41:48 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id cp23-20020a17090afb9700b001bbfe0fbe94so2122304pjb.3;
        Tue, 22 Feb 2022 02:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1NOc3SMhUPuBWYuzpTacLcC5sGu7ZMcAFSKQLrvWVRo=;
        b=ntLoOw60zJoi0qPzAfgf2CP171VvJ/NXamfGEp/vc4jRos7KfxeY6PmhXDWooo7JCA
         w+B6mNZ8+1Lu48hOUXYaoewTvs67f7d3ywGicFwNJWWGpGo3/AH80/00mHXfks9oH+q7
         QsmSrKJU1rvjprr/hWLcbJACQDMgw8lg6LdXO7bzvkLazgaGscFeZ3aVk3Y/6J6VnpRO
         UfiqrETrcMoF1AZ2YNSTgmowV0w6vhV1tHStF3pWYzSwh3soer43+pRbl1Z6wTvQuAEw
         Nf+KlcE+s49JKP6QWqDpzzW27WQMhk77bB17PoxnzYnkIcRDoPHxgeNJhcwVN8WA2T0N
         zB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1NOc3SMhUPuBWYuzpTacLcC5sGu7ZMcAFSKQLrvWVRo=;
        b=PrMRUj/23lhGY8OlUPIc4PbYPYOTvcHqjLPmUYDhGz+B4DX5LuovlSGOz5gdbj6rPE
         WtKPWmE6Q0z4AjWMSYqX3O3JLmKKnwmwPOQKQfJ76jtPnoSRn1NP1IJBRfRITlPaxki6
         nhcn5btdThmBX91v1/JeIBBJ1+rsObYTmd0wQXlNLN0iLReGmG68s9JHGwkXVZIEo3bc
         5iTqtW679AjZlSbENaPo0rrNWxZj18SmObD0+KVast7LJaT9nQk/g+hf3vfhiWV/Tip9
         clkLnAbf6OQuTj8XNfJnKOjqKXtmEAQPb8Rht3xW33+uhdngTpVWVwbzbVG5HhmNKKnB
         h9TQ==
X-Gm-Message-State: AOAM530abygWRcv7NzKsYMY/QwKQemc+nR91Z8zTlndQH3G7H61GUH1o
        jcydw9Jd/Bs48TaiYrcB23A=
X-Google-Smtp-Source: ABdhPJwxreu1SuM+bR7uo6M+mk8zg4/IhR+4ETPnAqIkFJR0FT82ZnckB7MfW0mMgzwWfdDyZJq/Kw==
X-Received: by 2002:a17:903:230f:b0:14f:95e1:8706 with SMTP id d15-20020a170903230f00b0014f95e18706mr12878041plh.154.1645526507617;
        Tue, 22 Feb 2022 02:41:47 -0800 (PST)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id c13sm16837311pfi.177.2022.02.22.02.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 02:41:47 -0800 (PST)
From:   Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] kvm:vmx: Fix typos comment in __loaded_vmcs_clear()
Date:   Tue, 22 Feb 2022 18:40:29 +0800
Message-Id: <20220222104029.70129-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

From: Peng Hao <flyingpeng@tencent.com>

Fix a comment documenting the memory barrier related to clearing a
loaded_vmcs; loaded_vmcs tracks the host CPU the VMCS is loaded on via
the field 'cpu', it doesn't have a 'vcpu' field.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6101c2980a9c..75ed7d6f35cc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -644,10 +644,10 @@ static void __loaded_vmcs_clear(void *arg)
 
 	/*
 	 * Ensure all writes to loaded_vmcs, including deleting it from its
-	 * current percpu list, complete before setting loaded_vmcs->vcpu to
-	 * -1, otherwise a different cpu can see vcpu == -1 first and add
-	 * loaded_vmcs to its percpu list before it's deleted from this cpu's
-	 * list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
+	 * current percpu list, complete before setting loaded_vmcs->cpu to
+	 * -1, otherwise a different cpu can see loaded_vmcs->cpu == -1 first
+	 * and add loaded_vmcs to its percpu list before it's deleted from this
+	 * cpu's list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
 	 */
 	smp_wmb();
 
-- 
2.27.0

