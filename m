Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6006D52EB45
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 13:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347481AbiETL4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 07:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348813AbiETL4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 07:56:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A24F965FD
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 04:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653047760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4IMlyw01tBNJTvtft3R8NXdy760egTdFl+vS1YSMxUk=;
        b=c2hsiG92OzPL+zmffIBFO9A8HQGnKCR4JH/3LDYDZX0DvmH5w4IRiNx5ccvHOKL0fTJjgq
        xtKJ5mso0bwlgb+Uz1LfmKUPt2If9afTO32tRvH9ru4E0TGxgmQackGPhIPapgXcKzFov8
        09O7F6mSPt3FjHrwi41aZDo7DhyaqyY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-Sm7kkeqQM-yXkl_9ykqIlQ-1; Fri, 20 May 2022 07:55:57 -0400
X-MC-Unique: Sm7kkeqQM-yXkl_9ykqIlQ-1
Received: by mail-ej1-f71.google.com with SMTP id s4-20020a170906500400b006feaccb3a0eso827236ejj.11
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 04:55:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4IMlyw01tBNJTvtft3R8NXdy760egTdFl+vS1YSMxUk=;
        b=afESPalOm/S2AL5ArQRBMSXr0n3eNGK8CyiHnAb+OVK3uClglUfix4YSiwCSjA9K6O
         OIY4fob+h+SmG770t/JHdzMeaG7tsgWFyrc6PBFKDzyKT36UkV04sbaJ7jAdqFJW36h+
         /LhaMz+NCdv+ppLvwjrDebaNpXDdTj1gWA3u9+Ii6HNOfpQzCL0V3zuPfd0AE6I6jUn3
         MMHYCZe/JtB7rhTH7XVBnd++EfbTkWm+xpQeZHh0Do1nZBw8SuiQvNkpcO+OcG03V60Y
         SMEAR7JUEmaIh7QyqVBPLtd2fVWItoP1F3jMeZrQHnyCuJ/vv/OIUXhgQOQkUkMnP7kg
         p8FA==
X-Gm-Message-State: AOAM532bKscriPnpBvt6viWYgC11EaHj9J3yCoB6ASh9E3uEBN71BFly
        y0dGT1noe9RfveYRlvUIyMF5RWW0s/D8o8owcUrtJ552LFVePs5SsrAxIubIt45sOWC9Hduce8t
        GzZIm0+nPywKl
X-Received: by 2002:a05:6402:35d4:b0:427:f36b:66dc with SMTP id z20-20020a05640235d400b00427f36b66dcmr10641135edc.77.1653047756286;
        Fri, 20 May 2022 04:55:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/eJ6Iu3s0UhZEmWO+wTmbI84ilygJn45btvxXA7t1f3uYrHaXgyTQhQFKBHmkDBQgsLw5sg==
X-Received: by 2002:a05:6402:35d4:b0:427:f36b:66dc with SMTP id z20-20020a05640235d400b00427f36b66dcmr10641105edc.77.1653047755996;
        Fri, 20 May 2022 04:55:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 17-20020a170906329100b006f3ef214dd2sm3125275ejw.56.2022.05.20.04.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 04:55:55 -0700 (PDT)
Message-ID: <d3ceed31-9dd5-ed7b-92e8-fc3a5fd406fa@redhat.com>
Date:   Fri, 20 May 2022 13:55:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [GIT PULL] KVM/riscv changes for 5.19
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy1DUJa=5YxbV_u0B=NLaTJrW03PbLxegJ2oCWDeWqy=zw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy1DUJa=5YxbV_u0B=NLaTJrW03PbLxegJ2oCWDeWqy=zw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/22 06:48, Anup Patel wrote:
> Hi Paolo,
> 
> We have following KVM RISC-V changes for 5.19:
> 1) Added Sv57x4 support for G-stage page table
> 2) Added range based local HFENCE functions
> 3) Added remote HFENCE functions based on VCPU requests
> 4) Added ISA extension registers in ONE_REG interface
> 5) Updated KVM RISC-V maintainers entry to cover selftests support
> 
> I don't expect any other KVM RISC-V changes for 5.19.
> 
> Please pull.
> 
> Regards,
> Anup
> 
> The following changes since commit 42226c989789d8da4af1de0c31070c96726d990c:
> 
>    Linux 5.18-rc7 (2022-05-15 18:08:58 -0700)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.19-1
> 
> for you to fetch changes up to fed9b26b2501ea0ce41ae3a788bcc498440589c6:
> 
>    MAINTAINERS: Update KVM RISC-V entry to cover selftests support
> (2022-05-20 09:09:23 +0530)
> 
> ----------------------------------------------------------------
> KVM/riscv changes for 5.19
> 
> - Added Sv57x4 support for G-stage page table
> - Added range based local HFENCE functions
> - Added remote HFENCE functions based on VCPU requests
> - Added ISA extension registers in ONE_REG interface
> - Updated KVM RISC-V maintainers entry to cover selftests support
> 
> ----------------------------------------------------------------
> Anup Patel (9):
>        KVM: selftests: riscv: Improve unexpected guest trap handling
>        RISC-V: KVM: Use G-stage name for hypervisor page table
>        RISC-V: KVM: Add Sv57x4 mode support for G-stage
>        RISC-V: KVM: Treat SBI HFENCE calls as NOPs
>        RISC-V: KVM: Introduce range based local HFENCE functions
>        RISC-V: KVM: Reduce KVM_MAX_VCPUS value
>        RISC-V: KVM: Add remote HFENCE functions based on VCPU requests
>        RISC-V: KVM: Cleanup stale TLB entries when host CPU changes
>        MAINTAINERS: Update KVM RISC-V entry to cover selftests support
> 
> Atish Patra (1):
>        RISC-V: KVM: Introduce ISA extension register
> 
> Jiapeng Chong (1):
>        KVM: selftests: riscv: Remove unneeded semicolon
> 
>   MAINTAINERS                                        |   2 +
>   arch/riscv/include/asm/csr.h                       |   1 +
>   arch/riscv/include/asm/kvm_host.h                  | 124 +++++-
>   arch/riscv/include/uapi/asm/kvm.h                  |  20 +
>   arch/riscv/kvm/main.c                              |  11 +-
>   arch/riscv/kvm/mmu.c                               | 264 ++++++------
>   arch/riscv/kvm/tlb.S                               |  74 ----
>   arch/riscv/kvm/tlb.c                               | 461 +++++++++++++++++++++
>   arch/riscv/kvm/vcpu.c                              | 144 ++++++-
>   arch/riscv/kvm/vcpu_exit.c                         |   6 +-
>   arch/riscv/kvm/vcpu_sbi_replace.c                  |  40 +-
>   arch/riscv/kvm/vcpu_sbi_v01.c                      |  35 +-
>   arch/riscv/kvm/vm.c                                |   8 +-
>   arch/riscv/kvm/vmid.c                              |  30 +-
>   .../selftests/kvm/include/riscv/processor.h        |   8 +-
>   tools/testing/selftests/kvm/lib/riscv/processor.c  |  11 +-
>   tools/testing/selftests/kvm/lib/riscv/ucall.c      |  31 +-
>   17 files changed, 965 insertions(+), 305 deletions(-)
>   delete mode 100644 arch/riscv/kvm/tlb.S
>   create mode 100644 arch/riscv/kvm/tlb.c
> 

Pulled, thanks.

Paolo

