Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552DC570EA2
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 02:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiGLAK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 20:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiGLAK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 20:10:56 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AB645F70
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 17:10:56 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u64-20020a638543000000b00412b09eae15so2507121pgd.15
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 17:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dQ1yHTydm5AL5ctZpvMijS/zgSvxtyg8H3xsByXzZP4=;
        b=NNa9oflyoJL+BnJVxf/0z42joAK0n+PbIeYpYFTS5qK0BLfU43wt6dSnnUxRNekB5I
         HvE4h9VvrQGk1b7UDQ6WU1ThgGu+FDAeQ/N/mDmrxwzMRdUIBVpsP3efvqKvLUZzjjCn
         7UFIXQsUbAF6oQmb/+ZRCPZC0cKh8JDzBWdxv3vE9o93d8sZiIsZ4GiNYhG6MIek+k3Z
         dZsBdMm8uhXUWa1/ydVSPjeR/crWskJ88M/qkxU5a4lKrI5YA1wz+eFBDYCWlW1bGSod
         Et5uG/gjohs+9VlC+0Mr77pITsVop/fHBGRrtCeWK+dsdaUifl9BTxMIbP1nthKbi9wn
         5ZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dQ1yHTydm5AL5ctZpvMijS/zgSvxtyg8H3xsByXzZP4=;
        b=NEgwgZlRgU+V0lnEhiu5s97LVIVVHqYvyw2/CRiJZZBFLece2ObA2jP/J3s/k6munk
         cymwnr3zPTxzBKGf7lh56MwcUY+vYH6cVIes1HsFkXDwepOdP7IApSTCsHh2XlIEEHTi
         xZgQyUSwS51NPj/YTiCuLd1vF75Me9XyEjkhw1/9LjXP3o+cHAA01lAGvbE3BtzEK/UH
         XDbSd7lQJT0d358dGtFzD2pRq4/pvIRx/uql+9gFY8EHeG4FqUu6ph7FhpKEroaMb/qZ
         lWaOROdH9dzigkGECGZMco77fHQstbJ4lBQMXQZ0CPtHhZfP8bXaKpG3pji6na+iJR+x
         noTQ==
X-Gm-Message-State: AJIora9eg6A0mKLVHwt+pdRmSVI2ZT+V5uslI+ZrvVdUehtYByhIRPeQ
        UtBQwGaJupBuZcZYqU2/g/sNt1EpYHcSESvQAfonwrdeXEBHp1fVaxWvyb8OZHyVXH+bUL9ZblE
        NF0EH0Hx+JPr5raUJqicfPvC3STgJBciDT38fAfGcQfRUnuZbW2G1KCjv6wobjSAsxFDQ
X-Google-Smtp-Source: AGRyM1v2i97FhWS08ueqBijpy1YAKucXf0sjeW/iMFhSAZ5kRkIb9o03V0Ukq7CkVTH8LhT4oV1reOZzvvRPksIr
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP
 id t9-20020a17090a024900b001e0a8a33c6cmr33776pje.0.1657584654711; Mon, 11 Jul
 2022 17:10:54 -0700 (PDT)
Date:   Tue, 12 Jul 2022 00:10:45 +0000
In-Reply-To: <20220712001045.2364298-1-aaronlewis@google.com>
Message-Id: <20220712001045.2364298-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220712001045.2364298-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2 2/2] KVM: x86: update documentation for MSR filtering
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the documentation to ensure best practices are used by VMM
developers when using KVM_X86_SET_MSR_FILTER and
KVM_CAP_X86_USER_SPACE_MSR.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5c651a4e4e2c..bd7d081e960f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4178,7 +4178,14 @@ KVM does guarantee that vCPUs will see either the previous filter or the new
 filter, e.g. MSRs with identical settings in both the old and new filter will
 have deterministic behavior.
 
+When using filtering for the purpose of deflecting MSR accesses to userspace,
+exiting[1] **must** be enabled for the lifetime of filtering.  That is to say,
+exiting needs to be enabled before filtering is enabled, and exiting needs to
+remain enabled until after filtering has been disabled.  Doing so avoids the
+case where when an MSR access is filtered, instead of deflecting it to
+userspace as intended a #GP is injected in the guest.
 
+[1] KVM_CAP_X86_USER_SPACE_MSR set with exit reason KVM_MSR_EXIT_REASON_FILTER.
 
 4.98 KVM_CREATE_SPAPR_TCE_64
 ----------------------------
@@ -7191,6 +7198,16 @@ KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR exit notifications which user space
 can then handle to implement model specific MSR handling and/or user notifications
 to inform a user that an MSR was not handled.
 
+When using filtering[1] for the purpose of deflecting MSR accesses to
+userspace, exiting[2] **must** be enabled for the lifetime of filtering.  That
+is to say, exiting needs to be enabled before filtering is enabled, and exiting
+needs to remain enabled until after filtering has been disabled.  Doing so
+avoids the case where when an MSR access is filtered, instead of deflecting it
+to userspace as intended a #GP is injected in the guest.
+
+[1] Using KVM_X86_SET_MSR_FILTER
+[2] KVM_CAP_X86_USER_SPACE_MSR set with exit reason KVM_MSR_EXIT_REASON_FILTER.
+
 7.22 KVM_CAP_X86_BUS_LOCK_EXIT
 -------------------------------
 
-- 
2.37.0.144.g8ac04bfd2-goog

