Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C752B3CB540
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 11:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhGPJ2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 05:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbhGPJ2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 05:28:16 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F119BC06175F;
        Fri, 16 Jul 2021 02:25:19 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id u15so10186692oiw.3;
        Fri, 16 Jul 2021 02:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M3L6N/isUtLMNrxa1XCwVdqbDJYk3wmwipYc7UHIg30=;
        b=r4+zxL8Ly1S8l0ZTRBbHhjuykg+E/jFwukwFh3ZLskQKJmd22UtiHt9e8Vrc4B/r1E
         StnSypkfyxFZx/dILMKWn0jGTvuzX5X/Vf8Np9xiQsE0TiMRPZFjQisx7QQXlZL9Duk/
         KXwqG2D4cf5WMWD+8ks9BTvFkTqg0X34U5ZTbw8Pmmky5S+tRtvNJJKJN9+yatdb5s0i
         4nnTnwrvJKghJ4z3ARRSdRv2gp5YKVngkA5lzcrK65yF6Zn1sl+8nT+i+0RdxoKKRRKQ
         JCIK93oHSE7ncCgx6BlwZp09fjFbXlB8kcmD0zPR8fQOKuxkxHIZg0VXPvJKTCVY8TV+
         9MDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M3L6N/isUtLMNrxa1XCwVdqbDJYk3wmwipYc7UHIg30=;
        b=XoscfH+ptbr5QKOb/JwR4JDr/VM7Yu4Pp0qiEAk+TIfaYVjtKnQbwsF01JIw9cB7dU
         YrKIeaotCRZiJPK+FQcswO2CF1nCN9sU0CFoo5UiKCQeyBEzIX7sTaPJmZfZb5SSudyq
         a4BK4VtRu7x/sAGG7zGgKCsw4VeUASJ6QxRrqTQ0SV/9IrfAHD+p+hvN4jXSMhgou/47
         z3s9Etw0GrdvVteds50YeOb3Z9rjYs/CpkIZC3vcIkRPligckX3c1Zo5S8V9jGz9g35j
         GHSTcP23gFlDBPlN9WKPREGsnVwxkhwtLzEPpRYH9JBO522OQvr2WRJj8uPZc3QWYimA
         Y/uA==
X-Gm-Message-State: AOAM531v5+y2yLT5F4Q5coudE1Njy9YmtFU9TOT7jN5b6vR8RS+CrVHR
        gighozRKBDIo+inkHl2oyFK7WpLNBPQeTSZ6ee4=
X-Google-Smtp-Source: ABdhPJxHyb8ANuJhmrB3GrlnpY3IjWqx4f3k/5MpMwr2A8uB+jRVB/RRadAnxqsI07492YshjiCdsR22hzW+eMENJfA=
X-Received: by 2002:aca:1017:: with SMTP id 23mr1121001oiq.141.1626427519435;
 Fri, 16 Jul 2021 02:25:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210716064808.14757-1-guang.zeng@intel.com>
In-Reply-To: <20210716064808.14757-1-guang.zeng@intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 16 Jul 2021 17:25:08 +0800
Message-ID: <CANRm+Cy=ncU-H7duei5q+CG+pm-kXvG8N8CiUQavQ3OEpDj9eg@mail.gmail.com>
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
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Jul 2021 at 15:14, Zeng Guang <guang.zeng@intel.com> wrote:
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
> Patches 1-3 add tertiary processor-based VM-execution support
> framework.
>
> Patch 4 implement interrupt dispatch support in x2APIC mode with
> APIC-write VM exit. In previous platform, no CPU would produce
> APIC-write VM exit with exit qulification 300H when the "virtual x2APIC
> mode" VM-execution control was 1.
>
> Patch 5 implement IPI virtualization related function including
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
> 22.21% and 15.98% cycles comsuming in xAPIC mode and x2APIC mode
> respectly.
>
> KMV unittest:vmexit/ipi, 2 vCPU, AP runs without halt to ensure no VM
> exit impact on target vCPU.
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

Commit a9ab13ff6e (KVM: X86: Improve latency for single target IPI
fastpath) mentioned that the whole ipi fastpath feature reduces the
latency from 4238 to 3293 around 22.3% on SKX server, why your IPIv
hardware acceleration is worse than software emulation? In addition,
please post the IPI microbenchmark score w/ and w/o the
patchset.(https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com),
I found that the hardware acceleration is not always outstanding.
https://lore.kernel.org/kvm/CANRm+Cx597FNRUCyVz1D=B6Vs2GX3Sw57X7Muk+yMpi_hb+v1w@mail.gmail.com

    Wanpeng
