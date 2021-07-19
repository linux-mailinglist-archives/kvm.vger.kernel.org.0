Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29C53CCEAC
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 09:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhGSHkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 03:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbhGSHkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 03:40:47 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0B6C061762;
        Mon, 19 Jul 2021 00:37:46 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id f93-20020a9d03e60000b02904b1f1d7c5f4so17326100otf.9;
        Mon, 19 Jul 2021 00:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KU35joaREKi8wYu27nSbbTlLzVUkngjyeSpBRqp8l7c=;
        b=ZhAtP9jq6ssyHpI49UT0cK4YAvAtrj6bw2VVxDWN1P8r+akwluUSu65GIEbpyL0p2P
         a3JOVSgo7nTywmhWBZIMNmrcWYHJpQx51kZWc5e2WVlTAxA+MEPQyrJTNcP7UZxGBR7y
         XdOd2CzFWMVuygQa8ynJH2k6Fz3xDR1fnKG0ihpleyx9/wA02Gj5CWvKttSayMTFv2sB
         S6Gq4rtLykxw7IFJhDVCnH/DHS5CgdcuuPPXCZGBBP972+tbE0Lbsr80WkmdhyS2YE/S
         Sdq4ThrXb0ImqzSm1/gvisFsqq18C2GMZkQpv1CbOmQXyAlDy/qTihjLvHJnkNDXzgpa
         Of+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KU35joaREKi8wYu27nSbbTlLzVUkngjyeSpBRqp8l7c=;
        b=C/cp0Mn+onIzz50U/qOhHVg6m3ISmlfhO0w/cqzWsgcBoy46sajlsCz/5YWw4DwSQi
         GoXJ4NRHk+X40StpmKLTfaFMzbe0csk9TNhNbaCSX3q4UVxXa1ob3Ssx84AYh2DpdL7Z
         R2kvwWuI0LBA7RL8MGla/XV0sn3TcBpuVqp7koq2ZBjD89evg+2yaN8XpVvpLp31Vt5d
         ldeyKod2HOWeRAxMSoMnx68Mm5YfHtU91QxjJ4eHZZHySigAqp1DSZcK8UIoudzi83Yx
         vrrraSXhJt2Kl5u4pnweD2vzvpqf/HMis9KWdZM+lVRL3crJdR8NdGFtLEJf7E8vMi11
         RlAg==
X-Gm-Message-State: AOAM533q+FzCo7uZti0BWVVLrrT+U4H8efe8u0u+sMDbM9PSV69ZL0bd
        MSvseMJTGGO9KgA91OtaciJ6t7HjbwOMGZZifBg=
X-Google-Smtp-Source: ABdhPJx/A2HSRknv97oVh/werPfkOH754gHACP5lmv08U10mFj0/qfdqEqassAcnwX7oR6Bt9vD5wv8tb7S04mrZITo=
X-Received: by 2002:a05:6830:1c69:: with SMTP id s9mr17719718otg.185.1626680266412;
 Mon, 19 Jul 2021 00:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210716064808.14757-1-guang.zeng@intel.com> <CANRm+Cy=ncU-H7duei5q+CG+pm-kXvG8N8CiUQavQ3OEpDj9eg@mail.gmail.com>
 <d96aa6dc-0638-f77e-f412-e2af52053d2c@intel.com>
In-Reply-To: <d96aa6dc-0638-f77e-f412-e2af52053d2c@intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 19 Jul 2021 15:37:35 +0800
Message-ID: <CANRm+CyinezdL4udNv1fkCymCUdOjG7wjBPKsbcMTVw0pAbcjA@mail.gmail.com>
Subject: Re: [PATCH 0/5] IPI virtualization support for VM
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 19 Jul 2021 at 15:26, Zeng Guang <guang.zeng@intel.com> wrote:
>
> On 7/16/2021 5:25 PM, Wanpeng Li wrote:
> > On Fri, 16 Jul 2021 at 15:14, Zeng Guang <guang.zeng@intel.com> wrote:
> >> Current IPI process in guest VM will virtualize the writing to interru=
pt
> >> command register(ICR) of the local APIC which will cause VM-exit anywa=
y
> >> on source vCPU. Frequent VM-exit could induce much overhead accumulate=
d
> >> if running IPI intensive task.
> >>
> >> IPI virtualization as a new VT-x feature targets to eliminate VM-exits
> >> when issuing IPI on source vCPU. It introduces a new VM-execution
> >> control - "IPI virtualization"(bit4) in the tertiary processor-based
> >> VM-exection controls and a new data structure - "PID-pointer table
> >> address" and "Last PID-pointer index" referenced by the VMCS. When "IP=
I
> >> virtualization" is enabled, processor emulateds following kind of writ=
es
> >> to APIC registers that would send IPIs, moreover without causing VM-ex=
its.
> >> - Memory-mapped ICR writes
> >> - MSR-mapped ICR writes
> >> - SENDUIPI execution
> >>
> >> This patch series implement IPI virtualization support in KVM.
> >>
> >> Patches 1-3 add tertiary processor-based VM-execution support
> >> framework.
> >>
> >> Patch 4 implement interrupt dispatch support in x2APIC mode with
> >> APIC-write VM exit. In previous platform, no CPU would produce
> >> APIC-write VM exit with exit qulification 300H when the "virtual x2API=
C
> >> mode" VM-execution control was 1.
> >>
> >> Patch 5 implement IPI virtualization related function including
> >> feature enabling through tertiary processor-based VM-execution in
> >> various scenario of VMCS configuration, PID table setup in vCPU creati=
on
> >> and vCPU block consideration.
> >>
> >> Document for IPI virtualization is now available at the latest "Intel
> >> Architecture Instruction Set Extensions Programming Reference".
> >>
> >> Document Link:
> >> https://software.intel.com/content/www/us/en/develop/download/intel-ar=
chitecture-instruction-set-extensions-programming-reference.html
> >>
> >> We did experiment to measure average time sending IPI from source vCPU
> >> to the target vCPU completing the IPI handling by kvm unittest w/ and
> >> w/o IPI virtualization. When IPI virtualizatin enabled, it will reduce
> >> 22.21% and 15.98% cycles comsuming in xAPIC mode and x2APIC mode
> >> respectly.
> >>
> >> KMV unittest:vmexit/ipi, 2 vCPU, AP runs without halt to ensure no VM
> >> exit impact on target vCPU.
> >>
> >>                  Cycles of IPI
> >>                  xAPIC mode              x2APIC mode
> >>          test    w/o IPIv  w/ IPIv       w/o IPIv  w/ IPIv
> >>          1       6106      4816          4265      3768
> >>          2       6244      4656          4404      3546
> >>          3       6165      4658          4233      3474
> >>          4       5992      4710          4363      3430
> >>          5       6083      4741          4215      3551
> >>          6       6238      4904          4304      3547
> >>          7       6164      4617          4263      3709
> >>          8       5984      4763          4518      3779
> >>          9       5931      4712          4645      3667
> >>          10      5955      4530          4332      3724
> >>          11      5897      4673          4283      3569
> >>          12      6140      4794          4178      3598
> >>          13      6183      4728          4363      3628
> >>          14      5991      4994          4509      3842
> >>          15      5866      4665          4520      3739
> >>          16      6032      4654          4229      3701
> >>          17      6050      4653          4185      3726
> >>          18      6004      4792          4319      3746
> >>          19      5961      4626          4196      3392
> >>          20      6194      4576          4433      3760
> >>
> >> Average cycles  6059      4713.1        4337.85   3644.8
> >> %Reduction                -22.21%                 -15.98%
> > Commit a9ab13ff6e (KVM: X86: Improve latency for single target IPI
> > fastpath) mentioned that the whole ipi fastpath feature reduces the
> > latency from 4238 to 3293 around 22.3% on SKX server, why your IPIv
> > hardware acceleration is worse than software emulation? In addition,
>
> Actually this performance data was measured on the basis of fastpath
> optimization while cpu runs at base frequency.
>
> As a result, IPI virtualization could have extra 15.98% cost reduction
> over IPI fastpath process in x2apic mode.

I observed that adaptive advance lapic timer and adaptive halt-polling
will influence kvm-unit-tests/vmexit.flat IPI testing score, could you
post the score after disabling these features as commit a9ab13ff6e
(KVM: X86: Improve latency for single target IPI fastpath) mentioned=EF=BC=
=9F
In addition, please post the hackbench(./hackbench -l 1000000) and ipi
microbenchmark scores.

    Wanpeng
