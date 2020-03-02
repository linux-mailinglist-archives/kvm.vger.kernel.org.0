Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B7A1762B7
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 19:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgCBSae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 13:30:34 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:40726 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgCBSae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 13:30:34 -0500
Received: by mail-il1-f196.google.com with SMTP id g6so368601ilc.7
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 10:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c9N8pmiznJwsvAz0Mn6RIRQBpDbT8QYW9ssTcn5Srt0=;
        b=ofrDh/W03+qXgcSrm3KyNkAyQydWdBRXEXFaC9ZchLmfzEVU1Y60uEB3nFcuG7bgJE
         +Z6e5pb9O93lPOefpvXtL85n8V3UhvZmr4hxaKsvf53treihjwahZH6t5cQrwZHUDEl6
         gZhEGy5ZG9qzRUf/4W8I3f2w3G2NKzmf01J6xyd2jottQIPjMYgYuSoQGuqfSRtKjvmE
         07hYHcN8TjXtTAE2BvqPIdSOtRvhkmrXJ4GwZeKtmuAH1YSRA6vlSXYp9Hsz86kJPPjl
         cOnbrQyg9ijriyRgciuxqarlh4bzlG28g0N3DuIdHVZwU6SX40gRznJheV22kpJvu8fs
         zL3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c9N8pmiznJwsvAz0Mn6RIRQBpDbT8QYW9ssTcn5Srt0=;
        b=HvkzmhUL4IO8WSMkj+Zp/ukOswTNurYd+ChLtQ/S511oDQTzCNL5MC9TJ4hKhMkwrr
         lzS69Jwck37PLvRkdbj8JSGiPPyayoVYR/YMiSCkmPZ6QT37mI4Sw+zPFWKeSnxGg10H
         0DGPL5zUoRsSatNmySvKUY5BL2s6yEoS5jTHY5vSBL/CTJ7NxgPu2Xt7dVeww4/kXZ24
         qUrYVebchhv97XlHwaXaJfC4Lv0naU5/uWKQJcBVGExva097bhxFt3SEjhdg0XycqJm6
         hOZlUL6oWgKJ0yjn/dMHDC936XXfzkPMArxOBehiGqvDmSD9R/j4dqxZVmXEdR+LptKQ
         coMg==
X-Gm-Message-State: ANhLgQ1SU+l5tydYjCa6/0m+9kPhMP0oAJIxee7IuS5RIrgBiyp1P+qt
        60mMnw7XEDpQ/s6n5+t0IaYwVZ24b6gYsKUz93pFwA==
X-Google-Smtp-Source: ADFU+vvfk/PTke3DmzOx8p1qiyiPWh39Gz/B81yPLGojcctURiXpbxbIgA4e1hpdnL9cY23/exLfgXJeZpz9wnvlANI=
X-Received: by 2002:a92:8547:: with SMTP id f68mr976871ilh.26.1583173833493;
 Mon, 02 Mar 2020 10:30:33 -0800 (PST)
MIME-Version: 1.0
References: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
 <CALMp9eSaZ557-GaQUVXW6-ZrMkz8jxOC1S6QPk-EVNJ-f2pT5w@mail.gmail.com>
 <a1ff3db1-1f5a-7bab-6c4b-f76e6d76d468@redhat.com> <CALMp9eQqFKnCLYGXdab-k=Q=h-H5x8VnV20F3HH9fDZTDuQcEQ@mail.gmail.com>
 <e173c489-dee7-a86d-3ec4-6fe45938a2d8@redhat.com>
In-Reply-To: <e173c489-dee7-a86d-3ec4-6fe45938a2d8@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 2 Mar 2020 10:30:22 -0800
Message-ID: <CALMp9eR9uanguked_O97BXMVGSE032m8QVsBP2qe2SS97j+qmg@mail.gmail.com>
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

On Mon, Mar 2, 2020 at 10:02 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/03/20 18:44, Jim Mattson wrote:
> > On Mon, Mar 2, 2020 at 9:09 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 02/03/20 18:01, Jim Mattson wrote:
> >>>> And in fact, it's not used anywhere. So it should be
> >>>> deprecated.
> >>> I don't know how you can make the assertion that this ioctl is not
> >>> used anywhere. For instance, I see a use of it in Google's code base.
> >>
> >> Right, it does not seem to be used anywhere according to e.g. Debian
> >> code search but of course it can have users.
> >>
> >> What are you using it for?  It's true that cpuid->nent is never written
> >> back to userspace, so the ioctl is basically unusable unless you already
> >> know how many entries are written.  Or unless you fill the CPUID entries
> >> with garbage before calling it, I guess; is that what you are doing?
> >
> > One could use GET_CPUID2 after SET_CPUID2, to see what changes kvm
> > made to the requested guest CPUID information without telling you.
>
> Yeah, I think GET_CPUID2 with the same number of leaves that you have
> passed to SET_CPUID2 should work.

Having said that, it doesn't look like the method that invokes this
ioctl (in Google's code base) gets called from anywhere.
