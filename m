Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1F420723
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhJDIQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:16:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230432AbhJDIQ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:16:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qASqnQv3qByaQH2TDi0dGQ8HzqCHq9QyH+Cz2YAE5Uc=;
        b=DfqYaSOYmFuHNC3ouOfrMIe28j11nPnE0EmznQYMiDXKXXBPTgjVHOy2sqTgsMU0mmUQC/
        RAxY90gHBJ/wl9Q+lpV1Mtg+2bFsA9Tt8Uj6U/p7ACB6ABlYCaLW+urFCcR+nrhcQPsplj
        q1A0quXeMtrkvEkbGxTsblgDNNiK7Ms=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-VjmivbDHPleJ_eYfA19cXw-1; Mon, 04 Oct 2021 04:15:06 -0400
X-MC-Unique: VjmivbDHPleJ_eYfA19cXw-1
Received: by mail-ed1-f70.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso16418627edx.2
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qASqnQv3qByaQH2TDi0dGQ8HzqCHq9QyH+Cz2YAE5Uc=;
        b=5VsloSEwswzWtvsZmObFay1Y+EChH4fuCMsORWtWuOso8kkmHISFZz1AlliEvf0+w7
         rez/H85rnKd3kiKtvyIwAwh/FXZyl8weIuqBfynE+EruXccLVYj4LdRbaSRc0E6sPL5I
         KKcXCPVaOYe5JXALEcnH0Dv/prdNdKHvZuduMzoV8vJ7CstEhQlfV5yk4i9CWpergqXZ
         TXbsUEEIoMtGcPoHV+2JLRFiejgNd5WfBXbL5TD4OI/uE8PBiCOxI+KM0r1gCnjAnZf0
         VEX1IQQ0R7yKihjc5C7e4K7CFhBEKV2vb9Sk6dPXmhe6g52Z4dCpNe7o65NwPJEfGIZ3
         QEaw==
X-Gm-Message-State: AOAM531XQV6lM0VHfIaTmfrki7iMqYyDsvIRhp/YSuD1VfsQTQF30gZG
        VDCVjyXh6QA30xld67H5Fxyhb9JIoWrIeDoy8zwDsXSCVqaVXFv+IvuiL7wVQ1fWO9dM0s/9Pma
        vgtDhS7wsGleD
X-Received: by 2002:a05:6402:19ba:: with SMTP id o26mr16493716edz.1.1633335305413;
        Mon, 04 Oct 2021 01:15:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyY4ZYoEOucCxsqiEFxcwy2kB5C34GOhabXfVEe7DQy5l607rBEyp6fYpacfK+/x1KtLGlIVw==
X-Received: by 2002:a05:6402:19ba:: with SMTP id o26mr16493706edz.1.1633335305257;
        Mon, 04 Oct 2021 01:15:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r18sm66029edy.86.2021.10.04.01.15.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:15:04 -0700 (PDT)
Message-ID: <698c9ce4-154b-0be2-c177-03fd22b2c92e@redhat.com>
Date:   Mon, 4 Oct 2021 10:15:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 12/22] target/i386/sev: Declare system-specific
 functions in 'sev_i386.h'
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-13-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-13-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> While prefixed with sysemu, 'sysemu/sev.h' contains the architecture
> specific declarations. The system specific parts are declared in
> 'sev_i386.h'.

While outside target/i386, 'sysemu/sev.h' contains some architecture 
specific declarations. Move them to 'sev_i386.h'.

Otherwise,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   include/sysemu/sev.h   | 6 ------
>   target/i386/sev_i386.h | 7 +++++++
>   hw/i386/pc_sysfw.c     | 2 +-
>   3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
> index 94d821d737c..a329ed75c1c 100644
> --- a/include/sysemu/sev.h
> +++ b/include/sysemu/sev.h
> @@ -18,11 +18,5 @@
>   
>   bool sev_enabled(void);
>   int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
> -int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
> -int sev_inject_launch_secret(const char *hdr, const char *secret,
> -                             uint64_t gpa, Error **errp);
> -
> -int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size);
> -void sev_es_set_reset_vector(CPUState *cpu);
>   
>   #endif
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index afa19a0a161..0798ab3519a 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -33,4 +33,11 @@ extern SevCapability *sev_get_capabilities(Error **errp);
>   extern SevAttestationReport *
>   sev_get_attestation_report(const char *mnonce, Error **errp);
>   
> +int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
> +int sev_inject_launch_secret(const char *hdr, const char *secret,
> +                             uint64_t gpa, Error **errp);
> +
> +int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size);
> +void sev_es_set_reset_vector(CPUState *cpu);
> +
>   #endif
> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> index 68d6b1f783e..0b202138b66 100644
> --- a/hw/i386/pc_sysfw.c
> +++ b/hw/i386/pc_sysfw.c
> @@ -37,7 +37,7 @@
>   #include "hw/qdev-properties.h"
>   #include "hw/block/flash.h"
>   #include "sysemu/kvm.h"
> -#include "sysemu/sev.h"
> +#include "sev_i386.h"
>   
>   #define FLASH_SECTOR_SIZE 4096
>   
> 

