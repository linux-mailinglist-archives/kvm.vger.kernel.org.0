Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEFB42071F
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhJDIQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:16:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230507AbhJDIP7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:15:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rt2taUi3UZfF6a3Ec9kR8v+p4tUBOzrc9UaCrS4J7ZQ=;
        b=IGFzdS7IkuVIMEZL28eZxgYTq72vJDsJ/Q1E8mOnrIjZxufKXfmh3aVS/Fq527XtX+HpzJ
        oulw4Sny78rgfdECFnOkMpCyXd2tyCJ3H7Idw8aOlc2wqAchhJwE0zUEu9bBWOm6Vrgvqp
        +Fohbs9ar2ICAULlIebodQ0kMNioZbo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-bKRGlz7aNMK_wuRDvjs8wA-1; Mon, 04 Oct 2021 04:14:10 -0400
X-MC-Unique: bKRGlz7aNMK_wuRDvjs8wA-1
Received: by mail-ed1-f69.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso16416089edx.2
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Rt2taUi3UZfF6a3Ec9kR8v+p4tUBOzrc9UaCrS4J7ZQ=;
        b=uncPL3+rCMNa9Lnc5vVEvKYGCC2o6uFiM1re9i8FjgetUT+vZralWozx8fiHl05osW
         iP6Cvu12S3sruYHui5+FGg8K1WEWfE/6kyzFnhlX54B9ti9RPoI6UrDx87PtZdmH1dGx
         UM3urxhKOKuZpe/GIZr6zTAQHnyqA23ffT3y0DzTeQap+kkeCHxXRxMfzB52aCYaxlek
         Wbheo59cn8Om81nMI64eO0w61ayu698HS2it9EBAIZxzdNUKsAFcn11bYQea3ckH0q5l
         aW2canTSG57Cgj47HHi3jXOlDIdX2mMWsyMqzrC9Cz/gYFdAJMYX7y2G01GNZcfwejkW
         r5ng==
X-Gm-Message-State: AOAM530EPssdAD/LbFo4R9uN9DwPBWtmisaeJ3a1T6r9Xa48EETL2GVn
        ACjgCcUkgvoz8J6M5a9TvxmBESe/az/W6MN9p6vf1DRDhY8FPaaq0+TALqGx1Wa0zkRQ9SBkZN1
        b9V4g6pNAhpUL
X-Received: by 2002:a17:906:608e:: with SMTP id t14mr15425342ejj.441.1633335248830;
        Mon, 04 Oct 2021 01:14:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTRL4sn3Euzn1Zet9vyUC7zl8KlL6EeelDz+8ey4amnehlwoyWgkbJyaxQwbwQGTUGIns5Bw==
X-Received: by 2002:a17:906:608e:: with SMTP id t14mr15425309ejj.441.1633335248547;
        Mon, 04 Oct 2021 01:14:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gl2sm6125190ejb.110.2021.10.04.01.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:14:08 -0700 (PDT)
Message-ID: <dfe5c054-b2dc-9bb5-5b15-fe6e51f2f98e@redhat.com>
Date:   Mon, 4 Oct 2021 10:14:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 11/22] target/i386/sev: Restrict SEV to system
 emulation
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
 <20211002125317.3418648-12-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-12-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> SEV is irrelevant on user emulation, so restrict it to sysemu.
> Some stubs are still required because used in cpu.c by
> x86_register_cpudef_types(), so move the sysemu specific stubs
> to sev-sysemu-stub.c instead. This will allow us to simplify
> monitor.c (which is not available in user emulation) in the
> next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/sev-stub.c        | 43 -------------------------
>   target/i386/sev-sysemu-stub.c | 60 +++++++++++++++++++++++++++++++++++
>   target/i386/meson.build       |  4 ++-
>   3 files changed, 63 insertions(+), 44 deletions(-)
>   create mode 100644 target/i386/sev-sysemu-stub.c
> 
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index 4668365fd3e..8eae5d2fa8d 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -15,11 +15,6 @@
>   #include "qapi/error.h"
>   #include "sev_i386.h"
>   
> -SevInfo *sev_get_info(void)
> -{
> -    return NULL;
> -}
> -
>   bool sev_enabled(void)
>   {
>       return false;
> @@ -35,45 +30,7 @@ uint32_t sev_get_reduced_phys_bits(void)
>       return 0;
>   }
>   
> -char *sev_get_launch_measurement(void)
> -{
> -    return NULL;
> -}
> -
> -SevCapability *sev_get_capabilities(Error **errp)
> -{
> -    error_setg(errp, "SEV is not available in this QEMU");
> -    return NULL;
> -}
> -
> -int sev_inject_launch_secret(const char *hdr, const char *secret,
> -                             uint64_t gpa, Error **errp)
> -{
> -    return 1;
> -}
> -
> -int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
> -{
> -    g_assert_not_reached();
> -}
> -
>   bool sev_es_enabled(void)
>   {
>       return false;
>   }
> -
> -void sev_es_set_reset_vector(CPUState *cpu)
> -{
> -}
> -
> -int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
> -{
> -    g_assert_not_reached();
> -}
> -
> -SevAttestationReport *
> -sev_get_attestation_report(const char *mnonce, Error **errp)
> -{
> -    error_setg(errp, "SEV is not available in this QEMU");
> -    return NULL;
> -}
> diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
> new file mode 100644
> index 00000000000..d556b4f091f
> --- /dev/null
> +++ b/target/i386/sev-sysemu-stub.c
> @@ -0,0 +1,60 @@
> +/*
> + * QEMU SEV system stub
> + *
> + * Copyright Advanced Micro Devices 2018
> + *
> + * Authors:
> + *      Brijesh Singh <brijesh.singh@amd.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/qapi-commands-misc-target.h"
> +#include "qapi/error.h"
> +#include "sev_i386.h"
> +
> +SevInfo *sev_get_info(void)
> +{
> +    return NULL;
> +}
> +
> +char *sev_get_launch_measurement(void)
> +{
> +    return NULL;
> +}
> +
> +SevCapability *sev_get_capabilities(Error **errp)
> +{
> +    error_setg(errp, "SEV is not available in this QEMU");
> +    return NULL;
> +}
> +
> +int sev_inject_launch_secret(const char *hdr, const char *secret,
> +                             uint64_t gpa, Error **errp)
> +{
> +    return 1;
> +}
> +
> +int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
> +{
> +    g_assert_not_reached();
> +}
> +
> +void sev_es_set_reset_vector(CPUState *cpu)
> +{
> +}
> +
> +int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
> +{
> +    g_assert_not_reached();
> +}
> +
> +SevAttestationReport *sev_get_attestation_report(const char *mnonce,
> +                                                 Error **errp)
> +{
> +    error_setg(errp, "SEV is not available in this QEMU");
> +    return NULL;
> +}
> diff --git a/target/i386/meson.build b/target/i386/meson.build
> index dac19ec00d4..a4f45c3ec1d 100644
> --- a/target/i386/meson.build
> +++ b/target/i386/meson.build
> @@ -6,7 +6,7 @@
>     'xsave_helper.c',
>     'cpu-dump.c',
>   ))
> -i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c', 'sev.c'), if_false: files('sev-stub.c'))
> +i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c'), if_false: files('sev-stub.c'))
>   
>   # x86 cpu type
>   i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
> @@ -20,6 +20,8 @@
>     'monitor.c',
>     'cpu-sysemu.c',
>   ))
> +i386_softmmu_ss.add(when: 'CONFIG_SEV', if_true: files('sev.c'), if_false: files('sev-sysemu-stub.c'))
> +
>   i386_user_ss = ss.source_set()
>   
>   subdir('kvm')
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

