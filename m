Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD4655016A
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 02:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358481AbiFRAiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 20:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbiFRAiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 20:38:08 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7AB2AC50
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 17:38:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d13so5115308plh.13
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 17:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rVrqXDo0tSbjEZ2PFx7oaAYlhv3FIN4HP2sOqRT4O8w=;
        b=WwOMpakC1dJm4I/Mg5Y++XeWZzgLIDvxAfHYYk81Wdg2cCj4OmmTFG3peORQ1JZn9x
         7DxzJB4YlIO7stLXdxlrZgmqHpbqkvRnLZrcyvLIREQEsqYrTtXGF222o4vjIAn1h3Yt
         jdkiqwYWQmIkHi7Kx4mdOx+d4zJQpuv5+koc0g57qGyv104ZlYWuVhsxDnB4Y9QSCaRx
         RoWEt9OLBmBTzV90I5bFc3m5M/9u614SZc7zN3EOYKvdmJe7CKRKDvn8wbsKx0SC+5Dr
         2edpui4IMrjRSvkitn7RhUzf2mv4tP0hAzmMzQuSAM3zUwO8Cpo+Mh1aIw7QV4K3YG1Z
         WFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rVrqXDo0tSbjEZ2PFx7oaAYlhv3FIN4HP2sOqRT4O8w=;
        b=rm1wbD1KUHu1Xahch0c6tzu4UGvh0iVMKY5yuzq4VhyZcjhqzjlvAhakqblmxjj6w5
         cg+AEZHJR7OW7hrGeK9XKwfQ3srUCT1iJylW0Q8C15sOk16k07n5lIpHC/8Z9wpsfVBT
         /SmjqRpHrSwOREl9acNzrHqt84P588nbOgGSbBhsCapzldxhhZpPguPCKeozplJncuOs
         PZ5gUD0Uo1mjGEtab9wOKQe88xZhlPIwmDcv7jznOeyMSQTFf+py5i3QOHul7WEsAaT6
         URNboG+PlCh8/iKNFuxS4gG+lZHdhU0SiWklDFk+26YrC0XFSv+TMiF9HdBgu/EvaB3O
         g2fw==
X-Gm-Message-State: AJIora8KEkR6ECDrntBqzQ+Kj9BFMBGWq4+UhVdCM/fX0UOi/1jnJQ55
        GSq3l0OoGQpnTAV+t0qoMq79HA==
X-Google-Smtp-Source: AGRyM1sjQpW2v09iDM1lxZV1gIfjMPQpmwQFRO3hVHxYIOvjPvc6xHG4ipxz/hYprLfsw8en9SLisg==
X-Received: by 2002:a17:903:284:b0:168:4d1a:3ccc with SMTP id j4-20020a170903028400b001684d1a3cccmr12421491plr.78.1655512685168;
        Fri, 17 Jun 2022 17:38:05 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id p22-20020a637416000000b003fcfdc9946dsm4408797pgc.51.2022.06.17.17.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 17:38:04 -0700 (PDT)
Date:   Fri, 17 Jun 2022 17:38:01 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 03/23] lib: Add support for the XSDT
 ACPI table
Message-ID: <Yq0eaaOiud8pOXZN@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-4-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-4-nikos.nikoleris@arm.com>
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

Hi Nikos,

On Fri, May 06, 2022 at 09:55:45PM +0100, Nikos Nikoleris wrote:
> XSDT provides pointers to other ACPI tables much like RSDT. However,
> contrary to RSDT that provides 32-bit addresses, XSDT provides 64-bit
> pointers. ACPI requires that if XSDT is valid then it takes precedence
> over RSDT.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/acpi.h |   6 ++++
>  lib/acpi.c | 103 ++++++++++++++++++++++++++++++++---------------------
>  2 files changed, 68 insertions(+), 41 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 42a2c16..d80b983 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -13,6 +13,7 @@
>  
>  #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
>  #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
> +#define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>  #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>  #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
>  
> @@ -56,6 +57,11 @@ struct rsdt_descriptor_rev1 {
>      u32 table_offset_entry[0];
>  } __attribute__ ((packed));
>  
> +struct acpi_table_xsdt {
> +    ACPI_TABLE_HEADER_DEF
> +    u64 table_offset_entry[1];

nit: This should be "[0]" to match the usage above (in rsdt).

I was about to suggest using an unspecified size "[]", but after reading
what the C standard says about it (below), now I'm not sure. was the
"[1]" needed for something that I'm missing?

	106) The length is unspecified to allow for the fact that
	implementations may give array members different
	alignments according to their lengths.


> +} __attribute__ ((packed));
> +
>  struct fadt_descriptor_rev1
>  {
>      ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
> diff --git a/lib/acpi.c b/lib/acpi.c
> index de275ca..9b8700c 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -38,45 +38,66 @@ static struct rsdp_descriptor *get_rsdp(void)
>  
>  void* find_acpi_table_addr(u32 sig)

nit: This one could also be fixed as well: "void *".

>  {
> -    struct rsdp_descriptor *rsdp;
> -    struct rsdt_descriptor_rev1 *rsdt;
> -    void *end;
> -    int i;
> -
> -    /* FACS is special... */
> -    if (sig == FACS_SIGNATURE) {
> -        struct fadt_descriptor_rev1 *fadt;
> -        fadt = find_acpi_table_addr(FACP_SIGNATURE);
> -        if (!fadt) {
> -            return NULL;
> -        }
> -        return (void*)(ulong)fadt->firmware_ctrl;
> -    }
> -
> -    rsdp = get_rsdp();
> -    if (rsdp == NULL) {
> -        printf("Can't find RSDP\n");
> -        return 0;
> -    }
> -
> -    if (sig == RSDP_SIGNATURE) {
> -        return rsdp;
> -    }
> -
> -    rsdt = (void*)(ulong)rsdp->rsdt_physical_address;
> -    if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
> -        return 0;
> -
> -    if (sig == RSDT_SIGNATURE) {
> -        return rsdt;
> -    }
> -
> -    end = (void*)rsdt + rsdt->length;
> -    for (i=0; (void*)&rsdt->table_offset_entry[i] < end; i++) {
> -        struct acpi_table *t = (void*)(ulong)rsdt->table_offset_entry[i];
> -        if (t && t->signature == sig) {
> -            return t;
> -        }
> -    }
> -   return NULL;
> +	struct rsdp_descriptor *rsdp;
> +	struct rsdt_descriptor_rev1 *rsdt;
> +	struct acpi_table_xsdt *xsdt = NULL;
> +	void *end;
> +	int i;
> +
> +	/* FACS is special... */
> +	if (sig == FACS_SIGNATURE) {
> +		struct fadt_descriptor_rev1 *fadt;
> +
> +		fadt = find_acpi_table_addr(FACP_SIGNATURE);
> +		if (!fadt)
> +			return NULL;
> +
> +		return (void*)(ulong)fadt->firmware_ctrl;
> +	}
> +
> +	rsdp = get_rsdp();
> +	if (rsdp == NULL) {
> +		printf("Can't find RSDP\n");
> +		return 0;
> +	}
> +
> +	if (sig == RSDP_SIGNATURE)
> +		return rsdp;
> +
> +	rsdt = (void *)(ulong)rsdp->rsdt_physical_address;
> +	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
> +		rsdt = NULL;
> +
> +	if (sig == RSDT_SIGNATURE)
> +		return rsdt;
> +
> +	if (rsdp->revision > 1)
> +		xsdt = (void *)(ulong)rsdp->xsdt_physical_address;
> +	if (!xsdt || xsdt->signature != XSDT_SIGNATURE)
> +		xsdt = NULL;
> +

To simplify this function a bit, finding the xsdt could be moved to some
kind of init function.

> +	if (sig == XSDT_SIGNATURE)
> +		return xsdt;
> +
> +	// APCI requires that we first try to use XSDT if it's valid,
> +	//  we use to find other tables, otherwise we use RSDT.
> +	if (xsdt) {
> +		end = (void *)(ulong)xsdt + xsdt->length;
> +		for (i = 0; (void *)&xsdt->table_offset_entry[i] < end; i++) {
> +			struct acpi_table *t =
> +				(void *)xsdt->table_offset_entry[i];
> +			if (t && t->signature == sig)
> +				return t;
> +		}
> +	} else if (rsdt) {
> +		end = (void *)rsdt + rsdt->length;
> +		for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
> +			struct acpi_table *t =
> +				(void *)(ulong)rsdt->table_offset_entry[i];
> +			if (t && t->signature == sig)
> +				return t;
> +		}
> +	}

The two for-loops could be moved into some common function, or maybe a
macro to deal with the fact that it deals with two different structures
(the rsdt and the xsdt). This is my attempt at making it a function:

void *scan_system_descriptor_table(void *dt)
{
	int i;
	void *end;
	/* XXX: Not sure if this is the nicest thing to do, but the rsdt
	 * and the xsdt have "length" and "table_offset_entry" at the
	 * same offsets. */
	struct acpi_table_xsdt *xsdt = dt;

	end = (void *)(ulong)xsdt + xsdt->length;
	for (i = 0; &xsdt->table_offset_entry[i] < end; i++) {
		struct acpi_table *t = (void *)xsdt->table_offset_entry[i];
		if (t && t->signature == sig)
			return t;
}

Thanks,
Ricardo

> +
> +	return NULL;
>  }
> -- 
> 2.25.1
> 
