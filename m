Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB758420744
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhJDI0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:26:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231318AbhJDI0a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w509nbdg8JL5H/S2ZdE6yOSvT63DYCsGYgqBOg4h6xw=;
        b=XfIB4HHJEQv0qzWBTyXC8GaI1U6BJ5+wyphOpdSiMrORSFyjIxo77TwkxITG5TYEBYknzP
        BBnJoy6eEWKHGPwbpm0jRGS25yBDERoTiwL/4nd7/20hiMNeoYLwWchAYjBhn4e0iFbwdV
        qssU+sRvx8G+LMGyQGP2dLNwjdO/MUQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-7tRgMMOfPqGdB4a9dNReHw-1; Mon, 04 Oct 2021 04:24:40 -0400
X-MC-Unique: 7tRgMMOfPqGdB4a9dNReHw-1
Received: by mail-ed1-f70.google.com with SMTP id n19-20020a509353000000b003dad185759bso8482605eda.6
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w509nbdg8JL5H/S2ZdE6yOSvT63DYCsGYgqBOg4h6xw=;
        b=f4tg28yqVK95Kx3yTSQYxib/ugQ8LP35TEzejGLu+iznVNKLzonEzg50CEGj6A/OVr
         W0rp0lgMd46Xzw4TM2blbJxR66M4jOaGSxNufkrgXEO3L4izdMl9uYFSdZBFSsjFX+m2
         XN4VBy/XKAaf2/oxdU3THT4flAm872Xg/GM2+AzCXONNqmzAsh+EUKkrzXOKxamowwj5
         c0RNIa/awGWKSjvmxOU+dLxb2r0sZi0kt5QeIKfTOJp026pOBAdmM1fBkFmaQAwFQeij
         8A2Rx8GWxwxkDiaNrpWa/pMgjVnho8w4AlIQreUgVbtPwOoFs59BZFGE/gNxAnZLEhS4
         8qMA==
X-Gm-Message-State: AOAM530HuGmKS9TSWTDRo+P76Y7/8h7nFVtnMPkCC5IUZ6VVcPkcMq9d
        EfSIkClkRKU4krp3hMb8qO+SRqZN2hVmoBYYtbTscieAdrED8HEFENmW57PGDsnamHHbfYgIdE2
        /cw2daaA5+N5F
X-Received: by 2002:a05:6402:35c9:: with SMTP id z9mr1392655edc.174.1633335879100;
        Mon, 04 Oct 2021 01:24:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1A9pPlY+x/EAis1SWI+1SZYm1j/pBPT8XG3HQkWLg8ugz12kqQjFiV+OfH8qb6mZC65y9pg==
X-Received: by 2002:a05:6402:35c9:: with SMTP id z9mr1392639edc.174.1633335878901;
        Mon, 04 Oct 2021 01:24:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d21sm4933933edp.27.2021.10.04.01.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:24:38 -0700 (PDT)
Message-ID: <17ad4157-8c17-153d-540e-5ca0923d4e51@redhat.com>
Date:   Mon, 4 Oct 2021 10:24:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 17/22] target/i386/sev: Move
 qmp_query_sev_launch_measure() to sev.c
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
 <20211002125317.3418648-18-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-18-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> Move qmp_query_sev_launch_measure() from monitor.c to sev.c
> and make sev_get_launch_measurement() static. We don't need the
> stub anymore, remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/sev_i386.h        |  1 -
>   target/i386/monitor.c         | 17 -----------------
>   target/i386/sev-sysemu-stub.c |  3 ++-
>   target/i386/sev.c             | 20 ++++++++++++++++++--
>   4 files changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index 8d9388d8c5c..1699376ad87 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -25,7 +25,6 @@
>   #define SEV_POLICY_SEV          0x20
>   
>   extern SevInfo *sev_get_info(void);
> -extern char *sev_get_launch_measurement(void);
>   
>   int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
>   int sev_inject_launch_secret(const char *hdr, const char *secret,
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index da36522fa15..0b38e970c73 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -711,23 +711,6 @@ void hmp_info_sev(Monitor *mon, const QDict *qdict)
>       qapi_free_SevInfo(info);
>   }
>   
> -SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
> -{
> -    char *data;
> -    SevLaunchMeasureInfo *info;
> -
> -    data = sev_get_launch_measurement();
> -    if (!data) {
> -        error_setg(errp, "Measurement is not available");
> -        return NULL;
> -    }
> -
> -    info = g_malloc0(sizeof(*info));
> -    info->data = data;
> -
> -    return info;
> -}
> -
>   SGXInfo *qmp_query_sgx(Error **errp)
>   {
>       return sgx_get_info(errp);
> diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
> index cc486a1afbe..355391c16c4 100644
> --- a/target/i386/sev-sysemu-stub.c
> +++ b/target/i386/sev-sysemu-stub.c
> @@ -22,8 +22,9 @@ SevInfo *sev_get_info(void)
>       return NULL;
>   }
>   
> -char *sev_get_launch_measurement(void)
> +SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
>   {
> +    error_setg(errp, QERR_UNSUPPORTED);
>       return NULL;
>   }
>   
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index fce007d6749..8e9cce62196 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -718,8 +718,7 @@ free_measurement:
>       g_free(measurement);
>   }
>   
> -char *
> -sev_get_launch_measurement(void)
> +static char *sev_get_launch_measurement(void)
>   {
>       if (sev_guest &&
>           sev_guest->state >= SEV_STATE_LAUNCH_SECRET) {
> @@ -729,6 +728,23 @@ sev_get_launch_measurement(void)
>       return NULL;
>   }
>   
> +SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
> +{
> +    char *data;
> +    SevLaunchMeasureInfo *info;
> +
> +    data = sev_get_launch_measurement();
> +    if (!data) {
> +        error_setg(errp, "Measurement is not available");
> +        return NULL;
> +    }
> +
> +    info = g_malloc0(sizeof(*info));
> +    info->data = data;
> +
> +    return info;
> +}
> +
>   static Notifier sev_machine_done_notify = {
>       .notify = sev_launch_get_measure,
>   };
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

