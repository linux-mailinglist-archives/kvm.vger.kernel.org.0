Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E22F32F7B6
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCFCA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 21:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhCFB7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:48 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F35C06175F
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:48 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v6so4600737ybk.9
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YKINTCGltrVyp3fTfK7Bwe6l6hsuKz4Q8fib2ZV0sdc=;
        b=Cr2RbPYyHNoYJrGOPNCVD/QXx5wxFfULpNrwYW6zQ+p6Hs3EaETj+41Bc0iKvaO6Ge
         iwSpg73F7ba2C3MaTrQ4ofl3ZhLCp81Y4Hwv2Ml8JHsrcUSGw2sfA0pUHBBlCJFM2Vjc
         JgXc3MboYC+lOCSCMv9L00Rqra+TaYYaV3yK7yyEDY3I8zXbr4Pd2MR1LAwunDEb2s6N
         Z+he7sdMYL+RCXI/QAqq5vvTU7bhYMt+oCyk4n3YbDjL5NsIC+jtZppDApz3PorIB8EE
         vZXgsCmgUTfYIriQtTv6GLUR7aMFIOW7bcYWuQcegj8LavB7LEl1mreKtHtQmIuzeWIs
         AUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YKINTCGltrVyp3fTfK7Bwe6l6hsuKz4Q8fib2ZV0sdc=;
        b=qlnxwDNajPYe2jWxD/qeonNpnjEoQSsISTC+sY3VSa7m99Ne8rn65160Bbw5gq76WS
         +pTynwNCxSDefzMdErANzpdiilFwXHkwfcchZy7e5iH43SjLz4upZZXD7auUDlZgKBie
         iXWy4yv9ajYuXDxXkziX0Z/DXuxb5mqHMl2ONK724YwtxBemY8JtJSkbdovsXl4ccgFh
         OTLgA9MY00pPa9bMy+Ei22pWTv/cQTgiOax6HclPnnV7ZjivGO5vVBAK1t2/v7UpUSxa
         dJUDf4nfHtt9Z/ZIHGC/UDylzdgCctjckdOdkTe8LqdakSyTxspW6xwTTsfbz4EgJNoG
         ZufA==
X-Gm-Message-State: AOAM530quI4B46olUTf7Nn7W28XO5GOOzOb40ECYMm2LcRUmOvcsZsEf
        Xy/gRoHRzv6s9chGdcFkC2rgnzTeSvE=
X-Google-Smtp-Source: ABdhPJwi+YJGESeOsryzEjL2L33OGG+L5KOJO4dby4/YXu3Yv91JPoKIqEdMHwkwTnn93s/I0WA3zfKIWGA=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:a25:ab29:: with SMTP id u38mr17013369ybi.327.1614995987876;
 Fri, 05 Mar 2021 17:59:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:59:04 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 13/14] KVM: SVM: Remove an unnecessary prototype
 declaration of sev_flush_asids()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the forward declaration of sev_flush_asids(), which is only a few
lines above the function itself.

No functional change intended.

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9837fd753d88..3bf04a697723 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -42,7 +42,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
-static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
-- 
2.30.1.766.gb4fecdf3b7-goog

