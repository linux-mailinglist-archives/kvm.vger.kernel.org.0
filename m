Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF4EBEBED
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 08:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389676AbfIZGX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 02:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbfIZGXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 02:23:25 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8266D2A09AD
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 06:23:24 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id m6so565754wmf.2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 23:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=p3wX4b3nJ/jsCclxFnCk6NvSH0CLX35aM42bWXitoow=;
        b=rXi0bAoIegnPrP00z62lUr64om/rGmnc32FEKrwkeK3G+DmblLr+XxySO+Xs+GZLOp
         fhwn7e9b30XnhTeCwOC38GhSEhfss8mT3+Ckte/1MazfTDtSA7NNuxveJ7uQEB9QPI+Q
         F9MI3fTSNc253AWrJvTviBNdKshXKz889NJAEO82MveIlwsXZGBgTTjH2zuWAJZtoDo1
         SFQH9uUdf70oAR6pRWxEczpjffGStyEKsaHcKKDrA48HPolmlyqMQ5jEVZlYVvkD1NVn
         FkIcdQR8RiqdTGhVjm/rhxs9pb5YH/cQgm/2LhfS5VLpuF2fbBPW9iyIIj7CTqfcNTPH
         MC5A==
X-Gm-Message-State: APjAAAUML37nx9x55DHAocWYq022Qbkxnzf2/KKYv6VDPz4KsYK4m5NJ
        0hZuISzryZRpeB9yZ90dZcvIW5hPlx2UgPoBlI8G67X9kvVcW5xyjiESGJbQyEUYI+gfTCzEFkt
        iCJ3bmXqRv/EC
X-Received: by 2002:a05:600c:241:: with SMTP id 1mr1475343wmj.162.1569479003011;
        Wed, 25 Sep 2019 23:23:23 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzC2N2A2UZ1Jh9B72qAvk1MOTXDqnAblHO1dJoblmrbdIZLLJK3Z5zO4H4Zf6ks4uwENDT3AQ==
X-Received: by 2002:a05:600c:241:: with SMTP id 1mr1475318wmj.162.1569479002801;
        Wed, 25 Sep 2019 23:23:22 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id w125sm2798555wmg.32.2019.09.25.23.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 23:23:21 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-8-slp@redhat.com> <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87a7ass9ho.fsf@redhat.com> <d70d3812-fd84-b248-7965-cae15704e785@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine type
In-reply-to: <d70d3812-fd84-b248-7965-cae15704e785@redhat.com>
Date:   Thu, 26 Sep 2019 08:23:13 +0200
Message-ID: <87o8z737am.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 25/09/19 17:04, Sergio Lopez wrote:
>> I'm going back to this level of the thread, because after your
>> suggestion I took a deeper look at how things work around the PIC, and
>> discovered I was completely wrong about my assumptions.
>>=20
>> For virtio-mmio devices, given that we don't have the ability to
>> configure vectors (as it's done in the PCI case) we're stuck with the
>> ones provided by the platform PIC, which in the x86 case is the i8259
>> (at least from Linux's perspective).
>>=20
>> So we can get rid of the IOAPIC, but we need to keep the i8259 (we have
>> both a userspace and a kernel implementation too, so it should be fine).
>
> Hmm...  I would have thought the vectors are just GSIs, which will be
> configured to the IOAPIC if it is present.  Maybe something is causing
> Linux to ignore the IOAPIC?

Turns out it was a bug in microvm. I was writing 0 to FW_CFG_NB_CPUS
(because I was using x86ms->boot_cpus instead of ms->smp.cpus), which
led to a broken MP table, causing Linux to ignore it and, as a side
effect to disable IOAPIC symmetric I/O mode.

After fixing it we can, indeed, boot without the i8259 \o/ :

/ # dmesg | grep legacy
[    0.074144] Using NULL legacy PIC
/ # cat /pr[   12.116930] random: fast init done
/ # cat /proc/interrupts=20
           CPU0       CPU1=20=20=20=20=20=20=20
  4:          0        278   IO-APIC   4-edge      ttyS0
 12:         48          0   IO-APIC  12-edge      virtio0
NMI:          0          0   Non-maskable interrupts
LOC:        124         98   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RTR:          0          0   APIC ICR read retries
RES:        476        535   Rescheduling interrupts
CAL:          0         76   Function call interrupts
TLB:          0          0   TLB shootdowns
HYP:          0          0   Hypervisor callback interrupts
ERR:          0
MIS:          0
PIN:          0          0   Posted-interrupt notification event
NPI:          0          0   Nested posted-interrupt event
PIW:          0          0   Posted-interrupt wakeup event

There's still one problem. If the Guest doesn't have TSC_DEADLINE_TIME,
Linux hangs on APIC timer calibration. I'm looking for a way to work
around this. Worst case scenario, we can check for that feature and add
both PIC and PIT if is missing.

>> As for the PIT, we can omit it if we're running with KVM acceleration,
>> as kvmclock will be used to calculate loops per jiffie and avoid the
>> calibration, leaving it enabled otherwise.
>
> Can you make it an OnOffAuto property, and default to on iff !KVM?

Sure.

Thanks,
Sergio.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2MWVEACgkQ9GknjS8M
AjVo2A//bzXUzuyTvFY3Yt7pa7vPg6BGH262M/NtpiZL+t8EF/mGaNsf9DbakPhk
WTOxCu8LHLsqDdzk3eI8L1MD8AsxvUUzncGBnf1AA0TYRugzNHc0ukSALz2FYHS+
q4DzpBx2g98n/UQGnfnew8qjEwQtgp7feMwyvOIY/6PDQlWWx7qwUN7rc0aBdC9o
Q8WrAJM/23/nKZKkfaaGKmuOQatodWrvXFn4HenhjXbScpUSSPTRtzuVYSVTemrq
yPqju2Qa10GIeG5kaIdfqM6jvS0X1usilwG98iouvYugXeMDy6tl2oljougZzxmd
wlnmnLlOf9GPyWVLIWxFDSnsQ8OjHTQOmrVFXHzToYkv85Lue2HDvtp93rvCdD63
DXBhFv7dotkMGfmGY01QcFIlGODUuYOlk8AXSglqW+LgVO1T58myXCbQG4XN6/zr
LKEEDICx3AVK6r+S/CTkR4p5Pnyv6L3kW5W6zUCiwV1qCTUm27P138OLYdTnufkx
wmwP2DJv1u5Br/LhgEO0luaUyRmZnpcrXfJJ2X/hpRl3C+wS8DyW5m+zrgpXizSb
gtHUAcXS6CJ7TXK4JdHr9dZBpjV1oYj0fmJgXkwfMrPs+iNpEklObsdoWCWnP3TO
6p5vk+NAhnvH6bsIOit1arENW40njETT+H1MqDLITILpWCOXcV4=
=/gyD
-----END PGP SIGNATURE-----
--=-=-=--
