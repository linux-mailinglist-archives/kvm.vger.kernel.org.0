Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2585153D8
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380078AbiD2SnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359759AbiD2SnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:43:07 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35826D64CD
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:49 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r16-20020a17090b051000b001db302efed7so3448356pjz.2
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eLj9VWCH6YzHOSIQaoJWqtR8rFElApiGGUxoXWV1O94=;
        b=OJFI0bT7LMQpxeCViUR4+UD694zimhrAh2VPA0v9AMUuhyRMsWCNSeFSBylOT9gyUk
         774fXxzii3Q5lJivzjja6/6V6/6TpcfqVQMBSmIRVpfNpkylP+nHG6FBqGBTLG9lI0xA
         349tvY55CZ7O5qWzCb4db0JaENxafsHQ64/r+aR/CODZBsOAlPhSP9JfqykhY3Ih7V5y
         RrNnK/+Uz8t5rHjSt6L36E/LEtiUJTQPheUf1kQv3ZRsIH9Te98SqTOGqdLfNXyZz3z4
         0iVSiKeonWn7oRF92IzHixs5T5CBuXv6K02KjxVrWoCawSHnvACRqV0g2kXWyE+9meKi
         k9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eLj9VWCH6YzHOSIQaoJWqtR8rFElApiGGUxoXWV1O94=;
        b=NbAa6xZFKiqVmabj1IrNejpdfTqGngUaU9LdvDkCh9/y067Z5LeUPJYLUH/recPhIG
         c1FX2S+FXuyrkhqvrxKCfAX2caWKjMMWE9k8GjCgz/xm4lFVow+56ae1iOVTHOFOq3CX
         KmmGf+weJ1iGbrqTik61yC4A9Dpj1fVesag5yi3Y+43/DyTnnbm5xRi/7IDu4Idps/LT
         jejY5qHq+fRw3ee3wxfG7tAeEDrxQxYPQeySbHVAxlPwmW7dIWOm47Qefb5ccFwt0tQj
         c3vfNRocWtvYnbhyL9QrD2ydaEW0QpRHLTReezuk+uQQKViVtan48ClsY3AywbcgaF2g
         mIkA==
X-Gm-Message-State: AOAM531ZKIKXVOhO+t1t65Jzgr6UZ6Yo5ilR1QBjEPHOAkRctCpgDiTn
        5gGnkDgci7ZfL376EMTaLrueegX63QEegg==
X-Google-Smtp-Source: ABdhPJzSIM17eRGysin9OCS+L6QVBunnF0SVXcSBOD20X7O0xte80T1HM8+3yFL94oCTYUwu7II0OlwRjy0FUA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP
 id w6-20020a17090ac98600b001d956e74e83mr430894pjt.1.1651257588338; Fri, 29
 Apr 2022 11:39:48 -0700 (PDT)
Date:   Fri, 29 Apr 2022 18:39:29 +0000
In-Reply-To: <20220429183935.1094599-1-dmatlack@google.com>
Message-Id: <20220429183935.1094599-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 3/9] KVM: selftests: Drop stale function parameter comment for nested_map()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
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

nested_map() does not take a parameter named eptp_memslot. Drop the
comment referring to it.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 1fa2d1059ade..ac432e064fcd 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -485,7 +485,6 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  *   nested_paddr - Nested guest physical address to map
  *   paddr - VM Physical Address
  *   size - The size of the range to map
- *   eptp_memslot - Memory region slot for new virtual translation tables
  *
  * Output Args: None
  *
-- 
2.36.0.464.gb9c8b46e94-goog

