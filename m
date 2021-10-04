Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D07420703
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhJDIIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:08:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230517AbhJDIIk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:08:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633334811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jJXy9qbxdg2C9dmRq5ZlX/rnrXy4McozWIE5caJXRxA=;
        b=A64NoceB+iQ3Lgj7w++WwIRp9G/gZCNAYxRLOo2yjrsQZ2D1fECK4vrSLJHUtD5faMjIQa
        q9QPWURjXoff843oZ7/TKmccRQC4XlDKN7Bzny4MFOKEhrTrDarmKZxP2ldhSrBCnByDXM
        L6OIyrBgNMc6HuuUKkSpdDF8ZeyUDDI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-U__A9W5aOkqhM3MAztwUVw-1; Mon, 04 Oct 2021 04:06:50 -0400
X-MC-Unique: U__A9W5aOkqhM3MAztwUVw-1
Received: by mail-ed1-f71.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso16302270edj.20
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jJXy9qbxdg2C9dmRq5ZlX/rnrXy4McozWIE5caJXRxA=;
        b=x7zhdBIIdxNdiunkFBtL2m0dCWnUx+Ny20T0vfIaQJtC3myTN6AigWX+mmIwY7qTVi
         +tT75fRbQqCJlhi4j0qPX/XBjjhskmKtfKW+ZQ7h3PHgxf5P3J0WK05nQ4VR7TrVZKUL
         LPgzVDpeuGRDyUZw30uqxPhUR2yhd1EovfNivJRI8gGt+BnczW4DL5dWRjHjk/UeLSH9
         5l950EUd317XIg1+zBrr3iFH56hwe4bt318S2cAjBi03wSKbSvulaS7VhyUdiCAA6HZR
         CyLa5oPFaaZ59Obcd2uPhicbfCc+IcHiRkAlRPPyJiyfPseeilM6KeaBw68H0FFDbDth
         13Pg==
X-Gm-Message-State: AOAM532Abc/ZA70h8io9sY7VGaLAByM8U5AQZ34LGDJkoVsotL+LmQpK
        OzbqfFrkmmo6inA/FrR6vQfEgAvxxMP2ksdIOrZVfznpRd1D7CQTA9UpdezmJt/Ya3b+k4NkpEQ
        FWf6BTS7mcxsI
X-Received: by 2002:a17:906:f243:: with SMTP id gy3mr16135276ejb.327.1633334809288;
        Mon, 04 Oct 2021 01:06:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIdzjTETW0eIAZHOkvEUoCw26rTuKoDHhEwXT7qa+YxQdbudEEtT1b0Ob2PmkGUciWfWArWQ==
X-Received: by 2002:a17:906:f243:: with SMTP id gy3mr16135251ejb.327.1633334809109;
        Mon, 04 Oct 2021 01:06:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z5sm6980558edm.82.2021.10.04.01.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:06:48 -0700 (PDT)
Message-ID: <6e9b4ea1-177e-00e6-d43a-0d316222be6e@redhat.com>
Date:   Mon, 4 Oct 2021 10:06:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 04/22] target/i386/kvm: Restrict SEV stubs to x86
 architecture
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
 <20211002125317.3418648-5-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-5-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:52, Philippe Mathieu-Daudé wrote:
> SEV is x86-specific, no need to add its stub to other
> architectures. Move the stub file to target/i386/kvm/.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   {accel => target/i386}/kvm/sev-stub.c | 0
>   accel/kvm/meson.build                 | 1 -
>   target/i386/kvm/meson.build           | 2 ++
>   3 files changed, 2 insertions(+), 1 deletion(-)
>   rename {accel => target/i386}/kvm/sev-stub.c (100%)
> 
> diff --git a/accel/kvm/sev-stub.c b/target/i386/kvm/sev-stub.c
> similarity index 100%
> rename from accel/kvm/sev-stub.c
> rename to target/i386/kvm/sev-stub.c
> diff --git a/accel/kvm/meson.build b/accel/kvm/meson.build
> index 8d219bea507..397a1fe1fd1 100644
> --- a/accel/kvm/meson.build
> +++ b/accel/kvm/meson.build
> @@ -3,6 +3,5 @@
>     'kvm-all.c',
>     'kvm-accel-ops.c',
>   ))
> -kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
>   
>   specific_ss.add_all(when: 'CONFIG_KVM', if_true: kvm_ss)
> diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
> index b1c76957c76..736df8b72e3 100644
> --- a/target/i386/kvm/meson.build
> +++ b/target/i386/kvm/meson.build
> @@ -7,6 +7,8 @@
>     'kvm-cpu.c',
>   ))
>   
> +i386_softmmu_kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
> +
>   i386_softmmu_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
>   
>   i386_softmmu_ss.add_all(when: 'CONFIG_KVM', if_true: i386_softmmu_kvm_ss)
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

