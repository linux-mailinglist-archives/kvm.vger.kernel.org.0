Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E035D97C
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 02:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfGCAop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 20:44:45 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38678 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfGCAop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 20:44:45 -0400
Received: by mail-oi1-f196.google.com with SMTP id v186so582213oie.5
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 17:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HSu4Dybpy/gx2VWu8RN0NxmfxLV/BXoSUUwhQy+na18=;
        b=kawEBkGxcxZQvZyvFfeWlWs/E/HnvkcEbWrgZEgaEavMKVZKAYbCV4DLrRXJCO3kWm
         qOmADTrY3z+8IxysHwoB0WjM9gt6AjcB8F79fILTGJa5TwOnuIKL5Hq5Yzcc9T2oM8PV
         T0f3NK5IDjET1dLYaj3Zp6mY4whkVDu7Fv9p8V6j1tX0RY/5ipHtLoZzLHXfQdzXq/Gd
         ZLXcDXMNjLvYc21RIwaViVLUe4YF2/lUyPm6plyf1LwkkjrD1ZNo4UebsNMl3IxfsFxb
         XbDaqnYIrFHeni0N/O0OhxVD4ImQxCql7iMYyk6JX4FMcUJjkxl/37aQqrclIN8j8r9h
         Fjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HSu4Dybpy/gx2VWu8RN0NxmfxLV/BXoSUUwhQy+na18=;
        b=rfiHqNvR5eligGqe9JnLeTMcsu+OzlTCKadxW/Gzx5MLF6rzw4DHa8LTqTQ7dvDbDv
         AaX5/kmgRrM8vt/DCqduKay7ACYTXa7TT9TGW63hhXkgbNQtQlbDNPupPSFCdpb7UClp
         hy1cxzR4tObmtMi9MXidVBA8CfxOt3ovvFau+aEzX+8VpNTp/uxs/EQjoUpGb+sUSIAY
         q4xIxrDoQRQLWpGXXNSFz2izO5/oqANBT7U1VLHxLQr9oEWjXkr0fEDuCUfkwDUPRsNI
         hbs3o/Ll8mP785AGmuGyX7Howl91bI0IQqDspwYVYHKqpTXna4Nij0mpDfsLdy4XksR6
         W02Q==
X-Gm-Message-State: APjAAAXbCkkJWHyLZDgACnsx5Ls9DCIWqefmBaJeQX24gyG5dH0VRVEn
        +YKeiDiPTwG24LogZAb5VFbRRwTp77Y=
X-Google-Smtp-Source: APXvYqxZZmAy0BtiBu+1zrLvTaGw/W4aliUU45LeVgRGv4tfvYv9/BKYdHgF3aqVqKG6fltC/FJroQ==
X-Received: by 2002:a63:460c:: with SMTP id t12mr30272700pga.69.1562110746666;
        Tue, 02 Jul 2019 16:39:06 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id y19sm162605pfe.150.2019.07.02.16.39.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 16:39:06 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <5a31871b-4010-dd01-9be6-944916753195@redhat.com>
Date:   Tue, 2 Jul 2019 16:39:04 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <954DC323-15B7-4B35-9249-AB03C9D01BB5@gmail.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <2e359eb2-4b2a-0a52-6c43-cd6037bb72ae@redhat.com>
 <F3480C92-28D8-470A-9E34-E87ECCE4FDD1@gmail.com>
 <73f56921-cb61-92fa-018a-5673e721dbef@redhat.com>
 <39BF29A2-D14B-4AC7-AE19-66EA8C136D98@gmail.com>
 <5a31871b-4010-dd01-9be6-944916753195@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 2, 2019, at 11:28 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 02/07/19 19:45, Nadav Amit wrote:
>>>> I know you are not =E2=80=9Cserious=E2=80=9D, but I=E2=80=99ll use =
this opportunity for a small
>>>> clarification. You do need to provide the real number of CPUs as =
otherwise
>>>> things will fail. I do not use cpuid, as my machine, for example =
has two
>>>> sockets. Decoding the ACPI tables is the right way, but I was too =
lazy to
>>>> implement it.
>>> What about the mptables, too?
>> If you mean to reuse mptable.c from [1] or [2] - I can give it a =
shot. I am
>> not about to write my own parser.
>=20
> Sure.

So mptable logic works on a couple of my machines, but not all.

For instance, on my Dell R630, running x86info (which uses mptable.c), I
get:

  x86info v1.31pre  Dave Jones 2001-2011
  Feedback to <davej@redhat.com>.

  Found 48 identical CPUsMP Configuration Table Header MISSING!

And this message (corrupted, but indicates what the code does), is since
apparently the "MP Floating Pointer Structure=E2=80=9D holds a zeroed =
physical
address pointer. (The number 48 comes from sysconf, and clearly not =
usable
in kvm-unit-tests.)

I also enable apic debugging and had a look on Linux's mpparse outputs. =
It
does not find the MPF either.=20

So it seems to me that it is down to either doing a more comprehensive =
ACPI
table decoding or having a fallback in the form of a kernel parameter. I =
am
not really excited about implementing the ACPI option, since I am afraid =
a
basic implementation will encounter some issues on some machines, =
similarly
to mptable. The other option is having a fallback as a test parameter, =
but
if there is already a fallback, then using mptable becomes an =
enhancement,
and can be left out right now.

What do you say?=
