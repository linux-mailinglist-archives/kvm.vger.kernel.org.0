Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555A2731C50
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 17:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240813AbjFOPSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 11:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjFOPSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 11:18:48 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096BF107
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 08:18:48 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b521e4e88bso2738845ad.2
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 08:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686842327; x=1689434327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7eZUMAxo5h1BGB1S8ryG9V7cVr6hC4O4UqlbbMmlDwQ=;
        b=VAZVXd+gL6dKq1z+XMXVEa3oW0j3Zfztqr5kjRHZ2SQ9ASCvW2nR6g5Px5S3L33w2T
         JvG8q5kVcK+PbGyOmocSWLy51MbCksfR8NzOT56/0S7NWqKxrhz04EvBacizje/0Zr2l
         sN/yxEaYHOKMzngBXFNCjSvRI1T55NrKvt8GrfpMflqAaDZTkFaoyu86SjUP85C5KE0Y
         cwrIHUK1m78MuhmQ6AAIanMlsf2XOOkJtgHaYHc8JonKzEHgUfVKW8BgZZIHeaqzqUuD
         390FVU7IKDFPwPYt8G+JV6iANUxRaosPdczeVWkR2BlEWkv+F3sQtmZauPDAimNjSr1K
         Di8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686842327; x=1689434327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7eZUMAxo5h1BGB1S8ryG9V7cVr6hC4O4UqlbbMmlDwQ=;
        b=KmYEjuSmPKivlu2w0nXulEf+D78Ub9ghcU6nMuJJre/4n3Oei+EztP+fysZNF/bnSr
         qtWPUVNNn5q6z8m5kkTiSlCDK3QAI43yCaDFEF3xN0HluVNnvWvbn2gF+FD0zH+vstYE
         AlLuHOQs+1AzLpBsZ42oVX7r5SSnyT3FsKRJ/rA/SuAUJQvcXp5IOVILda6dW75tVHo0
         pCtfBU08YDCWRl3YE9CGE60sIRTxhp2AA3rxjMzwlxJAWMRJCPAqhxmz0H9cy2VoVBUN
         lV0rWBTmcF8NJfuAaNC40o7qGidxLETD/SDglv+Ilsel6prFKTtrurWQx7tMKF6jH9yk
         XoIA==
X-Gm-Message-State: AC+VfDyUz9e3tepsXm65nxIdmH5AoQ5GGCQm1i7LHW7P1egTgZjRjio8
        L/OamNyvromcdRRGJgwM8PJszAp/Llo=
X-Google-Smtp-Source: ACHHUZ4/TdTD0WCon6BrAN72keLkpX6yhJ+u6nShtEJN0zIOfvMB3TsmSJFU6rBW1R9SItYk+y+vWgemD0w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c40c:b0:1b0:2432:2559 with SMTP id
 k12-20020a170902c40c00b001b024322559mr3129951plk.1.1686842327002; Thu, 15 Jun
 2023 08:18:47 -0700 (PDT)
Date:   Thu, 15 Jun 2023 08:18:45 -0700
In-Reply-To: <4de05ab1-e4d3-6693-a3c2-3f80236110bf@grsecurity.net>
Mime-Version: 1.0
References: <20230413184219.36404-1-minipli@grsecurity.net>
 <20230413184219.36404-7-minipli@grsecurity.net> <ZIe5IpqsWhy8Xyt5@google.com> <4de05ab1-e4d3-6693-a3c2-3f80236110bf@grsecurity.net>
Message-ID: <ZIsr1acxWTbtiWKg@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 06/16] x86/run_in_user: Change type of
 code label
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023, Mathias Krause wrote:
> On 13.06.23 02:32, Sean Christopherson wrote:
> > On Thu, Apr 13, 2023, Mathias Krause wrote:
> >> Use an array type to refer to the code label 'ret_to_kernel'.
> > 
> > Why?  Taking the address of a label when setting what is effectively the target
> > of a branch seems more intuitive than pointing at an array (that's not an array).
> 
> Well, the flexible array notation is what my understanding of referring
> to a "label" defined in ASM is. I'm probably biased, as that's a pattern
> used a lot in the Linux kernel but trying to look at the individual
> semantics may make it clearer why I prefer 'extern char sym[]' over
> 'extern char sym'.
> 
> The current code refers to the code sequence starting at 'ret_to_kernel'
> by creating an alias of it's first instruction byte. However, we're not
> interested in the first instruction byte at all. We want a symbolic
> handle of the begin of that sequence, which might be an unknown number
> of bytes. But that's also a detail that doesn't matter. We only what to
> know the start. By referring to it as 'extern char' implies that there
> is at least a single byte. (Let's ignore the hair splitting about just
> taking the address vs. actually dereferencing it (which we do not).) By
> looking at another code example, that byte may not actually be there!
> >From x86/vmx_tests.c:
> 
>   extern char vmx_mtf_pdpte_guest_begin;
>   extern char vmx_mtf_pdpte_guest_end;
> 
>   asm("vmx_mtf_pdpte_guest_begin:\n\t"
>       "mov %cr0, %rax\n\t"    /* save CR0 with PG=1                 */
>       "vmcall\n\t"            /* on return from this CR0.PG=0       */
>       "mov %rax, %cr0\n\t"    /* restore CR0.PG=1 to enter PAE mode */
>       "vmcall\n\t"
>       "retq\n\t"
>       "vmx_mtf_pdpte_guest_end:");
> 
> The byte referred to via &vmx_mtf_pdpte_guest_end may not even be mapped
> due to -ftoplevel-reorder possibly putting that asm block at the very
> end of the compilation unit.
> 
> By using 'extern char []' instead this nastiness is avoided by referring
> to an unknown sized byte sequence starting at that symbol (with zero
> being a totally valid length). We don't need to know how many bytes
> follow the label. All we want to know is its address. And that's what an
> array type provides easily.

I think my hangup is that arrays make me think of data, not code.  I wouldn't
object if this were new code, but I dislike changing existing code to something
that's arguably just as flawed.

What if we declare the label as a function?  That's not exactly correct either,
but IMO it's closer to the truth, and let's us document that the kernel trampoline
has a return value, i.e. preserves/outputs RAX.

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index c3ec0ad7..a46a369a 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -31,17 +31,18 @@ static void restore_exec_to_jmpbuf_exception_handler(struct ex_regs *regs)
 #endif
 }
 
+uint64_t ret_to_kernel(void);
+
 uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
                uint64_t arg1, uint64_t arg2, uint64_t arg3,
                uint64_t arg4, bool *raised_vector)
 {
-       extern char ret_to_kernel;
        volatile uint64_t rax = 0;
        static unsigned char user_stack[USERMODE_STACK_SIZE];
        handler old_ex;
 
        *raised_vector = 0;
-       set_idt_entry(RET_TO_KERNEL_IRQ, &ret_to_kernel, 3);
+       set_idt_entry(RET_TO_KERNEL_IRQ, ret_to_kernel, 3);
        old_ex = handle_exception(fault_vector,
                                  restore_exec_to_jmpbuf_exception_handler);
 

