Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C6716BE05
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 10:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgBYJ4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 04:56:08 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36822 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYJ4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 04:56:08 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so13301681ljg.3
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 01:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RXfxzGT82r2awc7IN2foaiR0ov1bF81vSFtrmS6a0D8=;
        b=ZhaNBGau4KlZATHPuSdFsIezBMqh2I2eamj4muaOpXXW3vtYW4srKMKGoFcHepZgl/
         y4Y2YrEMESurSY8Llbm1+G3R6QfyK8j/hV9vRxRanTldUPoeISqI4AO466iRPcC5khHI
         +Gyw2cyFKZySfXRLkv/NvMm4qktR43YChV2DjiICCDjbvdCHcv0A+KuZdC5kdLzDILJZ
         BDXh3tQHUUlgzfS5sKmZGTAftFJGIg2ryxrTVfn7LU0qS/pUyQ5jHWcqOXojBuKCm3L6
         mVek2AArDZSjWJWx77oJsl8nJPFRY6uQCnd2QMf6n7qDRB+OW5kh2Oe98xM+MDuYhy5h
         0OIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RXfxzGT82r2awc7IN2foaiR0ov1bF81vSFtrmS6a0D8=;
        b=Xuff6JHCiymKsjwwMxnsYBZWBLw4BYAUYVxVps+YwGuLaz8qBw3VHnnVV/J6tPSbdj
         iBGoMjqN573gUu+O+WC/PYXrPKijQka/0qYqQpxeGeppNt/KpCiT+12rjXjxFcNj7w5h
         Ct3IahnZqYcLpEzCjS4civ09TDyXtHfat+X2izSevnRGthtFfDMf7CGDVIs37mX51Ij2
         7t3TrS04FtBBey7zeImsALv2qNwZ/koAp+5atujPFlqR9XeW2u8RQ54E8AygRV8sfqJ5
         mxtn6Fr2LId/dWSMlcHbhIRFAU9nrcFkhIf5dg8WXjW9ci/yKea/PRZHkLcgcFuI1ta7
         D6oQ==
X-Gm-Message-State: APjAAAWYJ+rGN02USxnSy9MA2Sfw5JELXlhfRlJrD36E9aXicOR/nX+5
        M9F3UH3GwbEwmW+W+rlb3KZ/b3B3eS3en0XXMBKMTA==
X-Google-Smtp-Source: APXvYqz0nSefY3Dbl5kZ58DLsWHjP9TGrg9XY6k94dIgDEjgTfNUnIVOAuC0b4AJRFCGokGFOG1QM3EeKSEbXu/Tpf8=
X-Received: by 2002:a05:651c:414:: with SMTP id 20mr31345952lja.165.1582624566029;
 Tue, 25 Feb 2020 01:56:06 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <9cb2dbed-356d-31cd-22aa-fa99beada9f7@redhat.com>
In-Reply-To: <9cb2dbed-356d-31cd-22aa-fa99beada9f7@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Feb 2020 15:25:54 +0530
Message-ID: <CA+G9fYuTNr3YrehjuQD=nCXhdrirxGaiNEVMS+mHcM0fGVigVQ@mail.gmail.com>
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, namit@vmware.com,
        sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 at 01:33, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/02/20 13:53, Naresh Kamboju wrote:
> > FAIL  vmx (408624 tests, 3 unexpected failures, 2 expected
> > failures, 5 skipped)
>
> This is fixed in the latest kvm-unit-tests.git.

Running latest kvm-unit-tests on x86_64 got this output [1].
"VMX enabled and locked by BIOS"
We will enable on our BIOS and re-run these tests.

+ cat logs/vmx.log
timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 -nodefaults
-device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc
none -serial stdio -device pci-testdev -machine accel=kvm -kernel
x86/vmx.flat -smp 1 -cpu host,+vmx -append -exit_monitor_from_l2_test
-ept_access* -vmx_smp* -vmx_vmcs_shadow_test
-atomic_switch_overflow_msrs_test -vmx_init_signal_test
-vmx_apic_passthrough_tpr_threshold_test # -initrd /tmp/tmp.XZcnThGaPI
enabling apic
paging enabled
cr0 = 80010011
cr3 = 63d000
cr4 = 20
VMX enabled and locked by BIOS
PASS: test vmxon with unaligned vmxon region
<>
PASS: ENT_LOAD_DBGCTLS enabled, GUEST_DR7 80000000
Unhandled exception 13 #GP at ip 0000000000409af5
error_code=0000      rflags=00010046      cs=00000008
rax=0000000000000001 rcx=0000000000000000 rdx=0000000000000000
rbx=0000000000635a10
rbp=0000000000644fdf rsi=0000000000000000 rdi=0000000000000000
 r8=0000000000000000  r9=0000000000000000 r10=0000000000000000
r11=0000000000000000
r12=0000000000000000 r13=0000000000000000 r14=0000000000000000
r15=0000000000000000
cr0=0000000080010031 cr2=ffffffffffffe000 cr3=000000000063d000
cr4=0000000000002020
cr8=0000000000000000
STACK: @409af5 401765 400535
0x0000000000409af5: guest_state_test_main at x86/vmx_tests.c:5072
Error pretty printing stack:
Traceback (most recent call last):
  File \"./scripts/pretty_print_stacks.py\", line 83, in main
    pretty_print_stack(binary, line)
  File \"./scripts/pretty_print_stacks.py\", line 49, in pretty_print_stack
    lines = open(path).readlines()
  File \"/usr/lib/python3.5/encodings/ascii.py\", line 26, in decode
    return codecs.ascii_decode(input, self.errors)[0]
UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3 in position
7651: ordinal not in range(128)
Continuing without pretty printing...
STACK: @409af5 401765 400535

[1] https://lkft.validation.linaro.org/scheduler/job/1250342#L1761

>
> Paolo
>
