Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40F459C32E
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 17:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbiHVPnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 11:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236842AbiHVPmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 11:42:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2867B1D0CB
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 08:42:39 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m15so3329367pjj.3
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 08:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=m+XUoMI2UgV3bZeLoWMp4YUYplyHQDspsygE7stPO7Y=;
        b=mQIMHFyEw5q/aRnbp8qCFPZFgcHf0+Q5/fLNswDgxCw00bvU2YMe2szWZGH6ByHrHU
         TRZf5rCYIimZg3PN3wx1BMJ3gPE62P57Nvvos1WJl98iLexQHfIcowy0OP8kdOglG/PX
         6sU6tyUbspLRwaX9diRVbqwJj1W5gGFIF+p7ZUF+4QBGstqX+M57gFJw1egbI1ysZ1MR
         2r86vLzMzw3gmkMBn70ORykqGjT0YdirNiDLE3zWsUIFEMrRhwgtU0xcQWLrKcV8+SJp
         esLLzfhNssdVIoNKO9/Ib7eG/9xTmgjusGqx2/hmnNuK8v1D90954/uwzaighaZ5nCx7
         kFfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=m+XUoMI2UgV3bZeLoWMp4YUYplyHQDspsygE7stPO7Y=;
        b=BmI1a+kPnnDVZyV6OdG5CNqGzWNAUQ7IOd8TUx5WmD0a6YoLSbm42qyloZ+fsk3UE6
         Vq+J81m30Sz73c566f+IqCdeb37SM1xt97p2twI28pxQfMYR0vVwXbYRK1nkXxMQlSSo
         EHvlIcCXj/i/EwHCofWHF4b28HKZC1pczOjrH2BRFXTlhRhCsFYJNXMN4R/nLasFJGi1
         j+HPPOwDNvI2VL9KpqCjS4zbEW1lstJHaaz/xNnvqAHwjoryFbqJF8a//PcPpUwMncK2
         g0I1PMrQjJt4k3+2Eu/6Yp2xKoollXvlnaWptfHyp+JLVfVk0wt/iyORPH5bdSQm3EN1
         uMfg==
X-Gm-Message-State: ACgBeo24cBt3Vg9QsMfRdWvyZy3JBwFdOuTuOZsZZpHoXXmt0vSrZT32
        ZSiQFHKw1opvpXUOiwQ189wdSfE1q1tuWQ==
X-Google-Smtp-Source: AA6agR5yci+nO0OS3SEUskMQ7XF/VcfmX1jeZ5r3wKM0ui8q3gHwgOcODqa30BnK5Qo/7EAZszN/pg==
X-Received: by 2002:a17:902:d4ca:b0:16f:8311:54b0 with SMTP id o10-20020a170902d4ca00b0016f831154b0mr21067887plg.108.1661182958536;
        Mon, 22 Aug 2022 08:42:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c17-20020a63ef51000000b0041d95d805d6sm4524929pgk.57.2022.08.22.08.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 08:42:37 -0700 (PDT)
Date:   Mon, 22 Aug 2022 15:42:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
Message-ID: <YwOj6tzvIoG34/sF@google.com>
References: <20220821215900.1419215-1-mhal@rbox.co>
 <20220821220647.1420411-1-mhal@rbox.co>
 <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022, Michal Luczaj wrote:
> On 8/22/22 00:06, Michal Luczaj wrote:
> > Note that doing this the ASM_TRY() way would require extending
> > setup_idt() (to handle #DB) and introducing another ASM_TRY() variant
> > (one without the initial `movl $0, %%gs:4`).
> 
> Replying to self as I was wrong regarding the need for another ASM_TRY() variant.
> Once setup_idt() is told to handle #DB,

Hmm, it might be a moot point for this patch (see below), but my vote is to have
setup_idt() wire up all known handlers to check_exception_table().  I don't see
any reason to skip some vectors.  Code with __ASM_TRY() will explode no matter what,
so it's not like it risks suppressing completely unexpected faults.

	for (i = 0; i < 32; i++) {
		if (!idt_handlers[i])
			continue;

		set_idt_entry(i, idt_handlers[i], 0);
		handle_exception(i, check_exception_table);
	}

> test can be simplified to something like
> 
> 	asm volatile("push %[ss]\n\t"
> 		     __ASM_TRY(KVM_FEP "pop %%ss", "1f")
> 		     "ex_blocked: mov $1, %[success]\n\t"

So I'm 99% certain this only passes because KVM doesn't emulate the `mov $1, %[success]`.
kvm_vcpu_check_code_breakpoint() honors EFLAGS.RF, but not MOV/POP_SS blocking.
I.e. I would expect this to fail if the `mov` were also tagged KVM_FEP.

Single-step and data #DBs appear to be broken as well, I don't see anything that
will suppress them for MOV/POP_SS.  Of course, KVM doesn't emulate data #DBs at
all, so testing that case is probably not worthwhile at this time.

The reason I say the setup_idt() change is a moot point is because I think it
would be better to put this testcase into debug.c (where "this" testcase is really
going to be multiple testcases).  With macro shenanigans (or code patching), it
should be fairly easy to run all testcases with both FEP=0 and FEP=1.

Then it's "just" a matter of adding a code #DB testcase.  __run_single_step_db_test()
and run_ss_db_test() aren't fundamentally tied to single-step, i.e. can simply be
renamed.  For simplicity, I'd say just skip the usermode test for code #DBs, IMO
it's not worth the extra coverage.
