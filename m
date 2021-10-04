Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A932420743
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhJDI0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:26:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230238AbhJDI0V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=If+ReMAvz+ryketUBLo8OA3JB2QhFDQlrmRnIMs/CXU=;
        b=UFWwdVOUQ1FD3/NzYz6REUAbpTu2J10VveVhw1oEtDLyTd6Y81TRINTjQRmuOqNLKGJB7+
        z42rEI2L0pPr1t28JOIOvpfytkqJhmUFb9oaLQO0HfNN/r3bFlZl/DJoJimIIcVJra8HAC
        pg8gqMABymgA5f+PMz0zCqZfmTqXIB4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-X7qXjRWLObaIhGFXDeBCjQ-1; Mon, 04 Oct 2021 04:24:30 -0400
X-MC-Unique: X7qXjRWLObaIhGFXDeBCjQ-1
Received: by mail-ed1-f72.google.com with SMTP id r11-20020aa7cfcb000000b003d4fbd652b9so16386136edy.14
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=If+ReMAvz+ryketUBLo8OA3JB2QhFDQlrmRnIMs/CXU=;
        b=4heOZzVD3UCpVOWOArxBW10noMUrnApNQ6jfQwVXn6cSV0DfxLGxRK5L6SEwnhL9hT
         xUZJ0k9TTYJgqgITbIjRAc5TqSGu4cUE5kimJ8hS58iWFJQtS0bjDW+4cAHTwmOSUegY
         WQteqIwh2Z6quhUOvq3VV3gR5lZSAH2Oaax+x4hewPVt1/8yj6swyEdL5EoXsGSutG88
         cVCN2q1QOMSCCYrw4UFSqG2+GM7hyGSt/NNyLTx8Zb8iupDWeherTWeoSxjMWS00jFW+
         iF78XKGxkKj2Iy4HBguUd0qe92PpVHFb8NUysiNkI6ouHz3awUPWWvNNxg9KB76WqkWf
         Fsrw==
X-Gm-Message-State: AOAM532V80u9aPyFxr9BH5XwFffAyh5CX6gdTBQAfrczlJEf7oll1t3l
        9WXm7ybaHLmZUdoJFCUaak4C1qpI1qauuatXMWQ4kkvrL4j+RdUERhJYqq5ONW4pZdYPMRvekHJ
        OfegkgtpxF4+F
X-Received: by 2002:a05:6402:143b:: with SMTP id c27mr16981915edx.224.1633335869154;
        Mon, 04 Oct 2021 01:24:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDeMdqlj0O9bsJxnESsAIptrfSTAzM8EvFxHRZ47LFFjvMhiABonkHnbCuplcc+QE0NlEeQQ==
X-Received: by 2002:a05:6402:143b:: with SMTP id c27mr16981897edx.224.1633335868977;
        Mon, 04 Oct 2021 01:24:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b2sm5205962ejz.119.2021.10.04.01.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:24:28 -0700 (PDT)
Message-ID: <b5d73095-9348-ecb2-e9a7-1ec038cc85e6@redhat.com>
Date:   Mon, 4 Oct 2021 10:24:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 16/22] target/i386/sev: Move
 qmp_query_sev_capabilities() to sev.c
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
 <20211002125317.3418648-17-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-17-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> Move qmp_query_sev_capabilities() from monitor.c to sev.c
> and make sev_get_capabilities() static. We don't need the
> stub anymore, remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/sev_i386.h        | 1 -
>   target/i386/monitor.c         | 5 -----
>   target/i386/sev-sysemu-stub.c | 4 ++--
>   target/i386/sev.c             | 8 ++++++--
>   4 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index 5f367f78eb7..8d9388d8c5c 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -26,7 +26,6 @@
>   
>   extern SevInfo *sev_get_info(void);
>   extern char *sev_get_launch_measurement(void);
> -extern SevCapability *sev_get_capabilities(Error **errp);
>   
>   int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
>   int sev_inject_launch_secret(const char *hdr, const char *secret,
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index 188203da6f2..da36522fa15 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -728,11 +728,6 @@ SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
>       return info;
>   }
>   
> -SevCapability *qmp_query_sev_capabilities(Error **errp)
> -{
> -    return sev_get_capabilities(errp);
> -}
> -
>   SGXInfo *qmp_query_sgx(Error **errp)
>   {
>       return sgx_get_info(errp);
> diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
> index 66b69540aa5..cc486a1afbe 100644
> --- a/target/i386/sev-sysemu-stub.c
> +++ b/target/i386/sev-sysemu-stub.c
> @@ -27,9 +27,9 @@ char *sev_get_launch_measurement(void)
>       return NULL;
>   }
>   
> -SevCapability *sev_get_capabilities(Error **errp)
> +SevCapability *qmp_query_sev_capabilities(Error **errp)
>   {
> -    error_setg(errp, "SEV is not available in this QEMU");
> +    error_setg(errp, QERR_UNSUPPORTED);
>       return NULL;
>   }
>   
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 2198d550be2..fce007d6749 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -438,8 +438,7 @@ e_free:
>       return 1;
>   }
>   
> -SevCapability *
> -sev_get_capabilities(Error **errp)
> +static SevCapability *sev_get_capabilities(Error **errp)
>   {
>       SevCapability *cap = NULL;
>       guchar *pdh_data = NULL;
> @@ -489,6 +488,11 @@ out:
>       return cap;
>   }
>   
> +SevCapability *qmp_query_sev_capabilities(Error **errp)
> +{
> +    return sev_get_capabilities(errp);
> +}
> +
>   static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>                                                           Error **errp)
>   {
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

