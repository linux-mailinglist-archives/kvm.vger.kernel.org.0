Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C49420719
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhJDIPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:15:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29994 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230507AbhJDIPB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnDhtF1ATr+X66DQ/Xxg2LJW4VZx0oJz8BmVOuCxHZY=;
        b=bf993WbuP4US9akAIXhQEuXQmyPpZbTOFgHW8QlB5wcpw1mvA+hDZNwVnnSL6DsVLAF3Vz
        FhYqTZTsmOGLsoxN8HfATbK1jgMlVCEcALGAaJmJHJsqWHqgJXmHnzi8+z759BBmdm6569
        VbmbtW08Q7wpSYbPO5tIjmrwgyQly5Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-sqovV4A1OnagS5eGCHqTzg-1; Mon, 04 Oct 2021 04:13:11 -0400
X-MC-Unique: sqovV4A1OnagS5eGCHqTzg-1
Received: by mail-ed1-f69.google.com with SMTP id k10-20020a508aca000000b003dad77857f7so477789edk.22
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dnDhtF1ATr+X66DQ/Xxg2LJW4VZx0oJz8BmVOuCxHZY=;
        b=ShgQ0JaOmzMnOxCwl5DML9ozNz+kdM8DqIOO31aqctPfLUZCL2N021zJZ5bvxIIAfZ
         gzyAYzP9dM+Grn2UEI5iOVa1IIrqxgn1s20AgvOc5O/vNOH32Jgq4QjWtU6WeyIj0//U
         qTsl45+zy+FzVGZOo173s/FbjFOg17TakZ7f204A01MyM+q2H5bVrlcH/4R/zLAPcMfY
         sXdDK1Ag/H+5p/qY1SGevwQANQKJwbxGasK4I/Lz+afoI6gx4PC8Rfdjatly3kOpfgL/
         BUd/teN6C28f963liO6glthFzMqcYvmIwBnTg/JwrCFhP9a5zswMoxLj8Ys8DniEv9hM
         cesA==
X-Gm-Message-State: AOAM5338c8YiaZX7+dFuLzNGhM+lzSK87qwDFiUptT/nTy4QIMNs0f6Y
        78Ls81ZWRuzovQnI+YwmJ2YT1CnC7gA5oZf+Kyp2dPofrABWo6Ls9p++t7ImIv6fd8etumh/ZAu
        +y823H/YKc9Ay
X-Received: by 2002:aa7:da1a:: with SMTP id r26mr5865696eds.229.1633335190403;
        Mon, 04 Oct 2021 01:13:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwv8vCYqFd2dvvuwLaT8aXyPctMi9hMyDS7UrB6lf81VpZZ0rVRJjTpuz2iIYPr95l2n5ZDMA==
X-Received: by 2002:aa7:da1a:: with SMTP id r26mr5865675eds.229.1633335190175;
        Mon, 04 Oct 2021 01:13:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e1sm6959005edc.45.2021.10.04.01.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:13:09 -0700 (PDT)
Message-ID: <5920c7f9-df55-9fc9-c88c-0ddfa86f7004@redhat.com>
Date:   Mon, 4 Oct 2021 10:13:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 10/22] target/i386/sev: sev_get_attestation_report use
 g_autofree
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-11-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-11-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Removes a whole bunch of g_free's and a goto.
> 
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
> Message-Id: <20210603113017.34922-1-dgilbert@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/sev.c | 11 +++--------
>   1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index c88cd808410..aefbef4bb63 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -493,8 +493,8 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
>       struct kvm_sev_attestation_report input = {};
>       SevAttestationReport *report = NULL;
>       SevGuestState *sev = sev_guest;
> -    guchar *data;
> -    guchar *buf;
> +    g_autofree guchar *data = NULL;
> +    g_autofree guchar *buf = NULL;
>       gsize len;
>       int err = 0, ret;
>   
> @@ -514,7 +514,6 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
>       if (len != sizeof(input.mnonce)) {
>           error_setg(errp, "SEV: mnonce must be %zu bytes (got %" G_GSIZE_FORMAT ")",
>                   sizeof(input.mnonce), len);
> -        g_free(buf);
>           return NULL;
>       }
>   
> @@ -525,7 +524,6 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
>           if (err != SEV_RET_INVALID_LEN) {
>               error_setg(errp, "failed to query the attestation report length "
>                       "ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
> -            g_free(buf);
>               return NULL;
>           }
>       }
> @@ -540,7 +538,7 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
>       if (ret) {
>           error_setg_errno(errp, errno, "Failed to get attestation report"
>                   " ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
> -        goto e_free_data;
> +        return NULL;
>       }
>   
>       report = g_new0(SevAttestationReport, 1);
> @@ -548,9 +546,6 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
>   
>       trace_kvm_sev_attestation_report(mnonce, report->data);
>   
> -e_free_data:
> -    g_free(data);
> -    g_free(buf);
>       return report;
>   }
>   
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

