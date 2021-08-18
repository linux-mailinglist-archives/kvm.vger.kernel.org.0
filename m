Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFE73F0015
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 11:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhHRJNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 05:13:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbhHRJNg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 05:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629277981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ottHHj7zWc7J92l6pIK4Ru/1GKlXrPvFUE129DlVp0=;
        b=KlE8vKwmLuECs7RXJuVsO4oVgczR0gBBKNxsOHiO5nC0vgTTrTusihMH17Ku0dYL9IVvhF
        ZZ4leSjcBK91pWngQSPfpypBr9SoqMC8epijvD5weDtPW3ZuhEOchu4lHFoQvli+7Kua8t
        oCKuO9mzznuZAb4xJEyFxyNR6HDicEg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-vgzRIdwpNGKS-wtQr0SYxw-1; Wed, 18 Aug 2021 05:13:00 -0400
X-MC-Unique: vgzRIdwpNGKS-wtQr0SYxw-1
Received: by mail-ed1-f71.google.com with SMTP id z4-20020a05640240c4b02903be90a10a52so700423edb.19
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 02:13:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ottHHj7zWc7J92l6pIK4Ru/1GKlXrPvFUE129DlVp0=;
        b=QP441XfhOV6qGPbh07oTmZn6rgpuleNDIhQ2F56UlBzQuX8rX0ZvRFqmgoW/4hw+bV
         W0TS11NTdZxfQlxgATqY0mr9955idwmzEgWkUH/4+AbXQ197vz1ritS9A7dcUOcgzP7P
         FwaIMELeutXnG7rVWHWqZu0W+PXc6CgeHwkOueozZAqKr7wWRgM8Su+6ltZNMqxPa2ks
         j2onFW9ut/gQ/DrxarsbNEtHBB9uS3zEI7rjIJycH2MRDihZjyQxltfYqZS036Ifus7o
         iXu/JfnzEW5H3o9RA7B8Db7ITtAQttYfjTUBlOcuHBPHYF3hh8peMM+ksABiaIOpbATM
         o7Pw==
X-Gm-Message-State: AOAM532nhgLfDFjlpJTXKbhZL/guTX4nzpZo0eKcpoaUWviW2WeHr+gq
        P4LPhpriZBBBOqWhhiizxM195rNw8IsBL9gKSA5koc+MLNCprpTC/eRC6GfCpbL4lhG1h2ZIxfU
        Fx6ehH6lc45Yg
X-Received: by 2002:a17:906:9be1:: with SMTP id de33mr3532570ejc.180.1629277979492;
        Wed, 18 Aug 2021 02:12:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWIz+43XuJoqExXJvuXXomY91EWFU0asL8Ii9JrcJQFA5OO0osAfU91XdLit+YY3ImytX5DA==
X-Received: by 2002:a17:906:9be1:: with SMTP id de33mr3532550ejc.180.1629277979216;
        Wed, 18 Aug 2021 02:12:59 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83070.dip0.t-ipconnect.de. [217.232.48.112])
        by smtp.gmail.com with ESMTPSA id dg24sm2321392edb.6.2021.08.18.02.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 02:12:58 -0700 (PDT)
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/8] lib: s390x: Print addressing related
 exception information
Message-ID: <1f99e6f8-27d1-7e4a-f706-12912e84f6f4@redhat.com>
Date:   Wed, 18 Aug 2021 11:12:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210813073615.32837-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/2021 09.36, Janosch Frank wrote:
> Right now we only get told the kind of program exception as well as
> the PSW at the point where it happened.
> 
> For addressing exceptions the PSW is not always enough so let's print
> the TEID which contains the failing address and flags that tell us
> more about the kind of address exception.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h |  4 +++
>   lib/s390x/interrupt.c    | 72 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 76 insertions(+)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 4ca02c1d..39c5ba99 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -41,6 +41,10 @@ struct psw {
>   	uint64_t	addr;
>   };
>   
> +/* Let's ignore spaces we don't expect to use for now. */
> +#define AS_PRIM				0
> +#define AS_HOME				3
> +
>   #define PSW_MASK_EXT			0x0100000000000000UL
>   #define PSW_MASK_IO			0x0200000000000000UL
>   #define PSW_MASK_DAT			0x0400000000000000UL
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 01ded49d..1248bceb 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -12,6 +12,7 @@
>   #include <sclp.h>
>   #include <interrupt.h>
>   #include <sie.h>
> +#include <asm/page.h>
>   
>   static bool pgm_int_expected;
>   static bool ext_int_expected;
> @@ -126,6 +127,73 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>   	/* suppressed/terminated/completed point already at the next address */
>   }
>   
> +static void decode_pgm_prot(uint64_t teid)
> +{
> +	/* Low-address protection exception, 100 */
> +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && !test_bit_inv(61, &teid)) {

Likely just a matter of taste, but I'd prefer something like:

	if ((teid & 0x8c) == 0x80) {

> +		printf("Type: LAP\n");
> +		return;
> +	}
> +
> +	/* Instruction execution prevention, i.e. no-execute, 101 */
> +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid)) {
> +		printf("Type: IEP\n");
> +		return;
> +	}
> +
> +	/* Standard DAT exception, 001 */
> +	if (!test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid)) {
> +		printf("Type: DAT\n");
> +		return;
> +	}

What about 010 (key controlled protection) and 011 (access-list controlled 
protection)? Even if we do not trigger those yet, it might make sense to add 
them right from the start, too?

> +}
> +
> +static void decode_teid(uint64_t teid)
> +{
> +	int asce_id = lc->trans_exc_id & 3;

Why are you referencing the lc->trans_exc_id here again? It's already passed 
as "teid" parameter.

> +	bool dat = lc->pgm_old_psw.mask & PSW_MASK_DAT;
> +
> +	printf("Memory exception information:\n");
> +	printf("TEID: %lx\n", teid);
> +	printf("DAT: %s\n", dat ? "on" : "off");
> +	printf("AS: %s\n", asce_id == AS_PRIM ? "Primary" : "Home");

Could "secondary" or "AR" mode really never happen here? I'd rather like to 
see a switch-case statement here that is able to print all four modes, just 
to avoid confusion.

> +	if (lc->pgm_int_code == PGM_INT_CODE_PROTECTION)
> +		decode_pgm_prot(teid);
> +
> +	/*
> +	 * If teid bit 61 is off for these two exception the reported
> +	 * address is unpredictable.
> +	 */
> +	if ((lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
> +	     lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
> +	    !test_bit_inv(61, &teid)) {
> +		printf("Address: %lx, unpredictable\n ", teid & PAGE_MASK);
> +		return;
> +	}
> +	printf("Address: %lx\n\n", teid & PAGE_MASK);
> +}
> +
> +static void print_storage_exception_information(void)
> +{
> +	switch (lc->pgm_int_code) {
> +	case PGM_INT_CODE_PROTECTION:
> +	case PGM_INT_CODE_PAGE_TRANSLATION:
> +	case PGM_INT_CODE_SEGMENT_TRANSLATION:
> +	case PGM_INT_CODE_ASCE_TYPE:
> +	case PGM_INT_CODE_REGION_FIRST_TRANS:
> +	case PGM_INT_CODE_REGION_SECOND_TRANS:
> +	case PGM_INT_CODE_REGION_THIRD_TRANS:
> +	case PGM_INT_CODE_SECURE_STOR_ACCESS:
> +	case PGM_INT_CODE_NON_SECURE_STOR_ACCESS:
> +	case PGM_INT_CODE_SECURE_STOR_VIOLATION:
> +		decode_teid(lc->trans_exc_id);
> +		break;
> +	default:
> +		return;

I think you could drop that default case.

> +	}
> +}
> +
>   static void print_int_regs(struct stack_frame_int *stack)
>   {
>   	printf("\n");
> @@ -155,6 +223,10 @@ static void print_pgm_info(struct stack_frame_int *stack)
>   	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
>   	print_int_regs(stack);
>   	dump_stack();
> +
> +	/* Dump stack doesn't end with a \n so we add it here instead */
> +	printf("\n");
> +	print_storage_exception_information();
>   	report_summary();
>   	abort();
>   }
> 

