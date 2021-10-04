Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E311420749
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhJDI23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:28:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230469AbhJDI21 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:28:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btG2jGUoWy2nT5ZM3BSZ7Cn5M3SntGDJo8lfgebe/EI=;
        b=VRorUH5Ts4YdQjxL6tKTC3LJw3mYMsSmI1Xf6tgviq2+0xyMvDsfgGscMdqeAjD80ZTgUV
        rXxZunrDy0DmmP/ZGP0Yf1mVtBHknh3/dgc1VsjoyB/Fb92g5X+hkLgMXmctIHsrNaA4M8
        21o+o8pTU/Ms6NCp6Q2aKJJGMwrRiDQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-t1k8oFvFPma-Y7xwDQW_NA-1; Mon, 04 Oct 2021 04:26:37 -0400
X-MC-Unique: t1k8oFvFPma-Y7xwDQW_NA-1
Received: by mail-ed1-f72.google.com with SMTP id ec14-20020a0564020d4e00b003cf5630c190so16512065edb.3
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=btG2jGUoWy2nT5ZM3BSZ7Cn5M3SntGDJo8lfgebe/EI=;
        b=KBgVCtcWJH8KAPZqnJkWAVo0jLhrCsnf4RPPig2LqhcZV5c1ePMXa6HQY6KETi1VAE
         hopK7YMFUn9/knBNZDANbrpn9qKewa7uze++uRW/5gDSydKnUAgQrtVX3I4+QLEyBeMz
         vLoojdmw4+kvg37Sn7RtKY4xyPaZKi2szf6MFljFindSDJ4lc4SYaluLTzPzOjf/+rkQ
         w1BCC1rJQnf7vkyZGvF+yx3gJEXiA/ytH3hCw+X6R+Oi5cKdJ8Zq4hFF09fawJEs2V+T
         LqBtqj/V9/FSpny1LUao+1DN5f9yRBMR/iw2yMgx6xOD2D0PxSmoMlxeEpsysvU9UBOU
         3ZsQ==
X-Gm-Message-State: AOAM532olFvyv27OADEwVwUdiLPKCsyjO0+yaeGghI40lpCNIbAMK4li
        HHXDuUyXfGcLqmmsad/7KzMMjP3ks526uHD48ZCPsoddyw9VedKcGjBMTJ4pbXjrqA0M//xNf19
        mik4rP2epxN4Z
X-Received: by 2002:a17:906:2441:: with SMTP id a1mr15633972ejb.414.1633335996398;
        Mon, 04 Oct 2021 01:26:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRoeSW+V0+V2SCoZEw8TibTIzZQeXEges4N9UaSGdTRKC9mpRFxypKJ3npveIPfv+B2z22Zg==
X-Received: by 2002:a17:906:2441:: with SMTP id a1mr15633943ejb.414.1633335996161;
        Mon, 04 Oct 2021 01:26:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x16sm1639516ejj.8.2021.10.04.01.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:26:35 -0700 (PDT)
Message-ID: <5c1652ac-8a71-8d23-ed31-b84ce07596e8@redhat.com>
Date:   Mon, 4 Oct 2021 10:26:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 19/22] monitor: Restrict 'info sev' to x86 targets
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
 <20211002125317.3418648-20-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-20-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   include/monitor/hmp-target.h  | 1 +
>   include/monitor/hmp.h         | 1 -
>   target/i386/sev-sysemu-stub.c | 2 +-
>   target/i386/sev.c             | 2 +-
>   4 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/monitor/hmp-target.h b/include/monitor/hmp-target.h
> index dc53add7eef..96956d0fc41 100644
> --- a/include/monitor/hmp-target.h
> +++ b/include/monitor/hmp-target.h
> @@ -49,6 +49,7 @@ void hmp_info_tlb(Monitor *mon, const QDict *qdict);
>   void hmp_mce(Monitor *mon, const QDict *qdict);
>   void hmp_info_local_apic(Monitor *mon, const QDict *qdict);
>   void hmp_info_io_apic(Monitor *mon, const QDict *qdict);
> +void hmp_info_sev(Monitor *mon, const QDict *qdict);
>   void hmp_info_sgx(Monitor *mon, const QDict *qdict);
>   
>   #endif /* MONITOR_HMP_TARGET_H */
> diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
> index 3baa1058e2c..6bc27639e01 100644
> --- a/include/monitor/hmp.h
> +++ b/include/monitor/hmp.h
> @@ -124,7 +124,6 @@ void hmp_info_ramblock(Monitor *mon, const QDict *qdict);
>   void hmp_hotpluggable_cpus(Monitor *mon, const QDict *qdict);
>   void hmp_info_vm_generation_id(Monitor *mon, const QDict *qdict);
>   void hmp_info_memory_size_summary(Monitor *mon, const QDict *qdict);
> -void hmp_info_sev(Monitor *mon, const QDict *qdict);
>   void hmp_info_replay(Monitor *mon, const QDict *qdict);
>   void hmp_replay_break(Monitor *mon, const QDict *qdict);
>   void hmp_replay_delete_break(Monitor *mon, const QDict *qdict);
> diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
> index 1836b32e4fc..b2a4033a030 100644
> --- a/target/i386/sev-sysemu-stub.c
> +++ b/target/i386/sev-sysemu-stub.c
> @@ -13,7 +13,7 @@
>   
>   #include "qemu/osdep.h"
>   #include "monitor/monitor.h"
> -#include "monitor/hmp.h"
> +#include "monitor/hmp-target.h"
>   #include "qapi/qapi-commands-misc-target.h"
>   #include "qapi/qmp/qerror.h"
>   #include "qapi/error.h"
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 7caaa117ff7..c6d8fc52eb2 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -32,7 +32,7 @@
>   #include "migration/blocker.h"
>   #include "qom/object.h"
>   #include "monitor/monitor.h"
> -#include "monitor/hmp.h"
> +#include "monitor/hmp-target.h"
>   #include "qapi/qapi-commands-misc-target.h"
>   #include "qapi/qmp/qerror.h"
>   #include "exec/confidential-guest-support.h"
> 


This is only a cleanup, isn't it?  The #ifdef is already in 
hmp-commands-info.hx.

Anyway,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

but please adjust the commit message in v4.

Paolo

