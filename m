Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95856388A2A
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 11:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344405AbhESJIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 05:08:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240090AbhESJIW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 05:08:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621415221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KGek2Y6xPrDpb7bs2AvFFQ8RtUI+TRON+hzQiDKzDAk=;
        b=D2cQMUPETpxg2hIl57qZTX82bpHntYrmJZU8DRnI0xCCHA+fx/5BCQsJUidtL0X3LKSzc0
        NVQDHGAe3g4euzdYVCcI6Nl8SJTexKLoEu440fezwdQBl1mCVYhoU0+7IaP/mU9fu9blbn
        K/9xbraPojzieB7bsbU0B3uyjvYVqnE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-JZaF_teYMbqNwgKhDO99WQ-1; Wed, 19 May 2021 05:07:00 -0400
X-MC-Unique: JZaF_teYMbqNwgKhDO99WQ-1
Received: by mail-wr1-f71.google.com with SMTP id u20-20020a0560001614b02901115c8f2d89so6801880wrb.3
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 02:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KGek2Y6xPrDpb7bs2AvFFQ8RtUI+TRON+hzQiDKzDAk=;
        b=dEJmdeUAjhBl313kGtdtRxHZ0l4GNXPRTyw0jQ3j86Z9yjrAJfWlF4z2CYP6HoRoai
         c25y0UUbDgWGKDE01ojDiC+9U6HsDIpMLKJPVVhR01oBnDNVFCw7I0ThsQQIdUz0N/+t
         a5/7XJMTvCoF7F8HU4vG21eoFlGNuGHdDj9qneA2UZXxwzRTfEfylI7PFYP9eUmn3wRd
         KU+JccFHL1Aax95hlxfV6kByUEEI7EV6H38VhaNq1BhDm1GXBQAnpz3TS6YkR2SupbTm
         HiUQmN484y5mAWe4su4Eo6LW1QtzGKfVG2ZvmR6oSqfTl0a2Rbs35e6uPiiHx2d+Ifd6
         ntNg==
X-Gm-Message-State: AOAM533gyJAs9qxrOIj8us3jCR9WeJB3aYhBICCYG9zEOwz3+dDLTpl8
        RBz4h+KxXzhjaXP8Ow8bhqYLH/anNfcN9+BD2fyoUSobqveaBmDwQBsHBxoExyJ/dLXdW/g1qJl
        mAYv/GVK5Ymyh
X-Received: by 2002:a5d:6a4c:: with SMTP id t12mr13484090wrw.109.1621415219018;
        Wed, 19 May 2021 02:06:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzu9xU8NcRQvSHW+FuupOoqrazl17zuGiGTCAujbgWDxU5jY235VzO9g84Kr4EidWpzMSB8Bg==
X-Received: by 2002:a5d:6a4c:: with SMTP id t12mr13484059wrw.109.1621415218713;
        Wed, 19 May 2021 02:06:58 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6694.dip0.t-ipconnect.de. [91.12.102.148])
        by smtp.gmail.com with ESMTPSA id f188sm5155880wmf.24.2021.05.19.02.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 02:06:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 2/3] lib: s390x: sclp: Extend feature
 probing
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
References: <20210519082648.46803-1-frankja@linux.ibm.com>
 <20210519082648.46803-3-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <b7a16b6d-73fc-785f-25e7-2e0c0bfb3619@redhat.com>
Date:   Wed, 19 May 2021 11:06:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210519082648.46803-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.05.21 10:26, Janosch Frank wrote:
> Lets grab more of the feature bits from SCLP read info so we can use
> them in the cpumodel tests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/sclp.c | 20 ++++++++++++++++++++
>   lib/s390x/sclp.h | 38 +++++++++++++++++++++++++++++++++++---
>   2 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index f11c2035..291924b0 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -129,6 +129,13 @@ CPUEntry *sclp_get_cpu_entries(void)
>   	return (CPUEntry *)(_read_info + read_info->offset_cpu);
>   }
>   
> +static bool sclp_feat_check(int byte, int bit)
> +{
> +	uint8_t *rib = (uint8_t *)read_info;
> +
> +	return !!(rib[byte] & (0x80 >> bit));
> +}
> +
>   void sclp_facilities_setup(void)
>   {
>   	unsigned short cpu0_addr = stap();
> @@ -140,6 +147,14 @@ void sclp_facilities_setup(void)
>   	cpu = sclp_get_cpu_entries();
>   	if (read_info->offset_cpu > 134)
>   		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
> +	sclp_facilities.has_gsls = sclp_feat_check(85, SCLP_FEAT_85_BIT_GSLS);
> +	sclp_facilities.has_kss = sclp_feat_check(98, SCLP_FEAT_98_BIT_KSS);
> +	sclp_facilities.has_cmma = sclp_feat_check(116, SCLP_FEAT_116_BIT_CMMA);
> +	sclp_facilities.has_64bscao = sclp_feat_check(116, SCLP_FEAT_116_BIT_64BSCAO);
> +	sclp_facilities.has_esca = sclp_feat_check(116, SCLP_FEAT_116_BIT_ESCA);
> +	sclp_facilities.has_ibs = sclp_feat_check(117, SCLP_FEAT_117_BIT_IBS);
> +	sclp_facilities.has_pfmfi = sclp_feat_check(117, SCLP_FEAT_117_BIT_PFMFI);
> +
>   	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
>   		/*
>   		 * The logic for only reading the facilities from the
> @@ -150,6 +165,11 @@ void sclp_facilities_setup(void)
>   		 */
>   		if (cpu->address == cpu0_addr) {
>   			sclp_facilities.has_sief2 = cpu->feat_sief2;
> +			sclp_facilities.has_skeyi = cpu->feat_skeyi;
> +			sclp_facilities.has_siif = cpu->feat_siif;
> +			sclp_facilities.has_sigpif = cpu->feat_sigpif;
> +			sclp_facilities.has_ib = cpu->feat_ib;
> +			sclp_facilities.has_cei = cpu->feat_cei;
>   			break;
>   		}
>   	}
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 85231333..115bd2fa 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -94,9 +94,19 @@ typedef struct CPUEntry {
>   	uint8_t reserved0;
>   	uint8_t : 4;
>   	uint8_t feat_sief2 : 1;
> +	uint8_t feat_skeyi : 1;
> +	uint8_t : 2;
> +	uint8_t : 2;
> +	uint8_t feat_gpere : 1;
> +	uint8_t feat_siif : 1;
> +	uint8_t feat_sigpif : 1;
>   	uint8_t : 3;
> -	uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
> -	uint8_t reserved2[6];
> +	uint8_t reserved2[3];
> +	uint8_t : 2;
> +	uint8_t feat_ib : 1;
> +	uint8_t feat_cei : 1;
> +	uint8_t : 4;
> +	uint8_t reserved3[6];
>   	uint8_t type;
>   	uint8_t reserved1;
>   } __attribute__((packed)) CPUEntry;
> @@ -105,10 +115,32 @@ extern struct sclp_facilities sclp_facilities;
>   
>   struct sclp_facilities {
>   	uint64_t has_sief2 : 1;
> +	uint64_t has_skeyi : 1;
> +	uint64_t has_gpere : 1;
> +	uint64_t has_siif : 1;
> +	uint64_t has_sigpif : 1;
> +	uint64_t has_ib : 1;
> +	uint64_t has_cei : 1;
> +
>   	uint64_t has_diag318 : 1;
> -	uint64_t : 62;
> +	uint64_t has_gsls : 1;
> +	uint64_t has_cmma : 1;
> +	uint64_t has_64bscao : 1;
> +	uint64_t has_esca : 1;
> +	uint64_t has_kss : 1;
> +	uint64_t has_pfmfi : 1;
> +	uint64_t has_ibs : 1;
> +	uint64_t : 64 - 15;
>   };
>   
> +#define SCLP_FEAT_85_BIT_GSLS		7
> +#define SCLP_FEAT_98_BIT_KSS		0
> +#define SCLP_FEAT_116_BIT_64BSCAO	7
> +#define SCLP_FEAT_116_BIT_CMMA		6
> +#define SCLP_FEAT_116_BIT_ESCA		3
> +#define SCLP_FEAT_117_BIT_PFMFI		6
> +#define SCLP_FEAT_117_BIT_IBS		5
> +
>   typedef struct ReadInfo {
>   	SCCBHeader h;
>   	uint16_t rnmax;
> 

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

