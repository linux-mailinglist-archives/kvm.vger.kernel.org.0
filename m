Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0400069AF9
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 20:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbfGOSna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 14:43:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46023 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729513AbfGOSn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 14:43:29 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so7813982pfq.12
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 11:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EJKOeqUBddEreA3kd3cQmotDuZespEXTpSRsEYz3SpA=;
        b=S5WBUMHFEkR8iBeC/5l4CFS1Jw2elL6sYbNu1o00CsO1mYf24N7+HMkTQJVsyP76pF
         lECw0zsNNvdWrtmeQnZrBgOEF6RgPYwab0yuYqtNhGLReqqGxLKEZJXQSv/QYeXSjAMF
         s2fP0AhijeAzxLKwl0h/ex4yY5Gvr12YDhHgorZfVL7rnWO2pXpklgSp+9y9OQ9zalaJ
         wptL360B2uweFTFVnQSExcKkdRWyEwefj29717pdj6CROHK5DsmzX5mYfpqs03mcrRdq
         n9BVtQmBsc8T/cPO8jM4hmfRxG5xnv7HgFiTRwXVKs8XkLxdAVwSa1FkxCrKrgogFwU0
         ijBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EJKOeqUBddEreA3kd3cQmotDuZespEXTpSRsEYz3SpA=;
        b=ISNmYLDVh7UpY1VXbw2p5R0Z2A46gOw7GRK873iiDelTfW3G7Fcf/0oIZcEoz2Qa8n
         ZDyibwdhCAXlf2jOM2+TdQPkMLtwhVa/Pfmp+q6qe47VE/fNUeAkUOYyQvl0fzayqExA
         DBQamsSbk1Q16r44nOx0yj14hoV0/dnCQcgHIEQNBEzfI8pFBywHagLVlymShTZZzCb5
         uhRcu72eGInIA5KGAMwsx4OPcffUqslEFIn7mHG9OLIqOUceC1EfsY51Npkw0BiY6roo
         BODcLRLr+A0KgNk6+XL8+UlMrpnCRQzX5Mf/ubFJX88r6s6DX4oc8y7dgvo+FcCEPGPt
         asBA==
X-Gm-Message-State: APjAAAXyxZJ3MfZrQBj0fpAhLMppo5guQG2yOasM3m8cUC6jNc/4kYOq
        P83Kq37mlSZVpSRQnXh9jSN6gLwQZMY=
X-Google-Smtp-Source: APXvYqyZs6ZeINUzGyODZvhvg5IZqA/F3/FPNvYo5b/DCbpBsNDdMwwMrBAYF2enJoFsOhmucbQZLw==
X-Received: by 2002:a63:6ec6:: with SMTP id j189mr29222935pgc.168.1563216208717;
        Mon, 15 Jul 2019 11:43:28 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id o12sm14579557pjr.22.2019.07.15.11.43.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 11:43:27 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ab5e8e73-5214-e455-950d-e837979bb536@redhat.com>
Date:   Mon, 15 Jul 2019 11:43:26 -0700
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9A78B004-E8B8-427A-B522-C0847CBEFDD3@gmail.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <20190715154812.mlw4toyzkpwsfrfm@kamzik.brq.redhat.com>
 <FFD1C3FC-C442-4953-AFA6-0FFADDEA8351@gmail.com>
 <ab5e8e73-5214-e455-950d-e837979bb536@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 15, 2019, at 11:26 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 15/07/19 20:08, Nadav Amit wrote:
>>> On Jul 15, 2019, at 8:48 AM, Andrew Jones <drjones@redhat.com> =
wrote:
>>>=20
>>> On Fri, Jun 28, 2019 at 01:30:19PM -0700, Nadav Amit wrote:
>>>> Enable to run the tests when test-device is not present (e.g.,
>>>> bare-metal). Users can provide the number of CPUs and ram size =
through
>>>> kernel parameters.
>>>=20
>>> Can you provide multiboot a pointer to an initrd (text file) with
>>> environment variables listed instead? Because this works
>>>=20
>>> $ cat x86/params.c=20
>>> #include <libcflat.h>
>>> int main(void)
>>> {
>>>   printf("nr_cpus=3D%ld\n", atol(getenv("NR_CPUS")));
>>>   printf("memsize=3D%ld\n", atol(getenv("MEMSIZE")));
>>>   return 0;
>>> }
>>>=20
>>> $ cat params.initrd=20
>>> NR_CPUS=3D2
>>> MEMSIZE=3D256
>>>=20
>>> $ qemu-system-x86_64 -nodefaults -device pc-testdev -device =
isa-debug-exit,iobase=3D0xf4,iosize=3D0x4 -vnc none -serial stdio =
-device pci-testdev -machine accel=3Dkvm -kernel x86/params.flat -initrd =
params.initrd
>>> enabling apic
>>> enabling apic
>>> nr_cpus=3D2
>>> memsize=3D256
>>>=20
>>>=20
>>> This works because setup_multiboot() looks for an initrd, and then,
>>> if present, it gets interpreted as a list of environment variables
>>> which become the unit tests **envp.
>>=20
>> Looks like a nice solution, but Paolo preferred to see if this =
information
>> can be extracted from e810 and ACPI MADT. Paolo?
>=20
> It was mostly a matter of requiring adjustments in the tests.  =
Andrew's
> solution would be fine!

Ok, but I must be missing something, because the changes I proposed =
before
did not require any changes to the tests either (when they are run on =
top
of KVM).

Andrew=E2=80=99s solution would just make it easier to set =E2=80=9Cfixed=E2=
=80=9D boot-loader
entries, although they would still need a different root and
boot-relative-path on different machines.

