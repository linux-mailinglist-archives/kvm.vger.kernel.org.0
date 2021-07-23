Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7893D3477
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 08:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhGWFbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 01:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhGWFba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 01:31:30 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F3FC061575;
        Thu, 22 Jul 2021 23:12:03 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id q6so764070oiw.7;
        Thu, 22 Jul 2021 23:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AZKNDZPJaYefkpMUKBEqneOnIP2BNDuYsn0cDTJRRE0=;
        b=JED08zydxY7bsFY4lnM+AZbZVFIX3Yho6mvopHNofOsMP3cVY/W2Cre3f0GHvrgZUE
         PxdpxVTvd+ejeId7xwiGBX+73F/gc/+rwZcuWNk/XmYRfpI17lbI48VaUCX2wkWZa62Z
         lZhlDbxzTqgVuHTAuOdmqSP9cIsbDW2z9vcwYlD3n4ISAT7NgOvwkSQC4eA491vVzL5R
         LpYGfChkod2f0leP7uvDkv11AiJEMys4K4nSTRMkHe6XpiBkO9THtyWW47HoLqlQssAv
         NZo/UmbepGZ3B+eJzd/FvMMryVD9tzuqttNwT+acYLG93f1nN3TYFcF7tSDefkpxP6fM
         N/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AZKNDZPJaYefkpMUKBEqneOnIP2BNDuYsn0cDTJRRE0=;
        b=jW+QB/7mB05WMVvPH1QD2JS5FYwGDgFcrtff6VuJDIdn5UiCoHIQ5oZNqqhRloAcd/
         tpbk1//vga/V3j7E5yKiJ0XLoT0H3EYJioGlRWx4cyAFCP5dcmSiZPM3rbE1Zdjw5FMx
         Q4Ado5SrdH/i56HCjR0A15we9gD3tmV0/WuHTOyrUEPMInOs3KmuwG6lo4ty55jxSso3
         5WRgCndUyxVgZJ/L5dPsCqefyRqLahsNaOFR6m9xiD+wQriZebtWYcy86OLU22Co6WIH
         Ygy7bs+yAiozFYRvr2xo25vvzERqXaAhjtHi42Yv2ABItGG8+WOQNpZ3W9seIpX86Aik
         Cpaw==
X-Gm-Message-State: AOAM530CzlEqSxC0g+TqB7+as2i5q4KSyZxkxvizzAqLSqRVhul1VRpB
        70wcVdxRgrfeUNNSIsg1ZCaLtXXkapdLsi+kb0Y=
X-Google-Smtp-Source: ABdhPJxcgpkjyb1jD7G3yKubFEG/BUu91rZEanTZL99fRJf9XRT4HlXjbJWs/s3cGBXgeP0HlhJ6nsjncfJ2tThREPs=
X-Received: by 2002:aca:d505:: with SMTP id m5mr5889860oig.5.1627020723344;
 Thu, 22 Jul 2021 23:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210723051626.18364-1-guang.zeng@intel.com>
In-Reply-To: <20210723051626.18364-1-guang.zeng@intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 23 Jul 2021 14:11:52 +0800
Message-ID: <CANRm+CywPSiW=dniYEnUhYnK0NGGnnxV53AdC0goivndn6KR5g@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] IPI virtualization support for VM
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
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 23 Jul 2021 at 13:41, Zeng Guang <guang.zeng@intel.com> wrote:
>
> Current IPI process in guest VM will virtualize the writing to interrupt
> command register(ICR) of the local APIC which will cause VM-exit anyway
> on source vCPU. Frequent VM-exit could induce much overhead accumulated
> if running IPI intensive task.
>
> IPI virtualization as a new VT-x feature targets to eliminate VM-exits
> when issuing IPI on source vCPU. It introduces a new VM-execution
> control - "IPI virtualization"(bit4) in the tertiary processor-based
> VM-exection controls and a new data structure - "PID-pointer table
> address" and "Last PID-pointer index" referenced by the VMCS. When "IPI
> virtualization" is enabled, processor emulateds following kind of writes
> to APIC registers that would send IPIs, moreover without causing VM-exits.
> - Memory-mapped ICR writes
> - MSR-mapped ICR writes
> - SENDUIPI execution
>
> This patch series implement IPI virtualization support in KVM.
>
> Patches 1-4 add tertiary processor-based VM-execution support
> framework.
>
> Patch 5 implement interrupt dispatch support in x2APIC mode with
> APIC-write VM exit. In previous platform, no CPU would produce
> APIC-write VM exit with exit qulification 300H when the "virtual x2APIC
> mode" VM-execution control was 1.
>
> Patch 6 implement IPI virtualization related function including
> feature enabling through tertiary processor-based VM-execution in
> various scenario of VMCS configuration, PID table setup in vCPU creation
> and vCPU block consideration.
>
> Document for IPI virtualization is now available at the latest "Intel
> Architecture Instruction Set Extensions Programming Reference".
>
> Document Link:
> https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
>
> We did experiment to measure average time sending IPI from source vCPU
> to the target vCPU completing the IPI handling by kvm unittest w/ and
> w/o IPI virtualization. When IPI virtualizatin enabled, it will reduce
> 22.21% and 15.98% cycles consuming in xAPIC mode and x2APIC mode
> respectly.
>
> KMV unittest:vmexit/ipi, 2 vCPU, AP was modified to run in idle loop
> instead of halt to ensure no VM exit impact on target vCPU.
>
>                 Cycles of IPI
>                 xAPIC mode              x2APIC mode
>         test    w/o IPIv  w/ IPIv       w/o IPIv  w/ IPIv
>         1       6106      4816          4265      3768
>         2       6244      4656          4404      3546
>         3       6165      4658          4233      3474
>         4       5992      4710          4363      3430
>         5       6083      4741          4215      3551
>         6       6238      4904          4304      3547
>         7       6164      4617          4263      3709
>         8       5984      4763          4518      3779
>         9       5931      4712          4645      3667
>         10      5955      4530          4332      3724
>         11      5897      4673          4283      3569
>         12      6140      4794          4178      3598
>         13      6183      4728          4363      3628
>         14      5991      4994          4509      3842
>         15      5866      4665          4520      3739
>         16      6032      4654          4229      3701
>         17      6050      4653          4185      3726
>         18      6004      4792          4319      3746
>         19      5961      4626          4196      3392
>         20      6194      4576          4433      3760
>
> Average cycles  6059      4713.1        4337.85   3644.8
> %Reduction                -22.21%                 -15.98%
>
> --------------------------------------
> IPI microbenchmark:
> (https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com)
>
> 2 vCPUs, 1:1 pin vCPU to pCPU, guest VM runs with idle=poll, x2APIC mode

Improve the performance for unicast ipi is as expected, however, I
wonder whether the broadcast performance is worse than PV
IPIs/Thomas's IPI shorthands(IPI shorthands are supported by upstream
linux apic/x2apic driver). The hardware acceleration is not always
outstanding on AMD(https://lore.kernel.org/kvm/CANRm+Cx597FNRUCyVz1D=B6Vs2GX3Sw57X7Muk+yMpi_hb+v1w@mail.gmail.com/),
how about your Intel guys? Please try a big VM at least 96 vCPUs as
below or more bigger.

>
> Result with IPIv enabled:
>
> Dry-run:                         0,             272798 ns
> Self-IPI:                  5094123,           11114037 ns
> Normal IPI:              131697087,          173321200 ns
> Broadcast IPI:                   0,          155649075 ns
> Broadcast lock:                  0,          161518031 ns
>
> Result with IPIv disabled:
>
> Dry-run:                         0,             272766 ns
> Self-IPI:                  5091788,           11123699 ns
> Normal IPI:              145215772,          174558920 ns
> Broadcast IPI:                   0,          175785384 ns
> Broadcast lock:                  0,          149076195 ns
>
>
> As IPIv can benefit unicast IPI to other CPU, Noraml IPI test case gain
> about 9.73% time saving on average out of 15 test runs when IPIv is
> enabled.
>
>                 w/o IPIv                w/ IPIv
> Normal IPI:     145944306.6 ns          131742993.1 ns
> %Reduction                              -9.73%
>
> --------------------------------------
> hackbench:
>
> 8 vCPUs, guest VM free run, x2APIC mode
> ./hackbench -p -l 100000
>
>                 w/o IPIv        w/ IPIv
> Time:           91.887          74.605
> %Reduction:                     -18.808%
>
> 96 vCPUs, guest VM free run, x2APIC mode
> ./hackbench -p -l 1000000
>
>                 w/o IPIv        w/ IPIv
> Time:           287.504         235.185
> %Reduction:                     -18.198%

Good to know this.

    Wanpeng
