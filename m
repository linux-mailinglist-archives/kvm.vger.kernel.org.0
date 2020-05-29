Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CD01E78B6
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgE2Isq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:48:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37111 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbgE2Isp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 04:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590742124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1HVtHqmTPogN4uGcli8b+zN2VCCHjD1gSq3KTFjNcik=;
        b=hSXch02SzJCRZYF+ZjmN8OFdt3jznOBbQFqNyvHR8ZTSBB6SIs5la0aLJ+J3ZIEYaUV/uA
        Jj1xhSUIqSisyqMI2psCJitOmVpfY52MN+VTFJW/NZLFujunenAQv3hcnrLdAxj5XMfesf
        xK07IoYspSYF+h3FGiB1z9v/CLuLlgI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-V6I9kwqZOJKGM5ihh4otog-1; Fri, 29 May 2020 04:48:42 -0400
X-MC-Unique: V6I9kwqZOJKGM5ihh4otog-1
Received: by mail-wr1-f71.google.com with SMTP id f4so752248wrp.21
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 01:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1HVtHqmTPogN4uGcli8b+zN2VCCHjD1gSq3KTFjNcik=;
        b=nEFfNJ4wo7GBY5WMA3x0SUSQWCIIoz5mom657IU9ZoDGCWicURX4NIL0a+eS1GW2ag
         kI+4N2PIf4m/Z6CMEOjFR/580f9XaYuCOLjdSvoTlnadWAzYWA5pZx9tu/QbUaGip+no
         eso4tJrcjpLsCpJ0+StuN7c6Zh9ncPFOiu2VxUHXQzhL8hEN5CtTs2QBw5c+/niRuZZv
         9v4Jb36uKFu3yltc5N66DLYS/nEJGgyvOpDs/h8PJybFLFPM+3ZeXGyu9os6TP2ercyr
         qTjVUij2/xSIt0oOapAeIesMjsLP/flSDOOLXlE8iZUWRYmSysRjQxAN2FcA2N4rb8E3
         suPA==
X-Gm-Message-State: AOAM531kqblryMGk7Cr6orn6fvDi6mzCRe1xHSqqDXPKfJY4u8Y9orO/
        aFR8Iyllk/CVloeao5HDiGigzRQhy+gpu4KTc8r+YHrwvHUEcb3QxIoQYj0rr33GtTeQGr5U9FG
        cg7spqgIw6HBr
X-Received: by 2002:a05:6000:11ca:: with SMTP id i10mr7853107wrx.10.1590742121614;
        Fri, 29 May 2020 01:48:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyInIS95vxIwx6fpq8IWyjCt9gy2W+3pDRVYWPBirFO47dESVBVWHppaLvTF1XJ+aMC46BU0Q==
X-Received: by 2002:a05:6000:11ca:: with SMTP id i10mr7853089wrx.10.1590742121358;
        Fri, 29 May 2020 01:48:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b096:1b7:7695:e4f7? ([2001:b07:6468:f312:b096:1b7:7695:e4f7])
        by smtp.gmail.com with ESMTPSA id o20sm9287899wra.29.2020.05.29.01.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 01:48:40 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] access: disable phys-bits=36 for now
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Mohammed Gamal <mgamal@redhat.com>
References: <20200528124742.28953-1-pbonzini@redhat.com>
 <87d06o2fbb.fsf@vitty.brq.redhat.com>
 <20200528214527.GG30353@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4832b457-3b6b-b489-4364-a7f5593189a8@redhat.com>
Date:   Fri, 29 May 2020 10:48:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200528214527.GG30353@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/20 23:45, Sean Christopherson wrote:
> On Thu, May 28, 2020 at 06:29:44PM +0200, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>
>>> Support for guest-MAXPHYADDR < host-MAXPHYADDR is not upstream yet,
>>> it should not be enabled.  Otherwise, all the pde.36 and pte.36
>>> fail and the test takes so long that it times out.
>>>
>>> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>  x86/unittests.cfg | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>>> index bf0d02e..d658bc8 100644
>>> --- a/x86/unittests.cfg
>>> +++ b/x86/unittests.cfg
>>> @@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
>>>  [access]
>>>  file = access.flat
>>>  arch = x86_64
>>> -extra_params = -cpu host,phys-bits=36
>>> +extra_params = -cpu host
>>>  
>>>  [smap]
>>>  file = smap.flat
>>
>> Works both VMX and SVM, thanks!
> 
> What's the status of the "guest-MAXPHYADDR < host-MAXPHYADDR" work?

Mohammed was working on it, we should have it in 5.9.

> I ask because the AC_PTE_BIT51 and AC_PDE_BIT51 subtests are broken
> on CPUs with 52 bit PAs.  Is it worth sending a patch to temporarily
> disable those tests if MAXPHYADDR=52?
It's a QEMU bug that it does not enable host_phys_bits=on by default for
"-cpu host".  For now I'll tweak this patch to add it manually.

Paolo

