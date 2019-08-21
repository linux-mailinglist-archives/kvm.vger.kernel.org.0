Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A259980FD
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 19:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfHURGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 13:06:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfHURGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 13:06:15 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 26C3881F13
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 17:06:15 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id b135so1044276wmg.1
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 10:06:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W24D/eGxTc+6J2y3EbaYEs8JehLWl+BD786rxzrTCtM=;
        b=BYiJGLmMHhHy8HzAg33Q+ZY7E68lzBiE8p7lGyAglzuPjtUXmlGDL6Af/TQ7Tnudxy
         D2MIfkxGJ1EYqy663qVPaNO5YpwM1k/CxphXlmo9lj4hBPFZeLp4I7wBZgoucw+7b6Qf
         S0rxk0mtDcPfHUGAG8U2IRdYa4/ywBj54f4wi2xFhCxJbmGb2f2PH989FvtpnWQT3mjd
         Co+OBTEEZNvqAdxlgpgqvcTlJs6B/q5VrW/QZUPOAuJmkqFgEMvLbkT+Ho2AY/KSGup7
         slPv4HgFZhdsmkS60QtcJCxvSzrOlGHW6LYvpgFCf1rgelszZycCYaMIZ8znlBu55Mps
         dS9Q==
X-Gm-Message-State: APjAAAXdcRAIxuLbM3ROjeETXddN88p7BcyfeiECVyp/mOkFPG8HNFTu
        JRKxhtYV3IUf56IMlzPntOQHGk4ocq8YzIM+iktQ9yrZwB3tgLlsVkjV90HbRIz4rCH4YH8WBLy
        gwBY13VZvCkAI
X-Received: by 2002:a05:600c:d9:: with SMTP id u25mr1230373wmm.26.1566407173632;
        Wed, 21 Aug 2019 10:06:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwuQfx1XaberyFNitFoFJZeqA2WoDq201lvGolt2CImLLnqThhrovfYHtbz1QDSuPhoyHzTsA==
X-Received: by 2002:a05:600c:d9:: with SMTP id u25mr1230352wmm.26.1566407173334;
        Wed, 21 Aug 2019 10:06:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:21b9:ff1f:a96c:9fb3? ([2001:b07:6468:f312:21b9:ff1f:a96c:9fb3])
        by smtp.gmail.com with ESMTPSA id a19sm68979449wra.2.2019.08.21.10.06.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2019 10:06:12 -0700 (PDT)
Subject: Re: [PATCH] selftests/kvm: make platform_info_test pass on AMD
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190610172255.6792-1-vkuznets@redhat.com>
 <87a7c2qz1x.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <023eb523-9767-3239-b6eb-cba3769bbd0f@redhat.com>
Date:   Wed, 21 Aug 2019 19:06:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87a7c2qz1x.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/08/19 18:10, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
>> test_msr_platform_info_disabled() generates EXIT_SHUTDOWN but VMCB state
>> is undefined after that so an attempt to launch this guest again from
>> test_msr_platform_info_enabled() fails. Reorder the tests to make test
>> pass.
>>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  tools/testing/selftests/kvm/x86_64/platform_info_test.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
>> index 40050e44ec0a..f9334bd3cce9 100644
>> --- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
>> +++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
>> @@ -99,8 +99,8 @@ int main(int argc, char *argv[])
>>  	msr_platform_info = vcpu_get_msr(vm, VCPU_ID, MSR_PLATFORM_INFO);
>>  	vcpu_set_msr(vm, VCPU_ID, MSR_PLATFORM_INFO,
>>  		msr_platform_info | MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
>> -	test_msr_platform_info_disabled(vm);
>>  	test_msr_platform_info_enabled(vm);
>> +	test_msr_platform_info_disabled(vm);
>>  	vcpu_set_msr(vm, VCPU_ID, MSR_PLATFORM_INFO, msr_platform_info);
>>  
>>  	kvm_vm_free(vm);
> 
> Ping!
> 

Queued, thanks.

Paolo
