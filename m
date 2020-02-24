Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102A916AD69
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 18:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgBXRaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 12:30:00 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38913 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgBXRaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 12:30:00 -0500
Received: by mail-lj1-f196.google.com with SMTP id o15so11041908ljg.6
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 09:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jsQJlTyskA0Ki07fJrpfgyrWATwYsZ5Q4Xe6qgxBOc8=;
        b=mETZAO1vdIZOsDJmbvtgzEwTRI4BoX3SST9GIdM3ItbQV4BTE0ax2xQ0qiqBTVHxXO
         eEp8i1T90FTbVW2dO0JNIZWJxcpLS6bt/OnescZ3Ibv6xEY865FBOGRqxbQ64DyY+oVh
         f78nwJLUqyWUSHWs2F6YBVSl6WoN5rMLXXp8jnk8Fb2/dauN0hAuL6GI/d8dmNaabQ9K
         feY/8wEjVwWpPW7nnW8dZu8hh3XrjJ4lfzzVtNJtWRhHB6w6HM46D+MmHJnRRn+7AexO
         5wK7uZQnkgt8Pghic+05BEDvQxbNcCrXZSxF1TJGKz3q8uSQTnCXLVsMZSC5RijEjJ1x
         +J/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jsQJlTyskA0Ki07fJrpfgyrWATwYsZ5Q4Xe6qgxBOc8=;
        b=B9v1nGaHcfXtu8xuWL2YWDlqwqJIRBc2sKL4kh3nHKOLEyZ2Ynu08FwKN22Y7CdUqK
         4Rqk9JoWmHaW0mInZYN73LyvnWTsPrvjNEdyfVPCE6lPbDqyhJbnKwz2f0Yrq+ZnNIDf
         1lAG5UTsA8tZoPGGbj8gbMlWAGbCFrBl+eUpecib5gMrhNV8YycwgRLoLKEbcB5QSF2A
         ThSLOAYjs3oldMVJ/NXCoDYd5mAIFJUh5h7KUR+pQ2p5RQ14gznR7edZODQQls4D5I4J
         kFjX0mnrSuVn0DXE9CtQoBmUvK78YxuU6QQIT5IYOCqs2FuhH7HMpP+bVjGMYlGSHNOs
         d0UA==
X-Gm-Message-State: APjAAAVhXG3Juv1b47/ShLqfpwcyfvthFzKlZ+/Tyk9wlOhh1TCEDkZ+
        HZJKWHxarhuuR9ubHF50ArfnjE7cTabpDUSQgNelIw==
X-Google-Smtp-Source: APXvYqwMw9D3fn1Yq2ISy/dWF4lvAZzz/qFb9Ujpuld6rSVChtLd+yQ+A4P335diyaqlXg39J5cTSBFcT/AOJYlB94s=
X-Received: by 2002:a2e:9e55:: with SMTP id g21mr31783876ljk.245.1582565396929;
 Mon, 24 Feb 2020 09:29:56 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com> <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
 <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com>
In-Reply-To: <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 24 Feb 2020 22:59:45 +0530
Message-ID: <CA+G9fYvwSc_riC8yBam-e2hS7D1AoQvnSz1htD2marQNuVVB=g@mail.gmail.com>
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

Hi Alexandru,

On Mon, 24 Feb 2020 at 19:17, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On 2/24/20 1:38 PM, Andrew Jones wrote:
> > On Mon, Feb 24, 2020 at 01:21:23PM +0000, Alexandru Elisei wrote:
> >> Hi Naresh,
> >>
> >> On 2/24/20 12:53 PM, Naresh Kamboju wrote:
> >>> [Sorry for the spam]
> >>>
> >>> Greeting from Linaro !
> >>> We are running kvm-unit-tests on our CI Continuous Integration and
> >>> testing on x86_64 and arm64 Juno-r2.
> >>> Linux stable branches and Linux mainline and Linux next.
> >>>
> >>> Few tests getting fail and skipped, we are interested in increasing the
> >>> test coverage by adding required kernel config fragments,
> >>> kernel command line arguments and user space tools.
> >>>
> >>> Your help is much appreciated.
> >>>
> >>> Here is the details of the LKFT kvm unit test logs,
> >>>
> >>> [..]
> >> I am going to comment on the arm64 tests. As far as I am aware, you don't need any
> >> kernel configs to run the tests.
> >>
> >> From looking at the java log [1], I can point out a few things:
> >>
> >> - The gicv3 tests are failing because Juno has a gicv2 and the kernel refuses to
> >> create a virtual gicv3. It's normal.
> > Yup
> >
> >> - I am not familiar with the PMU test, so I cannot help you with that.
> > Where is the output from running the PMU test? I didn't see it in the link
> > below.
>
> It's toward the end, it just says that 2 tests failed:
>
> |TESTNAME=pmu TIMEOUT=90s ACCEL= ./arm/run arm/pmu.flat -smp 1|
> |[31mFAIL[0m pmu (3 tests, 2 unexpected failures)|
> >
> >> - Without the logs, it's hard for me to say why the micro-bench test is failing.
> >> Can you post the logs for that particular run?

Would it be a good idea to print failed log on console when test fails ?

timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/pmu.flat -smp 1 # -initrd /tmp/tmp.ZJ05lRvgc4
INFO: PMU version: 3
INFO: pmu: PMU implementer/ID code/counters: 0x41(\"A\")/0x3/6
PASS: pmu: Control register
Read 0 then 0.
FAIL: pmu: Monotonically increasing cycle count
instrs : cycles0 cycles1 ...
4:    0
cycles not incrementing!
FAIL: pmu: Cycle/instruction ratio
SUMMARY: 3 tests, 2 unexpected failures


>>> They are located in
> >> /path/to/kvm-unit-tests/logs/micro-bench.log. My guess is that it has to do with
> >> the fact that you are using taskset to keep the tests on one CPU. Micro-bench will
> >> use 2 VCPUs to send 2^28 IPIs which will run on the same physical CPU, and sending
> >> and receiving them will be serialized which will incur a *lot* of overhead. I
> >> tried the same test without taskset, and it worked. With taskset -c 0, it timed
> >> out like in your log.
> > We've also had "failures" of the micro-bench test when run under avocado
> > reported. The problem was/is the assert_msg() on line 107 is firing. We
> > could probably increase the number of tries or change the assert to a
> > warning. Of course micro-bench isn't a "test" anyway so it can't "fail".
> > Well, not unless one goes through the trouble of preparing expected times
> > for each measurement for a given host and then compares new results to
> > those expectations. Then it could fail when the results are too large
> > (some threshold must be defined too).
>
> That happens to me too on occasions when running under kvmtool. When it does I
> just rerun the test and it passes almost always. But I think that's not the case
> here, since the test times out:

micro-bench [1] always timeout on arm64 juno-r2 running with taskset -c 0
with new test code it failed it used to be skipped.

>
> |TESTNAME=micro-bench TIMEOUT=90s ACCEL=kvm ./arm/run arm/micro-bench.flat -smp 2|
> |[31mFAIL[0m micro-bench (timeout; duration=90s)|
>
> I tried it and I got the same message, and the in the log:
>
> $ cat logs/micro-bench.log
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine
> virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device
> virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none
> -serial stdio -kernel arm/micro-bench.flat -smp 2 # -initrd /tmp/tmp.XXOYQIrjIM
> Timer Frequency 40000000 Hz (Output in microseconds)
>
> name                                    total ns                         avg
> ns
> --------------------------------------------------------------------------------------------
> hvc                                  87727475.0
> 1338.0
> mmio_read_user                      348083225.0
> 5311.0
> mmio_read_vgic                      125456300.0
> 1914.0
> eoi                                    820875.0
> 12.0
> qemu-system-aarch64: terminating on signal 15 from pid 23273 (timeout)

timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64
-nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device
virtio-serial-device -device virtconsole,chardev=ctd -chardev
testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/micro-bench.flat -smp 2 # -initrd /tmp/tmp.urqlMsBpJd
Timer Frequency 50000000 Hz (Output in microseconds)
name                          total ns               avg ns
--------------------------------------------------------------------------------------------
hvc                              296915440.0                         4530.0
mmio_read_user      1322325100.0                        20177.0
mmio_read_vgic         462255460.0                         7053.0
eoi                                  6779880.0                          103.0
qemu-system-aarch64: terminating on signal 15 from pid 3097 (timeout)

[1]
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kvm-unit-tests/micro-bench

>
> Thanks,
> Alex
