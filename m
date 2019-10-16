Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3C0D9DBB
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 23:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436789AbfJPVwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 17:52:42 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55140 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394765AbfJPVwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 17:52:42 -0400
Received: by mail-wm1-f68.google.com with SMTP id p7so371067wmp.4
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 14:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hjzmwKGu/3zrD2JsZedalTcHU0Ugg9lduf9lWwIfnAg=;
        b=PfJcUTqcb3JgDFGudFG7USth/sx2RzJQ+0TCPoILDDlo7hZVCPf5JqmV/CEa6ugT/m
         RlKohZ0P4ucxOxRQ9iKnFecLFeyvEHujoXRk+wAr+jMWEfxLjZzyqyWhHwKkyXtFPeId
         zb/Uui6C2JIpqwEZTARy87I6KZRWxNUW9xECM9fRWi2JP0/Z74pRZ1eisHbWftUZP+eV
         m/X65RCkHkly0iHrcNihalXxj/4AgR2bBaTTkzyw9IBCTJYauyj3OUaA9vc8XuEn4TJi
         U6MbaDy/OFiCVro1t5l30l7QKMIDxt23TcauziZVgv5NdfRNfSUvIGUs6pwEPQWbM5ZE
         qDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hjzmwKGu/3zrD2JsZedalTcHU0Ugg9lduf9lWwIfnAg=;
        b=SwI3ZuHp+0oH7VfAQBtbYwXQMHxfVqeinTGQVTAQjfNuQut/9VHQSBy0J84BH3BHbF
         X1UlGDHuo8yHWsRY0DgI2dhovpa2esrPHSdXqn6l4U6eIKzCrcjMJd+x/+jgzkLX826/
         qwVRuzMIsTI4DzqJECRYEnbqLV6VQ5MUsKHEdNMgT6qiI1GXtLFBFdyI1gPhz1TduyFr
         CgD/4V3pz1iQ1k6jrD3vdN8ZOPqPRmYFWVPRS3APp9j5a0ROumyJXfLFB+hUr27QxH1Z
         UQj7wXfs4p4ljvwZIV5YWa9VonfoB29ToQfURV5VvB7GNmRafcQaEyn6z7UggyC8gaAA
         EA3w==
X-Gm-Message-State: APjAAAW7JIm6SxLuq3kkUJKnEPd2+IduHqtNcoH6bo0GxEG/zGavyiFX
        S3c1KxBlUgODER+Oa5SnIYdtkyLccVhBxRB13U+ZJA==
X-Google-Smtp-Source: APXvYqwNPweyE9qk98XN/v/Z4LgWRcr/j7+gmR1uHyFPCRROI6R6bI/dmqtpmwB/b+At/lT/vWdMMO+uHVSFW3gVykQ=
X-Received: by 2002:a1c:a752:: with SMTP id q79mr5180240wme.32.1571262759771;
 Wed, 16 Oct 2019 14:52:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191012235859.238387-1-morbo@google.com> <20191012235859.238387-3-morbo@google.com>
 <CALMp9eSK_O24gYg6J7U-eL1Lq4Y=YaXSaQVZhXs+1RSM+h83ew@mail.gmail.com>
In-Reply-To: <CALMp9eSK_O24gYg6J7U-eL1Lq4Y=YaXSaQVZhXs+1RSM+h83ew@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 16 Oct 2019 14:52:28 -0700
Message-ID: <CALMp9eTGd6MWdePCfwG5QBLpfmVoTg8XGH55MkXxzfa=biG1WA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: realmode: use inline asm to get
 stack pointer
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 16, 2019 at 12:53 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Sat, Oct 12, 2019 at 4:59 PM Bill Wendling <morbo@google.com> wrote:
> >
> > It's fragile to try to retrieve the stack pointer by taking the address
> > of a variable on the stack. For instance, clang reserves more stack
> > space than gcc here, indicating that the variable may not be at the
> > start of the stack. Instead of relying upon this to work, retrieve the
> > "%rbp" value, which contains the value of "%rsp" before stack
> > allocation.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  x86/realmode.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/x86/realmode.c b/x86/realmode.c
> > index cf45fd6..7c89dd1 100644
> > --- a/x86/realmode.c
> > +++ b/x86/realmode.c
> > @@ -518,11 +518,12 @@ extern void retf_imm(void);
> >
> >  static void test_call(void)
> >  {
> > -       u32 esp[16];
> >         u32 addr;
> >
> >         inregs = (struct regs){ 0 };
> > -       inregs.esp = (u32)esp;
> > +
> > +       // At this point the original stack pointer is in %ebp.
> > +       asm volatile ("mov %%ebp, %0" : "=rm"(inregs.esp));
>
> I don't think we should assume the existence of frame pointers.
> Moreover, I think %esp is actually the value that should be saved
> here, regardless of how large the current frame is.

Never mind. After taking a closer look, esp[] is meant to provide
stack space for the code under test, but inregs.esp should point to
the top of this stack rather than the bottom. This is apparently a
long-standing bug, similar to the one Avi fixed for  test_long_jmp()
in commit 4aa22949 ("realmode: fix esp in long jump test").

For consistency with test_long_jmp, I'd suggest changing the
inregs.esp assignment to:
       inregs.esp = (u32)(esp+16);

Note that you absolutely must preserve the esp[] array!

> >         MK_INSN(call1, "mov $test_function, %eax \n\t"
> >                        "call *%eax\n\t");
> > --
> > 2.23.0.700.g56cf767bdb-goog
> >
