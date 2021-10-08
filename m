Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB73C4264A0
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 08:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhJHGaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 02:30:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229585AbhJHGaz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 02:30:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633674539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=66bdpyzPAZfft1eFWrlXRX9Ag9oSCJ0WcnS1e0+91qA=;
        b=C8/MoGtR1rLGOJHaEQtNQh2Kt/LGu9Dfqpg8av6iBZaCUKunEk9H3uwXLIZAouhBU2nAFu
        BgZjztWsHGMlhYTL/4BVMcs0g8cg4hJbp0c9O5SPqkDRe3wAmG8pxoRKH0QDG3AJdW6dtW
        F0KWoA4dydvoBANVf1YSloPmoyLAIV8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-caHxTirENqmsZLZYleHDWQ-1; Fri, 08 Oct 2021 02:28:58 -0400
X-MC-Unique: caHxTirENqmsZLZYleHDWQ-1
Received: by mail-ed1-f71.google.com with SMTP id z13-20020aa7c64d000000b003db3a3c396dso7125555edr.9
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 23:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=66bdpyzPAZfft1eFWrlXRX9Ag9oSCJ0WcnS1e0+91qA=;
        b=L8oGzmNEeofKbndAdxPKpCAIi/xs6+P88Jdn0u4AZle+aJinFmsv3a67opv4zpQoQc
         pxc5k1SYNe++SUbmH2J+ns9t+mmjJdWjFI4pMevMJfOs3RNle5MZ6JXh+XDb51vD4j/y
         X8Ay0viOxR33JRoRZDbxQ7xUI2t5WsdcuarBtd5b63hETh4z+jEYYACZKXOU7ag5+2Wa
         NwALpXOgQjEqVeWCC0S6zrri7JrRkhTAx5xnpHvjZtPa1PG+AYTY/WtG/GdNAIW5AHnC
         MIJ8sCQkQ6T057KFg1sXBcNIODHdRfuACR9XFYfaYI/40lr+wXTIzDsAn5t3Gifs23js
         nGbw==
X-Gm-Message-State: AOAM531tshwnRGD5saF2B94Fd7QxrKMjfSHdvolu6lWL/JnQr1vUDHzV
        FSzSs7gWyHKqCdPyIGVTqQm73q3usKFi7WhSaUh12ul89HNwzi0EQ0++7DtuwssRV6oG3XOdCrr
        KsNhUI29jUsUJ
X-Received: by 2002:a17:906:1184:: with SMTP id n4mr1993363eja.87.1633674537435;
        Thu, 07 Oct 2021 23:28:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJyExn0FhyzPo+C2Jqjvn16Uv3O8XDMg4nsVAS9tztBxtKjG/slYlHcTGscY/joHF7R/qWPA==
X-Received: by 2002:a17:906:1184:: with SMTP id n4mr1993350eja.87.1633674537256;
        Thu, 07 Oct 2021 23:28:57 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id d25sm609109edt.51.2021.10.07.23.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 23:28:56 -0700 (PDT)
Date:   Fri, 8 Oct 2021 08:28:55 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: Add mmio_addr arg to
 arm/micro-bench
Message-ID: <20211008062855.3g34sxevl6w3gn6h@gator.home>
References: <20211007183230.2637929-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007183230.2637929-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 07, 2021 at 11:32:30AM -0700, Ricardo Koller wrote:
> Add a command line arg to arm/micro-bench to set the mmio_addr to other
> values besides the default QEMU one. Default to the QEMU value if no arg
> is passed. Also, the <NUM> in mmio_addr=<NUM> can't be a hex.

I'll send this patch

diff --git a/lib/util.c b/lib/util.c
index a90554138952..682ca2db09e6 100644
--- a/lib/util.c
+++ b/lib/util.c
@@ -4,6 +4,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <stdlib.h>
 #include "util.h"
 
 int parse_keyval(char *s, long *val)
@@ -14,6 +15,6 @@ int parse_keyval(char *s, long *val)
        if (!p)
                return -1;
 
-       *val = atol(p+1);
+       *val = strtol(p+1, NULL, 0);
        return p - s;
 }


which ought to improve that.

> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/micro-bench.c | 33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 8e1d4ab..2c08813 100644
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
> @@ -278,12 +281,10 @@ static void *userspace_emulated_addr;
>  static bool mmio_read_user_prep(void)
>  {
>  	/*
> -	 * FIXME: Read device-id in virtio mmio here in order to
> -	 * force an exit to userspace. This address needs to be
> -	 * updated in the future if any relevant changes in QEMU
> -	 * test-dev are made.

I think the FIXME is still relavent, even with the user given control over
the address. The FIXME text could be improved though, because it's not
clear what it's trying to say, which is

 /*
  * FIXME: We need an MMIO address that we can safely read to test
  * exits to userspace. Ideally, the test-dev would provide us this
  * address (and one we could write to too), but until it does we
  * use a virtio-mmio transport address. FIXME2: We should be getting
  * this address (and the future test-dev address) from the devicetree,
  * but so far we lazily hardcode it.
  */

> +	 * Read device-id in virtio mmio here in order to
> +	 * force an exit to userspace.
>  	 */
> -	userspace_emulated_addr = (void*)ioremap(0x0a000008, sizeof(u32));
> +	userspace_emulated_addr = (void *)ioremap(mmio_addr, sizeof(u32));
>  	return true;
>  }
>  
> @@ -378,10 +379,30 @@ static void loop_test(struct exit_test *test)
>  		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
>  }
>  
> +static void parse_args(int argc, char **argv)
> +{
> +	int i, len;
> +	long val;
> +
> +	for (i = 0; i < argc; ++i) {
                 ^ should be 1, since we know argv[0] is prognam

> +		len = parse_keyval(argv[i], &val);
> +		if (len == -1)
> +			continue;
> +
> +		argv[i][len] = '\0';

Not nice to write to the global args, especially when we're not yet sure
if this arg is the one we care about.

> +		if (strcmp(argv[i], "mmio-addr") == 0) {

Can use strncmp to avoid the not nice args write,

 strncmp(argv[i], "mmio-addr", len)

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

Thanks,
drew 

