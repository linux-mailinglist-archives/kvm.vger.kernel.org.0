Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E1D420714
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhJDINz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:13:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230451AbhJDINs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxt3IlMwGgH/3HVBb8TMDbjlbaO6BWLe0pI5QdapWsE=;
        b=HAf+UD1QgjgyQeIuw2tYWqM7QePjwLs/Eri0Q/0BU7NW+VViZP9/XNdVKYPQX0Csl5sQzc
        Zxf1IR1RFijso3DYZKfh9crwq3DfWWxwXSZjdS6RjG8AlOHZEa8GehJhKlkWi82+wLlSeV
        xbMzjDCHk07k+Rlw/LquDMYXYwCWoWM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-O7NDLURqM3OgL86aI4HOKQ-1; Mon, 04 Oct 2021 04:11:57 -0400
X-MC-Unique: O7NDLURqM3OgL86aI4HOKQ-1
Received: by mail-ed1-f72.google.com with SMTP id m20-20020aa7c2d4000000b003d1add00b8aso16445808edp.0
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:11:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nxt3IlMwGgH/3HVBb8TMDbjlbaO6BWLe0pI5QdapWsE=;
        b=U89j2csBm1jj0oX044c9i/Q/ro5m2wgoJ68TJT2exuD3pKeycnev4BYRFbJZ0GnPko
         dSPsezJPbId5N/VXGJS6+ObwlADNOd+jGPmdmakeJOlVjt4m+3waGiXfANsxQMBrXHNr
         spRZKKCexim1Lags1cIGVHvYAFymSS0LUyoxB8t1rlEOWOsxWztlxQrxcctns9Xy7mSc
         5lnK27LjGgB8RxeB3kB+tzERyNpeIM79W4spvzUjNhERMGqXcVHBDJ7hF7r62/1vcoaJ
         A3wXI/rOJHSJTTezAYnbR4wf3T+AO0gJkjoNjLRBOWmDt33VpYBdiEb+Ts7fRsBnxqCJ
         5n3g==
X-Gm-Message-State: AOAM5335bgK5IX1cily7Rir3wy01DCwo7x2U8i39fHadvRoZpoHBayB/
        TbuBFXJAYPBKsr7rO7YO3dJ9+ETiqpEb88G6dyMlpxsKEuEvxamXYOmKBdRXD3OJeBo6szp7yuH
        C27iV/97D6Zj/
X-Received: by 2002:a17:907:7691:: with SMTP id jv17mr14785998ejc.378.1633335115567;
        Mon, 04 Oct 2021 01:11:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKXY/Mp02EhfUz9ie5EsTxFIrQa3PTxzv66us1lXEt4B0npQdV/hooBBhLcAdHgBNpUXLPMw==
X-Received: by 2002:a17:907:7691:: with SMTP id jv17mr14785972ejc.378.1633335115299;
        Mon, 04 Oct 2021 01:11:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c6sm5887814ejs.4.2021.10.04.01.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:11:54 -0700 (PDT)
Message-ID: <890d12fc-c2ee-0857-fd66-3d0893990885@redhat.com>
Date:   Mon, 4 Oct 2021 10:11:48 +0200
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

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

