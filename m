Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FB1340BEA
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 18:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhCRReJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 13:34:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232216AbhCRRdo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 13:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616088824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DN+8K3rKTpznELYcmJSaxwcdANuiNnp4BTO6V95gyn8=;
        b=fqIVI1fFvw5ebpzclbCfVZAszqu2hH//H2BqMCMINz7Q7yodm7FC/BBr9V+tDICTI43P4S
        FYtl2ob/qQjiDKgLVpS5XEyo2fpxfTA7lSsOKZywobXO5pqilpaMYOknLnOgQa886boxm+
        OXAdX7NTBwPwpGQN/e9q+FRCwP2J2r0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-kg7Pm9ogMpeBMugHXq6cOQ-1; Thu, 18 Mar 2021 13:33:37 -0400
X-MC-Unique: kg7Pm9ogMpeBMugHXq6cOQ-1
Received: by mail-wr1-f71.google.com with SMTP id v13so20458966wrs.21
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 10:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DN+8K3rKTpznELYcmJSaxwcdANuiNnp4BTO6V95gyn8=;
        b=dEVJYM65NjklsD0rhSFO2sE/Q/SQTPWoIxtqmwpdjXEK/YJuuILX3hOUDBl7EZ2KOW
         nw1Nzi1my6/bEkNnSMG2VcLPlmrJzRR/yUOU/mwAP1UVYrupXl1lEGK6zj5yDAPx6z3+
         EdRSrFOG5YHflJOSbZlmOU/ACqEr+tEBgVrkE9CJaTCbszNXuIsLGy/VxPOKEMN2915L
         parvv60DF0ND9L/mVf0bkYElU/i9TB5+yqdE2k3DbyFRZNANd2l+GuNaEfa1uix4cmlH
         b37tlFoazcQQvv4RDcvqSxwhCFZXxqSwSk/B+c2FXg52BX6PkUsriCFOzOmqxM37Spd0
         IN1g==
X-Gm-Message-State: AOAM530kMWV4dGn8uSW3BQH+2qwzoEyyuCshgb61/u8xzERZmHJfgHvV
        rWV9dGYMMYOV3vo0g9ZqXsM19VdxX8adlVMgYvU8KL1okiSi4V2BmZ8MTDvXdyHPzB0vIQ1iTdm
        O5yEmNjBWwK1P
X-Received: by 2002:a05:600c:4305:: with SMTP id p5mr281779wme.58.1616088816582;
        Thu, 18 Mar 2021 10:33:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4C0nnNPJfbUUcYMXpaLCD02RMObFn+Jfj9qUjWFqoZRQpPHL++lmLqOJOwel0p38NoPaT0g==
X-Received: by 2002:a05:600c:4305:: with SMTP id p5mr281769wme.58.1616088816430;
        Thu, 18 Mar 2021 10:33:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n1sm4535975wro.36.2021.03.18.10.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 10:33:35 -0700 (PDT)
To:     Andrew Jones <drjones@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210318145629.486450-1-eesposit@redhat.com>
 <20210318170316.6vah7x2ws4bimmdf@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] selftests/kvm: add get_msr_index_features
Message-ID: <c08773f1-4b84-bb19-cda8-c8ac6ffffdaf@redhat.com>
Date:   Thu, 18 Mar 2021 18:33:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210318170316.6vah7x2ws4bimmdf@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/21 18:03, Andrew Jones wrote:
>>
>>  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
>> +TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
> 
> Maybe we should give up trying to keep an alphabetic order.

FWIW I had fixed that but yeah maybe we should just give up.

>> +int main(int argc, char *argv[])
>> +{
>> +	if (kvm_check_cap(KVM_CAP_GET_MSR_FEATURES))
>> +		test_get_msr_feature();
>> +
>> +	test_get_msr_index();
> Missing return
> 
>> +}

"main" is special, it's okay not to have a return there.

Paolo

