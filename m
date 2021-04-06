Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DBE355A25
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 19:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346861AbhDFRSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 13:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346844AbhDFRSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 13:18:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45575C0613D7
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 10:18:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x7so7684807ybs.10
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 10:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AHeQvzzn66sWUva8JNr2h2SQ2HWMOsEyIwLZ7XmPEdo=;
        b=YETEvBs8rD6Dmh61b2NAoq1qfFjNVFIq9fVXm2Hfc5cx+aUOTDP/FcUFAxayIKqf13
         76ibDd1lermChzptEwnAh/LQFrI6N+rwx4ekcOYdM2+Z5E2HyrMbqjPt2QWJGrqSCpE1
         aX7zbi49N9k2lIIYMvOyGdmbnC8vauunxwf2vjAJ329IUqz3T8oOJ5xmxfEzwACtl+ij
         pkXLJ0sUz+pRFqFtsUUhzfevKLaT7ykOAvPzO2Ec2UlkMqxXTlUD3NHSNfIoMIiytR/c
         wnHjO5UFSIi7aQr7WC7sKfdfeUQDyr2f2olexN1i2NdAE2qEuEDe7gFCC+lng7k/7+zW
         JG5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AHeQvzzn66sWUva8JNr2h2SQ2HWMOsEyIwLZ7XmPEdo=;
        b=apnixJ/PoNIBY0DcyHAUKPcXBz2u4ktpRT5cDJkAFkkTQKhe9OMos3r6euMgSCNXSN
         YTaaSmYcyS1m8VBgVuWdxGkVa4O4v7o09Hq1FkD/Okt/LbmfOQup99eVJZfBAVeUVujv
         I3uaQdTvfcOdn9cpcHYUF15nvTfGLDLLda2a8s6Tp71yXiGMsO5zrFjuC4y1gUpmOGLk
         zC0OGJht88b+10UPH9Fm7wQab3/zKKili3R0RAu12g7kysJj2GX7CHYdhbaoX7oQC5RY
         QWygF2DeQgXFG9q8jtWHI/xRnkAKcUZoRKpxTlK9/HVWpNAx6o7dGiCOl9sZmlxEAiGV
         FJ7w==
X-Gm-Message-State: AOAM533cjclc3pEdBb3g7ctMZu2cdEicmIeSulul6YDcbWXpAV6AF1cB
        pX6alyCVgNcjznuSh6d0W1EflFV+giM=
X-Google-Smtp-Source: ABdhPJxbslvhhYvMOQ089wkXN1xaK5LEt/wkL5quSTis4uoo6YzzSrWcVv5TAYj4iW+o/zFSjf5u02tfKoU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a25:bad0:: with SMTP id a16mr44857414ybk.441.1617729503442;
 Tue, 06 Apr 2021 10:18:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 10:18:11 -0700
In-Reply-To: <20210406171811.4043363-1-seanjc@google.com>
Message-Id: <20210406171811.4043363-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210406171811.4043363-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 4/4] KVM: SVM: Enhance and clean up the vmcb tracking comment
 in pre_svm_run()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly document why a vmcb must be marked dirty and assigned a new
asid when it will be run on a different cpu.  The "what" is relatively
obvious, whereas the "why" requires reading the APM and/or KVM code.

Opportunistically remove a spurious period and several unnecessary
newlines in the comment.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f62c56adf7c9..afc275ba5d59 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3336,11 +3336,10 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
-	 * If the previous vmrun of the vmcb occurred on
-	 * a different physical cpu then we must mark the vmcb dirty.
-	 * and assign a new asid.
-	*/
-
+	 * If the previous vmrun of the vmcb occurred on a different physical
+	 * cpu, then mark the vmcb dirty and assign a new asid.  Hardware's
+	 * vmcb clean bits are per logical CPU, as are KVM's asid assignments.
+	 */
 	if (unlikely(svm->current_vmcb->cpu != vcpu->cpu)) {
 		svm->current_vmcb->asid_generation = 0;
 		vmcb_mark_all_dirty(svm->vmcb);
-- 
2.31.0.208.g409f899ff0-goog

