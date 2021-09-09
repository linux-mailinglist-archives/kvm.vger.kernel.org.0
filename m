Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FE7405CE6
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbhIISdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237355AbhIISdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:33:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54898C061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:32:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f8-20020a2585480000b02905937897e3daso3553845ybn.2
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bzPtkyQtTcRRxvsfUyzElMBS8Y0OVSIGRG3VuE50siE=;
        b=Jaw81VpgZGawyHrTzpkHJ51i1IBMQ2Pxkc11wkCX0AIPyuYuU1YjVcFtoyCePEvjcB
         MP9Wp2hHOEU6M6qm4+Wr7dj7z8n/6XcwQnxV7jynWYlf2sE9wMUDrDf5Tx8yov8fWpNu
         2h1gzO4xxLqyXDSKxIrAaoywYapl47TTcBTQyM8QvP41KIQahIv/AZm2hshSbhYq5n2s
         Igu0eYIBGDDiAok8AxtRqoMsu/Gywhs0nr6jG09udzxlx8Wudv9zXo+otydjqhTWq+9g
         +J6bH9tm+3P52kzTb+wI0Y4r5+HJlLAMrypiixFFMvauMmy78uYvIEXpfyA82eFStITc
         QsIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bzPtkyQtTcRRxvsfUyzElMBS8Y0OVSIGRG3VuE50siE=;
        b=E0KpZ88OewARJvUak7m1OCfD31dw2mwRY+Btpu1tOeY/4i3ao895mSWMs2GHpZ+vwD
         q1kYQVt7zyNicAingalpHjW8vnsrIjNjTGX74MnFAWMslm22yD3yBPE+SfvVW0GQYvCb
         t1Sb/S9SkK2r38Fcy+4J3WIHDGOQXSKx8FcFA4fuJiLACvgAv9Fp3GCXpGu/Sxkk+a6S
         jSxVylFSb2drU/Inqb3mP3Qrth1w9Ln1+PfbZLKvxBA3FCdV+B/cCUq7Un9sNDqgR0cM
         XGXS7pPqYpDRX6ls3bqS6iffU1gq5K0a1KGM9HKw5NqbxgP+oRGq5/IiBfZa+hpS232n
         eU4Q==
X-Gm-Message-State: AOAM532QNc5Q7yHxEXGJPerEPHx6N+NrilUhdchgP2OnVNDLEOFvKrSY
        TAEvHLP01znYFbqW8bZNFsIpfkpawjk=
X-Google-Smtp-Source: ABdhPJwPzcVAzbg5u0E3BC2Mm4hKmHHCgFEwbqVHtINZf4rNIZxNYZqyGk+2FsSooo1ghyGLHZ7xoWZgyzs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:295c:3114:eec1:f9f5])
 (user=seanjc job=sendgmr) by 2002:a25:c184:: with SMTP id r126mr5374747ybf.123.1631212341402;
 Thu, 09 Sep 2021 11:32:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Sep 2021 11:32:05 -0700
In-Reply-To: <20210909183207.2228273-1-seanjc@google.com>
Message-Id: <20210909183207.2228273-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v3 5/7] x86: svm: mark test_run as noinline
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

test_run uses inline asm that defines globally visible labels. Clang
decides that it can inline this function, which causes the assembler to
complain about duplicate symbols. Mark the function as "noinline" to
prevent this.

Signed-off-by: Bill Wendling <morbo@google.com>
[sean: call out the globally visible aspect]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index beb40b7..3f94b2a 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -256,7 +256,7 @@ int svm_vmrun(void)
 
 extern u8 vmrun_rip;
 
-static void test_run(struct svm_test *test)
+static noinline void test_run(struct svm_test *test)
 {
 	u64 vmcb_phys = virt_to_phys(vmcb);
 
-- 
2.33.0.309.g3052b89438-goog

