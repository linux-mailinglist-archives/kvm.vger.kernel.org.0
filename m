Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195F62D1829
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 19:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgLGSFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 13:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLGSFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 13:05:34 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483C9C0617B0
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 10:04:48 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id q22so10800013pfk.12
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 10:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=kbV3WSMn8Z3r9fdGwZbCofxQ8ZlQoCXfrnC4rA/3kXU=;
        b=BvSGPkk1XV51HulmhP09dGtC50Mqu3r9NSlD6Rtp/fEgFbKCUYHJxoiQ/Lw026a8eV
         8pkollCNLgLs0UCVhW4o6brcgbS7lvxuFZaOmJ+LJEDtCq8YuLMMQZrtArDfIaA4qRjK
         1rYEF7M/0093Uw/TQm30akYxGr+J8KFgSt2kBgvDwZmhZx7l1TrKcKnw/BLb64ju6OEZ
         7uNmPHrSbOS4KEe61x/bBDbhbX48C3Z5YfVlyWUBeqc96naM8cDULIA2yeOq4vSQjPXK
         LnXlIyvD6dTz28bK9V8o5Ko8tRYCjDgrUKZ2yxSAi3weyMM2+TT4+dd//sg+88u0Yyhh
         csoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=kbV3WSMn8Z3r9fdGwZbCofxQ8ZlQoCXfrnC4rA/3kXU=;
        b=mVUgVrT3KuJvTNFhXoAcg+4draXdLItFrw3IeJqfQgT3xnnzwRUK8V0zN5kO5GG3rT
         ukduGRlAE25/y4PiJJIfdDKJ/w0osrNWkm3Wy2T27mATSs4wzi6Kq8IrAs8A44oM2qKv
         i0i5tE2u5gXB+p8XHBIb+yubuKafnazaPGC85ICHM2s5DxDnfKsbAyJgJK/0feSF6edL
         Ss+WsFZve6URd3jfnREJllSm+TVfuzPj7P7cQNifQoQNsx1dU7jDqjUWUqxcLE7FvLQx
         3eHyTbEyaFcrHBHr1jwtCwGGfn6LXrQIo8DkR6IaXtj2+6693Qgi2pqthrnS7IFed3rk
         ybXQ==
X-Gm-Message-State: AOAM530pnYuDcUN0PGyZ4/6HIh6qrh8HvoZOtaYASz7aiHeXAfB9H0W6
        KpKll9CaRYwe1CXyVQAVadxFdg==
X-Google-Smtp-Source: ABdhPJwV3xytw1x+Of85bMOMEIGarLom/VlHMSxobmAAr7XDbFmck2N5F2W7tVz+G+34gQVIMGV2aQ==
X-Received: by 2002:a62:1c88:0:b029:197:f6e4:bc2b with SMTP id c130-20020a621c880000b0290197f6e4bc2bmr17027674pfc.6.1607364287776;
        Mon, 07 Dec 2020 10:04:47 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:4be:8206:69d7:62c1? ([2601:646:c200:1ef2:4be:8206:69d7:62c1])
        by smtp.gmail.com with ESMTPSA id x1sm15247910pfj.95.2020.12.07.10.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 10:04:47 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 1/3] KVM: x86: implement KVM_{GET|SET}_TSC_STATE
Date:   Mon, 7 Dec 2020 10:04:45 -0800
Message-Id: <885C1725-B479-47F6-B08D-A7181637A80A@amacapital.net>
References: <636fecc20b0143128b484f159ff795ff65d05b82.camel@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
In-Reply-To: <636fecc20b0143128b484f159ff795ff65d05b82.camel@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
X-Mailer: iPhone Mail (18B121)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Dec 7, 2020, at 9:00 AM, Maxim Levitsky <mlevitsk@redhat.com> wrote:
>=20
> =EF=BB=BFOn Mon, 2020-12-07 at 08:53 -0800, Andy Lutomirski wrote:
>>>> On Dec 7, 2020, at 8:38 AM, Thomas Gleixner <tglx@linutronix.de> wrote:=

>>>=20
>>> =EF=BB=BFOn Mon, Dec 07 2020 at 14:16, Maxim Levitsky wrote:
>>>>> On Sun, 2020-12-06 at 17:19 +0100, Thomas Gleixner wrote:
>>>>> =46rom a timekeeping POV and the guests expectation of TSC this is
>>>>> fundamentally wrong:
>>>>>=20
>>>>>     tscguest =3D scaled(hosttsc) + offset
>>>>>=20
>>>>> The TSC has to be viewed systemwide and not per CPU. It's systemwide
>>>>> used for timekeeping and for that to work it has to be synchronized.=20=

>>>>>=20
>>>>> Why would this be different on virt? Just because it's virt or what?=20=

>>>>>=20
>>>>> Migration is a guest wide thing and you're not migrating single vCPUs.=

>>>>>=20
>>>>> This hackery just papers over he underlying design fail that KVM looks=

>>>>> at the TSC per vCPU which is the root cause and that needs to be fixed=
.
>>>>=20
>>>> I don't disagree with you.
>>>> As far as I know the main reasons that kvm tracks TSC per guest are
>>>>=20
>>>> 1. cases when host tsc is not stable=20
>>>> (hopefully rare now, and I don't mind making
>>>> the new API just refuse to work when this is detected, and revert to ol=
d way
>>>> of doing things).
>>>=20
>>> That's a trainwreck to begin with and I really would just not support it=

>>> for anything new which aims to be more precise and correct.  TSC has
>>> become pretty reliable over the years.
>>>=20
>>>> 2. (theoretical) ability of the guest to introduce per core tsc offfset=

>>>> by either using TSC_ADJUST (for which I got recently an idea to stop
>>>> advertising this feature to the guest), or writing TSC directly which
>>>> is allowed by Intel's PRM:
>>>=20
>>> For anything halfways modern the write to TSC is reflected in TSC_ADJUST=

>>> which means you get the precise offset.
>>>=20
>>> The general principle still applies from a system POV.
>>>=20
>>>    TSC base (systemwide view) - The sane case
>>>=20
>>>    TSC CPU  =3D TSC base + TSC_ADJUST
>>>=20
>>> The guest TSC base is a per guest constant offset to the host TSC.
>>>=20
>>>    TSC guest base =3D TSC host base + guest base offset
>>>=20
>>> If the guest want's this different per vCPU by writing to the MSR or to
>>> TSC_ADJUST then you still can have a per vCPU offset in TSC_ADJUST which=

>>> is the offset to the TSC base of the guest.
>>=20
>> How about, if the guest wants to write TSC_ADJUST, it can turn off all pa=
ravirt features and keep both pieces?
>>=20
>=20
> This is one of the things I had in mind recently.
>=20
> Even better, we can stop advertising TSC_ADJUST in CPUID to the guest=20
> and forbid it from writing it at all.

Seems reasonable to me.

It also seems okay for some MSRs to stop working after the guest enabled new=
 PV timekeeping.

I do have a feature request, though: IMO it would be quite nifty if the new k=
vmclock structure could also expose NTP corrections. In other words, if you c=
ould expose enough info to calculate CLOCK_MONOTONIC_RAW, CLOCK_MONOTONIC, a=
nd CLOCK_REALTIME, then we could have paravirt NTP.

Bonus points if whatever you do for CLOCK_REALTIME also exposes leap seconds=
 in a race free way :). But I suppose that just exposing TAI and letting the=
 guest deal with the TAI - UTC offset itself would get the job done just fin=
e.
