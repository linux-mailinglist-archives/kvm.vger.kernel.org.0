Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31BACED5F
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 22:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbfJGUXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 16:23:22 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:42821 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbfJGUXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 16:23:22 -0400
Received: by mail-pl1-f169.google.com with SMTP id e5so7394524pls.9
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 13:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NsiOADxuVz+w5K3DlzYWkK3ekyMFourdpxpZ7BOjaZY=;
        b=ljTmIjB5EQG0LPBTCu5u98/c9mNvjwqa5FviTo4sh9O/qw/LljhihKmVR/2yUf9zQ5
         SVAkX1tjq0i4osmHDCXUyjsBraopoNCP8l1MkTzFTbUDGrtfWJJl3ATGz/+0kMql1tUO
         4RLydl7x4yWNP1VJ0a+jZxrbzXtcfd41Is2NuQbfIBB2fp5cqw7Z/ovwIEW9jseBG9MI
         NdV/N1iMRTy5uMk6Qkk9hY8yrNBvEbnqJ/Me/A5GPxCDIQJXVjGQxu2Mwr9powJP64rO
         R3M+WtqFCl5IOE1yQTXCSjTCPm3zGBPop83aJeBmTS80YvfVMIDkYY1ZTII5+xY3UZWU
         cqqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NsiOADxuVz+w5K3DlzYWkK3ekyMFourdpxpZ7BOjaZY=;
        b=Yv5tkbJZOP6QoKyCPomyDXccE+FKUssukTEFVmL3gZeZEQzBP4iaTdwYhpjwLd95XN
         Qv7V26LvwwSD5Tg9jU8S9ep39m3+otZTouqf6GCO1Uwh+A1gdDD3mvQb13BWEifyFR/4
         a7yGb1lhsL5rCWQmAzsiEoqsm7481R5R2fcyKOr7aS1KUIF+4DK1kvhFTNuQaP8w/vjA
         thRwGnkKJE0T9hLPoQVLzRd4rSF+BRoUgtmtbuAxlnFLABRI8FNk6CTJnKVQm64vk7yz
         VsJ5fKxJcJwldT7pCXd+LlkL/yOJqgesVZvNxhobTK5i87uh0avsb7mLuAGM2lSfPuQf
         qwZg==
X-Gm-Message-State: APjAAAU28tYaVipn59ZeF3XA5ckzODLQloRwNwLFejzPM3naWT8IJZsw
        MOQptJbY6+EQcPXsvEWTSUU=
X-Google-Smtp-Source: APXvYqy4TXplNSGIzmti0DR20IuP20lb6xpdKr1U0wItikwMUHtOwgVl72kQ4u7IGvwTtlqzF2xskg==
X-Received: by 2002:a17:902:421:: with SMTP id 30mr3327572ple.134.1570479801307;
        Mon, 07 Oct 2019 13:23:21 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id k65sm5232706pga.94.2019.10.07.13.23.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 13:23:20 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: Determining whether LVT_CMCI is supported
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20191007202050.GH18016@linux.intel.com>
Date:   Mon, 7 Oct 2019 13:23:19 -0700
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F2D25A33-642E-4501-AAB3-144EFD968893@gmail.com>
References: <2CF61715-CA79-4578-BD09-A0B6E2B2222F@gmail.com>
 <223C58D0-2AF4-4397-BDFF-3DD134E5B52A@gmail.com>
 <20191007202050.GH18016@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 7, 2019, at 1:20 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Apologies, completely lost this in my inbox.
>=20
> On Mon, Oct 07, 2019 at 12:58:16PM -0700, Nadav Amit wrote:
>>> On Oct 2, 2019, at 6:22 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>>>=20
>>> Hello Sean,
>>>=20
>>> Sorry for keep bothering you, but I am a bit stuck with fixing one
>>> kvm-unit-tests that fails on Skylake bare-metal.
>>>=20
>>> The reason for the failure is that I assumed that APIC_CMCI (MSR =
0x82f)
>>> support is reported in MSR_IA32_MCG_CAP[10].
>>>=20
>>> However, on my machine, I get:  MSR_IA32_MCG_CAP (0x179) =3D =
0x7000816
>>>=20
>>> And although MSR_IA32_MCG_CAP[10] is clear, APIC_CMCI is still =
accessible.
>>>=20
>>> Is there a way to determine whether LVT_CMCI is supported on a CPU?
>=20
> Bits 23:16 of the APIC's version register (LVR, MMIO 0x30, MSR 0x803)
> report the maximum number of LVT registers, minus 1.
>=20
>  Max LVT Entry Shows the number of LVT entries minus 1. For the =
Pentium 4 and
>  Intel Xeon processors (which have 6 LVT entries), the value returned =
in the Max
>  LVT field is 5; for the P6 family processors (which have 5 LVT =
entries), the
>  value returned is 4; for the Pentium processor (which has 4 LVT =
entries), the
>  value returned is 3. For processors based on the Intel =
microarchitecture code
>  name Nehalem (which has 7 LVT entries) and onward, the value returned =
is 6.
>=20
> I haven't found anything in the SDM that states which LVT entries are =
3rd,
> 4th, 5th, etc..., but based on kernel code, LVT_CMCI is the 7th, i.e.
> exists if APIC_LVR[23:16] >=3D 6.

Thanks! Highly appreciated, I=E2=80=99ll give it a try.

