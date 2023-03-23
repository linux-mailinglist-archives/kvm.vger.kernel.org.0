Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1D46C728C
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 22:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjCWVsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 17:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCWVr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 17:47:59 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD24171C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:47:58 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i7-20020a626d07000000b005d29737db06so63602pfc.15
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679608078;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zg/hHppX0Bcxm8+b/USlvKf7dTbzsTAszunwDJlIhwA=;
        b=DFLCi6RkXePZrNnJIPaTC+JOH9lUvQCCy3Q5t5cYpmrBqWH9yMnHuAY8klLwKdtEpd
         EMPl1DXxFf7WNtsJ0PAxQv6Hiip+t096I7Riq5E3EYuns4/YlZXJQItTWSVp65leYb70
         +NKPNL/ivWkqH4BQ22w1AXl/25cSvpKDjVurkNDPa02oGpJDTu7teW9smr3/zLgCz0dh
         rvdaR1eUIvJwHMvWKpKWWTn4ytTrNAVQxOC6l6uFPdbUsOx0BkXbhgH4d+cERMw8tZqi
         uNEAWRARKC1yYQxh6TIairs9/xvClTXF944x5EwX0U56kP/1pXDDeukSLAGOz39gxSWv
         q72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679608078;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zg/hHppX0Bcxm8+b/USlvKf7dTbzsTAszunwDJlIhwA=;
        b=ya30L49PlYHvEbQwhcJ9kbWKWw68rd+GT4aCCd19osDlUhz+SgYxMgC9K50iRWkKJ6
         o63Xh6wB36Cl4wBapnnjZsaKwg0SEAEweQ3shh3+LClYEs8TEkWAXc886f8r6E4aiZT1
         tiljkzgnTMERWjPuplU08Lup0laE5LQMepRvCrx8qZU8flcM72TC0myquKBfigHq42fk
         UzaWEIi0A8pnU7mgTibj4WOx7Ke+r6egytk/rqbOPu6CRKhRX8M4mE9w3CRqfhcOFujo
         qrf3spYWb7DseNDoI6a5JrzjiY+1Lc7/3NC6rWYvsS/nCSJo1HxiwV/K/Y7YCCxmxEp0
         skcw==
X-Gm-Message-State: AAQBX9fByNz90rHXDe5LNaPyV8xVWPfIKpEbxL5lNPWf/4csjGrT/NQx
        hnkfyeV2LITDJIi89wW3S8CZUN7rNl8=
X-Google-Smtp-Source: AKy350ahdfITL0Y4Q7OKzr2yGPt/xPOoz/Lo6KM4bP7OyiAIHXHd961iSirrbFv8doja2lBGv6NEcf36x/M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3004:b0:23f:900d:878d with SMTP id
 hg4-20020a17090b300400b0023f900d878dmr180445pjb.0.1679608078285; Thu, 23 Mar
 2023 14:47:58 -0700 (PDT)
Date:   Thu, 23 Mar 2023 14:47:56 -0700
In-Reply-To: <20230224223607.1580880-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
Message-ID: <ZBzJDLrekmFe6W//@google.com>
Subject: Re: [PATCH v3 0/8] Clean up the supported xfeatures
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        mizhang@google.com
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

On Fri, Feb 24, 2023, Aaron Lewis wrote:
> Make sure the supported xfeatures, i.e. EDX:EAX of CPUID.(EAX=0DH,ECX=0),
> for MPX, AVX-512, and AMX are in a valid state and follow the rules
> outlined in the SDM vol 1, section 13.3 ENABLING THE XSAVE FEATURE SET
> AND XSAVE-ENABLED FEATURES.  While those rules apply to the enabled
> xfeatures, i.e. XCR0, use them to set the supported xfeatures.  That way
> if they are used by userspace or a guest to set the enabled xfeatures,
> they won't cause a #GP.  
> 
> A test is then added to verify the supported xfeatures are in this
> sanitied state.
> 
> v2 -> v3:
>  - Sanitize the supported XCR0 in XSAVES2 [Sean]
>  - Split AVX-512 into 2 commits [Sean]
>  - Added XFEATURE_MASK_FP to selftests [Sean]
>  - Reworked XCR0 test to split up architectural and kvm rules [Sean]
> 
> Aaron Lewis (8):
>   KVM: x86: Add kvm_permitted_xcr0()
>   KVM: x86: Clear all supported MPX xfeatures if they are not all set
>   KVM: x86: Clear all supported AVX-512 xfeatures if they are not all set
>   KVM: x86: Clear AVX-512 xfeatures if SSE or AVX is clear
>   KVM: x86: Clear all supported AMX xfeatures if they are not all set
>   KVM: selftests: Hoist XGETBV and XSETBV to make them more accessible
>   KVM: selftests: Add XFEATURE masks to common code
>   KVM: selftests: Add XCR0 Test

A few nits on the new selftest, but I can clean those up when posting v4.  I'll
wait to do that until you've had a chance to weigh in on my proposal (see response
to patch 2).

Thanks!
