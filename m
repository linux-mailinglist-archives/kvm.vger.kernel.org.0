Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAC4425050
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240615AbhJGJu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 05:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240569AbhJGJu0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 05:50:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633600112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cunxVlt1Iz78RvNACgdXp2hdZjh6Rnqc8OiDeqi0Afw=;
        b=bFsb46AWFwkqAVQTOJDLQD0lOtdy+Ph9N4KxNjV1XXsybTH0pBhXEn67Ca/w3VjnyVdcgP
        sc8dY1SuYBi7NsZnGgd9U70GSPQCdBlFYsMCwC1Y6rnk9fG2oNHbSRjuthGW9vtDV30/zj
        zMiQwJ6X9IGooXoLfGdbZv22kso1vYY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-LqgQv3KwOKCBijiin21TeQ-1; Thu, 07 Oct 2021 05:48:31 -0400
X-MC-Unique: LqgQv3KwOKCBijiin21TeQ-1
Received: by mail-wr1-f71.google.com with SMTP id l9-20020adfc789000000b00160111fd4e8so4246492wrg.17
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 02:48:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cunxVlt1Iz78RvNACgdXp2hdZjh6Rnqc8OiDeqi0Afw=;
        b=V3O3Ozqj793dO711Bl0+vyJCF1/0+wWZEC77FzlCA2dZCmmlNSkvgM4omLJRuL+XAh
         2itFSn42DafLU+Nfme8FjBOZrStQ5WLlVkWlnwa6+aq+dSn2++v5LvrbNchZPh00sQKD
         RG1mVtkFXFQGXxfMrntz4uBRCZx9kYUILnDcfOMI6eEc/FaR/q+uBxsUkBjjfqZrJrqa
         PgHDTZTZ13pUXanrmbzjGZRmg1ZBb8dfdNiMk2k4E8NMkvk/2zWzKZHJXNtk9eQyAH0C
         P3ivzYrPp4zrC1fG1eeTlijNEiXA0ZHDTgc9JNiUUDl+lF1kZVZIQss0gwLTawdKfaCZ
         UChQ==
X-Gm-Message-State: AOAM530okOLLvKi+/CYeTCL5N+8YK3LHKmi7uWjLDMSyHoQyYGrOuqHl
        zw9ndLxZ9aaZi3yljXleDI+yZr9+JFvf8fZVKYUkcxstPy4lNOIQmi+6DohENI02rooWcBqF6NP
        +mJB3gx9e1vSV
X-Received: by 2002:a1c:4444:: with SMTP id r65mr3526101wma.174.1633600110090;
        Thu, 07 Oct 2021 02:48:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwsVfvrhysFLOExPEjTS7BRJA24jJc7VIGiVRn1DmleziljtHhswe3AgPTDfsV2RczVf9BdQ==
X-Received: by 2002:a1c:4444:: with SMTP id r65mr3526088wma.174.1633600109941;
        Thu, 07 Oct 2021 02:48:29 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id y15sm17040052wrp.44.2021.10.07.02.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 02:48:29 -0700 (PDT)
Message-ID: <6cbbe28f-29a6-7e7d-a2df-334a47752470@redhat.com>
Date:   Thu, 7 Oct 2021 11:48:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 14/22] target/i386/sev: Move
 qmp_query_sev_attestation_report() to sev.c
Content-Language: en-US
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, Dov Murik <dovmurik@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Daniel P . Berrange" <berrange@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-15-philmd@redhat.com> <YVrP9sGcUNuRuXm6@work-vm>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <YVrP9sGcUNuRuXm6@work-vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/21 11:57, Dr. David Alan Gilbert wrote:
> * Philippe Mathieu-Daudé (philmd@redhat.com) wrote:
>> Move qmp_query_sev_attestation_report() from monitor.c to sev.c
>> and make sev_get_attestation_report() static. We don't need the
>> stub anymore, remove it.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  target/i386/sev_i386.h        |  2 --
>>  target/i386/monitor.c         |  6 ------
>>  target/i386/sev-sysemu-stub.c |  7 ++++---
>>  target/i386/sev.c             | 12 ++++++++++--
>>  4 files changed, 14 insertions(+), 13 deletions(-)

>> -SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>> -                                                 Error **errp)
>> +SevAttestationReport *qmp_query_sev_attestation_report(const char *mnonce,
>> +                                                       Error **errp)
>>  {
>> -    error_setg(errp, "SEV is not available in this QEMU");
>> +    error_setg(errp, QERR_UNSUPPORTED);
> 
> I did like that message making it clear the reason it was unsupported
> was this build, rather than lack of host support or not enabling it.

Yep, no reason to change it, besides, QERR_UNSUPPORTED is deprecated
since 2015! (commit 4629ed1e989):

/*
 * These macros will go away, please don't use in new code, and do not
 * add new ones!
 */

I suppose this is a rebase mistake, thanks for catching it!

Phil.

