Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB5C59C5BF
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 20:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiHVSH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 14:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbiHVSH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 14:07:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDAD46235
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:07:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 77A1420173;
        Mon, 22 Aug 2022 18:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661191645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=21UmM9uPUbREGijZeAYnwPTGfXFDflYkfiHiu25p5rY=;
        b=UkBKIQXudhDAdXLauxaffNws572kOn22tWsuywISosgdWQrcDxkHJv2/gaDPd//oV8LIz/
        IycieTLkcFZNdo6S1Qr+ohHNtdMXt2FBGbELY6vNp64x2ioCv5/WYTWtCwoKpvFUt3nP44
        OTpAVPd4ovPl9/6yBd5rwM2lww7q384=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661191645;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=21UmM9uPUbREGijZeAYnwPTGfXFDflYkfiHiu25p5rY=;
        b=KCbEfk1QN/kxqyW7uiPxy6o3ihXElcQds2qLp8ZQiaY0BnK6zUQsQHSF4HY1DfpE1soydS
        C6YhK0MnJGKV0+CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 162431332D;
        Mon, 22 Aug 2022 18:07:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lbgBBN3FA2PBUgAAMHmgww
        (envelope-from <vkarasulli@suse.de>); Mon, 22 Aug 2022 18:07:25 +0000
Date:   Mon, 22 Aug 2022 20:07:23 +0200
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas.Lendacky@amd.com, bp@alien8.de, drjones@redhat.com,
        erdemaktas@google.com, jroedel@suse.de, kvm@vger.kernel.org,
        marcorr@google.com, pbonzini@redhat.com, rientjes@google.com,
        zxwang42@gmail.com
Subject: Re: [kvm-unit-tests PATCH v4 08/13] x86: efi: Provide percpu storage
Message-ID: <YwPF21yS/T1di22h@vasant-suse>
References: <20220615232943.1465490-9-seanjc@google.com>
 <20220822152123.18983-1-vkarasulli@suse.de>
 <YwO9GM/SV3amfIA1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwO9GM/SV3amfIA1@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mo 22-08-22 17:30:00, Sean Christopherson wrote:
> Please send a standalone patch (with a SOB), this series has already been merged.
>

Sorry, I will send a new patch.

> On Mon, Aug 22, 2022, Vasant Karasulli wrote:
> > Writing to MSR_IA32_APICBASE in reset_apic() is an
> > intercepted operation
>
> Is _typically_ an intercepted operation, architecturally there's nothing that
> requires APICBASE to emulated.

Right, I will improve the wording.

>
> > and causes #VC exception when the test is launched as
> > an SEV-ES guest.
> >
> > So calling reset_apic() before IDT is set up in setup_idt() and
> > load_idt() might cause problems.
>
> > Similarly if accessing _percpu_data array element in setup_segments64() results
> > in a page fault, this will lead to a double fault.
>
> Well, yeah, but loading the IDT isn't going to magically fix the #PF.  I suspect
> you're actually referring to the emulated MMIO #NPF=>#VC when accessing the xAPIC
> through MMIO?

Damn, I overlooked the pre_boot_apic_id() call, thought just accessing the array
element is the culprit. :(
>
> > Hence move reset_apic() call and percpu data setup after
> > setup_idt() and load_idt().
> > ---
> >  lib/x86/setup.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> > index 7df0256..b14e692 100644
> > --- a/lib/x86/setup.c
> > +++ b/lib/x86/setup.c
> > @@ -192,8 +192,6 @@ static void setup_segments64(void)
> >  	write_gs(KERNEL_DS);
> >  	write_ss(KERNEL_DS);
> >
> > -	/* Setup percpu base */
> > -	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
> >
> >  	/*
> >  	 * Update the code segment by putting it on the stack before the return
> > @@ -322,7 +320,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
> >  		}
> >  		return status;
> >  	}
> > -
> > +
> >  	status = setup_rsdp(efi_bootinfo);
> >  	if (status != EFI_SUCCESS) {
> >  		printf("Cannot find RSDP in EFI system table\n");
> > @@ -344,14 +342,15 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
> >  	}
> >
> >  	setup_gdt_tss();
> > +	setup_segments64();
> > +	setup_idt();
> > +	load_idt();
> >  	/*
> >  	 * GS.base, which points at the per-vCPU data, must be configured prior
> >  	 * to resetting the APIC, which sets the per-vCPU APIC ops.
> >  	 */
> > -	setup_segments64();
> > +	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
>
> This absolutely needs a comment, otherwise someone will wonder why on earth GS.base
> isn't configured during setup_segments64().  Easist thing is probalby to split and
> reword the above comment, e.g.

Will do that. Thanks for the suggestion and the review.
>
> 	/*
> 	 * Load GS.base with the per-vCPU data.  This must be done after loading
> 	 * the IDT as reading the APIC ID may #VC when running as an SEV-ES guest.
> 	 */
> 	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
>
> 	/*
> 	 * Resetting the APIC sets the per-vCPU APIC ops and so must be done
> 	 * after loading GS.base with the per-vCPU data.
> 	 */
> 	reset_apic();
>
> >  	reset_apic();
> > -	setup_idt();
> > -	load_idt();
> >  	mask_pic_interrupts();
> >  	setup_page_table();
> >  	enable_apic();
> > --
> > 2.34.1
> >

Thanks,
Vasant Karasulli
Kernel generalist
www.suse.com<http://www.suse.com>
[https://www.suse.com/assets/img/social-platforms-suse-logo.png]<http://www.suse.com/>
SUSE - Open Source Solutions for Enterprise Servers & Cloud<http://www.suse.com/>
Modernize your infrastructure with SUSE Linux Enterprise servers, cloud technology for IaaS, and SUSE's software-defined storage.
www.suse.com

