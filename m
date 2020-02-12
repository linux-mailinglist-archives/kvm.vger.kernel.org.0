Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9CC15A802
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgBLLiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:38:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38195 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbgBLLiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 06:38:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581507529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1R9MDslW/r3AzZWZ503wB4G8/M2cmEynec0RayrkLsE=;
        b=bCj86aUFm1gzprkQK0xIYIWrtKnETVrC7v3XRv0bOEsibu9H3hBMzP98DAfmAYB+B6NXVc
        QYxkrs9tNG5YcTOvdtByxjoF9CfOWY3LDHdcXcFYHCp8CzbZqjMkH0NAupRPGz7jXrW84t
        crUKCkS9OtJk99AR+x/hlSNemYly8BU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-aq6NZIrEOq6kKzvE65n2bg-1; Wed, 12 Feb 2020 06:38:47 -0500
X-MC-Unique: aq6NZIrEOq6kKzvE65n2bg-1
Received: by mail-wr1-f71.google.com with SMTP id p8so705923wrw.5
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 03:38:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1R9MDslW/r3AzZWZ503wB4G8/M2cmEynec0RayrkLsE=;
        b=jjTClCB5feInJrYoJfolauIaMVh+ERroSDt2r7sHBVGUb7COqmzcwGEEEVUAuILMd3
         nj3Tn2I9cx27kuT8egKzl4Qr1GccF0NUaYy0J+iBP/1V0znPykV2ukBke2V1F51g//DW
         XH11XWTcz9rnQszB7tdsTSTLNkcru8TwVJp+XX3kSUidHu/n3EbRe+9EDfCD8YWgZ6yY
         WpW0GQKK9x1r7p20oZPNODdAQgmBZV7200NqVFqXhp0QKfsMrwu+bOrTeljZEF4NL4PM
         YZGq5u0MVBUI1pWN14ioI0j/nxKGrrWLfeNNuJvNHwOFQ7FmDnM+d6XWgbtdvjggLZbJ
         VkbA==
X-Gm-Message-State: APjAAAVfDN8bZpnwH5jm5kYjJhjm0KztZdOsrSi+pZ5CE6r9bGhvQ7hw
        /LWZSQfxoDv5OKWLLaN+LQBQRuPUPOJB2K0Nz9iLOFd28kH4hJt9UpBO3W0IAEXoRXAqCPdd6F0
        n67RzCk5OzLqW
X-Received: by 2002:a5d:6445:: with SMTP id d5mr14710587wrw.244.1581507526680;
        Wed, 12 Feb 2020 03:38:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqyiyKNAHEirMBzSFoYbFCwdySkFn3k/DgKaESjlbORlcaN0YvvNgu9bN+TL2Mg3ChyNa0sqLA==
X-Received: by 2002:a5d:6445:: with SMTP id d5mr14710563wrw.244.1581507526405;
        Wed, 12 Feb 2020 03:38:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id h205sm391938wmf.25.2020.02.12.03.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 03:38:45 -0800 (PST)
Subject: Re: [PATCH v4 2/3] selftests: KVM: AMD Nested test infrastructure
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-3-eric.auger@redhat.com>
 <92106709-10ff-44d3-1fe8-2c77c010913f@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0df83591-880f-df40-d160-fc847dcdf301@redhat.com>
Date:   Wed, 12 Feb 2020 12:38:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <92106709-10ff-44d3-1fe8-2c77c010913f@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/02/20 23:57, Krish Sadhukhan wrote:
>>
>> +
>> +void nested_svm_check_supported(void)
>> +{
>> +    struct kvm_cpuid_entry2 *entry =
>> +        kvm_get_supported_cpuid_entry(0x80000001);
>> +
>> +    if (!(entry->ecx & CPUID_SVM)) {
>> +        fprintf(stderr, "nested SVM not enabled, skipping test\n");
> I think a better message would be:
> 
>     "nested SVM not supported on this CPU, skipping test\n"
> 
> Also, the function should ideally return a boolean and let the callers
> print whatever they want.

It would be "not supported by KVM", which is equivalent to "not enabled"
for all purposes.

Thanks,

Paolo

