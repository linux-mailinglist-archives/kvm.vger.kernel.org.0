Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57CA422B99
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 16:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhJEO75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 10:59:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231226AbhJEO74 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 10:59:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633445885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEZND+uRQZ2jXkjYnNViAUBIpQ2vwZb0Yzke1gX91No=;
        b=Qua6q2AeHZKqGBlNmdk9JhS2ba3TMGDxgj1DZJmuyZBbnTwrzhUuc3+sYrmszuXpMe9gHz
        f5Vtc9U+NbTy37ZLyxVZK3tbaL8a3c5NO+DQgw9h8SwpshLR5gZETVRZ+ts+N++YY3X6p8
        MnuXYj74ETqRq1/c8GMHca4Ww1y99Ao=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-MY7G4zQiNu-RJ5qwO8cOwQ-1; Tue, 05 Oct 2021 10:58:04 -0400
X-MC-Unique: MY7G4zQiNu-RJ5qwO8cOwQ-1
Received: by mail-ed1-f71.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so20868682edi.12
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 07:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rEZND+uRQZ2jXkjYnNViAUBIpQ2vwZb0Yzke1gX91No=;
        b=L7Zr0AM0sGMccB7vnVhgXioRismHXIj31RaxBtdnQOAIK/xmHIPUbEIMEThY+sL1tt
         15+bDeb4yvVf7S9z0y7CE/nPrIEZsULJlQloCX5PzUlbperbRt9LrNNM7HafI7j+I4r7
         EzvwJetxidMypbixZn8gAV6HjfKYmEs9NfjWPR7pqXi+19n7U+7fCGRM9FM3S6Hb7Dvn
         rNBzEQ+YWZ2cWREO4ZViaw6ydSaMLC2gqQDdLsyus8ju/B2tX4iG78u5U6SjKNyqboC7
         NlO1Sg/+dtuXVjn3ZyYH02ZEUTpJ7PR7Tjhwtk0I2eH5ABgLLgsqzaqjyOc7vBmOnLOl
         r8+g==
X-Gm-Message-State: AOAM533SJab2cnnozSCiYigRRkeAsgrvF8gw0AGLT+/ywBrZJiQmci1v
        ohCwFJ9wRmaCYg4ECLIE8kOnzl6lTsvFBfrI20HLalvkUe6e/6M7dfT4MYiPiwRT+JTqNOJEADP
        w03uNK8bGKH9E
X-Received: by 2002:a17:906:1ec9:: with SMTP id m9mr26468870ejj.115.1633445882851;
        Tue, 05 Oct 2021 07:58:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2T3tBg98Roz+xgsbi5xVB5eSSYIFuiFIiONsYzlt7erGJu72m+ky0H9IKIL97a2uxUqtXqA==
X-Received: by 2002:a17:906:1ec9:: with SMTP id m9mr26468850ejj.115.1633445882649;
        Tue, 05 Oct 2021 07:58:02 -0700 (PDT)
Received: from redhat.com ([2.55.147.134])
        by smtp.gmail.com with ESMTPSA id m9sm8256357edl.66.2021.10.05.07.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 07:58:02 -0700 (PDT)
Date:   Tue, 5 Oct 2021 10:57:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Cc:     qemu-devel@nongnu.org, haxm-team@intel.com,
        Eduardo Habkost <ehabkost@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>, qemu-trivial@nongnu.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Colin Xu <colin.xu@intel.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: Re: [PATCH v3] target/i386: Include 'hw/i386/apic.h' locally
Message-ID: <20211005105745-mutt-send-email-mst@kernel.org>
References: <20210929163124.2523413-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210929163124.2523413-1-f4bug@amsat.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 06:31:24PM +0200, Philippe Mathieu-Daudé wrote:
> Instead of including a sysemu-specific header in "cpu.h"
> (which is shared with user-mode emulations), include it
> locally when required.
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

which tree? trivial I guess?

> ---
>  target/i386/cpu.h                    | 4 ----
>  hw/i386/kvmvapic.c                   | 1 +
>  hw/i386/x86.c                        | 1 +
>  target/i386/cpu-dump.c               | 1 +
>  target/i386/cpu-sysemu.c             | 1 +
>  target/i386/cpu.c                    | 1 +
>  target/i386/gdbstub.c                | 4 ++++
>  target/i386/hax/hax-all.c            | 1 +
>  target/i386/helper.c                 | 1 +
>  target/i386/hvf/hvf.c                | 1 +
>  target/i386/hvf/x86_emu.c            | 1 +
>  target/i386/nvmm/nvmm-all.c          | 1 +
>  target/i386/tcg/sysemu/misc_helper.c | 1 +
>  target/i386/tcg/sysemu/seg_helper.c  | 1 +
>  target/i386/whpx/whpx-all.c          | 1 +
>  15 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index c2954c71ea0..4411718bb7a 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2045,10 +2045,6 @@ typedef X86CPU ArchCPU;
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
> diff --git a/target/i386/cpu-dump.c b/target/i386/cpu-dump.c
> index 02b635a52cf..0158fd2bf28 100644
> --- a/target/i386/cpu-dump.c
> +++ b/target/i386/cpu-dump.c
> @@ -22,6 +22,7 @@
>  #include "qemu/qemu-print.h"
>  #ifndef CONFIG_USER_ONLY
>  #include "hw/i386/apic_internal.h"
> +#include "hw/i386/apic.h"
>  #endif
>  
>  /***********************************************************/
> diff --git a/target/i386/cpu-sysemu.c b/target/i386/cpu-sysemu.c
> index 37b7c562f53..4e8a6973d08 100644
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
> index 6b029f1bdf1..52422cbf21b 100644
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
> diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
> index 4ba6e82fab3..50058a24f2a 100644
> --- a/target/i386/hvf/hvf.c
> +++ b/target/i386/hvf/hvf.c
> @@ -70,6 +70,7 @@
>  #include <sys/sysctl.h>
>  
>  #include "hw/i386/apic_internal.h"
> +#include "hw/i386/apic.h"
>  #include "qemu/main-loop.h"
>  #include "qemu/accel.h"
>  #include "target/i386/cpu.h"
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
> index a488b00e909..944bdb49663 100644
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
> diff --git a/target/i386/tcg/sysemu/misc_helper.c b/target/i386/tcg/sysemu/misc_helper.c
> index 9ccaa054c4c..b1d3096e9c9 100644
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
> diff --git a/target/i386/tcg/sysemu/seg_helper.c b/target/i386/tcg/sysemu/seg_helper.c
> index bf3444c26b0..34f2c65d47f 100644
> --- a/target/i386/tcg/sysemu/seg_helper.c
> +++ b/target/i386/tcg/sysemu/seg_helper.c
> @@ -24,6 +24,7 @@
>  #include "exec/cpu_ldst.h"
>  #include "tcg/helper-tcg.h"
>  #include "../seg_helper.h"
> +#include "hw/i386/apic.h"
>  
>  #ifdef TARGET_X86_64
>  void helper_syscall(CPUX86State *env, int next_eip_addend)
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
> -- 
> 2.31.1

