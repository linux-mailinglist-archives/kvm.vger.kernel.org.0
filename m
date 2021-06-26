Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EFC3B4B74
	for <lists+kvm@lfdr.de>; Sat, 26 Jun 2021 02:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhFZASF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 20:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFZASE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 20:18:04 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652CDC061574
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 17:15:42 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id s20-20020a4ae9940000b02902072d5df239so2975541ood.2
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 17:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ilSF5GMUaUIA7eo3QuzFNXPwlDPro49dD/v6T5UEs6c=;
        b=L4DpeCPT+HhVsSAifIKtiDNBRZ/izF04gXRXbiekPmaQa0nr/Gj8dspjSW5ev3mtEy
         vCxNOKqv36iUmrJqpT2zwCc+zyrx8fu2LcZw9PccfGfU+SuLZgmuhJ/cBsvViJA5uyXR
         e3QBLwpox115f1hIaXK8m8iwbBVw/ZDOMTFZGyNty2tW6w+n98tp+Jsx/6VfPOMkG4+o
         X9p81z/88zHjN4mKH9Qi6Sz9to1XYj8Uqjbx09fXkclV/1HELNOlRkN1PMSQ2BYiOhj6
         bxNp6EZhCur8b/zVseCymBSSQAx9qW/0Cg3QKWVLG3H+mz/OGYJUeDQ/2JpoZfnGkrjR
         RoJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ilSF5GMUaUIA7eo3QuzFNXPwlDPro49dD/v6T5UEs6c=;
        b=oCFXroSjPMQEBqAA46VOiUIjZOIOvlHpgoUBxJEWue2neWNpw3PRYok/CjOnKdy/OX
         ws14jRpHI5lqf/Uu554QloggdSCI8D4hWU8K/iov/6/FIdrOgwlM3mrk4baPu1L7unCa
         WwiG8Z8SLAg2FaW6z1/X/B/nRMAZZIUXeQRukELMpCLQhmdJ34Bs/rb2n703QQgmUwTj
         kvnvnmGIzW6cU5D3j4V5zIK2LdDv6XJFJRXKENTEUNbfDXxBEPoM//vGDd94+/kJbneq
         XyGW0H8CdLf1vOs7cs5Xi0nyMfKLt0cQM2FGQ6Z0c/qAwsaZExE01Ox1XxhpJsDkCuy5
         gyFg==
X-Gm-Message-State: AOAM532r8w/bY9xzVe3oYn0sp1gItzZ7lHoK+c16i7RMl4FSFzEM0SX8
        oxgxu/zZMZeN7DIJnAyEfxL6+LbfzvZtYPf86mEBznvvyZk=
X-Google-Smtp-Source: ABdhPJwoBpVOhWw8PSIe+CJ6mF6dqVYu+5aLSxx9TBFG9DEzNVK6T76gOoeLCR+/Mt1EK74zrNtPo/cJ6CNeDgpm0Y8=
X-Received: by 2002:a4a:b203:: with SMTP id d3mr11029822ooo.55.1624666541085;
 Fri, 25 Jun 2021 17:15:41 -0700 (PDT)
MIME-Version: 1.0
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com> <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com> <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru> <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
 <4f40a6e8-07ce-ba12-b3e6-5975ad19a2ff@yandex.ru> <cbaa0b83-fc3a-5732-4246-386a0a0ff9b8@yandex.ru>
 <60ae8b9f-89af-e8b3-13c4-99ddea1ced90@yandex.ru> <19022e7d-e1f5-06b5-f059-27172ca50011@yandex.ru>
 <f09d851d-bda1-7a99-41cb-a14ea51e1237@yandex.ru>
In-Reply-To: <f09d851d-bda1-7a99-41cb-a14ea51e1237@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 25 Jun 2021 17:15:29 -0700
Message-ID: <CALMp9eQWKa1vL+jj5HXO1bm+oMo6gQLNw44P7y6ZaF8_WQfukw@mail.gmail.com>
Subject: Re: exception vs SIGALRM race on core2 CPUs (with fix!)
To:     stsp <stsp2@yandex.ru>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021 at 4:35 PM stsp <stsp2@yandex.ru> wrote:
>
> OK, I've finally found that this
> fixes the race:
>
> --- x86.c.old   2021-03-20 12:51:14.000000000 +0300
> +++ x86.c       2021-06-26 02:28:37.082919492 +0300
> @@ -9176,8 +9176,10 @@
>                  if (__xfer_to_guest_mode_work_pending()) {
>                          srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>                          r = xfer_to_guest_mode_handle_work(vcpu);
> -                       if (r)
> +                       if (r) {
> +kvm_clear_exception_queue(vcpu);
>                                  return r;
> +}
>                          vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>                  }
>          }
>
>
>
> This is where it returns to user
> with the PF exception still pending.
> So... any ideas?

If the squashed exception was a trap, it's now lost.
