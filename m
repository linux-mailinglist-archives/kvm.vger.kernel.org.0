Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A72F420701
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhJDIIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:08:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230496AbhJDIIH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:08:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633334778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NaecXq8hUt75hzJc1rXTl5u5ap4zeFZ5kxrq2jxmrrw=;
        b=FJ0kgKS8Q1XhAoBeIL4tUl7EcT8ztwR/RYXP+z340NhOTuR+xJSIPNKZ0HeOxw5R1F/7rw
        P+PVUdmjceKd5IdnyXyzqEVDR/VydI7yToHqvDjXra9R4QzyKfa5Ecr1JXhiVbxa41dAcS
        tpKIwiI7FLjc33dvYgXXKsWaSWpseIs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-g1DxilJPPiawbe15UOGr8g-1; Mon, 04 Oct 2021 04:06:15 -0400
X-MC-Unique: g1DxilJPPiawbe15UOGr8g-1
Received: by mail-ed1-f69.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso16300687edj.20
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:06:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NaecXq8hUt75hzJc1rXTl5u5ap4zeFZ5kxrq2jxmrrw=;
        b=WV+YYpNlywhAHG15112e8vomGnxl6LdwfIAax12yec1wC8ap+X1ec/o41m5RFWN7KF
         mBd6wOHhYHh4Cp8zOf91DlYZkOr5+FTQYdvWw2P5fvjxWseNXNxmlauikyL5GssoSzO2
         XNJTvs/Zh08AGo/XEO3SajJS2Y/n5+tx+vpz15X1toNI97ZbtUeOYZgtu1uXz3FQdi93
         4GWSg3ZsNknnNBnGjQ+hVFsWP6qQfny0WTDBfgU2ERZjhiiGxPC3RaFnegnQtkdi1Y/V
         jVPG/vILA95JD+ZcekN0tSCeLzyIC4WQqBE75R6UrVEkBJwNlLBfBDPkEljtS7zmyU0K
         jBrQ==
X-Gm-Message-State: AOAM532h2qfi0YJiJEoAemCl+ShqDZzMM7SRaXjoOc1IwvV6nqxpxJoL
        tPZEMX1V3jc2wH+E2ouxFBitxFdIZ+0u6s0nisIq7Vo28K5vMPrSsFVjVGaP5QWY9MHkELUzPgT
        KqJUDOP2jopWz
X-Received: by 2002:aa7:d802:: with SMTP id v2mr13077963edq.271.1633334774257;
        Mon, 04 Oct 2021 01:06:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRap4GsemYDe+jkC9FNA31zg4spvFSlq5R7Ec4FD2PjRhZOOGlg+Xoy68MiO2XlqhngDUFZA==
X-Received: by 2002:aa7:d802:: with SMTP id v2mr13077946edq.271.1633334774074;
        Mon, 04 Oct 2021 01:06:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j3sm1933542ejy.65.2021.10.04.01.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:06:13 -0700 (PDT)
Message-ID: <66641be2-04c7-7c48-1ba9-46efff6f84da@redhat.com>
Date:   Mon, 4 Oct 2021 10:06:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 03/22] target/i386/kvm: Introduce i386_softmmu_kvm
 Meson source set
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
 <20211002125317.3418648-4-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-4-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:52, Philippe Mathieu-Daudé wrote:
> Introduce the i386_softmmu_kvm Meson source set to be able to
> add features dependent on CONFIG_KVM.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/kvm/meson.build | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
> index 0a533411cab..b1c76957c76 100644
> --- a/target/i386/kvm/meson.build
> +++ b/target/i386/kvm/meson.build
> @@ -1,8 +1,12 @@
>   i386_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
>   
> -i386_softmmu_ss.add(when: 'CONFIG_KVM', if_true: files(
> +i386_softmmu_kvm_ss = ss.source_set()
> +
> +i386_softmmu_kvm_ss.add(files(
>     'kvm.c',
>     'kvm-cpu.c',
>   ))
>   
>   i386_softmmu_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
> +
> +i386_softmmu_ss.add_all(when: 'CONFIG_KVM', if_true: i386_softmmu_kvm_ss)
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

