Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E143684A4
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbhDVQR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:17:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236333AbhDVQR4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 12:17:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619108240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rUvviQIOi9Y9P/XzEfQpDeW3p/9xLDBgy3nAUN/GIMY=;
        b=XdxYAgvG66rub1SGilkUsOmINhYpTHOIHoDTcnoqra3Y/fVCjUhl3eH/ik7rRUaTTMLksG
        7dp1kmeZ0+LQtwqJNEd2NOVpjEYPm40vC/aqmWTnB6Jin99JFtneAWGOMGFJsFc9XOK2RX
        dHBhyvD7d02FZoYguZwrj02/oWWXWDk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-z61JU1qvOpawtUYDXiwbRQ-1; Thu, 22 Apr 2021 12:17:06 -0400
X-MC-Unique: z61JU1qvOpawtUYDXiwbRQ-1
Received: by mail-ej1-f69.google.com with SMTP id r17-20020a1709069591b029037cf6a4a56dso7456459ejx.12
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 09:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rUvviQIOi9Y9P/XzEfQpDeW3p/9xLDBgy3nAUN/GIMY=;
        b=gj9kyPgaaRVAjbwyxp2EsxfC1E8g/T03B1HH1v0EaBJfscaRhDOcI8Gjwg+JiQoxWZ
         SEBV1z9gdNoVLadxpioRi1gUng/03W7mYBvwLRkjjmTpVsxmc2jdB9/VMTBpl2KQXDRT
         PePeBKutR0NZZPYGzQgj/JlkkMc2hC20/G/avZ/Rs0pkBnO6SuxQML1mCPk6A5IDrafA
         RiX02UJrZcWO4Lbnyox06fcmm4W1SOggIcd0CqphoMx6qRodBrCs/mx9E9N5jeJZScyd
         nOVwwgHXTv77oA/rcKYkx7eky+scUQD290IL3mB1Tp1Q1CCWOPWsRODzd8Hyq3KoJIx5
         h98w==
X-Gm-Message-State: AOAM5309AEZ001HokCwwsNogeeNPMTOztLLDI3CnboWuOb4w0HPQYjRn
        Minv5L6j25Eih0423b/SN+gC4vK+5oFvmiNK0FtZICiYHVuh4j31gXX3LbYOk6lUHELrR/rkIbU
        VzSRpQtEwYuXfDr+iAL6vp40FiobVi4dYCk2PVB+T7k3jozcBUXjyfjHkqVgQWOk=
X-Received: by 2002:a17:906:c1c9:: with SMTP id bw9mr4276800ejb.239.1619108224752;
        Thu, 22 Apr 2021 09:17:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyux+HQZTvPFKICQBre1izroY5OihvxfjbEztF6dDUqmh9lyDuwb4M+HaN+5bIBzufoPsLSA==
X-Received: by 2002:a17:906:c1c9:: with SMTP id bw9mr4276766ejb.239.1619108224506;
        Thu, 22 Apr 2021 09:17:04 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id u24sm2476723edt.85.2021.04.22.09.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 09:17:04 -0700 (PDT)
Date:   Thu, 22 Apr 2021 18:17:02 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2 8/8] arm/arm64: psci: don't assume
 method is hvc
Message-ID: <20210422161702.76ucofe2pbj4oacc@gator>
References: <20210420190002.383444-1-drjones@redhat.com>
 <20210420190002.383444-9-drjones@redhat.com>
 <20210421070206.mbtarb4cge5ywyuv@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421070206.mbtarb4cge5ywyuv@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


For v3, I've done the following changes (inline)

On Wed, Apr 21, 2021 at 09:02:06AM +0200, Andrew Jones wrote:
> On Tue, Apr 20, 2021 at 09:00:02PM +0200, Andrew Jones wrote:
> > The method can also be smc and it will be when running on bare metal.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arm/cstart.S       | 22 ++++++++++++++++++++++
> >  arm/cstart64.S     | 22 ++++++++++++++++++++++
> >  arm/selftest.c     | 34 +++++++---------------------------
> >  lib/arm/asm/psci.h | 10 ++++++++--
> >  lib/arm/psci.c     | 37 +++++++++++++++++++++++++++++--------
> >  lib/arm/setup.c    |  2 ++
> >  6 files changed, 90 insertions(+), 37 deletions(-)
> > 
> > diff --git a/arm/cstart.S b/arm/cstart.S
> > index 446966de350d..2401d92cdadc 100644
> > --- a/arm/cstart.S
> > +++ b/arm/cstart.S
> > @@ -95,6 +95,28 @@ start:
> >  
> >  .text
> >  
> > +/*
> > + * psci_invoke_hvc / psci_invoke_smc
> > + *
> > + * Inputs:
> > + *   r0 -- function_id
> > + *   r1 -- arg0
> > + *   r2 -- arg1
> > + *   r3 -- arg2
> > + *
> > + * Outputs:
> > + *   r0 -- return code
> > + */
> > +.globl psci_invoke_hvc
> > +psci_invoke_hvc:
> > +	hvc	#0
> > +	mov	pc, lr
> > +
> > +.globl psci_invoke_smc
> > +psci_invoke_smc:
> > +	smc	#0
> > +	mov	pc, lr
> > +
> >  enable_vfp:
> >  	/* Enable full access to CP10 and CP11: */
> >  	mov	r0, #(3 << 22 | 3 << 20)
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index 42ba3a3ca249..7610e28f06dd 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -109,6 +109,28 @@ start:
> >  
> >  .text
> >  
> > +/*
> > + * psci_invoke_hvc / psci_invoke_smc
> > + *
> > + * Inputs:
> > + *   x0 -- function_id

changed this comment to be 'w0 -- function_id'

> > + *   x1 -- arg0
> > + *   x2 -- arg1
> > + *   x3 -- arg2
> > + *
> > + * Outputs:
> > + *   x0 -- return code
> > + */
> > +.globl psci_invoke_hvc
> > +psci_invoke_hvc:
> > +	hvc	#0
> > +	ret
> > +
> > +.globl psci_invoke_smc
> > +psci_invoke_smc:
> > +	smc	#0
> > +	ret
> > +
> >  get_mmu_off:
> >  	adrp	x0, auxinfo
> >  	ldr	x0, [x0, :lo12:auxinfo + 8]
> > diff --git a/arm/selftest.c b/arm/selftest.c
> > index 4495b161cdd5..9f459ed3d571 100644
> > --- a/arm/selftest.c
> > +++ b/arm/selftest.c
> > @@ -400,33 +400,13 @@ static void check_vectors(void *arg __unused)
> >  	exit(report_summary());
> >  }
> >  
> > -static bool psci_check(void)
> > +static void psci_print(void)
> >  {
> > -	const struct fdt_property *method;
> > -	int node, len, ver;
> > -
> > -	node = fdt_node_offset_by_compatible(dt_fdt(), -1, "arm,psci-0.2");
> > -	if (node < 0) {
> > -		printf("PSCI v0.2 compatibility required\n");
> > -		return false;
> > -	}
> > -
> > -	method = fdt_get_property(dt_fdt(), node, "method", &len);
> > -	if (method == NULL) {
> > -		printf("bad psci device tree node\n");
> > -		return false;
> > -	}
> > -
> > -	if (len < 4 || strcmp(method->data, "hvc") != 0) {
> > -		printf("psci method must be hvc\n");
> > -		return false;
> > -	}
> > -
> > -	ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> > -	printf("PSCI version %d.%d\n", PSCI_VERSION_MAJOR(ver),
> > -				       PSCI_VERSION_MINOR(ver));
> > -
> > -	return true;
> > +	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> > +	report_info("PSCI version: %d.%d", PSCI_VERSION_MAJOR(ver),
> > +					  PSCI_VERSION_MINOR(ver));
> > +	report_info("PSCI method: %s", psci_invoke == psci_invoke_hvc ?
> > +				       "hvc" : "smc");
> >  }
> >  
> >  static void cpu_report(void *data __unused)
> > @@ -465,7 +445,7 @@ int main(int argc, char **argv)
> >  
> >  	} else if (strcmp(argv[1], "smp") == 0) {
> >  
> > -		report(psci_check(), "PSCI version");
> > +		psci_print();
> >  		on_cpus(cpu_report, NULL);
> >  		while (!cpumask_full(&ready))
> >  			cpu_relax();
> > diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
> > index 7b956bf5987d..2820c0a3afc7 100644
> > --- a/lib/arm/asm/psci.h
> > +++ b/lib/arm/asm/psci.h
> > @@ -3,8 +3,14 @@
> >  #include <libcflat.h>
> >  #include <linux/psci.h>
> >  
> > -extern int psci_invoke(unsigned long function_id, unsigned long arg0,
> > -		       unsigned long arg1, unsigned long arg2);
> > +typedef int (*psci_invoke_fn)(unsigned long function_id, unsigned long arg0,
> > +			      unsigned long arg1, unsigned long arg2);
> > +extern psci_invoke_fn psci_invoke;
> > +extern int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
> > +			   unsigned long arg1, unsigned long arg2);
> > +extern int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
> > +			   unsigned long arg1, unsigned long arg2);

The prototypes are now

long invoke_fn(unsigned int function_id, unsigned long arg0,
               unsigned long arg1, unsigned long arg2)

Notice the return value changed to long and the function_id to
unsigned int.


I also improved the commit message by adding the following:

   The method can be smc in addition to hvc, and it will be when running
   on bare metal. Additionally, we move the invocations to assembly so
   we don't have to rely on compiler assumptions. We also fix the
   prototype of psci_invoke. It should return long, not int, and
   function_id should be an unsigned int, not an unsigned long.

Thanks,
drew

