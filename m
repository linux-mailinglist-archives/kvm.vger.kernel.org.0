Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF5949D070
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 18:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243590AbiAZRLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 12:11:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236841AbiAZRLc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 12:11:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643217091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TntdNX4Of9iI5OjuxRo//9c3hal8k6KEzvMjsLVCKCw=;
        b=WB7frHcDAAtmDvMSMQ86/gnU3oPi1j/Bt8JFee82S36q0YM3ve/t2vcXqJzbroBZwTYRo7
        ZCAJVzBwop9pAvJAbC+M8/+eJeXhhGrjYxaKI2v7RgqwOXduUwYI8fyOnlB7QZzyz4O+1V
        6vmJ5LV1WyCUo5X/QJ/3ulNs4TlRnmQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-gQPsKEsoOoat3Azvv0dXIw-1; Wed, 26 Jan 2022 12:11:30 -0500
X-MC-Unique: gQPsKEsoOoat3Azvv0dXIw-1
Received: by mail-ej1-f70.google.com with SMTP id lb14-20020a170907784e00b006aa178894fcso1387ejc.6
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:11:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TntdNX4Of9iI5OjuxRo//9c3hal8k6KEzvMjsLVCKCw=;
        b=bdXO4CqHHmedAZEuZEdZQXUv+Fa6StUoIlBn4OjNBfHR57natxVIoIXrYdAmOiHKP8
         26EDjtilOqLVUiViQpfEMb69giR1ozg0b3mjDnzekur0hFlv+P7AhiAOtSzuspn66JRl
         /W5WxtO7mu+kxn2In5sUUWkvR9988fRXLaxRN3mrc/1cTuZFcD21hk6NHTxSOm9jaQjC
         ekwLbrhgVAnjJhVQlRoPbb0jLqDoto0M9EtCy6ILG9pdqDLYng0YxrmOS+jdSIVbOyhp
         38c903oCcEL8yUS8Yx7lSdhvceS6w04g/lCzyp9fR8wPcdtAE2HPDfQgjyHf4SkNS1yh
         iW8g==
X-Gm-Message-State: AOAM532Js++x6E7s1N9eRriEXR6RS9yCqmoIYKGVrhvIGJb1tUpADCFM
        DbZGYaQBLJucpb1aJZOrQu2GKTATyHyZGlfChT6BECbzynoF2Ml0I9UC80qvYSMhXoNLsa4VL6C
        h91q9m3lGSucc
X-Received: by 2002:a17:907:a089:: with SMTP id hu9mr1008387ejc.442.1643217088897;
        Wed, 26 Jan 2022 09:11:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgmlf9aAgSgXTJWpb4XHmg5jWPw8gUT1fG5rxd+AkVCOTpnzW4Gq2EBRRh8xzpN+5AfgJ8/w==
X-Received: by 2002:a17:907:a089:: with SMTP id hu9mr1008373ejc.442.1643217088691;
        Wed, 26 Jan 2022 09:11:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id gh14sm7608749ejb.126.2022.01.26.09.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 09:11:28 -0800 (PST)
Message-ID: <769dc0cb-e38a-4139-d0da-4019b83047cb@redhat.com>
Date:   Wed, 26 Jan 2022 18:11:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: orphan section warnings while building v5.17-rc1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     vkuznets@redhat.com, wanpengli@tencent.com, kvm@vger.kernel.org
References: <97ce2686-205b-8c46-fd24-116b094a7265@gmail.com>
 <YfF9mqcNVYLVERjl@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YfF9mqcNVYLVERjl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/22 17:58, Sean Christopherson wrote:
> On Tue, Jan 25, 2022, Pavel Skripkin wrote:
>> Hi kvm developers,
>>
>> while building newest kernel (0280e3c58f92b2fe0e8fbbdf8d386449168de4a8) with
>> mostly random config I met following warnings:
>>
>>    LD      .tmp_vmlinux.btf
>> ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
>> in section `.fixup'
>>    BTF     .btf.vmlinux.bin.o
>>    LD      .tmp_vmlinux.kallsyms1
>> ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
>> in section `.fixup'
>>    KSYMS   .tmp_vmlinux.kallsyms1.S
>>    AS      .tmp_vmlinux.kallsyms1.S
>>    LD      .tmp_vmlinux.kallsyms2
>> ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
>> in section `.fixup'
>>    KSYMS   .tmp_vmlinux.kallsyms2.S
>>    AS      .tmp_vmlinux.kallsyms2.S
>>    LD      vmlinux
>> ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
>> in section `.fixup'
> 
> Yep, xen.c has unnecessary usage of .fixup.  I'll get a patch sent.

Peter Zijlstra has already posted "x86,kvm/xen: Remove superfluous 
.fixup usage".

Paolo

