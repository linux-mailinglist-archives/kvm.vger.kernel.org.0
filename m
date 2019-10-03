Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BB8C9CBA
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 12:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfJCKyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 06:54:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfJCKyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 06:54:07 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F83B3C93D
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 10:54:07 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id q8so943176wrp.8
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 03:54:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GffyjIVlPnvsrRSrHxajUWEZWrzULU9iPsHRwjh280A=;
        b=jYpLErPm2I0e8YxbQIewe51yKHIGqUx2rBz8M7GIsKryxM8GKrJR1FknCXH/cO6CuT
         0f077ATLD33WtFGmiVTALglx0uyhAx7qG7ReEHEMzMFVRN0+qEY6WyPfva9EruL7XLZX
         DzHzAbkDJ8yV5QQcYM/Sk9ArNheYcBurUSwx5zI70Mdrc0ilAs5shkf4CY/1s6ELSiPl
         xNKkc/RLNjpub+d9/qHPCnME0eNeM/GDxUyGfY+O7KKdePxDJt5yu3VlUmuxj0gwgjSY
         XQnhBXzjTsBXrrfs4KIn1EOueBn1drQyoA9FXyh4bTw4JxkjVIN9mdnWPAxtR7Pburra
         K/DA==
X-Gm-Message-State: APjAAAW7TeehxaI5eoUnMQwv1s0wtW8bDUgH1JRx07cTi/KGVgPphw7j
        Kzv4EdERamO/8EBZvC/zI7zCBvGVszd1R7F/aEWvyqVKZjYj1YYZ5S02PQc2xi0raD+Aca3tmZO
        lzRTTdXxCiPmi
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr6708220wrv.248.1570100045802;
        Thu, 03 Oct 2019 03:54:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyv3Z0Cd9/KSakZBKWO86WJgzxHATqe7HQh3z6HK3wpvt0UzrjZziBeGUCN3si1Uj2bHlWO1w==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr6708199wrv.248.1570100045516;
        Thu, 03 Oct 2019 03:54:05 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z5sm3892422wrs.54.2019.10.03.03.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 03:54:04 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Roman Kagan <rkagan@virtuozzo.com>
Cc:     "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Joerg Roedel <jroedel@suse.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-hyperv\@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86/hyperv: make vapic support x2apic mode
In-Reply-To: <20191002101923.4981-1-rkagan@virtuozzo.com>
References: <20191002101923.4981-1-rkagan@virtuozzo.com>
Date:   Thu, 03 Oct 2019 12:54:03 +0200
Message-ID: <87muei14ms.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Roman Kagan <rkagan@virtuozzo.com> writes:

> Now that there's Hyper-V IOMMU driver, Linux can switch to x2apic mode
> when supported by the vcpus.
>
> However, the apic access functions for Hyper-V enlightened apic assume
> xapic mode only.
>
> As a result, Linux fails to bring up secondary cpus when run as a guest
> in QEMU/KVM with both hv_apic and x2apic enabled.
>
> I didn't manage to make my instance of Hyper-V expose x2apic to the
> guest; nor does Hyper-V spec document the expected behavior.  However,
> a Windows guest running in QEMU/KVM with hv_apic and x2apic and a big
> number of vcpus (so that it turns on x2apic mode) does use enlightened
> apic MSRs passing unshifted 32bit destination id and falls back to the
> regular x2apic MSRs for less frequently used apic fields.
>
> So implement the same behavior, by replacing enlightened apic access
> functions (only those where it makes a difference) with their
> x2apic-aware versions when x2apic is in use.
>
> Fixes: 29217a474683 ("iommu/hyper-v: Add Hyper-V stub IOMMU driver")
> Fixes: 6b48cb5f8347 ("X86/Hyper-V: Enlighten APIC access")
> Cc: stable@vger.kernel.org
> Signed-off-by: Roman Kagan <rkagan@virtuozzo.com>
> ---
> v1 -> v2:
> - add ifdefs to handle !CONFIG_X86_X2APIC
>
>  arch/x86/hyperv/hv_apic.c | 54 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 51 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
> index 5c056b8aebef..eb1434ae9e46 100644
> --- a/arch/x86/hyperv/hv_apic.c
> +++ b/arch/x86/hyperv/hv_apic.c
> @@ -84,6 +84,44 @@ static void hv_apic_write(u32 reg, u32 val)
>  	}
>  }
>  
> +#ifdef CONFIG_X86_X2APIC
> +static void hv_x2apic_icr_write(u32 low, u32 id)
> +{
> +	wrmsr(HV_X64_MSR_ICR, low, id);
> +}

AFAIU you're trying to mirror native_x2apic_icr_write() here but this is
different from what hv_apic_icr_write() does
(SET_APIC_DEST_FIELD(id)). Is it actually correct? (I think you've
tested this and it is but) Michael, could you please shed some light
here?

> +
> +static u32 hv_x2apic_read(u32 reg)
> +{
> +	u32 reg_val, hi;
> +
> +	switch (reg) {
> +	case APIC_EOI:
> +		rdmsr(HV_X64_MSR_EOI, reg_val, hi);
> +		return reg_val;
> +	case APIC_TASKPRI:
> +		rdmsr(HV_X64_MSR_TPR, reg_val, hi);
> +		return reg_val;
> +
> +	default:
> +		return native_apic_msr_read(reg);
> +	}
> +}
> +
> +static void hv_x2apic_write(u32 reg, u32 val)
> +{
> +	switch (reg) {
> +	case APIC_EOI:
> +		wrmsr(HV_X64_MSR_EOI, val, 0);
> +		break;
> +	case APIC_TASKPRI:
> +		wrmsr(HV_X64_MSR_TPR, val, 0);
> +		break;
> +	default:
> +		native_apic_msr_write(reg, val);
> +	}
> +}
> +#endif /* CONFIG_X86_X2APIC */
> +
>  static void hv_apic_eoi_write(u32 reg, u32 val)
>  {
>  	struct hv_vp_assist_page *hvp = hv_vp_assist_page[smp_processor_id()];
> @@ -262,9 +300,19 @@ void __init hv_apic_init(void)
>  	if (ms_hyperv.hints & HV_X64_APIC_ACCESS_RECOMMENDED) {
>  		pr_info("Hyper-V: Using MSR based APIC access\n");
>  		apic_set_eoi_write(hv_apic_eoi_write);
> -		apic->read      = hv_apic_read;
> -		apic->write     = hv_apic_write;
> -		apic->icr_write = hv_apic_icr_write;
> +#ifdef CONFIG_X86_X2APIC
> +		if (x2apic_enabled()) {
> +			apic->read      = hv_x2apic_read;
> +			apic->write     = hv_x2apic_write;
> +			apic->icr_write = hv_x2apic_icr_write;
> +		} else {
> +#endif
> +			apic->read      = hv_apic_read;
> +			apic->write     = hv_apic_write;
> +			apic->icr_write = hv_apic_icr_write;

(just wondering): Is it always safe to assume that we cannot switch
between apic_flat/x2apic in runtime? Moreover, the only difference
between hv_apic_read/hv_apic_write and hv_x2apic_read/hv_x2apic_write is
native_apic_mem_{read,write} -> native_apic_msr_{read,write}. Would it
make sense to move if (x2apic_enabled()) and merge these functions?

> +#ifdef CONFIG_X86_X2APIC
> +		}
> +#endif
>  		apic->icr_read  = hv_apic_icr_read;
>  	}
>  }

-- 
Vitaly
