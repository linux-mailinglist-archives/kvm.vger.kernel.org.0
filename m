Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFDD5F5B8E
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 23:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJEVPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 17:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiJEVPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 17:15:04 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B8231DDC
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 14:14:51 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id b5so16394445pgb.6
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 14:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f0QBH494YB72tj7KgInVzqaaWdUvarXEp+jN2Euacig=;
        b=EihkVHj8Hf/itdRpIjn5kNyR6wy1u5AGF8JiiNvYvyCHUR2B7/T+tCISdrj1josxoE
         Rv2B3B0JQdRDxABYds77u4ynprwVbvjdjEOiKkfcSoj+Bh4iHs1tZSCm+U0LX8AQZUPO
         ckWwq/kpsdftQ89dE+6lkvW/rkEfm4sonsIZVVjuZUcr8S459uE5MAhZQfTZf086/avR
         UG+ISx3/YxAA/T/BWmudSatw3OaTm9gtQwZMExIlE1gwYzXR7hz5d5Youqea34gIHn+7
         KwkewSQ2mU7KmDp13QA/Lotsl++tWoIzT7ug6cVCVl5Q5Crcksc87vlhY0kMfM9Qts2u
         DLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0QBH494YB72tj7KgInVzqaaWdUvarXEp+jN2Euacig=;
        b=kAR/DZBJcmeQN+W6Ij7dltbox7FIwugX2EKYkmaYpTFQaXZAwMiV10x9YU/4RCGaxW
         XI8AKGrpr/t7ITWKq31p2WcN2Dr9h+EgTCLThO9jxEm6uiHXJ+WJ6hj2f2z1RnipRzKF
         Ur114uVtQ4yLgWew4IbRXZVYnN595uwTb8IY2nvwZy2MZb0sCSCbIG4alHGdrtp9iQZH
         A1WtPSuNyXdwmbZKOMpHOEZSHSg3HZYKbIDgs9QU4FwJ3pYVCi93GxjXjc/cJYlQd1Jn
         KUKIMjv9u1TVYHJPhA3dl6Fz+8iZyhmcU7AbVrLaEy5nubbidw83ZHplBHyGnKdZIVzA
         85vg==
X-Gm-Message-State: ACrzQf16R/lD2/G2IEmu3nZoiJlfjTUbYxwetLYLMJq5LPUV1wRANAaz
        12LQooNyma4Y67ttvnAh3SNoyw==
X-Google-Smtp-Source: AMsMyM4ugwXNqEOU9zx0mBnhH8CVokk35DLDyRnjDDz3Sdp9ObwhA0NjlZVD7TX5agoaJRjBne2f9g==
X-Received: by 2002:a63:4a4b:0:b0:439:837:cc8d with SMTP id j11-20020a634a4b000000b004390837cc8dmr1501766pgl.199.1665004490749;
        Wed, 05 Oct 2022 14:14:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l62-20020a622541000000b005614f8f0f43sm6856216pfl.125.2022.10.05.14.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 14:14:49 -0700 (PDT)
Date:   Wed, 5 Oct 2022 21:14:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, aaronlewis@google.com
Subject: Re: [kvm-unit-tests PATCH v2 0/4] x86: nSVM: Add testing for routing
 L2 exceptions
Message-ID: <Yz3zxo4zEZs8ryVu@google.com>
References: <20220810050738.7442-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810050738.7442-1-manali.shukla@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022, Manali Shukla wrote:
> Series is inspired by vmx exception test framework series[1].
> 
> Set up a test framework that verifies an exception occurring in L2 is
> forwarded to the right place (L1 or L2).
> 
> Tests two conditions for each exception.
> 1) Exception generated in L2, is handled by L2 when L2 exception handler
>    is registered.
> 2) Exception generated in L2, is handled by L1 when intercept exception
>    bit map is set in L1.
> 
> Above tests were added to verify 8 different exceptions.
> #GP, #UD, #DE, #DB, #AC, #OF, #BP, #NM.
> 
> There are 4 patches in this series
> 1) Added test infrastructure and exception tests.
> 2) Move #BP test to exception test framework.
> 3) Move #OF test to exception test framework.
> 4) Move part of #NM test to exception test framework because
>    #NM has a test case which checks the condition for which #NM should not
>    be generated, all the test cases under #NM test except this test case have been
>    moved to exception test framework because of the exception test framework
>    design.

I know Paolo NACKed a full rework to share nVMX and nSVM code, but it's super easy
to share the helpers, get a net -100 LoC, and improve nVMX coverage.

I've done the work, along with some misc cleanups.  I'll post a combined version
shortly.

 lib/x86/processor.h |  98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 x86/svm_tests.c     | 195 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------------
 x86/vmx_tests.c     | 200 +++++++++++--------------------------------------------------------------------------------------------------------------------------------------
 3 files changed, 199 insertions(+), 294 deletions(-)
