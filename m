Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525F552D414
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238941AbiESNbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239103AbiESNbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:31:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C55DFB5A
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652967062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ffzx9wGkT5wlV7c6Z4hj/te6b5+TFfNhlnjuC9CE4ko=;
        b=iHPmocydiwCBdgFuhz/9XehZM6SMk44Ot9FC+g3fc9J+KSay2HuNwUsfpq/WJdBEfkIp6w
        W/tyr1VQIB8E7ul6N2Jaz2p+k5PsiiVp3svs19psGT3p4UVSGWP1LYtS3O3a2XsBqI1Lex
        1I1tsw2Tvi1TvhIGvcB1yyAcYaAiaXU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-V2R8i86aM4GNpbjELEJB8g-1; Thu, 19 May 2022 09:30:59 -0400
X-MC-Unique: V2R8i86aM4GNpbjELEJB8g-1
Received: by mail-wr1-f69.google.com with SMTP id u26-20020adfb21a000000b0020ac48a9aa4so1566817wra.5
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:30:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ffzx9wGkT5wlV7c6Z4hj/te6b5+TFfNhlnjuC9CE4ko=;
        b=wYuUY90cP42acEbpUy/42OhB1jZZ2MFElBk4OK8m1ckc/0q3gmLss2LBNqf0wBY/mt
         lqpNI3cwnQnuIKCt7Hmt+HetvS5RMQGCam2prbLBZlWNxLBAWfjrHNCY++SDjOl8S9Sm
         UxhTCb3IYIV+i9ubrkE8jngFPsWnWLKS6NHi4K0+kkySJo5g9TEeNaZMxlUB1monfEB1
         gnp1hH3/ioo61iBgaKIm91OfuP+CjtKX1FedLVHX4YwJoLDajfJdFdazXlGTJIZePy0A
         e/PFMyZCBHgRMLYVl2+XMZ27oUxDghj9zMJOeh4KTWCmtLugumdjhLlYd1nbBdLicI2C
         iUOA==
X-Gm-Message-State: AOAM533r57O2Bs1RoLqln53NOcXjm1XtY0nFXKGsC8cweic1cCMsQ0gq
        870f129TVVR5PtsAo6jezwXOz9E3Rx8hBin6IhPsuH0pM8Xao85qrxYNi2eqxWedlzMJYV34Ijs
        F5bloUwNLoLe2
X-Received: by 2002:a7b:c401:0:b0:397:26fb:ebf7 with SMTP id k1-20020a7bc401000000b0039726fbebf7mr3939844wmi.90.1652967057776;
        Thu, 19 May 2022 06:30:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvky8ssQcwaWe78kzJXatrtfXXtQl7A6U+KvRNrLu216KeqKVuwElwEvaZA58Xnk2qgh7d1w==
X-Received: by 2002:a7b:c401:0:b0:397:26fb:ebf7 with SMTP id k1-20020a7bc401000000b0039726fbebf7mr3939827wmi.90.1652967057573;
        Thu, 19 May 2022 06:30:57 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id m13-20020a7bcf2d000000b003942a244f47sm6693424wmg.32.2022.05.19.06.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 06:30:57 -0700 (PDT)
Date:   Thu, 19 May 2022 15:30:55 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 03/23] lib: Add support for the XSDT
 ACPI table
Message-ID: <20220519133055.zous23go2tkfdlqe@gator>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-4-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-4-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Let's definitely fix the coding style earlier in the series. Either while
moving the file or as another patch right after moving the file. That, or
use the old style for this file when updating it, since we don't want to
mix styles in the same file.

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
> +	if (sig == XSDT_SIGNATURE)
> +		return xsdt;
> +
> +	// APCI requires that we first try to use XSDT if it's valid,
> +	//  we use to find other tables, otherwise we use RSDT.

/* ... */ style comments please. And the comment looks like it's missing
something like "When it's valid..."

> +	if (xsdt) {
> +		end = (void *)(ulong)xsdt + xsdt->length;
> +		for (i = 0; (void *)&xsdt->table_offset_entry[i] < end; i++) {
> +			struct acpi_table *t =
> +				(void *)xsdt->table_offset_entry[i];

nit: The kernel's checkpatch allows 100 char line length. Let's use all of them :-)

> +			if (t && t->signature == sig)
> +				return t;
> +		}
> +	} else if (rsdt) {
> +		end = (void *)rsdt + rsdt->length;
> +		for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
> +			struct acpi_table *t =
> +				(void *)(ulong)rsdt->table_offset_entry[i];

Same nit as above.

> +			if (t && t->signature == sig)
> +				return t;
> +		}
> +	}
> +
> +	return NULL;
>  }
> -- 
> 2.25.1
>

Thanks,
drew 

