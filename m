Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0B3176169
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 18:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgCBRpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 12:45:00 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40356 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbgCBRo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 12:44:58 -0500
Received: by mail-io1-f65.google.com with SMTP id m22so300814ioj.7
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 09:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bkqP5rqEcpTe8UkETGyC05Piyo30bTlkBX2zfQhiYak=;
        b=K2xxZ6k/fKXqdRvOCWx+o0bgdJCP+yd8W5j2364rXc8L702Bc1Wmif/AzeGUaoIyvt
         k+m2aJ6AslxkpZ7mQvFRmnQmUhN7o2ZrWI4XqX8MaxkmDTI//BwWcP+tcLjTnbeuZdw3
         AFIkLe2W3PLWkNJWv8VOOwhopZKemlZSEyOlt7ytg9COABmAEhASuOHZXULeApfo2u6w
         SR3ILAve6uo6HzklXFmk6HLFDkJYi2icuDuAlMo0RCTJVmtHsDzjMfFeoGsfzo0Vm0lf
         Hx4wx/5eCmF01cHqrVDwGS39wRsdH2jF4ADU03NfOweDwrEp3RNCeYBELbPVnR8zFjLE
         g0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bkqP5rqEcpTe8UkETGyC05Piyo30bTlkBX2zfQhiYak=;
        b=h3T11SrNdEOAL7GP/oQMjvWl6XxiADkH8/LSGwNqOOfEz0zGdORlt/UrOeTXx17AQ+
         rpNmuKxaT+gogRz9KwGU9XdC9u0p1mPG3I9PGxDbgoCkcMufCJebbu9l82PEz0gSYxxH
         s8Cm+6OpElWFfcaCbIhZi4lLzdQJIkwCEGEY/WKbvRM7XlVjJ5qZzuS/xVD0pI1agF0S
         U6utNSz0Hlbzl2W3khFKhxr4isbDhNYD/5MuV1HzDjizEQauUT6xf63UpB7lrx98Q42D
         0ugJlYhGO/8AFPJPk8O/hV9rLZx3CaW/mkNg3waaoTyP5yA4rhSEHR9FJc/mwDbAgESQ
         lfgA==
X-Gm-Message-State: ANhLgQ2W4aahTWhLTL58lU999QHQyPCrzflbNCGXQQ7e7ybKj6TrimfM
        sCr7ibbCFf3f4Z0PYrVPzCxw4smMhZAXH/4xpd+IuQ==
X-Google-Smtp-Source: ADFU+vtX00vo2g2GZFlbw53ClqMtaKWhDpEWgjNmTVZc8q6YVuwN/BIthZga8jq4MTg4rwSiAe6hEGv+A/C/nYA77JU=
X-Received: by 2002:a6b:c986:: with SMTP id z128mr563097iof.296.1583171096690;
 Mon, 02 Mar 2020 09:44:56 -0800 (PST)
MIME-Version: 1.0
References: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
 <CALMp9eSaZ557-GaQUVXW6-ZrMkz8jxOC1S6QPk-EVNJ-f2pT5w@mail.gmail.com> <a1ff3db1-1f5a-7bab-6c4b-f76e6d76d468@redhat.com>
In-Reply-To: <a1ff3db1-1f5a-7bab-6c4b-f76e6d76d468@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 2 Mar 2020 09:44:45 -0800
Message-ID: <CALMp9eQqFKnCLYGXdab-k=Q=h-H5x8VnV20F3HH9fDZTDuQcEQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: deprecate obsolete KVM_GET_CPUID2 ioctl
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linmiaohe <linmiaohe@huawei.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 2, 2020 at 9:09 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/03/20 18:01, Jim Mattson wrote:
> >> And in fact, it's not used anywhere. So it should be
> >> deprecated.
> > I don't know how you can make the assertion that this ioctl is not
> > used anywhere. For instance, I see a use of it in Google's code base.
>
> Right, it does not seem to be used anywhere according to e.g. Debian
> code search but of course it can have users.
>
> What are you using it for?  It's true that cpuid->nent is never written
> back to userspace, so the ioctl is basically unusable unless you already
> know how many entries are written.  Or unless you fill the CPUID entries
> with garbage before calling it, I guess; is that what you are doing?

One could use GET_CPUID2 after SET_CPUID2, to see what changes kvm
made to the requested guest CPUID information without telling you.
