Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924404FFE3C
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbiDMS5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiDMS5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:57:39 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F8149F8D
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:55:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ll10so2903587pjb.5
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kG6ZUp+W02LJdqVNh6wM3M/xnpIji0iii1oHfp+7fKE=;
        b=On9f21oWzFSFSurLxsmSs/m/GlxcnYHuzmC/M+2iadFCLU5sqzKBFxq6I7I6NY4arQ
         yywTXtak+hZod2aRBuO5oKe+Mdwemx4uX3SzV7C2rdamyKA9vDJE51+apzNlEl+OTyrk
         Mbi12Qo/I30E5Pq+oZM0inpO5JrgYysnrA9n9uI+nDTejldB3CkgaqcK8hYKEM3bQN23
         NAvjZVx/UxR1VnyGBpfk5F4IodLgMFH1Ia7GZHbKPj7zrzLlHR/ZDY8n0HmUJs0GR6cK
         GLswvhJ7rbj0nLQ/AjFMCZg//vgu/XiMRISrhE+s7zILWdYeBOOQAIgskpw6ChEyyqwj
         urKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kG6ZUp+W02LJdqVNh6wM3M/xnpIji0iii1oHfp+7fKE=;
        b=NUPchc7bPoQxlTC0yETNdTHk5aVo53lZvROdn9aj9pzza46rN7MLWV4wxVDPNFvIQ5
         /ELfTz1l+4UHp3GjE8NVWKsuDmoWKWYf3Guuq7qcQJQmtF8QMsTzbh0If10SrqseXGiG
         NC6aL+yEpGTaOuJu3JU7iOdMNXJ5QIeVFnNfjuDa7PhCS5Ae8g8EAsY6ROLH6t2MJ3rV
         v+xaWscw1+E4kNrRFQt0b38wAfDWZEst3QQbIwMP5D5RfiwthZulk4LJHRDfyCUqOd0J
         ZQHKtwC16j0KtrSKsHYZlGBBWsr9z9pTAXLTt4xMjlbGTcuwpxse9uUP9AnNONqzU/4j
         paEg==
X-Gm-Message-State: AOAM533EFTrQ/s0lh5gJiMeOxRdpBYcdI0V6nsOXN6dcTqQ6TVbxu4Aq
        GIg39Q74ocmT3ML+C+akUYWgUw==
X-Google-Smtp-Source: ABdhPJx4Dd4A9yJgI+9pl/LKXLWNSBfrBGeMNIFxR70/i5xUZub52QouadBilVSmVTaOpb+c4jPE+Q==
X-Received: by 2002:a17:902:760a:b0:14f:4a29:1f64 with SMTP id k10-20020a170902760a00b0014f4a291f64mr26872186pll.90.1649876117280;
        Wed, 13 Apr 2022 11:55:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s89-20020a17090a69e200b001cd5b0dcaa1sm2608126pjj.17.2022.04.13.11.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 11:55:16 -0700 (PDT)
Date:   Wed, 13 Apr 2022 18:55:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 01/10] x86: Move ap_init() to smp.c
Message-ID: <Ylcckbw3XXxcJiTL@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-2-varad.gautam@suse.com>
 <YlcZ83yz9eoBjmEt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlcZ83yz9eoBjmEt@google.com>
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

On Wed, Apr 13, 2022, Sean Christopherson wrote:
> On Tue, Apr 12, 2022, Varad Gautam wrote:
> > @@ -142,3 +143,26 @@ void smp_reset_apic(void)
> >  
> >  	atomic_inc(&active_cpus);
> >  }
> > +
> > +void ap_init(void)
> > +{
> > +	u8 *dst_addr = 0;
> 
> Oof, this is subtle.  I didn't realize until patch 7 that this is actually using
> va=pa=0 for the trampoline.
> 
> Does anything actually prevent KUT from allocating pa=0?  Ah, looks like __setup_vm()
> excludes the lower 1mb.
> 
> '0' should be a #define somewhere, e.g. EFI_RM_TRAMPOLINE_PHYS_ADDR, probably in
> lib/alloc_page.h next to AREA_ANY_NUMBER with a comment tying the two together.
> And then patch 7 can (hopefully without too much pain) use the define instead of
> open coding the reference to PA=0, which is really confusing and unnecessarily
> fragile.
> 
> E.g. instead of
> 
> 	/* Retrieve relocated gdt32_descr address at (PAGE_SIZE - 2). */
> 	mov (PAGE_SIZE - 2), %ebx
> 
> hopefully it can be
> 
> 	mov (EFI_RM_TRAMPOLINE_PHYS_ADDR + PAGE_SIZE - 2), %ebx
> 
> > +	size_t sipi_sz = (&sipi_end - &sipi_entry) + 1;
> 
> Nit, maybe sipi_trampoline_size?

Ooooh, and I finally realized in patch 7 that the "sipi" area encompasses the GDT
as well.  I couldn't figure out how the GDT was getting relocated :-)

Definitely needs a different name.  How about efi_rm_trampoline_start,
efi_rm_trampoline_end, and efi_rm_trampoline_size?  The "real mode" part is
kinda misleading, but on the other hand it's also the main reason why this needs
to be relocated to super low memory.  And add a comment 

That will help make it a little more obvious that there's more than just the SIPI
code that is getting manually relocated.

It's probably still worth having an explicit sipi_entry label, with a comment to
document that it absolutely needs to be at the start of the trampoline so that
the SIPI vector sends APs to the right location.
