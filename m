Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41745D483
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfGBQno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:43:44 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45037 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfGBQno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:43:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id t7so649886plr.11
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EhbxKamQ/0wcCBw8Yoh4Shb8CTX+GKo2JiJWkV2KXHc=;
        b=lFvpgI2pyYrEOdvzBQyY1JqSyHkiYhPWrQGc0QhVS00M3WsXtcN8C78mjb1+wL9NKl
         LpYnmaACHpMp74bZ+XLWDw3/IW8MGb3jz23AAIag6RQ8enzeuA7c2vDAnPYkTnsOVAEb
         1cdmIXelSyhWJ/yewQDOKka+JQ7VHWZ7ib3V9tAXRwuwhpJMgpM4af3W/XV6/KPlsTc7
         FEG7O0g6V4hFXqNKSREGuYUr/RB2YuIpAyEKBQKwI9nbXv+u5P2z1IU6mnKXPA3VJv1b
         v8INRjikKJH/s2cwCTCxH7ZIXTFgRX62MYerEx98/7z22SM9xhTozTlvSsgK6lbgJXUZ
         9Abg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EhbxKamQ/0wcCBw8Yoh4Shb8CTX+GKo2JiJWkV2KXHc=;
        b=ACG17PdWTG/DN+xepNkq98zaHmZNlbZvBeQC3la73PanFTo0MkrcPAH47b7xjZGuGl
         imRt5vstzD/4FuTl9yNvARinRLiL2PKqjH04UWOUykjoN6IKThjjIcn2OI3HWSGNSbQP
         tTlZjtmkdP9WNng9GkUwfAW+8RhwsiiYxCs/KfcXd2OP6G2qDfUDm25wVQeLW+Vn9wYz
         /FbkGVPV3NDk6+GLe+qDuW6HUimri2CrXOIcnqgXFK035YLm5LBbmGT6sHXNYyyf1/qq
         3FdUtO/k7dYYsVfVoVJsP1E3tHbwwJ4E50zMiO8Y86TEdmO1NYk/Giy2Do2BQ2M80i9N
         +Igg==
X-Gm-Message-State: APjAAAW5sicp9wGBNgLu0x2N6Ag8NaqeG8VKQmar4uHFYlaGWtIpxRvH
        RL9vqzUEDUAaVRc52syrkAeUQpi+z9k=
X-Google-Smtp-Source: APXvYqyX81k8OvnUq31pNmGqIXZOrhiR4cB2Szi500LwBOwDAzHpIgJHwAFKAuKx54uGSF2sYjTfrw==
X-Received: by 2002:a17:902:4643:: with SMTP id o61mr35930144pld.101.1562085823316;
        Tue, 02 Jul 2019 09:43:43 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id o13sm3107398pje.28.2019.07.02.09.43.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:43:41 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <2e359eb2-4b2a-0a52-6c43-cd6037bb72ae@redhat.com>
Date:   Tue, 2 Jul 2019 09:43:40 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F3480C92-28D8-470A-9E34-E87ECCE4FDD1@gmail.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <2e359eb2-4b2a-0a52-6c43-cd6037bb72ae@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 2, 2019, at 9:08 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 28/06/19 22:30, Nadav Amit wrote:
>> Enable to run the tests when test-device is not present (e.g.,
>> bare-metal). Users can provide the number of CPUs and ram size =
through
>> kernel parameters.
>>=20
>> On Ubuntu, for example, the tests can be run by copying a test to the
>> boot directory (/boot) and adding a menuentry to grub (editing
>> /etc/grub.d/40_custom):
>>=20
>>  menuentry 'idt_test' {
>> 	set root=3D'ROOT'
>> 	multiboot BOOT_RELATIVE/idt_test.flat ignore nb_cpus=3D48 \
>> 		ram_size=3D4294967296 no-test-device
>>  }
>>=20
>> Replace ROOT with `grub-probe --target=3Dbios_hints /boot` and
>> BOOT_RELATIVE with `grub-mkrelpath /boot`, and run update-grub.
>>=20
>> Note that the first kernel parameter is ignored for compatibility =
with
>> test executions through QEMU.
>>=20
>> Remember that the output goes to the serial port.
>=20
> RAM size can use the multiboot info (see lib/x86/setup.c).

The multiboot info, as provided by the boot-loader is not good enough as =
far
as I remember. The info just defines where to kernel can be loaded, but =
does
not say how big the memory is. For that, e820 decoding is needed, which =
I
was too lazy to do.

> For the # of CPUs I'm not sure what you're supposed to do on bare =
metal
> though. :)

I know you are not =E2=80=9Cserious=E2=80=9D, but I=E2=80=99ll use this =
opportunity for a small
clarification. You do need to provide the real number of CPUs as =
otherwise
things will fail. I do not use cpuid, as my machine, for example has two
sockets. Decoding the ACPI tables is the right way, but I was too lazy =
to
implement it.

