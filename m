Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470D459C9F2
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 22:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbiHVU0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 16:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiHVU0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 16:26:43 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCCC27CCA
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 13:26:42 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-335624d1e26so326688067b3.4
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 13:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8XJkBHlk/+a6iefWC//SbedfQQAzqBK0fb3XmKYxUPI=;
        b=HiGf+jwXxGsyaX6AXWHcv7N66hiTdp7G1rsO2du9FGoqoYli4fyOwClxHR0SMmylb8
         RJlzyuzW7lwe+u1m24BO4K8rhHlzU1LdVxTvQ5875bcM2iNoql1Cc6wFa4k7lma8fOwO
         PXDHmddSJ8c2jmwLrtok9VZpdWVniMbcVQ5Xt5+lWiPDOoQwV+tuc4OmqFYr9cvURr6M
         FNoaG6WVyOzAZH2dxHVuAu3VPSiGNx+tkJeTJ7wCIj7rRwYWNPyteUKvIoFrqnWrHAIi
         k+S36yEJxBxyBARe5/qZ9OZf3bY5TgpYboGe+TcJ69Qi+xBHM3nOanbKsd19TtGwOfvT
         41NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8XJkBHlk/+a6iefWC//SbedfQQAzqBK0fb3XmKYxUPI=;
        b=yS5vQ6owZYfaZSx1qE3W/z4fkkEqzACp5ZKzEgxed5NtdP5joLpnRed2yppDHKn8YB
         0wT6QfBhogI9BaOCQOmz8SOOKbYxUlj8ltllBBGF385jqEyKdrhG6pR69QlXU/AAHO9t
         biN4lMLUmPBXojatqDcgDTnq5UVwTBRoagdqytOO8yNztnv1r31HGFTiG4lAKWs9xR6V
         iFVeiij8eotMJJ5OCzmdVM8Wk0fM6FTXWtxaaQfoA42pbH1usXiFdb2IP4bznb4s8b+p
         yFSfsauIIw8kJhoSyoltf2lIoLveVMtPdEFm5AiAaz4PiemWBE3WGPPMH7ShOe4TIuMl
         Lumw==
X-Gm-Message-State: ACgBeo2kcapvUlA4Zeyv8YbMXVBrE9U1gIbOkqOI6vT+d6skr0RVJP5b
        Z0UyJGKGue5lfMOyOGDfH+Jm1yc3qKlS1FiG3XlvYw==
X-Google-Smtp-Source: AA6agR6kzJ4oix5znX/WD7NOj+Jhy2mv4zJokXOATi9OggfFa7UralfVqWeX+i2SJztvy9ML+gtpQvVJu+JMsQNXM4w=
X-Received: by 2002:a25:b92:0:b0:695:7503:cffe with SMTP id
 140-20020a250b92000000b006957503cffemr11801472ybl.91.1661200001485; Mon, 22
 Aug 2022 13:26:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220722230241.1944655-1-avagin@google.com> <Yts1tUfPxdPH5XGs@google.com>
 <CAEWA0a4hrRb5HYLqa1Q47=guY6TLsWSJ_zxNjOXXV2jCjUekUA@mail.gmail.com>
 <YuAD6qY+F2nuGm62@google.com> <875yjjttiz.ffs@tglx> <CAEWA0a6hteJsvkd7Fe06P93O0GcE=4izSvJEj3RGpYPta9=s1w@mail.gmail.com>
In-Reply-To: <CAEWA0a6hteJsvkd7Fe06P93O0GcE=4izSvJEj3RGpYPta9=s1w@mail.gmail.com>
From:   Andrei Vagin <avagin@google.com>
Date:   Mon, 22 Aug 2022 13:26:30 -0700
Message-ID: <CAEWA0a4Ryb+REb29+yAnXeZy=kaYtwYkBjrmW5EN8=P14O8EJQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM/x86: add a new hypercall to execute host system
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
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

On Tue, Jul 26, 2022 at 6:03 PM Andrei Vagin <avagin@google.com> wrote:
>
> On Tue, Jul 26, 2022 at 3:10 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > On Tue, Jul 26 2022 at 15:10, Sean Christopherson wrote:
> > > On Tue, Jul 26, 2022, Andrei Vagin wrote:
> > >> * It doesn't allow to support Confidential Computing (SEV-ES/SGX). The Sentry
> > >>   has to be fully enclosed in a VM to be able to support these technologies.
> > >
> > > Speaking of SGX, this reminds me a lot of Graphene, SCONEs, etc..., which IIRC
> > > tackled the "syscalls are crazy expensive" problem by using a message queue and
> > > a dedicated task outside of the enclave to handle syscalls.  Would something like
> > > that work, or is having to burn a pCPU (or more) to handle syscalls in the host a
> > > non-starter?
> >
> > Let's put VMs aside for a moment. The problem you are trying to solve is
> > ptrace overhead because that requires context switching, right?
>
> Yes, you are right.
>
> >
> > Did you ever try to solve this with SYSCALL_USER_DISPATCH? That requires
> > signals, which are not cheap either, but we certainly could come up with
> > a lightweight signal implementation for that particular use case.

Thomas,

I found that the idea of a lightweight signal implementation can be interesting
in a slightly different context. I have a prototype of a gVisor platform that
uses seccomp to trap guest system calls. Guest threads are running in stub
processes that are used to manage guest address spaces.  Each stub process sets
seccomp filters to trap all system calls and it has a signal handler for
 SIGTRAP, SIGSEGV, SIGFPU, SIGILL, and SIGBUS. Each time when one of these
signals is triggered, the signal handler notifies the Sentry about it. This
platform has two obvious problems:

* It requires context switching.
* Signals are expensive.

The first one can be solved with umcg which allows doing synchronous context
switches between processes.  A lightweight signal implementation can solve the
second problem.

Do you have any concrete ideas on how to do that?

Thanks,
Andrei
