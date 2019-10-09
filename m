Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB72DD1273
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 17:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbfJIP1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 11:27:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731688AbfJIP1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 11:27:10 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6529980F81
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 15:27:09 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id r187so2262191wme.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 08:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LnjHlFJZ3FGQs1QMmZ0Kw4G8OSYD5KUzSAtQFbnF6ZY=;
        b=lOR4pUbIRxZ9rZVPwQacyZN7ElzERZ7R53cZihbr44DP9ibF6kldT0n4b1nUpozyd3
         8yU/RjFu4XeGBA8uVXH+Y9WYrXEAJ6xBoR5HiqLN/tVi3Nqut5Q4fZZUL6v6tF4DHHGH
         FCnJBexi2vtWK2ZBtwOunl0x+ZD8lr6gI52onq0fqdL1qTNetfhfDRiatfy5N8Pte+v3
         OFXHbJoMf9yYa0/7dXnPnPW/w75+R0x3b7vMtV4djX4wsZo6cyTRCypmyDXpC1ud5erZ
         RcFlCadKFnLzuYh9foG+hsjUN1Bb91E58qzVf/i0ozykejR0DiBAfbO2VBqpFgn8HwDv
         Lt1A==
X-Gm-Message-State: APjAAAXe6E6YwK2gP9HNZb6vEGgHTKHLe2r5VSBdTiBGidyAJPvto/C6
        QiWQjDMbYhhESKkTSfHVC/9WIFVVRwVVAi4/vjquLC8c65edvtWaufNOCVl1QtIHss2l1fKJrFr
        WTSchjDW1NX0f
X-Received: by 2002:a5d:558b:: with SMTP id i11mr3472663wrv.166.1570634827937;
        Wed, 09 Oct 2019 08:27:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz0yhf0MXP9Ng1677vjj7N5mFHVu5KZ31jlXdy5OfBdWtvgpCjVAte/20NBF1wNoCg+0aCTPg==
X-Received: by 2002:a5d:558b:: with SMTP id i11mr3472632wrv.166.1570634827634;
        Wed, 09 Oct 2019 08:27:07 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h125sm3559380wmf.31.2019.10.09.08.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 08:27:07 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Roman Kagan <rkagan@virtuozzo.com>,
        Michael Kelley <mikelley@microsoft.com>
Cc:     "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
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
Subject: Re: [PATCH v3] x86/hyperv: make vapic support x2apic mode
In-Reply-To: <20191009145022.28442-1-rkagan@virtuozzo.com>
References: <20191009145022.28442-1-rkagan@virtuozzo.com>
Date:   Wed, 09 Oct 2019 17:27:06 +0200
Message-ID: <87r23mx7lh.fsf@vitty.brq.redhat.com>
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
> According to Michael Kelley, when in x2apic mode, the Hyper-V synthetic
> apic MSRs behave exactly the same as the corresponding architectural
> x2apic MSRs, so there's no need to override the apic accessors.  The
> only exception is hv_apic_eoi_write, which benefits from lazy EOI when
> available; however, its implementation works for both xapic and x2apic
> modes.
>
> Fixes: 29217a474683 ("iommu/hyper-v: Add Hyper-V stub IOMMU driver")
> Fixes: 6b48cb5f8347 ("X86/Hyper-V: Enlighten APIC access")
> Cc: stable@vger.kernel.org
> Suggested-by: Michael Kelley <mikelley@microsoft.com>
> Signed-off-by: Roman Kagan <rkagan@virtuozzo.com>
> ---
> v2 -> v3:
> - do not introduce x2apic-capable hv_apic accessors; leave original
>   x2apic accessors instead
>
> v1 -> v2:
> - add ifdefs to handle !CONFIG_X86_X2APIC
>
>  arch/x86/hyperv/hv_apic.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
> index 5c056b8aebef..26eeff5bd535 100644
> --- a/arch/x86/hyperv/hv_apic.c
> +++ b/arch/x86/hyperv/hv_apic.c
> @@ -261,10 +261,19 @@ void __init hv_apic_init(void)
>  
>  	if (ms_hyperv.hints & HV_X64_APIC_ACCESS_RECOMMENDED) {
>  		pr_info("Hyper-V: Using MSR based APIC access\n");

This pr_info() becomes a bit misleading in x2apic mode, maybe do
something like

pr_info("Hyper-V: using Enlightened APIC (%s mode)",
        x2apic_enabled() ? "x2apic" : "xapic");

> +		/*
> +		 * With x2apic, architectural x2apic MSRs are equivalent to the
> +		 * respective synthetic MSRs, so there's no need to override
> +		 * the apic accessors.  The only exception is
> +		 * hv_apic_eoi_write, because it benefits from lazy EOI when
> +		 * available, but it works for both xapic and x2apic modes.
> +		 */
>  		apic_set_eoi_write(hv_apic_eoi_write);
> -		apic->read      = hv_apic_read;
> -		apic->write     = hv_apic_write;
> -		apic->icr_write = hv_apic_icr_write;
> -		apic->icr_read  = hv_apic_icr_read;
> +		if (!x2apic_enabled()) {
> +			apic->read      = hv_apic_read;
> +			apic->write     = hv_apic_write;
> +			apic->icr_write = hv_apic_icr_write;
> +			apic->icr_read  = hv_apic_icr_read;
> +		}
>  	}
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
