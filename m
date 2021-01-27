Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDABE3057D7
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 11:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbhA0KID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 05:08:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235544AbhA0KFw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 05:05:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611741865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSBKskt+WQ4zYWYqyXQXePGFlrIIWEpfaYGgeOFkbk0=;
        b=VaP2zxjdSvGp9sOyMbdK4HBV3qFC1Kh7KP8XBIF1BZkJhcEGom/1INDcAj6XacPJPf32Rp
        VTcGgeCYV6rbCTo2IAghd5qALn5D/NvZFU3bxb4DtwaddP8XHAEZxMTUxc6z+PgfNOzXOy
        wWz1p7LZ+u5+dGzj9vSepZHaDk8bJYA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-ihbKx673M6qzTIaKn0QbFA-1; Wed, 27 Jan 2021 05:04:24 -0500
X-MC-Unique: ihbKx673M6qzTIaKn0QbFA-1
Received: by mail-ej1-f71.google.com with SMTP id n25so457100ejd.5
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 02:04:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rSBKskt+WQ4zYWYqyXQXePGFlrIIWEpfaYGgeOFkbk0=;
        b=IPf+LCHAdSge2P84FwVxSdOgLk1lneiS8sBF37Sdk7Sm6v57LLo0N6qVU9lFxfthC6
         sEr6SdLm9tq76G6K0mwteTMm/PPuGu3Y+1w0ZgrtiNEFf+rC1nlDfPeMIIgFsmiLuT8B
         iDaxDnqMMfIkc7z142rS9dqLV/7NAjhbz3JQg857QhO3lAUZjja+8Usnb92yk3FkklL3
         4eeccusuT8QOcq0tzIbdwjbv6nN5yp+uWHKoa5BI1G1/rec674w5o8eHg2dw6kMpqau7
         qgBQeiCFcPHFebyqAerL1egDYycuQ7RSRul+5ADZNggbJbXOEHEucmbc1LKlYJGqqM97
         N2fg==
X-Gm-Message-State: AOAM532Cca4WCAuKPRX5qPLqnk46Txcj73ikHTdiLPFu4I2EroBSIUa2
        jtArSHkzdHGUnX8DqdhzaR4m8fCFQs5XvbFQ8BY4sNEWCNJFIl9kbTqCX57C6pFXwvWC5Nc6Rf+
        EXeYq8KCl1RBi
X-Received: by 2002:a17:907:20b9:: with SMTP id pw25mr6044126ejb.262.1611741862820;
        Wed, 27 Jan 2021 02:04:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHKzXG6sD3LHVACXcNLb3uTij9dZavO0HXzoqzanjNZbuIjiIAyut5K/eZqVI2THoEtNsTXw==
X-Received: by 2002:a17:907:20b9:: with SMTP id pw25mr6044113ejb.262.1611741862684;
        Wed, 27 Jan 2021 02:04:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x5sm991191edi.35.2021.01.27.02.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 02:04:21 -0800 (PST)
Subject: Re: [RESEND PATCH 1/2] KVM: X86: Add support for the emulation of
 DR6_BUS_LOCK bit
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210108064924.1677-1-chenyi.qiang@intel.com>
 <20210108064924.1677-2-chenyi.qiang@intel.com>
 <fc29c63f-7820-078a-7d92-4a7adf828067@redhat.com>
 <5f3089a2-5a5c-a839-9ed9-471c404738a3@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6bf8fc0d-ad7d-0282-9dcc-695f16af0715@redhat.com>
Date:   Wed, 27 Jan 2021 11:04:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <5f3089a2-5a5c-a839-9ed9-471c404738a3@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/21 04:41, Xiaoyao Li wrote:
> On 1/27/2021 12:31 AM, Paolo Bonzini wrote:
>> On 08/01/21 07:49, Chenyi Qiang wrote:
>>> To avoid breaking the CPUs without bus lock detection, activate the
>>> DR6_BUS_LOCK bit (bit 11) conditionally in DR6_FIXED_1 bits.
>>>
>>> The set/clear of DR6_BUS_LOCK is similar to the DR6_RTM in DR6
>>> register. The processor clears DR6_BUS_LOCK when bus lock debug
>>> exception is generated. (For all other #DB the processor sets this bit
>>> to 1.) Software #DB handler should set this bit before returning to the
>>> interrupted task.
>>>
>>> For VM exit caused by debug exception, bit 11 of the exit qualification
>>> is set to indicate that a bus lock debug exception condition was
>>> detected. The VMM should emulate the exception by clearing bit 11 of the
>>> guest DR6.
>>
>> Please rename DR6_INIT to DR6_ACTIVE_LOW, and then a lot of changes 
>> become simpler:
> 
> Paolo,
> 
> What do you want to convey with the new name DR6_ACTIVE_LOW? To be 
> honest, the new name is confusing to me.

"Active low" means that the bit is usually 1 and goes to 0 when the 
condition (such as RTM or bus lock) happens.  For almost all those DR6 
bits the value is in fact always 1, but if they are defined in the 
future it will require no code change.

Paolo

>>> -        dr6 |= DR6_BD | DR6_RTM;
>>> +        dr6 |= DR6_BD | DR6_RTM | DR6_BUS_LOCK;
>>
>> dr6 |= DR6_BD | DR6_ACTIVE_LOW;
>>
> 
> 

