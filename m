Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E7442926E
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 16:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbhJKOqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 10:46:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238974AbhJKOqe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 10:46:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633963473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Vj8W7APBY2fyggKtVX8y6tenS0g5ttledn1kYzTma0=;
        b=RhvqJL7pkJVx2PpAI4jaWzTCvgEioD/pcwfYR7b9woYch8FhIHIxVarTrQzLqwVSj7/yPM
        xR2w0u8k4w1WAKfXujXzX2UQC/nZXzkdastkpu22hNSTrj7zedkTNszSewz2hTfScf9zY1
        Ew40o2xT6iKEvtfD/b6boVNJZAHBKao=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-lGlq3WtTO3ufzzASeiCT7Q-1; Mon, 11 Oct 2021 10:44:32 -0400
X-MC-Unique: lGlq3WtTO3ufzzASeiCT7Q-1
Received: by mail-wr1-f69.google.com with SMTP id y12-20020a056000168c00b00160da4de2c7so10375315wrd.5
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 07:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Vj8W7APBY2fyggKtVX8y6tenS0g5ttledn1kYzTma0=;
        b=0W4vVJe5SZzOc4DepL2Sd9N1cAZ5gJsPSqxep0Wfai3JGjuQ2vAwYwAj1uCX9tTWNn
         fBx1b4SP5gd9KPTDK8J7OpjE/7bQ7alBH49ys9OiT4RltPk5pnhAmtTxkAeoAu2bEsGT
         f/WIGMjXzglrtj8IblTQbQpcOHliyPsbK6l1ffoFHz3mT5d+2KSzmrKeAeDyNXy2TGC8
         xZuKo9FLprc2ZdVSIKixFjCg3pb1e6Z3uVw16BOag88NeUGuUNBx+Tn7sR4yRObDYO1Y
         9rn1XkEx1RNZOc+8oNZ1d/x58vqWZd1YJiK4A7z5jgHaNQoeXJ8ozpFwmM0kVGRF+Nyy
         y5aw==
X-Gm-Message-State: AOAM532KYafHstR7uU+WeSDxPjqQoYfXYHERNTzAZB+gwan3tA/BGXyx
        kXJpBkQ61mz9987opnkjpo3sc02gEM/7TjrvHsSRZWJ3/KUyLTVKFeTiui7++MURDsJcGdq616E
        cP6dje2jh7nrg
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr13094959wmj.146.1633963471457;
        Mon, 11 Oct 2021 07:44:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmedNib3+ZpDnLKlxj3BpgqbufyGqCa7JQZrW0+0LhmbffbNezRzXKtVLjHQgbYRWhOqo6HA==
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr13094938wmj.146.1633963471217;
        Mon, 11 Oct 2021 07:44:31 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id k17sm7884449wrc.93.2021.10.11.07.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 07:44:30 -0700 (PDT)
Date:   Mon, 11 Oct 2021 16:44:29 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add mmio_addr arg to
 arm/micro-bench
Message-ID: <20211011144429.26hn2tpeczbffwcs@gator>
References: <20211008174022.3028983-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008174022.3028983-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 08, 2021 at 10:40:22AM -0700, Ricardo Koller wrote:
> Add a command line arg to arm/micro-bench to set the mmio_addr to other
> values besides the default QEMU one. Default to the QEMU value if no arg
> is passed.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/micro-bench.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 8e1d4ab..c731b1d 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -19,16 +19,19 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <libcflat.h>
> +#include <util.h>
>  #include <asm/gic.h>
>  #include <asm/gic-v3-its.h>
>  #include <asm/timer.h>
>  
> -#define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
> +#define NS_5_SECONDS		(5 * 1000 * 1000 * 1000UL)
> +#define QEMU_MMIO_ADDR		0x0a000008
>  
>  static u32 cntfrq;
>  
>  static volatile bool irq_ready, irq_received;
>  static int nr_ipi_received;
> +static unsigned long mmio_addr = QEMU_MMIO_ADDR;
>  
>  static void *vgic_dist_base;
>  static void (*write_eoir)(u32 irqstat);
> @@ -278,12 +281,14 @@ static void *userspace_emulated_addr;
>  static bool mmio_read_user_prep(void)
>  {
>  	/*
> -	 * FIXME: Read device-id in virtio mmio here in order to
> -	 * force an exit to userspace. This address needs to be
> -	 * updated in the future if any relevant changes in QEMU
> -	 * test-dev are made.
> +	 * FIXME: We need an MMIO address that we can safely read to test
> +	 * exits to userspace. Ideally, the test-dev would provide us this
> +	 * address (and one we could write to too), but until it does we
> +	 * use a virtio-mmio transport address. FIXME2: We should be getting
> +	 * this address (and the future test-dev address) from the devicetree,
> +	 * but so far we lazily hardcode it.
>  	 */
> -	userspace_emulated_addr = (void*)ioremap(0x0a000008, sizeof(u32));
> +	userspace_emulated_addr = (void *)ioremap(mmio_addr, sizeof(u32));
>  	return true;
>  }
>  
> @@ -378,10 +383,29 @@ static void loop_test(struct exit_test *test)
>  		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
>  }
>  
> +static void parse_args(int argc, char **argv)
> +{
> +	int i, len;
> +	long val;
> +
> +	for (i = 1; i < argc; ++i) {
> +		len = parse_keyval(argv[i], &val);
> +		if (len == -1)
> +			continue;
> +
> +		if (strncmp(argv[i], "mmio-addr", len) == 0) {
> +			mmio_addr = val;
> +			report_info("found mmio_addr=0x%lx", mmio_addr);
> +		}
> +	}
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	int i;
>  
> +	parse_args(argc, argv);
> +
>  	if (!test_init())
>  		return 1;
>  
> -- 
> 2.33.0.882.g93a45727a2-goog
>

Pushed

Thanks,
drew 

