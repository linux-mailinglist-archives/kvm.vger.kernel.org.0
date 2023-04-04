Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C627C6D6D65
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 21:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbjDDTqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 15:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbjDDTqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 15:46:02 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305D62134
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 12:46:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 205-20020a2503d6000000b00b7411408308so32674783ybd.1
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 12:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680637561;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bV7VzdUGJGY4rlFM40sknaR9VqPVGxcH6wNmUTity2w=;
        b=OEfOtXRzNy1d4A/F9K5QCcBxgeb9cUWVzPD7nFX4pTaGlLXx8zoSDgBks1tGLYMRo+
         YgxhJbfPqFrEo4Kkav6LU0/6q4CTKMFMUtGhEJYZlSTSTpjytOao3TIWKuCSQbJjFnYh
         9HcI4C3mFsjkaqkNaRxgtxct2I7mia+mCEE+hf+QHT9YtQdBTmuQR0nTtcKj1SjiIVND
         HRFlAW6M36HAC3k1Etu2/V/mMIto7yvs3woFhFjKSH/dK2y48TSx8MG1z4e84R+yACA+
         i9CrCy1XxsLSDd6PO6WkByyTLjHG0sg4G9F+5pkq//HPdK8AqX3cR2poyEwAoo/XsXfg
         g6Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680637561;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bV7VzdUGJGY4rlFM40sknaR9VqPVGxcH6wNmUTity2w=;
        b=roRhsaEftKBMhEjq2JmVBcAlheVF6LUtYIuGiicI98EiLvCYk2MJqvHQzDEA+twgCj
         uNtTtFphF/HXclJe/kkNNBTzEu3amnGOQM/Xlh9cptQjbkKshlNoZU9XzrTbK5nvdjNz
         Pp3uUX2f8qa86q3RjxcRWQ5mG2/DbsCnudb8j0+MatYDI8PZG8Ay83WGLn5COfjlkJk2
         +WFNbwT/ksBcVEndWwD2IWVwbIR8ysWJzIMmPXGyNKmktKVJBwxIMIe5JlX1bteFoMmy
         YUPgh7utEiTZIwMU42uGE7FntadJv8Sk9SPXThC+GT13Nr2HbPRuHSMbJxQa1CsKnh9G
         wz/g==
X-Gm-Message-State: AAQBX9cBEnTI/QNmytG6Qse6CVZqe7i7sxPMCdUApJtZc2ngt36DIFy5
        LL87PmLAUwrLyvb5br28Rh7qs1LSAxU=
X-Google-Smtp-Source: AKy350ZKGoUEuBrG5aU/YzebOowAkMS85nD7ejsV/gCGzm4Y/g7cd3t2OuaBoYQLC/qPINr9LQzOb4ZXt6s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cb12:0:b0:b2f:bdc9:2cdc with SMTP id
 b18-20020a25cb12000000b00b2fbdc92cdcmr2619200ybg.7.1680637561372; Tue, 04 Apr
 2023 12:46:01 -0700 (PDT)
Date:   Tue, 4 Apr 2023 12:45:59 -0700
In-Reply-To: <20230404165341.163500-10-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com> <20230404165341.163500-10-seanjc@google.com>
Message-ID: <ZCx+d8eSrNWccvTF@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 9/9] nVMX: Add forced emulation variant
 of #PF access test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023, Sean Christopherson wrote:
> Add a forced emulation variant of vmx_pf_exception_test to exercise KVM
> emulation of L2 instructions and accesses.  Like the non-nested version,
> make the test nodefault as forcing KVM to emulate drastically increases
> the runtime.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/unittests.cfg |  6 ++++++
>  x86/vmx_tests.c   | 25 ++++++++++++++++++++-----
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index c878363e..0971bb3f 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -409,6 +409,12 @@ extra_params = -cpu max,+vmx -append "vmx_pf_exception_test"
>  arch = x86_64
>  groups = vmx nested_exception
>  
> +[vmx_pf_exception_test_fep]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "vmx_pf_exception_forced_emulation_test"
> +arch = x86_64
> +groups = vmx nested_exception nodefault

And I forgot how the nVMX "test" works.  vmx_pf_exception_forced_emulation_test
needs to be explicitly filtered out of the primary "vmx" test config.
