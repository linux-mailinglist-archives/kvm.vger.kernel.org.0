Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB9E24D758
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 16:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgHUO1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 10:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgHUO1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 10:27:49 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B22C061573
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 07:27:48 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id m20so1590573eds.2
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 07:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lkGBS94yFL7+NfFus6DctMNa0lsnoHqCaF8XkLSn/eI=;
        b=GjC/A1xV7IkTGBRDEVuIgKtq0RGa60fxJ27ZhyoiWs+x0sPeX0A2HQ1tG7voY+9ZdQ
         tOk3lONH+GvAVPXEp+wFICCxuZXphGGznd9xpyum8CF37tmx+UpHpd8tQ7wDIRw/pdv6
         P6gFF6jrCFEnpl8ptLO5VZUpllNCHKLL5g4mmqPF/Wa13/+X/8VCn5X73hIZn8pynS82
         blXzC6CwyuTvY9KNRilwe+zKmdv9bgMWZxgHNq0fBg//nyiOKxB7/i1tq8fDRkizfcLz
         OIe/VoLiDX0aLTV06fWuKSL+hbRwfkU2FQbOZsDJLjExii1NurRTW70Ac0yLPgA/Vbbz
         3qQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lkGBS94yFL7+NfFus6DctMNa0lsnoHqCaF8XkLSn/eI=;
        b=aH8w857SUapmMi/va2JE4AJ4qla/jFJzjbMKdt5lRkDuB+fXdDDru2zBBFQrFMuMxr
         Aqici0e7RnXKQoF/uAqh/7X9TPiJ2yYMkb+PNsrJt3Xf3scdaddWjBgzLErNLcjefpgC
         h9ohzn0cgDcbUIHtFxUM1jnhL6VHFljcJjS4xUBtayqCSY/sAhv8d6VgeQtX2C1vvnYw
         LeFIzt/79fFgv0uWNMz7WP0z75mvtN5nhuZYLk+5yNQK187qTXFWz79xPr4v+wQ6+zLV
         29VDfdKhBWG+qtm7FZnnr5DmY7gOBskNtd+J61CFsrRJ2rd1anyBn95TnhXWg6Xll5ek
         ThyQ==
X-Gm-Message-State: AOAM531/JATJZvlOxbP/iXbFyqXWZTVHwSIoR38y8YwvqJ8U76LQX8q3
        EVsky/U3ajgLHVLGp2zaZu26I3evtqwM/1APDIfmdg==
X-Google-Smtp-Source: ABdhPJwApJuvemM6r7oEA4TtXDcihJEemMkHwesqdAdUcYbgX0/5yJmvzPaqsmKFiw6EUFHZ364ubIxsag6XDwVM3Ec=
X-Received: by 2002:a05:6402:1758:: with SMTP id v24mr3137591edx.274.1598020067370;
 Fri, 21 Aug 2020 07:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-8-aaronlewis@google.com> <522d8a2f-8047-32f6-a329-c9ace7bf3693@amazon.com>
 <CAAAPnDFEKOQjTKcmkFjP6hr6dgmR-61NL_W9=7Fs0THdOOJ7+Q@mail.gmail.com>
 <d75a3862-d4f4-e057-5d45-9edcb3f9b696@amazon.com> <CALMp9eRQ3FYOW08tbLJ79KJ32dD8K7djSoze9rcV0tuGbfVgLw@mail.gmail.com>
In-Reply-To: <CALMp9eRQ3FYOW08tbLJ79KJ32dD8K7djSoze9rcV0tuGbfVgLw@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 21 Aug 2020 07:27:36 -0700
Message-ID: <CAAAPnDGiBw7U6G61kGuAJOn+vSonvkhm_RQ_nL5_G-4yNSdPPw@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] KVM: x86: Ensure the MSR bitmap never clears
 userspace tracked MSRs
To:     Jim Mattson <jmattson@google.com>
Cc:     Alexander Graf <graf@amazon.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 3:35 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Thu, Aug 20, 2020 at 3:04 PM Alexander Graf <graf@amazon.com> wrote:
> >
> >
> >
> > On 20.08.20 02:18, Aaron Lewis wrote:
> > >
> > > On Wed, Aug 19, 2020 at 8:26 AM Alexander Graf <graf@amazon.com> wrot=
e:
> > >>
> > >>
> > >>
> > >> On 18.08.20 23:15, Aaron Lewis wrote:
> > >>>
> > >>> SDM volume 3: 24.6.9 "MSR-Bitmap Address" and APM volume 2: 15.11 "=
MS
> > >>> intercepts" describe MSR permission bitmaps.  Permission bitmaps ar=
e
> > >>> used to control whether an execution of rdmsr or wrmsr will cause a
> > >>> vm exit.  For userspace tracked MSRs it is required they cause a vm
> > >>> exit, so the host is able to forward the MSR to userspace.  This ch=
ange
> > >>> adds vmx/svm support to ensure the permission bitmap is properly se=
t to
> > >>> cause a vm_exit to the host when rdmsr or wrmsr is used by one of t=
he
> > >>> userspace tracked MSRs.  Also, to avoid repeatedly setting them,
> > >>> kvm_make_request() is used to coalesce these into a single call.
> > >>>
> > >>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > >>> Reviewed-by: Oliver Upton <oupton@google.com>
> > >>
> > >> This is incomplete, as it doesn't cover all of the x2apic registers.
> > >> There are also a few MSRs that IIRC are handled differently from thi=
s
> > >> logic, such as EFER.
> > >>
> > >> I'm really curious if this is worth the effort? I would be inclined =
to
> > >> say that MSRs that KVM has direct access for need special handling o=
ne
> > >> way or another.
> > >>
> > >
> > > Can you please elaborate on this?  It was my understanding that the
> > > permission bitmap covers the x2apic registers.  Also, I=E2=80=99m not=
 sure how
> >
> > So x2apic MSR passthrough is configured specially:
> >
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/arch/x86/kvm/vmx/vmx.c#n3796
> >
> > and I think not handled by this patch?
>
> By happenstance only, I think, since there is also a call there to
> vmx_disable_intercept_for_msr() for the TPR when x2APIC is enabled.

If we want to be more explicit about it we could add
kvm_make_request(KVM_REQ_USER_MSR_UPDATE, vcpu) After the bitmap is
modified, but that doesn't seem to be necessary as Jim pointed out as
there are calls to vmx_disable_intercept_for_msr() there which will
set the update request for us.  And we only have to worry about that
if the bitmap is cleared which means MSR_BITMAP_MODE_X2APIC_APICV is
set, and that flag can only be set if MSR_BITMAP_MODE_X2APIC is set.
So, AFAICT that is covered by my changes.
