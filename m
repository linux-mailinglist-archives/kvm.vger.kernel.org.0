Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B92175F52
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 17:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCBQPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 11:15:31 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29225 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726946AbgCBQPa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Mar 2020 11:15:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583165730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mmvLYV8uSGKamG5bn2woan+DsvrYgigNBwpjj5pYtP4=;
        b=EOe5Q1Ui9U0fPNriM4iABmpmsnggs0woQ7J+hlOO88tX/NfvDKe14HvxzUj+hVTqv9EoIe
        ePon2HhBehlkmB2v0GFIooYrN+LAl2kbalM1dNvGBbw8KPUICclDNndIhcCrIK0Z+HB23a
        zBB/tclu50fhzbEEbMFrcJkJhEotqUk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-4j2Ow_OYN6-RH3bg8Jmgsw-1; Mon, 02 Mar 2020 11:15:28 -0500
X-MC-Unique: 4j2Ow_OYN6-RH3bg8Jmgsw-1
Received: by mail-wr1-f69.google.com with SMTP id p5so5965440wrj.17
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 08:15:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mmvLYV8uSGKamG5bn2woan+DsvrYgigNBwpjj5pYtP4=;
        b=bZBw1pk7C5t8N2NSrmfb6Zt808zhmLI4AA8PBuSTXVayPyoWWfxLEx6B84CvlxXXPY
         HWdSLGQz8Uf1NHTSbP+Ffr39nOHnuuuOJBkpEOy+swz4IyXsOQmEByTti4W3FLHBb9oF
         KfEQKHK/p6MliLubiYuHyckzeZcKt9kkG+lJ1qZaAsK5ENx1lyKJYC5J3aWP976+dcHW
         lkL8BYkRnM+NIJKcxSt4abIrIzFiDvjSbH5xD77BZ+kaYcikdHTRA2HpAlxZqMQEbz+e
         T/swCLhfJK1Ww0XSX/F+FdbQOrdtwmFk6MDY7jgLng5rwPdGH/28xnTtrK97J19ByClk
         wxVQ==
X-Gm-Message-State: ANhLgQ3x+3hZI0x2kM0JKQG5Mqlzzx9falHalCwHztWNeNInIO5Xg7Qn
        bfICU6zKybr6Fn94H1izJudAcBZSAwxCqYp3jS0syMnr7yseVWd0yZSm8f78W4CfsB3qE5ZjMm5
        g4yKFTpeFgBpg
X-Received: by 2002:a5d:5303:: with SMTP id e3mr344177wrv.274.1583165727168;
        Mon, 02 Mar 2020 08:15:27 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuZcTc1H12c5GWZ/vC0FhpVFV4kZ8UauvtLtPuaHd1TfxD7u0doqtcC+cwc3WdkGewCKmPeGQ==
X-Received: by 2002:a5d:5303:: with SMTP id e3mr344158wrv.274.1583165726844;
        Mon, 02 Mar 2020 08:15:26 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id b24sm5726409wmj.13.2020.03.02.08.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 08:15:26 -0800 (PST)
Subject: Re: [PATCH v2] KVM: Remove unnecessary asm/kvm_host.h includes
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jianjay.zhou@huawei.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200228183020.398692-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4c7c323e-5e5d-01b6-fb94-74390a813ff1@redhat.com>
Date:   Mon, 2 Mar 2020 17:15:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200228183020.398692-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 19:30, Peter Xu wrote:
> Remove includes of asm/kvm_host.h from files that already include
> linux/kvm_host.h to make it more obvious that there is no ordering issue
> between the two headers.  linux/kvm_host.h includes asm/kvm_host.h to
> pick up architecture specific settings, and this will never change, i.e.
> including asm/kvm_host.h after linux/kvm_host.h may seem problematic,
> but in practice is simply redundant.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
> v2:
> - s/unecessary/unnecessary/
> - use Sean's suggested commit message
> ---
>  arch/arm/kvm/coproc.c                | 1 -
>  arch/arm64/kvm/fpsimd.c              | 1 -
>  arch/arm64/kvm/guest.c               | 1 -
>  arch/arm64/kvm/hyp/switch.c          | 1 -
>  arch/arm64/kvm/sys_regs.c            | 1 -
>  arch/arm64/kvm/sys_regs_generic_v8.c | 1 -
>  arch/powerpc/kvm/book3s_64_vio.c     | 1 -
>  arch/powerpc/kvm/book3s_64_vio_hv.c  | 1 -
>  arch/powerpc/kvm/book3s_hv.c         | 1 -
>  arch/powerpc/kvm/mpic.c              | 1 -
>  arch/powerpc/kvm/powerpc.c           | 1 -
>  arch/powerpc/kvm/timing.h            | 1 -
>  arch/s390/kvm/intercept.c            | 1 -
>  arch/x86/kvm/mmu/page_track.c        | 1 -
>  virt/kvm/arm/psci.c                  | 1 -
>  15 files changed, 15 deletions(-)
> 
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index 07745ee022a1..f0c09049ee99 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -10,7 +10,6 @@
>  #include <linux/kvm_host.h>
>  #include <linux/uaccess.h>
>  #include <asm/kvm_arm.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_mmu.h>
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 525010504f9d..e329a36b2bee 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -11,7 +11,6 @@
>  #include <linux/kvm_host.h>
>  #include <asm/fpsimd.h>
>  #include <asm/kvm_asm.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/sysreg.h>
>  
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 2bd92301d32f..23ebe51410f0 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -25,7 +25,6 @@
>  #include <asm/kvm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_coproc.h>
> -#include <asm/kvm_host.h>
>  #include <asm/sigcontext.h>
>  
>  #include "trace.h"
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index dfe8dd172512..f3e0ab961565 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -17,7 +17,6 @@
>  #include <asm/kprobes.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3e909b117f0c..b95f7b7743c8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -22,7 +22,6 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_emulate.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/perf_event.h>
> diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
> index 2b4a3e2d1b89..9cb6b4c8355a 100644
> --- a/arch/arm64/kvm/sys_regs_generic_v8.c
> +++ b/arch/arm64/kvm/sys_regs_generic_v8.c
> @@ -12,7 +12,6 @@
>  #include <asm/cputype.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_coproc.h>
>  #include <asm/sysreg.h>
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index ee6c103bb7d5..50555ad1db93 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -27,7 +27,6 @@
>  #include <asm/hvcall.h>
>  #include <asm/synch.h>
>  #include <asm/ppc-opcode.h>
> -#include <asm/kvm_host.h>
>  #include <asm/udbg.h>
>  #include <asm/iommu.h>
>  #include <asm/tce.h>
> diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
> index ab6eeb8e753e..6fcaf1fa8e02 100644
> --- a/arch/powerpc/kvm/book3s_64_vio_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
> @@ -24,7 +24,6 @@
>  #include <asm/hvcall.h>
>  #include <asm/synch.h>
>  #include <asm/ppc-opcode.h>
> -#include <asm/kvm_host.h>
>  #include <asm/udbg.h>
>  #include <asm/iommu.h>
>  #include <asm/tce.h>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 2cefd071b848..f065d6956342 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -72,7 +72,6 @@
>  #include <asm/xics.h>
>  #include <asm/xive.h>
>  #include <asm/hw_breakpoint.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_book3s_uvmem.h>
>  #include <asm/ultravisor.h>
>  
> diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
> index fe312c160d97..23e9c2bd9f27 100644
> --- a/arch/powerpc/kvm/mpic.c
> +++ b/arch/powerpc/kvm/mpic.c
> @@ -32,7 +32,6 @@
>  #include <linux/uaccess.h>
>  #include <asm/mpic.h>
>  #include <asm/kvm_para.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_ppc.h>
>  #include <kvm/iodev.h>
>  
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 1af96fb5dc6f..c1f23cb4206c 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -32,7 +32,6 @@
>  #include <asm/plpar_wrappers.h>
>  #endif
>  #include <asm/ultravisor.h>
> -#include <asm/kvm_host.h>
>  
>  #include "timing.h"
>  #include "irq.h"
> diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
> index ace65f9fed30..feef7885ba82 100644
> --- a/arch/powerpc/kvm/timing.h
> +++ b/arch/powerpc/kvm/timing.h
> @@ -10,7 +10,6 @@
>  #define __POWERPC_KVM_EXITTIMING_H__
>  
>  #include <linux/kvm_host.h>
> -#include <asm/kvm_host.h>
>  
>  #ifdef CONFIG_KVM_EXIT_TIMING
>  void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu);
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index a389fa85cca2..3655196f1c03 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -12,7 +12,6 @@
>  #include <linux/errno.h>
>  #include <linux/pagemap.h>
>  
> -#include <asm/kvm_host.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/irq.h>
>  #include <asm/sysinfo.h>
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 3521e2d176f2..0713778b8e12 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -14,7 +14,6 @@
>  #include <linux/kvm_host.h>
>  #include <linux/rculist.h>
>  
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_page_track.h>
>  
>  #include "mmu.h"
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 17e2bdd4b76f..14a162e295a9 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -12,7 +12,6 @@
>  
>  #include <asm/cputype.h>
>  #include <asm/kvm_emulate.h>
> -#include <asm/kvm_host.h>
>  
>  #include <kvm/arm_psci.h>
>  #include <kvm/arm_hypercalls.h>
> 

Queued, thanks.

Paolo

