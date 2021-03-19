Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDBA341717
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 09:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhCSIHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 04:07:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234215AbhCSIHR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 04:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616141237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Skqo6f9yW8lK62SqKGHOk+G8drCEfkExBud4qudsccw=;
        b=Py3IaICHV1IBCvgJr1SRNqCNhSYy+/mgWsR3pIAT4BjkRTlpadJ2THVoW9fvM9LvS5AzKX
        rgB8SYzSfG6wsf+P1cmcILpeWkMhAvA1RvSR+yCSzIUS6WTpEnfpSeC/WoSLqnmB/hza9g
        R9tVQVega2nkIdZhIs5MgJAvEjYBJZ0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-0AN5CaTVMkSFm2KG93T6jA-1; Fri, 19 Mar 2021 04:07:15 -0400
X-MC-Unique: 0AN5CaTVMkSFm2KG93T6jA-1
Received: by mail-ej1-f72.google.com with SMTP id rl7so17826828ejb.16
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 01:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Skqo6f9yW8lK62SqKGHOk+G8drCEfkExBud4qudsccw=;
        b=GtCbaegRlCIPhQMhBhMhh83wuRTAKSDqlZCNddnPuiJVmfEvYeSJ740TzWsH+cxTtc
         LctMnFvbBnvnTDL15VaHsryKOT7diIs9L3E7FFgzkuytJjd19rGeSMvEHCvUrxduM/VJ
         uCV960/J/DZ5lHYLFviPrQEKDB3A6TpreSUQ+dZ5vhVmg2fegIskRoElvvScT1r2bJn2
         GKew2PEWGXlOLeDe8kYs/w0a1ImsQzXwjqX2Jr/ItJcB1bsa77pkhMSDO7e9bcyf7P2A
         yQZBtV8JohCl0BnZS1E0xsrXhRSLOGFzSw+TbIAP5JlSWD6KoqwQoDFMvCE7yWOdWlUP
         zl0w==
X-Gm-Message-State: AOAM532DoAtLddrOAGcG72mtrDRhh+viBolwO9YIJK61MIYewQ5moKZ3
        CXc11S7ak4ZJSlrQOVKgr0QRROTo0hMufPddzH4+hukZwSmaf1skU9NfOqoEvJFDS7oUoqFlX9M
        EEX7+gisgMvho
X-Received: by 2002:a17:906:4955:: with SMTP id f21mr3064170ejt.74.1616141234395;
        Fri, 19 Mar 2021 01:07:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkhvLmdglHhe4zfW02VmKkQ4vHdspPb/cEApNgMloEmZsu3PphEPl8SexenPqbp0wXWjtuqQ==
X-Received: by 2002:a17:906:4955:: with SMTP id f21mr3064155ejt.74.1616141234243;
        Fri, 19 Mar 2021 01:07:14 -0700 (PDT)
Received: from localhost.localdomain ([194.230.155.135])
        by smtp.gmail.com with ESMTPSA id r17sm3311246ejz.109.2021.03.19.01.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 01:07:13 -0700 (PDT)
Subject: Re: [PATCH] selftests/kvm: add get_msr_index_features
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210318145629.486450-1-eesposit@redhat.com>
 <20210318170316.6vah7x2ws4bimmdf@kamzik.brq.redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <52d09cdf-3819-0cd8-5812-387febaa1ab3@redhat.com>
Date:   Fri, 19 Mar 2021 09:07:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210318170316.6vah7x2ws4bimmdf@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

Thank you for the feedback (also in v1).

On 18/03/2021 18:03, Andrew Jones wrote:
> On Thu, Mar 18, 2021 at 03:56:29PM +0100, Emanuele Giuseppe Esposito wrote:
>> Test the KVM_GET_MSR_FEATURE_INDEX_LIST
>> and KVM_GET_MSR_INDEX_LIST ioctls.
>>
>> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
>> ---
>>   tools/testing/selftests/kvm/.gitignore        |   1 +
>>   tools/testing/selftests/kvm/Makefile          |   1 +
>>   .../kvm/x86_64/get_msr_index_features.c       | 124 ++++++++++++++++++
>>   3 files changed, 126 insertions(+)
>>   create mode 100644 tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
>>
>> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
>> index 32b87cc77c8e..d99f3969d371 100644
>> --- a/tools/testing/selftests/kvm/.gitignore
>> +++ b/tools/testing/selftests/kvm/.gitignore
>> @@ -5,6 +5,7 @@
>>   /s390x/resets
>>   /s390x/sync_regs_test
>>   /x86_64/cr4_cpuid_sync_test
>> +/x86_64/get_msr_index_features
>>   /x86_64/debug_regs
>>   /x86_64/evmcs_test
>>   /x86_64/get_cpuid_test
>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>> index a6d61f451f88..c748b9650e28 100644
>> --- a/tools/testing/selftests/kvm/Makefile
>> +++ b/tools/testing/selftests/kvm/Makefile
>> @@ -39,6 +39,7 @@ LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
>>   LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
>>   
>>   TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
>> +TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
> 
> Maybe we should give up trying to keep an alphabetic order.

My bad, I did not notice that it was in alphabetic order.

> 
>>   TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
>>   TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
>>   TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>> diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
>> new file mode 100644
>> index 000000000000..ad9972d99dfa
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
>> @@ -0,0 +1,124 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Test that KVM_GET_MSR_INDEX_LIST and
>> + * KVM_GET_MSR_FEATURE_INDEX_LIST work as intended
>> + *
>> + * Copyright (C) 2020, Red Hat, Inc.
>> + */
>> +#include <fcntl.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <sys/ioctl.h>
>> +
>> +#include "test_util.h"
>> +#include "kvm_util.h"
>> +#include "processor.h"
>> +#include "../lib/kvm_util_internal.h"
> 
> I'm not sure why the original kvm selftests authors decided to do this
> internal stuff, but we should either kill that or avoid doing stuff like
> this.

I need this include because of the KVM_DEV_PATH macro, to get the kvm_fd.
No other reason for including it in this test.
>> +
>> +static int kvm_num_feature_msrs(int kvm_fd, int nmsrs)
>> +{
>> +	struct kvm_msr_list *list;
>> +	int r;
>> +
>> +	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
>> +	list->nmsrs = nmsrs;
>> +	r = ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, list);
>> +	TEST_ASSERT(r == -1 && errno == E2BIG,
>> +		"Unexpected result from KVM_GET_MSR_FEATURE_INDEX_LIST probe, r: %i",
>> +				r);
> 
> Weird indentation. I'd just leave it up on the last line. We don't care
> about long lines.

Ok. I wanted avoid warnings from the checkpatch script.

Paolo, do you want me to send v2 with fixed indentation or you already 
took care of it? I'll be happy to do so.

Emanuele

