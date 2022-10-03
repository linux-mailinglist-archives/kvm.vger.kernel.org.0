Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38745F365B
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJCTe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiJCTe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:34:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28904474FF
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664825665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BHdWi/paqmDBqfitK3aVupNcHyNAIYCtrWUImZTD18E=;
        b=aAoQt+sqbJzlwnfnwcubSnd0i2K4mhAPP/mht51iP/yrty6U859MwwP2sYtp/EZAJvHML1
        /aM2J1HinZcPh3imlueQEkGWtnCUQ+Zilii9ECTmxrpBZKpSl1Vh5cLLHNPqb2Po85R4xa
        H9SfFhWbNSapdHgweX+9KQHuljhmEno=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-62-5PBlHfNHPxmdoyCorIViuQ-1; Mon, 03 Oct 2022 15:34:24 -0400
X-MC-Unique: 5PBlHfNHPxmdoyCorIViuQ-1
Received: by mail-ua1-f72.google.com with SMTP id z10-20020ab05bca000000b003d7ca721fe7so2298109uae.23
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 12:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=BHdWi/paqmDBqfitK3aVupNcHyNAIYCtrWUImZTD18E=;
        b=AQ6N1Cczjh61uRkCPdZE/Pbl1tvn9YyLADhAF4hgigW3IAvSwck2/sVo7FqtfyQsmY
         BuAYdSl5+lms1naCFfcmn3m7yEzv5byzo2jNMZrdAdaNmD8TouATafmEJ6rhPtI0Jnh5
         kOIpxi+JDdhhP1llnYQZxhe8dMBxhVOMm/ztQpkFAI1hWDj+cEskejMLu0h1tz7gg5JH
         YoBULuZktiupbHrD02bBIHyWjheE+654SnN9s/v/qP2HoOrM1BqXgWwX6ZBM0Rx/LFSH
         NoGHuOcwZCTjPW829k1oxI3/ujPqeX+ZKSulxce1VYnvRqf0s90ICiNCMSe39INuqqtN
         oUkQ==
X-Gm-Message-State: ACrzQf2riKsLrJk1c5MXAD8wMBE+oS6MtPneIMfTyNCtkvmv8zVF/cd6
        iih0CZYhiPeajeoA05SFpuRwlT7jiFgnUSg01n/0BRSgzynxbaF4AQcYjlhWaLGCxAF4BcDVEpc
        eFaMKpOkUJHzxulbrxs9njmz3gntu
X-Received: by 2002:a67:ac4c:0:b0:3a4:b881:4490 with SMTP id n12-20020a67ac4c000000b003a4b8814490mr10400721vsh.42.1664825663425;
        Mon, 03 Oct 2022 12:34:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5afW8fzwWcvUW0EWcnh/TOcV2BXPkjmI6SJlLvWnhUGyqDx+Vr03c9bkyIxGVENeT92rJRXvPExkNB5noBgvE=
X-Received: by 2002:a67:ac4c:0:b0:3a4:b881:4490 with SMTP id
 n12-20020a67ac4c000000b003a4b8814490mr10400710vsh.42.1664825663189; Mon, 03
 Oct 2022 12:34:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy134Ve1mbeK+TNRx-pWpQ=nVzNLptDcUyPaDU4v18Qyaw@mail.gmail.com>
In-Reply-To: <CAAhSdy134Ve1mbeK+TNRx-pWpQ=nVzNLptDcUyPaDU4v18Qyaw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 3 Oct 2022 21:34:12 +0200
Message-ID: <CABgObfZ08HQMqPVGRa8_viSzWKWizQGU3K_9u20FBUToEjQR5A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.1
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pulled, thanks!

On Sun, Oct 2, 2022 at 7:46 AM Anup Patel <anup@brainfault.org> wrote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.1:
> 1) Improved instruction encoding infrastructure for
>     instructions not yet supported by binutils
> 2) Svinval support for both KVM Host and KVM Guest
> 3) Zihintpause support for KVM Guest
> 4) Zicbom support for KVM Guest
> 5) Record number of signal exits as a VCPU stat
> 6) Use generic guest entry infrastructure
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit f76349cf41451c5c42a99f18a9163377e4b364ff:
>
>   Linux 6.0-rc7 (2022-09-25 14:01:02 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.1-1
>
> for you to fetch changes up to b60ca69715fcc39a5f4bdd56ca2ea691b7358455:
>
>   riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK (2022-10-02 10:19:31 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.1
>
> - Improved instruction encoding infrastructure for
>   instructions not yet supported by binutils
> - Svinval support for both KVM Host and KVM Guest
> - Zihintpause support for KVM Guest
> - Zicbom support for KVM Guest
> - Record number of signal exits as a VCPU stat
> - Use generic guest entry infrastructure
>
> ----------------------------------------------------------------
> Andrew Jones (7):
>       riscv: Add X register names to gpr-nums
>       riscv: Introduce support for defining instructions
>       riscv: KVM: Apply insn-def to hfence encodings
>       riscv: KVM: Apply insn-def to hlv encodings
>       RISC-V: KVM: Make ISA ext mappings explicit
>       RISC-V: KVM: Provide UAPI for Zicbom block size
>       RISC-V: KVM: Expose Zicbom to the guest
>
> Anup Patel (3):
>       RISC-V: KVM: Change the SBI specification version to v1.0
>       RISC-V: KVM: Use Svinval for local TLB maintenance when available
>       RISC-V: KVM: Allow Guest use Svinval extension
>
> Jisheng Zhang (3):
>       RISC-V: KVM: Record number of signal exits as a vCPU stat
>       RISC-V: KVM: Use generic guest entry infrastructure
>       riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK
>
> Mayuresh Chitale (2):
>       RISC-V: Probe Svinval extension form ISA string
>       RISC-V: KVM: Allow Guest use Zihintpause extension
>
> Xiu Jianfeng (1):
>       RISC-V: KVM: add __init annotation to riscv_kvm_init()
>
>  arch/riscv/Kconfig                    |   4 +
>  arch/riscv/include/asm/gpr-num.h      |   8 ++
>  arch/riscv/include/asm/hwcap.h        |   4 +
>  arch/riscv/include/asm/insn-def.h     | 137 ++++++++++++++++++++++++++++++
>  arch/riscv/include/asm/kvm_host.h     |   1 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   4 +-
>  arch/riscv/include/uapi/asm/kvm.h     |   4 +
>  arch/riscv/kernel/cpu.c               |   1 +
>  arch/riscv/kernel/cpufeature.c        |   1 +
>  arch/riscv/kvm/Kconfig                |   1 +
>  arch/riscv/kvm/main.c                 |   2 +-
>  arch/riscv/kvm/tlb.c                  | 155 +++++++++++-----------------------
>  arch/riscv/kvm/vcpu.c                 |  60 ++++++++-----
>  arch/riscv/kvm/vcpu_exit.c            |  39 ++-------
>  arch/riscv/mm/dma-noncoherent.c       |   2 +
>  15 files changed, 260 insertions(+), 163 deletions(-)
>  create mode 100644 arch/riscv/include/asm/insn-def.h
>

On Sun, Oct 2, 2022 at 7:46 AM Anup Patel <anup@brainfault.org> wrote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.1:
> 1) Improved instruction encoding infrastructure for
>     instructions not yet supported by binutils
> 2) Svinval support for both KVM Host and KVM Guest
> 3) Zihintpause support for KVM Guest
> 4) Zicbom support for KVM Guest
> 5) Record number of signal exits as a VCPU stat
> 6) Use generic guest entry infrastructure
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit f76349cf41451c5c42a99f18a9163377e4b364ff:
>
>   Linux 6.0-rc7 (2022-09-25 14:01:02 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.1-1
>
> for you to fetch changes up to b60ca69715fcc39a5f4bdd56ca2ea691b7358455:
>
>   riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK (2022-10-02 10:19:31 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.1
>
> - Improved instruction encoding infrastructure for
>   instructions not yet supported by binutils
> - Svinval support for both KVM Host and KVM Guest
> - Zihintpause support for KVM Guest
> - Zicbom support for KVM Guest
> - Record number of signal exits as a VCPU stat
> - Use generic guest entry infrastructure
>
> ----------------------------------------------------------------
> Andrew Jones (7):
>       riscv: Add X register names to gpr-nums
>       riscv: Introduce support for defining instructions
>       riscv: KVM: Apply insn-def to hfence encodings
>       riscv: KVM: Apply insn-def to hlv encodings
>       RISC-V: KVM: Make ISA ext mappings explicit
>       RISC-V: KVM: Provide UAPI for Zicbom block size
>       RISC-V: KVM: Expose Zicbom to the guest
>
> Anup Patel (3):
>       RISC-V: KVM: Change the SBI specification version to v1.0
>       RISC-V: KVM: Use Svinval for local TLB maintenance when available
>       RISC-V: KVM: Allow Guest use Svinval extension
>
> Jisheng Zhang (3):
>       RISC-V: KVM: Record number of signal exits as a vCPU stat
>       RISC-V: KVM: Use generic guest entry infrastructure
>       riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK
>
> Mayuresh Chitale (2):
>       RISC-V: Probe Svinval extension form ISA string
>       RISC-V: KVM: Allow Guest use Zihintpause extension
>
> Xiu Jianfeng (1):
>       RISC-V: KVM: add __init annotation to riscv_kvm_init()
>
>  arch/riscv/Kconfig                    |   4 +
>  arch/riscv/include/asm/gpr-num.h      |   8 ++
>  arch/riscv/include/asm/hwcap.h        |   4 +
>  arch/riscv/include/asm/insn-def.h     | 137 ++++++++++++++++++++++++++++++
>  arch/riscv/include/asm/kvm_host.h     |   1 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   4 +-
>  arch/riscv/include/uapi/asm/kvm.h     |   4 +
>  arch/riscv/kernel/cpu.c               |   1 +
>  arch/riscv/kernel/cpufeature.c        |   1 +
>  arch/riscv/kvm/Kconfig                |   1 +
>  arch/riscv/kvm/main.c                 |   2 +-
>  arch/riscv/kvm/tlb.c                  | 155 +++++++++++-----------------------
>  arch/riscv/kvm/vcpu.c                 |  60 ++++++++-----
>  arch/riscv/kvm/vcpu_exit.c            |  39 ++-------
>  arch/riscv/mm/dma-noncoherent.c       |   2 +
>  15 files changed, 260 insertions(+), 163 deletions(-)
>  create mode 100644 arch/riscv/include/asm/insn-def.h
>

