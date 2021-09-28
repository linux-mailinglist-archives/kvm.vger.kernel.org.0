Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C599441B3E5
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241523AbhI1QaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:30:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241662AbhI1QaS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 12:30:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632846518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kDCcNu7bbsfB2wNWfie8bDssTuWuW0RZ7Ty63uv/r1M=;
        b=IyMF++LbkjiviZObVv9baWi8JprswZL4OVWakmZcV2DNHAPr7wGzCWFdjomOeJjg4pr+15
        9Z76lXefjowpO3OMpAdJ7cnAXDerOusZR0ubVsAtCtcw/uJ+eICnTc59ixLoKy4OdA5urQ
        d1Ye1MEXkamh5dyUjoDaQdpjYv64Tgc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-f2ygvoFsOAevvo-S8LFSRQ-1; Tue, 28 Sep 2021 12:28:37 -0400
X-MC-Unique: f2ygvoFsOAevvo-S8LFSRQ-1
Received: by mail-wm1-f72.google.com with SMTP id a137-20020a1c7f8f000000b0030cda9c0feeso2284353wmd.7
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 09:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kDCcNu7bbsfB2wNWfie8bDssTuWuW0RZ7Ty63uv/r1M=;
        b=Zjx5N4K6v+9vhBTdOqFfvUhKOOGE3ZmXC958LaXYhWAIy+H0cw5WQd7P0bYo3zoHj4
         ZaITrM5mAVwXArmK2piFDwulOlwdlTwnLdp+FDADmP9myk+NUsWxiUFqeSrKh/iYPpTb
         mw3KwOLLyuWkSOn9Geoy5Ngw+Aycc9aXjTLlA+V32WwXPduGweiBrRnpnJ/sA/smEfIs
         zfzs4+wCSF7kqG2i3+BvDLUT7wzfGGRN8YP/62jNBy6FbJQpB0v+qAkwK+U4VodnVrkn
         LHNUiKKw56rKaIto4MEwdKEd9+XP86cJEtMgL9BbCLTKrWuCCWvUl32+KG3sOACMn+Qp
         luYA==
X-Gm-Message-State: AOAM530a+AJ611OG9COEeusDJfMT60H9LmmzFvlJAfUzWPiVFoJiHuJq
        MfU+V15xXbVwJL7beYw1H1OHtDlOuYtH1hu6BTNMB8g6rzqvICHhwt7F9HIHZDO2HKmu7d/A3yz
        KcbO0a2yGVoh4
X-Received: by 2002:a05:600c:4f4e:: with SMTP id m14mr1696434wmq.5.1632846516275;
        Tue, 28 Sep 2021 09:28:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIGMbxvDql9Inlzz0uxzDc/AHYI9ULKoRx1AnDuL2Kv0h7yV7lWnzfXvMGEKmlsCahAE96iA==
X-Received: by 2002:a05:600c:4f4e:: with SMTP id m14mr1696413wmq.5.1632846516070;
        Tue, 28 Sep 2021 09:28:36 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de. [84.155.178.189])
        by smtp.gmail.com with ESMTPSA id y11sm24343663wrg.18.2021.09.28.09.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 09:28:35 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/9] s390x: uv-host: Fence a destroy cpu
 test on z15
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, linux-s390@vger.kernel.org, seiden@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-4-frankja@linux.ibm.com>
 <8035a911-4a76-50ed-cb07-edce48abdb9c@redhat.com>
 <11d1b08d-6605-97f7-84f3-49f20f8cc0c2@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <604002cd-93e5-9495-aa87-df49d0e9a651@redhat.com>
Date:   Tue, 28 Sep 2021 18:28:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <11d1b08d-6605-97f7-84f3-49f20f8cc0c2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/09/2021 13.21, Janosch Frank wrote:
> On 9/27/21 17:26, Thomas Huth wrote:
>> On 22/09/2021 09.18, Janosch Frank wrote:
>>> Firmware will not give us the expected return code on z15 so let's
>>> fence it for the z15 machine generation.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>    lib/s390x/asm/arch_def.h | 14 ++++++++++++++
>>>    s390x/uv-host.c          | 11 +++++++----
>>>    2 files changed, 21 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>> index aa80d840..c8d2722a 100644
>>> --- a/lib/s390x/asm/arch_def.h
>>> +++ b/lib/s390x/asm/arch_def.h
>>> @@ -219,6 +219,20 @@ static inline unsigned short stap(void)
>>>        return cpu_address;
>>>    }
>>> +#define MACHINE_Z15A    0x8561
>>> +#define MACHINE_Z15B    0x8562
>>> +
>>> +static inline uint16_t get_machine_id(void)
>>> +{
>>> +    uint64_t cpuid;
>>> +
>>> +    asm volatile("stidp %0" : "=Q" (cpuid));
>>> +    cpuid = cpuid >> 16;
>>> +    cpuid &= 0xffff;

You could skip the masking line since the function returns an uint61_t anyway.

>>> +
>>> +    return cpuid;
>>> +}
>>> +
>>>    static inline int tprot(unsigned long addr)
>>>    {
>>>        int cc;
>>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>>> index 66a11160..5e351120 100644
>>> --- a/s390x/uv-host.c
>>> +++ b/s390x/uv-host.c
>>> @@ -111,6 +111,7 @@ static void test_config_destroy(void)
>>>    static void test_cpu_destroy(void)
>>>    {
>>>        int rc;
>>> +    uint16_t machineid = get_machine_id();
>>>        struct uv_cb_nodata uvcb = {
>>>            .header.len = sizeof(uvcb),
>>>            .header.cmd = UVC_CMD_DESTROY_SEC_CPU,
>>> @@ -125,10 +126,12 @@ static void test_cpu_destroy(void)
>>>               "hdr invalid length");
>>>        uvcb.header.len += 8;
>>> -    uvcb.handle += 1;
>>> -    rc = uv_call(0, (uint64_t)&uvcb);
>>> -    report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid 
>>> handle");
>>> -    uvcb.handle -= 1;
>>> +    if (machineid != MACHINE_Z15A && machineid != MACHINE_Z15B) {
>>> +        uvcb.handle += 1;
>>> +        rc = uv_call(0, (uint64_t)&uvcb);
>>> +        report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid 
>>> handle");
>>> +        uvcb.handle -= 1;
>>> +    }
>>
>> So this is a bug in the firmware? Any chance that it will still get fixed
>> for the z15? If so, would it make sense to turn this into a report_xfail()
>> instead?
>>
>>    Thomas
>>
> 
> No, a xfail will not help here.

Ok, fair, then I think the patch is fine:

Acked-by: Thomas Huth <thuth@redhat.com>


