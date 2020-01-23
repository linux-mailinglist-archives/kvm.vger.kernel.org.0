Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E887D1470AA
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 19:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAWSWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 13:22:36 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44880 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgAWSWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 13:22:36 -0500
Received: by mail-il1-f196.google.com with SMTP id f16so1793046ilk.11
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 10:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8clo8dXG42zIL/L9nZL9Dx9XAGs9mrDLfnthhdfY8Y=;
        b=V+Sjm1R1nhL0npwIMsw08M2uOWP2QfGRS14RPBDTz1HEgswva+ntVT2eXOtui8fRNy
         NCFOqtf0cvErUsF7f97XV69guOe8TT24ZNf6Zi/1gX4Bqbi8+tmnD0/GsH0/fjJeYenJ
         besrC7mHrghalQX8hPFwTkWSeSAc2LZZa/mZJokhx6TEbgMFLVqGzCc+FxpGqTaD86aa
         G8FMlPcuJqDDfB7PC2NQrqQHqH4dou8KisqYDKqmCbq9uDiTAJ7PPpmZhHvTNPBIknGB
         /Fk/rwD3x/Ao8Az2ws4HSX6N++/TXTOqwRGAF5b1wBSrVHaRqcZObNq24D3rHg24D3Xu
         p5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8clo8dXG42zIL/L9nZL9Dx9XAGs9mrDLfnthhdfY8Y=;
        b=Xmx+Op+/90uDF4IH57Myt6A8JzuqMjF0vM1kCRcYC/ei1mcEwHtXlCSuE8KB5rBWBu
         dSfWppUXedt0GMuobQrFguntVEiXMwW4UsPYT2lmjrUknhz+Mj01v3sS5e/+cCIMfrI3
         jRP4EUGvzstBq3LZa8X42yb2cvnJ6Wvuta3eQvuHktotHLdxOFhzXeMadvVekx+2wsuJ
         6mV7cah+eLVQDkOIj3jnkDpNL8O+o7BhB0FvK4OKgUreatMP6CvT+r+lJdPi6qQHz4o3
         iDQaIc0iU4v03VFFuHixmrLoH1aIqzr8fPiikKcWOlTDfJXCgEReLmcF45NvDe+CQi69
         qOhg==
X-Gm-Message-State: APjAAAX228Fh/c6pUYrG/OIFSTFDDoYShp8OYr8ZOyJKlNzhYUryVg4V
        EyrDrMqABpyRNx0lzHIlM3ekTgiH3vOwcKetZVcIpUv7
X-Google-Smtp-Source: APXvYqzt9yyKrwX6qDon/KVWTbyRb5RYOyonsWZO6Z1k1vq4AHaWPOnc83kRw1cSE+bKh4+oY69Ric6NljkOVgt3JtE=
X-Received: by 2002:a92:8458:: with SMTP id l85mr13969531ild.296.1579803755413;
 Thu, 23 Jan 2020 10:22:35 -0800 (PST)
MIME-Version: 1.0
References: <1579749241-712-1-git-send-email-linmiaohe@huawei.com>
 <8736c6sga7.fsf@vitty.brq.redhat.com> <1a083ac8-3b01-fd2d-d867-2b3956cdef6d@redhat.com>
 <87wo9iqzfa.fsf@vitty.brq.redhat.com> <ee7d815f-750f-3d0e-2def-1631be66a483@redhat.com>
In-Reply-To: <ee7d815f-750f-3d0e-2def-1631be66a483@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 23 Jan 2020 10:22:24 -0800
Message-ID: <CALMp9eRRUY6a_QzbG-rHoZi5zc1YWHLk243=V2VBSQa=HL-Dpw@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: set rflags to specify success in
 handle_invvpid() default case
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 23, 2020 at 1:54 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/01/20 10:45, Vitaly Kuznetsov wrote:
> >>> SDM says that "If an
> >>> unsupported INVVPID type is specified, the instruction fails." and this
> >>> is similar to INVEPT and I decided to check what handle_invept()
> >>> does. Well, it does BUG_ON().
> >>>
> >>> Are we doing the right thing in any of these cases?
> >>
> >> Yes, both INVEPT and INVVPID catch this earlier.
> >>
> >> So I'm leaning towards not applying Miaohe's patch.
> >
> > Well, we may at least want to converge on BUG_ON() for both
> > handle_invvpid()/handle_invept(), there's no need for them to differ.
>
> WARN_ON_ONCE + nested_vmx_failValid would probably be better, if we
> really want to change this.
>
> Paolo

In both cases, something is seriously wrong. The only plausible
explanations are compiler error or hardware failure. It would be nice
to handle *all* such failures with a KVM_INTERNAL_ERROR exit to
userspace. (I'm also thinking of situations like getting a VM-exit for
INIT.)
