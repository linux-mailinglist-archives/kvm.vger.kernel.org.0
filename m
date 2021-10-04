Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C2F42074E
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhJDI3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:29:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230448AbhJDI3B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:29:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633336032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gwvDByIC+vTfc+SW+nW5Q49khZ7Ca0Ksli141LQG9yw=;
        b=S6uG+YEtip49+eDS46/TNecEiLzYz57MY+A3uF/TZgOazhZS6tkESHtlKH3wl3G+atD8W5
        0xQmXClv0+9qRk503kqLJcKENyEq9AsUO3QJ3uXTWdh5f0MpozNswTJZ2Q2nv03l6Ccdhr
        kpj74JsLKgi01M9sDi1RBDclLNepRpM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-2FjMe-sPN26rCtWDupADxA-1; Mon, 04 Oct 2021 04:27:09 -0400
X-MC-Unique: 2FjMe-sPN26rCtWDupADxA-1
Received: by mail-ed1-f71.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso16451138edx.2
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gwvDByIC+vTfc+SW+nW5Q49khZ7Ca0Ksli141LQG9yw=;
        b=UsjQs/FM8LqcL6j5sPntLc7PFxaGzoDdxIGsxe8XC/ZVfCRhGNlZNa4ifdjUVrociG
         clsuR1ZGJZGanhKU1rhW+jG0e4vs8QwP0+htLGfooV8BIcHArzcWeSCYTWNGfPwHbvXF
         ZR9NKYRdo0Ue4Oja2TyY/KoS/Ajm2Ps93NSSFj317b2lyWecQ+8pfEnb7GBxumI6svCN
         rudfNcINajLmIB6LUD/HFJNDCJCTBXJvKdPH3LAmkOrSeHKvMOOwL5Iq77eJ/E6TsNiP
         GI++xObUWApygDUcBSHz655WQsxIF6ajbepwVXSU6yO2u0duPV1KzUlaZYNcRy+zmzI8
         +j8g==
X-Gm-Message-State: AOAM5339AEPy3xgNCnfAu0JJaWAjcN01MeyI6Kgz02g+eQJNoEdPkH3N
        6vRuWB7RFhZ9ZCfa9hP8oszFfamJBs1l5fcGjZ4lMBcIr2eV06sdtEJ11l/LZf57TrXrmz77nuq
        +yH66OCh+0PdA
X-Received: by 2002:a50:e006:: with SMTP id e6mr16213679edl.302.1633336028345;
        Mon, 04 Oct 2021 01:27:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwU7u03IjhG3DKilfNvbDjof5cqTK+DLAJqU3WAhInDEBELKB/AKQqVhKx1wx6OBCOzLpAj7w==
X-Received: by 2002:a50:e006:: with SMTP id e6mr16213665edl.302.1633336028131;
        Mon, 04 Oct 2021 01:27:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lb12sm6307833ejc.28.2021.10.04.01.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:27:07 -0700 (PDT)
Message-ID: <a603ce87-e315-06e0-ff53-2c961c046b82@redhat.com>
Date:   Mon, 4 Oct 2021 10:27:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 22/22] MAINTAINERS: Cover AMD SEV files
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
 <20211002125317.3418648-23-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-23-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> Add an entry to list SEV-related files.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   MAINTAINERS | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 50435b8d2f5..733a5201e76 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3038,6 +3038,13 @@ F: hw/core/clock-vmstate.c
>   F: hw/core/qdev-clock.c
>   F: docs/devel/clocks.rst
>   
> +AMD Secure Encrypted Virtualization (SEV)
> +S: Orphan
> +F: docs/amd-memory-encryption.txt
> +F: target/i386/sev*
> +F: target/i386/kvm/sev-stub.c
> +F: include/sysemu/sev.h

I don't think it qualifies as orphan; it's covered by x86 maintainers.

Paolo

