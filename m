Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487785D9BA
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 02:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfGCAvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 20:51:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41331 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCAvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 20:51:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so688403wrm.8
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 17:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bLZ88IFY3tu53Jg5E0M38zUC8xadQky+8LMyLZBpVnw=;
        b=I+PKG1XbK7kLNDnWUWNGOfJc7uqirAyA2DlWjJ7d9CqCvfz6kGSGEo4SxoTFDpKt5R
         keJC/hBFH/xFIIKtc2jBiOO7BYwY5x5h+ZcTfgIxnNkzvcIFJ5TpVIl6dBmIfD6isBdj
         E5b3GxEXALgnafHlLoEPEXJJyBZkL4ixKxknMAd7rEBwuE7uZhSAwKBys9OFmb471teU
         7ZA+RGddHNo7UzJnT9UqV3IowL+w7xOv9wcOflbNVoD5FanupptDBquBPTsoYZalTdk6
         jRuUa900hfzosp1CKWY5tS2l9oS/pT9wXpu6Dz8etqzbyWjxGK5vK9s4q1YImZ7xz9c3
         9XbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bLZ88IFY3tu53Jg5E0M38zUC8xadQky+8LMyLZBpVnw=;
        b=tBJvFDPox56YZSOU/nUDz0AdSp9sPFj6XoTz8ofYJY692EdQyaruHYI8t2gwzXYTK4
         bl1GBc+oG38L5SuiScDXerK9IdtmWOuLkz1J7AEhwaa9pKSGkbM21e4H1rkxsMaNRB19
         MWkzAfCZFwe5P1XlcMQMJbVxfu+S6+2qPwAXMyFe9lr+gk4c2FIcvZsHb/slK6eo5x1d
         lXM2OVcsc8qlYBaEPXPfIkrHs4xAcsC9d+8EhYZb4rjh/5Z74QORYZmatBhQrBvzwz3N
         Fb4HXdF6WseH98AHhbGQTSJtlWs1JIFdsaY3LSQdOmx7S1DTHAJOAvIWBOX92+wuYdm5
         x6zA==
X-Gm-Message-State: APjAAAWH7TTOrtjO7q/1wYOpLVFjM4bziWDuYmIfkReDcyhp9ibErXua
        MUHAyF/Z9AvEP6OwJFewxZ+r+b/vUPQ=
X-Google-Smtp-Source: APXvYqxPXe+QpWRIkNrtCJF3rzePYhDiALqU7ftN6sBSQ2laPnG98fsyYla9MXI1Qd/pSeOzqqPFag==
X-Received: by 2002:a5d:4950:: with SMTP id r16mr25769793wrs.136.1562111792132;
        Tue, 02 Jul 2019 16:56:32 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id w20sm752197wra.96.2019.07.02.16.56.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 16:56:31 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <954DC323-15B7-4B35-9249-AB03C9D01BB5@gmail.com>
Date:   Tue, 2 Jul 2019 16:56:29 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A4764CFE-CA7A-4714-A54A-9E32DC591160@gmail.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <2e359eb2-4b2a-0a52-6c43-cd6037bb72ae@redhat.com>
 <F3480C92-28D8-470A-9E34-E87ECCE4FDD1@gmail.com>
 <73f56921-cb61-92fa-018a-5673e721dbef@redhat.com>
 <39BF29A2-D14B-4AC7-AE19-66EA8C136D98@gmail.com>
 <5a31871b-4010-dd01-9be6-944916753195@redhat.com>
 <954DC323-15B7-4B35-9249-AB03C9D01BB5@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 2, 2019, at 4:39 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Jul 2, 2019, at 11:28 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>=20
>> On 02/07/19 19:45, Nadav Amit wrote:
>>>>> I know you are not =E2=80=9Cserious=E2=80=9D, but I=E2=80=99ll use =
this opportunity for a small
>>>>> clarification. You do need to provide the real number of CPUs as =
otherwise
>>>>> things will fail. I do not use cpuid, as my machine, for example =
has two
>>>>> sockets. Decoding the ACPI tables is the right way, but I was too =
lazy to
>>>>> implement it.
>>>> What about the mptables, too?
>>> If you mean to reuse mptable.c from [1] or [2] - I can give it a =
shot. I am
>>> not about to write my own parser.
>>=20
>> Sure.
>=20
> So mptable logic works on a couple of my machines, but not all.
>=20
> For instance, on my Dell R630, running x86info (which uses mptable.c), =
I
> get:
>=20
>  x86info v1.31pre  Dave Jones 2001-2011
>  Feedback to <davej@redhat.com>.
>=20
>  Found 48 identical CPUsMP Configuration Table Header MISSING!
>=20
> And this message (corrupted, but indicates what the code does), is =
since
> apparently the "MP Floating Pointer Structure=E2=80=9D holds a zeroed =
physical
> address pointer. (The number 48 comes from sysconf, and clearly not =
usable
> in kvm-unit-tests.)
>=20
> I also enable apic debugging and had a look on Linux's mpparse =
outputs. It
> does not find the MPF either.=20
>=20
> So it seems to me that it is down to either doing a more comprehensive =
ACPI
> table decoding or having a fallback in the form of a kernel parameter. =
I am
> not really excited about implementing the ACPI option, since I am =
afraid a
> basic implementation will encounter some issues on some machines, =
similarly
> to mptable. The other option is having a fallback as a test parameter, =
but
> if there is already a fallback, then using mptable becomes an =
enhancement,
> and can be left out right now.
>=20
> What do you say?

Never mind (for now). I=E2=80=99ll have a look at libacpi when I have =
time.=
