Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F1256BCAA
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbiGHO4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 10:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiGHO4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 10:56:48 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DEB2DA88
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 07:56:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g4so22584536pgc.1
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 07:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VFqWa+9OMJ/ctVP9eoUWDFUInS8ymDBK2hy47L/2IuQ=;
        b=iMIiLON4Z5IX0NnFwWkdKowpk3sr8kD1VtorbwAbYQeeDKq+TOzBeq93+icZ62/LXZ
         qHZbkWtYc4hHXEGIp2GBcwL50eo5wR/fRDqmwEBLTVnB4eFZQfc6gKIk2nE5++8TLFcb
         PN+Z6CbdEBmVHoH5Tq+6lUAlHq/qJAsnkGJ+U4VsqGR8+205WAC33wlbwvM+gGXH4DWr
         2FmQC772MrNXPNm2LQnydSbbIop0KmDX7tXxCyFN6lHaEE7f6LBnX371/vr5112EsB6Q
         6io2guQUhpczyqGx8da/jRU56Tzsb2lLZIUasAYKzdjmS/X7TvUgz8/9TAL2X9ZHMYfM
         f5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VFqWa+9OMJ/ctVP9eoUWDFUInS8ymDBK2hy47L/2IuQ=;
        b=lI3K1EbhO5coHp26vMGhuTrSrmccbgamIlm4kW2ZBYKWcq68qwDLGsuidzmvttGXl1
         o+KLlKI2JnqqCZBzZz1cxtm15omjoWfbC4UMfqtf+LmCHYjxBKnn9I50t+JF/CtRSB3N
         7kYurGim7tEu0xh0sFkl5VlFINVeFYNFXn0AWrWAEKK871emi1rdI+TCTiaabZ9IWUKn
         ddyNLzWUU2hF33gBxxChKaa23/IrvTLG2XXfDnHW3O09nc9UJ91bfqVaEj1qPYaDhlbp
         48neouko40wOKVwSMJFVtiTt0x4/KFaPnfPGt611Ue/reGM26miPs17Au1/APiEC8QGi
         HMEA==
X-Gm-Message-State: AJIora9O0NqPDfgXnI4vRrSR3vZas/SKdEURFuQOnei0NYLJF06ZSVgw
        5enpJArH1vF+HwsMhc8yMVL8tw==
X-Google-Smtp-Source: AGRyM1v7ND1NFuqn/iDRDVEcbXP5ywnr4+cGUHggCkZRRnk9IwcGHd7V8HBCywT9TGhf7XwyYOMwxA==
X-Received: by 2002:a05:6a00:1312:b0:528:2948:e974 with SMTP id j18-20020a056a00131200b005282948e974mr4393046pfu.79.1657292206632;
        Fri, 08 Jul 2022 07:56:46 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a1fcf00b001eaae89de5fsm1731708pjz.1.2022.07.08.07.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 07:56:46 -0700 (PDT)
Date:   Fri, 8 Jul 2022 14:56:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Like Xu <likexu@tencent.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        kvm@vger.kernel.org, lkp@lists.01.org, lkp@intel.com
Subject: Re: [KVM]  cf8e55fe50: kvm-unit-tests.msr.fail
Message-ID: <YshFqkODttAUVeMU@google.com>
References: <YsfUdeft2F4f5OuL@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsfUdeft2F4f5OuL@xsang-OptiPlex-9020>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08, 2022, kernel test robot wrote:
> 
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-11):
> 
> commit: cf8e55fe50df0c0292b389a165daa81193cd39d1 ("KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> in testcase: kvm-unit-tests
> version: kvm-unit-tests-x86_64-8719e83-1_20220518

kvm-unit-tests needs to be updated, commit bab19ca ("x86: do not overwrite bits
7, 11 and 12 of MSR_IA32_MISC_ENABLE") fixes a test bug where it attempts to toggle
read-only bits.
