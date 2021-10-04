Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5376E420742
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhJDI0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:26:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230238AbhJDI0D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:26:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s2wbpkICgHhSrA7oKaJb/nuNpTmppm8SF2u99Et/0YU=;
        b=Ixrbb7lP3S4aiBtC0MzIwywyEDx8a0H02rBGmo7qVrGecEMFwuiPgGIbGg04DQOfxFq7xG
        lK7NM3GQOQsMOxYNQNju1XDyOSoWyq4eb0LnaDxSF9BFJ34ghu/hr/jasDUZ1HB5a8obpO
        wKlTdUv39B9r8i0ZnlodoFObEqd6+fM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-bu3x1V7xOQGMqWk5pUH2fw-1; Mon, 04 Oct 2021 04:24:13 -0400
X-MC-Unique: bu3x1V7xOQGMqWk5pUH2fw-1
Received: by mail-ed1-f70.google.com with SMTP id ec14-20020a0564020d4e00b003cf5630c190so16505586edb.3
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s2wbpkICgHhSrA7oKaJb/nuNpTmppm8SF2u99Et/0YU=;
        b=rUsDe1QTzanCmU8Dbl8glZu3u8W5Qa8Qy/oLgIrJO0ya1Bjy/1k0Rh+3tKwhrCjzGU
         tmoH1Ic/1Vzr3lA3kA2ve3o6dXCC9fUnAKvHLDZO2VarvKvY+xxU8V27TXEfO5eY7suC
         P7vtrVu9MDEHmOq8ELI8P6Ar2ILScC/DzGumdGVww2+b/KNjMNpTq9oGrCosTQlXM6Q6
         PP0OrBsUvxpsZTXzANB/g5i847EFs8TJkptBoceT9qpXgnmCR//7xfrhdyQaGPjn5+jP
         Q/CtSlDjfZ5vf6bZsbCCArMJu2Mnpcwrr2xSsbD1CyxLuN0ETLk42aP1pl1VCKZ5B3D5
         KW6Q==
X-Gm-Message-State: AOAM531Enc2fMEYLqJuS9hdvAISYwkPGu/86peKlpVYnv4KuZFg/Q/nJ
        O7ti6FO2AhnDzvjxrPOfzdfsde9IIhvqxfgr+g1LSwDvAg27EGag3qyz4sLb1qJPKnWHK8fUI2m
        69FNnRXrqNDBw
X-Received: by 2002:a50:9347:: with SMTP id n7mr16072220eda.249.1633335852338;
        Mon, 04 Oct 2021 01:24:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSYRxHjXuIiNzIC9LhjhLDKeJIO/SjrvxZlKS9sHkPCDOIwxpUdwlklnnKa3DULig0sdwbSA==
X-Received: by 2002:a50:9347:: with SMTP id n7mr16072204eda.249.1633335852091;
        Mon, 04 Oct 2021 01:24:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u10sm6737189eds.83.2021.10.04.01.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:24:11 -0700 (PDT)
Message-ID: <6db5d402-518d-ac31-ead4-ab8edd46f113@redhat.com>
Date:   Mon, 4 Oct 2021 10:24:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 15/22] target/i386/sev: Move
 qmp_sev_inject_launch_secret() to sev.c
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
 <20211002125317.3418648-16-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-16-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> Move qmp_sev_inject_launch_secret() from monitor.c to sev.c
> and make sev_inject_launch_secret() static. We don't need the
> stub anymore, remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/monitor.c         | 31 -------------------------------
>   target/i386/sev-sysemu-stub.c |  6 +++---
>   target/i386/sev.c             | 31 +++++++++++++++++++++++++++++++
>   3 files changed, 34 insertions(+), 34 deletions(-)
> 
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index c05d70252a2..188203da6f2 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -733,37 +733,6 @@ SevCapability *qmp_query_sev_capabilities(Error **errp)
>       return sev_get_capabilities(errp);
>   }
>   
> -#define SEV_SECRET_GUID "4c2eb361-7d9b-4cc3-8081-127c90d3d294"
> -struct sev_secret_area {
> -    uint32_t base;
> -    uint32_t size;
> -};
> -
> -void qmp_sev_inject_launch_secret(const char *packet_hdr,
> -                                  const char *secret,
> -                                  bool has_gpa, uint64_t gpa,
> -                                  Error **errp)
> -{
> -    if (!sev_enabled()) {
> -        error_setg(errp, QERR_UNSUPPORTED);
> -        return;
> -    }
> -    if (!has_gpa) {
> -        uint8_t *data;
> -        struct sev_secret_area *area;
> -
> -        if (!pc_system_ovmf_table_find(SEV_SECRET_GUID, &data, NULL)) {
> -            error_setg(errp, "SEV: no secret area found in OVMF,"
> -                       " gpa must be specified.");
> -            return;
> -        }
> -        area = (struct sev_secret_area *)data;
> -        gpa = area->base;
> -    }
> -
> -    sev_inject_launch_secret(packet_hdr, secret, gpa, errp);
> -}
> -
>   SGXInfo *qmp_query_sgx(Error **errp)
>   {
>       return sgx_get_info(errp);
> diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
> index 813b9a6a03b..66b69540aa5 100644
> --- a/target/i386/sev-sysemu-stub.c
> +++ b/target/i386/sev-sysemu-stub.c
> @@ -33,10 +33,10 @@ SevCapability *sev_get_capabilities(Error **errp)
>       return NULL;
>   }
>   
> -int sev_inject_launch_secret(const char *hdr, const char *secret,
> -                             uint64_t gpa, Error **errp)
> +void qmp_sev_inject_launch_secret(const char *packet_header, const char *secret,
> +                                  bool has_gpa, uint64_t gpa, Error **errp)
>   {
> -    return 1;
> +    error_setg(errp, QERR_UNSUPPORTED);
>   }
>   
>   int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 91a217bbb85..2198d550be2 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -949,6 +949,37 @@ int sev_inject_launch_secret(const char *packet_hdr, const char *secret,
>       return 0;
>   }
>   
> +#define SEV_SECRET_GUID "4c2eb361-7d9b-4cc3-8081-127c90d3d294"
> +struct sev_secret_area {
> +    uint32_t base;
> +    uint32_t size;
> +};
> +
> +void qmp_sev_inject_launch_secret(const char *packet_hdr,
> +                                  const char *secret,
> +                                  bool has_gpa, uint64_t gpa,
> +                                  Error **errp)
> +{
> +    if (!sev_enabled()) {
> +        error_setg(errp, QERR_UNSUPPORTED);
> +        return;
> +    }
> +    if (!has_gpa) {
> +        uint8_t *data;
> +        struct sev_secret_area *area;
> +
> +        if (!pc_system_ovmf_table_find(SEV_SECRET_GUID, &data, NULL)) {
> +            error_setg(errp, "SEV: no secret area found in OVMF,"
> +                       " gpa must be specified.");
> +            return;
> +        }
> +        area = (struct sev_secret_area *)data;
> +        gpa = area->base;
> +    }
> +
> +    sev_inject_launch_secret(packet_hdr, secret, gpa, errp);
> +}
> +
>   static int
>   sev_es_parse_reset_block(SevInfoBlock *info, uint32_t *addr)
>   {
> 

Ok, this indirectly addresses my comment on patch 5.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

