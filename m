Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21914251FD
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 13:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbhJGLbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 07:31:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhJGLbk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 07:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633606186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=drYJ3joVpGlpbZnnoT10cnxDs5NiORQp9FnHE19ej48=;
        b=H5kXp3MOh2QhWlRPyIGV4tzWYzYAIJkPWPUHioEC6e4SVvG+SHsrRDw80DI/LHCx1S2Bf5
        OKgOq01juNo+j9tMrmIjFXlylYih5iOJldKg9Ya+PiZhnafMTRjTfnC5RDJm2bMLyT5KbA
        xn/7u7g1oLuVz78bfYz/omrg+y4xUQ4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-HO7iCreaOzuWWtxuHfyNRA-1; Thu, 07 Oct 2021 07:29:45 -0400
X-MC-Unique: HO7iCreaOzuWWtxuHfyNRA-1
Received: by mail-wr1-f69.google.com with SMTP id p12-20020adfc38c000000b00160d6a7e293so1945786wrf.18
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 04:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=drYJ3joVpGlpbZnnoT10cnxDs5NiORQp9FnHE19ej48=;
        b=uU9Zdg6uP5eN8pp96cdhKMyFUN1nmjWEVgkxgN9JWe+hHFm4P7OukiyCxSyyUQ2KGy
         7J9smi/t/TnBex8Lr5yl3FW4UGfGXNfpVBJyJ3eZROBIwyT1dDoXCl/BU8inRQ6dzauk
         a0JGwbX4lumuXHbkdg80qwSkEM+2KbZt8Eu3Up5mnRdNq5TF8ilVaixHG2C2AzZNk6Nt
         wgSGXaMdn3YgPZ7uoyTpaqEeRfX+M7odIgV+lpDjq7ardzh4JPPiARPqjTNn6sgyiHTg
         C1KUeTM+sw9bSdcfwGmJiTvfaeBljdiULwhC6PMss6h7iDEnLkXX4nu0Oyx9VboPBMF0
         MdXA==
X-Gm-Message-State: AOAM533gYb6fsmMjGoku+RVTHjrjmMdpHCmHIv3siWvX5usCpw5rcrR0
        9jKFQQF70BWJ5wR4qkKrPBcEGhxp9mpehXvZImvwRQc8PFeLZ6lB1pN4tVLzgaTWaOLZA5XcMae
        6igHWNSQ5ivpO
X-Received: by 2002:a05:600c:2dc1:: with SMTP id e1mr3909739wmh.135.1633606184130;
        Thu, 07 Oct 2021 04:29:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCGtQPVUTWH8//ChO0azrAsnUoGsBUNkudWwL4mB93Z03icqsjehxKzcd4fqupF2TMlDsgAQ==
X-Received: by 2002:a05:600c:2dc1:: with SMTP id e1mr3909724wmh.135.1633606183940;
        Thu, 07 Oct 2021 04:29:43 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id z16sm8450077wmk.6.2021.10.07.04.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 04:29:43 -0700 (PDT)
Message-ID: <8f12bc3e-53aa-c946-bb06-f7d08721b243@redhat.com>
Date:   Thu, 7 Oct 2021 13:29:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 05/22] target/i386/monitor: Return QMP error when SEV
 is disabled in build
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, Sergio Lopez <slp@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Connor Kuehl <ckuehl@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-6-philmd@redhat.com>
 <bef20bd5-7760-3fc7-9914-1eddca800825@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <bef20bd5-7760-3fc7-9914-1eddca800825@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/21 10:11, Paolo Bonzini wrote:
> On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
>> If the management layer tries to inject a secret, it gets an empty
>> response in case the binary built without SEV:
>>
>>    { "execute": "sev-inject-launch-secret",
>>      "arguments": { "packet-header": "mypkt", "secret": "mypass",
>> "gpa": 4294959104 }
>>    }
>>    {
>>        "return": {
>>        }
>>    }
>>
>> Make it clearer by returning an error, mentioning the feature is
>> disabled:
>>
>>    { "execute": "sev-inject-launch-secret",
>>      "arguments": { "packet-header": "mypkt", "secret": "mypass",
>> "gpa": 4294959104 }
>>    }
>>    {
>>        "error": {
>>            "class": "GenericError",
>>            "desc": "this feature or command is not currently supported"
>>        }
>>    }
>>
>> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   target/i386/monitor.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
>> index 196c1c9e77f..a9f85acd473 100644
>> --- a/target/i386/monitor.c
>> +++ b/target/i386/monitor.c
>> @@ -28,6 +28,7 @@
>>   #include "monitor/hmp-target.h"
>>   #include "monitor/hmp.h"
>>   #include "qapi/qmp/qdict.h"
>> +#include "qapi/qmp/qerror.h"
>>   #include "sysemu/kvm.h"
>>   #include "sysemu/sev.h"
>>   #include "qapi/error.h"
>> @@ -743,6 +744,10 @@ void qmp_sev_inject_launch_secret(const char
>> *packet_hdr,
>>                                     bool has_gpa, uint64_t gpa,
>>                                     Error **errp)
>>   {
>> +    if (!sev_enabled()) {
>> +        error_setg(errp, QERR_UNSUPPORTED);
>> +        return;
>> +    }
>>       if (!has_gpa) {
>>           uint8_t *data;
>>           struct sev_secret_area *area;
>>
> 
> This should be done in the sev_inject_launch_secret stub instead, I
> think.  Or if you do it here, you can remove the "if (!sev_guest)"
> conditional in the non-stub version.

This part is not related to SEV builtin; what we want to avoid here
is management layer to try to inject secret while the guest hasn't
been started with SEV (IOW 'no memory encryption requested for KVM).

Maybe this error message is more explicit?

  error_setg(errp, "Guest is not using memory encryption");

Or:

  error_setg(errp, "Guest is not using SEV");

