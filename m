Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2960540C78C
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 16:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbhIOOhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 10:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbhIOOha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 10:37:30 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B60C061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 07:36:11 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id b21-20020a1c8015000000b003049690d882so4972355wmd.5
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 07:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5QZGFGPjF0C7Lig7wvQtlLsEnnIuhwXE287z3nzxPnM=;
        b=hh6q5iBnyyoQpXq0cwG3GM6sVyQM1eEJQDpWrxibZ+CrS2VxVSbqVQqiv0mL+oouay
         Q3Mc9wZAhwJ/yhOG15l6qZ6ujoSn6H+iVyyXSm0/Wqy1LTk+8dVotdQIHkZoXZKHurKc
         viRIn0WOSacK+JGn9TYNC9UfBzNRAOHUfy3eI5RMjtNybA7blQbvxv0HzIvQqCUCwjhv
         qMci3YSVcnAgbMYDiVRHl3b+tVKvUA/co/SLbzVqLJ4urEtXOxHFM5RvugPAoAep8crD
         uqjmpx+C5Ixw7tWByqw9kPNwmqYCw3jcQeGlte8nkHPJsNUQHjplVG9JcZkIxYwtjqtO
         nSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5QZGFGPjF0C7Lig7wvQtlLsEnnIuhwXE287z3nzxPnM=;
        b=aOfUbKBlXG85ELIRFARHiQ2r8eNVX/2h+qOA2rTNw1ee+kffaGw4epxmv1bRejpETo
         OjGgr5UI6HUGyvorRK0fatolHN8BQUrusAodyemXtdj1tGBS3O8cOBWGZ5iyb9zgvTpR
         dV3B1aAhq+CJ//ZusHvLG/nv3x1x4XxT6NCC01+DYTuX38DP4EJf5otIQ4OjSOPE/4rc
         992eWUSCSqfexvr81sbL8VRB75OI+8dS8H6OvOn8fVoOZ6iBmzlx6Y9kzd8nNgrPTjdT
         fDwsr1cDg1cjvqA2XpiGUgOoKoGsSDXH6qApn0oLoe1HAZqMsfGE0ioy1ttDAup2qgUr
         +HMw==
X-Gm-Message-State: AOAM530LRw3i3Fg7Gez/L0t7BD72TAQiq1b+VgGSu4JMBLXUhwtv/srJ
        xDf+fzP6S2vc8XleO3aJ2iI=
X-Google-Smtp-Source: ABdhPJzV2UYq/ifyKLCu0luZxs/3Cs6KK3maXJdiENXxmo/3wi4QOaaFmsAK4MmdhKfmumHepZ8hCg==
X-Received: by 2002:a05:600c:b41:: with SMTP id k1mr5017576wmr.4.1631716570336;
        Wed, 15 Sep 2021 07:36:10 -0700 (PDT)
Received: from [192.168.1.36] (14.red-83-35-25.dynamicip.rima-tde.net. [83.35.25.14])
        by smtp.gmail.com with ESMTPSA id z12sm144747wro.75.2021.09.15.07.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 07:36:09 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH] target/i386: Include 'hw/i386/apic.h' locally
To:     qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Colin Xu <colin.xu@intel.com>, haxm-team@intel.com,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210902152243.386118-1-f4bug@amsat.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <66a53499-bd20-e422-3b47-cdbb1ef28480@amsat.org>
Date:   Wed, 15 Sep 2021 16:36:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210902152243.386118-1-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 5:22 PM, Philippe Mathieu-Daudé wrote:
> Instead of including a sysemu-specific header in "cpu.h"
> (which is shared with user-mode emulations), include it
> locally when required.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---

Ping?

> ---
>  target/i386/cpu.h                    | 4 ----
>  hw/i386/kvmvapic.c                   | 1 +
>  hw/i386/x86.c                        | 1 +
>  target/i386/cpu-sysemu.c             | 1 +
>  target/i386/cpu.c                    | 1 +
>  target/i386/gdbstub.c                | 4 ++++
>  target/i386/hax/hax-all.c            | 1 +
>  target/i386/helper.c                 | 1 +
>  target/i386/hvf/x86_emu.c            | 1 +
>  target/i386/nvmm/nvmm-all.c          | 1 +
>  target/i386/tcg/seg_helper.c         | 4 ++++
>  target/i386/tcg/sysemu/misc_helper.c | 1 +
>  target/i386/whpx/whpx-all.c          | 1 +
>  13 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index c7cc65e92d5..eddafd1acd5 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2046,10 +2046,6 @@ typedef X86CPU ArchCPU;
>  #include "exec/cpu-all.h"
>  #include "svm.h"
>  
> -#if !defined(CONFIG_USER_ONLY)
> -#include "hw/i386/apic.h"
> -#endif
> -
>  static inline void cpu_get_tb_cpu_state(CPUX86State *env, target_ulong *pc,
>                                          target_ulong *cs_base, uint32_t *flags)
>  {
> diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
> index 43f8a8f679e..7333818bdd1 100644
> --- a/hw/i386/kvmvapic.c
> +++ b/hw/i386/kvmvapic.c
> @@ -16,6 +16,7 @@
>  #include "sysemu/hw_accel.h"
>  #include "sysemu/kvm.h"
>  #include "sysemu/runstate.h"
> +#include "hw/i386/apic.h"
>  #include "hw/i386/apic_internal.h"
>  #include "hw/sysbus.h"
>  #include "hw/boards.h"
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index 00448ed55aa..e0218f8791f 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -43,6 +43,7 @@
>  #include "target/i386/cpu.h"
>  #include "hw/i386/topology.h"
>  #include "hw/i386/fw_cfg.h"
> +#include "hw/i386/apic.h"
>  #include "hw/intc/i8259.h"
>  #include "hw/rtc/mc146818rtc.h"
>  
> diff --git a/target/i386/cpu-sysemu.c b/target/i386/cpu-sysemu.c
> index 1078e3d157f..65709e41903 100644
> --- a/target/i386/cpu-sysemu.c
> +++ b/target/i386/cpu-sysemu.c
> @@ -30,6 +30,7 @@
>  #include "hw/qdev-properties.h"
>  
>  #include "exec/address-spaces.h"
> +#include "hw/i386/apic.h"
>  #include "hw/i386/apic_internal.h"
>  
>  #include "cpu-internal.h"
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 97e250e8760..04f59043804 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -33,6 +33,7 @@
>  #include "standard-headers/asm-x86/kvm_para.h"
>  #include "hw/qdev-properties.h"
>  #include "hw/i386/topology.h"
> +#include "hw/i386/apic.h"
>  #ifndef CONFIG_USER_ONLY
>  #include "exec/address-spaces.h"
>  #include "hw/boards.h"
> diff --git a/target/i386/gdbstub.c b/target/i386/gdbstub.c
> index 098a2ad15a9..5438229c1a9 100644
> --- a/target/i386/gdbstub.c
> +++ b/target/i386/gdbstub.c
> @@ -21,6 +21,10 @@
>  #include "cpu.h"
>  #include "exec/gdbstub.h"
>  
> +#ifndef CONFIG_USER_ONLY
> +#include "hw/i386/apic.h"
> +#endif
> +
>  #ifdef TARGET_X86_64
>  static const int gpr_map[16] = {
>      R_EAX, R_EBX, R_ECX, R_EDX, R_ESI, R_EDI, R_EBP, R_ESP,
> diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
> index bf65ed6fa92..cd89e3233a9 100644
> --- a/target/i386/hax/hax-all.c
> +++ b/target/i386/hax/hax-all.c
> @@ -32,6 +32,7 @@
>  #include "sysemu/reset.h"
>  #include "sysemu/runstate.h"
>  #include "hw/boards.h"
> +#include "hw/i386/apic.h"
>  
>  #include "hax-accel-ops.h"
>  
> diff --git a/target/i386/helper.c b/target/i386/helper.c
> index 533b29cb91b..874beda98ae 100644
> --- a/target/i386/helper.c
> +++ b/target/i386/helper.c
> @@ -26,6 +26,7 @@
>  #ifndef CONFIG_USER_ONLY
>  #include "sysemu/hw_accel.h"
>  #include "monitor/monitor.h"
> +#include "hw/i386/apic.h"
>  #endif
>  
>  void cpu_sync_bndcs_hflags(CPUX86State *env)
> diff --git a/target/i386/hvf/x86_emu.c b/target/i386/hvf/x86_emu.c
> index 7c8203b21fb..fb3e88959d4 100644
> --- a/target/i386/hvf/x86_emu.c
> +++ b/target/i386/hvf/x86_emu.c
> @@ -45,6 +45,7 @@
>  #include "x86_flags.h"
>  #include "vmcs.h"
>  #include "vmx.h"
> +#include "hw/i386/apic.h"
>  
>  void hvf_handle_io(struct CPUState *cpu, uint16_t port, void *data,
>                     int direction, int size, uint32_t count);
> diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
> index 28dee4c5ee3..4c07cfc7194 100644
> --- a/target/i386/nvmm/nvmm-all.c
> +++ b/target/i386/nvmm/nvmm-all.c
> @@ -22,6 +22,7 @@
>  #include "qemu/queue.h"
>  #include "migration/blocker.h"
>  #include "strings.h"
> +#include "hw/i386/apic.h"
>  
>  #include "nvmm-accel-ops.h"
>  
> diff --git a/target/i386/tcg/seg_helper.c b/target/i386/tcg/seg_helper.c
> index 13c6e6ee62e..71fd2bf8d06 100644
> --- a/target/i386/tcg/seg_helper.c
> +++ b/target/i386/tcg/seg_helper.c
> @@ -28,6 +28,10 @@
>  #include "helper-tcg.h"
>  #include "seg_helper.h"
>  
> +#ifndef CONFIG_USER_ONLY
> +#include "hw/i386/apic.h"
> +#endif
> +
>  /* return non zero if error */
>  static inline int load_segment_ra(CPUX86State *env, uint32_t *e1_ptr,
>                                 uint32_t *e2_ptr, int selector,
> diff --git a/target/i386/tcg/sysemu/misc_helper.c b/target/i386/tcg/sysemu/misc_helper.c
> index e7a2ebde813..dbeda8d0b0f 100644
> --- a/target/i386/tcg/sysemu/misc_helper.c
> +++ b/target/i386/tcg/sysemu/misc_helper.c
> @@ -24,6 +24,7 @@
>  #include "exec/cpu_ldst.h"
>  #include "exec/address-spaces.h"
>  #include "tcg/helper-tcg.h"
> +#include "hw/i386/apic.h"
>  
>  void helper_outb(CPUX86State *env, uint32_t port, uint32_t data)
>  {
> diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
> index 3e925b9da70..9ab844fd05d 100644
> --- a/target/i386/whpx/whpx-all.c
> +++ b/target/i386/whpx/whpx-all.c
> @@ -20,6 +20,7 @@
>  #include "qemu/main-loop.h"
>  #include "hw/boards.h"
>  #include "hw/i386/ioapic.h"
> +#include "hw/i386/apic.h"
>  #include "hw/i386/apic_internal.h"
>  #include "qemu/error-report.h"
>  #include "qapi/error.h"
> 
