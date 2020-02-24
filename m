Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909C816ADEC
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 18:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgBXRop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 12:44:45 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33068 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBXRop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 12:44:45 -0500
Received: by mail-lj1-f194.google.com with SMTP id y6so11136675lji.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 09:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZuXtdUZGPD6QyOsTmkvGwn0StHpbOBjuLPxdBTJnH8=;
        b=tc05Z/iC6tQ6OQcRq8KmybWsNnb/FsugnUl2GuFuy9bhkACF/EZ8LSi45foB60C/3H
         AOy7gKbfP0jydh+X/SD7Nx0ysVP/o4Mj8nVSVYYsBVrMq/ClEi/fQKolEDBp9Wo87fUu
         36KIhtNtGl0cgAtc65exJMUrceBTt8/BA1t1Gd6tJEpE25MY+2BlnUvlfN8qrFk6tCnT
         nc0wIb6Hup8N95pRgpMjxI+Gn4Dib0VmsY7PkODUksxb2DysTGZ2L0O5sMs/CqOhMPRr
         5p8ldIwTUmUEwbuidO5vGMS/2hV8D6qxipN/tJ7XpB9tV6xMzCdZiywmAnrIvsJjyxs7
         8Tjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZuXtdUZGPD6QyOsTmkvGwn0StHpbOBjuLPxdBTJnH8=;
        b=RZcce0LwrZjg5qN4rZGcNo03VT6QOHa5tWqTOD9G/8XmkovJey1hQrGkwBK6F0uSCg
         GDgM6A5l1BpCK5oIfCTMlNo8V13aygheY8kXAOAHg1hk3WBbKMNMmOjeMgNwmDrdNDDE
         8G/WMuwL/rRLWv+KXdvJp/iX2nY2CYTEReT5uLSE5UEvUXuF9gBnGlOcGdz4I+ePN29k
         J9Y+5nKw8qlBtAwu1HA4S9cE4LxO7bqrP6hUTh5+aVoxWNLIgljYtLSx3Pp0M21jl3mr
         HcQY36U0bGekE0rwv1yFoXo8CBXeJW2EvJa0h+QOew/hQV8/pzbVqEYBgj1C3yKpyRFx
         cbgg==
X-Gm-Message-State: APjAAAWr7hJyGdqSIhTjYrt3JoOQfYIXGJrik5b2/fVgbXa0ZOc4cDw0
        EHudwU7cjHIxTbfamQOXEABhaj9FkQvn/Yn9QzoyAQ==
X-Google-Smtp-Source: APXvYqwZk7R2XAZQnTHauGInE6hRHSuhvIQEGQ7ZcoHtJuAI59YTGq+4q9dY9Ne+HGTwInj95R1hut1iQJUjp2uJh04=
X-Received: by 2002:a05:651c:414:: with SMTP id 20mr29584161lja.165.1582566282344;
 Mon, 24 Feb 2020 09:44:42 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com> <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
 <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com> <20200224145936.mzpwveaoijjmb5ql@kamzik.brq.redhat.com>
 <CA+G9fYvt2LyqU5G2j_EFKzgPXzt8sDYYm8NxP+zD6Do07REsYw@mail.gmail.com> <7b9209be-f880-a791-a2b9-c7e98bf05ecd@arm.com>
In-Reply-To: <7b9209be-f880-a791-a2b9-c7e98bf05ecd@arm.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 24 Feb 2020 23:14:31 +0530
Message-ID: <CA+G9fYvjoeLV5B951yFb8fc7r+WAejz+0kHcFYTNzW6+HfouXw@mail.gmail.com>
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        namit@vmware.com, sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 at 23:06, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On 2/24/20 4:55 PM, Naresh Kamboju wrote:
> > On Mon, 24 Feb 2020 at 20:29, Andrew Jones <drjones@redhat.com> wrote:
> >> On Mon, Feb 24, 2020 at 01:47:44PM +0000, Alexandru Elisei wrote:
> >>> Hi,
> >>>
> >>> On 2/24/20 1:38 PM, Andrew Jones wrote:
> >>>> On Mon, Feb 24, 2020 at 01:21:23PM +0000, Alexandru Elisei wrote:
> >>>>> Hi Naresh,
> >>>>>
> >>>>> On 2/24/20 12:53 PM, Naresh Kamboju wrote:
> >>>>>> [..]
> >>>>> I am going to comment on the arm64 tests. As far as I am aware, you don't need any
> >>>>> kernel configs to run the tests.
> > Thanks for the confirmation on Kconfig part for arm64.
> > The next question is, How to enable and run nested virtual testing ?
>
> There's not support in KVM to run nested guests (yet [1]) and no support in
> kvm-unit-tests to run at EL2 (yet [2]) and no hardware that has supported for
> nested virtualization (yet).

ack.

>
> [1] https://www.spinics.net/lists/arm-kernel/msg784744.html
> [2] https://www.spinics.net/lists/kvm/msg203527.html
> >
> >>>>> From looking at the java log [1], I can point out a few things:
> >>>>>
> >>>>> - The gicv3 tests are failing because Juno has a gicv2 and the kernel refuses to
> >>>>> create a virtual gicv3. It's normal.
> > Got it.
> > Because of heterogeneous big.LITTLE CPU architecture of Juno device caused
> > test hang and "taskset -c 0 ./run_tests.sh -a -v -t " solved this problem.
>
> KVM doesn't normally care about big.little configurations, and kvm-unit-tests
> definitely doesn't do anything that is specific to a certain microarchitecture. I
> would say something else is wrong here. I'll try and reproduce it on my Juno when
> I get the time, but that might not happen until next week. Can you trigger this
> behaviour every run?

I will schedule multiple runs and get an answer by tomorrow.

>
> >
> >>>> Yup
> > timers test is intermittent failure due to timeout on the CPU 0 which
> > is configured
> > as LITTLE cpu cortext a53. If i change test to run on big CPU then it
> > always PASS.
> > "taskset -c $BIG_CPU_ID ./run_tests.sh -a -v -t"
>
> This might just be an unfortunate mix of events and kernel scheduling decisions
> for the VCPU thread that is causing an unexpected delay in receiving timer
> interrupts. Hard to know without a log.
>
> >
> >>>>> - I am not familiar with the PMU test, so I cannot help you with that.
> >>>> Where is the output from running the PMU test? I didn't see it in the link
> >>>> below.
> >>> It's toward the end, it just says that 2 tests failed:
> >> If the test runner isn't capturing all the output of the tests somewhere,
> >> then it should. Naresh, is the pmu.log file somewhere?
> > For more detail I have shared LAVA log [1] and attached detail run output.
> >
> > timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> > -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
> > virtio-serial-device -device virtconsole,chardev=ctd -chardev
> > testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> > arm/pmu.flat -smp 1 # -initrd /tmp/tmp.ZJ05lRvgc4
> > INFO: PMU version: 3
> > INFO: pmu: PMU implementer/ID code/counters: 0x41(\"A\")/0x3/6
> > PASS: pmu: Control register
> > Read 0 then 0.
> > FAIL: pmu: Monotonically increasing cycle count
> > instrs : cycles0 cycles1 ...
> > 4:    0
> > cycles not incrementing!
> > FAIL: pmu: Cycle/instruction ratio
> > SUMMARY: 3 tests, 2 unexpected failures
>
> This when running the tests with taskset, right?

Right.

>
> > [..]
> > timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
> > -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
> > virtio-serial-device -device virtconsole,chardev=ctd -chardev
> > testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> > arm/micro-bench.flat -smp 2 # -initrd /tmp/tmp.urqlMsBpJd
> > Timer Frequency 50000000 Hz (Output in microseconds)
> > name                                    total ns                         avg ns
> > --------------------------------------------------------------------------------------------
> > hvc                                 296915440.0                         4530.0
> > mmio_read_user                     1322325100.0                        20177.0
> > mmio_read_vgic                      462255460.0                         7053.0
> > eoi                                   6779880.0                          103.0
> > qemu-system-aarch64: terminating on signal 15 from pid 3097 (timeout)
> >
> > [..]
>
> I think this is because you are running it on one physical CPU (it's exactly the
> same message I am getting when I use taskset to run the tests). Can you try and
> run it without taskset and see if it solves your issue?

Alright. I will run without taskset and share logs here.

>
> Thanks,
> Alex
