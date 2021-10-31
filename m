Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5BA440D71
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 08:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhJaHbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 03:31:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhJaHbO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 03:31:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635665323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eo1MSr4ckckQxvAK3VBPPPuV6lxn6t3zOtFTXVQ2H5w=;
        b=UTlBJoCX3HtHvscqxpFFoFB5Tx57lJJ2yogZeXXokFTrpaUt+oWqtHoAW7aOseYKmQ/YkY
        rBP1a3hBJdsGvgx/bBPbWsWo4wDIxo1lX3nh04Ymchw64CrLBiPbZL0Ni+SAL2Q6xDmn8s
        eKT7cB8YkfTtChIK3JrmG+WBGxGHf94=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-dD2ByfbPPA2vO0aSdr3hNA-1; Sun, 31 Oct 2021 03:28:41 -0400
X-MC-Unique: dD2ByfbPPA2vO0aSdr3hNA-1
Received: by mail-ed1-f72.google.com with SMTP id x13-20020a05640226cd00b003dd4720703bso12862357edd.8
        for <kvm@vger.kernel.org>; Sun, 31 Oct 2021 00:28:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eo1MSr4ckckQxvAK3VBPPPuV6lxn6t3zOtFTXVQ2H5w=;
        b=h1yZZcxnRdQB7enc7CoEnwA6HxBc45yBc2H4v0RVUm1hitcUFZkBWJSFnnVOL5N2OS
         oJZisPR4EEBnMCe/MMZiFFLHW6KKe87HvfsxOmTinCQhpOSlc2/nvQNB3eUkjr1JzSdZ
         xX2DEsqcg+2xwRe/fJEWJ/UyjLXOutBnXCzKzanULhLdmrb/Ct03bOP1eeSBdPlTj3hz
         wvMDRLP2gjP+8zDSx4EsZOxdLTfoZQ45P5bkvNorq4d/gEsGYs/v8szymr64mdRtv/2V
         aPOmMfDyrHj0bXYrzNRsyJS3ODpz+XYaRDBt7tCVakFcoDRUllECj5NCSM1218ktGZE3
         GKFQ==
X-Gm-Message-State: AOAM531vTmZilY+vY6ONhTbxpeuhUbw0M4tderFkkJCREuH1uiya1puV
        RJ9HM4fmu4g4AifvB6Sm4QMPR8OOChcRDADEgsyBW5yn+BPbFAgUgYBkcny5yTRPa00wPIkkGuB
        HpDZdK7iyo4nb
X-Received: by 2002:a17:907:9694:: with SMTP id hd20mr26513516ejc.508.1635665320315;
        Sun, 31 Oct 2021 00:28:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykYMQYRlPyS4iYy0Y40u1793ZYYUoHA4NO3sFjyivxOWVVZQhxAoUhHQEDa6iE4TEvaNKJZw==
X-Received: by 2002:a17:907:9694:: with SMTP id hd20mr26513496ejc.508.1635665320077;
        Sun, 31 Oct 2021 00:28:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id qf38sm5457438ejc.116.2021.10.31.00.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 00:28:39 -0700 (PDT)
Message-ID: <d6c56f03-1da7-1ebf-1d2e-0ec1aa0b241c@redhat.com>
Date:   Sun, 31 Oct 2021 08:28:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v1 0/7] x86_64 UEFI set up process refactor
 and scripts fixes
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20211031055634.894263-1-zxwang42@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211031055634.894263-1-zxwang42@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/10/21 06:56, Zixuan Wang wrote:
> Hello,
> 
> This patch series refactors the x86_64 UEFI set up process and fixes the
> `run-tests.sh` script to run under UEFI. The patches are organized as
> three parts.
> 
> The first part (patches 1-2) refactors the x86_64 UEFI set up process.
> The previous UEFI setup calls arch-specific setup functions twice and
> generates arch-specific data structure. As Andrew suggested [1], we
> refactor this process to make only one call to the arch-specific
> function and generate arch-neutral data structures. This simplifies the
> set up process and makes it easier to develop UEFI support for other
> architectures.
> 
> The second part (patch 3) converts several x86 test cases to
> Position-Independent Code (PIC) to run under UEFI. This patch is ported
> from the initial UEFI support patchset [2] with fixes to the 32-bit
> compilation.
> 
> The third part (patches 4-7) fixes the UEFI runner scripts. Patch 4 sets
> UEFI OVMF image as readonly. Patch 5 fixes test cases' return code under
> UEFI, enabling Patch 6-7 to fix the `run-tests.sh` script under UEFI.
> 
> This patch set is based on the `uefi` branch.

Thank you, for patches 1-6 I have squashed the patches when applicable 
(1, 4, 5, 6) and queued the others (2 and 3).

I did not queue patch 7 yet, it seems okay but I want to understand 
better the changes it needs in the harness and what is missing.  I'll 
take a look during the week.

Paolo

> Best regards,
> Zixuan Wang and Marc Orr
> 
> [1] https://lore.kernel.org/kvm/20211005060549.clar5nakynz2zecl@gator.home/
> [2] https://lore.kernel.org/kvm/20211004204931.1537823-1-zxwang42@gmail.com/
> 
> Marc Orr (2):
>    scripts: Generalize EFI check
>    x86 UEFI: Make run_tests.sh (mostly) work under UEFI
> 
> Zixuan Wang (5):
>    x86 UEFI: Remove mixed_mode
>    x86 UEFI: Refactor set up process
>    x86 UEFI: Convert x86 test cases to PIC
>    x86 UEFI: Set UEFI OVMF as readonly
>    x86 UEFI: Exit QEMU with return code
> 
>   lib/efi.c            |  54 ++++++--
>   lib/efi.h            |  19 ++-
>   lib/linux/efi.h      | 317 ++++++++++++++-----------------------------
>   lib/x86/acpi.c       |  36 +++--
>   lib/x86/acpi.h       |   5 +-
>   lib/x86/asm/setup.h  |  16 +--
>   lib/x86/setup.c      | 153 ++++++++++-----------
>   lib/x86/usermode.c   |   3 +-
>   scripts/common.bash  |   9 +-
>   scripts/runtime.bash |  15 +-
>   x86/Makefile.common  |  10 +-
>   x86/Makefile.x86_64  |   7 +-
>   x86/access.c         |   9 +-
>   x86/cet.c            |   8 +-
>   x86/efi/run          |  27 +++-
>   x86/emulator.c       |   5 +-
>   x86/eventinj.c       |   8 ++
>   x86/run              |   6 +-
>   x86/smap.c           |  13 +-
>   x86/umip.c           |  26 +++-
>   20 files changed, 360 insertions(+), 386 deletions(-)
> 

