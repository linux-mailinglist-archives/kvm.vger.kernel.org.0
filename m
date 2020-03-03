Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39CB317829D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 20:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgCCSxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 13:53:20 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43594 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbgCCSxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 13:53:20 -0500
Received: by mail-lf1-f68.google.com with SMTP id s23so3659192lfs.10
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 10:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G1rFZaea9BK3b4wUfruQ7G0LK/25ghthW1G2sNgml7k=;
        b=mkoPatuPS/SkcduMBsA0coljwYC4VYWcoF1Jde1trtw2sCAMZK5QhNPT06ViYxV2XM
         yxGRRQ7C854GO3psHkEX3STRDXVU0S+qpus37MCvPspCzo2l0YQj/ZShOJGq9m6wRgI2
         YXbYwsbMw3h3gkYRth/IWK40B4Y2GGZ6CYHPSsbd8pWhBmohoOWDglmJ9sMNWaUiZ07/
         wyhrzfJi/FKI/PU4aRW0QSVYkvFwZoHYRLbM9B/kNBfM7ojTvnU6IQnNzaYV01fjwrbp
         z2+o4WJTb9/2Nu5S9jjPhxDQlRhxHEivh5zgyZCilPUo5D9L98apYZxr1OEl4TeJwPZr
         5ffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G1rFZaea9BK3b4wUfruQ7G0LK/25ghthW1G2sNgml7k=;
        b=EPCrWFDWVHtLJLx4mEou78CkFOBpmLOtEoCysVEaJjqNXogPyZVbtlggWxFAXJAq+v
         cFnOtWUW+RHu9DGVhF/WFAGkryU5scpexe9qhHLOF0cRMdD5A7HPG3ol+1Vfn5ZAWC7Y
         +A9p/uaqmD21iaw0dTUKH3cYVx/kq+Y8IM41PvPZVOPlM/RqjTD2ZjIuacajEC2p/rxb
         Cjbi/KPUZBihR6FZNLWTo7U8d6O9z/R3wsO0Z+KUB9yDZ9dv39EanObbbtScz4gGk1Q8
         nulcEFGUndoS3bq2baOnjdvXm5ijC+APJusnFDnVAIC7ejcdSoPuxIBoAiQYLvqP8VBN
         StuQ==
X-Gm-Message-State: ANhLgQ3u9A9UQq7wVK2uhwZPXQ9DvJzbOcowYOke7fdeGIcC+6RuYqkG
        iMT1Dmtfs7IuGheI75xixXv2cwFiHmC6PIksQ1Focg==
X-Google-Smtp-Source: ADFU+vvW24LumfTp4zNrx9D5LaNU3ajtGV7X1StQtuE0E1EBjo0I+BBx+0o/fEH207sxIjwoiaWwq44Kt3d5uKAktvs=
X-Received: by 2002:ac2:4d16:: with SMTP id r22mr3433400lfi.74.1583261597834;
 Tue, 03 Mar 2020 10:53:17 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com> <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
 <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com> <20200224145936.mzpwveaoijjmb5ql@kamzik.brq.redhat.com>
 <CA+G9fYvt2LyqU5G2j_EFKzgPXzt8sDYYm8NxP+zD6Do07REsYw@mail.gmail.com>
 <7b9209be-f880-a791-a2b9-c7e98bf05ecd@arm.com> <CA+G9fYvjoeLV5B951yFb8fc7r+WAejz+0kHcFYTNzW6+HfouXw@mail.gmail.com>
 <CA+G9fYuEfrhW_7vLCdK4nKBhDv6aQkK_knUY7mbgeDcuaETLyQ@mail.gmail.com> <a1f51266-d735-402a-6273-8ae84d415881@arm.com>
In-Reply-To: <a1f51266-d735-402a-6273-8ae84d415881@arm.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 4 Mar 2020 00:23:06 +0530
Message-ID: <CA+G9fYt2UFv=i5Wg1cwM-hiHNRdkTUHjMZUfbWCY=CWVAoSwrQ@mail.gmail.com>
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, namit@vmware.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Basil Eljuse <Basil.Eljuse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 3 Mar 2020 at 21:32, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On 2/25/20 8:20 AM, Naresh Kamboju wrote:
> > Hi Alexandru,
> >
> > On Mon, 24 Feb 2020 at 23:14, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >>> I think this is because you are running it on one physical CPU (it's exactly the
> >>> same message I am getting when I use taskset to run the tests). Can you try and
> >>> run it without taskset and see if it solves your issue?
> > We have a new problem when running [1] without taskset on Juno-r2.
> > None of the test got pass [2] when running without taskset on Juno-r2.
> >
> I think I have an explanation for why all the tests fail. qemu creates a vcpu to
> match the host cpu in kvm_arm_create_scratch_host_vcpu and it sets the target to
> whatever the result of the KVM_ARM_PREFERRED_TARGET ioctl is. If it's run on the
> little core, the target will be KVM_ARM_TARGET_CORTEX_A53. If it's run on the big
> core, the target will be KVM_ARM_TARGET_GENERIC_V8. I tried it a few times, and
> for me it has always been the big core.
>
> The vcpu is created from a different thread by doing a KVM_ARM_VCPU_INIT ioctl and
> KVM makes sure that the vcpu target matches the target corresponding to the
> physical CPU the thread is running on. What is happening is that the vcpu thread
> is run on a little core, so the target as far as KVM is concerned should be
> KVM_ARM_TARGET_CORTEX_A53, but qemu (correctly) set it to
> KVM_ARM_TARGET_GENERIC_V8. The ioctl return -EINVAL (-22) and qemu dies.
>
> To get around this, I ran the tests either only on the big cores or on the little
> cores.

Thanks for explaining in details.
I have seen this scenario and defined my test to run only on CPU 0.
The CPU 0 on my Juno-r2 devices found to be LITTLE CPU.

>
> I also managed to reliably trigger the PMU failures that you are seeing. They only
> happen when kvm-unit-tests is run on the little cores (ran them 10 times in a
> loop). When run on  the big cores, everything is fine (also ran them 10 times in a
> loop). Log output when it fails:

Thanks for reproducing this PMU failure.

>
> # taskset -c 0,3,4,5 arm/run arm/pmu.flat

CPU 0,3,4,5 are seem to be on little cores.

> /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
> -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev
> testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
> arm/pmu.flat # -initrd /tmp/tmp.s4ld4DX4uK
> INFO: PMU version: 3
> INFO: pmu: PMU implementer/ID code/counters: 0x41("A")/0x3/6
> PASS: pmu: Control register
> Read 0 then 0.
> FAIL: pmu: Monotonically increasing cycle count
> instrs : cycles0 cycles1 ...
>    4:    0
> cycles not incrementing!
> FAIL: pmu: Cycle/instruction ratio
> SUMMARY: 3 tests, 2 unexpected failures
>
> I'm looking into it.

- Naresh
