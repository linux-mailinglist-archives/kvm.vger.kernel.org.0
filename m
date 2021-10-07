Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C63842567B
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 17:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbhJGPUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 11:20:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232940AbhJGPUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 11:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633619887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A6vtXIkicFt7VVQ5NHVntrnPXhTSxCgEIYm8aJeHGxA=;
        b=bUeQnNJik1s3/d8p6LQEot5eTbcdeC7big9mwPxGHlMBRqxIJ9tM/c2dL//K+ToTtcra/x
        egRUSAf8mLgEg6zsOUJiR8Jn+Tp06YdPngf4+Zr5Mai/TQsgqOTlMfB/SxZ7EH6UJgMxGO
        d0tDWXQwvYRNFz3QR3IuD6utx7Fsaw0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-fLyH7mr5NGGxq6aEkdJKKQ-1; Thu, 07 Oct 2021 11:18:06 -0400
X-MC-Unique: fLyH7mr5NGGxq6aEkdJKKQ-1
Received: by mail-wr1-f70.google.com with SMTP id p12-20020adfc38c000000b00160d6a7e293so2493286wrf.18
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 08:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A6vtXIkicFt7VVQ5NHVntrnPXhTSxCgEIYm8aJeHGxA=;
        b=TFEZ2elMDbhmqTj22BJ1zJ3/0sHVWfqHtPnrl/BoNB8j+052lwpwl61SRIzDWzEuE7
         M6h0AUpRBEiBK48VLTq86rrWvSQ5Go4jnS4s3VJaxdKN9KPUzBIujLmWADKRgprTlYcX
         p5vduMlergpPRe6UnDl2Vsq7oJ6wtCS4mNbXZskpRUQ8n2UQlO9HQ8E37KhnfSOZVxKH
         IKvR7/KwoQXar/Wo5VTkuLNlg5whUzZstqyqap4QTlPwkFNiC+O326R18pmMo3PN82Z8
         iT3CxQhtJ9143FnPMv4m3tEYEb4xP6Kz9bHE8m3wXng/glJd6NGm0VCbGJPiM+1V7Vxs
         Ngug==
X-Gm-Message-State: AOAM530eEqtYW+3aqNkXb3hntJU4CYeg0/R6gItnSln6q/LqFiJXqKC6
        eU9Qp57zc2KQJ0ZAv6Jz2ubOh7rrv4Z5TAlGDwLGKiroiPog4pGyXXj1bVde54ZJ88W2FHor+bG
        NP42vssOam8h0
X-Received: by 2002:a5d:59ad:: with SMTP id p13mr6208234wrr.253.1633619885122;
        Thu, 07 Oct 2021 08:18:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1chPAauVcmvAUGIu2PpmeGC1NzHHEZTsM8AxFTeGNU0jLdg6eBriMmhAOBKsfKtxtw9g1Zw==
X-Received: by 2002:a5d:59ad:: with SMTP id p13mr6208209wrr.253.1633619884958;
        Thu, 07 Oct 2021 08:18:04 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id n15sm25386369wrg.58.2021.10.07.08.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 08:18:04 -0700 (PDT)
Message-ID: <9f36432b-b1b7-139e-085d-c8af430772fc@redhat.com>
Date:   Thu, 7 Oct 2021 17:18:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 19/22] monitor: Restrict 'info sev' to x86 targets
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-20-philmd@redhat.com>
 <5c1652ac-8a71-8d23-ed31-b84ce07596e8@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <5c1652ac-8a71-8d23-ed31-b84ce07596e8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/21 10:26, Paolo Bonzini wrote:
> On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   include/monitor/hmp-target.h  | 1 +
>>   include/monitor/hmp.h         | 1 -
>>   target/i386/sev-sysemu-stub.c | 2 +-
>>   target/i386/sev.c             | 2 +-
>>   4 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/monitor/hmp-target.h b/include/monitor/hmp-target.h
>> index dc53add7eef..96956d0fc41 100644
>> --- a/include/monitor/hmp-target.h
>> +++ b/include/monitor/hmp-target.h
>> @@ -49,6 +49,7 @@ void hmp_info_tlb(Monitor *mon, const QDict *qdict);
>>   void hmp_mce(Monitor *mon, const QDict *qdict);
>>   void hmp_info_local_apic(Monitor *mon, const QDict *qdict);
>>   void hmp_info_io_apic(Monitor *mon, const QDict *qdict);
>> +void hmp_info_sev(Monitor *mon, const QDict *qdict);
>>   void hmp_info_sgx(Monitor *mon, const QDict *qdict);
>>     #endif /* MONITOR_HMP_TARGET_H */
>> diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
>> index 3baa1058e2c..6bc27639e01 100644
>> --- a/include/monitor/hmp.h
>> +++ b/include/monitor/hmp.h
>> @@ -124,7 +124,6 @@ void hmp_info_ramblock(Monitor *mon, const QDict
>> *qdict);
>>   void hmp_hotpluggable_cpus(Monitor *mon, const QDict *qdict);
>>   void hmp_info_vm_generation_id(Monitor *mon, const QDict *qdict);
>>   void hmp_info_memory_size_summary(Monitor *mon, const QDict *qdict);
>> -void hmp_info_sev(Monitor *mon, const QDict *qdict);
>>   void hmp_info_replay(Monitor *mon, const QDict *qdict);
>>   void hmp_replay_break(Monitor *mon, const QDict *qdict);
>>   void hmp_replay_delete_break(Monitor *mon, const QDict *qdict);
>> diff --git a/target/i386/sev-sysemu-stub.c
>> b/target/i386/sev-sysemu-stub.c
>> index 1836b32e4fc..b2a4033a030 100644
>> --- a/target/i386/sev-sysemu-stub.c
>> +++ b/target/i386/sev-sysemu-stub.c
>> @@ -13,7 +13,7 @@
>>     #include "qemu/osdep.h"
>>   #include "monitor/monitor.h"
>> -#include "monitor/hmp.h"
>> +#include "monitor/hmp-target.h"
>>   #include "qapi/qapi-commands-misc-target.h"
>>   #include "qapi/qmp/qerror.h"
>>   #include "qapi/error.h"
>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>> index 7caaa117ff7..c6d8fc52eb2 100644
>> --- a/target/i386/sev.c
>> +++ b/target/i386/sev.c
>> @@ -32,7 +32,7 @@
>>   #include "migration/blocker.h"
>>   #include "qom/object.h"
>>   #include "monitor/monitor.h"
>> -#include "monitor/hmp.h"
>> +#include "monitor/hmp-target.h"
>>   #include "qapi/qapi-commands-misc-target.h"
>>   #include "qapi/qmp/qerror.h"
>>   #include "exec/confidential-guest-support.h"
>>
> 
> 
> This is only a cleanup, isn't it?  The #ifdef is already in
> hmp-commands-info.hx.

IIUC the prototype is exposed to all targets, while with
this patch, only to the files including "monitor/hmp-target.h".

You are right the command is only added for TARGET_I386 in
hmp-commands-info.hx.

> 
> Anyway,
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> but please adjust the commit message in v4.

OK, thanks.

