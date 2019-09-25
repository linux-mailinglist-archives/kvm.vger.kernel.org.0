Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED048BD7EA
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 07:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411802AbfIYFt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 01:49:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404277AbfIYFt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 01:49:56 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B6E90C057F20
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 05:49:55 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id k9so1401852wmb.0
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 22:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=HSsroT4HC2j6oQ8x2w3C7SA7aQg1P5xbfLeT4Pk4g7M=;
        b=gphyhfcGsrYXSOxgX/x+c1Vh8atTJWHsJqllOVRhh2eRohgl7SNPeVNKGTtP/N9N+0
         +0Gyp2fSO+JLteEhe3rLeisyg3HWGUK8xkswTehIhfCsMu6p/RGGaQm0VUpAp0oKvAGR
         OWthrOgokDXC8q25+BWpIltMPICMzdtNf4wZOh4NZFlNO0HrpZu0z/lKabUvlUMH+1XP
         yimOz24AQ/QDdw2zB2JPdqMC+U4FMfnkUqjA3TGGCs+t0ei6xD08etxNeL7RAiPcdD74
         TMkB3tqU0xlAN27P0XhZImdR6fAI5posRnm7byuPUSN5mERYMj9wrXsazIifKFlHvN6H
         cblA==
X-Gm-Message-State: APjAAAUpgbdMEprFBtyEzHGqLXHTilQfWe46on8523xykdVxw0qkrsok
        BMvrM0LrDSONYR0reCRkeKf1ac/JiHJdSaX3MuXgFOEyv6hACn8u0IUvelcVNGVjJQZ2Ge8rsH1
        TYBTgE4t9KeDG
X-Received: by 2002:a5d:4689:: with SMTP id u9mr7042376wrq.78.1569390594236;
        Tue, 24 Sep 2019 22:49:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwL4FR1FGuJ/FPsehgfbn7DutFbGl1HOLQJUHAiJW+F9qMjTpY/JwpIrmNKmqUEzHoMHYG6eA==
X-Received: by 2002:a5d:4689:: with SMTP id u9mr7042354wrq.78.1569390594060;
        Tue, 24 Sep 2019 22:49:54 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id x5sm4280279wrt.75.2019.09.24.22.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 22:49:53 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-8-slp@redhat.com> <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine type
In-reply-to: <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com>
Date:   Wed, 25 Sep 2019 07:49:50 +0200
Message-ID: <87r245rkld.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 24/09/19 14:44, Sergio Lopez wrote:
>> +Microvm is a machine type inspired by both NEMU and Firecracker, and
>> +constructed after the machine model implemented by the latter.
>
> I would say it's inspired by Firecracker only.  The NEMU virt machine
> had virtio-pci and ACPI.

Actually, the NEMU reference comes from the fact that, originally,
microvm.c code was based on virt.c, but on v4 all that is already gone,
so it makes sense to remove the reference.

>> +It's main purpose is providing users a minimalist machine type free
>> +from the burden of legacy compatibility,
>
> I think this is too strong, especially if you keep the PIC and PIT. :)
> Maybe just "It's a minimalist machine type without PCI support designed
> for short-lived guests".

OK.

>> +serving as a stepping stone
>> +for future projects aiming at improving boot times, reducing the
>> +attack surface and slimming down QEMU's footprint.
>
> "Microvm also establishes a baseline for benchmarking QEMU and operating
> systems, since it is optimized for both boot time and footprint".

Well, I prefer my paragraph, but I'm good with either.

>> +The microvm machine type supports the following devices:
>> +
>> + - ISA bus
>> + - i8259 PIC
>> + - LAPIC (implicit if using KVM)
>> + - IOAPIC (defaults to kernel_irqchip_split = true)
>> + - i8254 PIT
>
> Do we need the PIT?  And perhaps the PIC even?

We need the PIT for non-KVM accel (if present with KVM and
kernel_irqchip_split = off, it basically becomes a placeholder), and the
PIC for both the PIT and the ISA serial port.

Thanks,
Sergio.

>> + - MC146818 RTC (optional)
>> + - kvmclock (if using KVM)
>> + - fw_cfg
>> + - One ISA serial port (optional)
>> + - Up to eight virtio-mmio devices (configured by the user)
>> +


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2K//4ACgkQ9GknjS8M
AjVmTw/9ElDYdyqk9aGcU379B23aC3XF0mWk40KFNEN6DxgVirVzkZwMuyajcxrq
nZE3rj155US21V8yFWSk3Wewuv0GTmL2YjIUBqWMbY5XZ/4BACPfpolJfhVnWP03
kn0usIuwAFPmIkrmy06I+eIF4/0Zu8W8TVe+cKA8QhTUL2W45o6hShTbFS4WQuvA
m7OK875wf4g1Ca3p306Yug2hrn9yvcUajyWVkhZNiheI0juj5shE2VM05veCdZTz
U/A7F7DBmJ2G61Fk4lyUggX6k/FRkdea/qwG8AfSBhD0DVCQFHvr5f/Ea0eqGs9r
qiMnTftjSDBS+1H92Gyx5bCqZeb8Vihdn+hoNQ52/XdV18Vrh8/zP11fqHP4mRj3
2zehKx0Qd7wLm+ZUwitgOif8+tE+Ehz8+hBdTbgloP5/2GqyM6QvhLrt9RNIbCqW
Z36k1Az56L4rdTTdKXUwyBBfqNCTvSUuroGo1sX4u9RJfW+SK3vdLufF985kBn4Y
65vSZlkS2t4geFo5F2PH0b6UlenrXdoIYKB+X1RD3r6FcSCGftn8EK5A63m5D81R
LYGJQPB+eO2/q2/v2+pBgsCtMotFgapGmw5uap10M+cV+BmJg6Q+sgYIhBXO81SW
oHa/DImvBu6FgvhRYblzjfGrJF2ixxBpqmYLf3xV52nS7ZdtVXM=
=skTF
-----END PGP SIGNATURE-----
--=-=-=--
