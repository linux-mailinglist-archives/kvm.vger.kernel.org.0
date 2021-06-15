Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32543A7728
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 08:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhFOGjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 02:39:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229659AbhFOGjN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 02:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623739029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/uTYDE6axgI8+V5JJRzWIMMuTTgoiXTw80Zr4xUCLF0=;
        b=FkEirsxGcYvU+iq5HtoFdXwBJVJtSWJ5ZJe3FGNuIbEfx+eVuLlGhrlBvEHYPJoITV43y6
        83hmvnD/MPkW/0Gi63whNdu+ucmG1puiUfjl8MrL9S644Oaor06Fzh7hr+/s1rZiHnxRDu
        kmtlAunwwBc4JvtbWj0tz72QBmbXBko=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-iK7QpjeaNvyZlKl3z-gu6w-1; Tue, 15 Jun 2021 02:37:07 -0400
X-MC-Unique: iK7QpjeaNvyZlKl3z-gu6w-1
Received: by mail-ej1-f69.google.com with SMTP id b8-20020a170906d108b02903fa10388224so4047180ejz.18
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 23:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/uTYDE6axgI8+V5JJRzWIMMuTTgoiXTw80Zr4xUCLF0=;
        b=cJ4NxayEyWqUEeZqqSgcPHVmUUakUhPcsUmm/fmSQdn3z5j68YEbMZ0YPtnjaux+UJ
         I2fvY8O1GOQZZw6ifLlVUdLQqO52CeYjQWyvaOZlqqDDiYZJoUwtpnl4+bmFnuoHQpcB
         FwSqzQqQr9H8FcDWcXZqieHgqqCZncDe9y/yonsNjycvP7IxMXyGBHFMycJYOTIRvnGu
         Hnnxdb9vL3rBakgL/yXVqIlopJCUXffKLW8lwXRmQbX4uhQvijP9PW63bqLPIEBf1s3S
         keY7SFpYv2WWJj8BJo5WLNaxBZcCmcCx0kA+MRxT9PTrnGOBioMnbnYlmBVN1UVEbfK9
         Zw4A==
X-Gm-Message-State: AOAM530615PNWopAj75Ac2mDgS/w5r6iCty0UOfXrJFVopCWQHFT4Eaf
        JpH43ziTSo9oUxAYekLmcT3B+3zOJTnst3+xYnELSprb3sZkGpBylt3oCU9B1kRXCkbhxmJQ3D8
        0c/IPXz6PJIdG
X-Received: by 2002:a05:6402:10d7:: with SMTP id p23mr21087703edu.74.1623739026427;
        Mon, 14 Jun 2021 23:37:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIJEY877bzl4Nl2KxraQA7dX3+GKtUBy5mvWvkO0DSmKCTjIHyEw85M40WWw7qZpl6Wa9Ihw==
X-Received: by 2002:a05:6402:10d7:: with SMTP id p23mr21087686edu.74.1623739026290;
        Mon, 14 Jun 2021 23:37:06 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id q14sm10792082eds.2.2021.06.14.23.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 23:37:06 -0700 (PDT)
Date:   Tue, 15 Jun 2021 08:36:59 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests] its-migration segmentation fault
Message-ID: <20210615063659.7w2rp6jk76rhgeue@gator.home>
References: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
 <20201120123414.bolwl6pym4iy3m6x@kamzik.brq.redhat.com>
 <CAMy_GT9Y1JNyh5GkZm31RQ6nX8Jv9qHFRN2KeOe01GOyk2ifQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMy_GT9Y1JNyh5GkZm31RQ6nX8Jv9qHFRN2KeOe01GOyk2ifQg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 11:21:05AM +0800, Po-Hsu Lin wrote:
> On Fri, Nov 20, 2020 at 8:35 PM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Fri, Nov 20, 2020 at 12:02:10PM +0000, Alexandru Elisei wrote:
> > > When running all the tests with taskset -c 0-3 ./run_tests.sh on a rockpro64 (on
> > > the Cortex-a53 cores) the its-migration test hangs. In the log file I see:
> > >
> > > run_migration timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> > > -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
> > > virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd
> > > -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 6
> > > -machine gic-version=3 -append its-migration # -initrd /tmp/tmp.OrlQiorBpY
> > > ITS: MAPD devid=2 size = 0x8 itt=0x40420000 valid=1
> > > ITS: MAPD devid=7 size = 0x8 itt=0x40430000 valid=1
> > > MAPC col_id=3 target_addr = 0x30000 valid=1
> > > MAPC col_id=2 target_addr = 0x20000 valid=1
> > > INVALL col_id=2
> > > INVALL col_id=3
> > > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > > Now migrate the VM, then press a key to continue...
> > > scripts/arch-run.bash: line 103: 48549 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > >      48550 Segmentation fault      (core dumped) | ncat -U $1
> > > scripts/arch-run.bash: line 103: 48568 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > >      48569 Segmentation fault      (core dumped) | ncat -U $1
> > > scripts/arch-run.bash: line 103: 48583 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > >      48584 Segmentation fault      (core dumped) | ncat -U $1
> > > [..]
> > > scripts/arch-run.bash: line 103: 49414 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > >      49415 Segmentation fault      (core dumped) | ncat -U $1
> > > qemu-system-aarch64: terminating on signal 15 from pid 48496 (timeout)
> > > qemu-system-aarch64: terminating on signal 15 from pid 48504 (timeout)
> > > scripts/arch-run.bash: line 103: 49430 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > >      49431 Segmentation fault      (core dumped) | ncat -U $1
> > > scripts/arch-run.bash: line 103: 49445 Done                    echo '{ "execute":
> > > "qmp_capabilities" }{ "execute":' "$2" '}'
> > > [..]
> >
> > Is your ncat segfaulting? It looks like it from this output. Have you
> > tried running your ncat with a UNIX socket independently of this test?
> >
> > Is this the first time you've tried this test in this environment, or
> > is this a regression for you?
> >
> > >
> > > If I run the test manually:
> > >
> > > $ taskset -c 0-3 ./arm-run arm/gic.flat -smp 4 -machine gic-version=3 -append
> > > 'its-migration'
> >
> > This won't work because we need run_tests.sh to setup the run_migration()
> > call. The only ways to run migration tests separately are
> >
> >  $ ./run_tests.sh its-migration
> >
> > and
> >
> >  $ tests/its-migration
> >
> > For the second one you need to do 'make standalone' first.
> >
> >
> > >
> > > /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
> > > -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
> > > testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> > > arm/gic.flat -smp 4 -machine gic-version=3 -append its-migration # -initrd
> > > /tmp/tmp.OtsTj3QD4J
> > > ITS: MAPD devid=2 size = 0x8 itt=0x403a0000 valid=1
> > > ITS: MAPD devid=7 size = 0x8 itt=0x403b0000 valid=1
> > > MAPC col_id=3 target_addr = 0x30000 valid=1
> > > MAPC col_id=2 target_addr = 0x20000 valid=1
> > > INVALL col_id=2
> > > INVALL col_id=3
> > > MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> > > MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> > > Now migrate the VM, then press a key to continue...
> > >
> > > And the test hangs here after I press a key.
> >
> > The test doesn't get your input because of the '</dev/null' in run_qemu(),
> > which ./arm-run calls. So it's not hanging it's just waiting forever on
> > the key press.
> Hello Andrew,
> We have found this waiting for key press issue on our side as well
> [1], the test will fail with TIMEOUT, it looks like it's not getting
> my input like you mentioned here.
> I would like to ask what is the expected behaviour of these migration
> related tests (its-pending-migration / its-migration /
> its-migrate-unmapped-collection)? Should they pass right after the
> tester hit a key?

They should, but normally users don't need to press a key, because the
script uses ncat to do it for them.

> Also, if these test would require user interaction, should they be
> moved to some special group like 'nodefault' to prevent it from
> failing with timeout in automated tests?

The tests shouldn't be a problem when ncat does its job.



I still think we have a script/ncat issue here. Please provide

 qemu version:
 bash version:
 ncat version:

And the distro and distro version might also be helpful.

Thanks,
drew

