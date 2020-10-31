Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33522A182F
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgJaOcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:32:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727867AbgJaOcx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:32:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604154771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQ3vouoN5pBDEW1j92+HYzR5V8rv0UDLlic9MsCvMqY=;
        b=f2RzpEeAoyN71/F7ZD0lcUVZeZrpbSi+n97QUPKN+eLFgWRzErb0VxzQOROZEr7G3Wn3/j
        g0ZTUr4ONUrfNz3S4Oc6AkEbyhAU3K+9CRetlEQ/tpWCUsFAxAv4aAxxKGByKL8idQGSzI
        9MoFCZDDMish9yGV6towDPeLOgvojGA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-RU8n5-F3PXy6is4u0ayJLw-1; Sat, 31 Oct 2020 10:32:49 -0400
X-MC-Unique: RU8n5-F3PXy6is4u0ayJLw-1
Received: by mail-wr1-f70.google.com with SMTP id 33so4032117wrf.22
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 07:32:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fQ3vouoN5pBDEW1j92+HYzR5V8rv0UDLlic9MsCvMqY=;
        b=e4nlCNvwifdjAgTiTHALULhfDxQXC8fonjQONp0iCJm4mkvMzKQAyZ/5wC0HNZ2Ee1
         Iy3CLDncAZ3d5aqzUmUeSfOxKu3YOTHggsKyGgTCp/yS1yjHyH6MxaV+aF+3dUsUGMd0
         wAcywx7t9RA1T47kHv8vmL3xMJME7AykNoToDW/4gfFQ+J6ZrGaM9NvsAMaxgEaDTFly
         PnuvnY3uOf/TtdLZBVsy6/091U7CHOJpdGqO8La7mU3U0ZQQfDBMDByNe5ZuoIkyN3iV
         rwTrBIYVmsL1U4FW1nBMBU80KqEjth87kATCCp7hPqsGLTzjnfYVqfHKXlpuLdkJBTj8
         U7iw==
X-Gm-Message-State: AOAM532cWodwdieXle0u1Vk4QqdPBlcJZLynO7tA6QhFIQXmSV5GgxYE
        qtz7ypvaKjg3E3VHsal36AnOOakLyClyN/I8upNyIwfVsg7Xu8SzlZF7JE9CD15EBSffsQiOgNn
        6QKmdV59uIypv
X-Received: by 2002:a7b:c956:: with SMTP id i22mr2230562wml.12.1604154768072;
        Sat, 31 Oct 2020 07:32:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3LjkpZyrPANWgXsIPVFL51S9Z9A9ia3lwgbzPJTyr+FvTp65WTYwTZd5HA/y6/Hn3zV7KLA==
X-Received: by 2002:a7b:c956:: with SMTP id i22mr2230550wml.12.1604154767890;
        Sat, 31 Oct 2020 07:32:47 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id k185sm8691883wmf.16.2020.10.31.07.32.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:32:47 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 3/3] arm/arm64: Change dcache_line_size to
 ulong
To:     Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>,
        kvm@vger.kernel.org
References: <20201014191444.136782-1-drjones@redhat.com>
 <20201014191444.136782-4-drjones@redhat.com>
 <f4d0035a-717b-042c-1469-0fdd3843cce7@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <939c571b-d717-878f-9193-5e6361192dac@redhat.com>
Date:   Sat, 31 Oct 2020 15:32:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <f4d0035a-717b-042c-1469-0fdd3843cce7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/20 10:30, Thomas Huth wrote:
> On 14/10/2020 21.14, Andrew Jones wrote:
>> dcache_line_size is treated like a long in assembly, so make it one.
>>
>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>> ---
>>  lib/arm/asm/processor.h   | 2 +-
>>  lib/arm/setup.c           | 2 +-
>>  lib/arm64/asm/processor.h | 2 +-
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
>> index e26ef89000a8..273366d1fe1c 100644
>> --- a/lib/arm/asm/processor.h
>> +++ b/lib/arm/asm/processor.h
>> @@ -89,6 +89,6 @@ static inline u32 get_ctr(void)
>>  	return read_sysreg(CTR);
>>  }
>>  
>> -extern u32 dcache_line_size;
>> +extern unsigned long dcache_line_size;
>>  
>>  #endif /* _ASMARM_PROCESSOR_H_ */
>> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
>> index 78562e47c01c..ea714d064afa 100644
>> --- a/lib/arm/setup.c
>> +++ b/lib/arm/setup.c
>> @@ -42,7 +42,7 @@ static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
>>  struct mem_region *mem_regions = __initial_mem_regions;
>>  phys_addr_t __phys_offset, __phys_end;
>>  
>> -u32 dcache_line_size;
>> +unsigned long dcache_line_size;
>>  
>>  int mpidr_to_cpu(uint64_t mpidr)
>>  {
>> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
>> index 02665b84cc7e..6ee7c1260b6b 100644
>> --- a/lib/arm64/asm/processor.h
>> +++ b/lib/arm64/asm/processor.h
>> @@ -115,7 +115,7 @@ static inline u64 get_ctr(void)
>>  	return read_sysreg(ctr_el0);
>>  }
>>  
>> -extern u32 dcache_line_size;
>> +extern unsigned long dcache_line_size;
>>  
>>  #endif /* !__ASSEMBLY__ */
>>  #endif /* _ASMARM64_PROCESSOR_H_ */
>>
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Queued all three, thanks.

Paolo

