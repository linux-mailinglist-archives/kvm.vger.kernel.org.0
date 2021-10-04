Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A61421988
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 23:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhJDWAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbhJDWAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 18:00:55 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51926C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 14:59:05 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i24so28080344lfj.13
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 14:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rZgCUPnYZ0FR32ISVPVMxVR1xHUCHV+BqlZxDJdX5pA=;
        b=WIZbGtVSRp02kgD+GacEfrJYti/BW8Xqm7dvk3+87vLcx8gpurIIBLnrgIhGBQmB71
         jztycB8Y3Dn/EAxNe42ISbvVz5DQi4iaK0YlRH7Sk1YuCaDTQsdiUOXitK20JfZTHmmB
         pTO3VVRXrtZa6qHbEoKb53EjQkPeUWvMmoeuft5N1cov6AhnHNVVYUdGj541HXVI+D7y
         oQXxQUVG967FgLwvMil1gs+s1r/M+ugTNN7kJSXSXmoz2fwdyhVavyX3BUMF8NFNSypl
         qUCK/T6LE17TE37R2Xk0II5Da03hcuRu41IV/5YDXUa0ZdyBu+XAbi60mdnhrB3AvEJF
         j4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rZgCUPnYZ0FR32ISVPVMxVR1xHUCHV+BqlZxDJdX5pA=;
        b=JiYRY8M9RrGVtCZDmWx6VoSlYNWED1szHl7Jiz1juzCAo4XbVJk+Tpa5aNb/tKJ0/l
         JsMmV99rXnWXZxCdI0x4CDiBtjRnUVcoOGF7Syp2lS9VLWN/6icBLLRuDTy3ZBEE1NkJ
         k9wh55kgbFJDXfbX95qsSW2rxlC1mQlyRfmaz0cFyN7nqc/VBQ3sb6K1cJGjPvlUXn3k
         TOKDbT7NmK3yVFmJd/1ig0L+QKXJnIAzakrlbK7KbvlgW20utj1YBSGmY37BT6qqAyML
         kheVlLbBycILxy+bjGP0ZuWURgRuhqGmuWnRD93ZPEZZODOfBPDusj6cUG9TmxEAZeQn
         gEfg==
X-Gm-Message-State: AOAM530zDrbDUNQtICVPT6Vd8Kx8fRY2khBAWskcL+wTwVCU3GY+0WXV
        3cl7g0HNx0KrNBw3qAEBVxBb+WvUbvP1zjWiLf8=
X-Google-Smtp-Source: ABdhPJwnuYZXpvZedS5hID50zQ3GB3Cptz/XvnpDg0AGdbHaoF9HD5RNmXb0fb1lZJXoaVIYLROr9v2684n6986Ean8=
X-Received: by 2002:ac2:4d16:: with SMTP id r22mr10319473lfi.662.1633384743708;
 Mon, 04 Oct 2021 14:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-9-zixuanwang@google.com> <20211004132102.lfsyabk2daeiejkx@gator>
In-Reply-To: <20211004132102.lfsyabk2daeiejkx@gator>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 4 Oct 2021 14:58:29 -0700
Message-ID: <CAEDJ5ZRy8ywXjujoMVHem8igBq-2s0HzN2Gt6f76cLbZzCkr9g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 08/17] x86 UEFI: Set up RSDP after UEFI
 boot up
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 4, 2021 at 6:23 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 27, 2021 at 03:12:13AM +0000, Zixuan Wang wrote:
> > Root system description pointer (RSDP) is a data structure used in the
> > ACPI programming interface. In BIOS, RSDP is located within a
> > predefined memory area, so a program can scan the memory area and find
> > RSDP. But in UEFI, RSDP may not appear in that memory area, instead, a
> > program should find it in the EFI system table.
> >
> > +typedef union {
> > +     struct {
> > +             efi_guid_t guid;
> > +             void *table;
> > +     };
> > +     efi_config_table_32_t mixed_mode;
>
> Can't we drop all the mixed_mode stuff? Or do we really want to support
> 32-bit UEFI kvm-unit-tests?

We are currently not considering the 32-bit UEFI support. I will drop
the mixed_mode code in the next version.

> > +void setup_efi_rsdp(struct rsdp_descriptor *rsdp) {
> > +     efi_rsdp = rsdp;
> > +}
>
> { on its own line please

Got it! I will fix it in the next version.

> > +
> > +static struct rsdp_descriptor *get_rsdp(void) {
> > +     if (efi_rsdp == NULL) {
> > +             printf("Can't find RSDP from UEFI, maybe setup_efi_rsdp() was not called\n");
> > +     }
> > +     return efi_rsdp;
> > +}
> > +#else
> > +static struct rsdp_descriptor *get_rsdp(void) {
> > +    struct rsdp_descriptor *rsdp;
> > +    unsigned long addr;
> > +    for(addr = 0xf0000; addr < 0x100000; addr += 16) {
> > +     rsdp = (void*)addr;
> > +     if (rsdp->signature == RSDP_SIGNATURE_8BYTE)
> > +          break;
> > +    }
>
> When moving code please take the opportunity to clean up its style.

Got it! I will fix this in the next version.

> > +#ifdef TARGET_EFI
> > +void setup_efi_rsdp(struct rsdp_descriptor *rsdp);
> > +#endif /* TARGET_EFI */
>
> Unnecessary ifdef.

I previously thought it's safer to use ifdef here, as the function is
only defined in the UEFI kvm-unit-tests.

I will drop it in the next version. Dropping it does not affect the
compilation of Multiboot kvm-unit-tests.

> > @@ -255,6 +267,7 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
> >       enable_x2apic();
> >       smp_init();
> >       phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
> > +     setup_efi_rsdp(efi_bootinfo->rsdp);
>
> What memory region is this table in? We should make sure it's reserved or
> copy the table out to somewhere that is reserved.

I will double-check it in the next version. I will add a comment to
this line if it's already in reserved memory. Otherwise, I will copy
it to a reserved location.

> >  }
> >
> >  #endif /* TARGET_EFI */
> > --
> > 2.33.0.259.gc128427fd7-goog
> >
>
> I'd much prefer we avoid too much of this split setup where we have a bit
> of setup in a common efi lib and then an x86 specific part that populates
> an x86 specific info structure before exiting boot services and then more
> x86 specific setup that uses that later...
>
> Can't we do almost everything in lib/efi.c and only call out once into an
> arch_efi_setup function after exiting boot services?
>
> Thanks,
> drew
>

Indeed, I will refactor this part in the next version. I will move the
arch-neutral functions to lib/efi.c and pass an EFI system info data
structure to the arch-specific function for additional setup.

Best regards,
Zixuan
