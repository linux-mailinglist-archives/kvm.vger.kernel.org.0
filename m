Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB60A3F005D
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 11:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhHRJZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 05:25:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232720AbhHRJZS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 05:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629278683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xRaF4ibqqTKL4gf4bLxzmr31/JCFub6/Guzco44M6h8=;
        b=KhV3bFyTSHi4hTldQrn42UzE2OiaT0/7Y7Y5aTBafaVNpkkRvkDl0aUTduL9zuTiKB3+c0
        HNtYiKxOABt2luoBcP26O658+CDS4hP3SqoLI6ao6KNztSJ9lks5VdU1wuFATar/jtMk9r
        2/WisGsOAGUw1ifPOmAH3e1O06tqd8g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-KGwiHPO0Ov6se8AMneU0LA-1; Wed, 18 Aug 2021 05:24:42 -0400
X-MC-Unique: KGwiHPO0Ov6se8AMneU0LA-1
Received: by mail-ed1-f70.google.com with SMTP id bx23-20020a0564020b5700b003bf2eb11718so711642edb.20
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 02:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xRaF4ibqqTKL4gf4bLxzmr31/JCFub6/Guzco44M6h8=;
        b=PrVT7RZ50b5k1gVG5KIB16dAvABjPOisSKw7YquBrlfCFmB0OJ6/h5im9ImwfKr3h7
         H4MZQEv4THXUY7fXlb9i5HRlaZbN3+Gs/et9kFwa/OByTaEPKT76TyNyWzvDuQhuIrCX
         EeTmE//7Jf/+xoaezhYz9yHlYkU45rfCr6gxClgxQFXg6a/kPhvlG/CgUTfCQGmYw2eV
         +Dr1k27vR1rlq7haXvmjkm2ARmOccPk4pHA7JN1WaoGN/krREm3VXI6YPkjNpchsQCBf
         Zya/FYdeZbB9FEw/TvLnQYLsaeiW+k/rqxOna0S7OngdY46VHXu7qxmlje+7Mq2Y8guj
         6B3A==
X-Gm-Message-State: AOAM5316LDvOO7kj/jvIjKJUleiWunhher0P5rsr8c32TTmwBtOWcVwx
        BGLZgR+Gpt4ULmZn1i1smiHqUv2fQOm1r2UHWecQ2Zg+FKGC8ZYOI9mh4/abpsLXe68pyUc3+mb
        B3SEjZk+1BRxQ
X-Received: by 2002:a05:6402:3485:: with SMTP id v5mr8808893edc.205.1629278681027;
        Wed, 18 Aug 2021 02:24:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwO505jA4aGPl6io2+Nh1IAJVCOX0AktdhZUSJw4e+bZqPYCXsHvz5GeLIm5mhlAg1LvlC4qQ==
X-Received: by 2002:a05:6402:3485:: with SMTP id v5mr8808883edc.205.1629278680883;
        Wed, 18 Aug 2021 02:24:40 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83070.dip0.t-ipconnect.de. [217.232.48.112])
        by smtp.gmail.com with ESMTPSA id c28sm1742579ejc.102.2021.08.18.02.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 02:24:40 -0700 (PDT)
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 4/8] lib: s390x: Start using bitops instead
 of magic constants
Message-ID: <f6b4c1e2-ac05-3567-5209-be9227b39786@redhat.com>
Date:   Wed, 18 Aug 2021 11:24:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210813073615.32837-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/2021 09.36, Janosch Frank wrote:
> TEID data is specified in the Principles of Operation as bits so it
> makes more sens to test the bits instead of anding the mask.
> 
> We need to set -Wno-address-of-packed-member since for test bit we
> take an address of a struct lowcore member.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/interrupt.c | 5 +++--
>   s390x/Makefile        | 1 +
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 1248bceb..e05c212e 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -8,6 +8,7 @@
>    *  David Hildenbrand <david@redhat.com>
>    */
>   #include <libcflat.h>
> +#include <bitops.h>
>   #include <asm/barrier.h>
>   #include <sclp.h>
>   #include <interrupt.h>
> @@ -77,8 +78,8 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>   		break;
>   	case PGM_INT_CODE_PROTECTION:
>   		/* Handling for iep.c test case. */
> -		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id & 0x04UL &&
> -		    !(lc->trans_exc_id & 0x08UL))
> +		if (test_bit_inv(56, &lc->trans_exc_id) && test_bit_inv(61, &lc->trans_exc_id) &&
> +		    !test_bit_inv(60, &lc->trans_exc_id))

I'd rather prefer:

	if ((lc->trans_exc_id & 0x8c) == 0x84)

... or maybe you could add a helper function for these checks a la:

bool check_teid_prot_cause(uint64_t teid, bool bit56, bool bit60,
                            bool bit61)

then you could replace the if statement with:

	if (check_teid_prot_cause(lc->trans_exc_id, 1, 0, 1))

which would be way more readable, IMHO.

>   			/*
>   			 * We branched to the instruction that caused
>   			 * the exception so we can use the return
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ef8041a6..d260b336 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -45,6 +45,7 @@ CFLAGS += -O2
>   CFLAGS += -march=zEC12
>   CFLAGS += -mbackchain
>   CFLAGS += -fno-delete-null-pointer-checks
> +CFLAGS += -Wno-address-of-packed-member

I think we should avoid this since this also affects the common code, 
doesn't it? And in common code, we might need to deal with this.

  Thomas

