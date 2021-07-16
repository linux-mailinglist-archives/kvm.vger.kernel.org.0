Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFBC3CB2C5
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 08:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhGPGib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 02:38:31 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:47322
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230011AbhGPGib (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Jul 2021 02:38:31 -0400
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 4C8B5408AB
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 06:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626417336;
        bh=4j7G11Xm0HV7sqp7ibnxlMwChJPMkMMUOn/ET7Wu810=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Ywx+rD4CrljAPFAyXp3YOB/xyZEJtMQ4T0mTz22w3OKz+yQnTlEYeoVKAcAZRjYG/
         +lpoSjubVs//ZoxhcJcPnvSNazGggCxiQI5/ri496JC9nn/ZXSA0qfdf1LU102j0LL
         S8nkBoLOu7J0R7LDJY/g8PDw/N3eg2uI7+CmVGocDMU7Xroc1y6ZnRcB92eUz1ll/6
         FIcr67kE0XDMk8Ew+EjxSRBJ2iMeU9+ETaAoQYLteTUtI46iToNHJYbSezvsKdw5AW
         nGtBC2LjOAJDFS+4ZQYwhn0Cf535mCUhY5GTnjvgkFVZSQHE1aRWebw9Q+7sBiIl5a
         WVhOqhA3mJT7w==
Received: by mail-pg1-f199.google.com with SMTP id u8-20020a6345480000b0290227a64be361so6248087pgk.9
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 23:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4j7G11Xm0HV7sqp7ibnxlMwChJPMkMMUOn/ET7Wu810=;
        b=MG7SgB6SLK5P+MEnHobg/2BIdrgOUJHt/WoRlL1rDwxl0ceaL5A3xeYyDcgjHYhuTv
         yIxdkNHtZt/vJ4ZY7Sn/9RD9EdmvhdzDE1l4HtLUn8LPpvTovsqe/SeTWlknwzI76m50
         UbFVEIXN6oZ3T4aFq1nldFCarcTCQKQ+mZhMx2lxKUgJVc9mWAGtUdOudP3/+PRM5/F5
         9/i5q5jSbXuKqzL/ok4F6yUxGfpoRxqBtfPfOTFzkNFRtbZzJ57Fs3PWd3YsHegYqCnK
         MlzMSyB+/XHxMJIfNho61hYzgFydFR4dHE3VxN+HWoyK69RuZSW4B5LS3VRBPjEqVmrk
         OvBA==
X-Gm-Message-State: AOAM53160WxUPGBL1x73rfB1pAvpezymqyYfvO/bmIwFGwaYE5JGsuto
        lqU7uXRbrN6XWNmuwf9zdFiyr7wKpZceSM7T02XXvrhbC2VmrF2UAt0ynKVQlwb0j9eHfxNckl4
        WNop7QnahtQKtltNxQg4Y1rUL4c1hk5d+ciay5g3G2gAP
X-Received: by 2002:a63:338d:: with SMTP id z135mr8391431pgz.314.1626417334722;
        Thu, 15 Jul 2021 23:35:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPkyAoKhEoAEXQZOmMm1wUpJkkzzHW/sfB9xk9FcBV3UKHGmi3dRJWCPts5JEZwAdnEOAhqEY+8I50GbHSWJ4=
X-Received: by 2002:a63:338d:: with SMTP id z135mr8391391pgz.314.1626417334186;
 Thu, 15 Jul 2021 23:35:34 -0700 (PDT)
MIME-Version: 1.0
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com> <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
 <CAMy_GT9Y1JNyh5GkZm31RQ6nX8Jv9qHFRN2KeOe01GOyk2ifQg@mail.gmail.com>
 <20210615063659.7w2rp6jk76rhgeue@gator.home> <CAMy_GT_jegx-EO20ktpBZrrdM_Q4cTaZmPSZfK2eyowonRNH3g@mail.gmail.com>
In-Reply-To: <CAMy_GT_jegx-EO20ktpBZrrdM_Q4cTaZmPSZfK2eyowonRNH3g@mail.gmail.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Fri, 16 Jul 2021 14:35:22 +0800
Message-ID: <CAMy_GT_YYA=q8csbUFrQUKYu39AVNpoaVZ4dA8CdG+2iDBtDuA@mail.gmail.com>
Subject: Re: [kvm-unit-tests] its-migration segmentation fault
To:     Andrew Jones <drjones@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Auger Eric <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 3:11 PM Po-Hsu Lin <po-hsu.lin@canonical.com> wrote:
>
> On Tue, Jun 15, 2021 at 2:37 PM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Tue, Jun 15, 2021 at 11:21:05AM +0800, Po-Hsu Lin wrote:
> > > On Fri, Nov 20, 2020 at 8:35 PM Andrew Jones <drjones@redhat.com> wrote:
> > > >
> > > > On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
> > > > > When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
> > > > > the Cortex-a53 cores) the its-migration test hangs. In the log file I see:
> > > > >
> > > > > run_migration timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> > > > > -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
> > > > > virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd
> > > > > -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 6
> > > > > -machine gic-version=3 -append its-migration # -initrd /tmp/tmp.OrlQiorBpY
> > > > > ITS: MAPD devid=2 size = 0x8 itt=0x40420000 valid=1
> > > > > ITS: MAPD devid=7 size = 0x8 itt=0x40430000 valid=1
> > > > > MAPC col_id=3 target_addr = 0x30000 valid=1
> > > > > MAPC col_id=2 target_addr = 0x20000 valid=1
> > > > > INVALL col_id=2
> > > > > INVALL col_id=3
> > > > > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > > > > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > > > > Now migrate the VM, then press a key to continue...
> > > > > scripts/arch-run.bash: line 103: 48549 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > >      48550 Segmentation fault      (core dumped) | ncat -U $1
> > > > > scripts/arch-run.bash: line 103: 48568 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > >      48569 Segmentation fault      (core dumped) | ncat -U $1
> > > > > scripts/arch-run.bash: line 103: 48583 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > >      48584 Segmentation fault      (core dumped) | ncat -U $1
> > > > > [..]
> > > > > scripts/arch-run.bash: line 103: 49414 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > >      49415 Segmentation fault      (core dumped) | ncat -U $1
> > > > > qemu-system-aarch64: terminating on signal 15 from pid 48496 (timeout)
> > > > > qemu-system-aarch64: terminating on signal 15 from pid 48504 (timeout)
> > > > > scripts/arch-run.bash: line 103: 49430 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > >      49431 Segmentation fault      (core dumped) | ncat -U $1
> > > > > scripts/arch-run.bash: line 103: 49445 Done                    echo '{ "execute":
> > > > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > > > [..]
> > > >
> > > > Is your ncat segfaulting? It looks like it from this output. Have you
> > > > tried running your ncat with a UNIX socket independently of this test?
> > > >
> > > > Is this the first time you've tried this test in this environment, or
> > > > is this a regression for you?
> > > >
> > > > >
> > > > > If I run the test manually:
> > > > >
> > > > > $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
> > > > > 'its-migration'
> > > >
> > > > This won't work because we need run_tests.sh to setup the run_migration()
> > > > call. The only ways to run migration tests separately are
> > > >
> > > >  $ ./run_tests.sh its-migration
> > > >
> > > > and
> > > >
> > > >  $ tests/its-migration
> > > >
> > > > For the second one you need to do 'make standalone' first.
> > > >
> > > >
> > > > >
> > > > > /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
> > > > > -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
> > > > > testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> > > > > arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
> > > > > /tmp/tmp.OtsTj3QD4J
> > > > > ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
> > > > > ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
> > > > > MAPC col_id=3 target_addr = 0x30000 valid=1
> > > > > MAPC col_id=2 target_addr = 0x20000 valid=1
> > > > > INVALL col_id=2
> > > > > INVALL col_id=3
> > > > > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > > > > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > > > > Now migrate the VM, then press a key to continue...
> > > > >
> > > > > And the test hangs here after I press a key.
> > > >
> > > > The test doesn't get your input because of the '</dev/null' in run_qemu(),
> > > > which ./arm-run calls. So it's not hanging it's just waiting forever on
> > > > the key press.
> > > Hello Andrew,
> > > We have found this waiting for key press issue on our side as well
> > > [1], the test will fail with TIMEOUT, it looks like it's not getting
> > > my input like you mentioned here.
> > > I would like to ask what is the expected behaviour of these migration
> > > related tests (its-pending-migration / its-migration /
> > > its-migrate-unmapped-collection)? Should they pass right after the
> > > tester hit a key?
> >
> > They should, but normally users don't need to press a key, because the
> > script uses ncat to do it for them.
> >
> > > Also, if these test would require user interaction, should they be
> > > moved to some special group like 'nodefault' to prevent it from
> > > failing with timeout in automated tests?
> >
> > The tests shouldn't be a problem when ncat does its job.
> >
> >
> >
> > I still think we have a script/ncat issue here. Please provide
> >
> >  qemu version:
> >  bash version:
> >  ncat version:
> >
> > And the distro and distro version might also be helpful.
>
> Hi Andrew,
> thanks for the info, here is my system information:
> * Ubuntu Hirsute 21.04 (5.11.0-18-generic)
> * qemu version (qemu-system-arm) - QEMU emulator version 5.2.0 (Debian
> 1:5.2+dfsg-9ubuntu3)
> * bash version - GNU bash, version 5.1.4(1)-release (aarch64-unknown-linux-gnu)
> * ncat version - Ncat: Version 7.80 ( https://nmap.org/ncat )
>
> Cheers
>
Hello Andrew,
is there anything I can test here for this issue?
Thanks!

> >
> > Thanks,
> > drew
> >
