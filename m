Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3728A3F94DD
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244350AbhH0HHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:07:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhH0HHo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 03:07:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630048016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nOKUkOiPOJUuW1BeJGrt0BGMqLncXK4AuC8Tr1L6PbU=;
        b=b5kN6NM4C4FMZ+nXoMIGUKarA1ysLBzbWh8hLKo+y5200r33C248IKwYFOU3R6M8sHHQZI
        53/5uE4BA/SmMrdE8KS5VLvLI906LEE7fdXNkBq7wgrCm1D2DhgN8tHU7OLIBSjCja4yPX
        kVqr51XrJshZXuWCSVNcQG6npjfllJ4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-WA0UZJbhM6Gqqo-ygjBl0A-1; Fri, 27 Aug 2021 03:06:52 -0400
X-MC-Unique: WA0UZJbhM6Gqqo-ygjBl0A-1
Received: by mail-wm1-f69.google.com with SMTP id 5-20020a1c00050000b02902e67111d9f0so1737286wma.4
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 00:06:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nOKUkOiPOJUuW1BeJGrt0BGMqLncXK4AuC8Tr1L6PbU=;
        b=pfCns7xQtyNTP2U+dS3eFVgO2zQ1lonraSHmscbkyNXVArojkJaLx9h/3H7kJnrBnp
         xQh2whBjugUTspHPXuRJEoeud0cZbzpH28EaLSXBVXFDTiYB3Nk+xLTMZ4uxVBA00JkY
         KHsHJNT9SRtwMzK0C+uNkQ+UwxCvEWYff5+vFu1nLlEbCpjKbF/aH4MaEiTLjKXso6tG
         aScM5uWkQQfngsN60zRua3+GWduIGWLAvaXopHVQwri1982xwBUvoFwa8yGNK5SI+yYg
         6AdlUlG9DYoqChze+XGbtS9UpHrP/A9gPw0VL4TQ+ZalcPUavdQi2qqnIgt1rOtPRBJc
         BgBQ==
X-Gm-Message-State: AOAM530jj9zXkJeTCl1so4NOG7180CQnhmFtdca4blPq/lAlhZWGSMyA
        IM948/6hlp+aVF+6SHwsMlWPWNjY27rlZHinZwzPjLzRwOsJrI64jAilTkjfEZtbJ6ueQyLTasb
        dhQ4rh3+m3YKa
X-Received: by 2002:adf:9ccc:: with SMTP id h12mr8327999wre.385.1630048011489;
        Fri, 27 Aug 2021 00:06:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw57zjaM5g1GyQHtDyDMZ2UBw12roRBBqfIkLUfj27vJWmqrNn2efnoDxPlsDUNyZkXOwoBMw==
X-Received: by 2002:adf:9ccc:: with SMTP id h12mr8327984wre.385.1630048011293;
        Fri, 27 Aug 2021 00:06:51 -0700 (PDT)
Received: from thuth.remote.csb (dynamic-046-114-148-182.46.114.pool.telefonica.de. [46.114.148.182])
        by smtp.gmail.com with ESMTPSA id u27sm5711741wru.2.2021.08.27.00.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 00:06:50 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 1/3] lib: s390x: Print addressing
 related exception information
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210820114000.166527-1-frankja@linux.ibm.com>
 <20210820114000.166527-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <079f3f36-652f-4f11-a704-4105ddc65a8a@redhat.com>
Date:   Fri, 27 Aug 2021 09:06:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210820114000.166527-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/2021 13.39, Janosch Frank wrote:
> Right now we only get told the kind of program exception as well as
> the PSW at the point where it happened.
> 
> For addressing exceptions the PSW is not always enough so let's print
> the TEID which contains the failing address and flags that tell us
> more about the kind of address exception.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
...
> --- /dev/null
> +++ b/lib/s390x/fault.h
> @@ -0,0 +1,44 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Headers for fault.c
> + *
> + * Copyright 2021 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
> +#ifndef _S390X_FAULT_H_
> +#define _S390X_FAULT_H_
> +
> +#include <bitops.h>
> +
> +/* Instruction execution prevention, i.e. no-execute, 101 */
> +static inline bool prot_is_iep(uint64_t teid)
> +{
> +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid))
> +		return true;
> +
> +	return false;

You could simplify this into:

	return test_bit_inv(56, &teid) &&
                !test_bit_inv(60, &teid) &&
                test_bit_inv(61, &teid);

... but I don't mind too much if you keep the current version.

> +}
> +
> +/* Standard DAT exception, 001 */
> +static inline bool prot_is_datp(uint64_t teid)
> +{
> +	if (!test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid))
> +		return true;
> +
> +	return false;

dito

> +}
> +
> +/* Low-address protection exception, 100 */
> +static inline bool prot_is_lap(uint64_t teid)
> +{
> +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && !test_bit_inv(61, &teid))
> +		return true;
> +
> +	return false;

dito

> +}
> +
> +void print_decode_teid(uint64_t teid);
> +
> +#endif /* _S390X_FAULT_H_ */
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 01ded49d..721e6758 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -12,6 +12,8 @@
>   #include <sclp.h>
>   #include <interrupt.h>
>   #include <sie.h>
> +#include <fault.h>
> +#include <asm/page.h>
>   
>   static bool pgm_int_expected;
>   static bool ext_int_expected;
> @@ -76,8 +78,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>   		break;
>   	case PGM_INT_CODE_PROTECTION:
>   		/* Handling for iep.c test case. */
> -		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id & 0x04UL &&
> -		    !(lc->trans_exc_id & 0x08UL))
> +		if (prot_is_iep(lc->trans_exc_id))
>   			/*
>   			 * We branched to the instruction that caused
>   			 * the exception so we can use the return
> @@ -126,6 +127,26 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>   	/* suppressed/terminated/completed point already at the next address */
>   }
>   
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
> +		print_decode_teid(lc->trans_exc_id);
> +		break;
> +	default:
> +		return;

Drop the default case?

> +	}
> +}
> +
>   static void print_int_regs(struct stack_frame_int *stack)
>   {
>   	printf("\n");
> @@ -155,6 +176,10 @@ static void print_pgm_info(struct stack_frame_int *stack)
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
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ef8041a6..5d1a33a0 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -72,6 +72,7 @@ cflatobjs += lib/s390x/css_lib.o
>   cflatobjs += lib/s390x/malloc_io.o
>   cflatobjs += lib/s390x/uv.o
>   cflatobjs += lib/s390x/sie.o
> +cflatobjs += lib/s390x/fault.o
>   
>   OBJDIRS += lib/s390x
>   
> 

Some nits, but looks fine to me anyway:

Reviewed-by: Thomas Huth <thuth@redhat.com>

