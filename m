Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72AD2BCBB2
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 17:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388732AbfIXPmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 11:42:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388373AbfIXPmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 11:42:51 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 776E669066
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 15:42:51 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id j125so223215wmj.6
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 08:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BKHTQ+dvnHZoUkU/+AFjbcU0CLIRMV5EQUTp4fv+4WY=;
        b=oN8fIx7VSYfZbU0b5VRwbyHO9NdmK4jTY8BnbEsTtT/QKx+rxjKG8nEH+WE1+dWj1G
         rrESKMnbpH5BGeHPmGrugZDHbty8S5W5AvDiwQFZhjDnfYZyknaIEc6hMBQ5LWIDCl0c
         sgF6DrV6YE2outftP1/++/mmOUUqhmFdNXuImlGbAmAFR7zEy2FUoevC3KgMANPdKOqn
         bmQI4wR8L31n5XZMpnDJbuSHZaFQBhHbwr/hzxufhxoNKRQrxceCuYh9b93D+XgmbPoV
         NJJGAP6911pT4kaxGbJziQZPuIAcGuoq8qd3ptY+iOEZlsonDnaZVPSo7U1cLtNVFfBt
         dssA==
X-Gm-Message-State: APjAAAUI1BHw7RcTPv+piszHGyl2ODt8hMJK2x+DagPBV93UnllSIWJP
        +n7FCcpyb7r/Q14Vd6WxYpdTbHNII850odcSlqZ8dniW4CGN2wRZMUL9OmEh9PEe42ZZTFaUzms
        D1Sx08Ad+ZtnG
X-Received: by 2002:a5d:4241:: with SMTP id s1mr3085835wrr.101.1569339769101;
        Tue, 24 Sep 2019 08:42:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqznFWlCrZsHnS9CLRR1lQIT4iG8xoxfvEH9cNYZ2iQ9drSG4dkXFCKIil+MepFFIQKNa8pPkg==
X-Received: by 2002:a5d:4241:: with SMTP id s1mr3085805wrr.101.1569339768810;
        Tue, 24 Sep 2019 08:42:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id f3sm1265326wrq.53.2019.09.24.08.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 08:42:47 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
To:     Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        rkrcmar@redhat.com, kvm@vger.kernel.org
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <87a7b09y5g.fsf@vitty.brq.redhat.com>
 <8A53DB10-E776-40CC-BB33-0E9A84479194@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5bcc595a-fffd-616c-9b68-881c0151fe3d@redhat.com>
Date:   Tue, 24 Sep 2019 17:42:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8A53DB10-E776-40CC-BB33-0E9A84479194@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/19 17:34, Liran Alon wrote:
> Gentle ping.

I'm going to send another pull request to Linus this week and then will
get back to this patch (and also Krish's performance counter series).

Paolo

>> On 19 Sep 2019, at 17:08, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Liran Alon <liran.alon@oracle.com> writes:
>>
>>> Hi,
>>>
>>> This patch series aims to add a vmx test to verify the functionality
>>> introduced by KVM commit:
>>> 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
>>>
>>> The test verifies the following functionality:
>>> 1) An INIT signal received when CPU is in VMX operation
>>>  is latched until it exits VMX operation.
>>> 2) If there is an INIT signal pending when CPU is in
>>>  VMX non-root mode, it result in VMExit with (reason == 3).
>>> 3) Exit from VMX non-root mode on VMExit do not clear
>>>  pending INIT signal in LAPIC.
>>> 4) When CPU exits VMX operation, pending INIT signal in
>>>  LAPIC is processed.
>>>
>>> In order to write such a complex test, the vmx tests framework was
>>> enhanced to support using VMX in non BSP CPUs. This enhancement is
>>> implemented in patches 1-7. The test itself is implemented at patch 8.
>>> This enhancement to the vmx tests framework is a bit hackish, but
>>> I believe it's OK because this functionality is rarely required by
>>> other VMX tests.
>>>
>>
>> Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>
>> Thanks!
>>
>> -- 
>> Vitaly
> 

