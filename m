Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58175A724D
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiHaARN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiHaARL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:17:11 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1857D97D6E
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:17:11 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a19-20020aa780d3000000b0052bccd363f8so5269076pfn.22
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=inZmAldSU4aSVbi2qd8QeS7mQNQRQnMt4A+ie/z8kT4=;
        b=fw5mYkkDqyqthv1ZRUQttXv6Rt6nsjmDZuPEL/hSLeU1qHD2O7Pudcyzxr1Eltpwap
         VBveF2fI4xy3WgARvDqfhk0cGTyAXcKDKfw/2X4eyn8teb5Ig6p233OlvrtBmpJ6u7wE
         yi/6ALf7NqSqSQJgVbppcAeu779Yn5Q4M74lunps77pzDcx4J8XThFxm7itG8VnqOpUP
         7dgZGNhCGoY3KrB4T3RR+dL0APKedZRNaunchY5WFgIexJPp8YDEMIjElBU7XgOWewQ1
         H2EwW7vghCKWVrW3jsE1i6ipr0jNdm3vAddWKajWAloOh7Qg3MpBy9Z3O5z40P0xSqAl
         CUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=inZmAldSU4aSVbi2qd8QeS7mQNQRQnMt4A+ie/z8kT4=;
        b=lqaWJVNMOh8FfJsDN4pegf1LPvhsAbI1F25unWYfiyc1OjQooRkX6oNHTymlmlu3Gk
         7MJVI1LMntMMnLBnLI+9GycHtWrcmEM5bqNSlabTF7od8Ht+VroSPUnJMRpaa9iF79BJ
         wJcVj3swJVcBrMsAJW8eXsVvaNx5FkwQn9fO7iaGqOz/od3rpMU7BpsxBXahjq1YZa1j
         NWXTDpD/Q/nDAN1ROsOh5rOemPA1dtwJfmKNQgm3GnyU4+FOxKhWxpg3Z7XPlUoLc6Rt
         ZjwtV8hr7yPKYBuFlae4bF9TBh6RNLT4gKnGYECAHcJQ33uTGSBGNKcWARZFJRGXhvl5
         Zfdw==
X-Gm-Message-State: ACgBeo3TECDdcU+fZeOwYYO9VYo7xeij2dGMjmkkB+ESMbpq8Q9KseDs
        r1rda8lg0DZGrJj4zSH4QdSAAJOGN2g=
X-Google-Smtp-Source: AA6agR61rRRBtVSh/bqQGKudwNlbYfL17nqG83gwCw/bfIDZc5+kB//aIfVhaX+yuKKqFlBUleMQAN1NbAM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:edc3:b0:172:8ae3:9778 with SMTP id
 q3-20020a170902edc300b001728ae39778mr23098814plk.72.1661905030673; Tue, 30
 Aug 2022 17:17:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:17:04 +0000
In-Reply-To: <20220831001706.4075399-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831001706.4075399-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831001706.4075399-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: x86: Delete documentation for READ|WRITE in KVM_X86_SET_MSR_FILTER
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete the paragraph that describes the behavior when both
KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE are set for a range.  There is
nothing special about KVM's handling of this combination, whereas
explicitly documenting the combination suggests that there is some magic
behavior the user needs to be aware of.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 236a797be71c..5148b431ed13 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4115,13 +4115,6 @@ flags values for ``struct kvm_msr_filter_range``:
   a write for a particular MSR should be handled regardless of the default
   filter action.
 
-``KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE``
-
-  Filter both read and write accesses to MSRs using the given bitmap. A 0
-  in the bitmap indicates that both reads and writes should immediately fail,
-  while a 1 indicates that reads and writes for a particular MSR are not
-  filtered by this range.
-
 flags values for ``struct kvm_msr_filter``:
 
 ``KVM_MSR_FILTER_DEFAULT_ALLOW``
-- 
2.37.2.672.g94769d06f0-goog

