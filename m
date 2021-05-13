Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8029537FCA7
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 19:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhEMRo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 13:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229964AbhEMRo3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 13:44:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620927799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltOaFuqAsBE6NBj9u6B6AH3ZN/ZpntcTswD/sYg6FgQ=;
        b=hHRxumQEGcmQLAH0a6dLIhUNL/Edvb2sz4dEHIPCE5mopsg2VZrYf/TwZmENnv3X+b6ft1
        AtS/00xOQeDn0kIQjdD4jao9I3H6P4WJYvTQxjPfEmHvWeIGxP+dRlQxPzxG4p8nZev3m7
        z0ywUJzM2DqTuCuh9kRmPXfx7ySwmos=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-MVow6pXMOaS3PZiKVGAGcA-1; Thu, 13 May 2021 13:43:17 -0400
X-MC-Unique: MVow6pXMOaS3PZiKVGAGcA-1
Received: by mail-ed1-f72.google.com with SMTP id g17-20020aa7dd910000b029038843570b67so15030527edv.9
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 10:43:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ltOaFuqAsBE6NBj9u6B6AH3ZN/ZpntcTswD/sYg6FgQ=;
        b=Gkb1oI6C0hTs03lnSiV1kdd0OhS9T8Q+zgD/kxr2mjqqorQTT09my3h+gbGBab+mFC
         /bul6aBUSPlbR2vHGbA6kd774+61TjTYTZGEAOst8TUO0ssKwth9zySP5ZQBp2XTsDEj
         xCHPf43E9lPEFv4EFQ4byHMNHeSED0uXZIqMXWvnjUyCjt9plSzKfp25SWGdsdbm9Wz5
         9AxGeyHcDk7A784xosaGd/Ig/fLhMFzNX0ZYy6VNINoGvotjPRqYqBXWatGyvBEMufrI
         87LR3Wz00qXK8muH380Cyj+6XcV6FxI6Z4yew88jyIjnWpEqTz1YyotovhuA8STqO2kK
         4AkQ==
X-Gm-Message-State: AOAM531RnHt+tvwRDAr2dEsBRps3RjjGehoGJp10Nf0XEfP7MaeBcbJ4
        asltfbGjyoYu0zwAijwuBvaHGySIecwvOgkqa8YChB9T/73tKVe+oIZSCC365CWgURTTTGZc8Hg
        2qMalXqe2Cycc
X-Received: by 2002:aa7:db94:: with SMTP id u20mr30065487edt.381.1620927796066;
        Thu, 13 May 2021 10:43:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwc9PBrmMqh4/QafVN5RTIgXX3dcesbr744ll+N/OnZNtxul/8iYyHtM3Ve7YV8EeTmh0UoeA==
X-Received: by 2002:aa7:db94:: with SMTP id u20mr30065475edt.381.1620927795849;
        Thu, 13 May 2021 10:43:15 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id yr15sm355106ejb.16.2021.05.13.10.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 10:43:15 -0700 (PDT)
Date:   Thu, 13 May 2021 19:43:13 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v3 4/8] arm/arm64: mmu: Stop mapping an
 assumed IO region
Message-ID: <20210513174313.j7ff6j5jhzvocnuh@gator>
References: <20210429164130.405198-1-drjones@redhat.com>
 <20210429164130.405198-5-drjones@redhat.com>
 <94288c5b-8894-5f8b-2477-6e45e087c4b5@arm.com>
 <0ca20ae5-d797-1c9f-9414-1d162d86f1b5@arm.com>
 <20210513171844.n3h3c7l5srhuriyy@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210513171844.n3h3c7l5srhuriyy@gator>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 13, 2021 at 07:18:44PM +0200, Andrew Jones wrote:
> On Thu, May 13, 2021 at 04:48:16PM +0100, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On 5/10/21 4:45 PM, Alexandru Elisei wrote:
> > > Hi Drew,
> > >
> > > On 4/29/21 5:41 PM, Andrew Jones wrote:
> > >> By providing a proper ioremap function, we can just rely on devices
> > >> calling it for each region they need (as they already do) instead of
> > >> mapping a big assumed I/O range. We don't require the MMU to be
> > >> enabled at the time of the ioremap. In that case, we add the mapping
> > >> to the identity map anyway. This allows us to call setup_vm after
> > >> io_init. Why don't we just call setup_vm before io_init, I hear you
> > >> ask? Well, that's because tests like sieve want to start with the MMU
> > >> off, later call setup_vm, and all the while have working I/O. Some
> > >> unit tests are just really demanding...
> > >>
> > >> While at it, ensure we map the I/O regions with XN (execute never),
> > >> as suggested by Alexandru Elisei.
> > > I got to thinking why this wasn't an issue before. Under KVM, device memory is not
> > > usually mapped at stage 2, so any speculated reads wouldn't have reached memory at
> > > all. The only way I imagine that happening if the user was running kvm-unit-tests
> > > with a passthrough PCI device, which I don't think happens too often.
> > >
> > > But we cannot rely on devices not being mapped at stage 2 when running under EFI
> > > (we're mapping them ourselves with ioremap), so I believe this is a good fix.
> > >
> > > Had another look at the patch, looks good to me:
> > 
> > While testing the series I discovered that this patch introduces a bug when
> > running under kvmtool.
> > 
> > Here's the splat:
> > 
> > $ ./configure --vmm=kvmtool --earlycon=uart,mmio,0x1000000 --page-size=4K && make
> > clean && make -j6 && ./vm run -c2 -m128 -f arm/micro-bench.flat
> > [..]
> >   # lkvm run --firmware arm/micro-bench.flat -m 128 -c 2 --name guest-6986
> >   Info: Placing fdt at 0x80200000 - 0x80210000
> > chr_testdev_init: chr-testdev: can't find a virtio-console
> > Timer Frequency 24000000 Hz (Output in microseconds)
> > 
> > name                                    total ns                         avg
> > ns            
> > --------------------------------------------------------------------------------------------
> > hvc                                 168674516.0                        
> > 2573.0             
> > Load address: 80000000
> > PC: 80000128 PC offset: 128
> > Unhandled exception ec=0x25 (DABT_EL1)
> > Vector: 4 (el1h_sync)
> > ESR_EL1:         96000006, ec=0x25 (DABT_EL1)
> > FAR_EL1: 000000000a000008 (valid)
> > Exception frame registers:
> > pc : [<0000000080000128>] lr : [<000000008000cac8>] pstate: 800003c5
> > sp : 000000008003ff90
> > x29: 0000000000000000 x28: 0000000000000000
> > x27: 00000011ada4d0c2 x26: 0000000000000000
> > x25: 0000000080015978 x24: 0000000080015a90
> > x23: 0000048c27394fff x22: 20c49ba5e353f7cf
> > x21: 28f5c28f5c28f5c3 x20: 0000000080016af0
> > x19: 000000e8d4a51000 x18: 0000000080040000
> > x17: 0000000000000000 x16: 0000000080008210
> > x15: 000000008003fe5c x14: 0000000000000260
> > x13: 00000000000002a4 x12: 0000000080040000
> > x11: 0000000000000001 x10: 0000000000000060
> > x9 : 0000000000000000 x8 : 0000000000000039
> > x7 : 0000000000000040 x6 : 0000000080013983
> > x5 : 000000008003f74e x4 : 000000008003f69c
> > x3 : 0000000000000000 x2 : 0000000000000000
> > x1 : 0000000000000000 x0 : 000000000a000008
> > 
> > The issue is caused by the mmio_read_user_exec() function from arm/micro-bench.c.
> > kvmtool doesn't have a chr-testdev device, and because probing fails, the address
> > 0x0a000008 isn't ioremap'ed. The 0-1G memory region is not automatically mapped
> > anymore, and the access triggers a data abort at stage 1.
> > 
> > I fixed the splat with this change:
> > 
> > diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> > index 95c418c10eb4..ad9e44d71d8d 100644
> > --- a/arm/micro-bench.c
> > +++ b/arm/micro-bench.c
> > @@ -281,7 +281,7 @@ static void mmio_read_user_exec(void)
> >          * updated in the future if any relevant changes in QEMU
> >          * test-dev are made.
> >          */
> > -       void *userspace_emulated_addr = (void*)0x0a000008;
> > +       void *userspace_emulated_addr = (void*)ioremap(0x0a000008, 8);
> >  
> >         readl(userspace_emulated_addr);
> >  }
> > 
> > kvmtool ignores the MMIO exit reason if no device owns the IPA, that's why it also
> > works on kvmtool.
> > 
> > The micro-bench test with the diff passes under qemu and kvmtool, tested with 4K,
> > 16K and 64K pages on an odroid-c4.
> >
> 
> Thanks Alex,
> 
> I think a better fix is this untested one below, though. If you can test
> it out and confirm it also resolves the issue, then I'll add this patch
> to the series.
> 
> Thanks,
> drew
> 
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 95c418c10eb4..deafd5695c33 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -273,16 +273,22 @@ static void hvc_exec(void)
>         asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
>  }
>  
> -static void mmio_read_user_exec(void)
> +/*
> + * FIXME: Read device-id in virtio mmio here in order to
> + * force an exit to userspace. This address needs to be
> + * updated in the future if any relevant changes in QEMU
> + * test-dev are made.
> + */
> +static void *userspace_emulated_addr;
> +
> +static bool mmio_read_user_prep(void)
>  {
> -       /*
> -        * FIXME: Read device-id in virtio mmio here in order to
> -        * force an exit to userspace. This address needs to be
> -        * updated in the future if any relevant changes in QEMU
> -        * test-dev are made.
> -        */
> -       void *userspace_emulated_addr = (void*)0x0a000008;
> +       userspace_emulated_addr = (void*)ioremap(0x0a000008, 8);
> +       return true;
> +}
>  
> +static void mmio_read_user_exec(void)
> +{
>         readl(userspace_emulated_addr);
>  }
>  
> @@ -309,14 +315,14 @@ struct exit_test {
>  };
>  
>  static struct exit_test tests[] = {
> -       {"hvc",                 NULL,           hvc_exec,               NULL,           65536,          true},
> -       {"mmio_read_user",      NULL,           mmio_read_user_exec,    NULL,           65536,          true},
> -       {"mmio_read_vgic",      NULL,           mmio_read_vgic_exec,    NULL,           65536,          true},
> -       {"eoi",                 NULL,           eoi_exec,               NULL,           65536,          true},
> -       {"ipi",                 ipi_prep,       ipi_exec,               NULL,           65536,          true},
> -       {"ipi_hw",              ipi_hw_prep,    ipi_exec,               NULL,           65536,          true},
> -       {"lpi",                 lpi_prep,       lpi_exec,               NULL,           65536,          true},
> -       {"timer_10ms",          timer_prep,     timer_exec,             timer_post,     256,            true},
> +       {"hvc",                 NULL,                   hvc_exec,               NULL,           65536,          true},
> +       {"mmio_read_user",      mmio_read_user_prep,    mmio_read_user_exec,    NULL,           65536,          true},
> +       {"mmio_read_vgic",      NULL,                   mmio_read_vgic_exec,    NULL,           65536,          true},
> +       {"eoi",                 NULL,                   eoi_exec,               NULL,           65536,          true},
> +       {"ipi",                 ipi_prep,               ipi_exec,               NULL,           65536,          true},
> +       {"ipi_hw",              ipi_hw_prep,            ipi_exec,               NULL,           65536,          true},
> +       {"lpi",                 lpi_prep,               lpi_exec,               NULL,           65536,          true},
> +       {"timer_10ms",          timer_prep,             timer_exec,             timer_post,     256,            true},
>  };
>  
>  struct ns_time {
>

I still haven't tested it (beyond compiling), but I've tweaked this a bit.
You can see it here

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commit/71938030d160e021db3388037d0d407df17e8e5e

The whole v4 of this series is here

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/efiprep

Thanks,
drew

