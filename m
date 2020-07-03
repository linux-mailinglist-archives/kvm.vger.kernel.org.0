Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FFF213E3A
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 19:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgGCRJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 13:09:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25688 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726616AbgGCRJv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 13:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593796190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F8VYBvGQRDq6NypiWTvGyM7XQSiEhw4jOmXnEMzeenc=;
        b=QL47a4Xz+SiaKqfNEcoCo3PfpcxTTLxESjmcyljBMhOMplldiGN2tO/DLENAS40X80xzLU
        h8UnmzwuOCdZx+MYotj99r75rrP+uvJXsXmgUu3BV3kILYLjDfBXV746yGs7Cwl1myNlR/
        N2Da2CZXLcXyOYx864BttJnUZfU6Yxc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-eINGq2tLNE2GaLfKOK8Yng-1; Fri, 03 Jul 2020 13:09:48 -0400
X-MC-Unique: eINGq2tLNE2GaLfKOK8Yng-1
Received: by mail-wm1-f70.google.com with SMTP id o13so35791872wmh.9
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 10:09:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F8VYBvGQRDq6NypiWTvGyM7XQSiEhw4jOmXnEMzeenc=;
        b=Cwyj8MNZ5dnP043lF7ruFz819AkVSswd6JPH4FgyDW057NzUvuZN7vimCtO5598mnu
         P4PU8YCrUME5GUhUWQJ9udRW5Z5FOypfnFlaEOs69PzE71p7/HObaTfTkICxDkMYHFMt
         hWOaeedq6W9Z7FTctUG+6CWk8qa3Wz5CbbLhEy6QQdkMb13DhUlQbntxOx0H+ZsiGZdY
         KkPuOE7HnWYIp85c0oMuJhA/DM0XH5DrprtmQ14jNVxlcbHRmuszFa0xIANMDt2t7A1/
         /3GWkxbnIM8w/Mm0YkMLXIrj6DkdxSMOYDioNHoKEdF0YW9hIqiI7gD3wL9J3n8aQvze
         KyiQ==
X-Gm-Message-State: AOAM533N6TXgrObXfR7FiC+XXx38NgPjY3I4kJf8bxR5oCN388ZDv2g1
        ueHc/jW+lccL2aovWlYS/gvQXKM/godWWrlRS3fCB2cxn3b7gkco7JbURYOABha+UJHs2b5DKps
        cI33M6tgWWICw
X-Received: by 2002:a05:600c:2118:: with SMTP id u24mr25161016wml.133.1593796187473;
        Fri, 03 Jul 2020 10:09:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6/VQ8O65jMKdcXNBgoAvYpo0EKch0Zkev4qAbd3kToWX6xgSlm0o4qikoYlrO2WkHbCbrmQ==
X-Received: by 2002:a05:600c:2118:: with SMTP id u24mr25161010wml.133.1593796187258;
        Fri, 03 Jul 2020 10:09:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5cf9:fc14:deb7:51fc? ([2001:b07:6468:f312:5cf9:fc14:deb7:51fc])
        by smtp.gmail.com with ESMTPSA id e8sm14883523wrp.26.2020.07.03.10.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 10:09:46 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: nSVM: Check reserved bits in DR6, DR7 and EFER
 on vmrun of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
 <2fa88813-684c-f7ac-495b-68fe6cdbd5b2@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dd18bc82-0757-591a-62e9-0c701b593674@redhat.com>
Date:   Fri, 3 Jul 2020 19:09:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2fa88813-684c-f7ac-495b-68fe6cdbd5b2@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/20 00:33, Krish Sadhukhan wrote:
> Ping.
> 
> On 5/22/20 3:19 PM, Krish Sadhukhan wrote:
>> Patch# 1: Moves the check for upper 32 reserved bits of DR6 to a new
>> function.
>> Patch# 2: Adds the KVM checks for DR6[63:32] and DR7[64:32] reserved bits
>> Patch# 3: Adds kvm-unit-tests for DR6[63:32] and DR7[64:32] reserved
>> bits and
>>       reserved bits in EFER
>> Patch# 4: Removes the duplicate definition of 'vmcb' that sneaked via
>> one of
>>       my previous patches.
>>
>>
>> [PATCH 1/4] KVM: x86: Move the check for upper 32 reserved bits of
>> [PATCH 2/4] KVM: nSVM: Check that DR6[63:32] and DR7[64:32] are not
>> [PATCH 3/4] kvm-unit-tests: nSVM: Test that DR6[63:32], DR7[63:32]
>> [PATCH 4/4] kvm-unit-tests: x86: Remove duplicate instance of 'vmcb'
>>
>>   arch/x86/kvm/svm/nested.c | 3 +++
>>   arch/x86/kvm/x86.c        | 2 +-
>>   arch/x86/kvm/x86.h        | 5 +++++
>>   3 files changed, 9 insertions(+), 1 deletion(-)
>>
>> Krish Sadhukhan (2):
>>        KVM: x86: Move the check for upper 32 reserved bits of DR6 to
>> separate fun
>>        KVM: nVMX: Check that DR6[63:32] and DR7[64:32] are not set on
>> vmrun of ne
>>   x86/svm.c       |  1 -
>>   x86/svm.h       |  3 +++
>>   x86/svm_tests.c | 59
>> ++++++++++++++++++++++++++++++++++++++-------------------
>>   3 files changed, 42 insertions(+), 21 deletions(-)
>>
>> Krish Sadhukhan (2):
>>        kvm-unit-tests: nSVM: Test that DR6[63:32], DR7[63:32] and EFER
>> reserved b
>>        kvm-unit-tests: x86: Remove duplicate instance of 'vmcb'
>>
> 

Queued, thanks.

Paolo

