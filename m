Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F406359C507
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbiHVRaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiHVRaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:30:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE753DBD1
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:30:04 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso12026684pjr.3
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=byHRNMLCtBJDcq62UcV8wHX4egiesVjzdV0Fv11ishU=;
        b=Bt9kIhNINJ34r6V/GHdM7Yyj5XImm2dyR/q0TaSLRkL39NAK33mjSNWVp+cXFQ963T
         2g7Cj6d2liTJZcYWwLIfRpyCEKYewbruKEeONjMwcbQqiO7sayXunXM8D6mfmRURnyYc
         snuVK8R/l8a/Fw7OGNaHopJ0SMpzpe936ek5Dgt0gh8s+i1C4HavSSOEb1MLkSkP/qLJ
         XXSEEhXYe7Y/cplv7gVp5mmx+EcCPdICZfi8ccPa+5tYotp3ebH8rncNRooddsZFDrdo
         /FH/WbIL5U/ite721OvraYWQ+76w2JvgrPP0lZoLVGhE1DodoIqBKLhXMj1jcTZrgNam
         LxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=byHRNMLCtBJDcq62UcV8wHX4egiesVjzdV0Fv11ishU=;
        b=gmnCTaMNumc/R+O9iiQkhSPeKT2ne+a64E9Q7EzBExSatYDoGYMWOB/qXoBd1YTo70
         ivmlnGZBC5laL9TDgrRIkt1M2FBQHxmkMk85tnXuv7T095Fdqe7B3DLaLkA0yVdNQTJH
         qWnfvkq3Pw9zWABBuUc8CsxKkOVd2wBX0JToIi5IFSozSR1Nd+PHokFwdeElYAudmFXw
         p/CY585bshssrkyYt0DQsEwHp/NNYdjfQAYkZI8kbUkbxELrYXAIiDb8HgSdQidF151H
         ltm8x3/oLxAs4WzYxmINF2DDPfmeGMfGP6tMR/h3Bs3OqXl6l7kWuALkAGOIfY11W/VG
         BHOQ==
X-Gm-Message-State: ACgBeo075BpyMphUGmZ7crQnAfL8to6XjrrtVKrn2L7Og8mX18DiM/Ho
        wehGLTPlyP8jiQ8bYrQOo6Ug1Q==
X-Google-Smtp-Source: AA6agR4mMqJDaKTPdtcFPYF9+Y1aVWFiZ8xyrysug0M47qSv6tqvSYf21UjaoGacFiwGciuzS2NpOA==
X-Received: by 2002:a17:90b:483:b0:1fb:137e:4bb9 with SMTP id bh3-20020a17090b048300b001fb137e4bb9mr10211376pjb.188.1661189404236;
        Mon, 22 Aug 2022 10:30:04 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a82-20020a621a55000000b005367c28fd32sm3396212pfa.185.2022.08.22.10.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 10:30:03 -0700 (PDT)
Date:   Mon, 22 Aug 2022 17:30:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vasant Karasulli <vkarasulli@suse.de>
Cc:     Thomas.Lendacky@amd.com, bp@alien8.de, drjones@redhat.com,
        erdemaktas@google.com, jroedel@suse.de, kvm@vger.kernel.org,
        marcorr@google.com, pbonzini@redhat.com, rientjes@google.com,
        zxwang42@gmail.com
Subject: Re: [kvm-unit-tests PATCH v4 08/13] x86: efi: Provide percpu storage
Message-ID: <YwO9GM/SV3amfIA1@google.com>
References: <20220615232943.1465490-9-seanjc@google.com>
 <20220822152123.18983-1-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822152123.18983-1-vkarasulli@suse.de>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please send a standalone patch (with a SOB), this series has already been merged.

On Mon, Aug 22, 2022, Vasant Karasulli wrote:
> Writing to MSR_IA32_APICBASE in reset_apic() is an
> intercepted operation

Is _typically_ an intercepted operation, architecturally there's nothing that
requires APICBASE to emulated.  

> and causes #VC exception when the test is launched as
> an SEV-ES guest.
>
> So calling reset_apic() before IDT is set up in setup_idt() and
> load_idt() might cause problems.

> Similarly if accessing _percpu_data array element in setup_segments64() results
> in a page fault, this will lead to a double fault.

Well, yeah, but loading the IDT isn't going to magically fix the #PF.  I suspect
you're actually referring to the emulated MMIO #NPF=>#VC when accessing the xAPIC
through MMIO?

> Hence move reset_apic() call and percpu data setup after
> setup_idt() and load_idt().
> ---
>  lib/x86/setup.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index 7df0256..b14e692 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -192,8 +192,6 @@ static void setup_segments64(void)
>  	write_gs(KERNEL_DS);
>  	write_ss(KERNEL_DS);
> 
> -	/* Setup percpu base */
> -	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
> 
>  	/*
>  	 * Update the code segment by putting it on the stack before the return
> @@ -322,7 +320,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  		}
>  		return status;
>  	}
> -
> +
>  	status = setup_rsdp(efi_bootinfo);
>  	if (status != EFI_SUCCESS) {
>  		printf("Cannot find RSDP in EFI system table\n");
> @@ -344,14 +342,15 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  	}
> 
>  	setup_gdt_tss();
> +	setup_segments64();
> +	setup_idt();
> +	load_idt();
>  	/*
>  	 * GS.base, which points at the per-vCPU data, must be configured prior
>  	 * to resetting the APIC, which sets the per-vCPU APIC ops.
>  	 */
> -	setup_segments64();
> +	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);

This absolutely needs a comment, otherwise someone will wonder why on earth GS.base
isn't configured during setup_segments64().  Easist thing is probalby to split and
reword the above comment, e.g.

	/*
	 * Load GS.base with the per-vCPU data.  This must be done after loading
	 * the IDT as reading the APIC ID may #VC when running as an SEV-ES guest.
	 */
	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);

	/*
	 * Resetting the APIC sets the per-vCPU APIC ops and so must be done
	 * after loading GS.base with the per-vCPU data.
	 */
	reset_apic();	
	
>  	reset_apic();
> -	setup_idt();
> -	load_idt();
>  	mask_pic_interrupts();
>  	setup_page_table();
>  	enable_apic();
> --
> 2.34.1
> 
