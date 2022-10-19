Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994F1605210
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 23:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiJSVgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 17:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJSVgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 17:36:31 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B24C194F82
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:36:30 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id gz13-20020a17090b0ecd00b0020d67a4e6e5so7808647pjb.3
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3c3fjpS7b6lyRZwyafOTjKsv3G2yFfUTLLOxAv+pE68=;
        b=eYBHpwKfZg4P/ZAo2gwOzhtUs2xxkNKRCNRo+RxKv0PE5v+UBuzHss1HYh7YpqMhh+
         FGnexuvXV/sxfX6LQvqDLafTD83ujqkkvil28FSj2cor6tfsFaVskEe48/xw12r5rbdZ
         dsohLV1OL7hYsnWyMX9TNQDeZ1lKLfrqR+NXbH3XS++W1jFMtDeAyYFM3bFV0NeNsnM9
         +wTLBjuKt20emWqTdaCEoQnhuSODDdx2GB9Hboqn8FVavVs4xE6fgDwmgTysGfSv3WRb
         tTchKZuXmpfzJoRcBUV+gWln4z21tuWCcyXUb+k2y5O5iK1ptMVLj08zmeI3LahyiW4d
         P87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3c3fjpS7b6lyRZwyafOTjKsv3G2yFfUTLLOxAv+pE68=;
        b=ZhVuxORT4Eu5FqdDABacbj+DpjsnwNiP4QYaYgm+chQlrjAt5fgAc00RgChZbPLwbg
         X1C8vp9p+CPuLFbPxwlrX07Is1apH9UI3dp6OKzByfik9YMEdTosW533FkJw5ZyLz19g
         iXDSk3ooLCiTfACxdZv417mOM2jkY0X6M4eoixkxbNOmicOH+i60j+iwQhk/FKDo1uwL
         AVY9buxunncT3tMaCIOxVq/NcjtCRBrKAAtWlzpVUyk1X1dh0x8XKqTdvx9pC7w5R/R9
         Kc/fj4wTk1Hvp4ataXWvcqEKkw4VqIrLi0o/iXGqsln4sTAosP/EioaBSIyyvZI1bmGI
         tg3w==
X-Gm-Message-State: ACrzQf0Sdhk5+Z+q8KmH8R/LuHaXIQvVhUOGbUeVIHi4DBjezbgMjNU8
        jAI7vDH9WgaNjxLqnCyjSp2XVULMGfHzyGknnLZYHuqtwQd4hZy7du1bKCsg6vfe0rc5s5HgvZm
        YgQRDXBNl5Qvv1iw+a5gYRMfvyRW43BmKkljSnkiVarwglbjdts0MpD5maHFt4SQ=
X-Google-Smtp-Source: AMsMyM7quhyFHevROLu76Ailc8FZuIEU/r+NrZmVHDHgYg2DMi6vUV6kI2TvQ+YO/sP+Y8jUEXrJBVPkkpSrzA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP
 id w6-20020a17090ac98600b00205f08ca82bmr1447pjt.1.1666215388682; Wed, 19 Oct
 2022 14:36:28 -0700 (PDT)
Date:   Wed, 19 Oct 2022 14:36:19 -0700
In-Reply-To: <20221019213620.1953281-1-jmattson@google.com>
Mime-Version: 1.0
References: <20221019213620.1953281-1-jmattson@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019213620.1953281-2-jmattson@google.com>
Subject: [PATCH v2 1/2] KVM: VMX: Guest usage of IA32_SPEC_CTRL is likely
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At this point in time, most guests (in the default, out-of-the-box
configuration) are likely to use IA32_SPEC_CTRL.  Therefore, drop the
compiler hint that it is unlikely for KVM to be intercepting WRMSR of
IA32_SPEC_CTRL.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dba04b6b019..b092f61b8258 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -858,7 +858,7 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
 	 * to change it directly without causing a vmexit.  In that case read
 	 * it after vmexit and store it in vmx->spec_ctrl.
 	 */
-	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
+	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
 		flags |= VMX_RUN_SAVE_SPEC_CTRL;
 
 	return flags;
-- 
2.38.0.413.g74048e4d9e-goog

