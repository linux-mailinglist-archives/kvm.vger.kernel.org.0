Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5AB5326B1
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 11:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbiEXJmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 05:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235811AbiEXJml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 05:42:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A421552E5F
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 02:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653385357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zFo5wCOAm0pgrR3mlKlJ9zjKOLJ6nCkOz288AuApEU8=;
        b=YKPymaG0bt/mBS8TN6pqG2EsXZNIQChdkglkTWt/cptvQTnSpDWicZQS+huQuqu9H5PnwL
        DPQGEaVFfOifE1dk9UL15kUnUIxfuYqTGcvwiYOD7u1dFaB2rXcwzfyOPuaefU84Hr/9Ht
        RNrs+khW7ezwXsQ1qAP1K0gldAWCHqA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-aDqblJeGP06m4RU3qBlbsw-1; Tue, 24 May 2022 05:42:36 -0400
X-MC-Unique: aDqblJeGP06m4RU3qBlbsw-1
Received: by mail-ej1-f69.google.com with SMTP id lf18-20020a170906ae5200b006fec8de9f0cso2662208ejb.4
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 02:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zFo5wCOAm0pgrR3mlKlJ9zjKOLJ6nCkOz288AuApEU8=;
        b=vpqZV11m2ZHTJHh56YEEpEnVgloeXlM4q0peLxVMCzMrNkPUVt9Ak366XbbQRxAWPy
         IP9OqEmVvDelwzlMRI/cmvtrMK4Wk/ptSTPid6WnKbPhUP0rjc8mYGyGjRppvw1JAeEq
         DSE/k7ETgvW9yQZ2WD7AmPIUvlxv8uVWIYvNYg0cdnS7azQgYjKTEn3hktdbg/IEVhCW
         Sn0BwbjKZ+3FtG40RwtP+t4LgjF/CdmlgvaGRsDmmmi+0NR0hc3uwOAh8WKrKlRs+UKo
         CL9MV9Jblh1HUMsca9S5qu3TTw+IAOL6Q8k/2xT2B0T9siiYWk/M/69RGnjaMSwgrf0M
         RUPg==
X-Gm-Message-State: AOAM530yCtn00i5hru1n8fKcN9mONbHv5rqtNe1dN9dTQEi8nhypfDJa
        BSCdCuclZi7PWOXLbi0H5a0ABA+4WC9L3OxZxNDtBbUXGdpc//QrB8bXQ2Oli23Kjjw1f2b+wyK
        PWoFfdMsbEhBq
X-Received: by 2002:a17:907:7b95:b0:6f4:ff03:981a with SMTP id ne21-20020a1709077b9500b006f4ff03981amr23817499ejc.653.1653385354823;
        Tue, 24 May 2022 02:42:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyz1c8JZ5OgT7BSYJ7GMI1ZrbV0ucv3Jm2MDi5bXDEPX/pxgf5WI1Tr1nVK1/8YFWI1DdgwYw==
X-Received: by 2002:a17:907:7b95:b0:6f4:ff03:981a with SMTP id ne21-20020a1709077b9500b006f4ff03981amr23817486ejc.653.1653385354641;
        Tue, 24 May 2022 02:42:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id 16-20020a17090601d000b006f3ef214db3sm7086985ejj.25.2022.05.24.02.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 02:42:33 -0700 (PDT)
Message-ID: <43bba413-030e-578b-a7d0-e81aed4e67b4@redhat.com>
Date:   Tue, 24 May 2022 11:42:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] s390/uv_uapi: depend on CONFIG_S390
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20220523192420.151184-1-pbonzini@redhat.com>
 <78b9cc09-caef-94c7-8bff-30544098603f@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <78b9cc09-caef-94c7-8bff-30544098603f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/22 09:01, Christian Borntraeger wrote:
> Am 23.05.22 um 21:24 schrieb Paolo Bonzini:
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   drivers/s390/char/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
>> index ef8f41833c1a..108e8eb06249 100644
>> --- a/drivers/s390/char/Kconfig
>> +++ b/drivers/s390/char/Kconfig
>> @@ -103,6 +103,7 @@ config SCLP_OFB
>>   config S390_UV_UAPI
>>       def_tristate m
>>       prompt "Ultravisor userspace API"
>> +        depends on S390
>>       help
>>         Selecting exposes parts of the UV interface to userspace
>>         by providing a misc character device at /dev/uv.
> 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> with the whitespace as outlined.

Yes, that needs to be a tab.

> Can you pick it yourself?

Sure, thanks.

Paolo

