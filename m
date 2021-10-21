Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D154363B9
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhJUOGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:06:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhJUOGk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 10:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634825063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vo/FAd6Z/y6QeO89/UBrFTooX/R+KvkBPVcJa1A6uGQ=;
        b=HfKhbhoNmkO4wu1V/nK1FT4zjOjG28eui39FoT98wcGEMdMiMZ46jhS5/S2n52wBzQTYog
        Jj1EfsTvh9DRYeeziEyksL94Z3b4+eEdOAtSQSEUTH3sQtIEeK47HuPtAqoPf/h8BkumLK
        YyXUiL0dmgLKZyTC/mdDpgkuwmLTpt0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-D035lTmIMA2Aq7xas1QfeA-1; Thu, 21 Oct 2021 10:04:22 -0400
X-MC-Unique: D035lTmIMA2Aq7xas1QfeA-1
Received: by mail-ed1-f69.google.com with SMTP id h19-20020aa7de13000000b003db6ad5245bso450576edv.9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Vo/FAd6Z/y6QeO89/UBrFTooX/R+KvkBPVcJa1A6uGQ=;
        b=zGLsOc8R7ZCIAKFaUcFu7K5njP1XBuz0lNztNI35yyk8lFg4xOOdDCQQvDR2QE9DAT
         HXniAogJSLkcodVgGVFtIHVDuCc/kKw9RLcL7DSKrmTUT2jlqEHLbKnUE38YGP7CFLe5
         /SXr92gxbBK1BdXsptSjiBIJ0fEp5OMtTPcg2TTq8glWDOvFt0DtRRkaBP6puK1RsJhj
         WHuh9q9rCg+IPdfnw37RLnVO5E9L8DzVJsomif/qQ/pFGe4TBzjeVmXh2hs9gyX/88AB
         LxJsCLddTbV1v9FUAdcYGbraIhuHugf9cEcXeDqd/t4HUJ9x9GWZmSHho+82BbWDDmT7
         PTiQ==
X-Gm-Message-State: AOAM5338OpgMnAS5aIj8CfkG5lrbaVk58CQTQSw6MBLY22VC2s7AOgfp
        xhqafrdZ6pYdpR6SIV5AFHOzpB5QSfwKH6UhQGmvw9MJrB6Sk76iy2sCt53/iA6PT35ZaymEaIA
        SgpHvradSSH9A
X-Received: by 2002:aa7:dcc4:: with SMTP id w4mr7953148edu.194.1634825061128;
        Thu, 21 Oct 2021 07:04:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2kZ92TuC4efqrHhw0HpNrNuli74GZHMDU0KaDpYU4g2dWRWRpksfyj75mgzN7NZu5eq21vw==
X-Received: by 2002:aa7:dcc4:: with SMTP id w4mr7953118edu.194.1634825060838;
        Thu, 21 Oct 2021 07:04:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id g2sm3001716edq.81.2021.10.21.07.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:04:20 -0700 (PDT)
Message-ID: <6b1d100b-dcc2-24d9-3424-2fbc9f855ebe@redhat.com>
Date:   Thu, 21 Oct 2021 16:04:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 17/17] x86 AMD SEV-ES: Add test cases
Content-Language: en-US
To:     Varad Gautam <varad.gautam@suse.com>,
        Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com, jroedel@suse.de,
        bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <20211004204931.1537823-18-zxwang42@gmail.com>
 <6a5a16f7-c350-a48d-c5e7-352455b57c09@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <6a5a16f7-c350-a48d-c5e7-352455b57c09@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/21 13:47, Varad Gautam wrote:
> Hi Zixuan,
> 
> On 10/4/21 10:49 PM, Zixuan Wang wrote:
>> From: Zixuan Wang <zixuanwang@google.com>
>>
>> SEV-ES introduces #VC handler for guest/host communications, e.g.,
>> accessing MSR, executing CPUID. This commit provides test cases to check
>> if SEV-ES is enabled and if rdmsr/wrmsr are handled correctly in SEV-ES.
>>
>> Signed-off-by: Zixuan Wang <zixuanwang@google.com>
>> ---
>>   x86/amd_sev.c | 30 ++++++++++++++++++++++++++++++
>>   1 file changed, 30 insertions(+)
>>
>> diff --git a/x86/amd_sev.c b/x86/amd_sev.c
>> index a07a48f..21a491c 100644
>> --- a/x86/amd_sev.c
>> +++ b/x86/amd_sev.c
>> @@ -13,6 +13,7 @@
>>   #include "libcflat.h"
>>   #include "x86/processor.h"
>>   #include "x86/amd_sev.h"
>> +#include "msr.h"
>>   
>>   #define EXIT_SUCCESS 0
>>   #define EXIT_FAILURE 1
>> @@ -55,10 +56,39 @@ static int test_sev_activation(void)
>>   	return EXIT_SUCCESS;
>>   }
>>   
>> +static int test_sev_es_activation(void)
>> +{
>> +	if (!(rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK)) {
>> +		return EXIT_FAILURE;
>> +	}
>> +
>> +	return EXIT_SUCCESS;
>> +}
>> +
>> +static int test_sev_es_msr(void)
>> +{
>> +	/*
>> +	 * With SEV-ES, rdmsr/wrmsr trigger #VC exception. If #VC is handled
>> +	 * correctly, rdmsr/wrmsr should work like without SEV-ES and not crash
>> +	 * the guest VM.
>> +	 */
>> +	u64 val = 0x1234;
>> +	wrmsr(MSR_TSC_AUX, val);
>> +	if(val != rdmsr(MSR_TSC_AUX)) {
>> +		return EXIT_FAILURE;
> 
> See note below.
> 
>> +	}
>> +
>> +	return EXIT_SUCCESS;
>> +}
>> +
>>   int main(void)
>>   {
>>   	int rtn;
>>   	rtn = test_sev_activation();
>>   	report(rtn == EXIT_SUCCESS, "SEV activation test.");
>> +	rtn = test_sev_es_activation();
>> +	report(rtn == EXIT_SUCCESS, "SEV-ES activation test.");
>> +	rtn = test_sev_es_msr();
> 
> There is nothing SEV-ES specific about this function, it only wraps
> rdmsr/wrmsr, which are supposed to generate #VC exceptions on SEV-ES.
> Since the same scenario can be covered by running the msr testcase
> as a SEV-ES guest and observing if it crashes, does testing
> rdmsr/wrmsr one more time here gain us any new information?
> 
> Also, the function gets called from main() even if
> test_sev_es_activation() failed or SEV-ES was inactive.

Agreed, this patch is still a bit rough.  However, a very simple change 
to report whether SEV-ES is enabled is a good addition to x86/amd_sev.c

Paolo

