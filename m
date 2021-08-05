Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80CB3E19E5
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbhHERDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbhHERDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 13:03:33 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6328C061765
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 10:03:17 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id d10-20020a9d4f0a0000b02904f51c5004e3so1455955otl.9
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 10:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/9Z4KZKQefdFhx9Q9Hrx33PI4/YqXnMAcNgzJO25Txg=;
        b=YGbuXjmMg4Ot8y+Uu320G8DWukcg2U2q0xsnV/iiM0Pig5aasyOv+8XDByFH4yA3Ez
         OjHRFRmpC+Jo6SsWZxjhQkhOuFIjC1WrkCOaVcnJFJAl1l1di67uOTiPOlrs3LQNT+JJ
         hwJPnMMpSnLKgUQDFMD4Y1E626LWnLlTVImyyfom10h+tlwC2n+LoBKY9a2lWnkp1TMS
         SYMDj+fO/1wWZlYIj/2cJJyJwNMCgdCyR4z0I78EAtWA99WtkQt9myeXpW6zIjiij9yw
         oHfw0H3Unq2Df5sDL1hcs0PlnAky9aN4CH2a4bPVA0Y4bdCrRAGLD88SU6BCHd+GXg+s
         g8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/9Z4KZKQefdFhx9Q9Hrx33PI4/YqXnMAcNgzJO25Txg=;
        b=O2EpqoKfkTLUP+bjaEyBLw7zxgUnY6WV8ZihZx7bi5MMiGcSSRz2i0g8tG0JipWwJu
         sdG5BtxNukJurjEmA+WmiXQRkAcltVwDBqSp+QHClLgcy4mrHHsRpEZ3O88WJ/+t7HMh
         sUxRptZ6WFi/lkovSghyvIO1sTP7LKi2LxVAROUViTkjyb0f8q05L+5XzJIxWr6X4Ed9
         y22IFATveF7mkAHRnWhqUAO5W/FMGF0uWAhtQqnYgYHzjDUf87x1vD7ClHgeXLwhYHYs
         VU1HVX/5I39sUmgLURRM0DyuZe8u9lLGN2zL7DKb3vKjg9YdglO2R8VHCXeBE7clbaas
         PUTA==
X-Gm-Message-State: AOAM531cABwK14qQXxo+l7Tnx6Al7+CWvJn1BIv10SqnQhOgpP/Waenc
        qY/uComhoYzrKFF9SWZVRze0G8+rN/KVOGzwh86WiQ==
X-Google-Smtp-Source: ABdhPJxl+W48pedWtycWkTFa1VlGGCuA5hVug0zLZnwPD0R291fyjNJPimFYfhrdXRCoRwPUyGRa0vQ9QtvP8uRTifo=
X-Received: by 2002:a05:6830:40c2:: with SMTP id h2mr4501463otu.56.1628182996864;
 Thu, 05 Aug 2021 10:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210805151317.19054-1-guang.zeng@intel.com>
In-Reply-To: <20210805151317.19054-1-guang.zeng@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Aug 2021 10:03:05 -0700
Message-ID: <CALMp9eQ=W0XFstXkCWQNziu_QmWf4V2neNw3kn6imMThLc+SGw@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] IPI virtualization support for VM
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 5, 2021 at 8:38 AM Zeng Guang <guang.zeng@intel.com> wrote:
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
VM-execution
> address" and "Last PID-pointer index" referenced by the VMCS. When "IPI
> virtualization" is enabled, processor emulateds following kind of writes
emulates
> to APIC registers that would send IPIs, moreover without causing VM-exits.
> - Memory-mapped ICR writes
> - MSR-mapped ICR writes
> - SENDUIPI execution
>
> This patch series implement IPI virtualization support in KVM.
implements
>
> Patches 1-4 add tertiary processor-based VM-execution support
> framework.
>
> Patch 5 implement interrupt dispatch support in x2APIC mode with
implements
> APIC-write VM exit. In previous platform, no CPU would produce
> APIC-write VM exit with exit qulification 300H when the "virtual x2APIC
qualification
> mode" VM-execution control was 1.
>
> Patch 6 implement IPI virtualization related function including
> feature enabling through tertiary processor-based VM-execution in
> various scenario of VMCS configuration, PID table setup in vCPU creation
scenarios
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
virtualization
> 22.21% and 15.98% cycles consuming in xAPIC mode and x2APIC mode
> respectly.
respectively
>
> KMV unittest:vmexit/ipi, 2 vCPU, AP was modified to run in idle loop
KVM
> instead of halt to ensure no VM exit impact on target vCPU.
Are you going to post the kvm-init-test changes?
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
For dedicated CPUs, we would just disable the MONITOR/MWAIT intercepts
and expose MONITOR/MWAIT to the guest. We would not recommend that
anyone use idle=poll.
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
Normal
> about 9.73% time saving on average out of 15 test runs when IPIv is
> enabled.
Can you share the CDFs?
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
>
> --------------------------------------
>
> v2 -> v3:
> 1. Misc change on tertiary execution control
>    definition and capability setup
> 2. Alternative to get tertiary execution
>    control configuration
>
> v1 -> v2:
> 1. Refine the IPIv enabling logic for VM.
>    Remove ipiv_active definition per vCPU.
>
> Gao Chao (1):
>   KVM: VMX: enable IPI virtualization
>
> Robert Hoo (4):
>   x86/feat_ctl: Add new VMX feature, Tertiary VM-Execution control
>   KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit
>     variation
>   KVM: VMX: Detect Tertiary VM-Execution control when setup VMCS config
>   KVM: VMX: dump_vmcs() reports tertiary_exec_control field as well
>
> Zeng Guang (1):
>   KVM: x86: Support interrupt dispatch in x2APIC mode with APIC-write VM
>     exit
>
>  arch/x86/include/asm/msr-index.h   |   1 +
>  arch/x86/include/asm/vmx.h         |  11 +++
>  arch/x86/include/asm/vmxfeatures.h |   5 +-
>  arch/x86/kernel/cpu/feat_ctl.c     |  11 ++-
>  arch/x86/kvm/lapic.c               |   9 ++-
>  arch/x86/kvm/vmx/capabilities.h    |  14 ++++
>  arch/x86/kvm/vmx/evmcs.c           |   2 +
>  arch/x86/kvm/vmx/evmcs.h           |   1 +
>  arch/x86/kvm/vmx/posted_intr.c     |  22 ++++--
>  arch/x86/kvm/vmx/vmcs.h            |   1 +
>  arch/x86/kvm/vmx/vmx.c             | 114 +++++++++++++++++++++++++++--
>  arch/x86/kvm/vmx/vmx.h             |  27 ++++---
>  12 files changed, 193 insertions(+), 25 deletions(-)
>
> --
> 2.25.1
>
