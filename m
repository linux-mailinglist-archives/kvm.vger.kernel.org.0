Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D422E0259
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 23:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgLUWLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 17:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgLUWLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 17:11:17 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1314EC0613D3;
        Mon, 21 Dec 2020 14:10:37 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id p14so10275017qke.6;
        Mon, 21 Dec 2020 14:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AnZzpWyI6LkHSnjU9R4atfysgpmuyvki0fbakwGxV/o=;
        b=TDIBvsBTQfzj8AkEyyYdKJ8mbGI+DhW6wx/uhuAoFAMgzu5T4aUh5X1+KavHtSI7l6
         eV5IthOty/VLn9s+j25KuczWD13/NlA/NE0pHSzLl2EwyxH22kMGtHI9dOox5aUSRXn4
         gZWkx2G5jeVKzp/fimKcSFlUWXdeiiEifo+8SHL0xJE2j+FWIVIHb+ZmQLl8gl/uLrH2
         VOHU0rbBQgmRIt6RzAbG6N5kgq0GgnPtOgQaRI/hZIL38KxXee8cMicKaCxIonNwf8hO
         /N9jQ11qpUSsNHpVW2YRifKWV9cmmMOOMdw4kcrGx4me6pbYtVdXmPGqQsmkQDvcVIWM
         fjqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AnZzpWyI6LkHSnjU9R4atfysgpmuyvki0fbakwGxV/o=;
        b=NulYxn+6GZaCqMMPHXRZJ+lEwj/ewMsbMFa7FE/rTBe0gpyeQRQu3C098KlPEdbX8A
         tUpZKY8rwCG6+P4Oi4KFs8ydga4mizHoQo8DVqSI3XtA3m43+nP83ojIi1d1oIDd9jWE
         HBOgRxXjj4Ut2Cu+0YarD8l89JCeHcGy2EhjgtxfJepYY6QjyIeMhaoJMrk1MjPOVi2E
         VoO5QxAlO1dEFt8SE8hnky/4CYc69EybT9HMkGsYSpHc/LvRjGbVjAwA/yzRG7EA1D9S
         TO66AT74qEC5SQXQhnqyZi18PibW2CUYPNNXQThKNLdL2rCpTH/3SB+noG6iQ4Pj9sKu
         eZ+w==
X-Gm-Message-State: AOAM532bY2Rv3PVpMcXJJ6vAeXk9yZDjmWJSRqY7YeM4ARxXjSQWJkc4
        O0RAP1Yy98vZArZuuzimXcPPRzCLT+gB2GRbgY4=
X-Google-Smtp-Source: ABdhPJzHi7rBg1cyOt9Tyrl84ADsDjj3VvLLu655uhpc9YRsHWo4fIkmN1yyJkmyLYxE723bzCfZrdCd7ZVWnkuPNHM=
X-Received: by 2002:a05:620a:69c:: with SMTP id f28mr19427194qkh.127.1608588636211;
 Mon, 21 Dec 2020 14:10:36 -0800 (PST)
MIME-Version: 1.0
References: <20201221194800.46962-1-ubizjak@gmail.com> <a773afca-7f28-2392-74ad-0895da3f75ca@oracle.com>
In-Reply-To: <a773afca-7f28-2392-74ad-0895da3f75ca@oracle.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 21 Dec 2020 23:10:25 +0100
Message-ID: <CAFULd4bCGOi7K2snz1MMe93F8hbDku_LoJdh3wOcePUrsv4ZRQ@mail.gmail.com>
Subject: Re: [PATCH v3] KVM/x86: Move definition of __ex to x86.h
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 21, 2020 at 11:01 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 12/21/20 11:48 AM, Uros Bizjak wrote:
> > Merge __kvm_handle_fault_on_reboot with its sole user
> > and move the definition of __ex to a common include to be
> > shared between VMX and SVM.
> >
> > v2: Rebase to the latest kvm/queue.
> >
> > v3: Incorporate changes from review comments.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h | 25 -------------------------
> >   arch/x86/kvm/svm/sev.c          |  2 --
> >   arch/x86/kvm/svm/svm.c          |  2 --
> >   arch/x86/kvm/vmx/vmx.c          |  4 +---
> >   arch/x86/kvm/vmx/vmx_ops.h      |  4 +---
> >   arch/x86/kvm/x86.h              | 24 ++++++++++++++++++++++++
> >   6 files changed, 26 insertions(+), 35 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 39707e72b062..a78e4b1a5d77 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1634,31 +1634,6 @@ enum {
> >   #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
> >   #define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
> >
> > -asmlinkage void kvm_spurious_fault(void);
> > -
> > -/*
> > - * Hardware virtualization extension instructions may fault if a
> > - * reboot turns off virtualization while processes are running.
> > - * Usually after catching the fault we just panic; during reboot
> > - * instead the instruction is ignored.
> > - */
> > -#define __kvm_handle_fault_on_reboot(insn)                           \
> > -     "666: \n\t"                                                     \
> > -     insn "\n\t"                                                     \
> > -     "jmp    668f \n\t"                                              \
> > -     "667: \n\t"                                                     \
> > -     "1: \n\t"                                                       \
> > -     ".pushsection .discard.instr_begin \n\t"                        \
> > -     ".long 1b - . \n\t"                                             \
> > -     ".popsection \n\t"                                              \
> > -     "call   kvm_spurious_fault \n\t"                                \
> > -     "1: \n\t"                                                       \
> > -     ".pushsection .discard.instr_end \n\t"                          \
> > -     ".long 1b - . \n\t"                                             \
> > -     ".popsection \n\t"                                              \
> > -     "668: \n\t"                                                     \
> > -     _ASM_EXTABLE(666b, 667b)
> > -
> >   #define KVM_ARCH_WANT_MMU_NOTIFIER
> >   int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
> >                       unsigned flags);
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index e57847ff8bd2..ba492b6d37a0 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -25,8 +25,6 @@
> >   #include "cpuid.h"
> >   #include "trace.h"
> >
> > -#define __ex(x) __kvm_handle_fault_on_reboot(x)
> > -
> >   static u8 sev_enc_bit;
> >   static int sev_flush_asids(void);
> >   static DECLARE_RWSEM(sev_deactivate_lock);
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 941e5251e13f..733d9f98a121 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -42,8 +42,6 @@
> >
> >   #include "svm.h"
> >
> > -#define __ex(x) __kvm_handle_fault_on_reboot(x)
> > -
> >   MODULE_AUTHOR("Qumranet");
> >   MODULE_LICENSE("GPL");
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 75c9c6a0a3a4..b82f2689f2d7 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2320,9 +2320,7 @@ static void vmclear_local_loaded_vmcss(void)
> >   }
> >
> >
> > -/* Just like cpu_vmxoff(), but with the __kvm_handle_fault_on_reboot()
> > - * tricks.
> > - */
> > +/* Just like cpu_vmxoff(), but with the fault handling. */
> >   static void kvm_cpu_vmxoff(void)
> >   {
> >       asm volatile (__ex("vmxoff"));
> > diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
> > index 692b0c31c9c8..7e3cb53c413f 100644
> > --- a/arch/x86/kvm/vmx/vmx_ops.h
> > +++ b/arch/x86/kvm/vmx/vmx_ops.h
> > @@ -4,13 +4,11 @@
> >
> >   #include <linux/nospec.h>
> >
> > -#include <asm/kvm_host.h>
> >   #include <asm/vmx.h>
> >
> >   #include "evmcs.h"
> >   #include "vmcs.h"
> > -
> > -#define __ex(x) __kvm_handle_fault_on_reboot(x)
> > +#include "x86.h"
> >
> >   asmlinkage void vmread_error(unsigned long field, bool fault);
> >   __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index c5ee0f5ce0f1..5b16d2b5c3bc 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -8,6 +8,30 @@
> >   #include "kvm_cache_regs.h"
> >   #include "kvm_emulate.h"
> >
> > +asmlinkage void kvm_spurious_fault(void);
> > +
> > +/*
> > + * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
> > + *
> > + * Hardware virtualization extension instructions may fault if a reboot turns
> > + * off virtualization while processes are running.  Usually after catching the
> > + * fault we just panic; during reboot instead the instruction is ignored.
> > + */
> > +#define __ex(insn)                                                   \
>
>
> While the previous name was too elaborate, this new name is very
> cryptic.  Unless we are saving for space, it's better to give a somewhat
> descriptive name.

Then we will need to update all usage sites to a new name, something I
tried to avoid.

Uros.

> > +     "666:   " insn "\n"                                             \
> > +     "       jmp 669f\n"                                             \
> > +     "667:\n"                                                        \
> > +     "       .pushsection .discard.instr_begin\n"                    \
> > +     "       .long 667b - .\n"                                       \
> > +     "       .popsection\n"                                          \
> > +     "       call kvm_spurious_fault\n"                              \
> > +     "668:\n"                                                        \
> > +     "       .pushsection .discard.instr_end\n"                      \
> > +     "       .long 668b - .\n"                                       \
> > +     "       .popsection\n"                                          \
> > +     "669:\n"                                                        \
> > +     _ASM_EXTABLE(666b, 667b)
> > +
> >   #define KVM_DEFAULT_PLE_GAP         128
> >   #define KVM_VMX_DEFAULT_PLE_WINDOW  4096
> >   #define KVM_DEFAULT_PLE_WINDOW_GROW 2
