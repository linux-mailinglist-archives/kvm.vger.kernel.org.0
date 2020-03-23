Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8512818FDA9
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 20:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgCWTbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 15:31:09 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39682 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbgCWTbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 15:31:09 -0400
Received: by mail-pf1-f194.google.com with SMTP id d25so7981792pfn.6
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 12:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DSiiinnDsM5Ld5HkYiOfO11ZFTG2X1EpUiB46MpxJGU=;
        b=gRoKlRByEmrdJ+1XGErh+VIj4YLl+vePxDE3A6fdOgcivVHRUViqrAbPzcxgGwhnhi
         bDM7UdOSCZI2AanpF39P+26KWSMv64vH6zbFjifBY035FpxkJyg50JoPEEElYgex9cgN
         9CAjArYhHoB9Bu7JPxm1FkN70XxmMi8JbGjY0HLVPqLM46MNUvvozDj/u3qI/T+/Wx0U
         6tOdvkDE034k26A2alpGO62lAKoInSYVqNIcj2zQDg6PjnCM+ogcxVMG0HOnjjdFGu4U
         VPaM+4pMJDSqWW2pTxo/G/ZVIKnoNkFhib1S/AB2zBUIsDRq+u839k1sy+GLdQV/ma50
         3sIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DSiiinnDsM5Ld5HkYiOfO11ZFTG2X1EpUiB46MpxJGU=;
        b=J/Sf4xAdfRgNLtlFu/HGNrMzP6dxx8zFb565jwijVgmgsOTxoEKHQNqRMQMgoj/HW8
         XrXDbem/Ro+szlLH/v3/Pc9GOImCQk1tPzu8gp/2hQF+poV8Mokb/GiJgvVdXkL+C9m2
         mAqrL67SyVSRb5dqmKlC/srfRHkx7VTyw/LZkKeizz6G/fWePZUOdTCRgw8xnuKzhNeb
         jyba/idCAlGJD1u3RQNhXmkH6cF66yhruJQVEh1+9F8R4DBLhGGY50osTBbEGluRmwph
         H/1fgFTXRZcqq2NyXBtHBs1sfQ/ATo7uzxuKQSr4x6/JzKqlMlUqed1mETAjF60kprJe
         I5jQ==
X-Gm-Message-State: ANhLgQ3/ylH/XIEascYPG8KoWZ+6HcH13OxOkVjv0atrkiWHG472lG1O
        KT4xpildkzqqb4bU9i5lsFjHkhmnxdeopTgCA8RL0w==
X-Google-Smtp-Source: ADFU+vsavI6XpX8ossNfyDu1sAijYZq6RsWyzwYZRP5AJ7Y7H4zN+16IYO5VuHGNC2r0BwSOYyTQn7XcqA+DOnYQJi8=
X-Received: by 2002:aa7:8b54:: with SMTP id i20mr25380850pfd.39.1584991867491;
 Mon, 23 Mar 2020 12:31:07 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000277a0405a16bd5c9@google.com> <CACT4Y+b1WFT87pWQaXD3CWjyjoQaP1jcycHdHF+rtxoR5xW1ww@mail.gmail.com>
 <5058aabe-f32d-b8ef-57ed-f9c0206304c5@redhat.com> <CAG_fn=WYtSoyi63ACaz-ya=Dbi+BFU-_mADDpL6gQvDimQscmw@mail.gmail.com>
 <20200323163925.GP28711@linux.intel.com> <CAKwvOdkE8OAu=Gj4MKWwpctka6==6EtrbF3e1tvF=jS2hBB3Ow@mail.gmail.com>
 <CAKwvOdkXi1MN2Yqqoa6ghw14tQ25WYgyJkSv35-+1KRb=cmhZw@mail.gmail.com>
 <CAG_fn=WE0BmuHSxUoBJWQ9dnZ4X5ZpBqcT9rQaDE_6HAfTYKQA@mail.gmail.com>
 <CAG_fn=Uf2dDo4K9X==wE=eL8HQMc1an8m8H18tvWd9Mkyhpskg@mail.gmail.com>
 <CAKwvOdntYiM8afOA2nX6dtLp9FWk-1E3Mc+oVRJ_Y8X-9kr81Q@mail.gmail.com> <CAKwvOdn10Ts_AU6i+7toj7NkMwK-+0yr5wTrN0XEDudBWS0sPQ@mail.gmail.com>
In-Reply-To: <CAKwvOdn10Ts_AU6i+7toj7NkMwK-+0yr5wTrN0XEDudBWS0sPQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 23 Mar 2020 12:30:53 -0700
Message-ID: <CAKwvOdnwhoHe8ouao2VBo1meRd8H4EOC7Nr8hnFkbXBACWRm9w@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in handle_external_interrupt_irqoff
To:     Alexander Potapenko <glider@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        syzbot <syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 11:49 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> So maybe we can find why
> commit 76b043848fd2 ("x86/retpoline: Add initial retpoline support")
> added THUNK_TARGET with and without "m" constraint, and either:
> - remove "m" from THUNK_TARGET. (Maybe this doesn't compile somewhere)
> or
> - use my above recommendation locally avoiding THUNK_TARGET.  We can
> use "r" rather than "a" (what Clang would have picked) or "b (what GCC
> would have picked) to give the compilers maximal flexibility.

So I've sent a patch for the latter; my reason for not pursuing the former is:
1. I assume that the thunk target could be spilled, or a pointer, and
we'd like to keep flexibility for the general case of inline asm that
doesn't modify the stack pointer.
2. `entry` is local to `handle_external_interrupt_irqoff`; it's not
being passed in via pointer as a function parameter.
3. register pressure is irrelevant if the resulting code is incorrect.
-- 
Thanks,
~Nick Desaulniers
