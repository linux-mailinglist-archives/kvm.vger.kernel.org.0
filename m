Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70111A3389
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 13:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgDILtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 07:49:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53497 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgDILtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 07:49:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id d77so3596769wmd.3
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 04:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NhCGDxyUnA14N2Q0P5fdjbo3qgE+I/ZWPpei6zT7QB8=;
        b=Wt/Hzy5jCHDeFSq6vISCyUT5iHJxSK17PQZZqlsUzoUhExC1Fwuj+ApvIcIogFgHpL
         ZtkhOUbflz/ISVh4fK/c0C/VQ2uwJD5YoFirHWxK5LVQbvwXCwSaCx/DTkB0l8yfI322
         J+6V/GTYl6ydXOqCcY4Jhh0AVlBEE7qjkyuM4Gd3s8ukJnXfmmh1i0BlNLtTJw0qD1Kv
         VCK97okxwa9Ii/6qReDouys5Otcvpid993rvMk+3d6cuNAcJjiKRSwiPF7bLiQMmZ0dH
         j2BnLWw5YBPnUyfuhAwIchy/awVZqD5u6Ur65P93e2u9PaXioxDpN3DbtDAMH1VgOl09
         7/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NhCGDxyUnA14N2Q0P5fdjbo3qgE+I/ZWPpei6zT7QB8=;
        b=O3mh3pRGtNCxkpMCOWbauP9LqfdYYEDLGHTZqzilq5093IJRrTfBOaVOCEL9u/9dV2
         Q+YkzQFNw2eTy9eqs1GHfcueqb+62z2LMo+aoY7WEOjB1Fz7PfmzGlq1IZAQb7AhuLS8
         n65NCKQpUfaSjeN/AFHzfF7mvepTady6THAr0wRj4FQ13Of2MTDczzMjDHZxgZAZMRZ/
         PMEX7iBFjsurAMvNEhGUSLddNN2S8f5mIXdDChrZEemwSfkA1cR3AOHhyvl46o/Pk+uH
         bpuWOwnUe4YJcL6e9fJFCjBFtkMsBd+xGUEwR8PQo1J4YKGbGi9+vp4+w5lKO14A2FJP
         mYlQ==
X-Gm-Message-State: AGi0PuYOCBpcP2KhChQQ/NcMmtrQptezlnaxSxHplAAPM9ks3LNgtvvu
        BJhVYSLqt22cdiLuqa0Kedc412EGfTo=
X-Google-Smtp-Source: APiQypKJ8z1OULVyZ3EW0TYT0OeWR4FPQQ5SvOB/2bf8DqgA1qZabS+lbTNx7l/55WwXFC7y5q4Fpg==
X-Received: by 2002:a1c:2b43:: with SMTP id r64mr10009732wmr.77.1586432983984;
        Thu, 09 Apr 2020 04:49:43 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id e23sm29884251wra.43.2020.04.09.04.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 04:49:43 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: SVM: Fix __svm_vcpu_run declaration.
Date:   Thu,  9 Apr 2020 13:49:26 +0200
Message-Id: <20200409114926.1407442-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function returns no value.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Fixes: 199cd1d7b534 ("KVM: SVM: Split svm_vcpu_run inline assembly to separate file")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2be5bbae3a40..061d19e69c73 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3276,7 +3276,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(svm);
 }
 
-bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
+void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 
 static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-- 
2.25.2

