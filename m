Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2BE420712
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhJDINo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:13:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230498AbhJDINg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JOTlxYLH0xKyMAM5Ajk4RGdOyX+Cmjh7f4GUhdJsX3w=;
        b=D1XUufkn8tc+rCk7JIqGqpiZffI6j5o7XhxJuWlAbnZdm055WVQ+3WykTJDH0U6m6UkY0D
        QSi6Xn9JNvf9QPWjgUmDeq7EHXRW2qPS9crVpvNSdANV4mrN166nH6rFqFdq7z6XQIGnnu
        Kyt3/lbi2LdjJI5XTX973dh2czLTZ4Y=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-my68apkLNLat2b1j7B-1Og-1; Mon, 04 Oct 2021 04:11:46 -0400
X-MC-Unique: my68apkLNLat2b1j7B-1Og-1
Received: by mail-ed1-f69.google.com with SMTP id t28-20020a508d5c000000b003dad7fc5caeso6465100edt.11
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JOTlxYLH0xKyMAM5Ajk4RGdOyX+Cmjh7f4GUhdJsX3w=;
        b=17IOsCdiYjlHzyb0IvBpXW+PUf+nwcoLHwzG2NYLx2s3kc+aGVFLlE0djqL8ohHcnk
         cfTGvmgc3LjO3pxQC3rDiCKKif+Y4CVOUtBwPJjiQi3F8JUpX1dOSskjkFU6dyEeQyFQ
         OA7f347/0Zl0ZfcEH/rjld4BsJjB8WF44IT3+87TOor+vPHEtgocl28YLuNx4cahLq+d
         cac84fvZhgXTcdbusV8qOEUa7U7vuH1DUpn+JvitoZj2r6/0Q4Qz7tKXaAyheBOBazQu
         V7rQrhWyWaYxmZP+fdJZQWPDLm7Fd8SUh05xpQnam1a0oN4L1hXONz72u0A6uz9855j5
         GV0g==
X-Gm-Message-State: AOAM532eknwR1bP9H00yyepieFsj4g/pvD0P6jbxP5o6c7DQaVIQEsy4
        t9rpeb88KyoU6lUAcMR51jYmTx/vjEVc36z5G3YSuDsb6WNu8wXrxC/Eya82/b4ELNQf52yWjKg
        3vSeQlKDhw2kt
X-Received: by 2002:a17:906:5950:: with SMTP id g16mr16220357ejr.149.1633335104814;
        Mon, 04 Oct 2021 01:11:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzW3bRpHqjWjrgerbOfFgeANw9BAyxffq3xsPvQ0UCB6ZGuKiofp6fNk99tikE6GvBAR6wpgg==
X-Received: by 2002:a17:906:5950:: with SMTP id g16mr16220340ejr.149.1633335104607;
        Mon, 04 Oct 2021 01:11:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q6sm6032505ejm.106.2021.10.04.01.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:11:44 -0700 (PDT)
Message-ID: <a44a2967-a8d5-8fc1-d755-3fe1456370a6@redhat.com>
Date:   Mon, 4 Oct 2021 10:11:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 08/22] target/i386/sev: Remove sev_get_me_mask()
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
 <20211002125317.3418648-9-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-9-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> Unused dead code makes review harder, so remove it.
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/sev_i386.h | 1 -
>   target/i386/sev-stub.c | 5 -----
>   target/i386/sev.c      | 9 ---------
>   3 files changed, 15 deletions(-)
> 
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index f4223f1febf..afa19a0a161 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -25,7 +25,6 @@
>   #define SEV_POLICY_SEV          0x20
>   
>   extern bool sev_es_enabled(void);
> -extern uint64_t sev_get_me_mask(void);
>   extern SevInfo *sev_get_info(void);
>   extern uint32_t sev_get_cbit_position(void);
>   extern uint32_t sev_get_reduced_phys_bits(void);
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index d91c2ece784..eb0c89bf2be 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -25,11 +25,6 @@ bool sev_enabled(void)
>       return false;
>   }
>   
> -uint64_t sev_get_me_mask(void)
> -{
> -    return ~0;
> -}
> -
>   uint32_t sev_get_cbit_position(void)
>   {
>       return 0;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index fa7210473a6..c88cd808410 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -64,7 +64,6 @@ struct SevGuestState {
>       uint8_t api_major;
>       uint8_t api_minor;
>       uint8_t build_id;
> -    uint64_t me_mask;
>       int sev_fd;
>       SevState state;
>       gchar *measurement;
> @@ -362,12 +361,6 @@ sev_es_enabled(void)
>       return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
>   }
>   
> -uint64_t
> -sev_get_me_mask(void)
> -{
> -    return sev_guest ? sev_guest->me_mask : ~0;
> -}
> -
>   uint32_t
>   sev_get_cbit_position(void)
>   {
> @@ -804,8 +797,6 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>           goto err;
>       }
>   
> -    sev->me_mask = ~(1UL << sev->cbitpos);
> -
>       devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
>       sev->sev_fd = open(devname, O_RDWR);
>       if (sev->sev_fd < 0) {
> 

RB

