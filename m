Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6855C00E0
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiIUPPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiIUPPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:15:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BC28709B
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n85-20020a254058000000b006b0148d96f7so5482709yba.2
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=AM15ozgnm9QNndhOKNzfVvo5El/vEuh9XgSZLRgqagw=;
        b=ZUK3knhYDTN88jBE2UQJYzdMWV9TlcnC8QuEHW9pwVd2nfww003o1qt9dQafLZZv2j
         gDCEmGvbfw7RhN3KNunZLYwE8WcTzoZ9nSr72POPqaVQu+cEpDO21+1W5WJq/3VetL//
         Gslv91eKzgxdI6VErVbk2QVd7W7PyzqG/a1nYPu9Uvvk+tEM47KBODw4vMZG4957PuDv
         fgUFRXtd5FY1Hi7Od139OcrQAYLZWTbUZqex9wO3MqTtNhdnzCKZvGiQAn2SCez8Goci
         sgD+sW1tgvkiAUeRdmkPPcrcl7kzTelc8X8mdl4qHBbzkb8bnOeeOlAdxZipK1cTT0jm
         Vpcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=AM15ozgnm9QNndhOKNzfVvo5El/vEuh9XgSZLRgqagw=;
        b=emVsw/yylwc+pVWcJ07OtamIUHDG6rdk/8W6e1RA7jPg6mWfFUIRiLIgl2ott+8dr1
         NdScPzqyfNMMVN+yFx17Nw4gntRmCG76ATuK7PgCZhO32BWOpGQ8e2/INaziwxte5p4K
         Pm8XOWgRDA9hXPhO2AZi/QMxr6maX8crjTOxhsmCz1Jo7lIPUzTujY1/Cd30MS+eL6eK
         Emri91XlN9/M+DOuTrHCpwkh1SXQXaNc3SuuMN6R0vM2WiqKIiTFd2wWAdS3dXEkhgBv
         BIatOV+eykHJQ0WnJRUXeFMrCcrilI0dnZcqloJdAbgXrYrReeQCJpOaADXPzpCS6FgN
         COnw==
X-Gm-Message-State: ACrzQf1f2I+MhxVructSHC4a6En7fApxzBqafNua11nqgPT76nPXm5WM
        t1Ru4/u1lrLRVIluadfgFUvtw6z5xKh5kQxZHr0dzt64vlaN43nwHp15k/nWYQMs5KxgOJNZyaZ
        m5U80caXNq/pdNdPsUqESmKw3RCmC9t/Hs5RWox588SfNPGPV2ahkUfiRyP3xUgCQ6KjF
X-Google-Smtp-Source: AMsMyM7idMkirR35YRuojB5Y6ZutngmwG2j3tDjFibWicUzLxR9FFXgBthA/jLlNCP99hrYu+29dbebBS9twtETG
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a25:bbcc:0:b0:6a8:e269:5eec with SMTP
 id c12-20020a25bbcc000000b006a8e2695eecmr25496715ybk.219.1663773330757; Wed,
 21 Sep 2022 08:15:30 -0700 (PDT)
Date:   Wed, 21 Sep 2022 15:15:21 +0000
In-Reply-To: <20220921151525.904162-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220921151525.904162-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921151525.904162-2-aaronlewis@google.com>
Subject: [PATCH v4 1/5] KVM: x86: Disallow the use of KVM_MSR_FILTER_DEFAULT_ALLOW
 in the kernel
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Protect the kernel from using the flag KVM_MSR_FILTER_DEFAULT_ALLOW.
Its value is 0, and using it incorrectly could have unintended
consequences. E.g. prevent someone in the kernel from writing something
like this.

if (filter.flags & KVM_MSR_FILTER_DEFAULT_ALLOW)
        <allow the MSR>

and getting confused when it doesn't work.

It would be more ideal to remove this flag altogether, but userspace
may already be using it, so protecting the kernel is all that can
reasonably be done at this point.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---

Google's VMM is already using this flag, so we *know* that dropping the
flag entirely will break userspace.  All we can do at this point is
prevent the kernel from using it.

 arch/x86/include/uapi/asm/kvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 46de10a809ec..73ad693aa653 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -222,7 +222,9 @@ struct kvm_msr_filter_range {
 
 #define KVM_MSR_FILTER_MAX_RANGES 16
 struct kvm_msr_filter {
+#ifndef __KERNEL__
 #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+#endif
 #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
 	__u32 flags;
 	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
-- 
2.37.3.968.ga6b4b080e4-goog

