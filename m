Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9DA5A7751
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 09:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiHaHNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 03:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiHaHMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 03:12:40 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A309C8FD5C;
        Wed, 31 Aug 2022 00:10:48 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id kh8so10458111qvb.1;
        Wed, 31 Aug 2022 00:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=4H6Ap5iYRv7tpvy1RQr8BbbT4SuQAg4q/F9AMK7kUsE=;
        b=nQsvUMM7gPD0MfxFck6Gx7rnh5GgDRrLnxF5+lzgvgGP2W0neOwAOpnIkihVmYmhnj
         g/QozrVUh/ut5/ZBecYX4GKEHTXw6Nd1YMXccL6CHC8ZMtaEnuR4keOMXxnei7fElw6W
         oS0orSOhbkNbPdl1lPwSkH5VxGgZWZ5Ewd6Pn/lfBPC+HxtHLc3g/VwDqZbfk1v1qB28
         mRyFWEfi1nINqBgE6N0zuT4nozA0kkypJeIzTRYxfkeq/uypYJRWO0sj4StHJQlYNA2v
         GrU/f6K5aRfZpApcdRyrFGNv/mUenugIMbl9ryj4q948MOTJI/qKaLfKS93VRBJbqCk0
         N8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=4H6Ap5iYRv7tpvy1RQr8BbbT4SuQAg4q/F9AMK7kUsE=;
        b=CFobw5+Bi1aaSyYdmueK8fhlqN/iL2rOSe+p2iLoosRFCav9XNCcNS/ZvcTOe0eaZl
         d4hferDFpiFr1rZOJDexIUlF7CEHDSsBDSUFknnRRUgWCsytONcJB0u5exqe1aqaaT0n
         M6GWsK/9Ydqvq1asswKXFRpX9RypyJGvx7lPveRc2dUALwGTbqDmBiyC+pHOP+HAHVST
         +GSRCCMdnhL5BVMoo2W7MWqKXgbh0bsltFJpZuvEnJoDsnp7AD41XvG+/ABZbzHNh+UA
         HmtEPiWGfHKQKzvVVX8EUap1CZ8T/72Rqc/6hTIGRKec3HNg/Jpur5DSkHzyrtW267Ml
         Mn+Q==
X-Gm-Message-State: ACgBeo3vaHQxPo9d9/k/P88ZTO7xgjSAyn8fPkw3iFEb67l+LcGZXXw0
        +k0jjJ0OVrx4L8tLkHsO132inMg7LlqCv3phgq8=
X-Google-Smtp-Source: AA6agR6pVIwGsshTqW4W1Ww2G4fQrnbCfhAxvo2a0nXNTfKZi/6YL5FJH3r6Gmd9tQShyqtgATCNZIDlS+4HFxhktbc=
X-Received: by 2002:a05:6214:27e3:b0:497:f73:7c2 with SMTP id
 jt3-20020a05621427e300b004970f7307c2mr18196483qvb.1.1661929837495; Wed, 31
 Aug 2022 00:10:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220817144045.3206-1-ubizjak@gmail.com> <Yv0QFZUdePurfjKh@google.com>
In-Reply-To: <Yv0QFZUdePurfjKh@google.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Wed, 31 Aug 2022 09:10:26 +0200
Message-ID: <CAFULd4bVQ73Cur85Oj=oXHiMRvfrxkAVy=V4TfHcbtNWbqOQzw@mail.gmail.com>
Subject: Re: [PATCH] KVM/VMX: Do not declare vmread_error asmlinkage
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 5:58 PM Sean Christopherson <seanjc@google.com> wrote:
>
> +PeterZ
>
> On Wed, Aug 17, 2022, Uros Bizjak wrote:
> > There is no need to declare vmread_error asmlinkage, its arguments
> > can be passed via registers for both, 32-bit and 64-bit targets.
> > Function argument registers are considered call-clobbered registers,
> > they are saved in the trampoline just before the function call and
> > restored afterwards.
>
> I'm officially confused.  What's the purpose of asmlinkage when used in the kernel?
> Is it some historical wart that's no longer truly necessary and only causes pain?
>
> When I wrote this code, I thought that the intent was that it should be applied to
> any and all asm => C function calls.  But that's obviously not required as there
> are multiple instances of asm code calling C functions without annotations of any
> kind.

It is the other way around. As written in coding-style.rst:

Large, non-trivial assembly functions should go in .S files, with corresponding
C prototypes defined in C header files.  The C prototypes for assembly
functions should use ``asmlinkage``.

So, prototypes for *assembly functions* should use asmlinkage.

That said, asmlinkage for i386 just switches ABI to the default
stack-passing ABI. However, we are calling assembly files, so the
argument handling in the callee is totally under our control and there
is no need to switch ABIs. It looks to me that besides syscalls,
asmlinkage is and should be used only for a large imported body of asm
functions that use standard stack-passing ABI (e.g. x86 crypto and
math-emu functions), otherwise it is just a burden to push and pop
registers to/from stack for no apparent benefit.

> And vmread_error() isn't the only case where asmlinkage appears to be a burden, e.g.
> schedule_tail_wrapper() => schedule_tail() seems to exist purely to deal with the
> side affect of asmlinkage generating -regparm=0 on 32-bit kernels.

schedule_tail is external to the x86 arch directory, and for some
reason marked asmlinkage. So, the call from asm must follow asmlinkage
ABI.

FYI, there is some discussion about asmlinkage on stackoverflow:

https://stackoverflow.com/questions/61635931/does-asmlinkage-mean-stack-or-registers

Uros.
