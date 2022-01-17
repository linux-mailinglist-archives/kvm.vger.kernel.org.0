Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A67490343
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 08:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237779AbiAQH54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 02:57:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237757AbiAQH5z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 02:57:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642406275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JCCi3MIuQovJPO+EIvftnsBpVatiAMOXiJV6GtHrvA=;
        b=N4rTBpSM556jtxEp6GBHracjSJDsV18OCTF0wOKb4+6/HwZz7/U3peCT9RrrQjoM6b3CBS
        XLdQv2eO0JG8PdzmKOuLYqaTcxIjUqJDOIFx4vMLllNtNEbLXIMM7bvAOyMpGsC2mTCl5C
        ZdTzL29VYggeP81NbwJYIYUEWYCUWGY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-x6LBQTrbN3uTazf0y-ZyGg-1; Mon, 17 Jan 2022 02:57:53 -0500
X-MC-Unique: x6LBQTrbN3uTazf0y-ZyGg-1
Received: by mail-wm1-f70.google.com with SMTP id w5-20020a1cf605000000b0034b8cb1f55eso4369228wmc.0
        for <kvm@vger.kernel.org>; Sun, 16 Jan 2022 23:57:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9JCCi3MIuQovJPO+EIvftnsBpVatiAMOXiJV6GtHrvA=;
        b=3vf+J4LmnunKUujmrj8Hg8xolgfvVz5SDCnJ/JanCFE9SY8LI4u3oPnHX3CDUTetNB
         W+7dTpvea6BLy/6XUTzG0UYRog8ggdNtFfMmyM4/SSXRpF7rdw5+JtTmkwhI9WjlO5Im
         4Hsg+FUCkcVSLyOt9MsC+biSZPD39duqVPr9+DjgTIsEhjf57C39PvlAhAjZkKvexBoV
         GjOil53yXRu+VAnPbgu2yUqNa1tVphrUP7f04vJSfKUT02j3B4cvdZnll2Hon92hJP3A
         T9GUWebq3eoU1dx0VmDP2Tax8jhCcXeaAngGuuac72zJb64rrutM2rQlk89i4vEQ/o41
         LV9Q==
X-Gm-Message-State: AOAM533XK9DH6cL9FhszG3+X+Sd/DucM+gSk1q5N3DVs7L42iRAUng2m
        jdi0/yCn9Bdy9CSsEtS20R6vhuGpQbWPYJnLnjXw4f+k9phK1MPyWxnh7ZQ8y+6OTXbpf1A62V5
        RSoCfG5qp3tep
X-Received: by 2002:a7b:c8c2:: with SMTP id f2mr18877835wml.31.1642406272300;
        Sun, 16 Jan 2022 23:57:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyeCSAIdXI07PHwaY+V/muk8T9a4aS45ceN4+PuQjmzpFR8DVMQ5d8AonGGR/ieUlS6CWwBJQ==
X-Received: by 2002:a7b:c8c2:: with SMTP id f2mr18877822wml.31.1642406272110;
        Sun, 16 Jan 2022 23:57:52 -0800 (PST)
Received: from [192.168.8.100] (tmo-098-68.customers.d1-online.com. [80.187.98.68])
        by smtp.gmail.com with ESMTPSA id az29sm8998444wmb.31.2022.01.16.23.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 23:57:51 -0800 (PST)
Message-ID: <6cecc9f8-2bc5-982b-4823-f44084f6f11b@redhat.com>
Date:   Mon, 17 Jan 2022 08:57:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 04/30] s390/sclp: detect the AISI facility
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-5-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220114203145.242984-5-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2022 21.31, Matthew Rosato wrote:
> Detect the Adapter Interruption Suppression Interpretation facility.
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/sclp.h   | 1 +
>   drivers/s390/char/sclp_early.c | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
> index 8c2e142000d4..33b174007848 100644
> --- a/arch/s390/include/asm/sclp.h
> +++ b/arch/s390/include/asm/sclp.h
> @@ -91,6 +91,7 @@ struct sclp_info {
>   	unsigned char has_zpci_lsi : 1;
>   	unsigned char has_aisii : 1;
>   	unsigned char has_aeni : 1;
> +	unsigned char has_aisi : 1;
>   	unsigned int ibc;
>   	unsigned int mtid;
>   	unsigned int mtid_cp;
> diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
> index e9af01b4c97a..c13e55cc4a5d 100644
> --- a/drivers/s390/char/sclp_early.c
> +++ b/drivers/s390/char/sclp_early.c
> @@ -47,6 +47,7 @@ static void __init sclp_early_facilities_detect(void)
>   	sclp.has_kss = !!(sccb->fac98 & 0x01);
>   	sclp.has_aisii = !!(sccb->fac118 & 0x40);
>   	sclp.has_aeni = !!(sccb->fac118 & 0x20);
> +	sclp.has_aisi = !!(sccb->fac118 & 0x10);
>   	sclp.has_zpci_lsi = !!(sccb->fac118 & 0x01);
>   	if (sccb->fac85 & 0x02)
>   		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;

Just a matter of taste, but I'd maybe squash patches 1 - 4 into one patch.

  Thomas

