Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B854D43E311
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 16:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhJ1OKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 10:10:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230354AbhJ1OKI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 10:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635430061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w/6u/2V3kbwOw+vCIQ7D9V9KhEUDROrBvfNcLoT9zUQ=;
        b=UTsa6i+wGl7hbT5TLvHPl+zcKKTc+NS1wd+63cInIpoxNn9IoC6uELtsDj5F4yS1quD0xA
        EOCDqHtxy1BHDQqd4d6ZoqUkIoeagcHr58jbyxx5kkTGR2HQquX94di3W1BXnQQdKJYiaV
        JYOpJ6lHCMhJTW60jA/A13vaVrnIeWs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-nGG39ugoOeSym1pNoXk2jA-1; Thu, 28 Oct 2021 10:07:39 -0400
X-MC-Unique: nGG39ugoOeSym1pNoXk2jA-1
Received: by mail-ed1-f71.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so5684517edj.21
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 07:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w/6u/2V3kbwOw+vCIQ7D9V9KhEUDROrBvfNcLoT9zUQ=;
        b=OORK+RQ1A0aUZuXL74uZHmgJV+WpxD5x+qcyKzBQgpR0sP1M3xXGfrWtm0E18F5qmf
         Lfywb7uxgVyaCmlqMEIFLjNF2fmveZ4ej1x/zHFgTXZfwB2+ZHkHKmWsmTDR/vriV8Gu
         VXR6FIqR2ets3ZihZk5+YbkL0+AWqg4LZUkP3VBumle4TvZEj8SzMP5Ch2Ok/woiwf6L
         n8fx8GsCHB0e8vJfiavt4FjA/Bi2T3fybFqEVcT44MXvs1Wbn9NCZLpCEE+q3mrAG0/w
         AHX1ta+tvucqc/W55HWhnHe8Y6hchY3cWbsGR1FB1R19QxrUiIINdpOXDjqFY8H6kM1H
         puoQ==
X-Gm-Message-State: AOAM532SLKQwhBKhy0LQRw6BzuyZdGpciz74a+RHl1Uemv1rzqwz9Ria
        hWnGsoNFDqzLNV5UNsZ2DY5t1IZc7bqos+ygSf7fa7ynuz8M3QftDsvRP3Q5G9UkavW0+2O6qha
        7YRrEylMnQGhS
X-Received: by 2002:a17:906:7b42:: with SMTP id n2mr5716172ejo.428.1635430058054;
        Thu, 28 Oct 2021 07:07:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5XiquuYAH7SkWh2/xFy/qGlGMMv5yBFfuta79BJff+F3uPv7LPQF5rW36lriFN8dBTGu76g==
X-Received: by 2002:a17:906:7b42:: with SMTP id n2mr5716144ejo.428.1635430057860;
        Thu, 28 Oct 2021 07:07:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gt36sm1448349ejc.13.2021.10.28.07.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 07:07:37 -0700 (PDT)
Message-ID: <62fe1c8e-abe0-5de9-5c00-3549faae1dba@redhat.com>
Date:   Thu, 28 Oct 2021 16:07:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/3] RISC-V: KVM: Few assorted changes
Content-Language: en-US
To:     Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20211026170136.2147619-1-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211026170136.2147619-1-anup.patel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/10/21 19:01, Anup Patel wrote:
> I had a few assorted KVM RISC-V changes which I wanted to sent after
> KVM RISC-V was merged hence this series.
> 
> These patches can also be found in riscv_kvm_assorted_v1 branch at:
> https://github.com/avpatel/linux.git
> 
> Anup Patel (3):
>    RISC-V: Enable KVM in RV64 and RV32 defconfigs as a module
>    RISC-V: KVM: Factor-out FP virtualization into separate sources
>    RISC-V: KVM: Fix GPA passed to __kvm_riscv_hfence_gvma_xyz() functions
> 
>   arch/riscv/configs/defconfig         |  15 ++-
>   arch/riscv/configs/rv32_defconfig    |   8 +-
>   arch/riscv/include/asm/kvm_host.h    |  10 +-
>   arch/riscv/include/asm/kvm_vcpu_fp.h |  59 +++++++++
>   arch/riscv/kvm/Makefile              |   1 +
>   arch/riscv/kvm/tlb.S                 |   4 +-
>   arch/riscv/kvm/vcpu.c                | 172 ---------------------------
>   arch/riscv/kvm/vcpu_fp.c             | 167 ++++++++++++++++++++++++++
>   8 files changed, 244 insertions(+), 192 deletions(-)
>   create mode 100644 arch/riscv/include/asm/kvm_vcpu_fp.h
>   create mode 100644 arch/riscv/kvm/vcpu_fp.c
> 

Queued 2+3, thanks.

Paolo

