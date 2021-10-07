Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D75424FCA
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhJGJNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 05:13:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231661AbhJGJNr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 05:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633597913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cL2AYQZt9EJmxIocfW/F95MTjSXhoGnSEOcdkz+hNRA=;
        b=Ek6H0IukXGWahE14bgvrwxr10vOeXtnKVlTgpGG6VyOkAHdCv+q3ckx5GnXBy2yKrfEwfE
        lXXCyorRVF8gP3XuxOT6E1QroYaS33mt6f/+xBQX6/iQBJNow3TAJ2gocmGNA7rgkZg1VV
        QbWtJ0MSct9HQLwLb4XJr/RGy7/BuuE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-p72h74c6Mg2oXn6iYoX7cg-1; Thu, 07 Oct 2021 05:11:52 -0400
X-MC-Unique: p72h74c6Mg2oXn6iYoX7cg-1
Received: by mail-wr1-f71.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso4133434wrb.20
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 02:11:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cL2AYQZt9EJmxIocfW/F95MTjSXhoGnSEOcdkz+hNRA=;
        b=Mw5jSXC/Gp5UiTnRRJDXL8JlEa1c+6H6K94BlcXnV9f/ngz9sSlxJ5auKoIOz8smXO
         eeEXfT7PmoXOGIsjUEQEmMiExvNAjMUQ7mwgQ2IC7IxGQ4NETOfohcw0d0yuYDdCJ021
         zmOBwFzrYgyeCuqZ8/eHGBFMshQGcWnFKfttMmalowArJvujXoB9AOIoraCI49iIQ0Z/
         lezN25xXJMPFUI63cgBhlxL9lf1j9enWoOloIDYRsQBoNaG0ybFi4bT26HfGNPKYJR83
         3DvR65CZCwOCCcraTu70WSiTVxgDXp202JJ2uaxhzA2AillQSIV5w/NNZLZ0sjSY19UF
         DCIg==
X-Gm-Message-State: AOAM5326qleh4O8TKG2KgbBR8jxG335gXCg6d634mJD3fW5aiI0q8LIA
        MfKKD5PDEH3xX4R4VQjUYa3oggQ8frKX5IN/E+pU7NCd6breqZhKnmGpw79z4q3Fkbog4YUQRgm
        UtmPkN9rQewF+
X-Received: by 2002:adf:b1d7:: with SMTP id r23mr3974113wra.145.1633597911715;
        Thu, 07 Oct 2021 02:11:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFBp3oRQeGhxR6zxv/NNmV1Xj2k340GDruIacyFt9QzrvM4W/CByUKsQWLlWqEcLHDuEABmA==
X-Received: by 2002:adf:b1d7:: with SMTP id r23mr3974104wra.145.1633597911580;
        Thu, 07 Oct 2021 02:11:51 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id f1sm26529941wri.43.2021.10.07.02.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 02:11:51 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v3 7/9] s390x: Add sthyi cc==0 r2+1
 verification
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, seiden@linux.ibm.com, scgl@linux.ibm.com
References: <20211007085027.13050-1-frankja@linux.ibm.com>
 <20211007085027.13050-8-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <18a10bec-aee5-700f-9004-b4a200dcebed@redhat.com>
Date:   Thu, 7 Oct 2021 11:11:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211007085027.13050-8-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/2021 10.50, Janosch Frank wrote:
> On success r2 + 1 should be 0, let's also check for that.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/sthyi.c | 20 +++++++++++---------
>   1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/s390x/sthyi.c b/s390x/sthyi.c
> index db90b56f..4b153bf4 100644
> --- a/s390x/sthyi.c
> +++ b/s390x/sthyi.c
> @@ -24,16 +24,16 @@ static inline int sthyi(uint64_t vaddr, uint64_t fcode, uint64_t *rc,
>   {
>   	register uint64_t code asm("0") = fcode;
>   	register uint64_t addr asm("2") = vaddr;
> -	register uint64_t rc3 asm("3") = 0;
> +	register uint64_t rc3 asm("3") = 42;
>   	int cc = 0;
>   
> -	asm volatile(".insn rre,0xB2560000,%[r1],%[r2]\n"
> -		     "ipm	 %[cc]\n"
> -		     "srl	 %[cc],28\n"
> -		     : [cc] "=d" (cc)
> -		     : [code] "d" (code), [addr] "a" (addr), [r1] "i" (r1),
> -		       [r2] "i" (r2)
> -		     : "memory", "cc", "r3");
> +	asm volatile(
> +		".insn   rre,0xB2560000,%[r1],%[r2]\n"
> +		"ipm     %[cc]\n"
> +		"srl     %[cc],28\n"
> +		: [cc] "=d" (cc), "+d" (rc3)
> +		: [code] "d" (code), [addr] "a" (addr), [r1] "i" (r1), [r2] "i" (r2)
> +		: "memory", "cc");
>   	if (rc)
>   		*rc = rc3;
>   	return cc;
> @@ -139,16 +139,18 @@ static void test_fcode0(void)
>   	struct sthyi_hdr_sctn *hdr;
>   	struct sthyi_mach_sctn *mach;
>   	struct sthyi_par_sctn *par;
> +	uint64_t rc = 42;
>   
>   	/* Zero destination memory. */
>   	memset(pagebuf, 0, PAGE_SIZE);
>   
>   	report_prefix_push("fcode 0");
> -	sthyi((uint64_t)pagebuf, 0, NULL, 0, 2);
> +	sthyi((uint64_t)pagebuf, 0, &rc, 0, 2);
>   	hdr = (void *)pagebuf;
>   	mach = (void *)pagebuf + hdr->INFMOFF;
>   	par = (void *)pagebuf + hdr->INFPOFF;
>   
> +	report(!rc, "r2 + 1 == 0");

Could you please check for "rc == CODE_SUCCES" (since we've got that for 
this purpose)?

With that change:
Reviewed-by: Thomas Huth <thuth@redhat.com>

