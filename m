Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0543F420745
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhJDI0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:26:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231318AbhJDI0w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:26:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5p0WShUJO7CqPDKHOUTKSobWwa9C6tme/99NhNxiCzc=;
        b=aIxW4VMZy50O17NbZijmkFr8b5te0L2zZxko7xkQIvUaoocv4Hw9VJrcNpyatkCtqgTQhC
        86uVpnGjOHqRaKE3kGiw3Q1BQUSwPbTGSHZjYCidgk6H/yCm135318ISiAGqz27vEexdQR
        937AJ3fCwgBnauRSYfHWzq3Ue84/AVA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-GxkS4LTeM0ivw-RKeyV66w-1; Mon, 04 Oct 2021 04:25:03 -0400
X-MC-Unique: GxkS4LTeM0ivw-RKeyV66w-1
Received: by mail-ed1-f72.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so16390981edi.12
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5p0WShUJO7CqPDKHOUTKSobWwa9C6tme/99NhNxiCzc=;
        b=TBYqVCSfcFRtfBkqi4vjoCHhwxmY+tpMhrfzdTT7UB8N0V3zxuSwS7TRMIC+5DDZtB
         CHdY5kmxFWJr4gRQ8clfCpyLJyHfXjr9dYMLcRHdcP6msNsW7up0WN209Ov9BIgZTzZW
         kVb06sxtm04katd7d3bo8sljdukLu0jZZ4bzstDhaF6wxCojqaSDSdnuz2WJtB0yFJ9l
         YXDUyXXGxNOuOZEDpIjoEkx/nDeQdrfMvsh5mKN1JCKbUVHCOVj979+cFB3XigmMQneD
         NHlduQiKwXy5zHfM4Gz0rfz1SEm++FWCOI3+rS8ShHZbGLbSK0THxD+a0WYE8T++52F0
         iJcQ==
X-Gm-Message-State: AOAM530kr23Ad4+kT5ES1dfV/thoRN7wzORT1zz4/4eHBhFTvDzyo1kG
        c2y3nNj/iSej2G/VtBzzFs/frSxOiS5wUlxScf4cczmEXNFKSFn/F7GdPQz/y+UsIZq3a9gTW03
        6dy3gbGeOnOJZ
X-Received: by 2002:a17:906:4346:: with SMTP id z6mr16073282ejm.403.1633335901892;
        Mon, 04 Oct 2021 01:25:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmvtTKKQjQI/M/2BONIWDf/ukyBxYzgH+RMfeVzgyCawpny7gazi+i24s0XQViwue6mXE8NA==
X-Received: by 2002:a17:906:4346:: with SMTP id z6mr16073261ejm.403.1633335901655;
        Mon, 04 Oct 2021 01:25:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l16sm6870373eds.46.2021.10.04.01.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:25:00 -0700 (PDT)
Message-ID: <a8bcc533-8432-c5a0-a00a-77f78fe23768@redhat.com>
Date:   Mon, 4 Oct 2021 10:24:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 18/22] target/i386/sev: Move qmp_query_sev() &
 hmp_info_sev() to sev.c
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
 <20211002125317.3418648-19-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-19-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> Move qmp_query_sev() & hmp_info_sev()() from monitor.c to sev.c
> and make sev_get_info() static. We don't need the stub anymore,
> remove it. Add a stub for hmp_info_sev().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/sev_i386.h        |  3 ---
>   target/i386/monitor.c         | 38 +---------------------------------
>   target/i386/sev-sysemu-stub.c | 10 ++++++++-
>   target/i386/sev.c             | 39 +++++++++++++++++++++++++++++++++--
>   4 files changed, 47 insertions(+), 43 deletions(-)
> 
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index 1699376ad87..15a959d6174 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -15,7 +15,6 @@
>   #define QEMU_SEV_I386_H
>   
>   #include "sysemu/sev.h"
> -#include "qapi/qapi-types-misc-target.h"
>   
>   #define SEV_POLICY_NODBG        0x1
>   #define SEV_POLICY_NOKS         0x2
> @@ -24,8 +23,6 @@
>   #define SEV_POLICY_DOMAIN       0x10
>   #define SEV_POLICY_SEV          0x20
>   
> -extern SevInfo *sev_get_info(void);
> -
>   int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
>   int sev_inject_launch_secret(const char *hdr, const char *secret,
>                                uint64_t gpa, Error **errp);
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index 0b38e970c73..890870b252d 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -28,11 +28,9 @@
>   #include "monitor/hmp-target.h"
>   #include "monitor/hmp.h"
>   #include "qapi/qmp/qdict.h"
> -#include "qapi/qmp/qerror.h"
> +//#include "qapi/qmp/qerror.h"
>   #include "sysemu/kvm.h"
> -#include "sysemu/sev.h"
>   #include "qapi/error.h"
> -#include "sev_i386.h"
>   #include "qapi/qapi-commands-misc-target.h"
>   #include "qapi/qapi-commands-misc.h"
>   #include "hw/i386/pc.h"
> @@ -677,40 +675,6 @@ void hmp_info_io_apic(Monitor *mon, const QDict *qdict)
>                      "removed soon. Please use 'info pic' instead.\n");
>   }
>   
> -SevInfo *qmp_query_sev(Error **errp)
> -{
> -    SevInfo *info;
> -
> -    info = sev_get_info();
> -    if (!info) {
> -        error_setg(errp, "SEV feature is not available");
> -        return NULL;
> -    }
> -
> -    return info;
> -}
> -
> -void hmp_info_sev(Monitor *mon, const QDict *qdict)
> -{
> -    SevInfo *info = sev_get_info();
> -
> -    if (info && info->enabled) {
> -        monitor_printf(mon, "handle: %d\n", info->handle);
> -        monitor_printf(mon, "state: %s\n", SevState_str(info->state));
> -        monitor_printf(mon, "build: %d\n", info->build_id);
> -        monitor_printf(mon, "api version: %d.%d\n",
> -                       info->api_major, info->api_minor);
> -        monitor_printf(mon, "debug: %s\n",
> -                       info->policy & SEV_POLICY_NODBG ? "off" : "on");
> -        monitor_printf(mon, "key-sharing: %s\n",
> -                       info->policy & SEV_POLICY_NOKS ? "off" : "on");
> -    } else {
> -        monitor_printf(mon, "SEV is not enabled\n");
> -    }
> -
> -    qapi_free_SevInfo(info);
> -}
> -
>   SGXInfo *qmp_query_sgx(Error **errp)
>   {
>       return sgx_get_info(errp);
> diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
> index 355391c16c4..1836b32e4fc 100644
> --- a/target/i386/sev-sysemu-stub.c
> +++ b/target/i386/sev-sysemu-stub.c
> @@ -12,13 +12,16 @@
>    */
>   
>   #include "qemu/osdep.h"
> +#include "monitor/monitor.h"
> +#include "monitor/hmp.h"
>   #include "qapi/qapi-commands-misc-target.h"
>   #include "qapi/qmp/qerror.h"
>   #include "qapi/error.h"
>   #include "sev_i386.h"
>   
> -SevInfo *sev_get_info(void)
> +SevInfo *qmp_query_sev(Error **errp)
>   {
> +    error_setg(errp, QERR_UNSUPPORTED);
>       return NULL;
>   }
>   
> @@ -60,3 +63,8 @@ SevAttestationReport *qmp_query_sev_attestation_report(const char *mnonce,
>       error_setg(errp, QERR_UNSUPPORTED);
>       return NULL;
>   }
> +
> +void hmp_info_sev(Monitor *mon, const QDict *qdict)
> +{
> +    monitor_printf(mon, "SEV is not available in this QEMU\n");
> +}
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 8e9cce62196..7caaa117ff7 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -27,10 +27,12 @@
>   #include "sev_i386.h"
>   #include "sysemu/sysemu.h"
>   #include "sysemu/runstate.h"
> +#include "sysemu/sev.h"
>   #include "trace.h"
>   #include "migration/blocker.h"
>   #include "qom/object.h"
>   #include "monitor/monitor.h"
> +#include "monitor/hmp.h"
>   #include "qapi/qapi-commands-misc-target.h"
>   #include "qapi/qmp/qerror.h"
>   #include "exec/confidential-guest-support.h"
> @@ -375,8 +377,7 @@ sev_get_reduced_phys_bits(void)
>       return sev_guest ? sev_guest->reduced_phys_bits : 0;
>   }
>   
> -SevInfo *
> -sev_get_info(void)
> +static SevInfo *sev_get_info(void)
>   {
>       SevInfo *info;
>   
> @@ -395,6 +396,40 @@ sev_get_info(void)
>       return info;
>   }
>   
> +SevInfo *qmp_query_sev(Error **errp)
> +{
> +    SevInfo *info;
> +
> +    info = sev_get_info();
> +    if (!info) {
> +        error_setg(errp, "SEV feature is not available");
> +        return NULL;
> +    }
> +
> +    return info;
> +}
> +
> +void hmp_info_sev(Monitor *mon, const QDict *qdict)
> +{
> +    SevInfo *info = sev_get_info();
> +
> +    if (info && info->enabled) {
> +        monitor_printf(mon, "handle: %d\n", info->handle);
> +        monitor_printf(mon, "state: %s\n", SevState_str(info->state));
> +        monitor_printf(mon, "build: %d\n", info->build_id);
> +        monitor_printf(mon, "api version: %d.%d\n",
> +                       info->api_major, info->api_minor);
> +        monitor_printf(mon, "debug: %s\n",
> +                       info->policy & SEV_POLICY_NODBG ? "off" : "on");
> +        monitor_printf(mon, "key-sharing: %s\n",
> +                       info->policy & SEV_POLICY_NOKS ? "off" : "on");
> +    } else {
> +        monitor_printf(mon, "SEV is not enabled\n");
> +    }
> +
> +    qapi_free_SevInfo(info);
> +}
> +
>   static int
>   sev_get_pdh_info(int fd, guchar **pdh, size_t *pdh_len, guchar **cert_chain,
>                    size_t *cert_chain_len, Error **errp)
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

