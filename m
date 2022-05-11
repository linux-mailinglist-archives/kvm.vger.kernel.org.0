Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8872F52289A
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 02:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239854AbiEKAtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 20:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEKAtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 20:49:15 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7670F4AE15
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 17:49:14 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-edf3b6b0f2so1029694fac.9
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 17:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agwNmHmiSRpsUer0BmF8Qc8Hml7ShK+GYhu1hW83ZjQ=;
        b=CbArl/CL9ZFIaYaDeYbV+N1CMIk8Ysw047QzCgJQn9q8Z9GFjkqRYQm6r3kWQc2Spl
         VjR9tnIGk7pxbRWECAa3JPORFI0U/iKXf+eetne9783QUOReahU0Sg3Fws+6rJILYLnX
         e6/4/ARSj8NogG+CAmvGKCov6hVQY0FgqfVxWAoJmSun+unpLCfJnUersCQ7oEMQa52v
         bydEX9I/+DyY7IsEahSmFPXqe+hJfKQSOhK7/zw17o9bKYVBgGKKJB2JN6c+93xf0I1R
         7TsZOjPkTwTv8QaHY4Ouqak9Xn1uy4pRfqqanOIrlkl49/S02b2EBWh2jrSMYfzEnLbp
         voWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agwNmHmiSRpsUer0BmF8Qc8Hml7ShK+GYhu1hW83ZjQ=;
        b=L4l1TgtMbkuAi47sIEXb8m1Dq427LHCyyQtg6/5sBBxcvlqJWDGMNZaPF7t7Kdk8IA
         EsrcH1KA2wei1DC5fH6TH5tPTWT/+v1D3lUQTpv1qk6w2iQQeo7hHz/G6Wb5WrWGgl/s
         oi5/IfPRXNMdeYyoVuA2EClB90Fw4uNflEr5eh29xuuZy4xnLRdrBCyvdoYFiYRI0RPi
         JGNnlQlvQDbh10OLXrNN6e0+Xhq3HvvrCJJ7LC2Ko0u6ko0QjrdmdSDnlyQyXXLwpEuc
         JO/y6fTE7UX8ajUe150+HAV3XqC3lA+qxRnjrfz0lt5sfSQWd1KpROp4f3touEzVO15n
         WtYA==
X-Gm-Message-State: AOAM533vpT//99vcCDU1V6FQzJajZAQCHFKw95b6gL/2j5IUWGZSRFRO
        ewYFoSRv49G6UplfClGoRHSqRafrzypvUIaIpBN5sg==
X-Google-Smtp-Source: ABdhPJz/tXyH3144NjRoODVb4o0epNHhFz+isfQ8zCxG/v0y92jS0VIAvbEix04cPDCdZXt6zBGYBQ/H9Riv7fylMB8=
X-Received: by 2002:a05:6870:969e:b0:ed:9e77:8eba with SMTP id
 o30-20020a056870969e00b000ed9e778ebamr1587395oaq.269.1652230153569; Tue, 10
 May 2022 17:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
 <YnGUazEgCJWgB6Yw@google.com> <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
 <CAJGDS+E5f2Xo68dsEkOfchZybU1uTSb=BgcTgQMLe0tW32m5xg@mail.gmail.com>
In-Reply-To: <CAJGDS+E5f2Xo68dsEkOfchZybU1uTSb=BgcTgQMLe0tW32m5xg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 11 May 2022 00:49:02 +0000
Message-ID: <CALMp9eT3FeDa735Mo_9sZVPfovGQbcqXAygLnz61-acHV-L7+w@mail.gmail.com>
Subject: Re: Causing VMEXITs when kprobes are hit in the guest VM
To:     Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Fri, May 6, 2022 at 11:31 PM Arnabjyoti Kalita
<akalita@cs.stonybrook.edu> wrote:
>
> Dear Sean and all,
>
> When a VMEXIT happens of type "KVM_EXIT_DEBUG" because a hardware
> breakpoint was triggered when an instruction was about to be executed,
> does the instruction where the breakpoint was placed actually execute
> before the VMEXIT happens?
>
> I am attempting to record the occurrence of the debug exception in
> userspace. I do not want to do anything extra with the debug
> exception. I have modified the kernel code (handle_exception_nmi) to
> do something like this -
>
> case BP_VECTOR:
>     /*
>      * Update instruction length as we may reinject #BP from
>      * user space while in guest debugging mode. Reading it for
>      * #DB as well causes no harm, it is not used in that case.
>      */
>       vmx->vcpu.arch.event_exit_inst_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
>       kvm_run->exit_reason = KVM_EXIT_DEBUG;
>       ......
>       kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
>       kvm_run->debug.arch.exception = ex_no;
>       kvm_rip_write(vcpu, rip + vmcs_read32(VM_EXIT_INSTRUCTION_LEN));
>    <---Change : update RIP here
>       break;
>
> This allows the guest to proceed after the hardware breakpoint
> exception was triggered. However, the guest kernel keeps running into
> page fault at arbitrary points in time. So, I'm not sure if I need to
> handle something else too.
>
> I have modified the userspace code to not trigger any exception, it
> just records the occurence of this VMEXIT and lets the guest continue.
>
> Is this the right approach?

Probably not. I'm not sure how kprobes work, but the tracepoint hooks
at function entry are multi-byte nopl instructions. The int3
instruction that raises a #BP fault is only one byte. If you advance
past that byte, you will try to execute the remaining bytes of the
original nopl. You want to skip past the entire nopl.
