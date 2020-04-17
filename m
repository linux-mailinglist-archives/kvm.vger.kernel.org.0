Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882591ADD48
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 14:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgDQMZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 08:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728234AbgDQMZR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 08:25:17 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D114BC061A0C
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 05:25:17 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f19so2077721iog.5
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 05:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PR6Ojf2TDhq9W2ewHr/WXlinGP4aWfTFOxJjMQsnHz8=;
        b=Dji+oRESpBn6CnjuBbVjepe/5K6DQz3BIf3KJFPS7Z9hY1weJ3avn/mp7DNbFunp/e
         rmkjTWV/4Sxnp2QjXBsamDezuwX14R56/VNb88Ms658R4COjy4L4U7Esvei1BsF/ScIU
         veEyLhvqqIC2lWk6B9E7hL8mlJq8baNDehoZyuPlQq844vK+GrhvHffgqfCegk5yFXI0
         6JGsRmoKZAaspb937IpcymIS5LtgjTe4CVA2MOt0Tsr4VQi4F9tRuCd0UaUQxCHpZIYr
         Z684cfRPLNkjm+0FfXGygzR2z35jaGx1xbjvKCZdrqPwySLtGfdWrmXumsWBM78UfRv4
         v59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PR6Ojf2TDhq9W2ewHr/WXlinGP4aWfTFOxJjMQsnHz8=;
        b=OjcG7MG8UEzM3437uS8vq/Vj7MxF9+RQc4fj4Bmg6q/KelKzbztjALoZ4Fo2v65zPD
         bvR2nuLfumrPIx6tFSEZ+4gsZJ/bYnECSgpE8AdPlfyF8AOm3EYpnxjCZHw77xZg+lus
         jUoKc/VeHM0CJz4917bCwpx1BW0izeHo4FvVlDz1NSiwGeLEdqwALR0Xba6NN+0UAVt9
         bJLT0ViyURjqybl3gs1e7Op1V/XrsQTsilGMmshohxdOxL8gBxzVLQl+eJH/klTRf55C
         OTbB2aAmyn1QFbfFsgq3UYDvaJRzx5/Y94LLJT4Oa0LP/94u4NUoiA3+e5QAibXBf/6e
         iJqw==
X-Gm-Message-State: AGi0Puau9UkZcNt2+EbjSTQ+Yx5hJyrDwEPHztn/5O9ePjcS5nu9TWqi
        S5MmckW7RCxdebU3qwOLrTs9GUz7zx5nLfpp3VTZYagdgyw=
X-Google-Smtp-Source: APiQypLrjLKMit5PZ32Q1EVzWsu5lX+2SHSbOaeXhmKuj8lTWGdiQUdjOOFc0VoXuE2UBUEU2mvSu3vf2snU0MrQHmI=
X-Received: by 2002:a6b:f20f:: with SMTP id q15mr1005488ioh.48.1587126317105;
 Fri, 17 Apr 2020 05:25:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200417113524.1280130-1-ubizjak@gmail.com> <140c189d-4e82-1af5-6a59-6ea42fb818b9@redhat.com>
In-Reply-To: <140c189d-4e82-1af5-6a59-6ea42fb818b9@redhat.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Fri, 17 Apr 2020 14:25:05 +0200
Message-ID: <CAFULd4YWpxUH6WJbqT5wvPu1d_HzZ+hXvnOu=CScaXQk=H4=UA@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Improve handle_external_interrupt_irqoff inline assembly
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 2:07 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 17/04/20 13:35, Uros Bizjak wrote:
> > Improve handle_external_interrupt_irqoff inline assembly in several ways:
> > - use __stringify to use __KERNEL_DS and __KERNEL_CS directly in assembler
>
> What's the advantage of this to pushing cs and ss?  We are faking an
> interrupt gate, and interrupts push cs and ss not __KERNEL_DS and
> __KERNEL_CS.

I see. If the current form is documenting the above, then there is
indeed no compelling reason for the change.
>
> > - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> > - use $-16 immediate to align %rsp
> > - avoid earlyclobber by using "l" GCC input operand constraint
>
> What is this and where is it documented?!? :)

I was going to say that it is documented in [1] under x86 family
section, but indeed, there is no description of "l" constraint. It is
internal to the compiler. :(

(define_register_constraint "l" "INDEX_REGS"
 "@internal Any register that can be used as the index in a base+index
  memory access: that is, any general register except the stack pointer.")

Other changes are minor and really not worth the maintainer's time to
handle the patch. Please consider the patch retracted.

[1] https://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html

Uros.
