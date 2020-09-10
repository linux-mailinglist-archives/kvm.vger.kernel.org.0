Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268D626548A
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 23:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbgIJV53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 17:57:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23276 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730521AbgIJLzG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 07:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599738902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g68Ln2Ykm0AsGzDT36RNb3rZ1ltN22ArPGT5SDWCbBk=;
        b=RmpFVw6dl4Lugn6jZKwNUR8HwBxU5nIuI6aX3gz2i0GVJ2HllYDT9OYFmo7uAGP1wEzvna
        UErb7EYSbFAHJQWlArGJ+z52Ib/jjyXDJ84QEXNlhJqO2fl0dTCmXvzWwNX2HyM5QdC3om
        J3kZ2YD8atSlDm2eXgMHxYLtnQ7Acu0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-mndsKPbGNLK9taZdcBQtsw-1; Thu, 10 Sep 2020 07:36:06 -0400
X-MC-Unique: mndsKPbGNLK9taZdcBQtsw-1
Received: by mail-ed1-f69.google.com with SMTP id d13so2296564edz.18
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 04:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g68Ln2Ykm0AsGzDT36RNb3rZ1ltN22ArPGT5SDWCbBk=;
        b=pTUy9Gn7n0T9zeDVoUzZ1UOM6iIB8FEIEzzgnzSw0IWCbDEg7pIijAVP6dFE8zs0Rg
         XgXpBVPpnKP732ruQOapMnIQkqzkn36dnDxFJ/74ToMSoKrZMVEOPN1pGfnlgs9a3S6w
         yTmQuzMqOW6606Ozi9Mzta5wjRxv/DkO2b3gPHJUSF/4OMM1TFPkTDMw1sbajakwoZip
         Od+NQAwVRlLpWm5fH71XD5r5kkW8sQyV227DeyyZYUqzOGyFA4Dyk/uwy171hgZ6X2b4
         nK3HDY6QeD1bhYX4UhhhBeRCpa+x63QuSqdtXKisQf+USo/zfe0TsAEGkhcmvfxjirVW
         ISIg==
X-Gm-Message-State: AOAM532LWRmKSh/bnO4v60mopUGE8Bvdeide5sxVUdzAE6GIfFr3KPu9
        6TzCZfKtE7cc+pRFept6ujZEyXtanIuZNMqOLKZ8bNRNpXfmyJWn/ZkrnOI3y7WOdyUN5u7K0Dv
        nK6KrVRBl/9Eg
X-Received: by 2002:a05:6402:70f:: with SMTP id w15mr9029412edx.202.1599737765598;
        Thu, 10 Sep 2020 04:36:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9MRcEWHvXnnWCE/19WdyGtANc2GFua6jmtkInHUN59/gDC3dQTZo6HFVJY56Lsok1NEcSrw==
X-Received: by 2002:a05:6402:70f:: with SMTP id w15mr9029399edx.202.1599737765385;
        Thu, 10 Sep 2020 04:36:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:68f6:5b4d:4ee8:10c7? ([2001:b07:6468:f312:68f6:5b4d:4ee8:10c7])
        by smtp.gmail.com with ESMTPSA id m6sm6450319ejb.85.2020.09.10.04.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 04:36:04 -0700 (PDT)
Subject: Re: [PATCH 5/6] hw/pci-host/q35: Rename PCI 'black hole as '(memory)
 hole'
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org, Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Joel Stanley <joel@jms.id.au>, qemu-trivial@nongnu.org,
        qemu-arm@nongnu.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Richard Henderson <rth@twiddle.net>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-6-philmd@redhat.com>
 <7dbdef90-1ca6-bf27-7084-af0c716d01d9@redhat.com>
 <20200910091454.GE1083348@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b6af444a-fb0b-ed98-60df-28ea67d6abe4@redhat.com>
Date:   Thu, 10 Sep 2020 13:36:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200910091454.GE1083348@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/20 11:14, Daniel P. Berrangé wrote:
> On Thu, Sep 10, 2020 at 09:15:02AM +0200, Thomas Huth wrote:
>> On 10/09/2020 09.01, Philippe Mathieu-Daudé wrote:
>>> In order to use inclusive terminology, rename "blackhole"
>>> as "(memory)hole".
>>
>> A black hole is a well-known astronomical term, which is simply named
>> that way since it absorbes all light. I doubt that anybody could get
>> upset by this term?
> 
> In this particular case I think the change is the right thing to do
> simply because the astronomical analogy is not adding any value in
> understanding. Calling it a "memoryhole" is more descriptive in what
> is actually is.

Absolutely not.  A memory hole ("memoryhole" is not an English word)
would be easily confused with a hole in the memory map, which this is
not.  For example on x86 systems the "PCI hole" is a hole between the
end of low RAM and the bottom of the ROM that is reserved for memory
mapped devices.  The "PCI hole" is explicitly left free by board code so
that the OS can put PCI BARs in there.

These black hole MemoryRegions, instead, are present in the memory map
and their purpose is to absorbs all writes and only sends back zeros,
hiding the contents of SMRAM and TSEG from the guest.  Just like a black
hole they are "something that exists".

Therefore, both "memory hole" and "hole" as in Philippe's patch are
worse than the astronomical metaphor.

Paolo

>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>> ---
>>>  include/hw/pci-host/q35.h |  4 ++--
>>>  hw/pci-host/q35.c         | 38 +++++++++++++++++++-------------------
>>>  tests/qtest/q35-test.c    |  2 +-
>>>  3 files changed, 22 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/include/hw/pci-host/q35.h b/include/hw/pci-host/q35.h
>>> index 070305f83df..0fb90aca18b 100644
>>> --- a/include/hw/pci-host/q35.h
>>> +++ b/include/hw/pci-host/q35.h
>>> @@ -48,8 +48,8 @@ typedef struct MCHPCIState {
>>>      PAMMemoryRegion pam_regions[13];
>>>      MemoryRegion smram_region, open_high_smram;
>>>      MemoryRegion smram, low_smram, high_smram;
>>> -    MemoryRegion tseg_blackhole, tseg_window;
>>> -    MemoryRegion smbase_blackhole, smbase_window;
>>> +    MemoryRegion tseg_hole, tseg_window;
>>> +    MemoryRegion smbase_hole, smbase_window;
>>
>> Maybe rather use smbase_memhole and tseg_memhole?
>>
>>  Thomas
>>
>>
> 
> Regards,
> Daniel
> 

