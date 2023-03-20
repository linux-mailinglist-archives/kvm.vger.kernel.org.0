Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DD06C1A6E
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 16:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjCTPzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 11:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbjCTPy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 11:54:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C12241EB
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:45:56 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so12871983pjb.0
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679327156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tZNiW5KxvoE+ahdAlVNoq8aEY+nAFPAaCHH+E+tzQfs=;
        b=bezcn259zmFSpv7wdzVX+54oxm3xoogNv7OqvFwOfT/1sm/aSy++6A2D3G1TF7/EC2
         NmymUPEXgk9EHDPIxYOkHZ5tddlpt2u9quNH0J4JgHoIXYpmB/g0FuMFFykjTO+0onGy
         xe+mpgLg31uG4QPd/xX3TRJL97ImOR2BC+raFSptLW9aRxHyOSlsOPsyRwcvwpFZw0Nt
         iWnwrhGypCw2cA8T/9CbN6x5qg2m6WcJziYVPS5aW8TIS+BAG0LHjNz3zS+E3K/XWWrs
         AIIYwiRfuigNJSIYHefYGO4TbH6vuO9d/EIejN7kQOgkANKU/4EzF8beogbwpHCu5StJ
         0vWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679327156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tZNiW5KxvoE+ahdAlVNoq8aEY+nAFPAaCHH+E+tzQfs=;
        b=0WfEeaF1T/3Fab8ApjsOpNG71yvh9p7mih/0Ftgoee4kG3DUjZkfyTFTCfcrcteYe7
         vSEaGllXwNKOo2oWVY4xEXOCy9oWPEpLIaYquSWMx+ZDW52UOjzM8juwhnV6420maz60
         nid412/0uU/G/d1kBo/iIFdhY7Vj6L3i97XNnwaP6IcAPyp0x2KO/nKx4SIwhwH/ciZ1
         i4KnUSVIUQzpyEZPUHvhj9Aln2YjCaq8m8IrglQekKz+oIjfC8CjI4DjbgBO8ceZS+nQ
         VVKFDCJmwDRYaSAQPiqkvRRfdmx7xT1vYZ8A08G6DvfKj/wOFCBRNtV+dManHWOz2cmD
         W2Gw==
X-Gm-Message-State: AO0yUKVC+qsrnd3MR5J+9N2JoE/8voBWUieV6jERTekwJZP01HQm18DJ
        i62RxQBnZ68fXil8Rpq2AXhmJA==
X-Google-Smtp-Source: AK7set+urGK6JCqgvl0FCezOVTn55tslfEdUHWcM266bjuRsgsnk23Z3QCZ7ABcCihxlo5ZYXl7IyQ==
X-Received: by 2002:a05:6a20:c9c:b0:d3:efaf:3613 with SMTP id dt28-20020a056a200c9c00b000d3efaf3613mr12414550pzb.21.1679327155516;
        Mon, 20 Mar 2023 08:45:55 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id c26-20020aa78e1a000000b00625616f59a1sm6524369pfr.73.2023.03.20.08.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 08:45:54 -0700 (PDT)
Date:   Mon, 20 Mar 2023 15:45:51 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Subject: Re: [PATCH v3 0/8] Clean up the supported xfeatures
Message-ID: <ZBh/r7CzBRv5qtr8@google.com>
References: <20230224223607.1580880-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224223607.1580880-1-aaronlewis@google.com>
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
> 
>  arch/x86/kvm/cpuid.c                          |  27 +++-
>  arch/x86/kvm/cpuid.h                          |   1 +
>  arch/x86/kvm/x86.c                            |   4 +-
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/processor.h  |  52 +++++++
>  tools/testing/selftests/kvm/x86_64/amx_test.c |  46 ++-----
>  .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 128 ++++++++++++++++++
>  7 files changed, 220 insertions(+), 39 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> 
ping? This series has been soaked for a while. Sean, would you mind
taking another look?
