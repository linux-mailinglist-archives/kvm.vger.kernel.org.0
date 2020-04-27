Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DAF1BAB4E
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 19:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgD0Raf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 13:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgD0Rae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 13:30:34 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB687C0610D5
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 10:30:34 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id s10so17463917iln.11
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 10:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WAmnZAQqsfdyDzhsu6wAOJW6mDvNQHToHiDwv+tvXL0=;
        b=rM6jBlbJF1p0rjqRj7enKn0xq7UtAq83W7/SMdsqwx7j8hmwJeU36VtGxm8+GhlYgi
         Ve6dpPf9g/k7UAXG5Kz3hp4z6YzgMyETLRyzSpcdDp9PkOJjRsWZGuyxr1Guxa1Qgx5h
         9HsDiljnE8iqsOYg9kr3Nl0Y+4k6JN3ZLOUNhj4aKH1LQtSMaK9Zmf8fLI2E78lgUGHz
         Rd/Gk7s4nR2oYB/JsvK/t2tZ4Pk9T0UC45bJ22686Gnmk1YPYfR5ss4L+L95lXOsU5ev
         WlZvRr3Z3PaNGYEQoz8EazMzdRqDlGQ/y/xmK9Z8BLvfiiLjQv1f3l6cJNPklESdAKt9
         c2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WAmnZAQqsfdyDzhsu6wAOJW6mDvNQHToHiDwv+tvXL0=;
        b=gpHVKnXIDYAohorGYCVvc7H3LzYv0sKf61k7J9swWMN3Gs7fTkzxlWGxmgzMiVCIlj
         vDnrG5gbYYZexMFkB0cKTQaXgT4kTRCNtqh/gXmD4ymgGNerk4bEgPEX6pcQNdjQ0Scl
         xZ3GXfklI/5BrQxk5BbF0ZF5jZX/IIOUaStjPoQKBlsDwM02MLJOI26IB4lo/PRCkn3l
         9YqFtO1MolhR8qYFxeQMZKTpWhMGijY8x7aznZNWtwXNF+ZumD7dlE6q1oTnOCx+U+Ni
         Mfc2dNC0n0h4AypUiJkUi6M+qwQA3ZBuTv9pmt08BZ8Yavtm77Iz7NZaYvlJMQxiTcBm
         kQSw==
X-Gm-Message-State: AGi0PubAO7QAETSMa+tsNBNNC4uPYDuk7d5egy9HrUCbRuidhHw2IU2o
        wCKbqrAFhYClXokIkwmJM8WeNt7qg/xECXHoFhD99A==
X-Google-Smtp-Source: APiQypLYGcoWKQQgcyvEo8F50ZL+lo84Kee1KKs7UcdGmTDiIyOyUYlVajqWTGznlrcpj+c81fTJlOxSHfqZrkYwiqE=
X-Received: by 2002:a92:da4e:: with SMTP id p14mr22191527ilq.296.1588008633445;
 Mon, 27 Apr 2020 10:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <1587704935-30960-1-git-send-email-lirongqing@baidu.com>
 <20200424100143.GZ20730@hirez.programming.kicks-ass.net> <20200424144625.GB30013@linux.intel.com>
 <CALMp9eQtSrZMRQtxa_Z5WmjayWzJYhSrpNkQbqK5b7Ufxg-cMA@mail.gmail.com>
 <ce51d5f9-aa7b-233b-883d-802d9b00e090@redhat.com> <fd2a8092edf54a85979e5781dc354690@baidu.com>
In-Reply-To: <fd2a8092edf54a85979e5781dc354690@baidu.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 27 Apr 2020 10:30:22 -0700
Message-ID: <CALMp9eQrGuqzy_ZRu+qU3A7PRkoi8JHWFRpm---cMhp9+J4j8A@mail.gmail.com>
Subject: Re: [PATCH] [RFC] kvm: x86: emulate APERF/MPERF registers
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 25, 2020 at 8:24 PM Li,Rongqing <lirongqing@baidu.com> wrote:
>
>
>
> > -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: Paolo Bonzini [mailto:pbonzini@redhat.com]
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B44=E6=9C=8825=E6=97=
=A5 0:30
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: Jim Mattson <jmattson@google.com>; Sean Ch=
ristopherson
> > <sean.j.christopherson@intel.com>
> > =E6=8A=84=E9=80=81: Peter Zijlstra <peterz@infradead.org>; Li,Rongqing
> > <lirongqing@baidu.com>; LKML <linux-kernel@vger.kernel.org>; kvm list
> > <kvm@vger.kernel.org>; the arch/x86 maintainers <x86@kernel.org>; H .
> > Peter Anvin <hpa@zytor.com>; Borislav Petkov <bp@alien8.de>; Ingo Molna=
r
> > <mingo@redhat.com>; Thomas Gleixner <tglx@linutronix.de>; Joerg Roedel
> > <joro@8bytes.org>; Wanpeng Li <wanpengli@tencent.com>; Vitaly Kuznetsov
> > <vkuznets@redhat.com>
> > =E4=B8=BB=E9=A2=98: Re: [PATCH] [RFC] kvm: x86: emulate APERF/MPERF reg=
isters
> >
> > On 24/04/20 18:25, Jim Mattson wrote:
> > >> Assuming we're going forward with this, at an absolute minimum the
> > >> RDMSRs need to be wrapped with checks on host _and_ guest support fo=
r
> > >> the emulated behavior.  Given the significant overhead, this might
> > >> even be something that should require an extra opt-in from userspace=
 to
> > enable.
> > >
> > > I would like to see performance data before enabling this uncondition=
ally.
> >
> > I wouldn't want this to be enabled unconditionally anyway, because you =
need to
> > take into account live migration to and from processors that do not hav=
e
> > APERF/MPERF support.
> >
> > Paolo
>
> I will add a kvm parameter to consider whether enable MPERF/APERF emulati=
ons, and make default value to false

Wouldn't it be better to add a per-VM capability to enable this feature?
