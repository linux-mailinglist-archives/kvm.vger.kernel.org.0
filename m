Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32D8474220
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 13:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhLNMJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 07:09:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229565AbhLNMJe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 07:09:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639483773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zy0wskww+aD2/4R9ZsqKne9pFIj+xfx8T5GmY2bY06U=;
        b=MYmrqmoUAa4EF7Bl55s9mOo7XvZsq8btoEtmQuLJ64+fmOBHygv1/g6/Cxj27MGblRn3yi
        AIMvLf7eC6wfztqj/hhKg1R8RhNNhCHp/weU3i0rZ9+1MUMx+h2DYPBqJ4xpQpwtp6R4im
        Aedbakr2Pwi7CjQ+lzhYCvdENCnzStY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-5er1JUDyOfGtnleHjHiNKw-1; Tue, 14 Dec 2021 07:09:32 -0500
X-MC-Unique: 5er1JUDyOfGtnleHjHiNKw-1
Received: by mail-ed1-f69.google.com with SMTP id p4-20020aa7d304000000b003e7ef120a37so16721231edq.16
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 04:09:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zy0wskww+aD2/4R9ZsqKne9pFIj+xfx8T5GmY2bY06U=;
        b=aAOzFgb6/1e8+B3lWNXTFMvvNoLZIfNYoox+7Mb+xVgbMT5mvhZbbPdaJdxlR8d8Xb
         jTA9PoKd0vtkoI2BjF8GQBf4ucanf6dYI22knfTyD/ByisgFOfABTFG0NTcJR3MItEgz
         tei2xZ+QTBJGvk3SgpJ9xiYPU/xfgxGC65nM/EcPdt2WC5XiYblpblXA5cQoe+wYAiQA
         tk6WWEST2HThIYzJLFfxcyB/Wa+3lufBZQCcBZmjKONAm/wxBQbElVK//4mLpUooyZss
         k4F03Z2raXU01SunQ0fqcYuReGH/yoL9K2vMxdE2SY3yNWvg27GbTOUIgYxdHeOhb7QG
         OxNQ==
X-Gm-Message-State: AOAM5309a1Ansd4w4O100jbyKg9roDvZBjxbZ3aTx1Z9fQ0Kbi6KYE/4
        G7GcJpWQManYVtgyPi2rn3Tk3jlqSaHi1QOUUIKJA88LUa5tnj7XTfAZodEagqRKM+RTKUGyEGd
        QwLebpn9yS+x+
X-Received: by 2002:a17:907:868f:: with SMTP id qa15mr5650126ejc.187.1639483771106;
        Tue, 14 Dec 2021 04:09:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOpILr0mhEwipv1ApcLa1BJG0zL6YJeRPArz+qAbMaMR+TRdkE01PvCCD0LCewPKyGHjjq4Q==
X-Received: by 2002:a17:907:868f:: with SMTP id qa15mr5650100ejc.187.1639483770836;
        Tue, 14 Dec 2021 04:09:30 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id hs20sm7108855ejc.26.2021.12.14.04.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 04:09:30 -0800 (PST)
Date:   Tue, 14 Dec 2021 13:09:27 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 0/4] arm: Timer fixes
Message-ID: <20211214120927.ownvywkbjqpyfbmz@gator.home>
References: <20211207154641.87740-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207154641.87740-1-alexandru.elisei@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021 at 03:46:37PM +0000, Alexandru Elisei wrote:
> This series intends to fix two bugs in the timer test. The first one is the
> TVAL comparison to check that the timer has expired and was found by code
> inspection.
> 
> The second one I found while playing with KVM, but it can manifest itself
> on certain hardware configuration with an unmodified version of KVM
> (details in the commit message for the last patch). Or on baremetal (not
> tested). In short, WFI can complete for a variety of reason, not just
> because an interrupt targetted at the VM was asserted. The fix I
> implemented was to do WFI in a loop until we get the interrupt or TVAL
> shows that the timer has expired.
> 
> All the patches in between are an attempt make the tests more robust and
> slightly easier to understand. If these changes are considered unnecessary,
> I would be more than happy to drop them; the main goal of the series is to
> fix the two bugs.
> 
> Tested on a rockpro64 with KVM modifed to clear HCR_EL2.TWI, which means
> that the WFI instruction is not trapped (WFI trapping is a performance
> optimization, not a correctness requirement):
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f4871e47b2d0..9af13e01ffeb 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -96,18 +96,12 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
>  
>  static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
>  {
> -       vcpu->arch.hcr_el2 &= ~HCR_TWE;
> -       if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
> -           vcpu->kvm->arch.vgic.nassgireq)
> -               vcpu->arch.hcr_el2 &= ~HCR_TWI;
> -       else
> -               vcpu->arch.hcr_el2 |= HCR_TWI;
> +       vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
>  }
>  
>  static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
>  {
> -       vcpu->arch.hcr_el2 |= HCR_TWE;
> -       vcpu->arch.hcr_el2 |= HCR_TWI;
> +       vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
>  }
>  
>  static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
> 
> Log when running ./run_test.sh timer (truncated for brevity) without the
> fixes:
> 
> ...
> INFO: vtimer-busy-loop: waiting for interrupt...
> FAIL: vtimer-busy-loop: interrupt received after TVAL/WFI
> FAIL: vtimer-busy-loop: timer has expired
> INFO: vtimer-busy-loop: TVAL is 144646 ticks
> ...
> INFO: ptimer-busy-loop: waiting for interrupt...
> FAIL: ptimer-busy-loop: interrupt received after TVAL/WFI
> FAIL: ptimer-busy-loop: timer has expired
> INFO: ptimer-busy-loop: TVAL is 50384 ticks
> SUMMARY: 18 tests, 4 unexpected failures
> 
> Log when running the same command with the series applied:
> 
> ...
> INFO: vtimer-busy-loop: waiting for interrupt...
> INFO: vtimer-busy-loop: waiting for interrupt...
> INFO: vtimer-busy-loop: waiting for interrupt...
> PASS: vtimer-busy-loop: interrupt received after TVAL/WFI
> PASS: vtimer-busy-loop: timer has expired
> INFO: vtimer-busy-loop: TVAL is -56982 ticks
> ...
> INFO: ptimer-busy-loop: waiting for interrupt...
> INFO: ptimer-busy-loop: waiting for interrupt...
> PASS: ptimer-busy-loop: interrupt received after TVAL/WFI
> PASS: ptimer-busy-loop: timer has expired
> INFO: ptimer-busy-loop: TVAL is -22997 ticks
> SUMMARY: 18 tests
> 
> 
> Alexandru Elisei (4):
>   arm: timer: Fix TVAL comparison for timer condition met
>   arm: timer: Move the different tests into their own functions
>   arm: timer: Test CVAL before interrupt pending state
>   arm: timer: Take into account other wake-up events for the TVAL test
> 
>  arm/timer.c | 81 +++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 66 insertions(+), 15 deletions(-)
> 
> -- 
> 2.34.1
>

Pushed to https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 

