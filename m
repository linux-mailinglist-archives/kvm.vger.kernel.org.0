Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B55669A88
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 20:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbfGOSIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 14:08:37 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38548 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729366AbfGOSIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 14:08:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id z75so8089745pgz.5
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 11:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SblXFu065uxzPZrmS6N9sHY8CMtn3pra44rW+mH9DGs=;
        b=UTc+eboihpsI2f3zznc+QpmHto7rPTXeUlUyY1B06IqvsTUE56EKtIFGKPZgggOUcS
         Ts1Stcl5aJn/Hr/cooaKOuMzocNIaP2q162wIsqYnDEK/9mVyFommuc7jT6iM9M6PeLH
         JLlzBIfBILqpD0VxSeeqr1LsWAuZc46R4VUNNnlZ0/N5d46lRnljMhk7b2cMs2UJap4q
         IShHHiMzM5KFohCzd1x3CDL5L3MXM6WH8x/LxdiJrT6XhUErJDQudf8sa6GcrmEIPRb7
         lRqbbopwHRdX9eU04IfqPKRP7cLlc9v6VF/HZq1jvqv2cb0cgkEFX+gC8/eca79UEeQs
         pvNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SblXFu065uxzPZrmS6N9sHY8CMtn3pra44rW+mH9DGs=;
        b=ApNoATzkYC8/QxV4tC5y8ZH50cXIBhH5qtRgRWJ2ylOnMxM1Ha+gBiVFX6yCiaVVZy
         hJ/b8Ym4oFf4JzaGzvZ9MVBaVvhcXb3OCJAysMy+Ct65f2Z6Xsdd/D912eaqLcu0HhLu
         IGnpTkO/z0n9ngXvn0AwLVxDl4+DiDE84hN/PdVhPjBIR5ODVi4VXQfMbyMZ5UtmeWtr
         DE9jDPM8xeDsz2eq944974SV7qOPeKBVR451CoEOqTuCbHA2bM623f4arQpNW/XcMFjD
         Ro9gj6GtQMLgy8geqn6J2E0jCulTdhE0M7bdWJg9Q/jyH+/TVPVwCy0QWAE8L62iHaG4
         QYsQ==
X-Gm-Message-State: APjAAAUnU1l6qMF+4PV0SSo8SpjL7cr1hZ5gjcLnje42ANNL4oPH2OUB
        wEaDx9GVZw6JAqv4BP9NuSQ=
X-Google-Smtp-Source: APXvYqzEYXGxMTs1cPTJcPIgQp36uOEehN1YOl6RxjsNavafle3T43FUXCk9gSq5A6AVcgMb+1/4vg==
X-Received: by 2002:a17:90a:3247:: with SMTP id k65mr30574984pjb.49.1563214115552;
        Mon, 15 Jul 2019 11:08:35 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id s24sm18974218pfh.133.2019.07.15.11.08.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 11:08:34 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190715154812.mlw4toyzkpwsfrfm@kamzik.brq.redhat.com>
Date:   Mon, 15 Jul 2019 11:08:33 -0700
Cc:     kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FFD1C3FC-C442-4953-AFA6-0FFADDEA8351@gmail.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <20190715154812.mlw4toyzkpwsfrfm@kamzik.brq.redhat.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 15, 2019, at 8:48 AM, Andrew Jones <drjones@redhat.com> wrote:
>=20
> On Fri, Jun 28, 2019 at 01:30:19PM -0700, Nadav Amit wrote:
>> Enable to run the tests when test-device is not present (e.g.,
>> bare-metal). Users can provide the number of CPUs and ram size =
through
>> kernel parameters.
>=20
> Can you provide multiboot a pointer to an initrd (text file) with
> environment variables listed instead? Because this works
>=20
> $ cat x86/params.c=20
> #include <libcflat.h>
> int main(void)
> {
>    printf("nr_cpus=3D%ld\n", atol(getenv("NR_CPUS")));
>    printf("memsize=3D%ld\n", atol(getenv("MEMSIZE")));
>    return 0;
> }
>=20
> $ cat params.initrd=20
> NR_CPUS=3D2
> MEMSIZE=3D256
>=20
> $ qemu-system-x86_64 -nodefaults -device pc-testdev -device =
isa-debug-exit,iobase=3D0xf4,iosize=3D0x4 -vnc none -serial stdio =
-device pci-testdev -machine accel=3Dkvm -kernel x86/params.flat -initrd =
params.initrd
> enabling apic
> enabling apic
> nr_cpus=3D2
> memsize=3D256
>=20
>=20
> This works because setup_multiboot() looks for an initrd, and then,
> if present, it gets interpreted as a list of environment variables
> which become the unit tests **envp.

Looks like a nice solution, but Paolo preferred to see if this =
information
can be extracted from e810 and ACPI MADT. Paolo?=
