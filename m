Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8779C4FFF09
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 21:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbiDMTUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 15:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbiDMTUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 15:20:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C5C49F03
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:18:02 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso7131526pjb.5
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OqHI2IzoxtLI50aj9lIYmoNMamWH2lv8zRFcfkysIrE=;
        b=Y4wxIRHNUmPoXg+k4tOGzRE1j4zMXKAQtqMZ2odJlui+Fe8fOALN7MeMK/0ivnAwGK
         yUUMXXvrmk16qmn0+afOoW9rSPXQNECA4tvQJGLlRHMUxBM6jquDbm4oq72dahF4zPYq
         pCXwWZ7AnWDMahKztvdDrygc5l6ku4p32IEmVbUsxA3yzt7cAcwr9ogB3Yd1/YCSfu9j
         Xt5PIf25YulxY63VuOS2iP3wY6PuqXYGobz/gANka6/WhX0Xq85ofwRihGHUgnJUBDaI
         k1kZCuz5LukqVwDg515t+zt2QCud3H0ONbIKohDqZOyTFY6ohHsK+m0U5RS0YV3aeF6p
         Qdrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OqHI2IzoxtLI50aj9lIYmoNMamWH2lv8zRFcfkysIrE=;
        b=nYeHmiHbVcBAQ3Ay33tt6fTdJ5pyEYQJKyIsxlFBjWg9/ZHXYlJ/1zEvdIMp1L0ltM
         Bgw5bC+bnLz/ObYtx+K3P+Px1vetCTyvR3mi6id/sJes0x0gD0mLTjo/J/Fq1MeCYXRU
         LOwb5viPgKo7K6egjezZ+rbVeAWycch8yL4ec0Ef4oD8Imloy4e1xiHJdDnrPHMX7zIg
         +lubTeyhDLRkfrP2Lu/4orQLDQC3IpsWGbUzxq/BfFrroudtGlbp15boLuSeOW//OPsY
         Sv3LE5ck6YrMjgB19Boj09Uo4HQF4q4+9Xghr8JlBkE4ioyP3dqHEEby2YbnvDkDrBne
         jJLw==
X-Gm-Message-State: AOAM530KBR4ya/kgNClOogeVk9n4MbwDLf1/RbbeOA0sQHWP2j8kKkWx
        AOe/mitwCbTaRBJC4hgbelvJPlCT2Uu+mA==
X-Google-Smtp-Source: ABdhPJxl105l1EHCioBBxZyNjveK3XmR2c8qz92Dyj5I8oh3ITXKMaCfV4tQy94viMWJsk0uxsgmww==
X-Received: by 2002:a17:90b:4f44:b0:1cb:c539:5acc with SMTP id pj4-20020a17090b4f4400b001cbc5395accmr265004pjb.152.1649877482173;
        Wed, 13 Apr 2022 12:18:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v126-20020a622f84000000b004fa666a1327sm31704227pfv.102.2022.04.13.12.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:18:01 -0700 (PDT)
Date:   Wed, 13 Apr 2022 19:17:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 07/10] x86: efi, smp: Transition APs
 from 16-bit to 32-bit mode
Message-ID: <Ylch5XK3MKGfCRxr@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-8-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-8-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Varad Gautam wrote:
> Sending INIT/SIPI to APs from ap_init() resets them into 16-bit mode
> to loop into sipi_entry().
> 
> To drive the APs into 32-bit mode, the SIPI vector needs:
> 1. A GDT descriptor reachable from 16-bit code (gdt32_descr).
> 2. A 32-bit entrypoint reachable from 16-bit code (ap_start32).
> 3. The locations of GDT and the 32-bit entrypoint.
> 
> Setting these up at compile time (like on non-EFI builds) is not
> possible since EFI builds with -shared -fPIC and efistart64.S cannot
> reference any absolute addresses.
> 
> Relative addressing is unavailable on 16-bit mode.
> 
> Moreover, EFI may not load the 32-bit entrypoint to be reachable from
> 16-bit mode.
> 
> To overcome these problems,
> 1. Fill the GDT descriptor at runtime after relocating
>    [sipi_entry-sipi_end] to lowmem. Since sipi_entry does not know the
>    address of this descriptor, use the last two bytes of SIPI page to
>    communicate it.
> 2. Place a call gate in the GDT to point to ap_start32.
> 3. Popluate sipi_entry() to lcall to ap_start32.
> 
> With this, the APs can transition to 32-bit mode and loop at a known
> location.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/smp.c        | 56 ++++++++++++++++++++++++++++++++++++++++++++
>  x86/efi/efistart64.S | 29 ++++++++++++++++++++++-
>  2 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/x86/smp.c b/lib/x86/smp.c
> index d7f5aba..5cc1648 100644
> --- a/lib/x86/smp.c
> +++ b/lib/x86/smp.c
> @@ -6,6 +6,7 @@
>  #include "apic.h"
>  #include "fwcfg.h"
>  #include "desc.h"
> +#include "asm/page.h"
>  
>  #define IPI_VECTOR 0x20
>  
> @@ -144,16 +145,71 @@ void smp_reset_apic(void)
>  	atomic_inc(&active_cpus);
>  }
>  
> +#ifdef CONFIG_EFI
> +extern u8 gdt32_descr, gdt32, gdt32_end;
> +extern u8 ap_start32;
> +#endif
> +
>  void ap_init(void)
>  {
>  	u8 *dst_addr = 0;
>  	size_t sipi_sz = (&sipi_end - &sipi_entry) + 1;
>  
> +	assert(sipi_sz < PAGE_SIZE);
> +
>  	asm volatile("cld");
>  
>  	/* Relocate SIPI vector to dst_addr so it can run in 16-bit mode. */
> +	memset(dst_addr, 0, PAGE_SIZE);
>  	memcpy(dst_addr, &sipi_entry, sipi_sz);
>  
> +#ifdef CONFIG_EFI
> +	volatile struct descriptor_table_ptr *gdt32_descr_rel;
> +	idt_entry_t *gate_descr;
> +	u16 *gdt32_descr_reladdr = (u16 *) (PAGE_SIZE - sizeof(u16));

Ah, the gdt32 name confused me for a bit.  Can we use something more unique?
Maybe efi_rm_trampoline_gdt?  Or just efi_trampoline_gdt since the "rm" part is
technically wrong (though consistent).

Oooh, and the "PAGE_SIZE - sizeof(u16)" is another instance of open coding
"PAGE_SIZE - 2".  Definitely need a #define for that.

> +
> +	/*
> +	 * gdt32_descr for CONFIG_EFI needs to be filled here dynamically
> +	 * since compile time calculation of offsets is not allowed when
> +	 * building with -shared, and rip-relative addressing is not supported
> +	 * in 16-bit mode.
> +	 *
> +	 * Use the last two bytes of SIPI page to store relocated gdt32_descr
> +	 * addr.

Ooh, I see, it's a double indirection.  Load the address to the descriptor, then
load the descriptor which holds the address to the GDT.  I kept thinking that 
2 bytes were the limit chunk of the descriptor.

Maybe instead of "relocated gdt32_descr addr", "a pointer to the relocated
descriptor used by the trampoline to load the GDT"?

> +	 */
> +	*gdt32_descr_reladdr = (&gdt32_descr - &sipi_entry);
> +
> +	gdt32_descr_rel = (struct descriptor_table_ptr *) ((u64) *gdt32_descr_reladdr);
> +	gdt32_descr_rel->limit = (u16) (&gdt32_end - &gdt32 - 1);
> +	gdt32_descr_rel->base = (ulong) ((u32) (&gdt32 - &sipi_entry));
> +
> +	/*
> +	 * EFI may not load the 32-bit AP entrypoint (ap_start32) low enough
> +	 * to be reachable from the SIPI vector. Since we build with -shared, this

Nit, please avoid "we" and other pronous, e.g. "Since KVM-unit-tests is built with..."
avoids any ambiguity.

> +	 * location needs to be fetched at runtime, and rip-relative addressing is
> +	 * not supported in 16-bit mode.
> +	 * To perform 16-bit -> 32-bit far jump, our options are:

"our options" can be tweaked to something like "Alternatives to a CALL GATE are".

> +	 * - ljmpl $cs, $label : unusable since $label is not known at build time.
> +	 * - push $cs; push $label; lret : requires an intermediate trampoline since
> +	 *	 $label must still be within 0 - 0xFFFF for 16-bit far return to work.
> +	 * - lcall into a call-gate : best suited.

I very much appreciate the comment, but it's backwards in the sense that I had no
idea what I was reading until the very end.  I.e. lead with the below "Set up a
call gate ..." blurb, then dive into the alternatives.  First and forement, help
the reader understand what is actually implemented, then call out the alternatives
and why they're inferior.

> +	 *
> +	 * Set up call gate to ap_start32 within GDT.
> +	 *
> +	 * gdt32 layout:
> +	 *
> +	 * Entry | Segment
> +	 * 0	 | NULL descr
> +	 * 1	 | Code segment descr
> +	 * 2	 | Data segment descr
> +	 * 3	 | Call gate descr
> +	 */
> +	gate_descr = (idt_entry_t *) ((u8 *)(&gdt32 - &sipi_entry)
> +		+ 3 * sizeof(gdt_entry_t));

Ah, it's just a coincidence that this GDT has the same layout as the "real" GDT,
e.g. has the same KERNEL_DS and KERNEL_CS.  It took me a while to suss out that
the APs do indeed reload a different GDT during ap_start64().

In the comment above, can you add a blurb to call out that it's purely coincidental
and not strictly required that this matches the initial part of the final GDT, and
that APs will load the final GDT in ap_start64()?  I kept trying to figure out how
this didn't break tests that use other selectors :-)

> +	set_idt_entry_t(gate_descr, sizeof(gdt_entry_t), (void *) &ap_start32,
> +		0x8 /* sel */, 0xc /* type */, 0 /* dpl */);
> +#endif
> +
>  	/* INIT */
>  	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
>  
