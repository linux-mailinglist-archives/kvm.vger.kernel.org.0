Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540D94A61ED
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 18:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbiBARJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 12:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiBARJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 12:09:51 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD595C061714;
        Tue,  1 Feb 2022 09:09:50 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id q63so17699735pja.1;
        Tue, 01 Feb 2022 09:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PUIgelpXEQevWyX1W8jBsBa/dCPezZfxgXScg7BVU5c=;
        b=SW54mIhtH5QKZwMa5XF99tt04pvq6dTodAAzJOC/fyaSsk3YbovTPXlN9dJtQRy9RV
         sZ5Dr2tD8bdIVEhWaqhIYeHFefl4pgIq29m2gZi8tpzDap4fJXTdR3kIIi9/v+aYemK7
         NBsYzn2I5t8ouHEH4apgnJHW2iZ5yr/UbkcAhqdSVDWJW6R9FmeJJWj9nc4+BDqoqw7K
         Tpk2sYjpqGYmk+u2ZqauQdVk0zErJXuHJDqCphJZJ+T9yXMODdkf4BGotlaiakIQxOy0
         t25O1aVH9BsUDt+a2ggdR+VkgUv2zOMBHz7WI2miDkM4USIWtb8TTbHAVKfcAvaWPXwj
         2fBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PUIgelpXEQevWyX1W8jBsBa/dCPezZfxgXScg7BVU5c=;
        b=Vopuoq1bZ8J/AYquUtebk1M0niGaCf2BTC09RVNTpby6WFxn+h2IzsmkQ7eLnJ6bkN
         niqX//bfUQEMlK/cIP2lN14NHB4e1DtJDXnGgm8S5Alrg4xiUEe+ewucWrXHrYctQUNh
         nlDsl8hfYqPs4WHzxGzrp9eOL3yq2UhJUCEmARingKXNZEGz65oiCcMb1LAQRyjcfA8S
         h7BmW9lf4l6Jl4SwFFinnrZECST9owAWLgGHL6vxEFloQEd5V2AVyMdedpDjCgeYpFPX
         BmLrZvtJGhRnnzM0DWIyfJDQ2zlE5/Q/6Yy0nPFHdbp7gRJ4FHp1OJ5QobKjCimmaXkh
         Ng0w==
X-Gm-Message-State: AOAM532Y6eM/MNSmjnN0dFn1xqjVKmEClWER3GXFI8nPxWbGGVWsncgZ
        cruexvC/pi4z6HZbi+ptgfs=
X-Google-Smtp-Source: ABdhPJz5yB07Ix5o19k8F+dU8Px3ktIP0ST5YMwenoAWVaxtH3aTzk6TAg04YPusVJsGsVMBn8uNyQ==
X-Received: by 2002:a17:902:e812:: with SMTP id u18mr26752712plg.12.1643735390153;
        Tue, 01 Feb 2022 09:09:50 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id h14sm23508476pfh.95.2022.02.01.09.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 09:09:49 -0800 (PST)
Message-ID: <d065921b-784c-be0c-3ad2-f2ededb201ac@gmail.com>
Date:   Tue, 1 Feb 2022 09:09:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/5] x86: uaccess CMPXCHG + KVM bug fixes
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>
References: <20220201010838.1494405-1-seanjc@google.com>
From:   Tadeusz Struk <tstruk@gmail.com>
In-Reply-To: <20220201010838.1494405-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/22 17:08, Sean Christopherson wrote:
> Add uaccess macros for doing CMPXCHG on userspace addresses and use the
> macros to fix KVM bugs by replacing flawed code that maps memory into the
> kernel address space without proper mmu_notifier protection (or with
> broken pfn calculations in one case).
> 
> Add yet another Kconfig for guarding asm_volatile_goto() to workaround a
> clang-13 bug.  I've verified the test passes on gcc versions of arm64,
> PPC, RISC-V, and s390x that also pass the CC_HAS_ASM_GOTO_OUTPUT test.
> 
> Patches 1-4 are tagged for stable@ as patches 3 and 4 (mostly 3) need a
> backportable fix, and doing CMPXCHG on the userspace address is the
> simplest fix from a KVM perspective.
> 
> Peter Zijlstra (1):
>    x86/uaccess: Implement macros for CMPXCHG on user addresses
> 
> Sean Christopherson (4):
>    Kconfig: Add option for asm goto w/ tied outputs to workaround
>      clang-13 bug
>    KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D bits
>    KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses
>    KVM: x86: Bail to userspace if emulation of atomic user access faults
> 
>   arch/x86/include/asm/uaccess.h | 131 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/mmu/paging_tmpl.h |  45 +----------
>   arch/x86/kvm/x86.c             |  35 ++++-----
>   init/Kconfig                   |   4 +
>   4 files changed, 150 insertions(+), 65 deletions(-)

This also fixes the following syzbot issue:
https://syzkaller.appspot.com/bug?id=6cb6102a0a7b0c52060753dd62d070a1d1e71347

Tested-by: Tadeusz Struk <tadeusz.struk@linaro.org>

--
Thanks,
Tadeusz
