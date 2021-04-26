Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F5336B6EB
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 18:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhDZQgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 12:36:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233934AbhDZQgf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 12:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619454953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MeCuE/FPlAgVvZjVieoLf7RsSfzfqrjVGkfOcQGCeWk=;
        b=aEgqlM36nu69uptWqFbGdu8eBkHADoH2QTU1OZIh2aGDwrGizn3uYzXc7EcFFFfSJb+Rwi
        6sZ8Bfi1O43Bu4eoIXzt33JSA5VGwI7EUHavrD2TYQk+Q8HRNhWO93vkLLY1GQfjddM7+4
        TQbV6MLOkq4Vcf5pIy8mH7AW/BAPtZs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-XtzPlfZNMsuyoTQ2-wKoFQ-1; Mon, 26 Apr 2021 12:35:51 -0400
X-MC-Unique: XtzPlfZNMsuyoTQ2-wKoFQ-1
Received: by mail-ed1-f71.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso23287144edb.4
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 09:35:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MeCuE/FPlAgVvZjVieoLf7RsSfzfqrjVGkfOcQGCeWk=;
        b=et4GKTgf3XKlIcXZ1xD0muNLCziqznAZE/NH0t0EOUGdp0UQin5nK08ico+KFkrw8r
         pvLgKoQJH8iNDhLm/FVru504iRx2k9tC+3F3Fe5X0LqfGCkLnYn53YARE1OszwKmKdkP
         QtLZWqeYorm5KM47JNpVZ8JCBerzX0tQuguz5Fhk4mUYf6f7Eba4C8lF1CrK+9I0gGoQ
         agF27zyKD1vAO25UCPGAkYmpzHeleCPIgaA37MeDHj0jvFA1jzD/XzWNPSJW9azcYLeT
         JQtfN0Ci9x7k1xkkOUyjJQoTW7zJ9V8HLFtKpSjupj14y+6NEFM2a0C61Ox5tNnviwGK
         YWpg==
X-Gm-Message-State: AOAM530VFdxrId1ckcLgycG2jSRm4t7eRdppViLM9cQK3skwxQ44X3lt
        tVX61h5oFSK7KwpxFF2qUj0mGkaB/YzdehOL4faQFEmvRJAwZeOnfzGpNWaZIkSeWY5n+WAdHKm
        yVS5uphxT/5vj
X-Received: by 2002:a17:906:ece4:: with SMTP id qt4mr19783523ejb.514.1619454950534;
        Mon, 26 Apr 2021 09:35:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8S5lXe4sj2eQW+PXlx4o7/9vNCErYeYssXv7N/970cayp1KqcVKgUcG0Kk3Ud8be8p2kg+g==
X-Received: by 2002:a17:906:ece4:: with SMTP id qt4mr19783506ejb.514.1619454950308;
        Mon, 26 Apr 2021 09:35:50 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id p18sm6395797ejb.19.2021.04.26.09.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 09:35:49 -0700 (PDT)
Date:   Mon, 26 Apr 2021 18:35:43 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2 8/8] arm/arm64: psci: don't assume
 method is hvc
Message-ID: <20210426163543.rus23uuwoalcqgas@gator>
References: <20210420190002.383444-1-drjones@redhat.com>
 <20210420190002.383444-9-drjones@redhat.com>
 <20210421070206.mbtarb4cge5ywyuv@gator.home>
 <20210422161702.76ucofe2pbj4oacc@gator>
 <c36ad6f1-a48f-02f0-27c9-e18d9efe3023@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c36ad6f1-a48f-02f0-27c9-e18d9efe3023@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021 at 03:57:34PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 4/22/21 5:17 PM, Andrew Jones wrote:
> > For v3, I've done the following changes (inline)
> >
> > On Wed, Apr 21, 2021 at 09:02:06AM +0200, Andrew Jones wrote:
> >> On Tue, Apr 20, 2021 at 09:00:02PM +0200, Andrew Jones wrote:
> >>> The method can also be smc and it will be when running on bare metal.
> >>>
> >>> Signed-off-by: Andrew Jones <drjones@redhat.com>
> >>> ---
> >>>  arm/cstart.S       | 22 ++++++++++++++++++++++
> >>>  arm/cstart64.S     | 22 ++++++++++++++++++++++
> >>>  arm/selftest.c     | 34 +++++++---------------------------
> >>>  lib/arm/asm/psci.h | 10 ++++++++--
> >>>  lib/arm/psci.c     | 37 +++++++++++++++++++++++++++++--------
> >>>  lib/arm/setup.c    |  2 ++
> >>>  6 files changed, 90 insertions(+), 37 deletions(-)
> >>>
> >>> diff --git a/arm/cstart.S b/arm/cstart.S
> >>> index 446966de350d..2401d92cdadc 100644
> >>> --- a/arm/cstart.S
> >>> +++ b/arm/cstart.S
> >>> @@ -95,6 +95,28 @@ start:
> >>>  
> >>>  .text
> >>>  
> >>> +/*
> >>> + * psci_invoke_hvc / psci_invoke_smc
> >>> + *
> >>> + * Inputs:
> >>> + *   r0 -- function_id
> >>> + *   r1 -- arg0
> >>> + *   r2 -- arg1
> >>> + *   r3 -- arg2
> >>> + *
> >>> + * Outputs:
> >>> + *   r0 -- return code
> >>> + */
> >>> +.globl psci_invoke_hvc
> >>> +psci_invoke_hvc:
> >>> +	hvc	#0
> >>> +	mov	pc, lr
> >>> +
> >>> +.globl psci_invoke_smc
> >>> +psci_invoke_smc:
> >>> +	smc	#0
> >>> +	mov	pc, lr
> >>> +
> >>>  enable_vfp:
> >>>  	/* Enable full access to CP10 and CP11: */
> >>>  	mov	r0, #(3 << 22 | 3 << 20)
> >>> diff --git a/arm/cstart64.S b/arm/cstart64.S
> >>> index 42ba3a3ca249..7610e28f06dd 100644
> >>> --- a/arm/cstart64.S
> >>> +++ b/arm/cstart64.S
> >>> @@ -109,6 +109,28 @@ start:
> >>>  
> >>>  .text
> >>>  
> >>> +/*
> >>> + * psci_invoke_hvc / psci_invoke_smc
> >>> + *
> >>> + * Inputs:
> >>> + *   x0 -- function_id
> > changed this comment to be 'w0 -- function_id'
> >
> >>> + *   x1 -- arg0
> >>> + *   x2 -- arg1
> >>> + *   x3 -- arg2
> >>> + *
> >>> + * Outputs:
> >>> + *   x0 -- return code
> >>> + */
> >>> +.globl psci_invoke_hvc
> >>> +psci_invoke_hvc:
> >>> +	hvc	#0
> >>> +	ret
> >>> +
> >>> +.globl psci_invoke_smc
> >>> +psci_invoke_smc:
> >>> +	smc	#0
> >>> +	ret
> >>> +
> >>>  get_mmu_off:
> >>>  	adrp	x0, auxinfo
> >>>  	ldr	x0, [x0, :lo12:auxinfo + 8]
> >>> diff --git a/arm/selftest.c b/arm/selftest.c
> >>> index 4495b161cdd5..9f459ed3d571 100644
> >>> --- a/arm/selftest.c
> >>> +++ b/arm/selftest.c
> >>> @@ -400,33 +400,13 @@ static void check_vectors(void *arg __unused)
> >>>  	exit(report_summary());
> >>>  }
> >>>  
> >>> -static bool psci_check(void)
> >>> +static void psci_print(void)
> >>>  {
> >>> -	const struct fdt_property *method;
> >>> -	int node, len, ver;
> >>> -
> >>> -	node = fdt_node_offset_by_compatible(dt_fdt(), -1, "arm,psci-0.2");
> >>> -	if (node < 0) {
> >>> -		printf("PSCI v0.2 compatibility required\n");
> >>> -		return false;
> >>> -	}
> >>> -
> >>> -	method = fdt_get_property(dt_fdt(), node, "method", &len);
> >>> -	if (method == NULL) {
> >>> -		printf("bad psci device tree node\n");
> >>> -		return false;
> >>> -	}
> >>> -
> >>> -	if (len < 4 || strcmp(method->data, "hvc") != 0) {
> >>> -		printf("psci method must be hvc\n");
> >>> -		return false;
> >>> -	}
> >>> -
> >>> -	ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> >>> -	printf("PSCI version %d.%d\n", PSCI_VERSION_MAJOR(ver),
> >>> -				       PSCI_VERSION_MINOR(ver));
> >>> -
> >>> -	return true;
> >>> +	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> >>> +	report_info("PSCI version: %d.%d", PSCI_VERSION_MAJOR(ver),
> >>> +					  PSCI_VERSION_MINOR(ver));
> >>> +	report_info("PSCI method: %s", psci_invoke == psci_invoke_hvc ?
> >>> +				       "hvc" : "smc");
> >>>  }
> >>>  
> >>>  static void cpu_report(void *data __unused)
> >>> @@ -465,7 +445,7 @@ int main(int argc, char **argv)
> >>>  
> >>>  	} else if (strcmp(argv[1], "smp") == 0) {
> >>>  
> >>> -		report(psci_check(), "PSCI version");
> >>> +		psci_print();
> >>>  		on_cpus(cpu_report, NULL);
> >>>  		while (!cpumask_full(&ready))
> >>>  			cpu_relax();
> >>> diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
> >>> index 7b956bf5987d..2820c0a3afc7 100644
> >>> --- a/lib/arm/asm/psci.h
> >>> +++ b/lib/arm/asm/psci.h
> >>> @@ -3,8 +3,14 @@
> >>>  #include <libcflat.h>
> >>>  #include <linux/psci.h>
> >>>  
> >>> -extern int psci_invoke(unsigned long function_id, unsigned long arg0,
> >>> -		       unsigned long arg1, unsigned long arg2);
> >>> +typedef int (*psci_invoke_fn)(unsigned long function_id, unsigned long arg0,
> >>> +			      unsigned long arg1, unsigned long arg2);
> >>> +extern psci_invoke_fn psci_invoke;
> >>> +extern int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
> >>> +			   unsigned long arg1, unsigned long arg2);
> >>> +extern int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
> >>> +			   unsigned long arg1, unsigned long arg2);
> > The prototypes are now
> >
> > long invoke_fn(unsigned int function_id, unsigned long arg0,
> >                unsigned long arg1, unsigned long arg2)
> >
> > Notice the return value changed to long and the function_id to
> > unsigned int.
> 
> Strictly speaking, arm always returns an unsigned long (32bits), but arm64 can
> return either an unsigned long (64bits) when using SMC64/HVC64, or an unsigned int
> (32bits) when using SMC32/HVC32.

Hmm, where did you see that? Because section 5.1 of the SMC calling
convention disagrees

"""
5.1 Error codes
Errors codes that are returned in R0, W0 and X0 are signed integers of the
appropriate size:
* In AArch32:
  o When using the SMC32/HVC32 calling convention, error codes, which are
    returned in R0, are 32-bit signed integers.
* In AArch64:
  o When using the SMC64/HVC64 calling convention, error codes, which are
    returned in X0, are 64-bit signed integers.
  o When using the SMC32/HVC32 calling convention, error codes, which are
    returned in W0, are 32-bit signed integers. X0[63:32] is UNDEFINED.
"""

And 5.2.2 from the Power State Coordination Interface manual

"""
5.2.2 Return error codes
Table 6 defines the values for error codes used with PSCI functions. All
errors are considered to be 32-bit signed integers.
"""

Thanks,
drew

