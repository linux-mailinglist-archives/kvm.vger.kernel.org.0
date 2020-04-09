Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A68071A3BEB
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 23:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgDIV2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 17:28:49 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37026 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbgDIV2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 17:28:49 -0400
Received: by mail-qk1-f194.google.com with SMTP id 130so307476qke.4
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 14:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KzqITVc/bBuEyLxzGIUIGtxALz12p2/0ce0mFYQIrPw=;
        b=L3VCXeGZiWNM74gXaSrx+3mPzlGogn91XBElMPwwaPBjS06I2nPALy+i/MBQMdQvyu
         oHYJTsUT3HqgCyDGpJmLO3XkpzojxVL0DhtI14l0WdUTwSyEbjx2c4Sx3TsvInCrj79j
         8Hbf6MhVaotW6uceGggZuwA651T6eGKUd+eZwFO+43rZzmOT35qR859lkVgO0dQ0Ityu
         2mrSOs/dNjE2LDMFxEi4hP/7hEsDQ6JlXuE0UH3YW5YGB5qqN3t6BXLC+9O5uzyPSx57
         FLgHRTDlCX9hTMzViFFA3772sIZAZGil+/WGauSudUJWm/mvqxCn49ph+PwsEwynIfII
         9Maw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KzqITVc/bBuEyLxzGIUIGtxALz12p2/0ce0mFYQIrPw=;
        b=JG8mtDrm34rwnSMtlIWeVr/t05N4R8iAnQ6lX5xHwdxpFp6fkmZQIyCrz4YMHMduGw
         djfbtr9Rau95FJ4xxfALHyRLl0clkZoB1zgEttwKte2Zw5Dp0p0XPxZL2inoMTjYtT98
         wAocSlmKR88thweSDwKv4f6u2PPBEUk5nGKiw8IYN2SiLCglgYcRZH5QIMWH3OHY+zYd
         yV03/PfvYnlbuv3RX0gkpD691xiB75GMA1bRCoWgDhSd9mL4wlkxZ02WBkh13XcO2bEC
         FzPopbvGtLVx9c4eu8cbmJLDGo5ZvoRB+G8pHgOHVF3fmLXDVjt+mGB1kedzcQt+htZu
         RGgw==
X-Gm-Message-State: AGi0PuYc6ybFjdOYTV3xUdl/GGK5780eqGXCPb9wHek590Y8eA6l9Aii
        GXbQxW6uNNfL4czpmI+Vkze0DA==
X-Google-Smtp-Source: APiQypIab/qD0/CzEmBueUxVI7cdP1cUNlLmljnFYFcTG79k7lQKDEA7S87fbH2i7ZyFknlD7TnBGw==
X-Received: by 2002:a37:a84f:: with SMTP id r76mr1035709qke.370.1586467727251;
        Thu, 09 Apr 2020 14:28:47 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id x68sm50341qka.129.2020.04.09.14.28.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Apr 2020 14:28:46 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: KCSAN + KVM = host reset
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <CANpmjNNUn9_Q30CSeqbU_TNvaYrMqwXkKCA23xO4ZLr2zO0w9Q@mail.gmail.com>
Date:   Thu, 9 Apr 2020 17:28:45 -0400
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B5F0F530-911E-4B75-886A-9D8C54FF49C8@lca.pw>
References: <E180B225-BF1E-4153-B399-1DBF8C577A82@lca.pw>
 <fb39d3d2-063e-b828-af1c-01f91d9be31c@redhat.com>
 <017E692B-4791-46AD-B9ED-25B887ECB56B@lca.pw>
 <CANpmjNMiHNVh3BVxZUqNo4jW3DPjoQPrn-KEmAJRtSYORuryEA@mail.gmail.com>
 <B7F7F73E-EE27-48F4-A5D0-EBB29292913E@lca.pw>
 <CANpmjNMEgc=+bLU472jy37hYPYo5_c+Kbyti8-mubPsEGBrm3A@mail.gmail.com>
 <2730C0CC-B8B5-4A65-A4ED-9DFAAE158AA6@lca.pw>
 <CANpmjNNUn9_Q30CSeqbU_TNvaYrMqwXkKCA23xO4ZLr2zO0w9Q@mail.gmail.com>
To:     Marco Elver <elver@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 9, 2020, at 12:03 PM, Marco Elver <elver@google.com> wrote:
>=20
> On Thu, 9 Apr 2020 at 17:30, Qian Cai <cai@lca.pw> wrote:
>>=20
>>=20
>>=20
>>> On Apr 9, 2020, at 11:22 AM, Marco Elver <elver@google.com> wrote:
>>>=20
>>> On Thu, 9 Apr 2020 at 17:10, Qian Cai <cai@lca.pw> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Apr 9, 2020, at 3:03 AM, Marco Elver <elver@google.com> wrote:
>>>>>=20
>>>>> On Wed, 8 Apr 2020 at 23:29, Qian Cai <cai@lca.pw> wrote:
>>>>>>=20
>>>>>>=20
>>>>>>=20
>>>>>>> On Apr 8, 2020, at 5:25 PM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>>>>>>=20
>>>>>>> On 08/04/20 22:59, Qian Cai wrote:
>>>>>>>> Running a simple thing on this AMD host would trigger a reset =
right away.
>>>>>>>> Unselect KCSAN kconfig makes everything work fine (the host =
would also
>>>>>>>> reset If only "echo off > /sys/kernel/debug/kcsan=E2=80=9D =
before running qemu-kvm).
>>>>>>>=20
>>>>>>> Is this a regression or something you've just started to play =
with?  (If
>>>>>>> anything, the assembly language conversion of the AMD world =
switch that
>>>>>>> is in linux-next could have reduced the likelihood of such a =
failure,
>>>>>>> not increased it).
>>>>>>=20
>>>>>> I don=E2=80=99t remember I had tried this combination before, so =
don=E2=80=99t know if it is a
>>>>>> regression or not.
>>>>>=20
>>>>> What happens with KASAN? My guess is that, since it also happens =
with
>>>>> "off", something that should not be instrumented is being
>>>>> instrumented.
>>>>=20
>>>> No, KASAN + KVM works fine.
>>>>=20
>>>>>=20
>>>>> What happens if you put a 'KCSAN_SANITIZE :=3D n' into
>>>>> arch/x86/kvm/Makefile? Since it's hard for me to reproduce on this
>>>>=20
>>>> Yes, that works, but this below alone does not work,
>>>>=20
>>>> KCSAN_SANITIZE_kvm-amd.o :=3D n
>>>=20
>>> There are some other files as well, that you could try until you hit
>>> the right one.
>>>=20
>>> But since this is in arch, 'KCSAN_SANITIZE :=3D n' wouldn't be too =
bad
>>> for now. If you can't narrow it down further, do you want to send a
>>> patch?
>>=20
>> No, that would be pretty bad because it will disable KCSAN for Intel
>> KVM as well which is working perfectly fine right now. It is only AMD
>> is broken.
>=20
> Interesting. Unfortunately I don't have access to an AMD machine right =
now.
>=20
> Actually I think it should be:
>=20
>  KCSAN_SANITIZE_svm.o :=3D n
>  KCSAN_SANITIZE_pmu_amd.o :=3D n
>=20
> If you want to disable KCSAN for kvm-amd.

KCSAN_SANITIZE_svm.o :=3D n

That alone works fine. I am wondering which functions there could =
trigger
perhaps some kind of recursing with KCSAN?=
