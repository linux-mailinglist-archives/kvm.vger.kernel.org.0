Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FE97272FD
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbjFGX3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbjFGX3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:29:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574922129
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:29:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bacd408046cso99540276.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 16:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686180586; x=1688772586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V+DsdjBEK10+EJFlWGr0IbYC18xsPmtET4RdPIySqvI=;
        b=hzWMGBZMKM0PIG9ee7IpChhIs22eMvskH5YfrIaOTwX3g/479HVhrqau3ScBSOH7a6
         xsB3Du2dLcc5Kcdmr9kkrl6bVtCkzhWORbt7/OHQD83JAa3N2r9zLV0UJJYh539y+zDJ
         U9ubK5UEn/sgKu9BlTuQQkxhrT+f2HjI3HK9AN95bXT/QTpF6JXzPR8z2Cz4s1Zaq9Ok
         iieD1X7WdpywK8p/fSyuR04+c7q1PG8aa6qJIeDR4ildYQjTShT2sSMDYutfeNrQXEQK
         2Xlj7Utqgo1sb7mFLN897FjQrqv488AVaMcVT76dXnkNsbhP2aFwQlMGqr5/GaqsPECb
         EWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686180586; x=1688772586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V+DsdjBEK10+EJFlWGr0IbYC18xsPmtET4RdPIySqvI=;
        b=hs8oTW9+9w1TZq8Lx6AxkM54iYfYgIyVd1aMt35knOoZqB2L3L1BVWz0o7ZMzpmoR1
         geCWtgAwsXMebeiu1a57Xs+BhWZwHZ2Unn1xWgI6JKVzvsksLIejnbwf9xB0k9Dp3PcJ
         JcJhEbUQbRrvBWrigx+qv/cxSLkr0lGSyvV+s+7b7AK4dBnloUIZSjt3BVPC2ZuqySIU
         OwFimjnzhLNXwh17ICacIS1121TdY0l5//oXNUnyix3V0IufYSxI7EhP/oysPLaM3liu
         0hqh3bYd/jmUGw5kUqc1t5o0a4xXm1+tj6XMSpWuTohldSOc0Tvfgup9RKdWWhX+6Quc
         jTow==
X-Gm-Message-State: AC+VfDxWNsVnNj9PNdQ5+gQHiEuiyCiXxzMIz0nEewSDrAYzNnVwsRht
        pSaQ+u1tm4QDIL9DLCzczrm7PLMSBPM=
X-Google-Smtp-Source: ACHHUZ4/rzKJ+eUpXHx/s6Fp+7pbghKYUhYikFJxNscuGYAS5Ec3026mEnZsHkqcp6mReiCtMM+JmCFG+Kk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:729:b0:bad:41b:f343 with SMTP id
 l9-20020a056902072900b00bad041bf343mr3931289ybt.1.1686180586617; Wed, 07 Jun
 2023 16:29:46 -0700 (PDT)
Date:   Wed,  7 Jun 2023 16:26:02 -0700
In-Reply-To: <20230405205138.525310-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405205138.525310-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168617859215.1601019.12130825950940647493.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 0/2] nSVM: vNMI testcase
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Santosh Shukla <santosh.shukla@amd.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 05 Apr 2023 13:51:36 -0700, Sean Christopherson wrote:
> Santosh's vNMI test, plus a prep patch to dedup a pile of copy+paste code
> in the SVM test for handling fatal errors in the guest.
> 
> Santosh, can you check that I didn't break anything in the vNMI test?  I
> don't have access to the necessary hardware.
> 
> Thanks!
> 
> [...]

Applied to kvm-x86 next, with fixups for the goofs pointed out by Mathias and
Santosh.

[1/2] nSVM: Add helper to report fatal errors in guest
      https://github.com/kvm-x86/kvm-unit-tests/commit/76c60c49ebfd
[2/2] x86: nSVM: Add support for VNMI test
      https://github.com/kvm-x86/kvm-unit-tests/commit/928fec073045

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
